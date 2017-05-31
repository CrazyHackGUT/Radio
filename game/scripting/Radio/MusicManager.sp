bool MusicManager_GetStationByID(int iID, char[] szURL = "", int iMaxURLLength = 0, char[] szName = "", int iMaxNameLength = 0, int iClient = 0) {
    if (iID < 0) {
        szURL[0] = 0;
        szName[0] = 0;

        if (iClient >= 0) {
            FormatEx(szName, iMaxNameLength, "%T", "StationNone", iClient);
        }
        return true;
    }

    if (iID >= g_hRadioStations.Length) {
        return false;
    }

    DataPack hPack = g_hRadioStations.Get(iID);
    hPack.Reset();
    hPack.ReadString(szName, iMaxNameLength);
    hPack.ReadString(szURL, iMaxURLLength);
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

    MusicManager_SendUpdate(iClient, iID, g_iVolume[iClient]);
    return true;
}

void MusicManager_SetSoundState(int iClient, bool bState) {
    MusicManager_SendUpdate(iClient, bState ? g_iSelected[iClient] : -1, g_iVolume[iClient]);
}

void MusicManager_SetVolume(int iClient, int iVolume) {
    MusicManager_SendUpdate(iClient, g_iSelected[iClient], iVolume);
}

void MusicManager_SendUpdate(const int iClient, const int iStation, const int iVolume) {
    char szReadyURL[256],
         szStationURL[256],
         szVolume[4];

    Game_GetBaseURL(szReadyURL, sizeof(szReadyURL));
    IntToString(iVolume, szVolume, sizeof(szVolume));

    if (iStation >= 0)
        MusicManager_GetStationByID(g_iSelected[iClient], szStationURL, sizeof(szStationURL));
    else
        szStationURL[0] = 0;

    ReplaceString(szReadyURL, sizeof(szReadyURL), "{STATION}", szStationURL, true);
    ReplaceString(szReadyURL, sizeof(szReadyURL), "{VOLUME}", szVolume, true);

    UTIL_SendLink(iClient, NULL_STRING, szReadyURL, false);
}
