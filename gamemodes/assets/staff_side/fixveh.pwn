#include <libs\ysilib\YSI_Coding\y_hooks>

static 
    account_Staff[MAX_PLAYERS];

YCMD:fv(playerid, params[], help)
{
	if(!account_Staff[playerid])
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo clanovi staff-a");

	new vehicleid = GetPlayerVehicleID(playerid);

    static
	    Float:Position_X, 
        Float:Position_Y, 
        Float:Position_Z, 
        Float:Position_A;

	if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Niste u vozilu!");
        
	GetPlayerPos(playerid, Position_X, Position_Y, Position_Z);
	GetVehicleZAngle(vehicleid, Position_A);
	SetVehicleZAngle(vehicleid, Position_A);
	RepairVehicle(vehicleid);
	SetVehicleHealth(vehicleid, 1000.0);
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
	print("[CMD] Fixveh Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}