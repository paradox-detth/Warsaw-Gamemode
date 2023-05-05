#include <libs\ysilib\YSI_Coding\y_hooks>

static 
    account_Staff[MAX_PLAYERS];

YCMD:cc(playerid, params[], help)
{
	if(!account_Staff[playerid])
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo clanovi staff-a");

	static 
        fm_string[72];
	for(new cc; cc < 110; cc++)
	{
		SendClientMessageToAll(-1, "");
	}

	format(fm_string, sizeof(fm_string), ""c_green"Chat je ociscen od strane staff tima");
	SendClientMessageToAll(-1, fm_string);
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
	print("[CMD] Clearchat Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}