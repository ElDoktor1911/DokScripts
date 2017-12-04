if(!hasInterface)exitWith{};

waitUntil {!isNil {player}};
waitUntil {player == player};

params ["_gameLogic"];

["CIVILIANWEAPON","onEachFrame",{
	if(count weapons player == 0 && !(captive player))then{
		player setCaptive true;
	};

	if(count weapons player > 0 && (captive player))then{
		player setCaptive false;
	};

}] call BIS_fnc_addStackedEventHandler;

deleteVehicle _gameLogic;