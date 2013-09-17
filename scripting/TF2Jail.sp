/*	TF2 Jailbreak by Jack of Designs!
	Goal of this plugin: Offer a TF2 Jailbreak experience and make TF2 Jailbreak a thing. I'm expecting to see hundreds of servers by at least 3-4 months after I release this! Make it happen people!
	
	The licensing for this plugin is similar to Sourcemod but there's two things I'd like to ask in a sincere way:
		- If you make any changes to this plugin, tell me. I'd like to update this for everyone to use. If you have updates you think should happen, fork this plugin on Github and push it to me to look at.
		- If you can help it, attempt to use the Natives I offer to create sub modules as plugins. I can make new natives if you need them so just give me a buzz.
	Other than that, if you need to edit the plugin, go right ahead, I don't mind.
	
	
	Do you like my work? Donate to me on my site below or use the link on the side:	http://www.jackofdesigns.com/blog/
		- Every penny counts since I like to eat food so anything is appreciated! If you donate $10000, I will personally come to your house and share a nice glass of Orange Juice with you!
		
	The list of credits for the plugin will be on the Github Wiki, I want them in one central place so check them out there. There's a lot of people since I generally looked at code made up by them and saw new methods that actually made my life easier.
	
	Also, I'd like to thank The Outpost Community for giving me a ground to step in in terms of a server to test things on and start the plugin on, I wouldn't have been able to do it without them.
	
	**
	 * =============================================================================
	 * TF2 Jailbreak Plugin Set (TF2Jail)
	 * Displays and searches SourceMod commands and descriptions.
	 *
	 * Created and developed by Keith Warren (Jack of Designs).
	 * =============================================================================
	 *
	 * This program is free software: you can redistribute it and/or modify
	 * it under the terms of the GNU General Public License as published by
	 * the Free Software Foundation, either version 3 of the License, or
	 * (at your option) any later version.
	 *
	 * This program is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	 * GNU General Public License for more details.
	 *
	 * You should have received a copy of the GNU General Public License
	 * along with this program. If not, see <http://www.gnu.org/licenses/>.
	 *
	**
*/

#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2>
#include <tf2_stocks>
#include <morecolors>
#include <smlib>
#include <autoexecconfig>
#undef REQUIRE_EXTENSIONS
#tryinclude <clientprefs>
#tryinclude <tf2items>
#tryinclude <steamtools>
#undef REQUIRE_PLUGIN
#tryinclude <sourcebans>
#tryinclude <adminmenu>
#tryinclude <updater>
#tryinclude <tf2attributes>
#tryinclude <sourcecomms>
#tryinclude <basecomm>
#tryinclude <basebans>
#tryinclude <betherobot>
#tryinclude <voiceannounce_ex>
#tryinclude <filesmanagementinterface>

#define PLUGIN_NAME     "[TF2] Jailbreak"
#define PLUGIN_AUTHOR   "Keith Warren(Jack of Designs)"
#define PLUGIN_VERSION  "4.9.3"
#define PLUGIN_DESCRIPTION	"Jailbreak for Team Fortress 2."
#define PLUGIN_CONTACT  "http://www.jackofdesigns.com/"

#define CLAN_TAG_COLOR	"{community}[TF2Jail]"
#define CLAN_TAG		"[TF2Jail]"

new Handle:JB_Cvar_Version = INVALID_HANDLE;
new Handle:JB_Cvar_Enabled = INVALID_HANDLE;
new Handle:JB_Cvar_Advertise = INVALID_HANDLE;
new Handle:JB_Cvar_Cvars = INVALID_HANDLE;
new Handle:JB_Cvar_Balance = INVALID_HANDLE;
new Handle:JB_Cvar_BalanceRatio = INVALID_HANDLE;
new Handle:JB_Cvar_RedMelee = INVALID_HANDLE;
new Handle:JB_Cvar_Warden = INVALID_HANDLE;
new Handle:JB_Cvar_WardenAuto = INVALID_HANDLE;
new Handle:JB_Cvar_WardenModel = INVALID_HANDLE;
new Handle:JB_Cvar_WardenFF = INVALID_HANDLE;
new Handle:JB_Cvar_WardenColor = INVALID_HANDLE;
new Handle:JB_Cvar_Doorcontrol = INVALID_HANDLE;
new Handle:JB_Cvar_DoorOpenTime = INVALID_HANDLE;
new Handle:JB_Cvar_RedMute = INVALID_HANDLE;
new Handle:JB_Cvar_RedMuteTime = INVALID_HANDLE;
new Handle:JB_Cvar_BlueMute = INVALID_HANDLE;
new Handle:JB_Cvar_DeadMute = INVALID_HANDLE;
new Handle:JB_Cvar_MicCheck = INVALID_HANDLE;
new Handle:JB_Cvar_MicCheckType = INVALID_HANDLE;
new Handle:JB_Cvar_Rebels = INVALID_HANDLE;
new Handle:JB_Cvar_RebelColor = INVALID_HANDLE;
new Handle:JB_Cvar_RebelsTime = INVALID_HANDLE;
new Handle:JB_Cvar_Crits = INVALID_HANDLE;
new Handle:JB_Cvar_CritsType = INVALID_HANDLE;
new Handle:JB_Cvar_VoteNeeded = INVALID_HANDLE;
new Handle:JB_Cvar_VoteMinPlayers = INVALID_HANDLE;
new Handle:JB_Cvar_VotePostAction = INVALID_HANDLE;
new Handle:JB_Cvar_VotePassedLimit = INVALID_HANDLE;
new Handle:JB_Cvar_Freekillers = INVALID_HANDLE;
new Handle:JB_Cvar_Freekillers_Time = INVALID_HANDLE;
new Handle:JB_Cvar_Freekillers_Kills = INVALID_HANDLE;
new Handle:JB_Cvar_Freekillers_Wave = INVALID_HANDLE;
new Handle:JB_Cvar_Freekillers_Action = INVALID_HANDLE;
new Handle:JB_Cvar_Freekillers_BanMSG = INVALID_HANDLE;
new Handle:JB_Cvar_Freekillers_BanMSGDC = INVALID_HANDLE;
new Handle:JB_Cvar_Freekillers_Bantime = INVALID_HANDLE;
new Handle:JB_Cvar_Freekillers_BantimeDC = INVALID_HANDLE;
new Handle:JB_Cvar_LRS_Enabled = INVALID_HANDLE;
new Handle:JB_Cvar_LRS_Automatic = INVALID_HANDLE;
new Handle:JB_Cvar_FreedayColor = INVALID_HANDLE;
new Handle:JB_Cvar_Freeday_Limit = INVALID_HANDLE;

new bool:j_Enabled = true;
new bool:j_Advertise = true;
new bool:j_Cvars = true;
new bool:j_Balance = true;
new Float:j_BalanceRatio = 0.5;
new bool:j_RedMelee = true;
new bool:j_Warden = false;
new bool:j_WardenAuto = false;
new bool:j_WardenModel = true;
new bool:j_WardenFF = true;
new gWardenColor[3];
new bool:j_DoorControl = true;
new Float:j_DoorOpenTimer = 60.0;
new j_RedMute = 2;
new Float:j_RedMuteTime = 15.0;
new j_BlueMute = 2;
new bool:j_DeadMute = true;
new bool:j_MicCheck = true;
new bool:j_MicCheckType = true;
new bool:j_Rebels = true;
new gRebelColor[3];
new Float:j_RebelsTime = 30.0;
new j_Criticals = 1;
new j_Criticalstype = 2;
new Float:j_WVotesNeeded = 0.60;
new j_WVotesMinPlayers = 0;
new j_WVotesPostAction = 0;
new j_WVotesPassedLimit = 3;
new bool:j_Freekillers = true;
new Float:j_FreekillersTime = 6.0;
new j_FreekillersKills = 6;
new Float:j_FreekillersWave = 60.0;
new j_FreekillersAction = 2;
new j_FreekillersBantime = 60;
new j_FreekillersBantimeDC = 120;
new bool:j_LRSEnabled = true;
new bool:j_LRSAutomatic = true;
new gFreedayColor[3];
new j_FreedayLimit = 3;

new bool:e_tf2items;
new bool:e_tf2attributes;
new bool:e_sourcecomms;
new bool:e_basecomm;
new bool:e_basebans;
new bool:e_betherobot;
new bool:e_voiceannounce_ex;
new bool:e_filemanager;
new bool:e_sourcebans;
new bool:steamtools = false;

new bool:g_IsMapCompatible = false;
new bool:g_IsLRRound = false;
new bool:g_CellDoorTimerActive = false;
new bool:g_1stRoundFreeday = false;
new bool:g_VoidFreekills = false;
new bool:g_bIsLRInUse = false;
new bool:g_bIsWardenLocked = false;
new bool:g_bIsSpeedDemonRound = false;
new bool:g_bIsLowGravRound = false;
new bool:g_bIsDiscoRound = false;
new bool:g_RobotRoundClients[MAXPLAYERS+1];
new bool:g_IsMuted[MAXPLAYERS+1];
new bool:g_IsRebel[MAXPLAYERS + 1];
new bool:g_IsFreeday[MAXPLAYERS + 1];
new bool:g_IsFreedayActive[MAXPLAYERS + 1];
new bool:g_IsFreekiller[MAXPLAYERS + 1];
new bool:g_HasTalked[MAXPLAYERS+1];
new bool:g_LockedFromWarden[MAXPLAYERS+1];
new bool:g_HasModel[MAXPLAYERS+1];
new bool:g_bLateLoad = false;
new bool:g_Voted[MAXPLAYERS+1] = {false, ...};

new g_Voters = 0;
new g_Votes = 0;
new g_VotesNeeded = 0;
new g_VotesPassed = 0;
new g_FirstKill[MAXPLAYERS + 1];
new g_Killcount[MAXPLAYERS + 1];
new Warden = -1;
new WardenLimit = 0;
new FreedayLimit = 0;

new Handle:g_hArray_Pending = INVALID_HANDLE;
new Handle:g_fward_onBecome = INVALID_HANDLE;
new Handle:g_fward_onRemove = INVALID_HANDLE;
new Handle:g_adverttimer = INVALID_HANDLE;
new Handle:DataTimerF = INVALID_HANDLE;
new Handle:Cvar_FF = INVALID_HANDLE;
new Handle:Cvar_COL = INVALID_HANDLE;

new String:DoorList[][] = {"func_door", "func_door_rotating", "func_movelinear"};

enum LastRequests
{
	LR_Disabled = 0,
	LR_FreedayForAll,
	LR_FreedayForClients,
	LR_PersonalFreeday,
	LR_GuardsMeleeOnly,
	LR_HHHKillRound,
	LR_LowGravity,
	LR_SpeedDemon,
	LR_HungerGames,
	LR_RoboticTakeOver,
	LR_HideAndSeek,
	LR_DiscoDay
};
new LastRequests:enumLastRequests;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
public Plugin:myinfo =
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_CONTACT
};

public OnPluginStart()
{
	LogMessage("%s Jailbreak is now loading...", CLAN_TAG);
	LoadTranslations("common.phrases");
	LoadTranslations("TF2Jail.phrases");
	
	AutoExecConfig_SetFile("TF2Jail");

	JB_Cvar_Version = AutoExecConfig_CreateConVar("tf2jail_version", PLUGIN_VERSION, PLUGIN_NAME, FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_DONTRECORD);
	JB_Cvar_Enabled = AutoExecConfig_CreateConVar("sm_tf2jail_enable", "1", "Status of the plugin: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_Advertise = AutoExecConfig_CreateConVar("sm_tf2jail_advertisement", "1", "Display plugin creator advertisement: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_Cvars = AutoExecConfig_CreateConVar("sm_tf2jail_set_variables", "1", "Set default cvars: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_Balance = AutoExecConfig_CreateConVar("sm_tf2jail_auto_balance", "1", "Should the plugin autobalance teams: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_BalanceRatio = AutoExecConfig_CreateConVar("sm_tf2jail_balance_ratio", "0.5", "Ratio for autobalance: (Example: 0.5 = 2:4)", FCVAR_PLUGIN, true, 0.1, true, 1.0);
	JB_Cvar_RedMelee = AutoExecConfig_CreateConVar("sm_tf2jail_melee", "1", "Strip Red Team of weapons: (1 = strip weapons, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_Warden = AutoExecConfig_CreateConVar("sm_tf2jail_warden_enable", "1", "Allow Wardens: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_WardenAuto = AutoExecConfig_CreateConVar("sm_tf2jail_warden_auto", "1", "Automatically assign a random warden on round start: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_WardenModel = AutoExecConfig_CreateConVar("sm_tf2jail_warden_model", "1", "Does Warden have a model: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_WardenFF = AutoExecConfig_CreateConVar("sm_tf2jail_warden_friendlyfire", "1", "Allow warden to manage friendly fire: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_WardenColor = AutoExecConfig_CreateConVar("sm_tf2jail_warden_color", "125 150 250", "Color of warden if wardenmodel is off: (0 = off)", FCVAR_PLUGIN);
	JB_Cvar_Doorcontrol = AutoExecConfig_CreateConVar("sm_tf2jail_door_controls", "1", "Allow Wardens and Admins door control: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_DoorOpenTime = AutoExecConfig_CreateConVar("sm_tf2jail_cell_timer", "60", "Time after Arena round start to open doors: (1.0 - 60.0) (0.0 = off)", FCVAR_PLUGIN, true, 0.0, true, 60.0);
	JB_Cvar_RedMute = AutoExecConfig_CreateConVar("sm_tf2jail_mute_red", "2", "Mute Red team: (2 = mute prisoners alive and all dead, 1 = mute prisoners on round start based on redmute_time, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 2.0);
	JB_Cvar_RedMuteTime = AutoExecConfig_CreateConVar("sm_tf2jail_mute_red_time", "15", "Mute time for redmute: (1.0 - 60.0)", FCVAR_PLUGIN, true, 1.0, true, 60.0);
	JB_Cvar_BlueMute = AutoExecConfig_CreateConVar("sm_tf2jail_mute_blue", "2", "Mute Blue players: (2 = always except warden, 1 = while Warden is active, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 2.0);
	JB_Cvar_DeadMute = AutoExecConfig_CreateConVar("sm_tf2jail_mute_dead", "1", "Mute Dead players: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_MicCheck = AutoExecConfig_CreateConVar("sm_tf2jail_microphonecheck_enable", "1", "Check blue clients for microphone: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_MicCheckType = AutoExecConfig_CreateConVar("sm_tf2jail_microphonecheck_type", "1", "Block blue team or warden if no microphone: (1 = Blue, 0 = Warden only)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_Rebels = AutoExecConfig_CreateConVar("sm_tf2jail_rebelling_enable", "1", "Enable the Rebel system: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_RebelColor = AutoExecConfig_CreateConVar("sm_tf2jail_rebelling_color", "0 255 0", "Rebel color flags: (0 = off)", FCVAR_PLUGIN);
	JB_Cvar_RebelsTime = AutoExecConfig_CreateConVar("sm_tf2jail_rebelling_time", "30.0", "Rebel timer: (1.0 - 60.0, 0 = always)", FCVAR_PLUGIN, true, 1.0, true, 60.0);
	JB_Cvar_Crits = AutoExecConfig_CreateConVar("sm_tf2jail_criticals", "1", "Which team gets crits: (0 = off, 1 = blue, 2 = red, 3 = both)", FCVAR_PLUGIN, true, 0.0, true, 3.0);
	JB_Cvar_CritsType = AutoExecConfig_CreateConVar("sm_tf2jail_criticals_type", "2", "Type of crits given: (1 = mini, 2 = full)", FCVAR_PLUGIN, true, 1.0, true, 2.0);
	JB_Cvar_VoteNeeded = AutoExecConfig_CreateConVar("sm_tf2jail_warden_veto_votesneeded", "0.60", "Percentage of players required for fire warden vote: (default 0.60 - 60%) (0.05 - 1.0)", 0, true, 0.05, true, 1.00);
	JB_Cvar_VoteMinPlayers = AutoExecConfig_CreateConVar("sm_tf2jail_warden_veto_minplayers", "0", "Minimum amount of players required for fire warden vote: (0 - MaxPlayers)", 0, true, 0.0, true, float(MAXPLAYERS));
	JB_Cvar_VotePostAction = AutoExecConfig_CreateConVar("sm_tf2jail_warden_veto_postaction", "0", "Fire warden instantly on vote success or next round: (0 = instant, 1 = Next round)", _, true, 0.0, true, 1.0);
	JB_Cvar_VotePassedLimit = AutoExecConfig_CreateConVar("sm_tf2jail_warden_veto_passlimit", "3", "Limit to wardens fired by players via votes: (1 - 10, 0 = unlimited)", FCVAR_PLUGIN, true, 0.0, true, 10.0);
	JB_Cvar_Freekillers = AutoExecConfig_CreateConVar("sm_tf2jail_freekilling_enable", "1", "Enable the Freekill system: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_Freekillers_Time = AutoExecConfig_CreateConVar("sm_tf2jail_freekilling_seconds", "6.0", "Time in seconds minimum for freekill flag on mark: (1.0 - 60.0)", FCVAR_PLUGIN, true, 1.0, true, 60.0);
	JB_Cvar_Freekillers_Kills = AutoExecConfig_CreateConVar("sm_tf2jail_freekilling_kills", "6", "Number of kills required to flag for freekilling: (1.0 - MaxPlayers)", FCVAR_PLUGIN, true, 1.0, true, float(MAXPLAYERS));
	JB_Cvar_Freekillers_Wave = AutoExecConfig_CreateConVar("sm_tf2jail_freekilling_wave", "60.0", "Time in seconds until client is banned for being marked: (1.0 - 60.0)", FCVAR_PLUGIN, true, 1.0, true, 60.0);
	JB_Cvar_Freekillers_Action = AutoExecConfig_CreateConVar("sm_tf2jail_freekilling_action", "2", "Action towards marked freekiller: (2 = Ban client based on cvars, 1 = Slay the client, 0 = remove mark on timer)", FCVAR_PLUGIN, true, 0.0, true, 2.0);
	JB_Cvar_Freekillers_BanMSG = AutoExecConfig_CreateConVar("sm_tf2jail_freekilling_ban_reason", "You have been banned for freekilling.", "Message to give the client if they're marked as a freekiller and banned.", FCVAR_PLUGIN);
	JB_Cvar_Freekillers_BanMSGDC = AutoExecConfig_CreateConVar("sm_tf2jail_freekilling_ban_reason_dc", "You have been banned for freekilling and disconnecting.", "Message to give the client if they're marked as a freekiller/disconnected and banned.", FCVAR_PLUGIN);
	JB_Cvar_Freekillers_Bantime = AutoExecConfig_CreateConVar("sm_tf2jail_freekilling_duration", "60", "Time banned after timer ends: (0 = permanent)", FCVAR_PLUGIN, true, 0.0);
	JB_Cvar_Freekillers_BantimeDC = AutoExecConfig_CreateConVar("sm_tf2jail_freekilling_duration_dc", "120", "Time banned if disconnected after timer ends: (0 = permanent)", FCVAR_PLUGIN, true, 0.0);
	JB_Cvar_LRS_Enabled = AutoExecConfig_CreateConVar("sm_tf2jail_lastrequest_enable", "1", "Status of the LR System: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_LRS_Automatic = AutoExecConfig_CreateConVar("sm_tf2jail_lastrequest_automatic", "1", "Automatically grant last request to last prisoner alive: (1 = on, 0 = off)", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	JB_Cvar_FreedayColor = AutoExecConfig_CreateConVar("sm_tf2jail_freeday_color", "125 0 0", "Freeday color flags: (0 = off)", FCVAR_PLUGIN);
	JB_Cvar_Freeday_Limit = AutoExecConfig_CreateConVar("sm_tf2jail_freeday_limit", "3", "Max number of freedays for the lr: (1.0 - 16.0)", FCVAR_PLUGIN, true, 1.0, true, 16.0);

	AutoExecConfig_ExecuteFile();

	gWardenColor[0] = 125;
	gWardenColor[1] = 150;
	gWardenColor[2] = 250;
	gRebelColor[0] = 0;
	gRebelColor[1] = 255;
	gRebelColor[2] = 0;
	gFreedayColor[0] = 125;
	gFreedayColor[1] = 0;
	gFreedayColor[2] = 0;

	HookConVarChange(JB_Cvar_Enabled, HandleCvars);
	HookConVarChange(JB_Cvar_Advertise, HandleCvars);
	HookConVarChange(JB_Cvar_Cvars, HandleCvars);
	HookConVarChange(JB_Cvar_Balance, HandleCvars);
	HookConVarChange(JB_Cvar_BalanceRatio, HandleCvars);
	HookConVarChange(JB_Cvar_RedMelee, HandleCvars);
	HookConVarChange(JB_Cvar_Warden, HandleCvars);
	HookConVarChange(JB_Cvar_WardenAuto, HandleCvars);
	HookConVarChange(JB_Cvar_WardenModel, HandleCvars);
	HookConVarChange(JB_Cvar_WardenFF, HandleCvars);
	HookConVarChange(JB_Cvar_WardenColor, HandleCvars);
	HookConVarChange(JB_Cvar_Doorcontrol, HandleCvars);
	HookConVarChange(JB_Cvar_DoorOpenTime, HandleCvars);
	HookConVarChange(JB_Cvar_RedMute, HandleCvars);
	HookConVarChange(JB_Cvar_RedMuteTime, HandleCvars);
	HookConVarChange(JB_Cvar_BlueMute, HandleCvars);
	HookConVarChange(JB_Cvar_DeadMute, HandleCvars);
	HookConVarChange(JB_Cvar_MicCheck, HandleCvars);
	HookConVarChange(JB_Cvar_MicCheckType, HandleCvars);
	HookConVarChange(JB_Cvar_Rebels, HandleCvars);
	HookConVarChange(JB_Cvar_RebelColor, HandleCvars);
	HookConVarChange(JB_Cvar_RebelsTime, HandleCvars);
	HookConVarChange(JB_Cvar_Crits, HandleCvars);
	HookConVarChange(JB_Cvar_CritsType, HandleCvars);
	HookConVarChange(JB_Cvar_VoteNeeded, HandleCvars);
	HookConVarChange(JB_Cvar_VoteMinPlayers, HandleCvars);
	HookConVarChange(JB_Cvar_VotePostAction, HandleCvars);
	HookConVarChange(JB_Cvar_VotePassedLimit, HandleCvars);
	HookConVarChange(JB_Cvar_Freekillers, HandleCvars);
	HookConVarChange(JB_Cvar_Freekillers_Time, HandleCvars);
	HookConVarChange(JB_Cvar_Freekillers_Kills, HandleCvars);
	HookConVarChange(JB_Cvar_Freekillers_Wave, HandleCvars);
	HookConVarChange(JB_Cvar_Freekillers_Action, HandleCvars);
	HookConVarChange(JB_Cvar_Freekillers_Bantime, HandleCvars);
	HookConVarChange(JB_Cvar_Freekillers_BantimeDC, HandleCvars);
	HookConVarChange(JB_Cvar_LRS_Enabled, HandleCvars);
	HookConVarChange(JB_Cvar_LRS_Automatic, HandleCvars);
	HookConVarChange(JB_Cvar_FreedayColor, HandleCvars);
	HookConVarChange(JB_Cvar_Freeday_Limit, HandleCvars);
	
	HookEvent("player_spawn", PlayerSpawn);
	HookEvent("player_hurt", PlayerHurt);
	HookEvent("player_death", PlayerDeath);
	HookEvent("teamplay_round_start", RoundStart);
	HookEvent("arena_round_start", ArenaRoundStart);
	HookEvent("teamplay_round_win", RoundEnd);
	AddCommandListener(InterceptBuild, "build");
	
	AutoExecConfig(true, "TF2Jail");

	RegConsoleCmd("sm_fire", Command_FireWarden);
	RegConsoleCmd("sm_firewarden", Command_FireWarden);
	RegConsoleCmd("sm_w", BecomeWarden);
	RegConsoleCmd("sm_warden", BecomeWarden);
	RegConsoleCmd("sm_uw", ExitWarden);
	RegConsoleCmd("sm_unwarden", ExitWarden);
	RegConsoleCmd("sm_wmenu", WardenMenuC);
	RegConsoleCmd("sm_wardenmenu", WardenMenuC);
	RegConsoleCmd("sm_open", OnOpenCommand);
	RegConsoleCmd("sm_close", OnCloseCommand);
	RegConsoleCmd("sm_wff", WardenFriendlyFire);
	RegConsoleCmd("sm_wardenff", WardenFriendlyFire);
	RegConsoleCmd("sm_wardenfriendlyfire", WardenFriendlyFire);
	RegConsoleCmd("sm_wcc", WardenCollision);
	RegConsoleCmd("sm_wcollision", WardenCollision);
	RegConsoleCmd("sm_givelr", GiveLR);
	RegConsoleCmd("sm_givelastrequest", GiveLR);
	RegConsoleCmd("sm_removelr", RemoveLR);
	RegConsoleCmd("sm_removelastrequest", RemoveLR);
	
	RegAdminCmd("sm_rw", AdminRemoveWarden, ADMFLAG_GENERIC);
	RegAdminCmd("sm_removewarden", AdminRemoveWarden, ADMFLAG_GENERIC);
	RegAdminCmd("sm_pardon", AdminPardonFreekiller, ADMFLAG_GENERIC);
	RegAdminCmd("sm_denylr", AdminDenyLR, ADMFLAG_GENERIC);
	RegAdminCmd("sm_denylastrequest", AdminDenyLR, ADMFLAG_GENERIC);
	RegAdminCmd("sm_opencells", AdminOpenCells, ADMFLAG_GENERIC);
	RegAdminCmd("sm_closecells", AdminCloseCells, ADMFLAG_GENERIC);
	RegAdminCmd("sm_lockcells", AdminLockCells, ADMFLAG_GENERIC);
	RegAdminCmd("sm_unlockcells", AdminUnlockCells, ADMFLAG_GENERIC);
	RegAdminCmd("sm_forcewarden", AdminForceWarden, ADMFLAG_GENERIC);
	RegAdminCmd("sm_forcelr", AdminForceLR, ADMFLAG_GENERIC);
	RegAdminCmd("sm_jailreset", AdminResetPlugin, ADMFLAG_GENERIC);
	RegAdminCmd("sm_compatible", MapCompatibilityCheck, ADMFLAG_GENERIC);
	RegAdminCmd("sm_givefreeday", AdminGiveFreeday, ADMFLAG_GENERIC);
	RegAdminCmd("sm_removefreeday", AdminRemoveFreeday, ADMFLAG_GENERIC);
	
	Cvar_FF = FindConVar("mp_friendlyfire");
	Cvar_COL = FindConVar("tf_avoidteammates_pushaway");
	
	AddMultiTargetFilter("@warden", WardenGroup, "the warden", false);
	AddMultiTargetFilter("@rebels", RebelsGroup, "all rebellers", false);
	AddMultiTargetFilter("@freedays", FreedaysGroup, "all freedays", false);
	AddMultiTargetFilter("@!warden", NotWardenGroup, "all but the warden", false);
	AddMultiTargetFilter("@!rebels", NotRebelsGroup, "all but rebellers", false);
	AddMultiTargetFilter("@!freedays", NotFreedaysGroup, "all but freedays", false);
	
	steamtools = LibraryExists("SteamTools");
	
	g_fward_onBecome = CreateGlobalForward("warden_OnWardenCreated", ET_Ignore, Param_Cell);
	g_fward_onRemove = CreateGlobalForward("warden_OnWardenRemoved", ET_Ignore, Param_Cell);

	AddServerTag2("Jailbreak");
	
	MapCheck();

	g_hArray_Pending = CreateArray();
	
	if (g_bLateLoad)
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				OnClientPutInServer(i);
			}
		}
	}
	AutoExecConfig_CleanFile();
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	new String:Game[32];
	GetGameFolderName(Game, sizeof(Game));

	if (!StrEqual(Game, "tf"))
	{
		Format(error, err_max, "This plugin only works for Team Fortress 2.");
		return APLRes_Failure;
	}

	MarkNativeAsOptional("GetUserMessageType");
	MarkNativeAsOptional("Steam_SetGameDescription");
	
	CreateNative("TF2Jail_WardenActive", Native_ExistWarden);
	CreateNative("TF2Jail_IsWarden", Native_IsWarden);
	CreateNative("TF2Jail_WardenSet", Native_SetWarden);
	CreateNative("TF2Jail_WardenUnset", Native_RemoveWarden);
	CreateNative("TF2Jail_IsFreeday", Native_IsFreeday);
	CreateNative("TF2Jail_GiveFreeday", Native_GiveFreeday);
	CreateNative("TF2Jail_IsRebel", Native_IsRebel);
	CreateNative("TF2Jail_MarkRebel", Native_MarkRebel);
	CreateNative("TF2Jail_IsFreekiller", Native_IsFreekiller);
	CreateNative("TF2Jail_MarkFreekiller", Native_MarkFreekill);
	RegPluginLibrary("TF2Jail");

	g_bLateLoad = late;

	return APLRes_Success;
}

public OnAllPluginsLoaded()
{	
	if (LibraryExists("betherobot"))				e_betherobot = true;
	if (LibraryExists("tf2items"))					e_tf2items = true;
	if (LibraryExists("voiceannounce_ex"))			e_voiceannounce_ex = true;
	if (LibraryExists("filesmanagementinterface"))	e_filemanager = true;
	if (LibraryExists("tf2attributes"))				e_tf2attributes = true;
	if (LibraryExists("sourcebans"))				e_sourcebans = true;
	if (LibraryExists("sourcecomms"))				e_sourcecomms = true;
	if (LibraryExists("basecomm"))					e_basecomm = true;
	if (LibraryExists("basebans"))					e_basebans = true;
}

public OnPluginEnd()
{
	ConvarsOff();
	RemoveServerTag2("Jailbreak");
	LogMessage("%s Jailbreak has been unloaded successfully.", CLAN_TAG);
}

stock ConvarsOn()
{
	SetConVarInt(FindConVar("mp_stalemate_enable"),0);
	SetConVarInt(FindConVar("tf_arena_use_queue"), 0);
	SetConVarInt(FindConVar("mp_teams_unbalance_limit"), 0);
	SetConVarInt(FindConVar("mp_autoteambalance"), 0);
	SetConVarInt(FindConVar("tf_arena_first_blood"), 0);
	SetConVarInt(FindConVar("mp_scrambleteams_auto"), 0);
	SetConVarInt(FindConVar("tf_scout_air_dash_count"), 0);
}

stock ConvarsOff()
{
	SetConVarInt(FindConVar("mp_stalemate_enable"),1);
	SetConVarInt(FindConVar("tf_arena_use_queue"), 1);
	SetConVarInt(FindConVar("mp_teams_unbalance_limit"), 1);
	SetConVarInt(FindConVar("mp_autoteambalance"), 1);
	SetConVarInt(FindConVar("tf_arena_first_blood"), 1);
	SetConVarInt(FindConVar("mp_scrambleteams_auto"), 1);
	SetConVarInt(FindConVar("tf_scout_air_dash_count"), 1);
}

public OnLibraryAdded(const String:name[])
{
	if (StrEqual(name, "sourcebans"))				e_sourcebans = true;
	if (StrEqual(name, "sourcecomms"))				e_sourcecomms = true;
	if (StrEqual(name, "basecomm"))					e_basecomm = true;
	if (StrEqual(name, "basebans"))					e_basebans = true;
	if (StrEqual(name, "filesmanagementinterface"))	e_filemanager = true;
	if (StrEqual(name, "voiceannounce_ex"))			e_voiceannounce_ex = true;
	if (StrEqual(name, "betherobot"))				e_betherobot = true;
	if (StrEqual(name, "tf2attributes"))			e_tf2attributes = true;
	if (StrEqual(name, "tf2items"))					e_tf2items = true;
	
	if (strcmp(name, "SteamTools", false) == 0)	steamtools = true;
}

public OnLibraryRemoved(const String:name[])
{
	if (StrEqual(name, "sourcebans"))				e_sourcebans = false;
	if (StrEqual(name, "basecomm"))					e_basecomm = false;
	if (StrEqual(name, "basebans"))					e_basebans = false;
	if (StrEqual(name, "tf2items"))					e_tf2items = false;
	if (StrEqual(name, "tf2attributes"))			e_tf2attributes = false;
	if (StrEqual(name, "sourcecomms"))				e_sourcecomms = false;
	if (StrEqual(name, "betherobot"))				e_betherobot = false;
	if (StrEqual(name, "voiceannounce_ex"))			e_voiceannounce_ex = false;
	if (StrEqual(name, "filesmanagementinterface"))	e_filemanager = false;
	
	if (strcmp(name, "SteamTools", false) == 0)	steamtools = false;
}

public OnConfigsExecuted()
{
	SetConVarString(JB_Cvar_Version, PLUGIN_VERSION);

	j_Enabled = GetConVarBool(JB_Cvar_Enabled);
	j_Advertise = GetConVarBool(JB_Cvar_Advertise);
	j_Cvars = GetConVarBool(JB_Cvar_Cvars);
	j_Balance = GetConVarBool(JB_Cvar_Balance);
	j_BalanceRatio = GetConVarFloat(JB_Cvar_BalanceRatio);
	j_RedMelee = GetConVarBool(JB_Cvar_RedMelee);
	j_Warden = GetConVarBool(JB_Cvar_Warden);
	j_WardenAuto = GetConVarBool(JB_Cvar_WardenAuto);
	j_WardenModel = GetConVarBool(JB_Cvar_WardenModel);
	j_WardenFF = GetConVarBool(JB_Cvar_WardenFF);
	//JB_Cvar_WardenColor
	j_DoorControl = GetConVarBool(JB_Cvar_Doorcontrol);
	j_DoorOpenTimer = GetConVarFloat(JB_Cvar_DoorOpenTime);
	j_RedMute = GetConVarInt(JB_Cvar_RedMute);
	j_RedMuteTime = GetConVarFloat(JB_Cvar_RedMuteTime);
	j_BlueMute = GetConVarInt(JB_Cvar_BlueMute);
	j_DeadMute = GetConVarBool(JB_Cvar_DeadMute);
	j_MicCheck = GetConVarBool(JB_Cvar_MicCheck);
	j_MicCheckType = GetConVarBool(JB_Cvar_MicCheckType);
	j_Rebels = GetConVarBool(JB_Cvar_Rebels);
	//JB_Cvar_RebelColor
	j_RebelsTime = GetConVarFloat(JB_Cvar_RebelsTime);
	j_Criticals = GetConVarInt(JB_Cvar_Crits);
	j_Criticalstype = GetConVarInt(JB_Cvar_CritsType);
	j_WVotesNeeded = GetConVarFloat(JB_Cvar_VoteNeeded);
	j_WVotesMinPlayers = GetConVarInt(JB_Cvar_VoteMinPlayers);
	j_WVotesPostAction = GetConVarInt(JB_Cvar_VotePostAction);
	j_WVotesPassedLimit = GetConVarInt(JB_Cvar_VotePassedLimit);
	j_Freekillers = GetConVarBool(JB_Cvar_Freekillers);
	j_FreekillersTime = GetConVarFloat(JB_Cvar_Freekillers_Time);
	j_FreekillersKills = GetConVarInt(JB_Cvar_Freekillers_Kills);
	j_FreekillersWave = GetConVarFloat(JB_Cvar_Freekillers_Wave);
	j_FreekillersAction = GetConVarInt(JB_Cvar_Freekillers_Action);
	j_FreekillersBantime = GetConVarInt(JB_Cvar_Freekillers_Bantime);
	j_FreekillersBantimeDC = GetConVarInt(JB_Cvar_Freekillers_BantimeDC);
	j_LRSEnabled = GetConVarBool(JB_Cvar_LRS_Enabled);
	j_LRSAutomatic = GetConVarBool(JB_Cvar_LRS_Automatic);
	//JB_Cvar_FreedayColor
	j_FreedayLimit = GetConVarInt(JB_Cvar_Freeday_Limit);

	if (e_filemanager && e_tf2attributes && e_tf2items)
	{
		//Do NOTHING, we use these later. Less shit from the compiler.
	}

	if (j_Enabled)
	{		
		if (j_Cvars)
		{
			ConvarsOn();
		}
		if (j_WardenModel)
		{
			if (PrecacheModel("models/jailbreak/warden/warden_v2.mdl", true))
			{
				AddFileToDownloadsTable("models/jailbreak/warden/warden_v2.mdl");
				AddFileToDownloadsTable("models/jailbreak/warden/warden_v2.dx80.vtx");
				AddFileToDownloadsTable("models/jailbreak/warden/warden_v2.dx90.vtx");
				AddFileToDownloadsTable("models/jailbreak/warden/warden_v2.phy");
				AddFileToDownloadsTable("models/jailbreak/warden/warden_v2.sw.vtx");
				AddFileToDownloadsTable("models/jailbreak/warden/warden_v2.vvd");
				AddFileToDownloadsTable("materials/models/jailbreak/warden/NineteenEleven.vtf");
				AddFileToDownloadsTable("materials/models/jailbreak/warden/NineteenEleven.vmt");
				AddFileToDownloadsTable("materials/models/jailbreak/warden/warden_body.vtf");
				AddFileToDownloadsTable("materials/models/jailbreak/warden/warden_body.vmt");
				AddFileToDownloadsTable("materials/models/jailbreak/warden/warden_hat.vtf");
				AddFileToDownloadsTable("materials/models/jailbreak/warden/warden_hat.vmt");
				AddFileToDownloadsTable("materials/models/jailbreak/warden/warden_head.vtf");
				AddFileToDownloadsTable("materials/models/jailbreak/warden/warden_head.vmt");
			}
			else
			{
				LogError("Warden model has failed to load correctly, please verify the files.");
				j_WardenModel = false;
			}
		}
	}
	if (steamtools)
	{
		decl String:gameDesc[64];
		Format(gameDesc, sizeof(gameDesc), "%s v%s", PLUGIN_NAME, PLUGIN_VERSION);
		Steam_SetGameDescription(gameDesc);
	}
	ResetVotes();
	
	PrecacheSound("ui/system_message_alert.wav", true);
}

public HandleCvars (Handle:cvar, const String:oldValue[], const String:newValue[])
{
	if (StrEqual(oldValue, newValue, true))
	{
		return;
	}
	
	new iNewValue = StringToInt(newValue);
	
	if (cvar == JB_Cvar_Enabled)
	{
		if (iNewValue == 1)
		{
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "plugin enabled");
			HookEvent("player_spawn", PlayerSpawn);
			HookEvent("player_hurt", PlayerHurt);
			HookEvent("player_death", PlayerDeath);
			HookEvent("teamplay_round_start", RoundStart);
			HookEvent("arena_round_start", ArenaRoundStart);
			HookEvent("teamplay_round_win", RoundEnd);
			AddCommandListener(InterceptBuild, "build");
			j_Enabled = true;
			if (steamtools)
			{
				decl String:gameDesc[64];
				Format(gameDesc, sizeof(gameDesc), "%s v%s", PLUGIN_NAME, PLUGIN_VERSION);
				Steam_SetGameDescription(gameDesc);
			}
			for (new i = 1; i <= MaxClients; i++)
			{
				if (i == Warden && j_WardenModel)
				{
					SetModel(i, "models/jailbreak/warden/warden_v2.mdl");
				}
			}
		}
		else if (iNewValue == 0)
		{
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "plugin disabled");
			UnhookEvent("player_spawn", PlayerSpawn);
			UnhookEvent("player_hurt", PlayerHurt);
			UnhookEvent("player_death", PlayerDeath);
			UnhookEvent("teamplay_round_start", RoundStart);
			UnhookEvent("arena_round_start", ArenaRoundStart);
			UnhookEvent("teamplay_round_win", RoundEnd);
			RemoveCommandListener(InterceptBuild, "build");
			j_Enabled = false;
			if (steamtools) Steam_SetGameDescription("Team Fortress");
			for (new i = 1; i <= MaxClients; i++)
			{
				if (i == Warden && j_WardenModel)
				{
					RemoveModel(i);
				}
				if (g_IsRebel[i] && j_Rebels)
				{
					SetEntityRenderColor(i, 255, 255, 255, 255);
					g_IsRebel[i] = false;
				}
			}
		}
	}
	else if (cvar == JB_Cvar_Advertise)
	{
		if (iNewValue == 1)
		{
			j_Advertise = true;
			if (g_adverttimer == INVALID_HANDLE)
			{
				g_adverttimer = CreateTimer(120.0, TimerAdvertisement, _, TIMER_REPEAT);
			}
		}
		else if (iNewValue == 0)
		{
			j_Advertise = false;
			if (g_adverttimer != INVALID_HANDLE)
			{
				ClearTimer(g_adverttimer);
			}
		}
	}
	else if (cvar == JB_Cvar_Cvars)
	{
		if (iNewValue == 1)
		{
			j_Cvars = true;
			ConvarsOn();
		}
		else if (iNewValue == 0)
		{
			j_Cvars = false;
			ConvarsOff();
		}
	}
	else if (cvar == JB_Cvar_Balance)
	{
		if (iNewValue == 1)
		{
			j_Balance = true;
		}
		else if (iNewValue == 0)
		{
			j_Balance = false;
		}
	}
	else if (cvar == JB_Cvar_BalanceRatio)
	{
		j_BalanceRatio = StringToFloat(newValue);
	}
	else if (cvar == JB_Cvar_RedMelee)
	{
		if (iNewValue == 1)
		{
			j_RedMelee = true;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && GetClientTeam(i) == _:TFTeam_Red && IsPlayerAlive(i))
				{
					RedSpawnStrip(i);
				}
			}
		}
		else if (iNewValue == 0)
		{
			j_RedMelee = false;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && GetClientTeam(i) == _:TFTeam_Red && IsPlayerAlive(i))
				{
					TF2_RegeneratePlayer(i);
				}
			}
		}
	}
	else if (cvar == JB_Cvar_Warden)
	{
		if (iNewValue == 1)
		{
			j_Warden = true;
		}
		else if (iNewValue == 0)
		{
			j_Warden = false;
		}
	}
	else if (cvar == JB_Cvar_WardenAuto)
	{
		if (iNewValue == 1)
		{
			j_WardenAuto = true;
		}
		else if (iNewValue == 0)
		{
			j_WardenAuto = false;
		}
	}
	else if (cvar == JB_Cvar_WardenModel)
	{
		if (iNewValue == 1)
		{
			j_WardenModel = true;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (i == Warden)
				{
					SetEntityRenderColor(i, 255, 255, 255, 255);
					SetModel(i, "models/jailbreak/warden/warden_v2.mdl");
				}
			}
		}
		else if (iNewValue == 0)
		{
			j_WardenModel = false;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (i == Warden)
				{
					SetEntityRenderColor(i, gWardenColor[0], gWardenColor[1], gWardenColor[2], 255);
					RemoveModel(i);
				}
			}
		}
	}
	else if (cvar == JB_Cvar_WardenFF)
	{
		if (iNewValue == 1)
		{
			j_WardenFF = true;
		}
		else if (iNewValue == 0)
		{
			j_WardenFF = false;
		}
	}
	else if (cvar == JB_Cvar_WardenColor)
	{
		gWardenColor = SplitColorString(newValue);
	}
	else if (cvar == JB_Cvar_Doorcontrol)
	{
		if (iNewValue == 1)
		{
			j_DoorControl = false;
		}
		else if (iNewValue == 0)
		{
			j_DoorControl = true;
		}
	}
	else if (cvar == JB_Cvar_DoorOpenTime)
	{
		j_DoorOpenTimer = StringToFloat(newValue);
	}
	else if (cvar == JB_Cvar_RedMute)
	{
		j_RedMute = iNewValue;
	}
	else if (cvar == JB_Cvar_RedMuteTime)
	{
		j_RedMuteTime = StringToFloat(newValue);
	}
	else if (cvar == JB_Cvar_BlueMute)
	{
		j_BlueMute = iNewValue;
	}
	else if (cvar == JB_Cvar_DeadMute)
	{
		if (iNewValue == 1)
		{
			j_DeadMute = true;
		}
		else if (iNewValue == 0)
		{
			j_DeadMute = false;
		}
	}
	else if (cvar == JB_Cvar_MicCheck)
	{
		if (iNewValue == 1)
		{
			j_MicCheck = true;
		}
		else if (iNewValue == 0)
		{
			j_MicCheck = false;
		}
	}
	else if (cvar == JB_Cvar_MicCheck)
	{
		if (iNewValue == 1)
		{
			j_MicCheckType = true;
		}
		else if (iNewValue == 0)
		{
			j_MicCheckType = false;
		}
	}
	else if (cvar == JB_Cvar_Rebels)
	{
		if (iNewValue == 1)
		{
			j_Rebels = true;
		}
		else if (iNewValue == 0)
		{
			j_Rebels = false;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (g_IsRebel[i])
				{
					SetEntityRenderColor(i, 255, 255, 255, 255);
					g_IsRebel[i] = false;
				}
			}
		}
	}
	else if (cvar == JB_Cvar_RebelColor)
	{
		gRebelColor = SplitColorString(newValue);
	}
	else if (cvar == JB_Cvar_RebelsTime)
	{
		j_RebelsTime = StringToFloat(newValue);
	}
	else if (cvar == JB_Cvar_Crits)
	{
		j_Criticals = iNewValue;
	}
	else if (cvar == JB_Cvar_CritsType)
	{
		j_Criticalstype = iNewValue;
	}
	else if (cvar == JB_Cvar_VoteNeeded)
	{
		j_WVotesNeeded = StringToFloat(newValue);
	}
	else if (cvar == JB_Cvar_VoteMinPlayers)
	{
		j_WVotesMinPlayers = iNewValue;
	}
	else if (cvar == JB_Cvar_VotePostAction)
	{
		j_WVotesPostAction = iNewValue;
	}
	else if (cvar == JB_Cvar_VotePassedLimit)
	{
		j_WVotesPassedLimit = iNewValue;
	}
	else if (cvar == JB_Cvar_Freekillers)
	{
		if (iNewValue == 1)
		{
			j_Freekillers = true;
		}
		else if (iNewValue == 0)
		{
			j_Freekillers = false;
		}
	}
	else if (cvar == JB_Cvar_Freekillers_Time)
	{
		j_FreekillersTime = StringToFloat(newValue);
	}
	else if (cvar == JB_Cvar_Freekillers_Kills)
	{
		j_FreekillersKills = iNewValue;
	}
	else if (cvar == JB_Cvar_Freekillers_Wave)
	{
		j_FreekillersWave = StringToFloat(newValue);
	}
	else if (cvar == JB_Cvar_Freekillers_Action)
	{
		j_FreekillersAction = iNewValue;
	}
	else if (cvar == JB_Cvar_Freekillers_Bantime)
	{
		j_FreekillersBantime = iNewValue;
	}
	else if (cvar == JB_Cvar_Freekillers_BantimeDC)
	{
		j_FreekillersBantimeDC = iNewValue;
	}
	else if (cvar == JB_Cvar_LRS_Enabled)
	{
		if (iNewValue == 1)
		{
			j_LRSEnabled = true;
		}
		else if (iNewValue == 0)
		{
			j_LRSEnabled = false;
		}
	}
	else if (cvar == JB_Cvar_LRS_Automatic)
	{
		if (iNewValue == 1)
		{
			j_LRSAutomatic = true;
		}
		else if (iNewValue == 0)
		{
			j_LRSAutomatic = false;
		}
	}
	else if (cvar == JB_Cvar_FreedayColor)
	{
		gFreedayColor = SplitColorString(newValue);
	}
	else if (cvar == JB_Cvar_Freeday_Limit)
	{
		j_FreedayLimit = iNewValue;
	}
}

SplitColorString(const String:colors[])
{
	decl _iColors[3], String:_sBuffer[3][4];
	ExplodeString(colors, " ", _sBuffer, 3, 4);
	for (new i = 0; i <= 2; i++)
	_iColors[i] = StringToInt(_sBuffer[i]);
	
	return _iColors;
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
public OnMapStart()
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientConnected(i))
		{
			OnClientConnected(i);
		}
	}
	if (j_Enabled && j_Advertise)	g_adverttimer = CreateTimer(120.0, TimerAdvertisement, _, TIMER_REPEAT);
	
	g_1stRoundFreeday = true;

	g_Voters = 0;
	g_Votes = 0;
	g_VotesNeeded = 0;
	WardenLimit = 0;
	
	MapCheck();
}

public OnMapEnd()
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			g_HasTalked[i] = false;
			g_IsMuted[i] = false;
			g_IsFreeday[i] = false;
			g_LockedFromWarden[i] = false;
		}
	}

	if (j_Cvars)	ConvarsOff();
	if (steamtools)	Steam_SetGameDescription("Team Fortress");

	g_IsMapCompatible = false;

	ClearTimer(g_adverttimer);
	
	ResetVotes();
}

public Action:TimerAdvertisement (Handle:hTimer, any:client)
{
	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "plugin advertisement");
}

public OnClientConnected(client)
{
	if (IsFakeClient(client)) return;
	
	g_Voted[client] = false;

	g_Voters++;
	g_VotesNeeded = RoundToFloor(float(g_Voters) * j_WVotesNeeded);
	
	return;
}

public OnClientPutInServer(client)
{
	g_IsMuted[client] = false;
	g_RobotRoundClients[client] = false;
	g_IsRebel[client] = false;
	g_IsFreeday[client] = false;
	g_IsFreedayActive[client] = false;
	g_IsFreekiller[client] = false;
	g_HasTalked[client] = false;
	g_LockedFromWarden[client] = false;
}

public OnClientPostAdminCheck(client)
{
	if (j_Enabled)	CreateTimer(4.0, Timer_Welcome, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Timer_Welcome(Handle:hTimer, any:client)
{
	if (IsValidClient(client))	CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "welcome message");
}

public OnClientDisconnect(client)
{
	if (IsFakeClient(client)) return;
	
	if (g_Voted[client])	g_Votes--;
	g_Voters--;

	g_VotesNeeded = RoundToFloor(float(g_Voters) * j_WVotesNeeded);
	
	if (g_Votes && g_Voters && g_Votes >= g_VotesNeeded )
	{
		if (j_WVotesPostAction == 1)
		{
			return;
		}
		FireWardenCall();
	}

	if (client == Warden)
	{
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "warden disconnected");
		PrintCenterTextAll("%t", "warden disconnected center");
		Warden = -1;
	}

	g_HasTalked[client] = false;
	g_IsMuted[client] = false;
	g_RobotRoundClients[client] = false;
	g_IsRebel[client] = false;
	g_IsFreeday[client] = false;
	g_Killcount[client] = 0;
	g_FirstKill[client] = 0;
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (!j_Enabled) return Plugin_Continue;

	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new team = GetClientTeam(client);
	new notarget = GetEntityFlags(client)|FL_NOTARGET;

	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		g_IsRebel[client] = false;
		switch(enumLastRequests)
		{
		case LR_GuardsMeleeOnly, LR_HungerGames, LR_HideAndSeek:
			{
				TF2_RemoveWeaponSlot(client, 0);
				TF2_RemoveWeaponSlot(client, 1);
				TF2_RemoveWeaponSlot(client, 3);
				TF2_RemoveWeaponSlot(client, 4);
				TF2_RemoveWeaponSlot(client, 5);
				TF2_SwitchtoSlot(client, TFWeaponSlot_Melee);
			}
		}
		if (team == _:TFTeam_Red)
		{
			SetEntityFlags(client, notarget);

			new ent = -1;
			while ((ent = FindEntityByClassname(ent, "tf_wearable_demoshield")) != -1)
			{
				AcceptEntityInput(ent, "kill");
			}
			if (TF2_GetPlayerClass(client) == TFClass_Spy && TF2_IsPlayerInCondition(client, TFCond_Cloaked))
			{
				TF2_RemoveCondition(client, TFCond_Cloaked);
			}
			if (j_RedMute != 0) MutePlayer(client);
			if (g_IsFreeday[client]) GiveFreeday(client);
			if (j_RedMelee) CreateTimer(0.1, StripWeaponsReds, client, TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (team == _:TFTeam_Blue)
		{
			if (e_voiceannounce_ex && j_MicCheck)
			{
				if (j_MicCheckType)
				{
					if (!g_HasTalked[client] && !Client_HasAdminFlags(client, ADMFLAG_RESERVATION))
					{
						ChangeClientTeam(client, _:TFTeam_Red);
						TF2_RespawnPlayer(client);
						CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "microphone unverified");
					}
				}
			}
			if (j_BlueMute == 2) MutePlayer(client);
		}
	}
	return Plugin_Continue;
}

public Action:StripWeaponsReds(Handle:hTimer, any:client)
{
	RedSpawnStrip(client);
}

RedSpawnStrip(client)
{
	new TFClassType:class = TF2_GetPlayerClass(client);
	new index = -1;
	switch(class)
	{
	case TFClass_DemoMan:
		{
			SetClip(client, 0, 0, client);
			SetClip(client, 1, 0, client);
			SetAmmo(client, 0, 0, client);
			SetAmmo(client, 1, 0, client);
		}
	case TFClass_Engineer:
		{
			SetClip(client, 0, 0, client);
			SetClip(client, 1, 0, client);
			SetAmmo(client, 0, 0, client);
			SetAmmo(client, 1, 0, client);
		}
	case TFClass_Heavy:
		{
			SetClip(client, 1, 0, client);
			SetAmmo(client, 0, 0, client);
			SetAmmo(client, 1, 0, client);
		}
	case TFClass_Medic:
		{
			SetClip(client, 0, 0, client);
			SetClip(client, 1, 0, client);
			SetAmmo(client, 0, 0, client);
			SetAmmo(client, 1, 0, client);
		}
	case TFClass_Pyro:
		{
			SetClip(client, 1, 0, client);
			SetAmmo(client, 0, 0, client);
			SetAmmo(client, 1, 0, client);
		}
	case TFClass_Scout:
		{
			SetClip(client, 0, 0, client);
			SetClip(client, 1, 0, client);
			SetAmmo(client, 0, 0, client);
			SetAmmo(client, 1, 0, client);
		}
	case TFClass_Sniper:
		{
			SetClip(client, 1, 0, client);
			SetAmmo(client, 0, 0, client);
			SetAmmo(client, 1, 0, client);
		}
	case TFClass_Soldier:
		{
			SetClip(client, 0, 0, client);
			SetClip(client, 1, 0, client);
			SetAmmo(client, 0, 0, client);
			SetAmmo(client, 1, 0, client);
		}
	case TFClass_Spy:
		{
			SetClip(client, 0, 0, client);
			SetClip(client, 1, 0, client);
			SetAmmo(client, 0, 0, client);
			SetAmmo(client, 1, 0, client);
		}
	}
	new primary = GetPlayerWeaponSlot(client, TFWeaponSlot_Primary);
	if (primary > MaxClients && IsValidEdict(primary))
	{
		index = GetEntProp(primary, Prop_Send, "m_iItemDefinitionIndex");
		switch (index)
		{
		case 56, 1005: SetClip(client, 0, 0, client);
		}
	}
	TF2_SwitchtoSlot(client, TFWeaponSlot_Melee);
	TF2_RemoveWeaponSlot(client, 3);
	TF2_RemoveWeaponSlot(client, 4);
	TF2_RemoveWeaponSlot(client, 5);
	CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "stripped weapons and ammo");
}

stock TF2_SwitchtoSlot(client, slot)
{
	if (slot >= 0 && slot <= 5 && IsValidClient(client) && IsPlayerAlive(client))
	{
		decl String:classname[64];
		new wep = GetPlayerWeaponSlot(client, slot);
		if (wep > MaxClients && IsValidEdict(wep) && GetEdictClassname(wep, classname, sizeof(classname)))
		{
			FakeClientCommandEx(client, "use %s", classname);
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", wep);
		}
	}
}

public Action:PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new client_attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	if (!j_Enabled || !IsValidClient(client) || !IsValidClient(client_attacker))
	{
		return Plugin_Continue;
	}

	if (client_attacker != client)
	{
		if (g_IsFreedayActive[client_attacker])
		{
			RemoveFreeday(client_attacker);
		}
		if (j_Rebels)
		{
			if (GetClientTeam(client_attacker) == _:TFTeam_Red && GetClientTeam(client) == _:TFTeam_Blue && !g_IsRebel[client_attacker])
			{
				MarkRebel(client_attacker);
			}
		}
	}
	return Plugin_Continue;
}

public Action:PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new client_killer = GetClientOfUserId(GetEventInt(event, "attacker"));
	new time = GetTime();
	
	if (!j_Enabled || !IsValidClient(client) || !IsValidClient(client_killer))
	{
		return Plugin_Continue;
	}

	if (j_Freekillers)
	{
		if (client_killer != client && GetClientTeam(client_killer) == _:TFTeam_Blue)
		{
			if ((g_FirstKill[client_killer] + j_FreekillersTime) >= time)
			{
				if (++g_Killcount[client_killer] == j_FreekillersKills)
				{
					if (!g_VoidFreekills)
					{
						MarkFreekiller(client_killer);
					}
					else
					{
						CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "freekiller flagged while void", client_killer);
					}
				}
			}
			else
			{
				g_Killcount[client_killer] = 1;
				g_FirstKill[client_killer] = time;
			}
		}
	}
	
	if (client == Warden)
	{
		WardenUnset(Warden);
		PrintCenterTextAll("%t", "warden killed", Warden);
	}

	if (j_DeadMute) MutePlayer(client);
	if (g_IsFreedayActive[client]) RemoveFreeday(client);

	if (j_LRSAutomatic)
	{
		new lastprisoner = Team_GetClientCount(_:TFTeam_Red, CLIENTFILTER_ALIVE);
		if (lastprisoner == 1)
		{
			if (IsPlayerAlive(client) && GetClientTeam(client) == _:TFTeam_Red)
			{
				LastRequestStart(client);
			}
		}
	}
	
	new lastguard = Team_GetClientCount(_:TFTeam_Blue, CLIENTFILTER_ALIVE);
	if (lastguard == 1)
	{
		g_VoidFreekills = true;
		PrintCenterTextAll("%t", "last guard");
	}
	return Plugin_Continue;
}

public Action:RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	Warden = -1;
	g_bIsLRInUse = false;

	new ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_respawnroom")) != -1)
	{
		SDKHook(ent, SDKHook_TouchPost, SpawnTouch);
		SDKHook(ent, SDKHook_StartTouchPost, SpawnTouch);
	}

	ServerCommand("sm_countdown_enabled 2");

	if (j_Enabled && g_1stRoundFreeday)
	{
		OpenCells();
		PrintCenterTextAll("1st round freeday");
		g_1stRoundFreeday = false;
	}
	if (g_IsMapCompatible)
	{
		new open_cells = Entity_FindByName("open_cells", "func_button");
		if (Entity_IsValid(open_cells))
		{
			if (j_DoorControl)
			{
				Entity_Lock(open_cells);
			}
			else
			{
				Entity_UnLock(open_cells);
			}
		}
	}
	else
	{
		LogError("Map is incompatible, disabling check for door controls command variable.");
	}
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			if (g_HasModel[i])	RemoveModel(i);
		}
	}
}

public SpawnTouch(entity, client)
{
	if(client < 1 || client > MaxClients || !IsPlayerAlive(client))
	{
		return;
	}
	if(GetEntProp(entity, Prop_Send, "m_iTeamNum") != GetClientTeam(client))
	{
		if (g_IsFreedayActive[client])
		{
			RemoveFreeday(client);
		}
	}
}

public Action:ArenaRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (!j_Enabled) return Plugin_Continue;

	g_bIsWardenLocked = false;

	new Float:Ratio;
	if (j_Balance)
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			Ratio = Float:GetTeamClientCount(_:TFTeam_Blue)/Float:GetTeamClientCount(_:TFTeam_Red);
			if (Ratio <= j_BalanceRatio || GetTeamClientCount(_:TFTeam_Red) == 1)
			{
				break;
			}
			if (IsValidClient(i) && GetClientTeam(i) == _:TFTeam_Blue)
			{
				ChangeClientTeam(i, _:TFTeam_Red);
				TF2_RespawnPlayer(i);
				CPrintToChat(i, "%s %t", CLAN_TAG_COLOR, "moved for balance");
				if (g_HasModel[i])
				{
					RemoveModel(i);
				}
			}
		}
	}
	
	if (g_IsMapCompatible && j_DoorOpenTimer != 0.0)
	{
		new autoopen = RoundFloat(j_DoorOpenTimer);
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "cell doors open start", autoopen);
		CreateTimer(j_DoorOpenTimer, Open_Doors, _);
		g_CellDoorTimerActive = true;
	}

	switch(j_RedMute)
	{
	case 0:
		{
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "red mute system disabled");
		}
	case 1:
		{
			new time = RoundFloat(j_RedMuteTime);
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "red team muted temporarily", time);
			CreateTimer(j_RedMuteTime, UnmuteReds, _, TIMER_FLAG_NO_MAPCHANGE);
		}
	case 2:
		{
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "red team muted");
		}
	}
	
	switch(enumLastRequests)
	{
	case LR_FreedayForAll:
		{
			OpenCells();
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr free for all executed");
			g_VoidFreekills = true;
			g_IsLRRound = true;
		}
	case LR_PersonalFreeday:
		{
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && g_IsFreedayActive[i])
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr freeday executed", i);
				}
			}
			g_IsLRRound = true;
		}
	case LR_FreedayForClients:
		{
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && g_IsFreedayActive[i])
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr freeday executed", i);
				}
			}
			g_IsLRRound = true;
		}
	case LR_GuardsMeleeOnly:
		{
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr guards melee only executed");
			g_IsLRRound = true;
		}
	case LR_HHHKillRound:
		{
			ServerCommand("sm_behhh @all");
			OpenCells();
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr hhh kill round executed");
			CreateTimer(10.0, EnableFFTimer, _, TIMER_FLAG_NO_MAPCHANGE);
			g_VoidFreekills = true;
			g_IsLRRound = true;
		}
	case LR_LowGravity:
		{
			g_bIsLowGravRound = true;
			ServerCommand("sv_gravity 300");
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr low gravity round executed");
			g_IsLRRound = true;
		}
	case LR_SpeedDemon:
		{
			g_bIsSpeedDemonRound = true;
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr speed demon round executed");
			g_IsLRRound = true;
		}
	case LR_HungerGames:
		{
			OpenCells();
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr hunger games executed");
			CreateTimer(10.0, EnableFFTimer, _, TIMER_FLAG_NO_MAPCHANGE);
			g_VoidFreekills = true;
			g_IsLRRound = true;
		}
	case LR_RoboticTakeOver:
		{
			if (e_betherobot)
			{
				for (new i = 1; i <= MaxClients; i++)
				{
					if (IsValidClient(i))
					{
						g_RobotRoundClients[i] = true;
						BeTheRobot_SetRobot(i, true);
					}
				}
				CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr robotic takeover executed");
				g_IsLRRound = true;
			}
			else
			{
				LogError("Robotic Takeover cannot be executed due to lack of the Plug-in being installed, please check that the plug-in is installed and running properly.");
			}
		}
	case LR_HideAndSeek:
		{
			OpenCells();
			ServerCommand("sm_freeze @blue 45");
			CreateTimer(30.0, LockBlueteam, _, TIMER_FLAG_NO_MAPCHANGE);
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr hide and seek executed");
			g_VoidFreekills = true;
			g_IsLRRound = true;
		}
	case LR_DiscoDay:
		{
			ServerCommand("sm_disco");
			g_bIsDiscoRound = true;
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr disco day executed");
			g_IsLRRound = true;
		}
	}
	
	if (j_WardenAuto)
	{
		new RandomWarden = Client_GetRandom(CLIENTFILTER_TEAMTWO|CLIENTFILTER_ALIVE|CLIENTFILTER_NOBOTS);
		if (RandomWarden && Warden == -1)
		{
			if (IsValidClient(RandomWarden)) WardenSet(RandomWarden);
		}
	}
	return Plugin_Continue;
}

public Action:UnmuteReds(Handle:hTimer, any:client)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == _:TFTeam_Red)
		{
			UnmutePlayer(i);
		}
	}
	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "red team unmuted");
	return Plugin_Continue;
}

public Action:Open_Doors(Handle:hTimer, any:client)
{
	if (g_CellDoorTimerActive)
	{
		OpenCells();
		new time = RoundFloat(j_DoorOpenTimer);
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "cell doors open end", time);
		g_CellDoorTimerActive = false;
	}
}

public Action:LockBlueteam(Handle:hTimer, any:client)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == _:TFTeam_Red)
		{
			TF2_StunPlayer(i, 120.0, 0.0, TF_STUNFLAGS_LOSERSTATE, 0);
		}
	}
}

public Action:RoundEnd(Handle:hEvent, const String:strName[], bool:bBroadcast)
{
	if (!j_Enabled) return Plugin_Continue;

	if (GetConVarBool(Cvar_FF)) SetConVarBool(Cvar_FF, false);
	if (GetConVarBool(Cvar_COL)) SetConVarBool(Cvar_COL, false);

	if (g_VoidFreekills)	g_VoidFreekills = false;

	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			UnmutePlayer(i);
			if (g_RobotRoundClients[i])
			{
				BeTheRobot_SetRobot(i, false);
				g_RobotRoundClients[i] = false;
			}
		}
		if (g_IsFreedayActive[i])
		{
			RemoveFreeday(i);
		}
	}
	
	if (g_IsLRRound)
	{
		g_IsLRRound = false;
		enumLastRequests = LR_Disabled;
	}
	
	if (g_bIsLowGravRound)
	{
		ServerCommand("sv_gravity 800");
		g_bIsLowGravRound = false;
	}
	if (g_bIsSpeedDemonRound)
	{
		ResetPlayerSpeed();
		g_bIsSpeedDemonRound = false;
	}
	if (g_bIsDiscoRound)
	{
		ServerCommand("sm_disco");
		g_bIsDiscoRound = false;
	}
	
	g_bIsWardenLocked = true;
	FreedayLimit = 0;

	return Plugin_Continue;
}

public OnGameFrame()
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsPlayerAlive(i)) continue;
		if (g_bIsSpeedDemonRound)	SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 400.0);
		
		if (j_Enabled)
		{
			switch(j_Criticals)
			{
			case 1:
				{
					if (GetClientTeam(i) == _:TFTeam_Blue && j_Criticalstype == 2) TF2_AddCondition(i, TFCond_Kritzkrieged, 0.1);
					else if (GetClientTeam(i) == _:TFTeam_Blue) TF2_AddCondition(i, TFCond_Buffed, 0.1);
				}
			case 2:
				{
					if (GetClientTeam(i) == _:TFTeam_Red && j_Criticalstype == 2) TF2_AddCondition(i, TFCond_Kritzkrieged, 0.1);
					else if (GetClientTeam(i) == _:TFTeam_Red) TF2_AddCondition(i, TFCond_Buffed, 0.1);
				}
			case 3:
				{
					if (j_Criticalstype == 2) TF2_AddCondition(i, TFCond_Kritzkrieged, 0.1);
					else TF2_AddCondition(i, TFCond_Buffed, 0.1);
				}
			}
		}
	}
}

public OnEntityCreated(entity, const String:classname[])
{
	if (j_Enabled && IsValidEntity(entity))
	{
		if (StrContains(classname, "tf_ammo_pack", false) != -1)
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
}

public bool:OnClientSpeakingEx(client)
{
	if (e_voiceannounce_ex && j_MicCheck && !g_HasTalked[client])
	{
		g_HasTalked[client] = true;
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "microphone verified");
	}
}

public Action:InterceptBuild(client, const String:command[], args)
{
	if (!j_Enabled) return Plugin_Continue;

	if (IsValidClient(client) && GetClientTeam(client) == _:TFTeam_Red)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
public Action:Command_FireWarden(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}

	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}

	if (j_WVotesPassedLimit != 0)
	{
		if (WardenLimit < j_WVotesPassedLimit)
		{
			AttemptFireWarden(client);
		}
		else
		{
			PrintToChat(client, "You are not allowed to vote again, the warden fire limit has been reached.");
			return Plugin_Handled;
		}
	}
	else
	{
		AttemptFireWarden(client);
	}

	return Plugin_Handled;
}

AttemptFireWarden(client)
{
	if (GetClientCount(true) < j_WVotesMinPlayers)
	{
		CReplyToCommand(client, "%s %t", CLAN_TAG_COLOR, "fire warden minimum players not met");
		return;			
	}

	if (g_Voted[client])
	{
		CReplyToCommand(client, "%s %t", CLAN_TAG_COLOR, "fire warden already voted", g_Votes, g_VotesNeeded);
		return;
	}

	new String:name[64];
	GetClientName(client, name, sizeof(name));
	g_Votes++;
	g_Voted[client] = true;

	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "fire warden requested", name, g_Votes, g_VotesNeeded);

	if (g_Votes >= g_VotesNeeded)
	{
		FireWardenCall();
	}	
}

FireWardenCall()
{
	if (Warden != -1)
	{
		for (new i=1; i<=MAXPLAYERS; i++)
		{
			if (i == Warden)
			{
				WardenUnset(i);
				g_LockedFromWarden[i] = true;
			}
		}
		ResetVotes();
		g_VotesPassed++;
		WardenLimit++;
	}
}

ResetVotes()
{
	g_Votes = 0;
	
	for (new i=1; i<=MAXPLAYERS; i++)
	{
		g_Voted[i] = false;
	}
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
public Action:MapCompatibilityCheck(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	new open_cells = Entity_FindByName("open_cells", "func_button");
	new cell_door = Entity_FindByName("cell_door", "func_door");
	
	if (!client)
	{
		if (Entity_IsValid(open_cells))
		{
			PrintToServer("%s Cell Opener = Detected", CLAN_TAG);
		}
		else
		{
			PrintToServer("%s Cell Opener = Undetected", CLAN_TAG);
		}
		
		if (Entity_IsValid(cell_door))
		{
			PrintToServer("%s Cell Doors = Detected", CLAN_TAG);
		}
		else
		{
			PrintToServer("%s Cell Doors = Undetected", CLAN_TAG);
		}
	}
	else
	{
		if (Entity_IsValid(open_cells))
		{
			CPrintToChat(client, "%s Cell Opener = Detected", CLAN_TAG);
		}
		else
		{
			CPrintToChat(client, "%s Cell Opener = Undetected", CLAN_TAG);
		}
		
		if (Entity_IsValid(cell_door))
		{
			CPrintToChat(client, "%s Cell Doors = Detected", CLAN_TAG);
		}
		else
		{
			CPrintToChat(client, "%s Cell Doors = Undetected", CLAN_TAG);
		}
	}
	return Plugin_Handled;
}

public Action:AdminResetPlugin(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	g_CellDoorTimerActive = false;
	g_1stRoundFreeday = false;
	g_bIsLRInUse = false;
	g_bIsWardenLocked = false;
	g_bIsSpeedDemonRound = false;
	
	g_bIsLowGravRound = false;
	for (new i = 1; i <= MaxClients; i++)
	{
		g_RobotRoundClients[i] = false;
		g_IsMuted[i] = false;
		g_IsRebel[i] = false;
		g_IsFreeday[i] = false;
		g_IsFreedayActive[i] = false;
		g_HasTalked[i] = false;
	}
	
	Warden = -1;
	enumLastRequests = LR_Disabled;

	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "admin reset plugin");
	return Plugin_Handled;
}

public Action:AdminOpenCells(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (g_IsMapCompatible)
	{
		OpenCells();
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "incompatible map");
	}

	return Plugin_Handled;
}

public Action:AdminCloseCells(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (g_IsMapCompatible)
	{
		CloseCells();
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "incompatible map");
	}
	return Plugin_Handled;
}

public Action:AdminLockCells(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (g_IsMapCompatible)
	{
		LockCells();
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "incompatible map");
	}
	
	return Plugin_Handled;
}

public Action:AdminUnlockCells(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}

	if (g_IsMapCompatible)
	{
		UnlockCells();
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "incompatible map");
	}

	return Plugin_Handled;
}

public Action:AdminForceWarden(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}

	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}

	if (Warden == -1)
	{
		new randomplayer = Client_GetRandom(CLIENTFILTER_TEAMTWO|CLIENTFILTER_ALIVE);
		if (randomplayer)
		{
			WardenSet(randomplayer);
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "forced warden", client, randomplayer);
		}
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "current warden", Warden);
	}
	
	return Plugin_Handled;
}

public Action:AdminForceLR(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	LastRequestStart(client);
	
	return Plugin_Handled;
}

public Action:AdminDenyLR(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	g_bIsLRInUse = false;
	g_bIsWardenLocked = false;
	
	enumLastRequests = LR_Disabled;
	
	for (new i = 1; i <= MaxClients; i++)
	{
		if (g_RobotRoundClients[i])
		{
			CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "admin removed robot");
			g_RobotRoundClients[i] = false;
		}
		if (g_IsFreeday[i] || g_IsFreedayActive[i])
		{
			CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "admin removed freeday");
			g_IsFreeday[i] = false;
			g_IsFreedayActive[i] = false;
		}
	}
	
	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "admin deny lr");

	return Plugin_Handled;
}

public Action:AdminPardonFreekiller(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (j_Freekillers)
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (g_IsFreekiller[i])
			{
				SetEntityRenderColor(i, 255, 255, 255, 255);
				TF2_RegeneratePlayer(i);
				ServerCommand("sm_beacon #%d", GetClientUserId(i));
				g_IsFreekiller[i] = false;
				ClearTimer(DataTimerF);
			}
		}
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "admin pardoned freekillers");
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "freekillers system disabled");
	}
	
	return Plugin_Handled;
}

public Action:AdminGiveFreeday(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}

	new Handle:menu = CreateMenu(MenuHandlerFFAdmin, MENU_ACTIONS_ALL);
	SetMenuTitle(menu,"Choose a Player");
	AddTargetsToMenu2(menu, 0, COMMAND_FILTER_ALIVE | COMMAND_FILTER_NO_BOTS | COMMAND_FILTER_NO_IMMUNITY);
	DisplayMenu(menu, client, 20);
	
	return Plugin_Handled;
}

public MenuHandlerFFAdmin(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
	case MenuAction_Select:
		{
			decl String:info[32];
			GetMenuItem(menu, param2, info, sizeof(info));

			new target = GetClientOfUserId(StringToInt(info));
			if (target == 0)
			{
				PrintToChat(param1, "Client is not valid.");
			}
			else
			{                     
				GiveFreeday(target);
			}
		}
	case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public Action:AdminRemoveFreeday(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	new Handle:menu = CreateMenu(MenuHandlerFFRAdmin, MENU_ACTIONS_ALL);
	SetMenuTitle(menu,"Choose a Player");
	AddTargetsToMenu2(menu, 0, COMMAND_FILTER_ALIVE | COMMAND_FILTER_NO_BOTS | COMMAND_FILTER_NO_IMMUNITY);
	DisplayMenu(menu, client, 20);
	
	return Plugin_Handled;
}

public MenuHandlerFFRAdmin(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
	case MenuAction_Select:
		{
			decl String:info[32];
			GetMenuItem(menu, param2, info, sizeof(info));

			new target = GetClientOfUserId(StringToInt(info));
			if (target == 0)
			{
				PrintToChat(param1, "Client is not valid.");
			}
			else
			{                     
				RemoveFreeday(target);
			}
		}
	case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
public Action:BecomeWarden(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}

	if (!j_Warden)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "Warden disabled");
		return Plugin_Handled;
	}
	
	if (j_MicCheck && !j_MicCheckType && !g_HasTalked[client])
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "microphone check warden block");
		return Plugin_Handled;
	}
	
	if (!g_1stRoundFreeday || !g_bIsWardenLocked)
	{
		if (Warden == -1)
		{
			if (!g_LockedFromWarden[client])
			{
				if (GetClientTeam(client) == _:TFTeam_Blue)
				{
					if (IsValidClient(client) && IsPlayerAlive(client))
					{
						CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "new warden", client);
						CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "warden message");
						WardenSet(client);
					}
					else
					{
						CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "dead warden");
					}
				}
				else
				{
					CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "guards only");
				}
			}
			else
			{
				CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "voted off of warden");
			}
		}
		else
		{
			CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "current warden", Warden);
		}
	}
	else
	{
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "warden locked");
	}
	
	return Plugin_Handled;
}

public Action:WardenMenuC(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (client == Warden)
	{
		WardenMenu(client);
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "not warden");
	}

	return Plugin_Handled;
}

WardenMenu(client)
{
	new Handle:menu = CreateMenu(WardenMenuHandler);
	SetMenuTitle(menu, "Available Warden Commands:");
	AddMenuItem(menu, "1", "Open Cells");
	AddMenuItem(menu, "2", "Close Cells");
	AddMenuItem(menu, "3", "Toggle Friendlyfire");
	AddMenuItem(menu, "4", "Toggle Collision");
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, client, 30);
}

public WardenMenuHandler(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
	case MenuAction_Select:
		{
			switch (param2)
			{
			case 0:
				{
					FakeClientCommandEx(client, "say /open");
				}
			case 1:
				{
					FakeClientCommandEx(client, "say /close");
				}
			case 2:
				{
					FakeClientCommandEx(client, "say /wff");
				}
			case 3:
				{
					FakeClientCommandEx(client, "say /wcc");
				}
			}
		}
	case MenuAction_Cancel:
		{

		}
	case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public Action:WardenFriendlyFire(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}

	if (j_WardenFF)
	{
		if (client == Warden)
		{
			if (!GetConVarBool(Cvar_FF))
			{
				SetConVarBool(Cvar_FF, true);
				CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "friendlyfire enabled");
				LogMessage("%s %N has enabled friendly fire as Warden.", CLAN_TAG_COLOR, Warden);
			}
			else
			{
				SetConVarBool(Cvar_FF, false);
				CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "friendlyfire disabled");
				LogMessage("%s %N has disabled friendly fire as Warden.", CLAN_TAG_COLOR, Warden);
			}
		}
		else
		{
			CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "not warden");
		}
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "warden friendly fire manage disabled");
	}

	return Plugin_Handled;
}

public Action:WardenCollision(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (client == Warden)
	{
		if (!GetConVarBool(Cvar_COL))
		{
			SetConVarBool(Cvar_COL, true);
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "collision enabled");
			LogMessage("%s %N has enabled collision as Warden.", CLAN_TAG_COLOR, Warden);
		}
		else
		{
			SetConVarBool(Cvar_COL, false);
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "collision disabled");
			LogMessage("%s %N has disabled collision fire as Warden.", CLAN_TAG_COLOR, Warden);
		}
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "not warden");
	}

	return Plugin_Handled;
}

public Action:ExitWarden(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (client == Warden)
	{
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "warden retired", client);
		PrintCenterTextAll("%t", "warden retired center");
		WardenUnset(client);
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "not warden");
	}

	return Plugin_Handled;
}

public Action:AdminRemoveWarden(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (Warden != -1)
	{
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "warden fired", client, Warden);
		PrintCenterTextAll("%t", "warden fired center");
		WardenUnset(Warden);
	}
	else
	{
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "no warden current");
	}

	return Plugin_Handled;
}

public Action:OnOpenCommand(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (g_IsMapCompatible)
	{
		if (j_DoorControl)
		{
			if (client == Warden)
			{
				OpenCells();
			}
			else
			{
				CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "not warden");
			}
		}
		else
		{
			CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "door controls disabled");
		}
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "incompatible map");
	}

	return Plugin_Handled;
}

public Action:OnCloseCommand(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}

	if (g_IsMapCompatible)
	{
		if (j_DoorControl)
		{
			if (client == Warden)
			{
				CloseCells();
			}
			else
			{
				CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "not warden");
			}
		}
		else
		{
			CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "door controls disabled");
		}
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "incompatible map");
	}

	return Plugin_Handled;
}

public Action:GiveLR(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (!j_LRSEnabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "lr system disabled");
		return Plugin_Handled;
	}
	
	if (client == Warden)
	{
		if (!g_bIsLRInUse)
		{
			new Handle:menu = CreateMenu(GiveLRMenuHandler, MENU_ACTIONS_ALL);
			SetMenuTitle(menu,"Choose a Player:");
			AddTargetsToMenu2(menu, 0, COMMAND_FILTER_ALIVE | COMMAND_FILTER_NO_BOTS | COMMAND_FILTER_NO_IMMUNITY);
			DisplayMenu(menu, client, 20);
		}
		else
		{
			CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "last request in use");
		}
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "not warden");
	}

	return Plugin_Handled;
}

public GiveLRMenuHandler(Handle:menu, MenuAction:action, client, itemNum)
{
	switch (action)
	{
	case MenuAction_Select:
		{
			new String:info[32];
			decl String:Name[32];    
			GetMenuItem(menu, itemNum, info, sizeof(info));     
			new iInfo = StringToInt(info);
			new iUserid = GetClientOfUserId(iInfo);
			GetClientName(iUserid, Name, sizeof(Name));    
			if (GetClientTeam(iUserid) != _:TFTeam_Red)
			{
				PrintToChat(client,"You cannot give LR to a guard or spectator!");
			}
			else
			{
				LastRequestStart(iUserid);
				CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "last request given", Warden, iUserid);
			}
		}
	}
}  

public Action:RemoveLR(client, args)
{
	if (!j_Enabled)
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "plugin disabled");
		return Plugin_Handled;
	}
	
	if (!client)
	{
		ReplyToCommand(client, "%t","Command is in-game only");
		return Plugin_Handled;
	}
	
	if (client == Warden)
	{
		g_bIsLRInUse = false;
		g_bIsWardenLocked = false;
		enumLastRequests = LR_Disabled;
		g_IsFreeday[client] = false;
		g_IsFreedayActive[client] = false;
		CPrintToChat(Warden, "%s %t", CLAN_TAG_COLOR, "warden removed lr");
	}
	else
	{
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "not warden");
	}

	return Plugin_Handled;
}

WardenSet(client)
{
	Warden = client;
	SetClientListeningFlags(client, VOICE_NORMAL);
	if (j_WardenModel)
	{
		SetModel(client, "models/jailbreak/warden/warden_v2.mdl");
	}
	else
	{
		SetEntityRenderColor(client, gWardenColor[0], gWardenColor[1], gWardenColor[2], 255);
	}
	WardenMenu(client);
	Forward_OnWardenCreation(client);
	
	if (j_BlueMute == 1)
	{
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsValidClient(i) && GetClientTeam(i) == _:TFTeam_Blue && i != Warden)
			{
				MutePlayer(i);
			}
		}
	}
}

WardenUnset(client)
{
	if (Warden != -1)
	{
		Warden = -1;
		if (j_WardenModel)
		{
			RemoveModel(client);
		}
		else
		{
			SetEntityRenderColor(client, 255, 255, 255, 255);
		}
	}
	Forward_OnWardenRemoved(client);
	
	if (j_BlueMute == 1)
	{
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsValidClient(i) && GetClientTeam(i) == _:TFTeam_Blue && i != Warden)
			{
				UnmutePlayer(i);
			}
		}
	}
}

public Action:SetModel(client, const String:model[])
{
	if (IsValidClient(client) && IsPlayerAlive(client) && client == Warden && !g_HasModel[client])
	{
		SetVariantString(model);
		AcceptEntityInput(client, "SetCustomModel");
		SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
		SetWearableAlpha(client, 255);
		g_HasModel[client] = true;
	}
}
public Action:RemoveModel(client)
{
	if (IsValidClient(client) && g_HasModel[client])
	{
		SetVariantString("");
		AcceptEntityInput(client, "SetCustomModel");
		SetWearableAlpha(client, 0);
		g_HasModel[client] = false;
	}
}

stock SetWearableAlpha(client, alpha, bool:override = false)
{
	if (!override) return 0;
	new count;
	for (new z = MaxClients + 1; z <= 2048; z++)
	{
		if (!IsValidEntity(z)) continue;
		decl String:cls[35];
		GetEntityClassname(z, cls, sizeof(cls));
		if (!StrEqual(cls, "tf_wearable") && !StrEqual(cls, "tf_powerup_bottle")) continue;
		if (client != GetEntPropEnt(z, Prop_Send, "m_hOwnerEntity")) continue;
		SetEntityRenderMode(z, RENDER_TRANSCOLOR);
		SetEntityRenderColor(z, 255, 255, 255, alpha);
		count++;
	}
	return count;
}

OpenCells()
{
	for (new i = 0; i < sizeof(DoorList); i++)
	{
		new String:buffer[60], ent = -1;
		while((ent = FindEntityByClassname(ent, DoorList[i])) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", buffer, sizeof(buffer));
			if (StrEqual(buffer, "cell_door", false) || StrEqual(buffer, "cd", false))
			{
				AcceptEntityInput(ent, "Open");
			}
		}
	}
	if (g_CellDoorTimerActive)
	{
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "doors manual open");
		g_CellDoorTimerActive = false;
	}
	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "doors opened");
}

CloseCells()
{
	for (new i = 0; i < sizeof(DoorList); i++)
	{
		new String:buffer[60], ent = -1;
		while((ent = FindEntityByClassname(ent, DoorList[i])) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", buffer, sizeof(buffer));
			if (StrEqual(buffer, "cell_door", false) || StrEqual(buffer, "cd", false))
			{
				AcceptEntityInput(ent, "Close");
			}
		}
	}
	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "doors closed");
}

LockCells()
{
	for (new i = 0; i < sizeof(DoorList); i++)
	{
		new String:buffer[60], ent = -1;
		while((ent = FindEntityByClassname(ent, DoorList[i])) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", buffer, sizeof(buffer));
			if (StrEqual(buffer, "cell_door", false) || StrEqual(buffer, "cd", false))
			{
				AcceptEntityInput(ent, "Lock");
			}
		}
	}
	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "doors locked");
}

UnlockCells()
{
	for (new i = 0; i < sizeof(DoorList); i++)
	{
		new String:buffer[60], ent = -1;
		while((ent = FindEntityByClassname(ent, DoorList[i])) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", buffer, sizeof(buffer));
			if (StrEqual(buffer, "cell_door", false) || StrEqual(buffer, "cd", false))
			{
				AcceptEntityInput(ent, "Unlock");
			}
		}
	}
	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "doors unlocked");
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
LastRequestStart(client)
{
	new Handle:LRMenu = CreateMenu(MenuHandlerLR, MENU_ACTIONS_ALL);\
	decl String:buffer[100];

	SetMenuTitle(LRMenu, "Last Request Menu");

	Format(buffer, sizeof(buffer), "%T", "menu Freeday for yourself", client);
	AddMenuItem(LRMenu, "0", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Freeday for you and others", client);
	AddMenuItem(LRMenu, "1", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Freeday for all", client);
	AddMenuItem(LRMenu, "2", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Commit Suicide", client);
	AddMenuItem(LRMenu, "3", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Guards Melee Only Round", client);
	AddMenuItem(LRMenu, "4", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu HHH Kill Round", client);
	AddMenuItem(LRMenu, "5", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Low Gravity Round", client);
	AddMenuItem(LRMenu, "6", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Speed Demon Round", client);
	AddMenuItem(LRMenu, "7", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Hunger Games", client);
	AddMenuItem(LRMenu, "8", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Robotic Takeover", client);
	if (e_betherobot)	AddMenuItem(LRMenu, "9", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Hide & Seek", client);
	AddMenuItem(LRMenu, "10", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Disco Day", client);
	AddMenuItem(LRMenu, "11", buffer);
	Format(buffer, sizeof(buffer), "%T", "menu Custom Request", client);
	AddMenuItem(LRMenu, "12", buffer);
	
	SetMenuExitButton(LRMenu, true);
	DisplayMenu(LRMenu, client, 30 );
}

public MenuHandlerLR(Handle:LRMenu, MenuAction:action, client, item)
{
	switch(action)
	{
	case MenuAction_Display:
		{
			g_bIsLRInUse = true;
			CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "warden granted lr");
		}
	case MenuAction_Select:
		{
			switch (item)
			{
			case 0:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr freeday queued", client);
					enumLastRequests = LR_PersonalFreeday;
					g_IsFreeday[client] = true;
				}
			case 1:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr freeday picking clients", client);
					enumLastRequests = LR_FreedayForClients;
					FreedayforClientsMenu(client);
				}
			case 2:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr free for all queued", client);
					enumLastRequests = LR_FreedayForAll;
				}
			case 3:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr suicide", client);
					ForcePlayerSuicide(client);
				}
			case 4:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr guards melee only queued", client);
					enumLastRequests = LR_GuardsMeleeOnly;
				}
			case 5:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr hhh kill round queued", client);
					enumLastRequests = LR_HHHKillRound;
				}
			case 6:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr low gravity round queued", client);
					enumLastRequests = LR_LowGravity;
				}
			case 7:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr speed demon round queued", client);
					enumLastRequests = LR_SpeedDemon;
				}
			case 8:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr hunger games queued", client);
					enumLastRequests = LR_HungerGames;
				}
			case 9:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr robotic takeover queued", client);
					enumLastRequests = LR_RoboticTakeOver;
				}
			case 10:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr hide and seek queued", client);
					enumLastRequests = LR_HideAndSeek;
				}
			case 11:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr disco day queued", client);
					enumLastRequests = LR_DiscoDay;
				}
			case 12:
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr custom message", client);
				}
			}
			g_bIsWardenLocked = true;
		}
	case MenuAction_Cancel:
		{
			g_bIsLRInUse = false;
			CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "last request closed");
		}
	case MenuAction_End:
		{
			CloseHandle(LRMenu);
		}
	}
}

FreedayforClientsMenu(client)
{
	new Handle:menu = CreateMenu(FreedayForClientsMenu_H, MENU_ACTIONS_ALL);

	SetMenuTitle(menu, "Choose a Player");
	SetMenuExitBackButton(menu, true);
	
	AddTargetsToMenu2(menu, 0, COMMAND_FILTER_NO_BOTS | COMMAND_FILTER_NO_IMMUNITY);
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public FreedayForClientsMenu_H(Handle:menu, MenuAction:action, client, param2)
{
	switch(action)
	{
	case MenuAction_End:
		{
			CloseHandle(menu);
		}
	case MenuAction_Select:
		{
			decl String:info[32];
			GetMenuItem(menu, param2, info, sizeof(info));
			
			new target = GetClientOfUserId(StringToInt(info));

			if (target == 0)
			{
				PrintToChat(client, "[JODC] %T", "Player no longer available", LANG_SERVER);
			}
			else
			{
				if (FreedayLimit < j_FreedayLimit)
				{
					g_IsFreeday[target] = true;
					FreedayLimit++;
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr freeday picked clients", client, target);
					if (IsValidClient(client) && !IsClientInKickQueue(client))
					{
						FreedayforClientsMenu(client);
					}
				}
				else
				{
					CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr freeday picked clients maxed", client);
				}
			}
		}
	}
}

GiveFreeday(client)
{
	SetEntProp(client, Prop_Data, "m_takedamage", 0, 1);
	SetEntityRenderColor(client, gFreedayColor[0], gFreedayColor[1], gFreedayColor[2], 255);
	CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "lr freeday message");
	new flags = GetEntityFlags(client)|FL_NOTARGET;
	SetEntityFlags(client, flags);
	ServerCommand("sm_evilbeam #%d", GetClientUserId(client));
	g_IsFreeday[client] = false;
	g_IsFreedayActive[client] = true;
}

RemoveFreeday(client)
{
	SetEntProp(client, Prop_Data, "m_takedamage", 2);
	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "lr freeday lost", client);
	PrintCenterTextAll("%t", "lr freeday lost center", client);
	new flags = GetEntityFlags(client)&~FL_NOTARGET;
	SetEntityFlags(client, flags);
	SetEntityRenderColor(client, 255, 255, 255, 255);
	ServerCommand("sm_evilbeam #%d", GetClientUserId(client));
	g_IsFreedayActive[client] = false;
}

stock ResetPlayerSpeed()
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsPlayerAlive(i)) continue;
		new TFClassType:class = TF2_GetPlayerClass(i);
		switch(class)
		{
		case TFClass_DemoMan: SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 280.0);
		case TFClass_Engineer: SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 300.0);
		case TFClass_Heavy: SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 230.0);
		case TFClass_Medic: SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 320.0);
		case TFClass_Pyro: SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 300.0);
		case TFClass_Scout: SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 400.0);
		case TFClass_Sniper: SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 300.0);
		case TFClass_Soldier: SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 240.0);
		case TFClass_Spy: SetEntPropFloat(i, Prop_Data, "m_flMaxspeed", 300.0);
		}
	}
}

public Action:EnableFFTimer(Handle:hTimer)
{
	SetConVarBool(Cvar_FF, true);
}

MarkRebel(client)
{
	g_IsRebel[client] = true;
	SetEntityRenderColor(client, gRebelColor[0], gRebelColor[1], gRebelColor[2], 255);
	CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "prisoner has rebelled", client);
	if (j_RebelsTime >= 1.0)
	{
		new time = RoundFloat(j_RebelsTime);
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "rebel timer start", time);
		CreateTimer(j_RebelsTime, RemoveRebel, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:RemoveRebel(Handle:hTimer, any:client)
{
	if (IsValidClient(client) && GetClientTeam(client) != 1 && IsPlayerAlive(client))
	{
		g_IsRebel[client] = false;
		SetEntityRenderColor(client, 255, 255, 255, 255);
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "rebel timer end");
	}
}

MarkFreekiller(client)
{
	g_IsFreekiller[client] = true;
	TF2_RemoveAllWeapons(client);
	ServerCommand("sm_beacon #%d", GetClientUserId(client));
	EmitSoundToAll("ui/system_message_alert.wav", _, _, _, _, 1.0, _, _, _, _, _, _);
	if (j_FreekillersWave >= 1.0)
	{
		new time = RoundFloat(j_FreekillersWave);
		CPrintToChatAll("%s %t", CLAN_TAG_COLOR, "freekiller timer start", client, time);

		decl String:sAuth[24];
		new Handle:hPack;
		DataTimerF = CreateDataTimer(j_FreekillersWave, BanClientTimerFreekiller, hPack);
		WritePackCell(hPack, client);
		WritePackCell(hPack, GetClientUserId(client));
		WritePackString(hPack, sAuth);
		if (DataTimerF != INVALID_HANDLE) PushArrayCell(hPack, DataTimerF);
	}
}

public Action:BanClientTimerFreekiller(Handle:hTimer, Handle:hPack)
{
	new iPosition;
	if ((iPosition = FindValueInArray(g_hArray_Pending, hTimer) != -1))
	RemoveFromArray(g_hArray_Pending, iPosition);

	ResetPack(hPack);
	new client = ReadPackCell(hPack);
	new userid = ReadPackCell(hPack);
	new String:sAuth[24];
	ReadPackString(hPack, sAuth, sizeof(sAuth));

	switch (j_FreekillersAction)
	{
	case 0:
		{
			if (IsValidClient(client))
			{
				g_IsFreekiller[client] = false;
				TF2_RegeneratePlayer(client);
				ServerCommand("sm_beacon #%d", GetClientUserId(client));
			}
		}
	case 1:
		{
			if (IsValidClient(client))
			{
				ForcePlayerSuicide(client);
				g_IsFreekiller[client] = false;
			}
		}
	case 2:
		{
			if (GetClientOfUserId(userid))
			{
				decl String:BanMsg[100];
				GetConVarString(JB_Cvar_Freekillers_BanMSG, BanMsg, sizeof(BanMsg));
				if (e_sourcebans) SBBanPlayer(0, client, 60, "Client has been marked for Freekilling.");
				else if (e_basebans) BanClient(client, j_FreekillersBantime, BANFLAG_AUTHID, "Client has been marked for Freekilling.", BanMsg, "freekillban", client);
			}
			else
			{
				decl String:BanMsgDC[100];
				GetConVarString(JB_Cvar_Freekillers_BanMSGDC, BanMsgDC, sizeof(BanMsgDC));
				BanIdentity(sAuth, j_FreekillersBantimeDC, BANFLAG_AUTHID, BanMsgDC);
			}
		}
	}
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
MapCheck()
{
	new open_cells = Entity_FindByName("open_cells", "func_button");
	new cell_door = Entity_FindByName("cell_door", "func_door");
	if (Entity_IsValid(open_cells) && Entity_IsValid(cell_door))
	{
		g_IsMapCompatible = true;
		LogMessage("%s The current map has passed all compatibility checks, plugin may proceed.", CLAN_TAG);
	}
	else
	{
		g_IsMapCompatible = false;
		LogError("The current map is incompatible with this plugin. Please verify the map or change it.");
		LogError("Feel free to type !compatible in chat to check the map manually.");
	}
}

stock MutePlayer(client)
{
	if (!AlreadyMuted(client) && !Client_HasAdminFlags(client, ADMFLAG_RESERVATION|ADMFLAG_RESERVATION) && !g_IsMuted[client])
	{
		Client_Mute(client);
		g_IsMuted[client] = true;
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "muted player");
	}
}

stock UnmutePlayer(client)
{
	if (!AlreadyMuted(client) && !Client_HasAdminFlags(client, ADMFLAG_RESERVATION|ADMFLAG_RESERVATION) && g_IsMuted[client])
	{
		Client_UnMute(client);
		g_IsMuted[client] = false;
		CPrintToChat(client, "%s %t", CLAN_TAG_COLOR, "unmuted player");
	}
}

stock bool:AlreadyMuted(client)
{
	if (e_sourcecomms)
	{
		if (SourceComms_GetClientMuteType(client) == bNot) return false;
		else return true;
	}
	else if (e_basecomm)
	{
		if (!BaseComm_IsClientMuted(client)) return false;
		else return true;
	}
	return false;
}

stock AddServerTag2(const String:tag[])
{
	new Handle:hTags = INVALID_HANDLE;
	hTags = FindConVar("sv_tags");
	if (hTags != INVALID_HANDLE)
	{
		decl String:tags[256];
		GetConVarString(hTags, tags, sizeof(tags));
		if (StrContains(tags, tag, true) > 0) return;
		if (strlen(tags) == 0)
		{
			Format(tags, sizeof(tags), tag);
		}
		else
		{
			Format(tags, sizeof(tags), "%s,%s", tags, tag);
		}
		SetConVarString(hTags, tags, true);
	}
}

stock RemoveServerTag2(const String:tag[])
{
	new Handle:hTags = INVALID_HANDLE;
	hTags = FindConVar("sv_tags");
	if (hTags != INVALID_HANDLE)
	{
		decl String:tags[50];
		GetConVarString(hTags, tags, sizeof(tags));
		if (StrEqual(tags, tag, true))
		{
			Format(tags, sizeof(tags), "");
			SetConVarString(hTags, tags, true);
			return;
		}
		new pos = StrContains(tags, tag, true);
		new len = strlen(tags);
		if (len > 0 && pos > -1)
		{
			new bool:found;
			new String:taglist[50][50];
			ExplodeString(tags, ",", taglist, sizeof(taglist[]), sizeof(taglist));
			for (new i; i < sizeof(taglist[]); i++)
			{
				if (StrEqual(taglist[i], tag, true))
				{
					Format(taglist[i], sizeof(taglist), "");
					found = true;
					break;
				}
			}
			if (!found) return;
			ImplodeStrings(taglist, sizeof(taglist[]), ",", tags, sizeof(tags));
			if (pos == 0)
			{
				tags[0] = 0x20;
			}
			else if (pos == len-1)
			{
				Format(tags[strlen(tags)-1], sizeof(tags), "");
			}
			else
			{
				ReplaceString(tags, sizeof(tags), ",,", ",");
			}
			SetConVarString(hTags, tags, true);
		}
	}
}

stock IsValidClient(client, bool:replaycheck = true)
{
	if (client <= 0 || client > MaxClients || !IsClientInGame(client) || GetEntProp(client, Prop_Send, "m_bIsCoaching") || IsFakeClient(client) || !IsValidEntity(client))
	{
		return false;
	}
	if (replaycheck)
	{
		if (IsClientSourceTV(client) || IsClientReplay(client))
		{
			return false;
		}
	}
	return true;
}

stock SetClip(client, wepslot, newAmmo, admin)
{
	new weapon = GetPlayerWeaponSlot(client, wepslot);
	if (IsValidEntity(weapon))
	{
		new iAmmoTable = FindSendPropInfo("CTFWeaponBase", "m_iClip1");
		SetEntData(weapon, iAmmoTable, newAmmo, 4, true);
	}
}

stock SetAmmo(client, wepslot, newAmmo, admin)
{
	new weapon = GetPlayerWeaponSlot(client, wepslot);
	if (IsValidEntity(weapon))
	{
		new iOffset = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType", 1)*4;
		new iAmmoTable = FindSendPropInfo("CTFPlayer", "m_iAmmo");
		SetEntData(client, iAmmoTable+iOffset, newAmmo, 4, true);
	}
}

stock ClearTimer(&Handle:hTimer)
{
	if(hTimer != INVALID_HANDLE)
	{
		KillTimer(hTimer);
		hTimer = INVALID_HANDLE;
	}
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
public bool:WardenGroup(const String:strPattern[], Handle:hClients)
{
	for (new i = 1; i <= MaxClients; i ++)
	{
		if (IsValidClient(i) && Warden != -1 && i == Warden)
		{
			PushArrayCell(hClients, i);
		}
	}
	return true;
}

public bool:NotWardenGroup(const String:strPattern[], Handle:hClients)
{
	for (new i = 1; i <= MaxClients; i ++)
	{
		if (IsValidClient(i) && Warden != -1 && i != Warden)
		{
			PushArrayCell(hClients, i);
		}
	}
	return true;
}

public bool:RebelsGroup(const String:strPattern[], Handle:hClients)
{
	for (new i = 1; i <= MaxClients; i ++)
	{
		if (IsValidClient(i) && g_IsRebel[i])
		{
			PushArrayCell(hClients, i);
		}
	}
	return true;
}

public bool:NotRebelsGroup(const String:strPattern[], Handle:hClients)
{
	for (new i = 1; i <= MaxClients; i ++)
	{
		if (IsValidClient(i) && !g_IsRebel[i])
		{
			PushArrayCell(hClients, i);
		}
	}
	return true;
}

public bool:FreedaysGroup(const String:strPattern[], Handle:hClients)
{
	for (new i = 1; i <= MaxClients; i ++)
	{
		if (IsValidClient(i) && g_IsFreeday[i] || IsValidClient(i) && g_IsFreedayActive[i])
		{
			PushArrayCell(hClients, i);
		}
	}
	return true;
}

public bool:NotFreedaysGroup(const String:strPattern[], Handle:hClients)
{
	for (new i = 1; i <= MaxClients; i ++)
	{
		if (IsValidClient(i) && !g_IsFreeday[i] || IsValidClient(i) && !g_IsFreedayActive[i])
		{
			PushArrayCell(hClients, i);
		}
	}
	return true;
}


public Native_ExistWarden(Handle:plugin, numParams)
{
	if (Warden != -1) return true;
	return false;
}

public Native_IsWarden(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!IsClientInGame(client) && !IsClientConnected(client))
	ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);
	
	if (client == Warden) return true;
	return false;
}

public Native_SetWarden(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!IsClientInGame(client) && !IsClientConnected(client))
	ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);
	
	if (Warden == -1) WardenSet(client);
}

public Native_RemoveWarden(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!IsClientInGame(client) && !IsClientConnected(client))
	ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);
	
	if (client == Warden) WardenUnset(client);
}

public Native_IsFreeday(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!IsClientInGame(client) && !IsClientConnected(client))
	ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);
	
	if (g_IsFreeday[client] || g_IsFreedayActive[client]) return true;
	return false;
}

public Native_GiveFreeday(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!IsClientInGame(client) && !IsClientConnected(client))
	ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);
	
	if (!g_IsFreeday[client] || !g_IsFreedayActive[client]) GiveFreeday(client);
}

public Native_IsRebel(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!IsClientInGame(client) && !IsClientConnected(client))
	ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);
	
	if (g_IsRebel[client]) return true;
	return false;
}

public Native_MarkRebel(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!IsClientInGame(client) && !IsClientConnected(client))
	ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);
	
	if (!g_IsRebel[client]) MarkRebel(client);
}

public Native_IsFreekiller(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!IsClientInGame(client) && !IsClientConnected(client))
	ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);
	
	if (g_IsFreekiller[client]) return true;
	return false;
}

public Native_MarkFreekill(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!IsClientInGame(client) && !IsClientConnected(client))
	ThrowNativeError(SP_ERROR_INDEX, "Client index %i is invalid", client);
	
	if (!g_IsFreekiller[client]) MarkFreekiller(client);
}

public Forward_OnWardenCreation(client)
{
	Call_StartForward(g_fward_onBecome);
	Call_PushCell(client);
	Call_Finish();
}

public Forward_OnWardenRemoved(client)
{
	Call_StartForward(g_fward_onRemove);
	Call_PushCell(client);
	Call_Finish();
}