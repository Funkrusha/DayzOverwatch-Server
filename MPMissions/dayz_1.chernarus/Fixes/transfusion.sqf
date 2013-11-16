private ["_started","_finished","_animState","_isMedic","_id","_unit"];
_unit = (_this select 3) select 0;

player removeMagazine "ItemBloodbag";

_unit setVariable ["USEC_BloodQty",12000];

call fnc_usec_medic_removeActions;
r_action = false;

if (vehicle player == player) then {
	//not in a vehicle
	player playActionNow "Medic";
};

r_interrupt = false;
_animState = animationState player;
r_doLoop = true;
_started = false;
_finished = false;

cutText [localize "str_actions_medical_transfusion_start", "PLAIN DOWN"];
[player,_unit,"loc",rTITLETEXT,localize "str_actions_medical_transfusion_start","PLAIN DOWN"] call RE;

while {r_doLoop} do {
	_animState = animationState player;
	_isMedic = ["medic",_animState] call fnc_inString;
	if (_isMedic) then {
		_started = true;
	};
	if (_started and !_isMedic) then {
		r_doLoop = false;
		_finished = true;
	};
	if (r_interrupt) then {
		r_doLoop = false;
	};
	if (vehicle player != player) then {
		sleep 3;
		r_doLoop = false;
		_finished = true;
	};
	sleep 0.1;
};
r_doLoop = false;

if (_finished) then {

	cutText [localize "str_actions_medical_transfusion_successful", "PLAIN DOWN"];
	[player,_unit,"loc",rTITLETEXT,localize "str_actions_medical_transfusion_successful","PLAIN DOWN"] call RE;

	if ((_unit == player) or (vehicle player != player)) then {
		// p2 says No Self Healing
	} else {
		[player,250] call player_humanityChange;
	};

	//Fix by Player2 =)
	PVDZ_send = [_unit,"Transfuse",[_unit,player,12000]];
	publicVariableServer "PVDZ_send";
	
	_unit setVariable["USEC_BloodQty",12000,false];
	_unit setVariable["medForceUpdate",true,false];
	
} else {
	player addMagazine "ItemBloodbag";
	r_interrupt = false;
	[objNull, player, rSwitchMove,""] call RE;
	player playActionNow "stop";
};