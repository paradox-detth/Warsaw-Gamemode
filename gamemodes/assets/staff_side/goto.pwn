#include <libs\ysilib\YSI_Coding\y_hooks>

static
    account_Staff[MAX_PLAYERS];

YCMD:goto(playerid, params[],help)
{
	if(!account_Staff[playerid])
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo staff moze ovo!");

	new giveplayerid, giveplayer[MAX_PLAYER_NAME];
	new Float:plx,Float:ply,Float:plz;
	GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
	if(!sscanf(params, "u", giveplayerid))
	{	
		GetPlayerPos(giveplayerid, plx, ply, plz);
			
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, plx, ply+4, plz);
		}
		else
		{
			SetPlayerPos(playerid,plx,ply+2, plz);
		}
		SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
	}

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
	print("[CMD] Goto Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}