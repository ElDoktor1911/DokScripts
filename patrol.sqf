params ["_gameLogic"];

_gameLogic execVM (["DokScripts\patrolrandom.sqf","DokScripts\patrolcircle.sqf"] call BIS_fnc_selectRandom);