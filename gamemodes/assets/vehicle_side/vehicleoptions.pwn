#include <libs\ysilib\YSI_Coding\y_hooks>

stock IsVehicleBicycle(vehid)
{
	switch(GetVehicleModel(vehid))
	{
		case 481, 509, 510: return true;
	}
	return false;
}

hook OnVehicleSpawn(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    if (IsVehicleBicycle(GetVehicleModel(vehicleid)))
    {
        SetVehicleParamsEx(vehicleid, 1, 0, 0, doors, bonnet, boot, objective);
    }
    else 
    {
        SetVehicleParamsEx(vehicleid, 0, 0, 0, doors, bonnet, boot, objective);
    }

	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    new veh = GetPlayerVehicleID(playerid),
                engine,
                lights,
                alarm,
                doors,
                bonnet,
                boot,
                objective;

    GetVehicleParamsEx(veh, engine, lights, alarm, doors, bonnet, boot, objective);

	if (newstate == PLAYER_STATE_DRIVER) 
    {
        if(engine == VEHICLE_PARAMS_OFF)
        {   
            SendClientMessage(playerid, -1, ""c_orange"( vehicle ) "c_white"Da upalite motor koristite tipku 'Y'");
        }
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        if(newkeys & KEY_YES)
        {
            new veh = GetPlayerVehicleID(playerid),
                engine,
                lights,
                alarm,
                doors,
                bonnet,
                boot,
                objective;
            
            if(IsVehicleBicycle(GetVehicleModel(veh)))
            {
                return true;
            }
            
            GetVehicleParamsEx(veh, engine, lights, alarm, doors, bonnet, boot, objective);

            if(engine == VEHICLE_PARAMS_OFF)
            {
                SetVehicleParamsEx(veh, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
            }
            else
            {
                SetVehicleParamsEx(veh, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
            }

            new str[60];
            format(str, sizeof(str),""c_orange"( vehicle ) "c_white"%s si motor na vozilu.", (engine == VEHICLE_PARAMS_OFF) ? "Upalio" : "Ugasio");
            SendClientMessage(playerid, -1, str);

            return true;
        }
        if(newkeys & KEY_YES)
        {
            new veh = GetPlayerVehicleID(playerid),
                engine,
                lights,
                alarm,
                doors,
                bonnet,
                boot,
                objective;
            
            if(IsVehicleBicycle(GetVehicleModel(veh)))
            {
                return true;
            }
            
            GetVehicleParamsEx(veh, engine, lights, alarm, doors, bonnet, boot, objective);

            if(lights == VEHICLE_PARAMS_OFF)
            {
                SetVehicleParamsEx(veh, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
            }
            else
            {
                SetVehicleParamsEx(veh, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
            }
            new str[60];
            format(str, sizeof(str),""c_orange"( vehicle ) "c_white"%s si svetla na vozilu.", (lights == VEHICLE_PARAMS_OFF) ? "Upalio" : "Ugasio");
            SendClientMessage(playerid, -1, str);

            return true;
        }
    }
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnGameModeInit()
{
	print("[SYS] Vehicleoptions Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}