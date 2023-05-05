#include <libs\ysilib\YSI_Coding\y_hooks>

static
    account_Staff[MAX_PLAYERS];

new staff_vehicle[MAX_PLAYERS] = { INVALID_VEHICLE_ID, ... };

new Text3D:staff_vehicle_label[MAX_PLAYERS];

YCMD:sveh(playerid, params[], help)
{
	if(!account_Staff[playerid])
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo staff moze ovo!");

	new 
        Float:Position_x, 
        Float:Position_y, 
        Float:Position_z;
        
	GetPlayerPos(playerid, Position_x, Position_y, Position_z);
	if(staff_vehicle[playerid] == INVALID_VEHICLE_ID) 
	{
		if(isnull(params))
			return SendClientMessage(playerid, -1, ""c_blue"( help ) "c_white"/sveh [Model ID]");

		new modelid = strval(params);

		if(400 > modelid > 611)
			return SendClientMessage(playerid, -1,""c_blue"( help ) "c_white" ID vozila ne moze biti manji 400 i veci 611.");

		new vehicleid = staff_vehicle[playerid] = CreateVehicle(modelid, Position_x, Position_y, Position_z, 0.0, 1, 0, -1);
        new fm_string[32];
        format(fm_string, sizeof(fm_string), "[ STAFF %s ]", ReturnPlayerName(playerid));
        staff_vehicle_label[playerid] = CreateDynamic3DTextLabel(fm_string, x_blue,  Position_x, Position_y, Position_z+1.0, 20.0, INVALID_PLAYER_ID, staff_vehicle[ playerid ], 0, -1, -1, -1, 20.0, -1, 0);
		SetVehicleNumberPlate(vehicleid, "STAFF");
		PutPlayerInVehicle(playerid, vehicleid, 0);

		SendClientMessage(playerid, -1, ""c_green"( info ) "c_white"Stvorili ste vase staff vozilo");
	}
	else 
	{
		DestroyVehicle(staff_vehicle[playerid]);
		staff_vehicle[playerid] = INVALID_PLAYER_ID;
        DestroyDynamic3DTextLabel(staff_vehicle_label[playerid]);
		SendClientMessage(playerid, -1, ""c_green"( info ) "c_white"Unistili ste vase staff vozilo.");
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerConnect(playerid)
{
	staff_vehicle[playerid] = INVALID_VEHICLE_ID;
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	DestroyVehicle(staff_vehicle[playerid]);
	staff_vehicle[playerid] = INVALID_PLAYER_ID;
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnVehicleDeath(vehicleid, killerid)
{
	DestroyVehicle(staff_vehicle[vehicleid]);
	staff_vehicle[vehicleid] = INVALID_PLAYER_ID;
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook Account_Load(const playerid, const string: name[], const string: value[]);
hook Account_Load(const playerid, const string: name[], const string: value[])
{
    INI_Int("Staff", account_Staff[playerid]);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnGameModeInit()
{
	print("[CMD] Staffveh Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}