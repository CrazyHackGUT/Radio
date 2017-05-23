#define GAME_UNKNOWN    0
#define GAME_ORANGEBOX  1
#define GAME_CSGO       2
#define GAME_OLD        3

int g_iEngine;

void Game_DetectEngine() {
    switch (GetEngineVersion()) {
        case Engine_SourceSDK2006:      g_iEngine = GAME_OLD;
        case Engine_CSGO:               g_iEngine = GAME_CSGO;
        case Engine_TF2, Engine_CSS:    g_iEngine = GAME_ORANGEBOX;
        default:                        g_iEngine = GAME_UNKNOWN;
    }

    if (g_iEngine == GAME_UNKNOWN) {
        LogError("[Engine Detect] Unknown game. Radio plugin maybe can't work. Report this information to author: https://steamcommunity.com/profiles/76561198071596952/");
    }
}

bool Game_GetBaseURL(char[] szOutput, int iMaxLength) {
    switch (g_iEngine) {
        case GAME_OLD:                      return Game_Old_GetBaseURL(szOutput, iMaxLength);
        case GAME_CSGO:                     return Game_CSGO_GetBaseURL(szOutput, iMaxLength);
        case GAME_ORANGEBOX, GAME_UNKNOWN:  return Game_Generic_GetBaseURL(szOutput, iMaxLength);
    }

    return false;
}

bool Game_Old_GetBaseURL(char[] szOutput, int iMaxLength) {
    FormatEx(szOutput, iMaxLength, "%s?engine=old&station={STATION}&volume={VOLUME}", g_szWebScript);
    return true;
}

bool Game_CSGO_GetBaseURL(char[] szOutput, int iMaxLength) {
    FormatEx(szOutput, iMaxLength, "%s?engine=csgo&station={STATION}&volume={VOLUME}", g_szWebScript);
    return true;
}

bool Game_Generic_GetBaseURL(char[] szOutput, int iMaxLength) {
    FormatEx(szOutput, iMaxLength, "%s?engine=orangebox#Station={STATION}&Volume={VOLUME}", g_szWebScript);
    return true;
}
