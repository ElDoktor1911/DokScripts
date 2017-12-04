if(!isServer)exitWith{};
params ["_gameLogic"];

private _hc_id = call DOKSCRIPTS_fnc_getHCID;

{
	private _grp = group leader _x;
	_grp setGroupOwner _hc_id;
}forEach synchronizedObjects _gameLogic;

deleteVehicle _gameLogic;