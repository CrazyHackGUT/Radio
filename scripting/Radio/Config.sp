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
        g_hRadioStations.Clear();
    } else {
        g_hRadioStations = new StringMap();
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
        }
    } else if (g_iCurrentCfgState == RADIOCFG_STATIONS) {
        g_hRadioStations.SetString(szKey, szValue, true);
    }
}
