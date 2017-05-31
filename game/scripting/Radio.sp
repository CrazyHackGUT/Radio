#include <sourcemod>

#pragma newdecls required

#define RADIO_TIMER TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE
#define PLYCOUNT    MAXPLAYERS + 1

public Plugin myinfo = { url = "https://kruzefag.ru/", name = "Radio", author = "CrazyHackGUT aka Kruzya", version = "1.3.1 RC4", description = "Radio plugin for all Source games"};

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
#include "Radio/Game.sp"
#include "Radio/Menu.sp"

public void OnPluginStart() {
    LoadTranslations("Radio.phrases");
    Game_DetectEngine();
    RegisterCommands();
    Events_Hook();

    g_bFirstStart = true;
}

public void OnMapStart() {
    ReadConfig();

    // Some scratch.
    if (g_bFirstStart) {
        for (int iClient = 1; iClient <= MaxClients; iClient++)
            ClearSettings(iClient);
        g_bFirstStart = false;
    }

    if (g_fAdvertTime >= 1.0)
        CreateTimer(g_fAdvertTime, NowPlaying, _, RADIO_TIMER);
    if (g_fMOTDChecker >= 1.0)
        CreateTimer(g_fMOTDChecker,  QueryMOTD,  _, RADIO_TIMER);
}

void ClearSettings(int iClient) {
    MOTD_SetState(iClient, Unknown);
    g_iSelected[iClient]    = -1;
    g_bSilence[iClient]     = false;
    g_iVolume[iClient]      = g_iDefaultVolume;
}

public void OnClientPutInServer(int iClient) {
    if (IsFakeClient(iClient))
        return;

    MOTD_Check(iClient);
    if (g_iSelected[iClient] != -1 && !g_bSilence[iClient])
        CreateTimer(5.0, ReEnableRadio, iClient);
}

public Action ReEnableRadio(Handle hTimer, int iClient) {
    if (MOTD_GetState(iClient) == Enabled)
        MusicManager_SendUpdate(iClient, g_iSelected[iClient], g_iVolume[iClient]);
}

public Action NowPlaying(Handle hTimer) {
    char szBuffer[128];

    for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++) {
        if (IsClientInGame(iPlayer) && !IsFakeClient(iPlayer) && !g_bSilence[iPlayer]) {
            if (g_iSelected[iPlayer] >= 0 && MusicManager_GetStationByID(g_iSelected[iPlayer], _, _, szBuffer, sizeof(szBuffer)))
                PrintToChat(iPlayer, "[Radio] %t", "NowPlaying", szBuffer, g_iVolume[iPlayer]);
            else
                PrintToChat(iPlayer, "[Radio] %t", "UseRadioCommand");
        }
    }
}

public Action QueryMOTD(Handle hTimer) {
    for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
        if (IsClientInGame(iPlayer) && !IsFakeClient(iPlayer) && MOTD_GetState(iPlayer) != Processing)
            MOTD_Check(iPlayer);
}
