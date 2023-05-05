#include <libs\ysilib\YSI_Coding\y_hooks>

static
    account_Staff[MAX_PLAYERS];

YCMD:sc(playerid, const string: params[], help)
{
	if(!account_Staff[playerid])
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo clanovi staff-a");

	if (isnull(params))
		return SendClientMessage(playerid, -1, ""c_blue"( help ) "c_white"/sc [text]");

	static fm_string[256];

    if(account_Staff[playerid] == 1)
    {
        format(fm_string, sizeof(fm_string), ""c_lblue"[SC] Support | %s[%d]: "c_white"%s", ReturnPlayerName(playerid), playerid, params);
    }
    if(account_Staff[playerid] == 2)
    {
        format(fm_string, sizeof(fm_string), ""c_lblue"[SC] Admin | %s[%d]: "c_white"%s", ReturnPlayerName(playerid), playerid, params);
    }
    if(account_Staff[playerid] == 3)
    {
        format(fm_string, sizeof(fm_string), ""c_lblue"[SC] Director | %s[%d]: "c_white"%s", ReturnPlayerName(playerid), playerid, params);
    }
    if(account_Staff[playerid] == 4)
    {
        format(fm_string, sizeof(fm_string), ""c_lblue"[SC] Co-Owner | %s[%d]: "c_white"%s", ReturnPlayerName(playerid), playerid, params);
    }
    if(account_Staff[playerid] == 5)
    {
        format(fm_string, sizeof(fm_string), ""c_lblue"[SC] Owner | %s[%d]: "c_white"%s", ReturnPlayerName(playerid), playerid, params);
    }

	foreach (new i: Player)
		if(account_Staff[i])
			SendClientMessage(i, x_lblue, fm_string);
	
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
	print("[CMD] Staffchat Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}