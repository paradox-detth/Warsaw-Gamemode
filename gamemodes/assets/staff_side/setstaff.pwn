#include <libs\ysilib\YSI_Coding\y_hooks>

static
    account_Staff[MAX_PLAYERS];

YCMD:setstaff(playerid, const string: params[], help)
{
	if(help)
    {
        SendClientMessage(playerid, x_blue, "( help ) "c_white"/setstaff [targetid] [staff level]");
        SendClientMessage(playerid, x_blue, "( help ) "c_white"| 1. Support Team | 2. Admin Team | 3. Director | 4. Co-Owner | 5. Owner |");
        return 1;
    }

	if(account_Staff[playerid] < 5)
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo owner moze ovo!");

	static
		targetid,
		level;

	if (sscanf(params, "ri", targetid, level))
		return SendClientMessage(playerid, x_blue, "( help ) "c_white"/setstaff [targetid] [staff level]");

	if (!level && !account_Staff[targetid])
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Taj igrac nije u staff-u.");

	if (level == account_Staff[targetid])
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Taj igrac je vec u staff-u.");

	account_Staff[targetid] = level;
	
	if (!level)
	{
		static fmt_string[64];

		format(fmt_string, sizeof(fmt_string), ""c_green"( info ) "c_white"%s Vas je izbacio iz staff-a.", ReturnPlayerName(playerid));
		SendClientMessage(targetid, -1, fmt_string);

		format(fmt_string, sizeof(fmt_string), ""c_green"( info ) "c_white"Izbacili ste %s iz staff-a.", ReturnPlayerName(targetid));
		SendClientMessage(playerid, -1, fmt_string);
	}
	else if(level < 0 || level > 5) return SendClientMessage(playerid, x_blue, "( help ) "c_white"Netacan staff level "c_blue"help setstaff");
	{
		static fmt_string[64];

		format(fmt_string, sizeof(fmt_string), ""c_green"( info ) "c_white"%s Vas je ubacio u staff.", ReturnPlayerName(playerid));
		SendClientMessage(targetid, -1, fmt_string);

		format(fmt_string, sizeof(fmt_string), ""c_green"( info ) "c_white"Ubacili ste %s u staff.", ReturnPlayerName(targetid));
		SendClientMessage(playerid, -1, fmt_string);
	}

    new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
    INI_WriteInt(File, "Staff", account_Staff[playerid]);
	INI_Close( File );
	
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook Account_Load(const playerid, const string: name[], const string: value[]);
hook Account_Load(const playerid, const string: name[], const string: value[])
{
    INI_Int("Staff", account_Staff[playerid]);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	new INI:File = INI_Open(Account_Path(playerid));
    INI_WriteInt(File, "Staff", account_Staff[playerid]);
    INI_Close(File);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnGameModeInit()
{
	print("[CMD] Setstaff Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}