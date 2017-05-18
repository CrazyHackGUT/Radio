#include <sourcemod>

#pragma newdecls required
#define PLYCOUNT    MAXPLAYERS + 1 

public Plugin myinfo = { url = "https://kruzefag.ru/", name = "Radio", author = "CrazyHackGUT aka Kruzya", version = "0.3", description = "Radio plugin for all Source games"};

StringMap   g_hRadioStations;
bool        g_bSilence[PLYCOUNT];
int         g_iSelected[PLYCOUNT];
int         g_iVolume[PLYCOUNT];

/**
 * Config Values
 */
char        g_szWebScript[256];
int         g_iStepSize;

#include "Radio/MusicManager.sp"
#include "Radio/Commands.sp"
#include "Radio/Config.sp"
#include "Radio/Menu.sp"

public void OnPluginStart() {
    RegisterCommands();
}

public void OnMapStart() {
    LoadConfig();
}