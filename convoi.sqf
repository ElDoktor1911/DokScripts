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

DOKCONVOI_var_CarSpeed = 15;
DOKCONVOI_var_TimeOut = 300;

DOKCONVOI_fnc_stop = {
	if(!isServer)then{
		[] remoteExec ["DOKCONVOI_fnc_stop",2];
	}else{
		{
			(driver _x) forceSpeed 0;
		}forEach DOKCONVOI_var_Cars;
	};
};

DOKCONVOI_fnc_start = {
	if(!isServer)then{
		[] remoteExec ["DOKCONVOI_fnc_start",2];
	}else{
		{
			(driver _x) forceSpeed DOKCONVOI_var_CarSpeed;
		}forEach DOKCONVOI_var_Cars;
	};
};

DOKCONVOI_fnc_vipScript = {
	params ["_grp","_vip"];
	private _vipGrp = group _vip;
	private _wp = objNull;

	while {(count (waypoints _vipGrp)) > 0} do {
		_wp = (waypoints _vipGrp) select 0;
		"Land_Money_F" createVehicle (waypointPosition _wp);
		deleteWaypoint _wp;
	};

	[_vip] joinSilent _grp;
	{
		_x setWaypointTimeout [DOKCONVOI_var_TimeOut,DOKCONVOI_var_TimeOut,DOKCONVOI_var_TimeOut];
	} forEach (waypoints _grp);

	private _veh = DOKCONVOI_var_Cars call BIS_fnc_selectRandom;
	_vip assignAsCargo _veh;
	private _pos = objNull;
	private _nextWP = [];
	[_vip] orderGetIn true;
	while{alive _vip}do{
		_nextWP = waypointPosition [_grp,(currentWaypoint _grp)];
		systemChat format ["%1",_nextWP];
		waitUntil{sleep 0.1;_vip distance _nextWP < 100};
		waitUntil{sleep 0.1;speed vehicle _vip == 0};
		[_vip] orderGetIn false;
		waitUntil{sleep 0.1;vehicle _vip == _vip};
		sleep 5;
		_pos = getPos ((_vip nearObjects ["Land_Money_F",100]) select 0);
		_vip doMove _pos;
		waitUntil {sleep 0.1;_vip distance _pos < 3};
		_vip forceSpeed 0;
		waitUntil{sleep 0.1;speed _veh != 0};
		_vip forceSpeed -1;
		call DOKCONVOI_fnc_stop;
		[_vip] orderGetIn true;
		waitUntil{sleep 0.1;vehicle _vip != _vip};
		call DOKCONVOI_fnc_start;
	};
};

if(isServer)then{
	DOKCONVOI_var_Cars = [];
	DOKCONVOI_var_DATA = [];

	private _grp = objNull;
	private _vip = objNull;
	{
		if(_x isKindOf "Car")then{
			DOKCONVOI_var_Cars pushBack _x;
		};
		if(_x isKindOf "Man")then{
			_vip = _x;
		};
	}forEach synchronizedObjects _gameLogic;

	_grp = group leader driver (DOKCONVOI_var_Cars select 0);
	DOKCONVOI_var_DATA pushBack (side _grp);

	{
		_x setWaypointFormation "COLUMN";
	 	_x setWaypointSpeed "NORMAL";
	 	_x setWaypointBehaviour "SAFE";
	 	DOKCONVOI_var_DATA pushBack (waypointPosition _x);
	} forEach (waypoints _grp);

	publicVariable "DOKCONVOI_var_DATA";

	call DOKCONVOI_fnc_stop;

	if(!isNull _vip)then{
		[_grp,_vip] spawn DOKCONVOI_fnc_vipScript;
	};
};

deleteVehicle _gameLogic;

if(!hasInterface)exitWith{};

waitUntil {!isNil "DOKCONVOI_var_DATA"};

waitUntil {!isNil {player}};
waitUntil {player == player};

DOKCONVOI_fnc_initPlayer = {
	params ["_player"];
	if(side _player == (DOKCONVOI_var_DATA select 0))then{
		_player addAction ["Convoi stop",{call DOKCONVOI_fnc_stop},nil,1.5,false,false,"",""];
		_player addAction ["Convoi start",{call DOKCONVOI_fnc_start},nil,1.5,false,false,"",""];
	};
};

[player] call DOKCONVOI_fnc_initPlayer;

player addEventHandler ["Respawn",{_this call DOKCONVOI_fnc_initPlayer}];

private _marker = objNull;
{
	if(_forEachIndex != 0)then{
		_marker = createMarkerLocal [str(_x),_x];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "mil_circle";
		_marker setMarkerColorLocal "ColorRed";
	};
}forEach DOKCONVOI_var_DATA;
