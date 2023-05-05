    /*
@project Warsaw
@developer .paradox
@version 0.1
@zasluge Kenza
@credits Y_Less, AmyrAhmady, xunder-matth, Awsomedude

    @streamer https://github.com/samp-incognito/samp-streamer-plugin/releases
    @sscanf https://github.com/Y-Less/sscanf/releases
    @ysi https://github.com/pawn-lang/YSI-Includes
    @easydialog https://github.com/Awsomedude/easyDialog

*/

#define YSI_YES_HEAP_MALLOC

#define CGEN_MEMORY 90000

#include <a_samp>
#include <libs\ysilib\YSI_Storage\y_ini>
#include <libs\ysilib\YSI_Coding\y_timers>
#include <libs\ysilib\YSI_Coding\y_inline>
#include <libs\ysilib\YSI_Coding\y_hooks>
#include <libs\ysilib\YSI_Visual\y_commands>
#include <libs\ysilib\YSI_Coding\y_va>
#include <streamer>
#include <sscanf2>
#include <easyDialog>

//-----> assets

#include "assets/core_end/colors.pwn"
#include "assets/core_end/proxdetector.pwn"
#include "assets/core_end/labels.pwn"

#include "assets/player_side/account.pwn"

#include "assets/server_side/payday.pwn"
#include "assets/server_side/bribe.pwn"

#include "assets/staff_side/setstaff.pwn"
#include "assets/staff_side/staffduty.pwn"
#include "assets/staff_side/staffveh.pwn"
#include "assets/staff_side/clearchat.pwn"
#include "assets/staff_side/fixveh.pwn"
#include "assets/staff_side/nitro.pwn"
#include "assets/staff_side/jetpack.pwn"
#include "assets/staff_side/setskin.pwn"
#include "assets/staff_side/staffhelp.pwn"
#include "assets/staff_side/staffchat.pwn"
#include "assets/staff_side/goto.pwn"
#include "assets/staff_side/slap.pwn"

#include "assets/object_side/spawn.pwn"

#include "assets/vehicle_side/vehicleoptions.pwn"

//-----> end