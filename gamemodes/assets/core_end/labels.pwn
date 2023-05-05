#include <libs\ysilib\YSI_Coding\y_hooks>

forward Create3DynamicPickup(const text[], Float:vXU, Float:vYU, Float:vZU, vInt, vVW, pickupid, Float:radius);
public Create3DynamicPickup(const text[], Float:vXU, Float:vYU, Float:vZU, vInt, vVW, pickupid, Float:radius)
{
	CreateDynamic3DTextLabel(text, 0x0059FFAA, vXU, vYU, vZU, radius, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vVW, vInt, -1, 20.0);
	CreateDynamicPickup(pickupid, 1, vXU, vYU, vZU, vVW, vInt);
}

hook OnGameModeInit()
{
    //Create3DynamicPickup(""c_server"Warsaw RolePlay\nVersion: 0.1", 1485.5272,-2286.7068,13.5724, -1, -1, 1239, 2.0);
    return Y_HOOKS_CONTINUE_RETURN_1;
}