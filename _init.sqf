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
