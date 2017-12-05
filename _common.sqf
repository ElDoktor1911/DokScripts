/*
 * Created on Mon Dec 04 2017
 *
 * The MIT License (MIT)
 * Copyright (c) 2017 ElDoktor
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial
 * portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 * TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//Système pour le chargement des scripts côté client
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

//Envoi un message à une distance _dist de la position _pos d'un objet depuis le serveur aux clients
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

//Retourne l'id du Headless Client si présent sinon 2 (le serveur)
DOKSCRIPTS_fnc_getHCID = {
	private _curators = allMissionObjects "HeadlessClient_F";
	private _hc_id = 2;
	if(count _curators > 0)then{
		_hc_id = owner (_curators select 0);
	};
	_hc_id
};

//Retourne un nombre _nbPos de positions aléatoires dans une zone donnée
DOKSCRIPTS_fnc_randomPosInArea = {
	params ["_nbPos","_area"];
	private _poss = [];

	for "_i" from 0 to (_nbPos-1) do {
		_poss pushBack (_area call BIS_fnc_randomPosTrigger);
	};
	_poss
};

//Retourne le nombre de "cargo" d'un véhicule
DOKSCRIPTS_fnc_getCargoVehicle = {
	params ["_veh"];
	private _count = 0;
	count(fullCrew [_veh, "cargo", true])
};

//Retourne le nombre de "turret" d'un véhicule
DOKSCRIPTS_fnc_getTurretVehicle = {
	params ["_veh"];
	private _count = 0;
	count(fullCrew [_veh, "turret", true])
};

//Retourne une liste de _nb class présente en jeu de la _side indiquée
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

//Supprime tous les waypoints d'un groupe
DOKSCRIPTS_fnc_deleteAllWaypoints = {
	params ["_grp"];
	while {(count (waypoints _grp)) > 0} do {
  		deleteWaypoint ((waypoints _grp) select 0);
 	};
};