#include <libs\ysilib\YSI_Coding\y_hooks>

static
    account_Staff[MAX_PLAYERS];

YCMD:shelp(playerid, const string: params[], help)
{
	if(!account_Staff[playerid])
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo staff moze ovo!");

    Dialog_Show(playerid, "dialog_staffcmd", DIALOG_STYLE_MSGBOX,
	""c_lblue"Staff Commands",
	""c_lblue"Support | "c_white"/sduty /fv /cc /sveh /sc /goto /slap\n\n\
    "c_lblue"Admin | "c_white"/jetpack /nitro\n\n\
    "c_lblue"Director | "c_white"/setskin\n\n\
    "c_lblue"Co-Owner | "c_white"/createbribe\n\n\
    "c_lblue"Owner | "c_white"/setstaff",
	"U redu", "");


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
	print("[CMD] Staffhelp Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}