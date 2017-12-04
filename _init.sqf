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
