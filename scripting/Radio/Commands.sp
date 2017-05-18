void RegisterCommands() {
    RegConsoleCmd("sm_radio",       Cmd_Radio);
    RegConsoleCmd("sm_radio_off",   Cmd_RadioOff);
}

public Action Cmd_Radio(int iClient, int iArgs) {
    if (iClient)
        Menu_Draw_MM(iClient);
    return Plugin_Handled;
}

public Action Cmd_RadioOff(int iClient, int iArgs) {
    if (iClient) {
        MusicManager_SetSoundState(iClient, g_bSilence[iClient]);
        g_bSilence[iClient] = !g_bSilence[iClient];
    }
    return Plugin_Handled;
}
