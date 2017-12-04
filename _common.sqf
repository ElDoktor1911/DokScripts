
DOKSCRIPTS_fnc_loadLocalModule = [];
"DokScripts_loadClientModule" addPublicVariableEventHandler {
	if(isServer)exitWith{};
	params ["_name","_value"];

	{
		if!(_x in DOKSCRIPTS_fnc_loadLocalModule)then{
			DOKSCRIPTS_fnc_loadLocalModule pushBackUnique _x;
			[] execVM _x;
			hint format ["Loading %1 ...",_x];
		};
	}forEach _value;
};


/*DOKSCRIPTS_fnc_loadLocalModule = {
	if(!hasInterface)exitWith{};
	{
		systemChat format [":: Chargement du module %1",_x];
		[] execVM _x;
	}forEach _this;
};

DOKSCRIPTS_fnc_playerConnect = {
	params ["_owner"];
	_owner publicVariableClient "DokScripts_common";
	sleep 1;
	[] remoteExecCall ["DokScripts_common",_owner];
	sleep 1;
	DokScripts_loadClientModule remoteExec ["DOKSCRIPTS_fnc_loadLocalModule",_owner];
};

DokScripts_fnc_waitForLoadedModule = {
	private _nbModules = count DokScripts_loadClientModule;
	sleep 2;
	while {count DokScripts_loadClientModule != _nbModules} do {
		sleep 2;
	};
	DokScripts_loadClientModule remoteExec ["DOKSCRIPTS_fnc_loadLocalModule",-2];
};*/

DOKSCRIPTS_fnc_sendHintFromServer = {
	params ["_message",["_dist",0],["_pos",[]],["_radio",""]];
	if(isServer && isMultiplayer)then{
		[_message,_dist,_pos,_radio] remoteExec ["DOKSCRIPTS_fnc_sendHintFromServer",-2];
	}else{
		if((count _pos == 0 || _dist == 0) && _radio == "")then{
			hint _message;
		}else{
			{
				if(_pos distance _x < _dist && _radio == "")then{
					hint _message;
				};
				if(_radio == "All")then{
					hint _message;
				};
				if(_radio == "Air" && (vehicle player) isKindOf "Air")then{
					hint _message;
				};
			}forEach (switchableUnits + playableUnits);
		};
	};
};


DOKSCRIPTS_fnc_getHCID = {
	private _curators = allMissionObjects "HeadlessClient_F";
	private _hc_id = 2;
	if(count _curators > 0)then{
		_hc_id = owner (_curators select 0);
	};
	_hc_id
};

DOKSCRIPTS_fnc_randomPosInArea = {
	params ["_nbPos","_area"];
	private _poss = [];

	for "_i" from 0 to (_nbPos-1) do {
		_poss pushBack (_area call BIS_fnc_randomPosTrigger);
	};
	_poss
};

DOKSCRIPTS_fnc_getCargoVehicle = {
	params ["_veh"];
	private _count = 0;
	count(fullCrew [_veh, "cargo", true])
};

DOKSCRIPTS_fnc_getTurretVehicle = {
	params ["_veh"];
	private _count = 0;
	count(fullCrew [_veh, "turret", true])
};

DOKSCRIPTS_fnc_getClass = {
	params ["_side","_nb"];
	private _classTmp = [];
	private _class = [];
	{
		if(side _x == _side)then{
			_classTmp pushBackUnique (typeOf _x);
		};
	}forEach allUnits;
	_classTmp = _classTmp call BIS_fnc_arrayShuffle;
	for "_i" from 0 to (_nb-1) do {
		_class pushBack (_classTmp call BIS_fnc_selectRandom);
	};
	_class
};

DOKSCRIPTS_fnc_goBackInVehicle = {
	params ["_veh"];
	private _crew = _veh getVariable ["DOKVEHCREW",[]];
	private _units = [];
	{
		if(!isNull (_x select 0))then{
			switch(_x select 1) do {
				case "driver":{(_x select 0) assignAsDriver _veh};
				case "commander":{(_x select 0) assignAsCommander _veh};
				case "gunner":{(_x select 0) assignAsGunner _veh};
				case "cargo":{(_x select 0) assignAsCargo _veh};
				case "turret":{(_x select 0) assignAsTurret [_veh,_x select 3]};
			};
			_units pushBack (_x select 0);
		};
	}forEach _crew;
	_units orderGetIn true;
	{
		_x forceSpeed -1;
	}forEach _units;
};
