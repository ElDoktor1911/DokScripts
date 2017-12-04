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

if(isNil "renfort_grps")then{
	renfort_grps = [];
};
private _trigger = objNull;

if(count renfort_grps == 0)then{
	renfort_addEvent = {
		{
			_x addEventHandler ["Fired",{_this spawn renfort_call}];
		}forEach allUnits - (switchableUnits + playableUnits);
	};
	renfort_call = {
		params ["_unit"];
		if((group _unit) getVariable ["RENFORT_IN_PROGRESS",false])exitWith{};
		(group _unit) setVariable ["RENFORT_IN_PROGRESS",true];
		private _marker = "";
		private _grp = grpNull;
		renfort_grps = renfort_grps call BIS_fnc_arrayShuffle;
		{
			private _m = _x getVariable ["RENFORT_AREA",""];
			if((getPos _unit) inArea _m && side _unit == side _x)exitWith{_marker = _m;_grp = _x};
		}forEach renfort_grps;

		if(isNull _grp)exitWith{};
		if(_marker == "")exitWith{};

		//Cas mortar
		if((vehicle leader _grp) isKindOf "StaticMortar")exitWith{[_unit,_grp] spawn renfort_mortar};

		renfort_grps = renfort_grps - [_grp];
		(group _unit) spawn renfort_removeCall;


		private _dir = _unit getRelDir (leader _grp);
		private _pos = _unit getRelPos [500,_dir];

		while {(count (waypoints _grp)) > 0} do{
  			deleteWaypoint ((waypoints _grp) select 0);
 		};

		_grp setVariable ["RENFORT_TO_GRP",(group _unit)];
 		(leader _grp) spawn renfort_grp;
	};
	renfort_grp = {
		params ["_leader"];
		private _grp = group _leader;
		while {(count (waypoints _grp)) > 0} do{
  			deleteWaypoint ((waypoints _grp) select 0);
 		};
 		private _oGrp = _grp getVariable ["RENFORT_TO_GRP",grpNull];
 		if(isNull _oGrp)exitWith{};
 		(units _grp) joinSilent _oGrp;
	};
	renfort_removeCall = {
		params ["_grp",["_time",180]];
		sleep _time;
		_grp setVariable ["RENFORT_IN_PROGRESS",false];
	};
	renfort_mortar = {
		params ["_unit","_grp"];
		private _target = assignedTarget _unit;
		if(isNull _target)exitWith{};
		[(group _unit),60] spawn renfort_removeCall;
		sleep 60;
		(gunner (vehicle leader _grp)) doArtilleryFire [getPos _target, "8Rnd_82mm_Mo_shells", (floor (random 3))+1];
	};
	0 spawn renfort_addEvent;
};

{
	if(_x isKindOf "EmptyDetector")exitWith{_trigger = _x};
}forEach synchronizedObjects _gameLogic;

if(isNull _trigger)exitWith{hint "DokScripts::renfort => Trigger undefined"};

private _ta = triggerArea _trigger;

private _marker = createMarkerLocal [str(getPos _trigger),getPos _trigger];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [_ta select 0,_ta select 1];

{
	if(_x isKindOf "Man" || _x isKindOf "Car" || _x isKindOf "Tank" || _x isKindOf "Air" || _x isKindOf "StaticMortar")then{
		renfort_grps pushBack (group leader _x);
		(group leader _x) setVariable ["RENFORT_AREA",_marker];
	};
}forEach synchronizedObjects _gameLogic;

deleteVehicle _trigger;
deleteVehicle _gameLogic;
