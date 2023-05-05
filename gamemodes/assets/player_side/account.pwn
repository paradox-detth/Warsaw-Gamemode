#include <libs\ysilib\YSI_Storage\y_ini>
#include <libs\ysilib\YSI_Coding\y_hooks>

static stock const USER_PATH[64] = "/Users/%s.ini";
 
const MAX_PASSWORD_LENGTH = 64;
const MIN_PASSWORD_LENGTH = 6;
const MAX_LOGIN_ATTEMPTS = 	3;
 
enum
{
	TYPE_REGISTER = 1,
    TYPE_LOGIN
};
 
static  
    account_Password[MAX_PLAYERS][MAX_PASSWORD_LENGTH],
    account_Sex[MAX_PLAYERS][2],
    account_Score[MAX_PLAYERS],
	account_Skin[MAX_PLAYERS],
    account_Money[MAX_PLAYERS],
    account_Ages[MAX_PLAYERS],
    account_LoginAttempts[MAX_PLAYERS];
 
forward Account_Load(const playerid, const string: name[], const string: value[]);
public Account_Load(const playerid, const string: name[], const string: value[])
{
	INI_String("Password", account_Password[playerid]);
	INI_String("Sex", account_Sex[playerid]);
	INI_Int("Level", account_Score[playerid]);
	INI_Int("Skin", account_Skin[playerid]);
	INI_Int("Money", account_Money[playerid]);
 
	return 1;
}
 
hook OnPlayerConnect(playerid)
{
	if(fexist(Account_Path(playerid)))
	{
		INI_ParseFile(Account_Path(playerid), "Account_Load", true, true, playerid);
		Dialog_Show(playerid, "dialog_login", DIALOG_STYLE_PASSWORD,
			"Prijavljivanje",
			"%s, unesite Vasu tacnu lozinku: ",
			"Potvrdi", "Izlaz", ReturnPlayerName(playerid)
		);
 
		return Y_HOOKS_CONTINUE_RETURN_1;
	}
 
	Dialog_Show(playerid, "dialog_regpassword", DIALOG_STYLE_INPUT,
		"Registracija",
		"%s, unesite Vasu zeljenu lozinku: ",
		"Potvrdi", "Izlaz", ReturnPlayerName(playerid)
	);
 
	return Y_HOOKS_CONTINUE_RETURN_1;
}
 
hook OnPlayerDisconnect(playerid, reason)
{
	new INI:File = INI_Open(Account_Path(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File, "Level",GetPlayerScore(playerid));
    INI_WriteInt(File, "Skin",GetPlayerSkin(playerid));
    INI_WriteInt(File, "Money", GetPlayerMoney(playerid));
    INI_Close(File);
 
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnGameModeInit()
{
	print("[SYS] Account Loaded");
	return Y_HOOKS_CONTINUE_RETURN_1;
}

stock Account_Path(const playerid)
{
	new tmp_fmt[64];
	format(tmp_fmt, sizeof(tmp_fmt), USER_PATH, ReturnPlayerName(playerid));
 
	return tmp_fmt;
}
 
timer Spawn_Player[100](playerid, type)
{
	if (type == TYPE_REGISTER)
		{
			SendClientMessage(playerid, -1, ""c_server"( Warsaw ) "c_white"Uspesno ste se registrovali!");
			SetSpawnInfo(playerid, 0, account_Skin[playerid],
				1476.1212,-2286.8179,13.5624,0.4520,
				0, 0, 0, 0, 0, 0
			);
			SpawnPlayer(playerid);
 
			SetPlayerScore(playerid, account_Score[playerid]);
			GivePlayerMoney(playerid, account_Money[playerid]);
			SetPlayerSkin(playerid, account_Skin[playerid]);
		}
 
		else if (type == TYPE_LOGIN)
		{
			SendClientMessage(playerid, x_server,"( Warsaw ) "c_white"Uspesno ste se prijavli!");
			SetSpawnInfo(playerid, 0, account_Skin[playerid],
				1476.1212,-2286.8179,13.5624,0.4520,
				0, 0, 0, 0, 0, 0
			);
			SpawnPlayer(playerid);
 
			SetPlayerScore(playerid, account_Score[playerid]);
			GivePlayerMoney(playerid, account_Money[playerid]);
			SetPlayerSkin(playerid, account_Skin[playerid]);
		}
 
}
 
Dialog: dialog_regpassword(playerid, response, listitem, string: inputtext[])
{
	if (!response)
		return Kick(playerid);
 
	if (!(MIN_PASSWORD_LENGTH <= strlen(inputtext) <= MAX_PASSWORD_LENGTH))
		return Dialog_Show(playerid, "dialog_regpassword", DIALOG_STYLE_INPUT,
			"Registracija",
			"%s, unesite Vasu zeljenu lozinku: ",
			"Potvrdi", "Izlaz", ReturnPlayerName(playerid)
		);
 
	strcopy(account_Password[playerid], inputtext);
 
	Dialog_Show(playerid, "dialog_regages", DIALOG_STYLE_INPUT,
		"Godine",
		"Koliko imate godina: ",
		"Unesi", "Izlaz"
	);
 
	return Y_HOOKS_CONTINUE_RETURN_1;
}
 
Dialog: dialog_regages(const playerid, response, listitem, string: inputtext[])
{
	if (!response)
		return Kick(playerid);
 
	if (!(12 <= strval(inputtext) <= 50))
		return Dialog_Show(playerid, "dialog_regages", DIALOG_STYLE_INPUT,
			"Godine",
			"Koliko imate godina: ",
			"Unesi", "Izlaz"
		);
 
	account_Ages[playerid] = strval(inputtext);
 
	Dialog_Show(playerid, "dialog_regsex", DIALOG_STYLE_LIST,
	"Spol",
	"Musko\nZensko",
	"Odaberi", "Izlaz"
	);
 
	return Y_HOOKS_CONTINUE_RETURN_1;
}
 
Dialog: dialog_regsex(const playerid, response, listitem, string: inputtext[])
{
	if (!response)
		return Kick(playerid);
 
	new tmp_int = listitem + 1;
 
	new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag(File,"data");
	INI_WriteString(File, "Password", account_Password[playerid]);
	INI_WriteString(File, "Sex", (tmp_int == 1 ? ("Musko") : ("Zensko")));
	INI_WriteInt(File, "Age", account_Ages[playerid]);
	INI_WriteInt(File, "Level", 0);
	INI_WriteInt(File, "Skin", 240);
	INI_WriteInt(File, "Money", 1000);
	INI_WriteInt(File, "Staff", 0);

	INI_Close(File);
 
	account_Money[playerid] = 1000;
	account_Skin[playerid] = 240;
	account_Score[playerid] = 0;
 
	defer Spawn_Player(playerid, 1);
 
	return Y_HOOKS_CONTINUE_RETURN_1;
}
 
Dialog: dialog_login(const playerid, response, listitem, string: inputtext[])
{
	if (!response)
		return Kick(playerid);
 
	if (!strcmp(account_Password[playerid], inputtext, false))
		defer Spawn_Player(playerid, 2);
	else
	{
		if (account_LoginAttempts[playerid] == MAX_LOGIN_ATTEMPTS)
			return Kick(playerid);
 
		++account_LoginAttempts[playerid];
		Dialog_Show(playerid, "dialog_login", DIALOG_STYLE_PASSWORD,
			"Prijavljivanje",
			"%s, unesite Vasu tacnu lozinku: ",
			"Potvrdi", "Izlaz", ReturnPlayerName(playerid)
		);
	}
 
	return Y_HOOKS_CONTINUE_RETURN_1;
}
