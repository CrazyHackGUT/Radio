void Menu_Draw_MM(int iClient) {
	Menu hMenu = new Menu(MMHandler);

	hMenu.SetTitle("%T", "MM_Title", iClient);

	// Volume
	char szBuffer[256];
	FormatEx(szBuffer, sizeof(szBuffer), "%T", "MM_Volume", iClient, g_iVolume);
	hMenu.AddItem("v", szBuffer);

	// Stations
	MusicManager_GetClientStationName(iClient, szBuffer, sizeof(szBuffer));
	Format(szBuffer, sizeof(szBuffer), "%T", "MM_Station", iClient, szBuffer);
	hMenu.AddItem("s", szBuffer);

	hMenu.AddItem(NULL_STRING, NULL_STRING, ITEMDRAW_SPACER);

	// Turn off/on sound
	FormatEx(szBuffer, sizeof(szBuffer), "%T", g_bSilenced[iClient] ? "MM_TurnOnSound" : "MM_TurnOffSound", iClient);
	hMenu.AddItem("o", szBuffer);

	hMenu.Display(iClient, 0);
}

public int MMHandler(Menu hMenu, MenuAction iAction, int iParam1, int iParam2) {
	if (iAction == MenuAction_End)
		delete hMenu;
	else if (iAction == MenuAction_Select) {
		char szBuff[3];
		hMenu.GetItem(iParam2, szBuff, sizeof(szBuff));

		if (szBuff[0] == 'o') {
			g_bSilenced[iParam1] = !g_bSilenced[iParam1];
			MusicManager_ChangeMusicState(iParam1);
		} else if (szBuff[0] == 'v') {
			Menu_VM_Draw(iParam1);
		} else {
			Menu_SM_Draw(iParam1);
		}
	}
}