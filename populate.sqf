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

_this spawn {
	params ["_gameLogic"];

	private _hc_id = call DOKSCRIPTS_fnc_getHCID;

	private _popClass = [];
	private _vehClass = [];
	private _trigger = objNull;

	{
		if(_x isKindOf "Man")then{
			_popClass pushBack (typeOf _x);
			deleteVehicle _x;
		};
		if(_x isKindOf "EmptyDetector")then{
			_trigger = _x;
		};
	}forEach synchronizedObjects _gameLogic;

	deleteVehicle _gameLogic;

	if(count _popClass ==0 && count _vehClass == 0)exitWith{hint "DokScripts::populate => class undefined"};
	if(isNull _trigger)exitWith{hint "DokScripts::populate => area undefined"};

	private _radius = (triggerArea _trigger) select 0;


	//Population
	private _houses = (getPos _trigger) nearObjects ["House", _radius];
	private _nbPopByGroup = ceil((count(_houses)*3)/20);
	private _nbGrp = count _houses;
	if(_nbGrp > 20)then{
		_nbGrp = 20;
	};
	if(_nbPopByGroup > 20)then{
		_nbPopByGroup = 20;
	};
	for "_j" from 0 to _nbGrp do {
		private _grpClass = [];
		for "_i" from 0 to _nbPopByGroup do {
			_grpClass pushBack (_popClass call BIS_fnc_selectRandom);
		};

		private _poss =  [8,_trigger] call DOKSCRIPTS_fnc_randomPosInArea;
		private _grp = [_poss select 0, civilian, _grpClass,[],[],[],[],[],180] call BIS_fnc_spawnGroup;

		_grp setBehaviour "SAFE";
		/*{
			_x disableAI "FSM";
		}forEach units _grp;*/

		{
			private _wp = _grp addWaypoint [_x,5];
			_wp setWaypointSpeed "LIMITED";
			_wp setWaypointType "MOVE";
		}forEach _poss;

		private _pos = _poss select 0;
		private _wp = _grp addWaypoint [_pos,5];
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointType "CYCLE";

		if(_hc_id > 2)then{
			_grp setGroupOwner _hc_id;
		};
		(allCurators select 0) addCuratorEditableObjects [(units _grp),true];
		sleep 0.5;
	};

	//Cars



	//Airs

	deleteVehicle _trigger;
};
