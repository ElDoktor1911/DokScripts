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

DOKHERSE_fnc_explodeTires = {
	params ["_objs"];
	private _wheels = ["wheel_1_1_steering","wheel_2_1_steering"];
	private _grp = grpNull;
	if(typeName _objs == "OBJECT")then{
		_objs = [_objs];
	};

	{
		if(_x isKindOf "Car")then{
			_x spawn DOKHERSE_fnc_waitRepair;
			_x setHit [_wheels call BIS_fnc_selectRandom, 1];
			_grp = group leader _x;
		};
	}forEach _objs;

	if(!isNull _grp)then{
		{
			if(((assignedVehicleRole _x) select 0) == "Driver")then{
				_x forceSpeed 0;
			};
		}forEach (units _grp);
	};
};

DOKHERSE_fnc_waitRepair = {
	params ["_veh"];
	waitUntil {sleep 0.1;((_veh getHit "wheel_1_1_steering") != 1 && (_veh getHit "wheel_2_1_steering") != 1)};
	_veh setDamage 0;
};

DOKHERSE_fnc_remove = {
	params ["_herse"];
	private _trig = _herse getVariable ["TRIGGER",objNull];
	deleteVehicle _trig;
	deleteVehicle _herse;
	player addMagazine "GOS_150Rnd_762x51_Box";
};

DOKHERSE_fnc_set = {
	private _road = [(getPos player),20,[]] call BIS_fnc_nearestRoad;
	private _herse = "Land_CraneRail_01_F" createVehicle (getPos _road);
	private _roadDir = [_road, (roadsConnectedTo _road) select 0] call BIS_fnc_DirTo;
	private _trigger = createTrigger ["EmptyDetector", getPos player];
	_herse setDir (_roadDir+90);
	_herse setVectorUp surfaceNormal position _herse;
	_herse setPos [(getPos _herse) select 0,(getPos _herse) select 1,-0.25];
	_herse setVariable ["TRIGGER",_trigger,true];
	_trigger setTriggerActivation ["ANY", "PRESENT", true];
	_trigger setTriggerArea  [8, 2, _roadDir, true];
	_trigger setTriggerStatements ["this", "thisList spawn DOKHERSE_fnc_explodeTires", ""];
	_trigger setPos getPos _herse;

	[
		_herse,
		"Retirer la herse",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"_this distance _target < 10",
		"_caller distance _target < 10",
		{},
		{},
		{_this call DOKHERSE_fnc_remove},
		{},
		[],
		12,
		0,
		true,
		false
	] remoteExec ["BIS_fnc_holdActionAdd",0,_herse];

	player removeMagazine 'GOS_150Rnd_762x51_Box';
};

if(isServer)then{
	{
		if(_x isKindOf "EmptyDetector")then{
			private _road = [(getPos _x),20,[]] call BIS_fnc_nearestRoad;
			private _herse = "Land_CraneRail_01_F" createVehicle (getPos _road);
			private _roadDir = [_road, (roadsConnectedTo _road) select 0] call BIS_fnc_DirTo;
			_herse setDir (_roadDir+90);

			_herse setVectorUp surfaceNormal position _herse;
			_herse setPos [(getPos _herse) select 0,(getPos _herse) select 1,-0.25];
			_herse setVariable ["TRIGGER",_x,true];
			_x setTriggerActivation ["ANY", "PRESENT", true];
			_x setTriggerArea  [8, 2, _roadDir, true];
			_x setTriggerStatements ["this", "thisList spawn DOKHERSE_fnc_explodeTires", ""];
			_x setPos getPos _herse;

			[
				_herse,
				"Retirer la herse",
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
				"_this distance _target < 10",
				"_caller distance _target < 10",
				{},
				{},
				{_this call DOKHERSE_fnc_remove},
				{},
				[],
				12,
				0,
				true,
				false
			] remoteExec ["BIS_fnc_holdActionAdd",0,_herse];
		};
	}forEach synchronizedObjects _gameLogic;
};

deleteVehicle _gameLogic;

if(!hasInterface)exitWith{};

waitUntil {!isNil {player}};
waitUntil {player == player};

DOKHERSE_fnc_initPlayer = {
	params ["_player"];
	_player addAction ["Poser une herse",{call DOKHERSE_fnc_set},nil,1.5,false,false,"","'GOS_150Rnd_762x51_Box' in (magazines player) && vehicle player == player"];
};

[player] call DOKHERSE_fnc_initPlayer;

player addEventHandler ["Respawn",{_this call DOKHERSE_fnc_initPlayer}];

