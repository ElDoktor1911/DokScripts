/*
 * Created on Mon Dec 04 2017
 *
 * The MIT License (MIT)
 * Copyright (c) 2017 ElDoktor
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial
 * portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 * TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/*
	0 : cancel snow
	1 : spare
	2 : light
	3 : medium
	4 : heavy
	5 : heavy high
*/
if(!hasInterface)exitWith{};

params [["_object",player],["_snowType",5]];
private _snow = objNull;

switch (_snowType) do {
	case 0 : {
		{
			if(typeOf _x == "#particleSource") then {
				detach _x;
				deleteVehicle _x;
			};
		}forEach (attachedObjects player);
	};
	case 1 : {
		_snow = "#particleSource" createVehicleLocal (position _object);
		_snow setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16,12,13,1], "","Billboard", 1, 7, [0,0,0], [0,0,0], 1, 0.0000001, 0.000, 1.7,[0.07],[[1,1,1,1]],[0,1], 0.2, 1.2, "", "",vehicle player];
		_snow setParticleRandom [0,[30,30,20],[0,0,0],0,0.01,[0,0,0,0.1],0,0];
		_snow setParticleCircle [0,[0,0,0]];
		_snow setDropInterval 0.0001;
	};
	case 2 : {
		_snow = "#particleSource" createVehicleLocal (position _object);
		_snow setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16,12,13,1], "","Billboard", 1, 7, [0,0,0], [0,0,0], 1, 0.0000001, 0.000, 1.7,[0.07],[[1,1,1,1]],[0,1], 0.2, 1.2, "", "",vehicle player];
		_snow setParticleRandom [0,[30,30,20],[0,0,0],0,0.01,[0,0,0,0.1],0,0];
		_snow setParticleCircle [0,[0,0,0]];
		_snow setDropInterval 0.00001;
	};
	case 3 : {
		_snow = "#particleSource" createVehicleLocal (position _object);
		_snow setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16,12,13,1], "","Billboard", 1, 7, [0,0,0], [0,0,0], 1, 0.0000001, 0.000, 1.7,[0.07],[[1,1,1,1]],[0,1], 0.2, 1.2, "", "",vehicle player];
		_snow setParticleRandom [0,[30,30,20],[0,0,0],0,0.01,[0,0,0,0.1],0,0];
		_snow setParticleCircle [0,[0,0,0]];
		_snow setDropInterval 0.000001;
	};
	case 4 : {
		_snow = "#particleSource" createVehicleLocal (position _object);
		_snow setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16,12,13,1], "","Billboard", 1, 7, [0,0,0], [0,0,0], 1, 0.0000001, 0.000, 1.7,[0.07],[[1,1,1,1]],[0,1], 0.2, 1.2, "", "",vehicle player];
		_snow setParticleRandom [0,[30,30,20],[0,0,0],0,0.01,[0,0,0,0.1],0,0];
		_snow setParticleCircle [0,[0,0,0]];
		_snow setDropInterval 0.0000001;
	};
	case 5 : {
		_snow = "#particleSource" createVehicleLocal (position _object);
		_snow setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16,12,13,1], "","Billboard", 1, 7, [0,0,0], [0,0,0], 1, 0.0000001, 0.000, 1.7,[0.07],[[1,1,1,1]],[0,1], 0.2, 1.2, "", "",vehicle player];
		_snow setParticleRandom [0,[30,30,20],[0,0,0],0,0.01,[0,0,0,0.1],0,0];
		_snow setParticleCircle [0,[0,0,0]];
		_snow setDropInterval 0.00000000001;
	};
};

if(_snowType != 0) then {
	_snow attachTo [_object,[0,0,0]];
};