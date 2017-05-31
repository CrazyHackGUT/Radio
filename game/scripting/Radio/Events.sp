void Events_Hook() {
    if (!HookEventEx("player_connect", OnGameEventFired, EventHookMode_Post) && !HookEventEx("player_connect_client", OnGameEventFired, EventHookMode_Post)) {
        Events_NotFoundEvent("PlayerConnect", "Unsupported engine");
    }

    if (!HookEventEx("player_team", OnGameEventFired, EventHookMode_Post)) {
        Events_NotFoundEvent("PlayerTeam", "What the fuck?!? https://wiki.alliedmods.net/Generic_Source_Events#player_team");
    }
}

void Events_NotFoundEvent(const char[] szEvent, const char[] szCommentary = "Unsupported game") {
    SetFailState("[Radio] Couldn't hook %s event. %s. Report this incident to developer: https://steamcommunity.com/profiles/76561198071596952/", szEvent, szCommentary);
}

/**
 * Game Events.
 */
public void OnGameEventFired(Event hEvent, const char[] szEventName, bool bDontBroadcast) {
    switch (szEventName[7]) {
        case 'c': {
            UTIL_ClearSettings(hEvent.GetInt("index"));
        }

        case 't': {
            int iClient = GetClientOfUserId(hEvent.GetInt("userid"));

            if (!IsFakeClient(iClient) && hEvent.GetInt("oldteam") == 0 && g_iSelected[iClient] != -1 && !g_bSilence[iClient] && MOTD_GetState(iClient) == Enabled) {
                MusicManager_SendUpdate(iClient, g_iSelected[iClient], g_iVolume[iClient]);
            }
        }
    }
}

/**
 * SourceMod Events.
 */
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
            UTIL_ClearSettings(iClient);
        g_bFirstStart = false;
    }

    if (g_fAdvertTime >= 1.0)
        CreateTimer(g_fAdvertTime, NowPlaying, _, RADIO_TIMER);
    if (g_fMOTDChecker >= 1.0)
        CreateTimer(g_fMOTDChecker,  QueryMOTD,  _, RADIO_TIMER);
}

public void OnClientPutInServer(int iClient) {
    if (IsFakeClient(iClient))
        return;

    MOTD_Check(iClient);
}
