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
