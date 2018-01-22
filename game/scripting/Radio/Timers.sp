static Handle   g_hAdvertTimer;
static Handle   g_hMotdTimer;

void Timers_Restart() {
    Timers_Stop();
    Timers_Start();
}

void Timers_Start() {
    if (g_fAdvertTime >= 1.0)
        g_hAdvertTimer = CreateTimer(g_fAdvertTime, NowPlaying, _, RADIO_TIMER);
    if (g_fMOTDChecker >= 1.0)
        g_hMotdTimer = CreateTimer(g_fMOTDChecker,  QueryMOTD,  _, RADIO_TIMER);
}

void Timers_Stop() {
    if (g_hAdvertTimer != null) {
        KillTimer(g_hAdvertTimer);
    }
    if (g_hMotdTimer != null) {
        KillTimer(g_hMotdTimer);
    }
}

void Timers_OnMapEnd() {
    g_hAdvertTimer = g_hMotdTimer = null;
}

public Action NowPlaying(Handle hTimer) {
    char szBuffer[128];

    for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++) {
        if (IsClientInGame(iPlayer) && !IsFakeClient(iPlayer) && !g_bSilence[iPlayer]) {
            if (g_iSelected[iPlayer] >= 0 && MusicManager_GetStationByID(g_iSelected[iPlayer], _, _, szBuffer, sizeof(szBuffer)))
                PrintToChat(iPlayer, "%t%t", "ChatPrefix", "NowPlaying", szBuffer, g_iVolume[iPlayer]);
            else
                PrintToChat(iPlayer, "%t%t", "ChatPrefix", "UseRadioCommand");
        }
    }
}

public Action QueryMOTD(Handle hTimer) {
    for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
        if (IsClientInGame(iPlayer) && !IsFakeClient(iPlayer) && MOTD_GetState(iPlayer) != Processing)
            MOTD_Check(iPlayer);
}
