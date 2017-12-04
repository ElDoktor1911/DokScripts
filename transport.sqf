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

params ["_gameLogic"];

HELIPORTGROUP_var_spots = [];
HELIPORTGROUP_var_pop = [];
HELIPORTGROUP_var_minDistance = 100;

HELIPORTGROUP_fnc_in = {
	params [["_player",player]];
	if(!isServer)exitWith{
		[_player] remoteExec ["HELIPORTGROUP_fnc_in",2];
	};
	_this spawn {
		params [["_player",player]];
		private _nearMans = _player nearEntities ["Man", 50];
		private _nearHouses = _player nearObjects ["House", 50];
		private _grp = grpNull;
		{
			if(!isPlayer _x && side _x == side _player)exitWith{_grp = group _x};
		}forEach _nearMans;
		if(isNull _grp && count(HELIPORTGROUP_var_pop arrayIntersect _nearHouses) == 0)exitWith{["Aucun groupe à portée !",30,getPos _player] call DOKSCRIPTS_fnc_sendHintFromServer;};
		if(isNull _grp)then{
			private _hpos = getPos ((HELIPORTGROUP_var_pop arrayIntersect  _nearHouses) select 0);
			private _cargo = [vehicle _player] call DOKSCRIPTS_fnc_getCargoVehicle;
			if(_cargo == 0)then{
				_cargo = [vehicle _player] call DOKSCRIPTS_fnc_getTurretVehicle;
			};
			private _class = [side _player,_cargo] call DOKSCRIPTS_fnc_getClass;
			if(count _class != _cargo)then{
				_grp = [_hpos, side _player, _cargo] call BIS_fnc_spawnGroup;
			}else{
				_grp = [_hpos, side _player, _class] call BIS_fnc_spawnGroup;
			};
		};
		{
			if(([vehicle _player] call DOKSCRIPTS_fnc_getCargoVehicle) != 0)then{
				_x assignAsCargo (vehicle _player);
			}else{
				_x assignAsTurret [vehicle _player,[_forEachIndex]];
			};
		}forEach units _grp;
		units _grp orderGetIn true;
		(vehicle _player) setVariable ["HELIPORTGROUP",_grp];
		waitUntil {sleep 1;(count (units _grp arrayIntersect (crew vehicle _player)))  == (count (units _grp))};
		sleep 2;
		["Groupe à bord !",30,getPos _player] call DOKSCRIPTS_fnc_sendHintFromServer;
	};
};

HELIPORTGROUP_fnc_out = {
	params [["_player",player]];
	if(!isServer)exitWith{
		[_player] remoteExec ["HELIPORTGROUP_fnc_out",2];
	};
	_this spawn {
		params [["_player",player]];
		private _grp = (vehicle _player) getVariable ["HELIPORTGROUP",grpNull];
		if(isNull _grp)exitWith{["Aucune groupe à débarquer !",30,getPos _player] call DOKSCRIPTS_fnc_sendHintFromServer};
		_grp leaveVehicle (vehicle _player);
		["Groupe en train de débarquer !",30,getPos _player] call DOKSCRIPTS_fnc_sendHintFromServer;
		waitUntil {sleep 1;(count (units _grp - (crew vehicle _player)))  == (count (units _grp))};
		sleep 2;
		private _marker = _grp call HELIPORTGROUP_fnc_findNearestWp;
		if(_marker == "")exitWith{
			["Pas de waypoint à portée ! nous allons explorer la zone.",30,getPos _player] call DOKSCRIPTS_fnc_sendHintFromServer;
			[_grp,getPos (leader _grp)] call BIS_fnc_taskAttack;
		};
		[_grp,getMarkerPos _marker] call BIS_fnc_taskAttack;
		["Go go go !",30,getPos _player] call DOKSCRIPTS_fnc_sendHintFromServer;
		(vehicle _player) setVariable ["HELIPORTGROUP",grpNull];
	};
};

HELIPORTGROUP_fnc_findNearestWp = {
	params ["_grp"];
	private _wp = "";
	{
		if((leader _grp) distance (getMarkerPos _x) < (getMarkerSize _x select 0))exitWith{_wp = _x;};
	}forEach HELIPORTGROUP_var_spots;
	_wp
};

if(isServer)then{
	{
		if(_x isKindOf "EmptyDetector")then{
			private _marker = createMarker [str(getPos _x),getPos _x];
			_marker setMarkerSize [(triggerArea _x) select 0,(triggerArea _x) select 1];
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerColor "ColorRed";
			_marker setMarkerBrush "Border";
			HELIPORTGROUP_var_spots pushBack _marker;
			deleteVehicle _x;
		};

		if(_x isKindOf "House")then{
			HELIPORTGROUP_var_pop pushBack _x;
		};
	}forEach synchronizedObjects _gameLogic;

	deleteVehicle _gameLogic;
};

if(!hasInterface)exitWith{};
if(!isNil "HELIPORTGROUP_fnc_loaded")exitWith{};

HELIPORTGROUP_fnc_loaded = true;

waitUntil {!isNil {player}};
waitUntil {player == player};

HELIPORTGROUP_fnc_initPlayer = {
	params ["_player"];
	_player addAction ["Récupérer le groupe",{call HELIPORTGROUP_fnc_in},nil,1.5,false,false,"","vehicle player != player && driver vehicle player == player && count (crew vehicle player) < 3"];
	_player addAction ["Débarquer le groupe",{call HELIPORTGROUP_fnc_out},nil,1.5,false,false,"","vehicle player != player && driver vehicle player == player && count (crew vehicle player) > 2"];
};

[player] call HELIPORTGROUP_fnc_initPlayer;

player addEventHandler ["Respawn",{_this call HELIPORTGROUP_fnc_initPlayer}];
