if(!isServer)exitWith{};
params ["_gameLogic"];

if(isNil "DokScripts_occupyHouse")then{
	DokScripts_occupyHouse = compileFinal preprocessFileLineNumbers "DokScripts\Zen_OccupyHouse.sqf";
};

private _grp = grpNull;
private _trigger = objNull;

{
	if(_x isKindOf "Man")exitWith{_grp = group _x};
}forEach synchronizedObjects _gameLogic;

{
	if(_x isKindOf "EmptyDetector")exitWith{_trigger = _x};
}forEach synchronizedObjects _gameLogic;

if(isNull _grp)exitWith{hint "DokScripts::garrisson => Group undefined"};
if(isNull _trigger)exitWith{hint "DokScripts::garrisson => Trigger undefined"};

private _radius = (triggerArea _trigger) select 0;

[getPos _trigger, units _grp, _radius, true, true] spawn DokScripts_occupyHouse;

deleteVehicle _trigger;
deleteVehicle _gameLogic;