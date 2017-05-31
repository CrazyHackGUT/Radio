void UTIL_ClearSettings(int iClient) {
    MOTD_SetState(iClient, Unknown);
    g_iSelected[iClient]    = -1;
    g_bSilence[iClient]     = false;
    g_iVolume[iClient]      = g_iDefaultVolume;
}

void UTIL_SendLink(const int iClient, const char[] szTitle, const char[] szURL, bool bVisible = true) {
    KeyValues hData = new KeyValues("data");

    hData.SetNum("type", MOTDPANEL_TYPE_URL);
    hData.SetString("title", szTitle);
    hData.SetString("msg", szURL);

    ShowVGUIPanel(iClient, "info", hData, bVisible);
    delete hData;
}
