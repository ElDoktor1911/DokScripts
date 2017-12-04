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