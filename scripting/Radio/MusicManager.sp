bool MusicManager_GetStationByID(int iID, char[] szURL = "", int iMaxURLLength = 0, char[] szName = "", int iMaxNameLength = 0, int iClient = -1) {
    if (iID < 0) {
        szURL[0] = 0;
        szName[0] = 0;

        if (iClient > 0) {
            FormatEx(szName, iMaxNameLength, "%T", "StationNone", iClient);
        }
        return true;
    }

    if (iID >= g_hRadioStations.Length) {
        return false;
    }

    DataPack hPack = g_hRadioStations.Get(iID);
    hPack.Reset();
    hPack.ReadString(szURL, iMaxURLLength);
    hPack.ReadString(szName, iMaxNameLength);
    return true;
}

bool MusicManager_ChangeStationMem(int iClient, int iID) {
    if (iID >= g_hRadioStations.Length) {
        return false;
    }

    g_iSelected[iClient] = iID;
    return true;
}

bool MusicManager_ChangeStation(int iClient, int iID) {
    if (!MusicManager_ChangeStationMem(iClient, iID))
        return false;

    char szBuffer[256];

    MusicManager_GetStationByID(g_iSelected[iClient], szBuffer, sizeof(szBuffer));
    Format(szBuffer, sizeof(szBuffer), "%s#ChangeStation=%s", g_szWebScript, szBuffer);

    UTIL_SendLink(iClient, NULL_STRING, szBuffer, false);
    return true;
}

void MusicManager_SetSoundState(int iClient, bool bState) {
    char szBuffer[256];
    Format(szBuffer, sizeof(szBuffer), "%s#TurnO%s", g_szWebScript, bState ? "n" : "ff");

    UTIL_SendLink(iClient, NULL_STRING, szBuffer, false);
}

void MusicManager_SetVolume(int iClient, int iVolume) {
    char szBuffer[256];
    Format(szBuffer, sizeof(szBuffer), "%s#Volume=%d", g_szWebScript, iVolume);

    UTIL_SendLink(iClient, NULL_STRING, szBuffer, false);
}

public Action MusicManager_SendVolume(Handle hTimer, any iClient) {
    if (IsClientInGame(iClient) && !IsFakeClient(iClient) && !g_bSilence[iClient])
        MusicManager_SetVolume(iClient, g_iVolume[iClient]);
}

void UTIL_SendLink(const int iClient, const char[] szTitle, const char[] szURL, bool bVisible = true) {
    KeyValues hData = new KeyValues("data");

    hData.SetNum("type", MOTDPANEL_TYPE_URL);
    hData.SetString("title", szTitle);
    hData.SetString("msg", szURL);

    ShowVGUIPanel(iClient, "info", hData, bVisible);
    delete hData;
}
