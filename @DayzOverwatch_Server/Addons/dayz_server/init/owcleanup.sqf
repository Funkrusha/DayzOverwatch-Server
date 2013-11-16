// Dayz Overwatch cleanup script

if (isServer) then {
	[] spawn
	{
		waitUntil {!(isNil "sm_done")};

		_lastUpdate = diag_tickTime;
		_lastZombieCheck = diag_tickTime;
		_lastNeedUpdate = diag_tickTime;
		_lastDeadCheck = diag_tickTime;
		_lastFPSCleanup = diag_tickTime;
		_lastItemCheck = diag_tickTime;
		_allDead = []; //temp array used for marking age of dead bodies

		while {true} do {
			if (((diag_tickTime - _lastUpdate) > 600)) then
			{
				_lastUpdate = diag_tickTime;
				private ["_date","_dateNum","_diff","_result","_outcome"];
				_result = "CHILD:307:" call server_hiveReadWrite;
				_outcome = _result select 0;
				if(_outcome == "PASS") then {
					_date = _result select 1; 
					_year = _date select 0;
					_month = _date select 1;
					_day = _date select 2;
					_hour = _date select 3;
					_minute = _date select 4;
		
					//Force full moon nights
					_date = [2013,8,3,_hour,_minute];
					setDate _date;
					
					dayzSetDate = _date;
					publicVariable "dayzSetDate";
				
					PVDZE_plr_SetDate = _date;
					publicVariable "PVDZE_plr_SetDate";

				
					diag_log ("HIVE: Local Time set to " + str(_date));
				};
			};
			if ((count needUpdate_objects) > 0 && (diag_tickTime -_lastNeedUpdate>40)) then
			{
				_lastNeedUpdate = diag_tickTime;
				{
					needUpdate_objects = needUpdate_objects - [_x];
					[_x,"all", true] call server_updateObject;

				} forEach needUpdate_objects;
			};
			if ((diag_tickTime - _lastDeadCheck) > 1800) then {
				_lastDeadCheck = diag_tickTime;
				private ["_modeldex","_myGroupX"];
				
				//Cleanup Dead Bodies
				{
					_modeldex = typeOf _x;
					_myGroupX = group _x;

					_x removeAllMPEventHandlers "mpkilled";
					_x removeAllMPEventHandlers "mphit";
					_x removeAllMPEventHandlers "mprespawn";
					_x removeAllEventHandlers "FiredNear";
					_x removeAllEventHandlers "HandleDamage";
					_x removeAllEventHandlers "Killed";
					_x removeAllEventHandlers "Fired";
					_x removeAllEventHandlers "GetOut";
					_x removeAllEventHandlers "Local";
					clearVehicleInit _x;
					deleteVehicle _x;
					deleteGroup _myGroupX;
					_x = nil;			
				} forEach _allDead;
				_allDead = [] + allDead;
			};
			if ((diag_tickTime - _lastZombieCheck) > 360) then {
				_lastZombieCheck = diag_tickTime;
				{
					if (local _x) then {
						_x enableSimulation false;
						_myGroupX = group _x;
						_x removeAllMPEventHandlers "mpkilled";
						_x removeAllMPEventHandlers "mphit";
						_x removeAllMPEventHandlers "mprespawn";
						_x removeAllEventHandlers "FiredNear";
						_x removeAllEventHandlers "HandleDamage";
						_x removeAllEventHandlers "Killed";
						_x removeAllEventHandlers "Fired";
						_x removeAllEventHandlers "GetOut";
						_x removeAllEventHandlers "Local";
						clearVehicleInit _x;
						deleteVehicle _x;
						deleteGroup _myGroupX;
						_x = nil;
					};
				} forEach allMissionObjects "Animal";

				//Delete Hacker Boxes
				 /*{
					 if (((count ((getWeaponCargo _x) select 1))+(count ((getMagazineCargo _x) select 1))) > 80) then {
						clearVehicleInit _x;
						deleteVehicle _x;
						_x = nil;
					 };
				 } forEach allMissionObjects "All";
				 */

				//Disable Zombie Server Side Simulation
				{
					if (local _x) then {
						_x enableSimulation false;
						_myGroupX = group _x;
						 _x removeAllMPEventHandlers "mpkilled";
						_x removeAllMPEventHandlers "mphit";
						_x removeAllMPEventHandlers "mprespawn";
						_x removeAllEventHandlers "FiredNear";
						_x removeAllEventHandlers "HandleDamage";
						_x removeAllEventHandlers "Killed";
						_x removeAllEventHandlers "Fired";
						_x removeAllEventHandlers "GetOut";
						_x removeAllEventHandlers "Local";
						clearVehicleInit _x;
						deleteVehicle _x;
						deleteGroup _myGroupX;
						_x = nil;
					};

				} forEach entities "zZombie_Base";
			};
			
			if (((diag_tickTime - _lastItemCheck) > 450)) then
			{
				_lastItemCheck = diag_tickTime;
				private ["_delQty","_keep","_nearby","_myGroupX","_delQtyAnimalR","_delQtyAnimal","_xtypeanimal","_missionObjs","_qty","_animaltype"];

				//Server Cleanup
				_missionObjs = allMissionObjects "ReammoBox";
				_qty = count _missionObjs;
				{
					if ((local _x) or (_qty > 750)) then {
						_keep = _x getVariable ["permaLoot",false];
								_nearby = {isPlayer _x} count (_x nearEntities [["CAManBase"], 100]);
						if ( (!_keep) && (_nearby==0) ) then {
							deleteVehicle _x;
							_x = nil;
						};
					};
				} forEach _missionObjs;
			};

			//Player Groups Cleanup
			{
				if (count units _x==0) then {
					deleteGroup _x;
					_x = nil;
				};
			} forEach allGroups;
			
			{
				_myGroupX = group _x;
				_x removeAllMPEventHandlers "mpkilled";
				_x removeAllMPEventHandlers "mphit";
				_x removeAllMPEventHandlers "mprespawn";
				_x removeAllEventHandlers "FiredNear";
				_x removeAllEventHandlers "HandleDamage";
				_x removeAllEventHandlers "Killed";
				_x removeAllEventHandlers "Fired";
				_x removeAllEventHandlers "GetOut";
				_x removeAllEventHandlers "Local";
				clearVehicleInit _x;
				deleteVehicle _x;
				deleteGroup _myGroupX;
				_x = nil;
			} forEach entities "Seagull";
			sleep 5;
		};
	};
};
