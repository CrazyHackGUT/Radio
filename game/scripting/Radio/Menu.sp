void Menu_Draw_MM(int iClient) {
    if (MOTD_GetState(iClient) != Enabled) {
        PrintToChat(iClient, "[Radio] %t", "EnableMOTD");
        Menu_Draw_MOTDInstruction(iClient);
        return;
    }

    char szBuffer[256];
    Menu hMenu = new Menu(MMHandler);

    hMenu.SetTitle("%T", "MM_Title", iClient);
    hMenu.ExitButton = true;

    // Volume
    FormatEx(szBuffer, sizeof(szBuffer), "%T", "MM_Volume", iClient, g_iVolume[iClient]);
    hMenu.AddItem("v", szBuffer, (g_iSelected[iClient] < 0 || g_bSilence[iClient]) ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);

    // Stations
    MusicManager_GetStationByID(g_iSelected[iClient], _, _, szBuffer, sizeof(szBuffer), iClient);
    Format(szBuffer, sizeof(szBuffer), "%T", "MM_Station", iClient, szBuffer);
    hMenu.AddItem("s", szBuffer);

    hMenu.AddItem(NULL_STRING, NULL_STRING, ITEMDRAW_SPACER);

    // Turn off/on sound
    FormatEx(szBuffer, sizeof(szBuffer), "%T", g_bSilence[iClient] ? "MM_TurnOnSound" : "MM_TurnOffSound", iClient);
    hMenu.AddItem("o", szBuffer);

    hMenu.Display(iClient, 0);
}

void Menu_Draw_VM(int iClient) {
    if (MOTD_GetState(iClient) != Enabled) {
        PrintToChat(iClient, "[Radio] %t", "EnableMOTD");
        Menu_Draw_MOTDInstruction(iClient);
        return;
    }

    char szBuffer[256];
    Menu hMenu = new Menu(VMHandler);

    hMenu.SetTitle("%T", "VM_Title", iClient, g_iVolume[iClient]);
    hMenu.ExitBackButton = true;
    hMenu.ExitButton = false;

    // Increase
    FormatEx(szBuffer, sizeof(szBuffer), "%T", "VM_Increase", iClient);
    hMenu.AddItem(NULL_STRING, szBuffer, ((g_iVolume[iClient] >= 100) ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT));

    // Decrease
    FormatEx(szBuffer, sizeof(szBuffer), "%T", "VM_Decrease", iClient);
    hMenu.AddItem(NULL_STRING, szBuffer, ((g_iVolume[iClient] <= 0) ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT));

    hMenu.Display(iClient, 0);
}

void Menu_Draw_SM(int iClient) {
    if (MOTD_GetState(iClient) != Enabled) {
        PrintToChat(iClient, "[Radio] %t", "EnableMOTD");
        Menu_Draw_MOTDInstruction(iClient);
        return;
    }

    char szBuffer[256];
    Menu hMenu = new Menu(SMHandler);

    MusicManager_GetStationByID(g_iSelected[iClient], _, _, szBuffer, sizeof(szBuffer), iClient);
    hMenu.SetTitle("%T", "SM_Title", iClient, szBuffer);
    hMenu.ExitBackButton = true;
    hMenu.ExitButton = false;

    FormatEx(szBuffer, sizeof(szBuffer), "%T", "StationNone", iClient);
    if (g_iSelected[iClient] < 0)
        Format(szBuffer, sizeof(szBuffer), "%s %T", szBuffer, "SM_Current", iClient);
    hMenu.AddItem(NULL_STRING, szBuffer, ((g_iSelected[iClient] < 0) ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT));

    int iID     = -1;
    int iLength = g_hRadioStations.Length;

    while (++iID < iLength) {
        MusicManager_GetStationByID(iID, _, _, szBuffer, sizeof(szBuffer));
        if (iID == g_iSelected[iClient])
            Format(szBuffer, sizeof(szBuffer), "%s %T", szBuffer, "SM_Current", iClient);

        hMenu.AddItem(NULL_STRING, szBuffer, ((g_iSelected[iClient] == iID) ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT));
    }

    hMenu.Display(iClient, 0);
}

void Menu_Draw_MOTDInstruction(int iClient) {
    Panel hPanel = new Panel();

    char szBuffer[128];
    FormatEx(szBuffer, sizeof(szBuffer), "%T\n ", "MOTD_Title", iClient);
    hPanel.SetTitle(szBuffer);

    for (int iStep = 1; iStep < 5; iStep++) {
        FormatEx(szBuffer, sizeof(szBuffer), "MOTD_Step%d", iStep);
        Format(szBuffer, sizeof(szBuffer), "%d. %T", iStep, szBuffer, iClient);
        hPanel.DrawText(szBuffer);
    }

    FormatEx(szBuffer, sizeof(szBuffer), "%T", "MOTD_Exit", iClient);
    hPanel.DrawItem(szBuffer);

    hPanel.Send(iClient, PanelHandler, 120);
    delete hPanel;
}

public int MMHandler(Menu hMenu, MenuAction iAction, int iParam1, int iParam2) {
    if (iAction == MenuAction_End)
        delete hMenu;
    else if (iAction == MenuAction_Select) {
        char szBuff[3];
        hMenu.GetItem(iParam2, szBuff, sizeof(szBuff));

        if (szBuff[0] == 'o') {
            g_bSilence[iParam1] = !g_bSilence[iParam1];
            MusicManager_SetSoundState(iParam1, !g_bSilence[iParam1]);
            Menu_Draw_MM(iParam1);
        } else if (szBuff[0] == 'v') {
            if (g_iStepSize > 0 && g_iStepSize < 100) {
                Menu_Draw_VM(iParam1);
            } else {
                PrintToChat(iParam1, "[Radio] %t", "FeatureOff");
            }
        } else {
            Menu_Draw_SM(iParam1);
        }
    }
}

public int VMHandler(Menu hMenu, MenuAction iAction, int iParam1, int iParam2) {
    if (iAction == MenuAction_End) {
        delete hMenu;
    } else if (iAction == MenuAction_Cancel && iParam2 == MenuCancel_ExitBack) {
        Menu_Draw_MM(iParam1);
    } else if (iAction == MenuAction_Select) {
        int iVolume = g_iVolume[iParam1];
        if (iParam2 == 1) {
            iVolume -= g_iStepSize;
            if (iVolume < 0)
                iVolume = 0;
        } else {
            iVolume += g_iStepSize;
            if (iVolume > 100)
                iVolume = 100;
        }

        MusicManager_SetVolume(iParam1, iVolume);
        g_iVolume[iParam1] = iVolume;

        Menu_Draw_VM(iParam1);
    }
}

public int SMHandler(Menu hMenu, MenuAction iAction, int iParam1, int iParam2) {
    if (iAction == MenuAction_End) {
        delete hMenu;
    } else if (iAction == MenuAction_Cancel && iParam2 == MenuCancel_ExitBack) {
        Menu_Draw_MM(iParam1);
    } else if (iAction == MenuAction_Select) {
        if (!g_bSilence[iParam1])
            MusicManager_ChangeStation(iParam1, iParam2 - 1);
        else
            MusicManager_ChangeStationMem(iParam1, iParam2 - 1);
        Menu_Draw_MM(iParam1);
    }
}

public int PanelHandler(Menu hMenu, MenuAction iAction, int iParam1, int iParam2) {
    if (iAction == MenuAction_Select) {
        MOTD_Check(iParam1);
    }
}