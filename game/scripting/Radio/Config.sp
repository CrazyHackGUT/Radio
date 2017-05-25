#define RADIOCFG_NONE       0
#define RADIOCFG_MAIN       1
#define RADIOCFG_STATIONS   2

SMCParser   g_hSMC;
char        g_szConfig[PLATFORM_MAX_PATH];
int         g_iCurrentCfgState;

void ReadConfig() {
    ClearStations();
    InitParser();
    InitPath();

    g_iCurrentCfgState = RADIOCFG_NONE;
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
    g_hSMC.OnEnterSection   = CFG_OnSectionEnter;
    g_hSMC.OnLeaveSection   = CFG_OnSectionLeave;
    g_hSMC.OnKeyValue       = CFG_OnKeyValue;
}

void InitPath() {
    if (g_szConfig[0])
        return;

    BuildPath(Path_SM, g_szConfig, sizeof(g_szConfig), "configs/Radio.cfg");
}

public SMCResult CFG_OnSectionEnter(SMCParser hSMC, const char[] szName, bool bOptQuotes) {
    if (StrEqual(szName, "Radio")) {
        g_iCurrentCfgState = RADIOCFG_MAIN;
    } else if (StrEqual(szName, "Stations")) {
        g_iCurrentCfgState = RADIOCFG_STATIONS;
    } else {
        g_iCurrentCfgState = RADIOCFG_NONE;
    }
}

public SMCResult CFG_OnSectionLeave(SMCParser hSMC) {
    if (g_iCurrentCfgState == RADIOCFG_MAIN) {
        g_iCurrentCfgState = RADIOCFG_NONE;
    } else if (g_iCurrentCfgState == RADIOCFG_STATIONS) {
        g_iCurrentCfgState = RADIOCFG_MAIN;
    }
}

public SMCResult CFG_OnKeyValue(SMCParser hSMC, const char[] szKey, const char[] szValue, bool bKeyQuotes, bool bValueQuotes) {
    if (g_iCurrentCfgState == RADIOCFG_MAIN) {
        if (StrEqual(szKey, "Script")) {
            strcopy(g_szWebScript, sizeof(g_szWebScript), szValue);
        } else if (StrEqual(szKey, "StepVolume")) {
            g_iStepSize = StringToInt(szValue);
        } else if (StrEqual(szKey, "DefaultVolume")) {
            g_iDefaultVolume = StringToInt(szValue);
            if (g_iDefaultVolume > 100)
                g_iDefaultVolume = 100;
            else if (g_iDefaultVolume < 0)
                g_iDefaultVolume = 0;
        } else if (StrEqual(szKey, "Advert_Time") {
            g_fAdvertTime = StringToFloat(szValue);
        } else if (StrEqual(szKey, "MOTD_Time") {
            g_fMOTDChecker = StringToFloat(szValue);
        }
    } else if (g_iCurrentCfgState == RADIOCFG_STATIONS) {
        DataPack hPack = new DataPack();
        hPack.WriteString(szKey);
        hPack.WriteString(szValue);
        g_hRadioStations.Push(hPack);
    }
}
