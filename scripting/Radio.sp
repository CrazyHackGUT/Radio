#include <sourcemod>

#pragma newdecls required
#define PLYCOUNT    MAXPLAYERS + 1 

public Plugin myinfo = { url = "https://kruzefag.ru/", name = "Radio", author = "CrazyHackGUT aka Kruzya", version = "1.1", description = "Radio plugin for all Source games"};

/**
 * Global settings for all players
 */
int         g_iSelected[PLYCOUNT];
bool        g_bSilence[PLYCOUNT];
int         g_iVolume[PLYCOUNT] = { 100, ... };

/**
 * Config Values
 */
char        g_szWebScript[256];
StringMap   g_hRadioStations;
int         g_iDefaultVolume;
int         g_iStepSize;

#include "Radio/MusicManager.sp"
#include "Radio/Commands.sp"
#include "Radio/Config.sp"
#include "Radio/Menu.sp"

public void OnPluginStart() {
    LoadTranslations("Radio.phrases");
    RegisterCommands();
}

public void OnMapStart() {
    ReadConfig();

    for (int iClient = 1; iClient <= MaxClients; iClient++)
        if (IsClientInGame(iClient) && !IsFakeClient(iClient) && IsClientAuthorized(iClient))
            OnClientAuthorized(iClient, NULL_STRING);

    CreateTimer(180.0, NowPlaying, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void OnClientAuthorized(int iClient, const char[] szAuth) {
    g_iSelected[iClient]    = -1;
    g_bSilence[iClient]     = false;
    g_iVolume[iClient]      = g_iDefaultVolume;
}

public Action NowPlaying(Handle hTimer) {
    char szBuffer[128];

    for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++) {
        if (IsClientInGame(iPlayer) && !IsFakeClient(iPlayer) && IsClientAuthorized(iPlayer) && !g_bSilence[iPlayer]) {
            if (g_iSelected[iPlayer] >= 0 && MusicManager_GetClientStationName(iPlayer, szBuffer, sizeof(szBuffer)))
                PrintToChat(iPlayer, "[Radio] %t", "NowPlaying", szBuffer, g_iVolume[iPlayer]);
            else
                PrintToChat(iPlayer, "[Radio] %t", "UseRadioCommand");
        }
    }
}
