ElDoktor - Arma 3 Scripts

The aim of those scripts are to be functional in MP/SP mode by a simple usage without any configuration.

First, get a copy of this repo by downloading a zip clone and unzip it into your mission folder (ex: [..]\myprofile\missions\NewMission\DokScripts).

Calling a script is made by adding a GameLogic in Arma Editor and by adding this line in the init box :
[this,"ScriptName"] execVM "DokScripts\_init.sqf"

Some GameLogic/Scripts has to be synchronized with "Simple Trigger" or "Object" set on map editor.

Each script works as following :

- Civilian Vehicle<br/>
*Description* : When player enter a vehicle, side change to civilian and "can't be detected" by ennemies.<br/>
*Init box* : [this,"civilianvehicle"] execVM "DokScripts\_init.sqf"<br/>
*Note* : GameLogic has to be synchronized with one or more vehicles.

- Civilian Weapon<br/>
*Description* : When player didn't carry any weapon, side change to civilian and "can't be detected" by ennemies.<br/>
*Init box* : [this,"civilianweapon"] execVM "DokScripts\_init.sqf"<br/>
*Note* : No sync.

