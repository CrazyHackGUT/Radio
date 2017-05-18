bool MusicManager_GetClientStationName(int iClient, char[] szOutput, int iMaxLength) {
    if (g_iSelected[iClient] < 0) {
        FormatEx(szOutput, iMaxLength, "%T", "StationNone", iClient);
        return true;
    }

    StringMapSnapshot hSnapshot = g_hRadioStations.Snapshot();
    if (hSnapshot.Length <= g_iSelected[iClient]) {
        delete hSnapshot;
        return false;
    }

    int iBytes = hSnapshot.GetKey(g_iSelected[iClient], szOutput, iMaxLength);
    delete hSnapshot;

    return (iBytes > 0);
}

bool MusicManager_GetClientStationURL(int iClient, char[] szOutput, int iMaxLength) {
    if (!MusicManager_GetClientStationName(iClient, szOutput, iMaxLength))
        return false;

    return g_hRadioStations.GetString(szOutput, szOutput, iMaxLength);
}

bool MusicManager_ChangeStationMem(int iClient, int iID) {
    StringMapSnapshot hSnapshot = g_hRadioStations.Snapshot();
    int iLength = hSnapshot.Length;
    delete hSnapshot;

    if (iID >= iLength) {
        return false;
    }

    g_iSelected[iClient] = iID;
    return true;
}

bool MusicManager_ChangeStation(int iClient, int iID) {
    if (!MusicManager_ChangeStationMem(iClient, iID))
        return false;

    char szBuffer[256];
    if (iID >= 0) {
        MusicManager_GetBaseURL(iClient, szBuffer, sizeof(szBuffer));
        Format(szBuffer, sizeof(szBuffer), "%s&v=%d", szBuffer, g_iVolume[iClient]);
    } else {
        strcopy(szBuffer, sizeof(szBuffer), g_szWebScript);
    }

    UTIL_SendLink(iClient, NULL_STRING, szBuffer, false);
    return true;
}

void MusicManager_GetBaseURL(int iClient, char[] szBuffer, int iMaxLength) {
    MusicManager_GetClientStationURL(iClient, szBuffer, iMaxLength);
    Format(szBuffer, iMaxLength, "%s?s=%s&v=%d", g_szWebScript, szBuffer, g_iStartV[iClient]);
}

void MusicManager_SetSoundState(int iClient, bool bState) {
    char szBuffer[256];
    MusicManager_GetBaseURL(iClient, szBuffer, sizeof(szBuffer));
    Format(szBuffer, sizeof(szBuffer), "%s#TurnO%s", szBuffer, bState ? "n" : "ff");

    UTIL_SendLink(iClient, NULL_STRING, szBuffer, false);
}

void MusicManager_SetVolume(int iClient, int iVolume) {
    char szBuffer[256];
    MusicManager_GetBaseURL(iClient, szBuffer, sizeof(szBuffer));
    Format(szBuffer, sizeof(szBuffer), "%s#Volume=%d", szBuffer, iVolume);

    UTIL_SendLink(iClient, NULL_STRING, szBuffer, false);
}

void UTIL_SendLink(const int iClient, const char[] szTitle, const char[] szURL, bool bVisible = true) {
    KeyValues hData = new KeyValues("data");

    hData.SetNum("type", MOTDPANEL_TYPE_URL);
    hData.SetString("title", szTitle);
    hData.SetString("msg", szURL);

    ShowVGUIPanel(iClient, "info", hData, bVisible);
    delete hData;
}
