#include <libs\ysilib\YSI_Coding\y_hooks>
#include <libs\ysilib\YSI_Coding\y_timers>

static
    account_DutyTime[MAX_PLAYERS],
    account_Staff[MAX_PLAYERS];

new bool:StaffDuty[MAX_PLAYERS];

timer DutyTimer[60000](playerid)
{
	if(StaffDuty[playerid])
	{
		account_DutyTime[playerid]++;
		defer DutyTimer(playerid);
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}

YCMD:sduty(playerid, params[], help)
{
	if(!account_Staff[playerid])
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo clanovi staff-a");

	static 
        fm_string[128];
	if(StaffDuty[playerid] == false )
 	{
		SetPlayerHealth( playerid, 100);
		SetPlayerArmour( playerid, 99);
		
		StaffDuty[ playerid ] = true;
		defer DutyTimer(playerid);
		format(fm_string, sizeof(fm_string), ""c_lblue"( Duty ) "c_white"Staff %s (Duty: %d min) je sada na duznosti "c_lblue"/help", ReturnPlayerName(playerid), account_DutyTime[playerid]);
	  	SendClientMessageToAll(-1, fm_string);	
	}
	else if(StaffDuty[playerid] == true)
	{
	 	StaffDuty[playerid] = false;
		format(fm_string, sizeof(fm_string), ""c_lblue"( Duty ) "c_white"Staff %s (Duty: %d min) vise nije na duznosti", ReturnPlayerName(playerid), account_DutyTime[playerid]);
	 	SendClientMessageToAll(-1, fm_string);
	}
	new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
	INI_WriteInt(File, "DutyTime", account_DutyTime[playerid]);

	INI_Close( File );

    return true;
}

hook Account_Load(const playerid, const string: name[], const string: value[]);
hook Account_Load(const playerid, const string: name[], const string: value[])
{
    INI_Int("Staff", account_Staff[playerid]);
    INI_Int("DutyTime", account_DutyTime[playerid]);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	new INI:File = INI_Open(Account_Path(playerid));
    INI_WriteInt(File, "DutyTime", account_DutyTime[playerid]);
    INI_Close(File);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnGameModeInit()
{
	print("[CMD] Staffduty Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}