static Handle   g_hScript;
static Handle   g_hStepVolume;
static Handle   g_hDefaultVolume;

static Handle   g_hAdvertTime;
static Handle   g_hMOTDTime;

void ConVar_Init() {
    g_hScript = CreateConVar("sm_radio_scripturl",              "http://kruzya.beget.tech/stuff/Radio_v2/", "Вспомогательный скрипт. Используется для более корректной работы регулировки громкости.");
    g_hStepVolume = CreateConVar("sm_radio_stepvolume",         "5",                                        "Шаг повышения/уменьшения громкости. Максимально 100, минимально 0.\nВНИМАНИЕ! \"0\" отключает возможность изменять громкость!");
    g_hDefaultVolume = CreateConVar("sm_radio_defaultvolume",   "100",                                      "Стандартная громкость");
    g_hAdvertTime = CreateConVar("sm_radio_adverttime",         "180.0",                                    "Периодичность вывода рекламы плагина. Любые значения менее 1.0 (например, 0.99) выключают рекламу.", _, true, 0.0);
    g_hMOTDTime = CreateConVar("sm_radio_motdtime",             "30.0",                                     "Периодичность проверок доступности HTML MOTD-окна у игроков. Любые значения менее 1.0 (например, 0.99) отключают периодические проверки.", _, true, 0.0);

    HookConVarChange(g_hScript, OnCvarChanged);
    HookConVarChange(g_hStepVolume, OnCvarChanged);
    HookConVarChange(g_hDefaultVolume, OnCvarChanged);
    HookConVarChange(g_hAdvertTime, OnCvarChanged);
    HookConVarChange(g_hMOTDTime, OnCvarChanged);

    AutoExecConfig(true, "radio");
}

public void OnCvarChanged(Handle hCvar, const char[] szOV, const char[] szNV) {
    if (hCvar == g_hScript) {
        strcopy(g_szWebScript, sizeof(g_szWebScript), szNV);
    } else if (hCvar == g_hStepVolume) {
        g_iStepSize = StringToInt(szNV);
    } else if (hCvar == g_hDefaultVolume) {
        g_iDefaultVolume = StringToInt(szNV);

        if (g_iDefaultVolume > 100)
            g_iDefaultVolume = 100;
        else if (g_iDefaultVolume < 0)
            g_iDefaultVolume = 0;
    } else if (hCvar == g_hAdvertTime) {
        g_fAdvertTime = StringToFloat(szNV);
        Timers_Restart();
    } else { 
        g_fMOTDChecker = StringToFloat(szNV);
        Timers_Restart();
    }
}

public void OnConfigsExecuted() {
    GetConVarString(g_hScript, g_szWebScript, sizeof(g_szWebScript));
    g_iStepSize         = GetConVarInt(g_hStepVolume);
    g_iDefaultVolume    = GetConVarInt(g_hDefaultVolume);
    g_fAdvertTime       = GetConVarFloat(g_hAdvertTime);
    g_fMOTDChecker      = GetConVarFloat(g_hMOTDTime);

    // default volume validator
    if (g_iDefaultVolume > 100)
        g_iDefaultVolume = 100;
    else if (g_iDefaultVolume < 0)
        g_iDefaultVolume = 0;

    Timers_Restart();
}