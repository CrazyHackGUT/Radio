#include <sourcemod>

#pragma newdecls required

#define RADIO_TIMER TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE
#define PLYCOUNT    MAXPLAYERS + 1

#define GAME_UNKNOWN    0
#define GAME_ORANGEBOX  1
#define GAME_CSGO       2
#define GAME_OLD        3

public Plugin myinfo = { url = "https://kruzefag.ru/", name = "Radio", author = "CrazyHackGUT aka Kruzya", version = "1.3.1 RC6", description = "Radio plugin for all Source games"};

/**
 * Global settings for all players
 */
int         g_iSelected[PLYCOUNT];
bool        g_bSilence[PLYCOUNT];
int         g_iVolume[PLYCOUNT];

/**
 * Config Values
 */
char        g_szWebScript[256]; // web-script url
ArrayList   g_hRadioStations;   // array with datapacks with stations
int         g_iDefaultVolume;   // default volume for all clients
float       g_fMOTDChecker;     // Periodic time for MOTD checker
float       g_fAdvertTime;      // Advert periodic time
bool        g_bFirstStart;      // scratch var.
int         g_iStepSize;        // step size in Volume menu.
                                // HERE

#include "Radio/MusicManager.sp"
#include "Radio/DisableMOTD.sp"
#include "Radio/Commands.sp"
#include "Radio/Config.sp"
#include "Radio/Events.sp"
#include "Radio/Timers.sp"
#include "Radio/Game.sp"
#include "Radio/Menu.sp"
#include "Radio/UTIL.sp"
