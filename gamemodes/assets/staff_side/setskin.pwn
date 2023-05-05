#include <libs\ysilib\YSI_Coding\y_hooks>

static
    account_Staff[MAX_PLAYERS],
    account_Skin[MAX_PLAYERS];

YCMD:setskin(playerid, const string: params[], help)
{
	if(account_Staff[playerid] < 3)
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo clanovi staff-a");

	static
		targetid,
		skinid;

	if(sscanf(params, "ri", targetid, skinid))
        return SendClientMessage(playerid, -1, ""c_blue"( help ) "c_white"/setskin [targetid] [skinid]");

	if(!(1 <= skinid <= 311))
		return SendClientMessage(playerid,  -1, ""c_red"( error ) "c_white"ID skina ne moze biti manji od 1 a veci od 311");


	SetPlayerSkin(targetid, skinid);

	account_Skin[targetid] = skinid;

    new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
    INI_WriteInt(File, "Skin", GetPlayerSkin(playerid));

	INI_Close( File );

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook Account_Load(const playerid, const string: name[], const string: value[]);
hook Account_Load(const playerid, const string: name[], const string: value[])
{
    INI_Int("Staff", account_Staff[playerid]);
    INI_Int("Skin", account_Skin[playerid]);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnGameModeInit()
{
	print("[CMD] Setskin Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}