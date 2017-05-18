bool MusicManager_GetClientStationName(int iClient, char[] szOutput, int iMaxLength) {
	if (g_iSelected[iClient] < 0) {
		FormatEx(szOutput, iMaxLength, "%T", "StationNone", iClient);
		return true;
	}
	StringMapSnapshot hSnapshot = g_hRadioStations.Snapshot();
	int iBytes = hSnapshot.GetKey(g_iSelected[iClient], szOutput, iMaxLength);
	delete hSnapshot;

	return (iBytes > 0);
}