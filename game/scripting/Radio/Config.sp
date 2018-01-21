SMCParser   g_hSMC;
char        g_szConfig[PLATFORM_MAX_PATH];

void ReadConfig() {
    ClearStations();
    InitParser();
    InitPath();

    g_hSMC.ParseFile(g_szConfig);
}

void ClearStations() {
    if (g_hRadioStations) {
        for (int i = 0; i<g_hRadioStations.Length; i++)
            delete view_as<DataPack>(g_hRadioStations.Get(i));

        g_hRadioStations.Clear();
    } else {
        g_hRadioStations = new ArrayList(ByteCountToCells(8));
    }
}

void InitParser() {
    if (g_hSMC)
        return;

    g_hSMC = new SMCParser();
    g_hSMC.OnKeyValue       = CFG_OnKeyValue;
}

void InitPath() {
    if (g_szConfig[0])
        return;

    BuildPath(Path_SM, g_szConfig, sizeof(g_szConfig), "data/Radio.cfg");
}

public SMCResult CFG_OnKeyValue(SMCParser hSMC, const char[] szKey, const char[] szValue, bool bKeyQuotes, bool bValueQuotes) {
    DataPack hPack = new DataPack();
    hPack.WriteString(szKey);
    hPack.WriteString(szValue);
    g_hRadioStations.Push(hPack);
}
