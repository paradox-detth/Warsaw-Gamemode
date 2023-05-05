#include <libs\ysilib\YSI_Coding\y_hooks>
#include <libs\ysilib\YSI_Coding\y_va>

static
    account_Staff[MAX_PLAYERS];

YCMD:slap(playerid, params[], help) 
{
    if(!account_Staff[playerid]) 
        return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo clanovi staff-a");

    static 
        targetid, 
        Float:Position_X, 
        Float:Position_Y, 
        Float:Position_Z;

	if(sscanf(params,"u", targetid)) 
        return SendClientMessage(playerid, -1, ""c_blue"( help ) "c_white"/slap [targetid]." );

	if(!IsPlayerConnected(targetid)) 
        return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Taj igrac nije na serveru.");

	GetPlayerPos(targetid, Position_X, Position_Y, Position_Z );
	SetPlayerPos(targetid, Position_X, Position_Y, Position_Z+5 );

	va_SendClientMessage(playerid, -1, ""c_green"( info ) "c_white"Osamario si igraca: %s", ReturnPlayerName(targetid));
	va_SendClientMessage(targetid, -1, ""c_green"( info ) "c_white"Staff %s vas je osamario.", ReturnPlayerName(playerid));

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
	print("[CMD] Slap Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}