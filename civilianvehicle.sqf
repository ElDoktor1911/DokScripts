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
