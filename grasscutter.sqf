if(!isServer)exitWith{};

params ["_gameLogic"];

{
	private _radius = (triggerArea _x) select 0;
	private _nearTerrainObjects = nearestTerrainObjects [getPos _x,["Tree","Bush"],_radius];
	{
		hideObjectGlobal _x;
	}forEach _nearTerrainObjects;
	deleteVehicle _x;
}forEach synchronizedObjects _gameLogic;

deleteVehicle _gameLogic;