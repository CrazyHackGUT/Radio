enum CV_State {
    Unknown     = 0,
    Processing  = 1,

    Enabled     = 2,
    Disabled    = 3
}

CV_State g_eMOTDState[PLYCOUNT] = { Unknown, ... };

void MOTD_Check(int iClient) {
    if (Game_GetEngine() == GAME_OLD) {
        // CSS v34 don't have client variable cl_disablehtmlmotd. Thanks, @will_rock and @Meowmurmur.
        MOTD_SetState(iClient, Enabled);
        return;
    }

    if (QueryClientConVar(iClient, "cl_disablehtmlmotd", MOTD_OnQueryFinished) != QUERYCOOKIE_FAILED) {
        MOTD_SetState(iClient, Processing);
    } else {
        MOTD_SetState(iClient, Unknown);
    }
}

public void MOTD_OnQueryFinished(QueryCookie hCookie, int iClient, ConVarQueryResult eResult, const char[] szCvarName, const char[] szCvarValue) {
    if (eResult != ConVarQuery_Okay) {
        MOTD_SetState(iClient, Unknown);
        return;
    }

    MOTD_SetState(iClient, ( (szCvarValue[0] == '1') ? Disabled : Enabled ));
}

CV_State MOTD_GetState(int iClient) {
    return (Game_GetEngine() != GAME_OLD) ? g_eMOTDState[iClient] : Enabled;
}

void MOTD_SetState(int iClient, CV_State eNewState) {
    g_eMOTDState[iClient] = eNewState;
}
