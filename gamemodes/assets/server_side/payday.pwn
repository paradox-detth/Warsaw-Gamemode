#include <libs\ysilib\YSI_Coding\y_hooks>
#include <libs\ysilib\YSI_Coding\y_timers>

static
    account_Score[MAX_PLAYERS],
    account_Respects[MAX_PLAYERS],
    account_Money[MAX_PLAYERS],
    account_NeededRep[MAX_PLAYERS];

forward PayDay(playerid);
public PayDay(playerid)
{
    account_Respects[playerid]++;

    static string[256];

    Dialog_Show(playerid, "dialog_payday", DIALOG_STYLE_MSGBOX, 
    ""c_green"PayDay", 
    ""c_white"Primili ste platu u iznosu od 1000$\n\
    "c_white"Imate %d/%d respekata",
    "U redu", "", account_Respects[playerid], account_NeededRep[playerid]
    );
        
    GivePlayerMoney(playerid, 1000);

    if(account_Respects[playerid] >= account_NeededRep[playerid])
    {
        account_Respects[playerid] = 0;
        account_Score[playerid]++;
        account_NeededRep[playerid] = account_Score[playerid]*3+4;
        format(string, sizeof(string), ""c_green"PAYDAY: "c_white"Cestitamo sada si level %d! Potrebno ti je %d respekata za iduci !", account_Score[playerid], account_NeededRep[playerid]);
        SendClientMessage(playerid, -1, string);
    }
    new INI:File = INI_Open(Account_Path(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File, "Level", GetPlayerScore(playerid));
    INI_WriteInt(File, "Respect", account_Respects[playerid]);
    INI_WriteInt(File, "RespetNeed", account_NeededRep[playerid]);
    INI_WriteInt(File, "Money", GetPlayerMoney(playerid));
    INI_Close(File);
    SetPlayerScore(playerid, account_Score[playerid]);

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook Account_Load(const playerid, const string: name[], const string: value[]);
hook Account_Load(const playerid, const string: name[], const string: value[])
{
    INI_Int("Level", account_Score[playerid]);
    INI_Int("Respect", account_Respects[playerid]);
	INI_Int("RespetNeed", account_NeededRep[playerid]);
    INI_Int("Money", account_Money[playerid]);

	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnGameModeInit()
{
    SetTimer("PayDay", 3600000, true);

    print("[SYS] PayDay Loaded");

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    new INI:File = INI_Open(Account_Path(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File, "Level", GetPlayerScore(playerid));
    INI_WriteInt(File, "Respect", account_Respects[playerid]);
    INI_WriteInt(File, "RespetNeed", account_NeededRep[playerid]);
    INI_WriteInt(File, "Money", GetPlayerMoney(playerid));
    INI_Close(File);

    return Y_HOOKS_CONTINUE_RETURN_1;
}