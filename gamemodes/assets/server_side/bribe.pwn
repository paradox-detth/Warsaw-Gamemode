#include <libs\ysilib\YSI_Coding\y_hooks>

static stock const BRIBE_PATH[64] = "Bribe/%d.ini";

const
    MAX_BRIBE = 10;

new BribeActor;

static
    Float:Position_X[MAX_BRIBE],
    Float:Position_Y[MAX_BRIBE],
    Float:Position_Z[MAX_BRIBE],
    Float:Position_A[MAX_BRIBE];

static
    account_Staff[MAX_PLAYERS],
    account_Wanted[MAX_PLAYERS];

forward Bribe_Load(const bribeid, const string: name[], const string: value[]);
public Bribe_Load(const bribeid, const string: name[], const string: value[])
{
	INI_Float("PositionX",Position_X[bribeid]);
    INI_Float("PositionY",Position_Y[bribeid]);
    INI_Float("PositionZ",Position_Z[bribeid]);
    INI_Float("PositionA",Position_A[bribeid]);
 
	return Y_HOOKS_CONTINUE_RETURN_1;
}
 
public OnGameModeInit() 
{
	for(new bribeID = 0; bribeID < MAX_BRIBE; bribeID++) 
    {
        new bribepath[50];
        format(bribepath, sizeof(bribepath), BRIBE_PATH, bribeID);
        if(fexist(bribepath)) 
        {
            INI_ParseFile(bribepath, "Bribe_Load", .bExtra = true, .extra = bribeID);
           	BribeActor = CreateActor(29, Position_X[bribeID], Position_Y[bribeID], Position_Z[bribeID], Position_A[bribeID]);
           	ApplyActorAnimation( BribeActor, "DEALER", "DEALER_IDLE", 4.0, 1, 1, 1, 1, 0 );
            CreateDynamic3DTextLabel(""c_white"Da podmitite policajca kucajte\n"c_server"[ /bribe ]", -1, Position_X[bribeID], Position_Y[bribeID], Position_Z[bribeID], 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0, -1, 0);
           	SetActorInvulnerable(bribeID, true);
		}
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}
 
 
YCMD:createbribe(playerid, params[], help) 
{
    if(account_Staff[playerid] < 4)
		return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Samo clanovi staff-a");

    for(new bribeid = 0; bribeid < MAX_BRIBE; bribeid++) {
        new bribe_file[50];
	    format(bribe_file, sizeof(bribe_file), BRIBE_PATH, bribeid);
		if(!fexist(bribe_file)) {
	        new Float:x, Float:y, Float:z, Float:rot;
	        GetPlayerPos(playerid, x, y, z);
	        GetPlayerFacingAngle(playerid, rot);
	        Position_X[bribeid] = x; Position_Y[bribeid] = y; Position_Z[bribeid] = z; Position_A[bribeid] = rot;
	        BribeActor = CreateActor(29, Position_X[bribeid], Position_Y[bribeid], Position_Z[bribeid], Position_A[bribeid]);

            new INI:File = INI_Open(bribe_file);
            INI_WriteFloat( File, "PositionX",Position_X[bribeid]);
            INI_WriteFloat( File, "PositionY",Position_Y[bribeid]);
            INI_WriteFloat( File, "PositionZ",Position_Z[bribeid]);
            INI_WriteFloat( File, "PositionA",Position_A[bribeid]);
            INI_Close(File);
	        SetActorInvulnerable(bribeid, true);
	        break;
        }
    }

	return Y_HOOKS_CONTINUE_RETURN_1;
}

YCMD:bribe(playerid, params[], help) 
{
    for(new bribeid = 0; bribeid < MAX_BRIBE; bribeid++)
    {
        if(!IsPlayerInRangeOfPoint(playerid, 2.0, Position_X[bribeid], Position_Y[bribeid], Position_Z[bribeid])) 
            return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white "Nisi u blizini bribe policajca");

        if(!account_Wanted[playerid]) 
            return SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Nemas wanted level");

        new price = account_Wanted[playerid] * 2000;

        Dialog_Show(playerid, "dialog_bribe", DIALOG_STYLE_MSGBOX, 
        ""c_server"Bribe", 
        "Da li si siguran da zelis platiti %d$ za ciscenje wanted levela?", 
        "Da", "Ne", price
        );
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}   

hook Account_Load(const playerid, const string: name[], const string: value[]);
hook Account_Load(const playerid, const string: name[], const string: value[])
{
    INI_Int("Staff", account_Staff[playerid]);
    INI_Int("Wanted Level", account_Wanted[playerid]);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnGameModeInit()
{
	print("[SYS] Bribe Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}

Dialog: dialog_bribe(const playerid, response, listitem, string: inputtext[])
{
    if(!response) return SendClientMessage(playerid, -1, ""c_green"( info ) "c_white"Odustao si od ciscenja wanted levela!");
    if(response) 
    {
        new price = account_Wanted[playerid] * 2000;
        if(GetPlayerMoney(playerid) < price) 
            return va_SendClientMessage(playerid, -1, ""c_red"( error ) "c_white"Nemas dovoljno novca %d$", price);

        GivePlayerMoney(playerid, -price);
        account_Wanted[playerid] = 0;
        SetPlayerWantedLevel(playerid, 0);

        new INI:File = INI_Open(Account_Path(playerid));
        INI_WriteFloat(File, "Wanted Level", account_Wanted[playerid]);
        INI_Close(File);

        va_SendClientMessage(playerid, -1, ""c_green"( info ) "c_white"Platio si %d$ za ciscenje wanted levela", price);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}
