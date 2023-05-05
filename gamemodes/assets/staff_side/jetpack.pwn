#include <libs\ysilib\YSI_Coding\y_hooks>

static
    account_Staff[MAX_PLAYERS];

YCMD:jetpack(playerid, params[], help)
{
	if(account_Staff[playerid] < 2)
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo clanovi staff-a");

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
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
	print("[CMD] Jetpack Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}