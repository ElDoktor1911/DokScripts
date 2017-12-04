if(!isServer)exitWith{};

params ["_gameLogic","_script"];

if(isNil "DokScripts_loadClientModule")then{
	DokScripts_loadClientModule = [];
	DokScripts_common = compileFinal preprocessFileLineNumbers "DokScripts\_common.sqf";
	publicVariable "DokScripts_common";
	[] remoteExecCall ["DokScripts_common",0];

	["DOKSERVER_PLAYERCONNECT", "onPlayerConnected", {
		params ["_id","_uid","_name","_jip","_owner"];

		_owner publicVariableClient "DokScripts_common";
		[] remoteExecCall ["DokScripts_common",_owner];
		_owner publicVariableClient "DokScripts_loadClientModule";

	}] call BIS_fnc_addStackedEventHandler;

};

private _sqf = format ["DokScripts\%1.sqf",toLower(_script)];

_gameLogic execVM _sqf;

DokScripts_loadClientModule pushBackUnique _sqf;
publicVariable "DokScripts_loadClientModule";

/*
switch(_script)do{
	case "grasscutter":{
		_gameLogic execVM "DokScripts\grasscutter.sqf";
	};
	case "patrol":{
		private _script = ["DokScripts\patrolRandom.sqf","DokScripts\patrolCircle.sqf"] call BIS_fnc_selectRandom;
		_gameLogic execVM _script;
	};
	case "patrolCircle":{
		_gameLogic execVM "DokScripts\patrolCircle.sqf";
	};
	case "patrolRandom":{
		_gameLogic execVM "DokScripts\patrolRandom.sqf";
	};
	case "garrisson":{
		_gameLogic execVM "DokScripts\garrisson.sqf";
	};
	case "renfort":{
		_gameLogic execVM "DokScripts\renfort.sqf";
	};
	case "transport":{
		_gameLogic execVM "DokScripts\transport.sqf";
		DokScripts_loadClientModule pushBackUnique "DokScripts\transport.sqf";
	};
	case "populate":{
		_gameLogic execVM "DokScripts\populate.sqf";
	};
	case "hcclient":{
		_gameLogic execVM "DokScripts\hcclient.sqf";
	};
	case "civilianVehicle":{
		_gameLogic execVM "DokScripts\civilianVehicle.sqf";
	};
	case "civilianWeapon":{
		_gameLogic execVM "DokScripts\civilianWeapon.sqf";
	};
	case "convoi":{
		_gameLogic execVM "DokScripts\convoi.sqf";
	};
	case "herse":{
		_gameLogic execVM "DokScripts\herse.sqf";
	};
	case "populateCars":{
		_gameLogic execVM "DokScripts\populateCars.sqf";
	};
};
*/
