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

private _grp = grpNull;
private _trigger = objNull;

{
	if(_x isKindOf "Man")exitWith{_grp = group _x};
}forEach synchronizedObjects _gameLogic;

{
	if(_x isKindOf "EmptyDetector")exitWith{_trigger = _x};
}forEach synchronizedObjects _gameLogic;

if(isNull _grp)exitWith{hint "DokScripts::patrolCircle => Group undefined"};
if(isNull _trigger)exitWith{hint "DokScripts::patrolCircle => Trigger undefined"};

private _radius = (triggerArea _trigger) select 0;

_grp setCombatMode "YELLOW";
_grp setBehaviour "SAFE";

{
	private _pos = (getPos _trigger) getPos [_radius,_x];
	private _wp = _grp addWaypoint [_pos,5];
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointType "MOVE";
}forEach [0,60,120,180,0,300,240,180];

private _pos = (getPos _trigger) getPos [_radius,0];
private _wp = _grp addWaypoint [_pos,5];
_wp setWaypointSpeed "LIMITED";
_wp setWaypointType "CYCLE";

deleteVehicle _trigger;
deleteVehicle _gameLogic;