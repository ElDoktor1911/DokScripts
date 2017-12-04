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

if(!isServer)exitWith{};
params ["_gameLogic"];

POPCARS = [];
{
	if(_x isKindOf "Car")then{
		POPCARS pushBack (typeOf _x);
		{
			deleteVehicle _x;
		}forEach crew _x;
		deleteVehicle _x;
	};
}forEach synchronizedObjects _gameLogic;

deleteVehicle _gameLogic;

sleep 5;

for "_i" from 0 to 80 do { // 80 vehicles (max 144 if no civilian group)
	private _rnd = [nil, ["water"]] call BIS_fnc_randomPos;
	private _road =  [_rnd,1000,[]] call BIS_fnc_nearestRoad;
	private _veh = ([getPos _road, 180, POPCARS call BIS_fnc_selectRandom, civilian] call bis_fnc_spawnvehicle) select 0;
	_veh allowDamage false;
	(driver _veh) forceSpeed 19;
	private _grp = group driver _veh;
	private _wp = _grp addWaypoint [getPos _road,5];
	_wp setWaypointType "MOVE";
	for "_j" from 0 to 4 do {
		_rnd = [nil, ["water"]] call BIS_fnc_randomPos;
		_road =  [_rnd,1000,[]] call BIS_fnc_nearestRoad;
		while{count ((getPos _road)-[0]) == 0}do{
			_rnd = [nil, ["water"]] call BIS_fnc_randomPos;
			_road =  [_rnd,1000,[]] call BIS_fnc_nearestRoad;
		};
		_wp = _grp addWaypoint [getPos _road,5];
		_wp setWaypointType "MOVE";
	};
	_wp = _grp addWaypoint [getPos _road,5];
	_wp setWaypointType "CYCLE";
	if(!isMultiplayer)then{
		(allCurators select 0) addCuratorEditableObjects [[_veh],true];
	};
	private _hc_id = call DOKSCRIPTS_fnc_getHCID;
	if(_hc_id > 2)then{
		_grp setGroupOwner _hc_id;
	};
	sleep 0.2;
};

