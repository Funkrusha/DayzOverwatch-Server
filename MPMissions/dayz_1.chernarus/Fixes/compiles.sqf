if (!isDedicated) then {
	// remove part from vehicles
	fnc_usec_selfActions = compile preprocessFileLineNumbers "Fixes\fn_selfActions.sqf";
	// transfusions bugfix
	fnc_usec_damageActions = compile preprocessFileLineNumbers "Fixes\fn_damageActions.sqf";
};