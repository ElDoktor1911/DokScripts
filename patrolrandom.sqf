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

if(isNull _grp)exitWith{hint "DokScripts::patrolRandom => Group undefined"};
if(isNull _trigger)exitWith{hint "DokScripts::patrolRandom => Trigger undefined"};

_grp setCombatMode "YELLOW";
_grp setBehaviour "SAFE";

private _poss = [8,_trigger] call DOKSCRIPTS_fnc_randomPosInArea;

{
	private _wp = _grp addWaypoint [_x,5];
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointType "MOVE";
}forEach _poss;

private _pos = _poss select 0;
private _wp = _grp addWaypoint [_pos,5];
_wp setWaypointSpeed "LIMITED";
_wp setWaypointType "CYCLE";

deleteVehicle _trigger;
deleteVehicle _gameLogic;