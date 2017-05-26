void Events_Hook() {
    if (!HookEventEx("player_connect", OnPlayerConnect, EventHookMode_Post) && !HookEventEx("player_connect_client", OnPlayerConnect, EventHookMode_Post)) {
        Events_NotFoundEvent("PlayerConnect", "Unsupported engine");
    }

    if (!HookEventEx("player_team", OnPlayerChangeTeam, EventHookMode_Pre)) {
        Events_NotFoundEvent("PlayerTeam", "This is not server");
    }
}

void Events_NotFoundEvent(const char[] szEvent, const char[] szCommentary = "Unsupported game") {
    SetFailState("[Radio] Couldn't hook %s event. %s. Report this incident to developer: https://steamcommunity.com/profiles/76561198071596952/", szEvent, szCommentary);
}

/**
 * Events.
 */
public void OnPlayerConnect(Event hEvent, const char[] szEventName, bool bDontBroadcast) {
    ClearSettings(hEvent.GetInt("index"));
}

public void OnPlayerChangeTeam(Event hEvent, const char[] szEventName, bool bDontBroadcast) {
    if (!hEvent.GetBool("disconnect"))
        return;

    MusicManager_SendUpdate(GetClientOfUserId(hEvent.GetInt("index")), -1, 0);
}