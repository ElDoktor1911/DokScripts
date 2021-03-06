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

if(isServer)then{
	params ["_gameLogic"];

	{
		_x setVariable ["CIVILIANVEHICLE",true,true];
		(allCurators select 0) removeCuratorEditableObjects [[_x],true];
	}forEach synchronizedObjects _gameLogic;

	deleteVehicle _gameLogic;
};

if(!hasInterface)exitWith{};

waitUntil {!isNil {player}};
waitUntil {player == player};

sleep 5;

["CIVILIANVEHICLE","onEachFrame",{
	if(((vehicle player) getVariable ["CIVILIANVEHICLE",false]) && !(captive player))then{
		player setCaptive true;
	};

	if(!((vehicle player) getVariable ["CIVILIANVEHICLE",false]) && (captive player))then{
		player setCaptive false;
	};

}] call BIS_fnc_addStackedEventHandler;
