/*
 * License:
 * The author(s) of this software retain the right to modify/revoke this license at any time under any conditions seen appropriate by the author(s).
 * You can change this include however you like.
 * It would be appreciated if you could add my name to the credits in your server, since this include was a lot of work to make.
 * You can extend on this include as long as you credit the original author(s).

 * Credits:
 * Freaksken (http://forum.sa-mp.com/member.php?u=46764) for this include.
 * Southclaw (http://forum.sa-mp.com/member.php?u=50199) for the GetTickCount overflow fix (http://pastebin.com/BZyaJpzs) and Ralfie (http://forum.sa-mp.com/member.php?u=218502) for an example on how to use the fix.
 * OrMisicL (http://forum.sa-mp.com/member.php?u=197901) and ZiGGi (http://forum.sa-mp.com/member.php?u=36935) (and any others who worked on this awesome plugin) for FCNPC (http://forum.sa-mp.com/showthread.php?t=428066).
 * Kalcor (http://forum.sa-mp.com/member.php?u=3), Mauzen (http://forum.sa-mp.com/member.php?u=10237) and pamdex (http://forum.sa-mp.com/member.php?u=78089) for MapAndreas v1.2.1 (http://forum.sa-mp.com/showthread.php?t=275492).
 * Incognito (http://forum.sa-mp.com/member.php?u=925) for his streamer (http://forum.sa-mp.com/showthread.php?t=102865) used in the example script.
 * SA-MP team for SA-MP (https://www.sa-mp.com).
 * Rockstar Games for GTA San Andreas (http://www.rockstargames.com/sanandreas).
*/

//FAKE NATIVES
/*
//Boss
native WOW_CreateBossFull(name[], fullName[] = WOW_INVALID_STRING, iconid = WOW_INVALID_ICON_ID, iconMarker = 23, iconColor = 0xff0000ff, iconStyle = MAPICON_LOCAL, Float:maxHealth = 100000.0, Float:rangeDisplay = 100.0, Float:rangeAggro = 20.0, bool:displayIfDead = true, Float:currentHealth = -1.0, targetid = INVALID_PLAYER_ID
, moveType = MOVE_TYPE_SPRINT, Float:moveSpeed = -1.0, Float:moveRadius = 0.0, bool:moveSetAngle = true, Float:rangedAttackDistance = 20.0, rangedAttackDelay = 0, bool:rangedAttackSetAngle = true, Float:meleeAttackDistance = 1.0, meleeAttackDelay = -1, bool:meleeAttackUseFightStyle = true);
native WOW_CreateBoss(name[]);
native WOW_GetBossFullName(bossid, name[], len);
native WOW_SetBossFullName(bossid, name[]);
native WOW_GetBossMapiconInfo(bossid, &iconid, &iconMarker, &iconColor, &iconStyle);
native WOW_SetBossMapiconInfo(bossid, iconid = WOW_INVALID_ICON_ID, iconMarker = 23, iconColor = 0xff0000ff, iconStyle = MAPICON_LOCAL);
native WOW_GetBossMaxHealth(bossid, &Float:health);
native WOW_SetBossMaxHealth(bossid, Float:health, bool:keepHealthPercent = false);
native WOW_GetBossDisplayRange(bossid, &Float:range);
native WOW_SetBossDisplayRange(bossid, Float:range);
native WOW_GetBossAggroRange(bossid, &Float:range);
native WOW_SetBossAggroRange(bossid, Float:range, bool:checkForTarget = false);
native WOW_GetBossDisplayIfDead(bossid);
native WOW_SetBossDisplayIfDead(bossid, bool:displayIfDead);
native WOW_GetBossCurrentHealth(bossid, &Float:health);
native WOW_SetBossCurrentHealth(bossid, Float:health, bool:keepHealthPercent = false);
native WOW_GetBossTarget(bossid);
native WOW_SetBossTarget(bossid, playerid, bool:checkForAggroRange = false);
native WOW_GetBossMoveInfo(bossid, &type, &Float:speed, &Float:radius, &bool:setAngle);
native WOW_SetBossMoveInfo(bossid, type = MOVE_TYPE_SPRINT, Float:speed = -1.0, Float:radius = 0.0, bool:setAngle = true);
native WOW_GetBossRangedAttackInfo(bossid, &Float:distance, &delay, &bool:setAngle);
native WOW_SetBossRangedAttackInfo(bossid, Float:distance = 20.0, delay = 0, bool:setAngle = true);
native WOW_GetBossMeleeAttackInfo(bossid, &Float:distance, &delay, &bool:useFightStyle);
native WOW_SetBossMeleeAttackInfo(bossid, Float:distance = 1.0, delay = -1, bool:useFightStyle = true);
native WOW_DestroyBoss(bossid);
native WOW_DestroyAllBosses();
native bool:WOW_IsValidBoss(bossid);
native bool:WOW_IsBossValidForPlayer(playerid, bossid);
native bool:WOW_IsPlayerInDisplayRange(playerid, bossid);
native bool:WOW_IsPlayerInAggroRange(playerid, bossid);
native bool:WOW_BossHasMeleeWeapons(bossid);
native WOW_GetBossNPCId(bossid);
native Text:WOW_GetBossTextDraw(bossid, textdraw);
native WOW_GetBossCurrentHealthPercent(bossid);
native WOW_GetBossIdFromPlayerid(playerid);
native WOW_DamageBoss(bossid, damagerid, Float:amount);
native WOW_HealBoss(bossid, healerid, Float:amount);

//Spell
native WOW_CreateSpellFull(name[], type = WOW_SPELL_TYPE_CUSTOM, castTime = 2000, Float:amount = 0.0, percentType = WOW_PERCENT_TYPE_CUSTOM, castBarColorDark = 0x645005ff, castBarColorLight = 0xb4820aff, bool:castBarInverted = false, bool:castTimeInverted = false, bool:canMove = false, bool:canAttack = false, info[] = WOW_INVALID_STRING);
native WOW_CreateSpell(name[]);
native WOW_GetSpellName(spellid, name[], len);
native WOW_SetSpellName(spellid, name[]);
native WOW_GetSpellType(spellid);
native WOW_SetSpellType(spellid, type);
native WOW_GetSpellCastTime(spellid);
native WOW_SetSpellCastTime(spellid, castTime, bool:keepCastPercent = false);
native WOW_GetSpellAmount(spellid, &Float:amount);
native WOW_SetSpellAmount(spellid, Float:amount);
native WOW_GetSpellPercentType(spellid);
native WOW_SetSpellPercentType(spellid, type);
native WOW_GetSpellCastBarColorDark(spellid);
native WOW_SetSpellCastBarColorDark(spellid, color);
native WOW_GetSpellCastBarColorLight(spellid);
native WOW_SetSpellCastBarColorLight(spellid, color);
native bool:WOW_GetSpellCastBarInverted(spellid);
native WOW_SetSpellCastBarInverted(spellid, bool:inverted, bool:invertProgressMade = false);
native bool:WOW_GetSpellCastTimeInverted(spellid);
native WOW_SetSpellCastTimeInverted(spellid, bool:inverted, bool:invertProgressMade = false);
native bool:WOW_GetSpellCanMove(spellid);
native WOW_SetSpellCanMove(spellid, bool:canMove);
native bool:WOW_GetSpellCanAttack(spellid);
native WOW_SetSpellCanAttack(spellid, bool:canAttack);
native WOW_GetSpellInfo(spellid, info[], len);
native WOW_SetSpellInfo(spellid, info[]);
native WOW_DestroySpell(spellid);
native WOW_DestroyAllSpells();
native bool:WOW_IsValidSpell(spellid);
native WOW_SpellToString(spellid, string[], len, bool:allowDefaultColors = true);

//Casting
native WOW_StartBossCastingSpell(bossid, spellid, targetid = INVALID_PLAYER_ID);
native WOW_GetBossCastingSpell(bossid);
native WOW_SetBossCastingSpell(bossid, spellid, bool:keepCastPercent = false);
native WOW_GetBossCastingProgress(bossid);
native WOW_SetBossCastingProgress(bossid, progress);
native WOW_GetBossCastingTarget(bossid);
native WOW_SetBossCastingTarget(bossid, targetid);
native WOW_GetBossCastingExtraProgress(bossid);
native WOW_SetBossCastingExtraProgress(bossid, progress);
native WOW_StopBossCasting(bossid);
native WOW_StopBossCastingSpell(bossid, spellid);
native WOW_StopAllBossesCasting();
native WOW_StopAllBossesCastingSpell(spellid);
native bool:WOW_IsBossCasting(bossid);
native bool:WOW_IsBossCastingSpell(bossid, spellid);
native bool:WOW_IsBossCastBarExtra(bossid);
native bool:WOW_IsBossCastBarExtraForSpell(bossid, spellid);
*/

//CALLBACKS
//Boss
forward WOW_OnBossEncounterStart(bossid, bool:reasonShot, firstTarget);
forward WOW_OnBossEncounterStop(bossid, bool:reasonDeath, lastTarget);
forward WOW_OnPlayerGetAggro(playerid, bossid);
forward WOW_OnPlayerLoseAggro(playerid, bossid);

//Casting
forward WOW_OnBossStartCasting(bossid, spellid, targetid);
forward WOW_OnBossStopCasting(bossid, spellid, targetid, bool:castComplete);

//General
//Include guards are already built into pawn, so no need to check
#include <a_samp>
#define WOW_VERSION                       	"1.0.0"
#if !defined WOW_USE_MAP_ANDREAS
	#define WOW_USE_MAP_ANDREAS           	true
#endif
#if WOW_USE_MAP_ANDREAS == true
	#include <MapAndreas>
#endif
#if !defined WOW_MAP_ANDREAS_MODE
	#define WOW_MAP_ANDREAS_MODE          	MAP_ANDREAS_MODE_FULL
#endif
#include <FCNPC>
#define WOW_INVALID_STRING              	" "
#define WOW_INVALID_COLOR	              	-1
#define WOW_INVALID_TIMER_ID            	-1
#if !defined WOW_UPDATE_TIME
	#define WOW_UPDATE_TIME    				50
#endif
#if !defined WOW_CAST_BAR_SHOW_EXTRA_TIME
	#define WOW_CAST_BAR_SHOW_EXTRA_TIME    1000
#endif
#if !defined WOW_DECIMAL_MARK
	#define WOW_DECIMAL_MARK    			'.'
#endif
#if !defined WOW_SHORTEN_HEALTH
	#define WOW_SHORTEN_HEALTH            	false
#endif
#define WOW_isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
static WOW_UpdateTimer = WOW_INVALID_TIMER_ID;
static WOW_PauseTickCount[MAX_PLAYERS] = {0,...};
static bool:WOW_PlayerPaused[MAX_PLAYERS] = {false,...};
static WOW_PauseTimer = WOW_INVALID_TIMER_ID;

//Boss
#if !defined WOW_MAX_BOSSES
	#define WOW_MAX_BOSSES					20
#endif
#if !defined WOW_MAX_BOSS_FULL_NAME
	#define WOW_MAX_BOSS_FULL_NAME      	50
#endif
#define WOW_INVALID_BOSS_ID					-1
#define WOW_INVALID_ICON_ID					-1
#define WOW_MAX_BOSS_TEXTDRAWS              8
enum WOW_ENUM_BOSS {
	//Can be set by the user
	FULL_NAME[WOW_MAX_BOSS_FULL_NAME + 1],
	ICONID,
	ICON_MARKER,
	ICON_COLOR,
	ICON_STYLE,
	Float:MAX_HEALTH,
	Float:RANGE_DISPLAY,
	Float:RANGE_AGGRO,
	bool:DISPLAY_IF_DEAD,
	Float:CUR_HEALTH, //Changes during the encounter
	TARGET, //Changes at the beginning, at the end and during the encounter
 	MOVE_TYPE,
	Float:MOVE_SPEED,
	Float:MOVE_RADIUS,
	bool:MOVE_SET_ANGLE,
	Float:RANGED_ATTACK_DISTANCE,
	RANGED_ATTACK_DELAY,
	bool:RANGED_ATTACK_SET_ANGLE,
	Float:MELEE_ATTACK_DISTANCE,
	MELEE_ATTACK_DELAY,
	bool:MELEE_ATTACK_USE_FIGHT_STYLE,
	//Cannot be set by the user
	NPCID,
	Text:TEXTDRAW[WOW_MAX_BOSS_TEXTDRAWS]
}
static WOW_Bosses[WOW_MAX_BOSSES][WOW_ENUM_BOSS];
static Text:WOW_BossBlackHealth = Text:INVALID_TEXT_DRAW;
static Text:WOW_BossDarkRed = Text:INVALID_TEXT_DRAW;
static Text:WOW_BossBlackCast = Text:INVALID_TEXT_DRAW;

//Spell
#if !defined WOW_MAX_SPELLS
	#define WOW_MAX_SPELLS					20
#endif
#if !defined WOW_MAX_SPELL_NAME
	#define WOW_MAX_SPELL_NAME				30
#endif
#if !defined WOW_MAX_SPELL_INFO
	#define WOW_MAX_SPELL_INFO				144
#endif
#define WOW_INVALID_SPELL_ID				-1
enum WOW_ENUM_SPELL {
	//Can be set by the user
	NAME[WOW_MAX_SPELL_NAME + 1],
	TYPE,
	CAST_TIME,
	Float:AMOUNT,
	PERCENT_TYPE,
	CAST_BAR_COLOR_DARK,
	CAST_BAR_COLOR_LIGHT,
	bool:CAST_BAR_INVERTED,
	bool:CAST_TIME_INVERTED,
	bool:CAN_MOVE,
	bool:CAN_ATTACK,
	INFO[WOW_MAX_SPELL_INFO + 1]
}
enum {
	WOW_SPELL_TYPE_INVALID = -1,
	WOW_SPELL_TYPE_DAM,
	WOW_SPELL_TYPE_HEAL,
	WOW_SPELL_TYPE_CROWD_CONTROL,
	WOW_SPELL_TYPE_INTERRUPT,
	WOW_SPELL_TYPE_DISPELL,
	WOW_SPELL_TYPE_SPAWN_ADD,
	WOW_SPELL_TYPE_CUSTOM
}
enum {
	WOW_PERCENT_TYPE_INVALID = -1,
	WOW_PERCENT_TYPE_NOT,
	WOW_PERCENT_TYPE_TARG_MAX_HP_AP,
	WOW_PERCENT_TYPE_CAST_MAX_HP_AP,
	WOW_PERCENT_TYPE_TARG_CUR_HP_AP,
	WOW_PERCENT_TYPE_CAST_CUR_HP_AP,
	WOW_PERCENT_TYPE_TARG_LOS_HP_AP,
	WOW_PERCENT_TYPE_CAST_LOS_HP_AP,
	WOW_PERCENT_TYPE_TARG_MAX_HP,
	WOW_PERCENT_TYPE_CAST_MAX_HP,
	WOW_PERCENT_TYPE_TARG_CUR_HP,
	WOW_PERCENT_TYPE_CAST_CUR_HP,
	WOW_PERCENT_TYPE_TARG_LOS_HP,
	WOW_PERCENT_TYPE_CAST_LOS_HP,
	WOW_PERCENT_TYPE_TARG_MAX_AP,
	WOW_PERCENT_TYPE_CAST_MAX_AP,
	WOW_PERCENT_TYPE_TARG_CUR_AP,
	WOW_PERCENT_TYPE_CAST_CUR_AP,
	WOW_PERCENT_TYPE_TARG_LOS_AP,
	WOW_PERCENT_TYPE_CAST_LOS_AP,
	WOW_PERCENT_TYPE_CUSTOM
}
static WOW_Spells[WOW_MAX_SPELLS][WOW_ENUM_SPELL];

//Casting
#define WOW_INVALID_CAST_PROGRESS       	-1
enum WOW_ENUM_CASTING {
	//Can be set by the user
	SPELLID,
	CAST_PROGRESS,
	TARGETID
}
static WOW_Casting[WOW_MAX_BOSSES][WOW_ENUM_CASTING];

//General
static WOW_strtokdelim(const string[], delimiter, &index) {
	new length = strlen(string);
	while ((index < length) && (string[index] <= delimiter)) {
		index++;
	}
	new offset = index;
	new result[21 + 1]; //We don't need this function for strings longer than 21 characters
	while ((index < length) && (string[index] > delimiter) && ((index - offset) < (sizeof(result) - 1))) {
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
static WOW_DisplayReadableInteger(amount) {
	//Integer min: -2.147.483.648
	//Integer max: 2.147.483.647
	new amountAsString[14 + 1]; //10(2147483647) + 3(.) + 1(-)
	format(amountAsString, sizeof(amountAsString), "%d", amount < 0 ? amount*-1 : amount);
	new length = strlen(amountAsString);
	new modulo = length%3;
	for(new pos = modulo; pos < length; pos+= 3) {
	    if(pos != 0) { //Door modulo = 0
	        #if WOW_DECIMAL_MARK == '.'
				strins(amountAsString, ",", pos);
	        #else
				strins(amountAsString, ".", pos);
			#endif
			length++;
			pos++;
		}
	}
	if(amount < 0) {
		strins(amountAsString, "-", 0);
	}
	return amountAsString;
}
static WOW_DisplayReadableFloat(Float:amount, maxDecimals = 6, minDecimals = 0) {
    new amountAsString[21 + 1], front[21 + 1], end[21 + 1], idx, frontval;
    format(amountAsString, sizeof(amountAsString), "%s", WOW_RemoveUnnecessaryDecimals(amount, maxDecimals, minDecimals));
	front = WOW_strtokdelim(amountAsString, '.', idx); //Bij een negatief getal wordt de - eraf gedaan? Oplossing zie hieronder.
	end = WOW_strtokdelim(amountAsString, '.', idx);
	frontval = strval(front);
	if(strlen(end) > 0) {
	    format(end, sizeof(end), "%c%s", WOW_DECIMAL_MARK, end);
	}
	format(amountAsString, sizeof(amountAsString), "%s%s", WOW_DisplayReadableInteger(amount < 0 ? frontval*-1 : frontval), end);
	return amountAsString;
}
static WOW_RemoveUnnecessaryDecimals(Float:amount, maxDecimals = 6, minDecimals = 0) {
	new amountAsString[21 + 1];
	format(amountAsString, sizeof(amountAsString), "%f", amount);
	if(maxDecimals > 6) {
		maxDecimals = 6;
	}
	if(maxDecimals < 0) {
		maxDecimals = 0;
	}
	if(minDecimals < 0) {
		minDecimals = 0;
	}
	if(minDecimals > 6) {
		minDecimals = 6;
	}
	if(maxDecimals < minDecimals) {
		maxDecimals = minDecimals;
	}
	new decimalCount = maxDecimals;
	new decimalPos = strfind(amountAsString, ".", true);
	for(new pos = decimalPos + maxDecimals; pos > decimalPos + minDecimals; pos--) {
	    if(amountAsString[pos] == '0') {
	        decimalCount--;
	    } else {
			break;
		}
	}
	switch(decimalCount) {
	    case 0: {format(amountAsString, sizeof(amountAsString), "%.0f", amount);}
	    case 1: {format(amountAsString, sizeof(amountAsString), "%.1f", amount);}
	    case 2: {format(amountAsString, sizeof(amountAsString), "%.2f", amount);}
	    case 3: {format(amountAsString, sizeof(amountAsString), "%.3f", amount);}
	    case 4: {format(amountAsString, sizeof(amountAsString), "%.4f", amount);}
	    case 5: {format(amountAsString, sizeof(amountAsString), "%.5f", amount);}
	    default: {format(amountAsString, sizeof(amountAsString), "%.6f", amount);}
	}
	return amountAsString;
}

#if defined FILTERSCRIPT
    public OnFilterScriptInit()
	{
	    WOW_InitScript();
	    #if defined WOW_OnFilterScriptInit
	        WOW_OnFilterScriptInit();
	    #endif
	    return 1;
	}
	#if defined _ALS_OnFilterScriptInit
	    #undef OnFilterScriptInit
	#else
	    #define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit WOW_OnFilterScriptInit
	#if defined WOW_OnFilterScriptInit
	    forward WOW_OnFilterScriptInit();
	#endif

    public OnFilterScriptExit()
	{
	    WOW_ExitScript();
	    #if defined WOW_OnFilterScriptExit
	        WOW_OnFilterScriptExit();
	    #endif
	    return 1;
	}
	#if defined _ALS_OnFilterScriptExit
	    #undef OnFilterScriptExit
	#else
	    #define _ALS_OnFilterScriptExit
	#endif
	#define OnFilterScriptExit WOW_OnFilterScriptExit
	#if defined WOW_OnFilterScriptExit
	    forward WOW_OnFilterScriptExit();
	#endif
#else
    public OnGameModeInit()
	{
	    WOW_InitScript();
	    #if defined WOW_OnGameModeInit
	        WOW_OnGameModeInit();
	    #endif
	    return 1;
	}
	#if defined _ALS_OnGameModeInit
	    #undef OnGameModeInit
	#else
	    #define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit WOW_OnGameModeInit
	#if defined WOW_OnGameModeInit
	    forward WOW_OnGameModeInit();
	#endif

    public OnGameModeExit()
	{
	    WOW_ExitScript();
	    #if defined WOW_OnGameModeExit
	        WOW_OnGameModeExit();
	    #endif
	    return 1;
	}
	#if defined _ALS_OnGameModeExit
	    #undef OnGameModeExit
	#else
	    #define _ALS_OnGameModeExit
	#endif
	#define OnGameModeExit WOW_OnGameModeExit
	#if defined WOW_OnGameModeExit
	    forward WOW_OnGameModeExit();
	#endif
#endif
static WOW_InitScript() {
	//General
	#if WOW_USE_MAP_ANDREAS == true
		new MapAndreasAddress = MapAndreas_GetAddress(); //Don't init MapAndreas when it was already initialized
		if(MapAndreasAddress == 0) {
	    	MapAndreas_Init(WOW_MAP_ANDREAS_MODE); //MapAndreas
	    }
		FCNPC_InitMapAndreas(MapAndreas_GetAddress()); //MapAndreas
	#endif
	FCNPC_SetUpdateRate(50);
 	WOW_UpdateTimer = SetTimer("WOW_Update", WOW_UPDATE_TIME, true);
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
		WOW_PauseTickCount[playerid] = GetTickCount();
		WOW_PlayerPaused[playerid] = false;
	}
	WOW_PauseTimer = SetTimer("WOW_CheckPausedPlayers", 1000, 1);

	//Boss
 	WOW_InitAllBosses();

	//Spell
 	WOW_InitAllSpells();
 	
 	//Casting
	WOW_InitAllBossesCasting();
	
	printf("---------------------");
	printf("  FCNPC Boss loaded  ");
	printf("- Version: %s     ", WOW_VERSION);
	printf("- Author: Freaksken  ");
	printf("---------------------");
}
static WOW_ExitScript() {
	//General
	KillTimer(WOW_UpdateTimer);
 	WOW_UpdateTimer = WOW_INVALID_TIMER_ID;
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
		WOW_PauseTickCount[playerid] = GetTickCount();
		WOW_PlayerPaused[playerid] = false;
	}
	KillTimer(WOW_PauseTimer);
	WOW_PauseTimer = WOW_INVALID_TIMER_ID;

 	//Boss
    WOW_DestroyAllBosses();

    //Spell
 	WOW_DestroyAllSpells();
 	
 	//Casting
 	WOW_InitAllBossesCasting();
}

public OnPlayerDisconnect(playerid, reason) {
    new bossid = WOW_GetBossIdFromPlayerid(playerid);
    if(WOW_IsValidBoss(bossid)) {
		WOW_DestroyBossNoFCNPC_Destroy(bossid);
    }
    #if defined WOW_OnPlayerDisconnect
        WOW_OnPlayerDisconnect(playerid, reason);
    #endif
	return 1;
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect WOW_OnPlayerDisconnect
#if defined WOW_OnPlayerDisconnect
    forward WOW_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerConnect(playerid) {
	WOW_PauseTickCount[playerid] = GetTickCount();
	WOW_PlayerPaused[playerid] = false;
    #if defined WOW_OnPlayerConnect
        WOW_OnPlayerConnect(playerid);
    #endif
	return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect WOW_OnPlayerConnect
#if defined WOW_OnPlayerConnect
    forward WOW_OnPlayerConnect(playerid);
#endif

public OnPlayerRequestClass(playerid, classid)
{
	//ForceClassSelection doesn't call a state change and thus PLAYER_STATE_WASTED isn't set
	for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][0]);
		TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][1]);
		TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][2]);
		TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][3]);
		TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][4]);
		TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][5]);
		TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][6]);
		TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][7]);
	}
    #if defined WOW_OnPlayerRequestClass
        WOW_OnPlayerRequestClass(playerid, classid);
    #endif
	return 1;
}
#if defined _ALS_OnPlayerRequestClass
    #undef OnPlayerRequestClass
#else
    #define _ALS_OnPlayerRequestClass
#endif
#define OnPlayerRequestClass WOW_OnPlayerRequestClass
#if defined WOW_OnPlayerRequestClass
    forward WOW_OnPlayerRequestClass(playerid, classid);
#endif

public OnPlayerUpdate(playerid)
{
	WOW_PauseTickCount[playerid] = GetTickCount();
    #if defined WOW_OnPlayerUpdate
        WOW_OnPlayerUpdate(playerid);
    #endif
	return 1;
}

#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate WOW_OnPlayerUpdate
#if defined WOW_OnPlayerUpdate
    forward WOW_OnPlayerUpdate(playerid);
#endif

/*
* FCNPC BEHAVIOUR:
* FCNPC_Spawn when not yet spawned => spawn, health is full, even if FCNPC_SetHealth was used after FCNPC_Create
* FCNPC_Spawn when already spawned => nothing
* FCNPC_Spawn when dead => nothing
* FCNPC_Respawn when not yet spawned => nothing
* FCNPC_Respawn when already spawned => respawn, health doesn't reset
* FCNPC_Respawn when dead => respawn, health resets only if FCNPC_SetHealth was not used with value > 0.0 after death
* FCNPC_SetPosition when not yet spawned => nothing
* FCNPC_SetPosition when already spawned => setposition, health doesn't reset
* FCNPC_SetPosition when dead => nothing
* FCNPC_SetHealth when not yet spawned => sethealth, but will reset when spawned
* FCNPC_SetHealth when already spawned => sethealth
* FCNPC_SetHealth when dead => sethealth, health doesn't reset when respawned
*/
public FCNPC_OnRespawn(npcid)
{
	new bossid = WOW_GetBossIdFromPlayerid(npcid);
	if(WOW_IsValidBoss(bossid)) {
	    if(WOW_Bosses[bossid][CUR_HEALTH] != 0) {
			//In case the boss is casting when the encounter hasn't started yet (can happen by using startbosscastingspell). WOW_SetBossTargetWithReason doesn't take care of this for various reasons.
			if(WOW_Bosses[bossid][TARGET] == INVALID_PLAYER_ID && WOW_IsBossCasting(bossid)) {
		      	WOW_StopBossCasting(bossid);
			}
			//Reset target
			WOW_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0);
	    } else {
			WOW_SetBossCurrentHealth(bossid, WOW_Bosses[bossid][MAX_HEALTH]);
	    }
	}
    #if defined WOW_FCNPC_OnRespawn
        WOW_FCNPC_OnRespawn(npcid);
    #endif
    return 1;
}
#if defined _ALS_FCNPC_OnRespawn
    #undef FCNPC_OnRespawn
#else
    #define _ALS_FCNPC_OnRespawn
#endif
#define FCNPC_OnRespawn WOW_FCNPC_OnRespawn
#if defined WOW_FCNPC_OnRespawn
    forward WOW_FCNPC_OnRespawn(npcid);
#endif
public FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss)
{
	new ret = 1;
	new bossid = WOW_GetBossIdFromPlayerid(npcid);
	if(WOW_IsValidBoss(bossid)) {
		ret = WOW_DamageBoss(bossid, damagerid, health_loss);
	}
    #if defined WOW_FCNPC_OnTakeDamage
        WOW_FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss);
    #endif
    return ret;
}
#if defined _ALS_FCNPC_OnTakeDamage
    #undef FCNPC_OnTakeDamage
#else
    #define _ALS_FCNPC_OnTakeDamage
#endif
#define FCNPC_OnTakeDamage WOW_FCNPC_OnTakeDamage
#if defined WOW_FCNPC_OnTakeDamage
    forward WOW_FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss);
#endif
stock WOW_DamageBoss(bossid, damagerid, Float:amount) {
	if(WOW_IsValidBoss(bossid) && (IsPlayerConnected(damagerid) || damagerid == INVALID_PLAYER_ID)) {
	    new bossplayerid = WOW_GetBossNPCId(bossid);
		//1st part of condition: if the npc is dead, this function can still be called before the OnDeath callback gets called (mainly when shot with fast guns: minigun, ...)
		//2nd part of condition: damage not inflicted by players (falling, ...)
		//3rd part of condition: neccesary to reject invalid damage done: the NPC is visible and thus damagable in other interiors
	 	if(!FCNPC_IsDead(bossplayerid) && (damagerid == INVALID_PLAYER_ID || GetPlayerInterior(damagerid) == FCNPC_GetInterior(bossplayerid))) {
			//Set target to damagerid if no target yet (valid damagerid + no target yet check in setter)
			WOW_SetBossTargetWithReason(bossid, damagerid, 1);
			//Dont damage below 0
			if(WOW_Bosses[bossid][CUR_HEALTH] > amount) {
				WOW_SetBossCurrentHealth(bossid, WOW_Bosses[bossid][CUR_HEALTH] - amount);
			} else {
				//Make the damager that makes the last shot, kill the boss
				FCNPC_SetHealth(bossplayerid, WOW_Bosses[bossid][CUR_HEALTH]);
				//WOW_SetBossCurrentHealth(bossid, 0); //Happens in FCNPC_OnDeath
				//Return 1 to allow the dammage to be afflicted to npc, which will kill him in this case
				return 1;
			}
	 	}
	}
	//Return 0 to prevent damage to be afflicted to npc, update CUR_HEALTH instead
	return 0;
}
stock WOW_HealBoss(bossid, healerid, Float:amount) {
	if(WOW_IsValidBoss(bossid) && (IsPlayerConnected(healerid) || healerid == INVALID_PLAYER_ID)) {
		new bossplayerid = WOW_GetBossNPCId(bossid);
		if(!FCNPC_IsDead(bossplayerid)) {
			//Don't heal above MAX_HEALTH
			if(WOW_Bosses[bossid][MAX_HEALTH] - WOW_Bosses[bossid][CUR_HEALTH] <= amount) {
				WOW_SetBossCurrentHealth(bossid, WOW_Bosses[bossid][MAX_HEALTH]);
				return 1;
			} else {
				WOW_SetBossCurrentHealth(bossid, WOW_Bosses[bossid][CUR_HEALTH] + amount);
			}
		}
	}
	return 0;
}
public FCNPC_OnDeath(npcid, killerid, weaponid)
{
	new bossid = WOW_GetBossIdFromPlayerid(npcid);
	if(WOW_IsValidBoss(bossid)) {
		//In case the boss is casting when the encounter hasn't started yet (can happen by using startbosscastingspell). WOW_SetBossTargetWithReason doesn't take care of this for various reasons.
		if(WOW_Bosses[bossid][TARGET] == INVALID_PLAYER_ID && WOW_IsBossCasting(bossid)) {
	      	WOW_StopBossCasting(bossid);
		}
	    //Reset target
		WOW_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 2);
		//If the boss was killed with FCNPC_Kill or FCNPC_SetHealth with value <= 0.0, not by taking damage
		WOW_SetBossCurrentHealth(bossid, 0);
	}
	#if defined WOW_FCNPC_OnDeath
        WOW_FCNPC_OnDeath(npcid, killerid, weaponid);
    #endif
	return 1;
}
#if defined _ALS_FCNPC_OnDeath
    #undef FCNPC_OnDeath
#else
    #define _ALS_FCNPC_OnDeath
#endif
#define FCNPC_OnDeath WOW_FCNPC_OnDeath
#if defined WOW_FCNPC_OnDeath
    forward WOW_FCNPC_OnDeath(npcid, killerid, weaponid);
#endif

forward WOW_Update();
public WOW_Update() {
	//Boss
	//Show/hide boss textdraws & mapicon to player
	for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
		//Last part of condition:  we don't need to display things to an npc
	   if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid)) {
			new closestBoss = WOW_GetClosestBossToDisplay(playerid);
			//Hide the textdraws all bosses share if no boss is in range for a player
			if(!WOW_IsValidBoss(closestBoss)) {
				TextDrawHideForPlayer(playerid, WOW_BossBlackHealth);
				TextDrawHideForPlayer(playerid, WOW_BossDarkRed);
				TextDrawHideForPlayer(playerid, WOW_BossBlackCast);
			}
			//Show the textdraws all bosses share if a boss is in range for a player
			else {
				TextDrawShowForPlayer(playerid, WOW_BossBlackHealth);
				TextDrawShowForPlayer(playerid, WOW_BossDarkRed);
				if(WOW_IsBossCasting(closestBoss) || WOW_IsBossCastBarExtra(closestBoss)) {
					TextDrawShowForPlayer(playerid, WOW_BossBlackCast);
				} else {
					TextDrawHideForPlayer(playerid, WOW_BossBlackCast);
				}
			}
			for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
			    //Show the mapicon if the boss is valid for a player
			    if(WOW_IsBossValidForPlayer(playerid, bossid) && WOW_Bosses[bossid][ICONID] != WOW_INVALID_ICON_ID) {
    				new Float:bossX, Float:bossY, Float:bossZ;
	        		FCNPC_GetPosition(WOW_Bosses[bossid][NPCID], bossX, bossY, bossZ);
					SetPlayerMapIcon(playerid, WOW_Bosses[bossid][ICONID], bossX, bossY, bossZ, WOW_Bosses[bossid][ICON_MARKER], WOW_Bosses[bossid][ICON_COLOR], WOW_Bosses[bossid][ICON_STYLE]);
			    }
			    //Hide the mapicon if the boss is invalid for a player
				else {
					RemovePlayerMapIcon(playerid, WOW_Bosses[bossid][ICONID]);
			    }
				//Show the textdraws specific to a boss if he is the closest boss for a player
			    if(bossid == closestBoss) {
					TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][0]);
					TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][1]);
					TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][2]);
					TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][3]);
					if(WOW_IsBossCasting(bossid) || WOW_IsBossCastBarExtra(bossid)) {
						TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][4]);
						TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][5]);
						TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][6]);
						TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][7]);
					} else {
						TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][4]);
						TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][5]);
						TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][6]);
						TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][7]);
					}
			    }
				//Hide the textdraws specific to a boss if he is not the closest boss for a player
				//Otherwise if multiple bosses are in range, their textdraws will be put on top of eachother, which is ugly and we don't want of course
				else {
					TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][0]);
					TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][1]);
					TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][2]);
					TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][3]);
					TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][4]);
					TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][5]);
					TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][6]);
					TextDrawHideForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][7]);
			    }
			}
		}
	}
	
	//Update boss
	for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
	    if(WOW_IsValidBoss(bossid) && !FCNPC_IsDead(WOW_Bosses[bossid][NPCID])) {
	        //Update casting bar
			WOW_IncreaseBossCastProgress(bossid);
			//Get new target if no target, or if old target invalid, or if the boss is not streamed in anymore for his old target
			if(!WOW_IsBossValidForPlayer(WOW_Bosses[bossid][TARGET], bossid) || !IsPlayerStreamedIn(WOW_Bosses[bossid][NPCID], WOW_Bosses[bossid][TARGET])) {
			    //Set target to closestPlayerid (valid closestPlayerid check in setter)
				WOW_SetBossTargetWithReason(bossid, WOW_GetClosestPlayerToTakeAggro(bossid), 3);
			}
	        //Attack target (which can be set above) if target known
	        if(WOW_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
          		WOW_BossAttackTarget(bossid, WOW_Bosses[bossid][TARGET]);
          	}
	    }
	}
}

forward WOW_CheckPausedPlayers();
public WOW_CheckPausedPlayers() {
	for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
	    new PlayerState = GetPlayerState(playerid);
	    //On initialization and when the player is dead or when the player is in class selection, OnPlayerUpdate will not be called
	    if(IsPlayerConnected(playerid) && PlayerState != PLAYER_STATE_WASTED && PlayerState != PLAYER_STATE_NONE) {
	        new bool:PlayerInGame = true;
	        if(WOW_GetTickCountDiff(WOW_PauseTickCount[playerid], GetTickCount()) > 2000) {
				PlayerInGame = false;
			}
	        if(!PlayerInGame && !WOW_PlayerPaused[playerid]) {
				WOW_PlayerPaused[playerid] = true;
	        } else if(PlayerInGame && WOW_PlayerPaused[playerid]){
				WOW_PlayerPaused[playerid] = false;
	        }
		}
	}
	return 1;
}
//This fixes the problem with GetTickCount integer overflow when the server is run for 24+ days
static WOW_GetTickCountAbs(integer) {
    if(integer < 0) {
        return integer * -1;
    }
    return integer;
}
static WOW_GetTickCountIntDiffAbs(oldInteger, newInteger) {
    if(oldInteger > newInteger) {
    	return WOW_GetTickCountAbs(oldInteger - newInteger);
    }
    return WOW_GetTickCountAbs(newInteger - oldInteger);
}
static WOW_GetTickCountDiff(oldInteger, newInteger) {
	//Integer max: 2147483647
    if(oldInteger < 0 && newInteger > 0) {
        new dist = WOW_GetTickCountIntDiffAbs(oldInteger, newInteger);
        if(dist > 2147483647) {
            return WOW_GetTickCountIntDiffAbs(oldInteger - 2147483647, newInteger - 2147483647);
        }
        return dist;
    }
    return WOW_GetTickCountIntDiffAbs(oldInteger, newInteger);
}

//Boss
static WOW_InitAllBosses() {
	WOW_BossBlackHealth = TextDrawCreate(169.0, 429, "_");
	TextDrawUseBox(WOW_BossBlackHealth, 1);
	TextDrawBoxColor(WOW_BossBlackHealth, 0x000000ff);
	TextDrawLetterSize(WOW_BossBlackHealth, 0.0, 0.7);
	TextDrawTextSize(WOW_BossBlackHealth, 471.0, 0.0);
	WOW_BossDarkRed = TextDrawCreate(170.0, 430.0, "_");
	TextDrawUseBox(WOW_BossDarkRed, 1);
	TextDrawBoxColor(WOW_BossDarkRed, 0x5A0C0EFF);
	TextDrawLetterSize(WOW_BossDarkRed, 0.0, 0.5);
	TextDrawTextSize(WOW_BossDarkRed, 470.0, 0.0);
	WOW_BossBlackCast = TextDrawCreate(169.0, 439, "_");
	TextDrawUseBox(WOW_BossBlackCast, 1);
	TextDrawBoxColor(WOW_BossBlackCast, 0x000000ff);
	TextDrawLetterSize(WOW_BossBlackCast, 0.0, 0.7);
	TextDrawTextSize(WOW_BossBlackCast, 471.0, 0.0);
	for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
	    WOW_InitBoss(bossid);
	}
}
static WOW_InitBoss(bossid) {
	//Don't use WOW_IsValidBoss(bossid)
	if(bossid >= 0 && bossid < WOW_MAX_BOSSES) {
		WOW_Bosses[bossid][TEXTDRAW][0] = TextDrawCreate(170.0, 430.0, "_");
		TextDrawUseBox(WOW_Bosses[bossid][TEXTDRAW][0], 1);
		TextDrawBoxColor(WOW_Bosses[bossid][TEXTDRAW][0], 0xB4191DFF);
		TextDrawTextSize(WOW_Bosses[bossid][TEXTDRAW][0], 470.0, 0.0);
		TextDrawLetterSize(WOW_Bosses[bossid][TEXTDRAW][0], 0.0, 0.5);
		WOW_Bosses[bossid][TEXTDRAW][1] = TextDrawCreate(170.0, 429.0, "_");
		TextDrawFont(WOW_Bosses[bossid][TEXTDRAW][1], 1);
		TextDrawAlignment(WOW_Bosses[bossid][TEXTDRAW][1], 1);
		TextDrawSetProportional(WOW_Bosses[bossid][TEXTDRAW][1], 1);
		TextDrawColor(WOW_Bosses[bossid][TEXTDRAW][1], 0xffffffff);
		TextDrawSetShadow(WOW_Bosses[bossid][TEXTDRAW][1], 0);
		TextDrawSetOutline(WOW_Bosses[bossid][TEXTDRAW][1], 1);
		TextDrawLetterSize(WOW_Bosses[bossid][TEXTDRAW][1], 0.2, 0.7);
		WOW_Bosses[bossid][TEXTDRAW][2] = TextDrawCreate(470.0, 429.0, "_");
		TextDrawFont(WOW_Bosses[bossid][TEXTDRAW][2], 1);
		TextDrawAlignment(WOW_Bosses[bossid][TEXTDRAW][2], 3);
		TextDrawSetProportional(WOW_Bosses[bossid][TEXTDRAW][2], 1);
		TextDrawColor(WOW_Bosses[bossid][TEXTDRAW][2], 0xffffffff);
		TextDrawSetShadow(WOW_Bosses[bossid][TEXTDRAW][2], 0);
		TextDrawSetOutline(WOW_Bosses[bossid][TEXTDRAW][2], 1);
		TextDrawLetterSize(WOW_Bosses[bossid][TEXTDRAW][2], 0.2, 0.7);
		WOW_Bosses[bossid][TEXTDRAW][3] = TextDrawCreate(169.0, 415, "_");
		TextDrawFont(WOW_Bosses[bossid][TEXTDRAW][3], 0);
		TextDrawAlignment(WOW_Bosses[bossid][TEXTDRAW][3], 1);
		TextDrawSetProportional(WOW_Bosses[bossid][TEXTDRAW][3], 1);
		TextDrawColor(WOW_Bosses[bossid][TEXTDRAW][3], 0xffffffff);
		TextDrawSetShadow(WOW_Bosses[bossid][TEXTDRAW][3], 0);
		TextDrawSetOutline(WOW_Bosses[bossid][TEXTDRAW][3], 1);
		TextDrawLetterSize(WOW_Bosses[bossid][TEXTDRAW][3], 0.3, 1.0);
		WOW_Bosses[bossid][TEXTDRAW][4] = TextDrawCreate(170.0, 440.0, "_");
		TextDrawUseBox(WOW_Bosses[bossid][TEXTDRAW][4], 1);
		TextDrawBoxColor(WOW_Bosses[bossid][TEXTDRAW][4], 0x645005ff);
		TextDrawTextSize(WOW_Bosses[bossid][TEXTDRAW][4], 470.0, 0.0);
		TextDrawLetterSize(WOW_Bosses[bossid][TEXTDRAW][4], 0.0, 0.5);
		WOW_Bosses[bossid][TEXTDRAW][5] = TextDrawCreate(170.0, 440.0, "_");
		TextDrawUseBox(WOW_Bosses[bossid][TEXTDRAW][5], 1);
		TextDrawBoxColor(WOW_Bosses[bossid][TEXTDRAW][5], 0xB4820AFF);
		TextDrawTextSize(WOW_Bosses[bossid][TEXTDRAW][5], 470.0, 0.0);
		TextDrawLetterSize(WOW_Bosses[bossid][TEXTDRAW][5], 0.0, 0.5);
		WOW_Bosses[bossid][TEXTDRAW][6] = TextDrawCreate(170.0, 439.0, "_");
		TextDrawFont(WOW_Bosses[bossid][TEXTDRAW][6], 1);
		TextDrawAlignment(WOW_Bosses[bossid][TEXTDRAW][6], 1);
		TextDrawSetProportional(WOW_Bosses[bossid][TEXTDRAW][6], 1);
		TextDrawColor(WOW_Bosses[bossid][TEXTDRAW][6], 0xffffffff);
		TextDrawSetShadow(WOW_Bosses[bossid][TEXTDRAW][6], 0);
		TextDrawSetOutline(WOW_Bosses[bossid][TEXTDRAW][6], 1);
		TextDrawLetterSize(WOW_Bosses[bossid][TEXTDRAW][6], 0.2, 0.7);
		WOW_Bosses[bossid][TEXTDRAW][7] = TextDrawCreate(470.0, 439.0, "_");
		TextDrawFont(WOW_Bosses[bossid][TEXTDRAW][7], 1);
		TextDrawAlignment(WOW_Bosses[bossid][TEXTDRAW][7], 3);
		TextDrawSetProportional(WOW_Bosses[bossid][TEXTDRAW][7], 1);
		TextDrawColor(WOW_Bosses[bossid][TEXTDRAW][7], 0xffffffff);
		TextDrawSetShadow(WOW_Bosses[bossid][TEXTDRAW][7], 0);
		TextDrawSetOutline(WOW_Bosses[bossid][TEXTDRAW][7], 1);
		TextDrawLetterSize(WOW_Bosses[bossid][TEXTDRAW][7], 0.2, 0.7);
		WOW_ResetBossStats(bossid);
	}
}
static WOW_ResetBossStats(bossid) {
	//Don't use WOW_IsValidBoss(bossid)
	if(bossid >= 0 && bossid < WOW_MAX_BOSSES) {
		format(WOW_Bosses[bossid][FULL_NAME], WOW_MAX_BOSS_FULL_NAME + 1, "%s", WOW_INVALID_STRING);
		WOW_Bosses[bossid][ICONID] = WOW_INVALID_ICON_ID;
		WOW_Bosses[bossid][ICON_MARKER] = 0;
		WOW_Bosses[bossid][ICON_COLOR] = WOW_INVALID_COLOR;
		WOW_Bosses[bossid][ICON_STYLE] = MAPICON_LOCAL;
		WOW_Bosses[bossid][MAX_HEALTH] = 0.0;
		WOW_Bosses[bossid][RANGE_DISPLAY] = 0.0;
		WOW_Bosses[bossid][RANGE_AGGRO] = 0.0;
		WOW_Bosses[bossid][DISPLAY_IF_DEAD] = false;
		WOW_Bosses[bossid][CUR_HEALTH] = 0.0;
		WOW_Bosses[bossid][TARGET] = INVALID_PLAYER_ID;
		WOW_Bosses[bossid][MOVE_TYPE] = MOVE_TYPE_AUTO;
		WOW_Bosses[bossid][MOVE_SPEED] = 0.0;
		WOW_Bosses[bossid][MOVE_RADIUS] = 0.0;
		WOW_Bosses[bossid][MOVE_SET_ANGLE] = false;
		WOW_Bosses[bossid][RANGED_ATTACK_DISTANCE] = 0.0;
		WOW_Bosses[bossid][RANGED_ATTACK_DELAY] = 0;
		WOW_Bosses[bossid][RANGED_ATTACK_SET_ANGLE] = false;
		WOW_Bosses[bossid][MELEE_ATTACK_DISTANCE] = 0.0;
		WOW_Bosses[bossid][MELEE_ATTACK_DELAY] = 0;
		WOW_Bosses[bossid][MELEE_ATTACK_USE_FIGHT_STYLE] = false;
		WOW_Bosses[bossid][NPCID] = INVALID_PLAYER_ID;
	}
}
forward bool:WOW_IsValidBoss(bossid); //Silence 'used before declaration' warning
stock bool:WOW_IsValidBoss(bossid) {
	if(bossid >= 0 && bossid < WOW_MAX_BOSSES && WOW_Bosses[bossid][NPCID] != INVALID_PLAYER_ID) {
	    return true;
	}
	return false;
}
stock WOW_DestroyAllBosses() {
	TextDrawDestroy(WOW_BossBlackHealth);
	TextDrawDestroy(WOW_BossDarkRed);
	TextDrawDestroy(WOW_BossBlackCast);
	WOW_BossBlackHealth = Text:INVALID_TEXT_DRAW;
	WOW_BossDarkRed = Text:INVALID_TEXT_DRAW;
	WOW_BossBlackCast = Text:INVALID_TEXT_DRAW;
	for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
	    WOW_DestroyBoss(bossid);
	}
	return 1;
}
stock WOW_DestroyBoss(bossid) {
	if(WOW_IsValidBoss(bossid)) {
	    FCNPC_Destroy(WOW_Bosses[bossid][NPCID]);
	    //WOW_DestroyBossNoFCNPC_Destroy will be called by OnPlayerDisconnect
    	return 1;
    }
    return 0;
}
static WOW_DestroyBossNoFCNPC_Destroy(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
 			RemovePlayerMapIcon(playerid, WOW_Bosses[bossid][ICONID]);
		}
		//In case the boss is casting when the encounter hasn't started yet (can happen by using startbosscastingspell). WOW_SetBossTargetWithReason doesn't take care of this for various reasons.
		if(WOW_Bosses[bossid][TARGET] == INVALID_PLAYER_ID && WOW_IsBossCasting(bossid)) {
	      	WOW_StopBossCasting(bossid);
		}
		//Reset target
		WOW_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0); //WOW_Casting gets reset in here, so we don't need to reset it manually again
		TextDrawDestroy(WOW_Bosses[bossid][TEXTDRAW][0]);
		TextDrawDestroy(WOW_Bosses[bossid][TEXTDRAW][1]);
		TextDrawDestroy(WOW_Bosses[bossid][TEXTDRAW][2]);
		TextDrawDestroy(WOW_Bosses[bossid][TEXTDRAW][3]);
		TextDrawDestroy(WOW_Bosses[bossid][TEXTDRAW][4]);
		TextDrawDestroy(WOW_Bosses[bossid][TEXTDRAW][5]);
		TextDrawDestroy(WOW_Bosses[bossid][TEXTDRAW][6]);
		TextDrawDestroy(WOW_Bosses[bossid][TEXTDRAW][7]);
		WOW_Bosses[bossid][TEXTDRAW][0] = Text:INVALID_TEXT_DRAW;
		WOW_Bosses[bossid][TEXTDRAW][1] = Text:INVALID_TEXT_DRAW;
		WOW_Bosses[bossid][TEXTDRAW][2] = Text:INVALID_TEXT_DRAW;
		WOW_Bosses[bossid][TEXTDRAW][3] = Text:INVALID_TEXT_DRAW;
		WOW_Bosses[bossid][TEXTDRAW][4] = Text:INVALID_TEXT_DRAW;
		WOW_Bosses[bossid][TEXTDRAW][5] = Text:INVALID_TEXT_DRAW;
		WOW_Bosses[bossid][TEXTDRAW][6] = Text:INVALID_TEXT_DRAW;
		WOW_Bosses[bossid][TEXTDRAW][7] = Text:INVALID_TEXT_DRAW;
	    WOW_ResetBossStats(bossid);
	}
}
stock WOW_CreateBossFull(name[], fullName[] = WOW_INVALID_STRING, iconid = WOW_INVALID_ICON_ID, iconMarker = 23, iconColor = 0xff0000ff, iconStyle = MAPICON_LOCAL, Float:maxHealth = 100000.0,
Float:rangeDisplay = 100.0, Float:rangeAggro = 20.0, bool:displayIfDead = true, Float:currentHealth = -1.0, targetid = INVALID_PLAYER_ID,
moveType = MOVE_TYPE_SPRINT, Float:moveSpeed = -1.0, Float:moveRadius = 0.0, bool:moveSetAngle = true, Float:rangedAttackDistance = 20.0, rangedAttackDelay = 0, bool:rangedAttackSetAngle = true,
Float:meleeAttackDistance = 1.0, meleeAttackDelay = -1, bool:meleeAttackUseFightStyle = true) {
	for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		if(WOW_Bosses[bossid][NPCID] == INVALID_PLAYER_ID) {
			WOW_Bosses[bossid][NPCID] = FCNPC_Create(name);
			if(WOW_Bosses[bossid][NPCID] != INVALID_PLAYER_ID) {
		 		WOW_SetBossFullName(bossid, fullName);
				WOW_SetBossMapiconInfo(bossid, iconid, iconMarker, iconColor, iconStyle);
				WOW_SetBossMaxHealth(bossid, maxHealth, false);
				WOW_SetBossDisplayRange(bossid, rangeDisplay);
				WOW_SetBossAggroRange(bossid, rangeAggro, false);
				WOW_SetBossDisplayIfDead(bossid, displayIfDead);
				WOW_SetBossCurrentHealth(bossid, currentHealth, false);
				WOW_SetBossTarget(bossid, targetid, false);
				WOW_SetBossMoveInfo(bossid, moveType, moveSpeed, moveRadius, moveSetAngle);
				WOW_SetBossRangedAttackInfo(bossid, rangedAttackDistance, rangedAttackDelay, rangedAttackSetAngle);
				WOW_SetBossMeleeAttackInfo(bossid, meleeAttackDistance, meleeAttackDelay, meleeAttackUseFightStyle);
		    	return bossid;
		    } else {
		        //FCNPC_Create failed
		    	return WOW_INVALID_BOSS_ID;
		    }
		}
	}
	//Max amount of bosses reached
	return WOW_INVALID_BOSS_ID;
}
stock WOW_CreateBoss(name[]) {
	return WOW_CreateBossFull(name);
}
stock WOW_GetBossFullName(bossid, name[], len) {
	if(WOW_IsValidBoss(bossid)) {
	    format(name, len, "%s", WOW_Bosses[bossid][FULL_NAME]);
		return strlen(name);
	}
	return -1;
}
stock WOW_SetBossFullName(bossid, name[]) {
	if(WOW_IsValidBoss(bossid)) {
	    //If the user didn't provide a valid fullName, use the playerName
	    if(!WOW_isnull(name) && !strcmp(name, WOW_INVALID_STRING, true)) {
	        new playerName[MAX_PLAYER_NAME + 1];
	        GetPlayerName(WOW_Bosses[bossid][NPCID], playerName, sizeof(playerName));
			format(WOW_Bosses[bossid][FULL_NAME], WOW_MAX_BOSS_FULL_NAME + 1, "%s", playerName);
		}
	    //If the user did provide a valid fullName, use that one
 		else {
			format(WOW_Bosses[bossid][FULL_NAME], WOW_MAX_BOSS_FULL_NAME + 1, "%s", name);
		}
		TextDrawSetString(WOW_Bosses[bossid][TEXTDRAW][3], WOW_Bosses[bossid][FULL_NAME]);
		//FullName textdraw updates automatically
		return 1;
	}
	return 0;
}
stock WOW_GetBossMapiconInfo(bossid, &iconid, &iconMarker, &iconColor, &iconStyle) {
	if(WOW_IsValidBoss(bossid)) {
		iconid = WOW_Bosses[bossid][ICONID];
		iconMarker = WOW_Bosses[bossid][ICON_MARKER];
		iconColor = WOW_Bosses[bossid][ICON_COLOR];
		iconStyle = WOW_Bosses[bossid][ICON_STYLE];
		return 1;
	}
	return 0;
}
stock WOW_SetBossMapiconInfo(bossid, iconid = WOW_INVALID_ICON_ID, iconMarker = 23, iconColor = 0xff0000ff, iconStyle = MAPICON_LOCAL) {
	if(WOW_IsValidBoss(bossid)) {
		if(iconid == WOW_INVALID_ICON_ID) {
			for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
	 			RemovePlayerMapIcon(playerid, WOW_Bosses[bossid][ICONID]);
			}
		}
	    WOW_Bosses[bossid][ICONID] = iconid;
		//Icon settings below, update automatically (see WOW_Update)
		WOW_Bosses[bossid][ICON_MARKER] = iconMarker;
		WOW_Bosses[bossid][ICON_COLOR] = iconColor;
		WOW_Bosses[bossid][ICON_STYLE] = iconStyle;
		return 1;
	}
	return 0;
}
stock WOW_GetBossMaxHealth(bossid, &Float:health) {
	if(WOW_IsValidBoss(bossid)) {
		health = WOW_Bosses[bossid][MAX_HEALTH];
		return 1;
	}
	return 0;
}
/*
Keeppercent:
- max 500, cur 450 => max 400, cur becomes 360
- max 500, cur 450 => max 600, cur becomes 540
Dont keeppercent:
- max 500, cur 450 => max 400, cur becomes 400 which is max
- max 500, cur 450 => max 600, cur stays 450
*/
stock WOW_SetBossMaxHealth(bossid, Float:health, bool:keepHealthPercent = false) {
	if(WOW_IsValidBoss(bossid)) {
		if(health <= 0.0) {
		    if(!FCNPC_IsDead(WOW_Bosses[bossid][NPCID])) {
		    	FCNPC_Kill(WOW_Bosses[bossid][NPCID]);
		    }
		    health = 0.0;
		}
	    if(!keepHealthPercent) {
	        if(WOW_Bosses[bossid][CUR_HEALTH] > health) {
	    		WOW_Bosses[bossid][CUR_HEALTH] = health;
	    	}
	    } else {
	    	WOW_Bosses[bossid][CUR_HEALTH] = float(WOW_GetBossCurrentHealthPercent(bossid)) / 100 * health;
	    }
		WOW_Bosses[bossid][MAX_HEALTH] = health;
		WOW_UpdateBossHealthDisplay(bossid);
		return 1;
	}
	return 0;
}
stock WOW_GetBossDisplayRange(bossid, &Float:range) {
	if(WOW_IsValidBoss(bossid)) {
		range = WOW_Bosses[bossid][RANGE_DISPLAY];
		return 1;
	}
	return 0;
}
stock WOW_SetBossDisplayRange(bossid, Float:range) {
	if(WOW_IsValidBoss(bossid)) {
	    if(range < 0.0) {
	        range = 0.0;
	    }
		WOW_Bosses[bossid][RANGE_DISPLAY] = range;
		//Textdraws update automatically (see WOW_Update)
		return 1;
	}
	return 0;
}
stock WOW_GetBossAggroRange(bossid, &Float:range) {
	if(WOW_IsValidBoss(bossid)) {
		range = WOW_Bosses[bossid][RANGE_AGGRO];
		return 1;
	}
	return 0;
}
/*
Checkfortarget:
- range 25.0, has target => range 10.0, target in new range, nothing
- range 25.0, has target => range 10.0, target not in new range, target loses aggro
- range 25.0, no target  => range 10.0, nothing
Dont checkfortarget:
- range 25.0, has target => range 10.0, target keeps aggro
- range 25.0, no target  => range 10.0, nothing
*/
stock WOW_SetBossAggroRange(bossid, Float:range, bool:checkForTarget = false) {
	if(WOW_IsValidBoss(bossid)) {
		if(range < 0.0) {
		    range = 0.0;
		}
		WOW_Bosses[bossid][RANGE_AGGRO] = range;
		if(checkForTarget) {
		    if(!WOW_IsPlayerInAggroRange(WOW_Bosses[bossid][TARGET], bossid)) {
		        //Reset target
				WOW_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0);
		    }
		}
		return 1;
	}
	return 0;
}
stock WOW_GetBossDisplayIfDead(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		return WOW_Bosses[bossid][DISPLAY_IF_DEAD];
	}
	return -1;
}
stock WOW_SetBossDisplayIfDead(bossid, bool:displayIfDead) {
	if(WOW_IsValidBoss(bossid)) {
		WOW_Bosses[bossid][DISPLAY_IF_DEAD] = displayIfDead;
		//Textdraws update automatically (see WOW_Update)
		return 1;
	}
	return 0;
}
stock WOW_GetBossCurrentHealth(bossid, &Float:health) {
	if(WOW_IsValidBoss(bossid)) {
		health = WOW_Bosses[bossid][CUR_HEALTH];
		return 1;
	}
	return 0;
}
/*
Keeppercent:
- max 500, cur 450 => cur 400, max becomes 444
- max 500, cur 450 => cur 600, max becomes 666
Dont keeppercent:
- max 500, cur 450 => cur 400, max stays 500
- max 500, cur 450 => cur 600, max becomes 600 which is cur
*/
stock WOW_SetBossCurrentHealth(bossid, Float:health, bool:keepHealthPercent = false) {
	if(WOW_IsValidBoss(bossid)) {
		if(health < 0.0) {
		    health = WOW_Bosses[bossid][MAX_HEALTH];
		} else if(health == 0.0) {
		    if(!FCNPC_IsDead(WOW_Bosses[bossid][NPCID])) {
		    	FCNPC_Kill(WOW_Bosses[bossid][NPCID]);
		    }
		}
		if(!keepHealthPercent) {
	        if(WOW_Bosses[bossid][MAX_HEALTH] < health) {
	    		WOW_Bosses[bossid][MAX_HEALTH] = health;
	    	}
	    } else {
	    	WOW_Bosses[bossid][MAX_HEALTH] *= health / WOW_Bosses[bossid][CUR_HEALTH];
	    }
		WOW_Bosses[bossid][CUR_HEALTH] = health;
		WOW_UpdateBossHealthDisplay(bossid);
		return 1;
	}
	return 0;
}
stock WOW_GetBossTarget(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		return WOW_Bosses[bossid][TARGET];
	}
	return -1;
}
/*
Checkforaggrorange:
- range 25.0, has target => new target, new target in range, switch target
- range 25.0, has target => new target, new target not in range, old target stays
- range 25.0, no target  => new target, new target in range, make target
- range 25.0, no target  => new target, new target not in range, nothing
Dont checkforaggrorange:
- range 25.0, has target => new target, switch target
- range 25.0, no target  => new target, make target
*/
stock WOW_SetBossTarget(bossid, playerid, bool:checkForAggroRange = false) {
	//Set target to playerid (valid playerid check in setter)
	//WOW_IsValidBoss in WOW_SetBossTargetWithReason
	return WOW_SetBossTargetWithReason(bossid, playerid, 4, checkForAggroRange);
}
/*
Reason:
- 0: reset (invalid new target)
- 1: bossDamaged (valid new target, invalid new target)
- 2: bossDeath (invalid new target)
- 3: target aggro (valid new target, invalid new target)
- 4: explicit set (valid new target, invalid new target, checkForAggroRange)
*/
//Invalid boss			 							=> nothing
//Not connected new target 							=> nothing
//Old target same as new target						=> nothing
//CheckForAggroRange and new target not in range   	=> nothing
//CheckIfStreamedIn and new target not streamed in  => nothing
//CheckIfValid and new target not valid             => nothing
//Reason is bossDamaged and old target is valid   	=> nothing
//New valid target, no old target 		=> set target, new target get aggro, start encounter
//New valid target, with old target 	=> old target lose aggro, set target, new target get aggro
//New invalid target, no old target     => set target
//New invalid target, with old target   => old target lose aggro, set target, stop encounter
static WOW_SetBossTargetWithReason(bossid, newtargetid, reason, bool:checkForAggroRange = false) {
	if(WOW_IsValidBoss(bossid)) {
		new oldtargetid = WOW_Bosses[bossid][TARGET];
		if(oldtargetid != newtargetid && (reason != 1 || oldtargetid == INVALID_PLAYER_ID)) {
		    new bool:newTargetValid = true;
		    new bool:newTargetStreamedIn = true;
		    if(newtargetid != INVALID_PLAYER_ID) {
		        if(!WOW_IsBossValidForPlayer(newtargetid, bossid)) {
		        	newTargetValid = false;
		        }
		        if(!IsPlayerStreamedIn(WOW_Bosses[bossid][NPCID], newtargetid)) {
		            newTargetStreamedIn = false;
		        }
		    }
		    new bool:newTargetInRange = true;
		    if(checkForAggroRange && !WOW_IsPlayerInAggroRange(newtargetid, bossid)) {
		        newTargetInRange = false;
		    }
		    if(newTargetValid && newTargetStreamedIn && newTargetInRange) {
		        if(oldtargetid != INVALID_PLAYER_ID) {
					CallRemoteFunction("WOW_OnPlayerLoseAggro", "dd", oldtargetid, bossid);
		        }
				WOW_Bosses[bossid][TARGET] = newtargetid;
				if(newtargetid != INVALID_PLAYER_ID) {
					CallRemoteFunction("WOW_OnPlayerGetAggro", "dd", newtargetid, bossid);
			        if(oldtargetid == INVALID_PLAYER_ID) {
			            new bool:reasonShot = false;
			            if(reason == 1) {
			                reasonShot = true;
			            }
						CallRemoteFunction("WOW_OnBossEncounterStart", "dbd", bossid, reasonShot, newtargetid);
					}
				} else {
			        if(oldtargetid != INVALID_PLAYER_ID) {
			            new bool:reasonDeath = false;
			            if(reason == 2) {
							reasonDeath = true;
			            }
	      				WOW_BossStopAttack(bossid);
	      				WOW_StopBossCasting(bossid);
						CallRemoteFunction("WOW_OnBossEncounterStop", "dbd", bossid, reasonDeath, oldtargetid);
					}
				}
				return 1;
		    }
	    }
	}
	return 0;
}
stock WOW_GetBossMoveInfo(bossid, &type, &Float:speed, &Float:radius, &bool:setAngle) {
	if(WOW_IsValidBoss(bossid)) {
	    type = WOW_Bosses[bossid][MOVE_TYPE];
	    speed = WOW_Bosses[bossid][MOVE_SPEED];
	    radius = WOW_Bosses[bossid][MOVE_RADIUS];
	    setAngle = WOW_Bosses[bossid][MOVE_SET_ANGLE];
	    return 1;
	}
	return 0;
}
stock WOW_SetBossMoveInfo(bossid, type = MOVE_TYPE_SPRINT, Float:speed = -1.0, Float:radius = 0.0, bool:setAngle = true) {
	if(WOW_IsValidBoss(bossid)) {
	    WOW_Bosses[bossid][MOVE_TYPE] = type;
	    WOW_Bosses[bossid][MOVE_SPEED] = speed;
	    WOW_Bosses[bossid][MOVE_RADIUS] = radius;
	    WOW_Bosses[bossid][MOVE_SET_ANGLE] = setAngle;
        if(WOW_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
      		WOW_BossAttackTarget(bossid, WOW_Bosses[bossid][TARGET]);
      	}
	    return 1;
	}
	return 0;
}
stock WOW_GetBossRangedAttackInfo(bossid, &Float:distance, &delay, &bool:setAngle) {
	if(WOW_IsValidBoss(bossid)) {
	    distance = WOW_Bosses[bossid][RANGED_ATTACK_DISTANCE];
	    delay = WOW_Bosses[bossid][RANGED_ATTACK_DELAY];
	    setAngle = WOW_Bosses[bossid][RANGED_ATTACK_SET_ANGLE];
	    return 1;
	}
	return 0;
}
stock WOW_SetBossRangedAttackInfo(bossid, Float:distance = 20.0, delay = 0, bool:setAngle = true) {
	if(WOW_IsValidBoss(bossid)) {
	    WOW_Bosses[bossid][RANGED_ATTACK_DISTANCE] = distance;
	    WOW_Bosses[bossid][RANGED_ATTACK_DELAY] = delay;
	    WOW_Bosses[bossid][RANGED_ATTACK_SET_ANGLE] = setAngle;
        if(WOW_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
      		WOW_BossAttackTarget(bossid, WOW_Bosses[bossid][TARGET]);
      	}
	    return 1;
	}
	return 0;
}
stock WOW_GetBossMeleeAttackInfo(bossid, &Float:distance, &delay, &bool:useFightStyle) {
	if(WOW_IsValidBoss(bossid)) {
	    distance = WOW_Bosses[bossid][MELEE_ATTACK_DISTANCE];
	    delay = WOW_Bosses[bossid][MELEE_ATTACK_DELAY];
	    useFightStyle = WOW_Bosses[bossid][MELEE_ATTACK_USE_FIGHT_STYLE];
	    return 1;
	}
	return 0;
}
stock WOW_SetBossMeleeAttackInfo(bossid, Float:distance = 1.0, delay = -1, bool:useFightStyle = true) {
	if(WOW_IsValidBoss(bossid)) {
	    WOW_Bosses[bossid][MELEE_ATTACK_DISTANCE] = distance;
	    WOW_Bosses[bossid][MELEE_ATTACK_DELAY] = delay;
	    WOW_Bosses[bossid][MELEE_ATTACK_USE_FIGHT_STYLE] = useFightStyle;
        if(WOW_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
      		WOW_BossAttackTarget(bossid, WOW_Bosses[bossid][TARGET]);
      	}
	    return 1;
	}
	return 0;
}
stock WOW_GetBossNPCId(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		return WOW_Bosses[bossid][NPCID];
	}
	return INVALID_PLAYER_ID;
}
stock Text:WOW_GetBossTextDraw(bossid, textdraw) {
	if(WOW_IsValidBoss(bossid) && textdraw >= 0 && textdraw < WOW_MAX_BOSS_TEXTDRAWS) {
		return WOW_Bosses[bossid][TEXTDRAW][textdraw];
	}
	return Text:INVALID_TEXT_DRAW;
}
stock WOW_GetBossCurrentHealthPercent(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		return floatround(WOW_Bosses[bossid][CUR_HEALTH] / WOW_Bosses[bossid][MAX_HEALTH] * 100, floatround_ceil);
	}
	return -1;
}
stock WOW_GetBossIdFromPlayerid(playerid) {
	for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
	    if(playerid == WOW_Bosses[bossid][NPCID]) {
	        return bossid;
		}
	}
	return WOW_INVALID_BOSS_ID;
}
forward bool:WOW_IsBossValidForPlayer(playerid, bossid); //Silence 'used before declaration' warning
stock bool:WOW_IsBossValidForPlayer(playerid, bossid) {
	if(IsPlayerConnected(playerid) && WOW_IsValidBoss(bossid)) {
	    new playerState = GetPlayerState(playerid);
	    new bossplayerid = WOW_GetBossNPCId(bossid);
		if(bossplayerid != playerid && (!FCNPC_IsDead(bossplayerid) || WOW_Bosses[bossid][DISPLAY_IF_DEAD])) {
		    new bossInterior = FCNPC_GetInterior(bossplayerid);
		    new bossWorld = FCNPC_GetVirtualWorld(bossplayerid);
		    if(!IsPlayerNPC(playerid)) {
				if(GetPlayerInterior(playerid) == bossInterior && GetPlayerVirtualWorld(playerid) == bossWorld && playerState != PLAYER_STATE_NONE && playerState != PLAYER_STATE_WASTED
				&& playerState != PLAYER_STATE_SPAWNED && playerState != PLAYER_STATE_SPECTATING && !WOW_PlayerPaused[playerid]) {
	    			return true;
				}
			} else {
			    //FCNPC_IsValid ==> only support FCNPC bots, no normal bots
			    if(FCNPC_IsValid(playerid) && FCNPC_GetInterior(playerid) == bossInterior && FCNPC_GetVirtualWorld(playerid) == bossWorld && FCNPC_IsSpawned(playerid) && !FCNPC_IsDead(playerid)) {
	    			return true;
			    }
			}
	    }
	}
	return false;
}
static WOW_GetClosestBossToDisplay(playerid) {
	new closestBoss = WOW_INVALID_BOSS_ID;
	new Float:closestBossRange = 0.0;
	if(IsPlayerConnected(playerid)) {
    	new Float:bossX, Float:bossY, Float:bossZ;
    	new Float:playerRange;
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		    if(WOW_IsBossValidForPlayer(playerid, bossid)) {
	        	FCNPC_GetPosition(WOW_Bosses[bossid][NPCID], bossX, bossY, bossZ);
	            playerRange = GetPlayerDistanceFromPoint(playerid, bossX, bossY, bossZ);
	            //Don't display if display range is <= 0
		  		if(WOW_IsPlayerInDisplayRange(playerid, bossid) && (!WOW_IsValidBoss(closestBoss) || playerRange < closestBossRange)) {
			        closestBossRange = playerRange;
			        closestBoss = bossid;
				}
			}
		}
	}
	return closestBoss;
}
static WOW_GetClosestPlayerToTakeAggro(bossid) {
	new closestPlayer = INVALID_PLAYER_ID;
	new Float:closestPlayerRange = 0.0;
	if(WOW_IsValidBoss(bossid)) {
    	new Float:playerX, Float:playerY, Float:playerZ;
    	new Float:bossRange;
		for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
		    if(WOW_IsBossValidForPlayer(playerid, bossid)) {
		        GetPlayerPos(playerid, playerX, playerY, playerZ);
	            bossRange = GetPlayerDistanceFromPoint(WOW_Bosses[bossid][NPCID], playerX, playerY, playerZ);
		  		if(WOW_IsPlayerInAggroRange(playerid, bossid) && (closestPlayer == INVALID_PLAYER_ID || bossRange < closestPlayerRange)) {
			        closestPlayerRange = bossRange;
			        closestPlayer = playerid;
				}
			}
		}
	}
	return closestPlayer;
}
forward bool:WOW_IsPlayerInDisplayRange(playerid, bossid); //Silence 'used before declaration' warning
stock bool:WOW_IsPlayerInDisplayRange(playerid, bossid) {
	if(IsPlayerConnected(playerid) && WOW_IsValidBoss(bossid)) {
		new Float:bossX, Float:bossY, Float:bossZ;
		FCNPC_GetPosition(WOW_Bosses[bossid][NPCID], bossX, bossY, bossZ);
	    new Float:playerRange = GetPlayerDistanceFromPoint(playerid, bossX, bossY, bossZ);
		//Don't display if display range is <= 0
		if(WOW_Bosses[bossid][RANGE_DISPLAY] > 0.0 && playerRange <= WOW_Bosses[bossid][RANGE_DISPLAY]) {
		    return true;
		}
	}
	return false;
}
forward bool:WOW_IsPlayerInAggroRange(playerid, bossid); //Silence 'used before declaration' warning
stock bool:WOW_IsPlayerInAggroRange(playerid, bossid) {
	if(IsPlayerConnected(playerid) && WOW_IsValidBoss(bossid)) {
		new Float:playerX, Float:playerY, Float:playerZ;
		GetPlayerPos(playerid, playerX, playerY, playerZ);
		new Float:bossRange = GetPlayerDistanceFromPoint(WOW_Bosses[bossid][NPCID], playerX, playerY, playerZ);
		//Don't aggro if aggro range is <= 0.0
		if(WOW_Bosses[bossid][RANGE_AGGRO] > 0.0 && bossRange <= WOW_Bosses[bossid][RANGE_AGGRO]) {
		    return true;
		}
	}
	return false;
}
static WOW_UpdateBossHealthDisplay(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		TextDrawTextSize(WOW_Bosses[bossid][TEXTDRAW][0], (470.0 - 167.3) * WOW_Bosses[bossid][CUR_HEALTH] / WOW_Bosses[bossid][MAX_HEALTH] + 167.3, 0.0);
		for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
			//Only update the textdraw for a player if he is seeing the textdraw of the boss
			//Last part of condition:  we don't need to display things to an npc
			if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid)) {
				new closestBoss = WOW_GetClosestBossToDisplay(playerid);
				if(WOW_IsValidBoss(closestBoss) && bossid == closestBoss) {
					TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][0]);
				}
			}
		}
		new string[14 + 1];
		format(string, sizeof(string), "%d%", WOW_GetBossCurrentHealthPercent(bossid));
		TextDrawSetString(WOW_Bosses[bossid][TEXTDRAW][1], string);
		new healthInteger = floatround(WOW_Bosses[bossid][CUR_HEALTH], floatround_ceil); //Ceil so 0.3 still displays as 1 instead of 0
		#if WOW_SHORTEN_HEALTH == false
			TextDrawSetString(WOW_Bosses[bossid][TEXTDRAW][2], WOW_DisplayReadableInteger(healthInteger));
		#else
		    if(float(healthInteger) / 1000 / 1000 >= 1) {
				format(string, sizeof(string), "%s M", WOW_DisplayReadableFloat(float(healthInteger) / 1000 / 1000, 2, 2));
			} else if(float(healthInteger) / 1000 >= 1) {
				format(string, sizeof(string), "%s K", WOW_DisplayReadableFloat(float(healthInteger) / 1000, 2, 2));
			} else {
				format(string, sizeof(string), "%s", WOW_DisplayReadableInteger(healthInteger));
			}
			TextDrawSetString(WOW_Bosses[bossid][TEXTDRAW][2], string);
		#endif
	}
}
static WOW_UpdateBossCastDisplay(bossid) {
	if(WOW_IsValidBoss(bossid) && (WOW_IsBossCasting(bossid) || WOW_IsBossCastBarExtra(bossid))) {
	    new spellid = WOW_Casting[bossid][SPELLID];
	    TextDrawBoxColor(WOW_Bosses[bossid][TEXTDRAW][4], WOW_Spells[spellid][CAST_BAR_COLOR_DARK]);
	    TextDrawBoxColor(WOW_Bosses[bossid][TEXTDRAW][5], WOW_Spells[spellid][CAST_BAR_COLOR_LIGHT]);
	    //Don't show the extraProgress on the bar and the number representation
		new showExtraProgress = WOW_Casting[bossid][CAST_PROGRESS] - WOW_Spells[spellid][CAST_TIME];
		if(showExtraProgress < 0) {
		    showExtraProgress = 0;
		}
		new progressWithoutShowExtra = WOW_Casting[bossid][CAST_PROGRESS] - showExtraProgress;
		//Show an inverted castbar if needed
	    if(!WOW_Spells[spellid][CAST_BAR_INVERTED]) {
			TextDrawTextSize(WOW_Bosses[bossid][TEXTDRAW][5], (470.0 - 167.3) * progressWithoutShowExtra / WOW_Spells[spellid][CAST_TIME] + 167.3, 0.0);
		} else {
			TextDrawTextSize(WOW_Bosses[bossid][TEXTDRAW][5], (470.0 - ((470.0 - 167.3) * progressWithoutShowExtra / WOW_Spells[spellid][CAST_TIME] + 167.3)) + 167.3, 0.0);
		}
		//Reshow the textdraw to make the changes (color + size) visible
		for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
			//Only update the textdraw for a player if he is seeing the textdraw of the boss
			//Last part of condition:  we don't need to display things to an npc
			if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid)) {
				new closestBoss = WOW_GetClosestBossToDisplay(playerid);
				if(WOW_IsValidBoss(closestBoss) && bossid == closestBoss) {
					TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][4]);
					TextDrawShowForPlayer(playerid, WOW_Bosses[bossid][TEXTDRAW][5]);
				}
			}
		}
		TextDrawSetString(WOW_Bosses[bossid][TEXTDRAW][6], WOW_Spells[spellid][NAME]);
		new string[21 + 1 + 21 + 2 + 1];
		new Float:castProgress = float(progressWithoutShowExtra);
		//Show an inverted number representation if needed
	    if(WOW_Spells[spellid][CAST_TIME_INVERTED]) {
	    	castProgress = float(WOW_Spells[spellid][CAST_TIME] - progressWithoutShowExtra);
	    }
		new Float:castTime = float(WOW_Spells[spellid][CAST_TIME]);
		if(castProgress / 1000 / 60 >= 1) {
			format(string, sizeof(string), "%sm", WOW_DisplayReadableFloat(castProgress / 1000 / 60, 2, 2));
		} else {
			format(string, sizeof(string), "%ss", WOW_DisplayReadableFloat(castProgress / 1000, 2, 2));
		}
		if(castTime / 1000 / 60 >= 1) {
			format(string, sizeof(string), "%s/%sm", string, WOW_DisplayReadableFloat(castTime / 1000 / 60, 2, 2));
		} else {
			format(string, sizeof(string), "%s/%ss", string, WOW_DisplayReadableFloat(castTime / 1000, 2, 2));
		}
		TextDrawSetString(WOW_Bosses[bossid][TEXTDRAW][7], string);
 	}
}
static WOW_IncreaseBossCastProgress(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		if(WOW_IsBossCasting(bossid)) {
		    new spellid = WOW_Casting[bossid][SPELLID];
			//Don't cast above castTime
			if(WOW_Spells[spellid][CAST_TIME] - WOW_Casting[bossid][CAST_PROGRESS] <= WOW_UPDATE_TIME) {
			    WOW_SetBossCastingProgress(bossid, WOW_Spells[spellid][CAST_TIME]); //We set the CAST_PROGRESS to CAST_TIME (say 500) instead of CAST_PROGRESS + WOW_UPDATE_TIME (say 490 + 49), because we want showextra to start exactly at 0 (say 500 - 500) and not something > 0 (say 490 - 500 + 49)
			} else {
			    WOW_SetBossCastingProgress(bossid, WOW_Casting[bossid][CAST_PROGRESS] + WOW_UPDATE_TIME);
			    //If the spell target becomes invalid, stop the cast
				//Otherwise: start cast, spell target dies before cast on him ends, spell target respawns, spell will still be executed on him
			    if(WOW_Casting[bossid][TARGETID] != INVALID_PLAYER_ID && !WOW_IsBossValidForPlayer(WOW_Casting[bossid][TARGETID], bossid)) {
					WOW_StopBossCasting(bossid);
			    }
			}
			WOW_UpdateBossCastDisplay(bossid);
		}
		//Keep showing the castbar for a small additional time after the cast is complete
		else if(WOW_IsBossCastBarExtra(bossid)) {
		    WOW_SetBossCastingExtraProgress(bossid, WOW_GetBossCastingExtraProgress(bossid) + WOW_UPDATE_TIME);
		}
	}
}
stock bool:WOW_BossHasMeleeWeapons(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		new weaponid = FCNPC_GetWeapon(WOW_GetBossNPCId(bossid));
		if(weaponid >= 0 && weaponid <= 15) {
	 		return true;
		}
	}
	return false;
}
//Is not casting & in attack range							==>	attack target
//Is not casting & not in attack range						==>	move to target
//Is casting & canmove & canattack & in attack range		==> attack target
//Is casting & canmove & canattack & not in attack range	==> move to target
//Is casting & !canmove & canattack & in attack range		==> attack target
//Is casting & !canmove & canattack & not in attack range	==> attack target even though out of range
//Is casting & canmove & !canattack & in attack range		==> move to target even though in range
//Is casting & canmove & !canattack & not in attack range	==> move to target
//Is casting & !canmove & !canattack & in attack range		==> nothing
//Is casting & !canmove & !canattack & not in attack range	==> nothing
static WOW_BossAttackTarget(bossid, targetid) {
	if(WOW_IsValidBoss(bossid) && WOW_IsBossValidForPlayer(targetid, bossid)) {
		new bossplayerid = WOW_GetBossNPCId(bossid);
		new Float:bossX, Float:bossY, Float:bossZ;
		FCNPC_GetPosition(bossplayerid, bossX, bossY, bossZ);
		new Float:distance = GetPlayerDistanceFromPoint(targetid, bossX, bossY, bossZ);
		new Float:attackDistance = WOW_Bosses[bossid][RANGED_ATTACK_DISTANCE];
		new bool:isMelee = WOW_BossHasMeleeWeapons(bossid);
		if(isMelee) {
		    attackDistance = WOW_Bosses[bossid][MELEE_ATTACK_DISTANCE];
		}
		new bool:canMove = true;
		new bool:canAttack = true;
		if(WOW_IsBossCasting(bossid)) {
		    new spellid = WOW_Casting[bossid][SPELLID];
		    canMove = WOW_Spells[spellid][CAN_MOVE];
		    canAttack = WOW_Spells[spellid][CAN_ATTACK];
		}
		//Target in attack range, attack if allowed
		if(distance <= attackDistance) {
		    if(canAttack) {
		        WOW_BossAttackAim(bossid, targetid);
		    } else {
		        if(canMove) {
		        	WOW_BossAttackMove(bossid, targetid);
		        } else {
		            WOW_BossStopAttack(bossid);
		        }
		    }
		}
		//Target not in attack range, move to target if allowed
		else {
		    if(canMove) {
		        WOW_BossAttackMove(bossid, targetid);
		    } else {
			    if(canAttack) {
		        	WOW_BossAttackAim(bossid, targetid);
			    } else {
		            WOW_BossStopAttack(bossid);
			    }
		    }
		}
	}
	return 1;
}
static WOW_BossAttackAim(bossid, targetid) {
	if(WOW_IsValidBoss(bossid) && WOW_IsBossValidForPlayer(targetid, bossid)) {
	    new bossplayerid = WOW_GetBossNPCId(bossid);
		new bool:isMelee = WOW_BossHasMeleeWeapons(bossid);
		if(FCNPC_IsMoving(bossplayerid)) {
 			FCNPC_Stop(bossplayerid);
	    }
	    if(!isMelee) {
	        if(FCNPC_IsAttacking(bossplayerid)) { //In case the npc switched weapons
	    		FCNPC_StopAttack(bossplayerid);
		    }
	        if(!FCNPC_IsAimingAtPlayer(bossplayerid, targetid)) { //So we don't aim again when we were already aiming at that same player. If aiming at another player, this will execute
				FCNPC_AimAtPlayer(bossplayerid, targetid, true, WOW_Bosses[bossid][RANGED_ATTACK_DELAY], WOW_Bosses[bossid][RANGED_ATTACK_SET_ANGLE]);
			}
		} else {
		    if(FCNPC_IsAiming(bossplayerid)) { //In case the npc switched weapons
			    FCNPC_StopAim(bossplayerid);
		    }
	        if(!FCNPC_IsAttacking(bossplayerid)) { //So we don't attack again when we were already attacking
		    	FCNPC_MeleeAttack(bossplayerid, WOW_Bosses[bossid][MELEE_ATTACK_DELAY], WOW_Bosses[bossid][MELEE_ATTACK_USE_FIGHT_STYLE]);
		    }
		}
	}
}
static WOW_BossAttackMove(bossid, targetid) {
	if(WOW_IsValidBoss(bossid) && WOW_IsBossValidForPlayer(targetid, bossid)) {
	    new bossplayerid = WOW_GetBossNPCId(bossid);
	    if(FCNPC_IsAiming(bossplayerid)) {
		    FCNPC_StopAim(bossplayerid);
	    }
        if(FCNPC_IsAttacking(bossplayerid)) {
    		FCNPC_StopAttack(bossplayerid);
    	}
    	if(!FCNPC_IsMovingAtPlayer(bossplayerid, targetid)) { //So we don't move again when we were already moving to that same player. If moving at another player, this will execute
			FCNPC_GoToPlayer(bossplayerid, targetid, WOW_Bosses[bossid][MOVE_TYPE], WOW_Bosses[bossid][MOVE_SPEED], WOW_USE_MAP_ANDREAS, WOW_Bosses[bossid][MOVE_RADIUS], WOW_Bosses[bossid][MOVE_SET_ANGLE]);
		}
	}
}
static WOW_BossStopAttack(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		new bossplayerid = WOW_GetBossNPCId(bossid);
	    if(FCNPC_IsMoving(bossplayerid)) {
			FCNPC_Stop(bossplayerid);
	    }
	    if(FCNPC_IsAiming(bossplayerid)) {
		    FCNPC_StopAim(bossplayerid);
	    }
        if(FCNPC_IsAttacking(bossplayerid)) {
    		FCNPC_StopAttack(bossplayerid);
    	}
    }
}

//Spell
static WOW_InitAllSpells() {
	for(new spellid = 0; spellid < WOW_MAX_SPELLS; spellid++) {
	    WOW_InitSpell(spellid);
	}
}
static WOW_InitSpell(spellid) {
	//Don't use WOW_IsValidSpell(spellid)
	if(spellid >= 0 && spellid < WOW_MAX_SPELLS) {
		format(WOW_Spells[spellid][NAME], WOW_MAX_SPELL_NAME + 1, "%s", WOW_INVALID_STRING);
		WOW_Spells[spellid][TYPE] = WOW_SPELL_TYPE_INVALID;
		WOW_Spells[spellid][CAST_TIME] = 0;
		WOW_Spells[spellid][AMOUNT] = 0.0;
		WOW_Spells[spellid][PERCENT_TYPE] = WOW_PERCENT_TYPE_INVALID;
		WOW_Spells[spellid][CAST_BAR_COLOR_DARK] = WOW_INVALID_COLOR;
		WOW_Spells[spellid][CAST_BAR_COLOR_LIGHT] = WOW_INVALID_COLOR;
		WOW_Spells[spellid][CAST_BAR_INVERTED] = false;
		WOW_Spells[spellid][CAST_TIME_INVERTED] = false;
		WOW_Spells[spellid][CAN_MOVE] = false;
		WOW_Spells[spellid][CAN_ATTACK] = false;
		format(WOW_Spells[spellid][INFO], WOW_MAX_SPELL_INFO + 1, "%s", WOW_INVALID_STRING);
	}
}
stock bool:WOW_IsValidSpell(spellid) {
	if(spellid >= 0 && spellid < WOW_MAX_SPELLS && WOW_Spells[spellid][TYPE] != WOW_SPELL_TYPE_INVALID) {
	    return true;
	}
	return false;
}
stock WOW_DestroyAllSpells() {
	for(new spellid = 0; spellid < WOW_MAX_SPELLS; spellid++) {
	    WOW_DestroySpell(spellid);
	}
	return 1;
}
stock WOW_DestroySpell(spellid) {
	if(WOW_IsValidSpell(spellid)) {
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
			WOW_StopAllBossesCastingSpell(spellid);
		}
		WOW_InitSpell(spellid);
		return 1;
	}
	return 0;
}
stock WOW_CreateSpellFull(name[], type = WOW_SPELL_TYPE_CUSTOM, castTime = 2000, Float:amount = 0.0, percentType = WOW_PERCENT_TYPE_CUSTOM, castBarColorDark = 0x645005ff, castBarColorLight = 0xb4820aff,
bool:castBarInverted = false, bool:castTimeInverted = false, bool:canMove = false, bool:canAttack = false, info[] = WOW_INVALID_STRING) {
	for(new spellid = 0; spellid < WOW_MAX_SPELLS; spellid++) {
	    if(WOW_Spells[spellid][TYPE] == WOW_SPELL_TYPE_INVALID) {
	    	WOW_Spells[spellid][TYPE] = type;
			WOW_SetSpellName(spellid, name);
			WOW_SetSpellType(spellid, type);
			WOW_SetSpellCastTime(spellid, castTime, false);
			WOW_SetSpellAmount(spellid, amount);
			WOW_SetSpellPercentType(spellid, percentType);
			WOW_SetSpellCastBarColorDark(spellid, castBarColorDark);
			WOW_SetSpellCastBarColorLight(spellid, castBarColorLight);
			WOW_SetSpellCastBarInverted(spellid, castBarInverted, false);
			WOW_SetSpellCastTimeInverted(spellid, castTimeInverted, false);
			WOW_SetSpellCanMove(spellid, canMove);
			WOW_SetSpellCanAttack(spellid, canAttack);
			WOW_SetSpellInfo(spellid, info);
	    	return spellid;
		}
	}
	//Max amount of spells reached
	return WOW_INVALID_SPELL_ID;
}
stock WOW_CreateSpell(name[]) {
	return WOW_CreateSpellFull(name);
}
stock WOW_GetSpellName(spellid, name[], len) {
	if(WOW_IsValidSpell(spellid)) {
	    format(name, len, "%s", WOW_Spells[spellid][NAME]);
		return strlen(name);
	}
	return -1;
}
stock WOW_SetSpellName(spellid, name[]) {
	if(WOW_IsValidSpell(spellid)) {
	    format(WOW_Spells[spellid][NAME], WOW_MAX_SPELL_NAME + 1, "%s", name);
	    for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
	        if(WOW_IsValidBoss(bossid) && (WOW_IsBossCastingSpell(bossid, spellid) || WOW_IsBossCastBarExtraForSpell(bossid, spellid))) {
				TextDrawSetString(WOW_Bosses[bossid][TEXTDRAW][6], WOW_Spells[spellid][NAME]);
				//Textdraw updates automatically
	        }
	    }
		return 1;
	}
	return 0;
}
stock WOW_GetSpellType(spellid) {
	if(WOW_IsValidSpell(spellid)) {
	    return WOW_Spells[spellid][TYPE];
	}
	return WOW_SPELL_TYPE_INVALID;
}
stock WOW_SetSpellType(spellid, type) {
	//Don't check for type <= CUSTOM, so the user can create additionale types
	if(WOW_IsValidSpell(spellid) && type != WOW_SPELL_TYPE_INVALID && type >= 0) {
		WOW_Spells[spellid][TYPE] = type;
	    return 1;
	}
	return 0;
}
stock WOW_GetSpellCastTime(spellid) {
	if(WOW_IsValidSpell(spellid)) {
	    return WOW_Spells[spellid][CAST_TIME];
	}
	return -1;
}
/*
Instant:
- casttime 500, progress 450, extraprogress 0 => casttime 0 (instant), progress becomes 0, execute complete stopcast and init cast immediately
- casttime 500, progress 850, extraprogress 350 => casttime 0 (instant), progress becomes 0, init cast immediately (not complete stopcast as well, because it has already been called, because there is extraprogress)
ShowExtra:
- casttime 500, progress 850, extraprogress 350 => casttime 400, progress becomes 750 which is casttime + extraprogress (keep showextra fixed, otherwise showextra will start again)
- casttime 500, progress 850, extraprogress 350 => casttime 900, progress becomes 1250 which is casttime + extraprogress (keep showextra fixed, otherwise WOW_OnBossStopCasting will be called again when progress reaches casttime again)
Keeppercent:
- casttime 500, progress 450, extraprogress 0 => casttime 400, progress becomes 360
- casttime 500, progress 450, extraprogress 0 => casttime 600, progress becomes 540
Dont keeppercent:
- casttime 500, progress 450, extraprogress 0 => casttime 400, progress becomes 400 which is casttime, execute complete stopcast immediately (not init cast as well to allow for showExtra, except if showExtra is invalid)
- casttime 500, progress 450, extraprogress 0 => casttime 600, progress stays 450
In other words: showextra does never scale it will always remain a fixed number. Instants don't have showextra time. Both are to prevent showextra from going over WOW_CAST_BAR_SHOW_EXTRA_TIME and to prevent WOW_OnBossStopCasting from being called twice.
*/
stock WOW_SetSpellCastTime(spellid, castTime, bool:keepCastPercent = false) {
	if(WOW_IsValidSpell(spellid)) {
	    if(castTime < 0) {
			castTime = 0;
		}
		new oldCastTime = WOW_Spells[spellid][CAST_TIME];
		WOW_Spells[spellid][CAST_TIME] = castTime;
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		    if(WOW_IsValidBoss(bossid) && (WOW_IsBossCastingSpell(bossid, spellid) || WOW_IsBossCastBarExtraForSpell(bossid, spellid))) {
			    new showExtraProgress = WOW_Casting[bossid][CAST_PROGRESS] - oldCastTime;
				if(showExtraProgress < 0) {
				    showExtraProgress = 0;
				}
		        if(castTime == 0) {
			    	WOW_Casting[bossid][CAST_PROGRESS] = 0; //Must be set before WOW_BossCastProgressComplete is called, because that function checks for CAST_PROGRESS == CAST_TIME
			    	if(showExtraProgress == 0) {
						WOW_BossCastProgressComplete(bossid, spellid);
					}
	    			WOW_InitBossCasting(bossid);
		        } else {
		            if(showExtraProgress != 0) {
		                WOW_Casting[bossid][CAST_PROGRESS] = castTime + showExtraProgress;
		            } else {
		                if(keepCastPercent) {
							WOW_Casting[bossid][CAST_PROGRESS] = floatround(float(WOW_Casting[bossid][CAST_PROGRESS]) / oldCastTime * castTime, floatround_floor); //floatround_floor, because (say 400.9) the next progress integer (401) wasn't reached yet
						} else {
							if(WOW_Casting[bossid][CAST_PROGRESS] >= castTime) {
								WOW_Casting[bossid][CAST_PROGRESS] = castTime; //Must be set before WOW_BossCastProgressComplete is called, because that function checks for CAST_PROGRESS == CAST_TIME
								WOW_BossCastProgressComplete(bossid, spellid);
								#if WOW_CAST_BAR_SHOW_EXTRA_TIME <= 0
									WOW_InitBossCasting(bossid);
								#endif
							}
		                }
		            }
		            //Don't update castbar with instants or if no show extra
		            #if WOW_CAST_BAR_SHOW_EXTRA_TIME > 0
						WOW_UpdateBossCastDisplay(bossid);
					#endif
				}
			}
		}
	    return 1;
	}
	return 0;
}
stock WOW_GetSpellAmount(spellid, &Float:amount) {
	if(WOW_IsValidSpell(spellid)) {
	    amount = WOW_Spells[spellid][AMOUNT];
	    return 1;
	}
	return 0;
}
stock WOW_SetSpellAmount(spellid, Float:amount) {
	if(WOW_IsValidSpell(spellid)) {
	    if(amount < 0.0) {
			amount = 0.0;
		}
	    WOW_Spells[spellid][AMOUNT] = amount;
	    return 1;
	}
	return 0;
}
stock WOW_GetSpellPercentType(spellid) {
	if(WOW_IsValidSpell(spellid)) {
	    return WOW_Spells[spellid][PERCENT_TYPE];
	}
	return WOW_PERCENT_TYPE_INVALID;
}
stock WOW_SetSpellPercentType(spellid, type) {
	//Don't check for type <= CUSTOM, so the user can create additionale types
	if(WOW_IsValidSpell(spellid) && type != WOW_PERCENT_TYPE_INVALID && type >= 0) {
		WOW_Spells[spellid][PERCENT_TYPE] = type;
	    return 1;
	}
	return 0;
}
stock WOW_GetSpellCastBarColorDark(spellid) {
	if(WOW_IsValidSpell(spellid)) {
		return WOW_Spells[spellid][CAST_BAR_COLOR_DARK];
	}
	return -1;
}
stock WOW_SetSpellCastBarColorDark(spellid, color) {
	if(WOW_IsValidSpell(spellid)) {
		WOW_Spells[spellid][CAST_BAR_COLOR_DARK] = color;
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		    if(WOW_IsValidBoss(bossid) && (WOW_IsBossCastingSpell(bossid, spellid) || WOW_IsBossCastBarExtraForSpell(bossid, spellid))) {
    			WOW_UpdateBossCastDisplay(bossid);
		    }
	    }
	    return 1;
	}
	return 0;
}
stock WOW_GetSpellCastBarColorLight(spellid) {
	if(WOW_IsValidSpell(spellid)) {
		return WOW_Spells[spellid][CAST_BAR_COLOR_LIGHT];
	}
	return -1;
}
stock WOW_SetSpellCastBarColorLight(spellid, color) {
	if(WOW_IsValidSpell(spellid)) {
		WOW_Spells[spellid][CAST_BAR_COLOR_LIGHT] = color;
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		    if(WOW_IsValidBoss(bossid) && (WOW_IsBossCastingSpell(bossid, spellid) || WOW_IsBossCastBarExtraForSpell(bossid, spellid))) {
    			WOW_UpdateBossCastDisplay(bossid);
		    }
	    }
	    return 1;
	}
	return 0;
}
stock bool:WOW_GetSpellCastBarInverted(spellid) {
	if(WOW_IsValidSpell(spellid)) {
		return WOW_Spells[spellid][CAST_BAR_INVERTED];
	}
	return false;
}
/*
Invertprogressmade:
- casttime 500, progress 450, extraprogress 0, is not inverted 	=> bar remains in position and will move to left, progress becomes 50, extraprogress stays 0, further increases
- casttime 500, progress 450, extraprogress 0, is inverted 		=> bar remains in position and will move to right, progress becomes 50, extraprogress stays 0, further increases
- showextra                                                     => bar remains in position, progress inverts, extraprogress doesn't change, further increases
Dont invertprogressmade:
- casttime 500, progress 450, extraprogress 0, is not inverted 	=> bar inverts from big to small and will move to left, progress stays 450, extraprogress stays 0, further increases
- casttime 500, progress 450, extraprogress 0, is inverted 		=> bar inverts from small to big and will move to right, progress stays 450, extraprogress stays 0, further increases
- showextra                                                     => bar inverts, progress doesn't change, extraprogress doesn't change, further increases
In other words: all values will always be positive, but the representation on the textdraw is adapted. When showextra is true, progress or extraprogress never changes, to keep showextra a consistent time.
*/
stock WOW_SetSpellCastBarInverted(spellid, bool:inverted, bool:invertProgressMade = false) {
	if(WOW_IsValidSpell(spellid)) {
	    //Don't inv if already inv and vice versa
	    new bool:oldInverted = WOW_Spells[spellid][CAST_BAR_INVERTED];
		WOW_Spells[spellid][CAST_BAR_INVERTED] = inverted;
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		    if(WOW_IsValidBoss(bossid) && (WOW_IsBossCastingSpell(bossid, spellid) || WOW_IsBossCastBarExtraForSpell(bossid, spellid))) {
    			WOW_UpdateBossCastDisplay(bossid);
		        if(invertProgressMade && WOW_IsBossCastingSpell(bossid, spellid) && oldInverted != inverted) { //Only invert when casting, not when showextra
		            WOW_Casting[bossid][CAST_PROGRESS] = WOW_Spells[spellid][CAST_TIME] - WOW_Casting[bossid][CAST_PROGRESS];
		        }
		    }
	    }
		return 1;
	}
	return 0;
}
stock bool:WOW_GetSpellCastTimeInverted(spellid) {
	if(WOW_IsValidSpell(spellid)) {
		return WOW_Spells[spellid][CAST_TIME_INVERTED];
	}
	return false;
}
/*
Invertprogressmade:
- casttime 500, progress 450, extraprogress 0, is not inverted 	=> time remains equal and will decrease, progress becomes 50, extraprogress stays 0, further increases
- casttime 500, progress 450, extraprogress 0, is inverted 		=> time remains equal and will increase, progress becomes 50, extraprogress stays 0, further increases
- showextra                                                     => time remains equal, progress inverts, extraprogress doesn't change, further increases
Dont invertprogressmade:
- casttime 500, progress 450, extraprogress 0, is not inverted 	=> time inverts from big to small and will decrease, progress stays 450, extraprogress stays 0, further increases
- casttime 500, progress 450, extraprogress 0, is inverted 		=> bar inverts from small to big and will increase, progress stays 450, extraprogress stays 0, further increases
- showextra                                                     => time inverts, progress doesn't change, extraprogress doesn't change, further increases
In other words: all values will always be positive, but the representation on the textdraw is adapted. When showextra is true, progress or extraprogress never changes, to keep showextra a consistent time.
*/
stock WOW_SetSpellCastTimeInverted(spellid, bool:inverted, bool:invertProgressMade = false) {
	if(WOW_IsValidSpell(spellid)) {
	    //Don't inv if already inv and vice versa
	    new bool:oldInverted = WOW_Spells[spellid][CAST_TIME_INVERTED];
		WOW_Spells[spellid][CAST_TIME_INVERTED] = inverted;
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		    if(WOW_IsValidBoss(bossid) && (WOW_IsBossCastingSpell(bossid, spellid) || WOW_IsBossCastBarExtraForSpell(bossid, spellid))) {
    			WOW_UpdateBossCastDisplay(bossid);
		        if(invertProgressMade && WOW_IsBossCastingSpell(bossid, spellid) && oldInverted != inverted) { //Only invert when casting, not when showextra
		            WOW_Casting[bossid][CAST_PROGRESS] = WOW_Spells[spellid][CAST_TIME] - WOW_Casting[bossid][CAST_PROGRESS];
		        }
		    }
	    }
		return 1;
	}
	return 0;
}
stock bool:WOW_GetSpellCanMove(spellid) {
	if(WOW_IsValidSpell(spellid)) {
		return WOW_Spells[spellid][CAN_MOVE];
	}
	return false;
}
stock WOW_SetSpellCanMove(spellid, bool:canMove) {
	if(WOW_IsValidSpell(spellid)) {
		WOW_Spells[spellid][CAN_MOVE] = canMove;
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		    if(WOW_IsValidBoss(bossid) && (WOW_IsBossCastingSpell(bossid, spellid) || WOW_IsBossCastBarExtraForSpell(bossid, spellid)) && WOW_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
		      	WOW_BossAttackTarget(bossid, WOW_Bosses[bossid][TARGET]);
		    }
	    }
		return 1;
	}
	return 0;
}
stock bool:WOW_GetSpellCanAttack(spellid) {
	if(WOW_IsValidSpell(spellid)) {
		return WOW_Spells[spellid][CAN_ATTACK];
	}
	return false;
}
stock WOW_SetSpellCanAttack(spellid, bool:canAttack) {
	if(WOW_IsValidSpell(spellid)) {
		WOW_Spells[spellid][CAN_ATTACK] = canAttack;
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		    if(WOW_IsValidBoss(bossid) && (WOW_IsBossCastingSpell(bossid, spellid) || WOW_IsBossCastBarExtraForSpell(bossid, spellid)) && WOW_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
		      	WOW_BossAttackTarget(bossid, WOW_Bosses[bossid][TARGET]);
		    }
	    }
		return 1;
	}
	return 0;
}
stock WOW_GetSpellInfo(spellid, info[], len) {
	if(WOW_IsValidSpell(spellid)) {
	    format(info, len, "%s", WOW_Spells[spellid][INFO]);
		return strlen(info);
	}
	return -1;
}
stock WOW_SetSpellInfo(spellid, info[]) {
	if(WOW_IsValidSpell(spellid)) {
		//If the user didn't provide info, construct info based on other settings
		if(!WOW_isnull(info) && !strcmp(info, WOW_INVALID_STRING, true)) {
			new string[WOW_MAX_SPELL_INFO + 1];
			new percentString[21 + 26 + 1];
			format(percentString, sizeof(percentString), "%s", WOW_DisplayReadableFloat(WOW_Spells[spellid][AMOUNT], 2, 0));
			switch(WOW_Spells[spellid][PERCENT_TYPE]) {
			    case WOW_PERCENT_TYPE_NOT: {format(percentString, sizeof(percentString), "%s", percentString);}
				case WOW_PERCENT_TYPE_TARG_MAX_HP_AP: {format(percentString, sizeof(percentString), "%s\% of target's max health + armour", percentString);}
				case WOW_PERCENT_TYPE_CAST_MAX_HP_AP: {format(percentString, sizeof(percentString), "%s\% of caster's max health + armour", percentString);}
				case WOW_PERCENT_TYPE_TARG_CUR_HP_AP: {format(percentString, sizeof(percentString), "%s\% of target's remaining health + armour", percentString);}
				case WOW_PERCENT_TYPE_CAST_CUR_HP_AP: {format(percentString, sizeof(percentString), "%s\% of caster's remaining health + armour", percentString);}
				case WOW_PERCENT_TYPE_TARG_LOS_HP_AP: {format(percentString, sizeof(percentString), "%s\% of target's lost health + armour", percentString);}
				case WOW_PERCENT_TYPE_CAST_LOS_HP_AP: {format(percentString, sizeof(percentString), "%s\% of caster's lost health + armour", percentString);}
				case WOW_PERCENT_TYPE_TARG_MAX_HP: {format(percentString, sizeof(percentString), "%s\% of target's max health", percentString);}
				case WOW_PERCENT_TYPE_CAST_MAX_HP: {format(percentString, sizeof(percentString), "%s\% of caster's max health", percentString);}
				case WOW_PERCENT_TYPE_TARG_CUR_HP: {format(percentString, sizeof(percentString), "%s\% of target's remaining health", percentString);}
				case WOW_PERCENT_TYPE_CAST_CUR_HP: {format(percentString, sizeof(percentString), "%s\% of caster's remaining health", percentString);}
				case WOW_PERCENT_TYPE_TARG_LOS_HP: {format(percentString, sizeof(percentString), "%s\% of target's lost health", percentString);}
				case WOW_PERCENT_TYPE_CAST_LOS_HP: {format(percentString, sizeof(percentString), "%s\% of caster's lost health", percentString);}
				case WOW_PERCENT_TYPE_TARG_MAX_AP: {format(percentString, sizeof(percentString), "%s\% of target's max armour", percentString);}
				case WOW_PERCENT_TYPE_CAST_MAX_AP: {format(percentString, sizeof(percentString), "%s\% of caster's max armour", percentString);}
				case WOW_PERCENT_TYPE_TARG_CUR_AP: {format(percentString, sizeof(percentString), "%s\% of target's remaining armour", percentString);}
				case WOW_PERCENT_TYPE_CAST_CUR_AP: {format(percentString, sizeof(percentString), "%s\% of caster's remaining armour", percentString);}
				case WOW_PERCENT_TYPE_TARG_LOS_AP: {format(percentString, sizeof(percentString), "%s\% of target's lost armour", percentString);}
				case WOW_PERCENT_TYPE_CAST_LOS_AP: {format(percentString, sizeof(percentString), "%s\% of caster's lost armour", percentString);}
			}
			new castTimeString[21 + 7 + 1];
			if(WOW_Spells[spellid][CAST_TIME] != 0) {
				if(float(WOW_Spells[spellid][CAST_TIME]) / 1000 / 60 >= 1) {
					format(castTimeString, sizeof(castTimeString), "%s minute", WOW_DisplayReadableFloat(float(WOW_Spells[spellid][CAST_TIME]) / 1000 / 60, 2, 0));
				} else {
					format(castTimeString, sizeof(castTimeString), "%s second", WOW_DisplayReadableFloat(float(WOW_Spells[spellid][CAST_TIME]) / 1000, 2, 0));
				}
			} else {
				format(castTimeString, sizeof(castTimeString), "%s", "Instant");
			}
		    switch(WOW_Spells[spellid][TYPE]) {
				case WOW_SPELL_TYPE_CUSTOM: {format(string, sizeof(string), "Has a custom effect. %s cast.", castTimeString);}
				case WOW_SPELL_TYPE_DAM: {format(string, sizeof(string), "Damages %s. %s cast.", percentString, castTimeString);}
				case WOW_SPELL_TYPE_HEAL: {format(string, sizeof(string), "Heals %s. %s cast.", percentString, castTimeString);}
				case WOW_SPELL_TYPE_CROWD_CONTROL: {format(string, sizeof(string), "Applies a crowd control effect. %s cast.", percentString, castTimeString);}
			}
		    format(WOW_Spells[spellid][INFO], WOW_MAX_SPELL_INFO + 1, "%s", string);
		}
		//If the user did provide info, use that one
		else {
		    format(WOW_Spells[spellid][INFO], WOW_MAX_SPELL_INFO + 1, "%s", info);
		}
		return 1;
	}
	return 0;
}
stock WOW_SpellToString(spellid, string[], len, bool:allowDefaultColors = true) {
	if(WOW_IsValidSpell(spellid)) {
	    if(allowDefaultColors) {
	    	format(string, len, "{%06x}%s: {%06x}%s", 0xffffffff >>> 8, WOW_Spells[spellid][NAME], 0xffd517ff >>> 8, WOW_Spells[spellid][INFO]);
	    } else {
	    	format(string, len, "%s: %s", WOW_Spells[spellid][NAME], WOW_Spells[spellid][INFO]);
	    }
		return strlen(string);
	}
	return -1;
}

//Casting
stock WOW_StopAllBossesCasting() {
	for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		WOW_StopBossCasting(bossid);
	}
	return 1;
}
stock WOW_StopBossCasting(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		return WOW_StopBossCastingSpell(bossid, WOW_Casting[bossid][SPELLID]);
    }
    return 0;
}
stock WOW_StopAllBossesCastingSpell(spellid) {
	if(WOW_IsValidSpell(spellid)) {
		for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
			WOW_StopBossCastingSpell(bossid, spellid);
		}
		return 1;
	}
	return 0;
}
static WOW_InitAllBossesCasting() {
	for(new bossid = 0; bossid < WOW_MAX_BOSSES; bossid++) {
		WOW_InitBossCasting(bossid);
	}
}
static WOW_InitBossCasting(bossid) {
	//Don't use WOW_IsValidBoss(bossid)
	if(bossid >= 0 && bossid < WOW_MAX_BOSSES) {
	    WOW_Casting[bossid][SPELLID] = WOW_INVALID_SPELL_ID;
	    WOW_Casting[bossid][CAST_PROGRESS] = WOW_INVALID_CAST_PROGRESS;
		WOW_Casting[bossid][TARGETID] = INVALID_PLAYER_ID;
	}
}
forward bool:WOW_IsBossCasting(bossid); //Silence 'used before declaration' warning
stock bool:WOW_IsBossCasting(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		new spellid = WOW_Casting[bossid][SPELLID];
		if(WOW_IsValidSpell(spellid) && WOW_Spells[spellid][CAST_TIME] > WOW_Casting[bossid][CAST_PROGRESS]) {
	    	return true;
	    }
	}
	return false;
}
forward bool:WOW_IsBossCastingSpell(bossid, spellid); //Silence used before definition warning
stock bool:WOW_IsBossCastingSpell(bossid, spellid) {
	//WOW_IsValidBoss & WOW_IsValidSpell in WOW_IsBossCasting
	return WOW_IsBossCasting(bossid) && spellid == WOW_Casting[bossid][SPELLID];
}
forward bool:WOW_IsBossCastBarExtra(bossid); //Silence used before definition warning
stock bool:WOW_IsBossCastBarExtra(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		new spellid = WOW_Casting[bossid][SPELLID];
		if(WOW_IsValidSpell(spellid) && WOW_Casting[bossid][CAST_PROGRESS] >= WOW_Spells[spellid][CAST_TIME]) {
			return true;
		}
	}
	return false;
}
forward bool:WOW_IsBossCastBarExtraForSpell(bossid, spellid); //Silence used before definition warning
stock bool:WOW_IsBossCastBarExtraForSpell(bossid, spellid) {
	//WOW_IsValidBoss & WOW_IsValidSpell in WOW_IsBossCastBarExtra
	return WOW_IsBossCastBarExtra(bossid) && spellid == WOW_Casting[bossid][SPELLID];
}
stock WOW_StopBossCastingSpell(bossid, spellid) {
	if(WOW_IsValidBoss(bossid) && WOW_IsValidSpell(spellid) && WOW_IsBossCastingSpell(bossid, spellid)) {
	    WOW_BossCastProgressInComplete(bossid, spellid);
	    WOW_InitBossCasting(bossid);
	    return 1;
	}
	return 0;
}
static WOW_BossCastProgressInComplete(bossid, spellid) {
	if(WOW_IsValidBoss(bossid) && WOW_IsValidSpell(spellid)) {
        if(WOW_IsBossCastingSpell(bossid, spellid)) { //Only call the end of the incomplete cast if CastProgress has actually not reached CastTime
			CallRemoteFunction("WOW_OnBossStopCasting", "ddd", bossid, spellid, WOW_Casting[bossid][TARGETID], false);
		}
	}
}
static WOW_BossCastProgressComplete(bossid, spellid) {
	if(WOW_IsValidBoss(bossid) && WOW_IsValidSpell(spellid)) {
        if(WOW_Casting[bossid][CAST_PROGRESS] == WOW_Spells[spellid][CAST_TIME]) { //Only call the end of the complete cast if CastProgress has actually reached CastTime
			CallRemoteFunction("WOW_OnBossStopCasting", "ddd", bossid, spellid, WOW_Casting[bossid][TARGETID], true);
		}
	}
}
stock WOW_StartBossCastingSpell(bossid, spellid, targetid = INVALID_PLAYER_ID) {
	//Don't replace if casting already, do replace if showExtra
	if(WOW_IsValidBoss(bossid) && WOW_IsValidSpell(spellid) && !FCNPC_IsDead(WOW_Bosses[bossid][NPCID]) && (IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID) && !WOW_IsBossCasting(bossid)) {
        if(WOW_IsBossCastBarExtra(bossid)) {
    		WOW_InitBossCasting(bossid);
        }
		WOW_Casting[bossid][SPELLID] = spellid;
		WOW_Casting[bossid][CAST_PROGRESS] = 0;
		WOW_Casting[bossid][TARGETID] = targetid;
		CallRemoteFunction("WOW_OnBossStartCasting", "ddd", bossid, spellid, targetid);
		 //Immediately end cast if instant
		if(WOW_Spells[spellid][CAST_TIME] == 0) {
		    WOW_BossCastProgressComplete(bossid, spellid);
    		WOW_InitBossCasting(bossid);
		}
    	return 1;
	}
	return 0;
}
stock WOW_GetBossCastingSpell(bossid) {
	//Don't return anything if showExtra is true, because the boss isn't casting anymore even though the variable is still set to allow for the showExtra functionality
	if(WOW_IsValidBoss(bossid) && WOW_IsBossCasting(bossid)) {
	    return WOW_Casting[bossid][SPELLID];
	}
	return -1;
}
/*
Instant:
- Will never happen because, onstopcast gets called immediately after onstartcast
ShowExtra:
- Will never happen, because WOW_IsBossCasting is not true with showExtra. Use WOW_StartBossCastingSpell instead.
Keeppercent:
- casttime 500, progress 250 => casttime 200, progress becomes 100
- casttime 500, progress 250 => casttime 600, progress becomes 300
Dont keeppercent:
- casttime 500, progress 250 => casttime 200, progress becomes 200 which is casttime, execute complete stopcast immediately (not init cast as well to allow for showExtra, except if showExtra is invalid)
- casttime 500, progress 250 => casttime 600, progress stays 250
*/
stock WOW_SetBossCastingSpell(bossid, spellid, bool:keepCastPercent = false) {
	if(WOW_IsValidBoss(bossid) && WOW_IsValidSpell(spellid) && WOW_IsBossCasting(bossid) && !FCNPC_IsDead(WOW_Bosses[bossid][NPCID])) {
		new oldCastTime = WOW_Spells[WOW_Casting[bossid][SPELLID]][CAST_TIME];
		new newCastTime = WOW_Spells[spellid][CAST_TIME];
		WOW_Casting[bossid][SPELLID] = spellid; //Must be called before
		if(keepCastPercent) {
			WOW_Casting[bossid][CAST_PROGRESS] = floatround(float(WOW_Casting[bossid][CAST_PROGRESS]) / oldCastTime * newCastTime, floatround_floor); //floatround_floor, because (say 400.9) the next progress integer (401) wasn't reached yet
	    } else {
			if(WOW_Casting[bossid][CAST_PROGRESS] > newCastTime) {
				WOW_Casting[bossid][CAST_PROGRESS] = newCastTime; //Must be set before WOW_BossCastProgressComplete is called, because that function checks for CAST_PROGRESS == CAST_TIME
				WOW_BossCastProgressComplete(bossid, spellid);
				#if WOW_CAST_BAR_SHOW_EXTRA_TIME <= 0
					WOW_InitBossCasting(bossid);
				#endif
			}
	    }
		//Don't update castbar with instants or if no show extra
		if(newCastTime > 0) {
			#if WOW_CAST_BAR_SHOW_EXTRA_TIME > 0
				WOW_UpdateBossCastDisplay(bossid);
			#endif
		}
	    return 1;
	}
	return 0;
}
stock WOW_GetBossCastingProgress(bossid) {
	//Don't return anything if showExtra is true, because the boss isn't casting anymore even though the variable is still set to allow for the showExtra functionality
	//If the showextra progress is needed, use WOW_GetBossCastingExtraProgress
	if(WOW_IsValidBoss(bossid) && WOW_IsBossCasting(bossid)) {
	    return WOW_Casting[bossid][CAST_PROGRESS];
	}
	return -1;
}
/*
Instant:
- Will never happen because, onstopcast gets called immediately after onstartcast
ShowExtra:
- Will never happen, because WOW_IsBossCasting is not true with showExtra. Use WOW_SetBossCastingExtraProgress instead.
(Don't) KeepCastPercent:
- Not possible, because a spell can be used by multiple bosses. Therefore we can not set the CAST_TIME of a spell according to the CAST_PROGRESS of a particular boss.
  Say we change the cast progress of a boss and thus the cast time of the spell he is currently casting, why should another boss who is also casting the same spell be affected by this?
Other conditions:
- casttime 500, progress 450, showextramax 50 => progress 0, progress becomes 0, do nothing special
- casttime 500, progress 450, showextramax 50 => progress 475, progress becomes 475, do nothing special
- casttime 500, progress 450, showextramax 50 => progress 500, progress becomes 500, execute complete stopcast immediately (not init cast as well to allow for showExtra, except if showExtra is invalid)
- casttime 500, progress 450, showextramax 50 => progress 550, progress becomes 500, execute complete stopcast immediately (not init cast as well to allow for showExtra, except if showExtra is invalid)
- casttime 500, progress 450, showextramax 50 => progress 560, progress becomes 500, execute complete stopcast immediately (not init cast as well to allow for showExtra, except if showExtra is invalid)
In other words: if the new progress is >= the casttime, make it equal to the casttime, to allow for a consistent showextra time.
*/
stock WOW_SetBossCastingProgress(bossid, progress) {
	if(WOW_IsValidBoss(bossid) && WOW_IsBossCasting(bossid) && !FCNPC_IsDead(WOW_Bosses[bossid][NPCID])) {
	    if(progress < 0) {
	        progress = 0;
	    }
		new spellid = WOW_Casting[bossid][SPELLID];
		if(progress >= WOW_Spells[spellid][CAST_TIME]) {
			WOW_Casting[bossid][CAST_PROGRESS] = WOW_Spells[spellid][CAST_TIME]; //Must be set before WOW_BossCastProgressComplete is called, because that function checks for CAST_PROGRESS == CAST_TIME
			WOW_BossCastProgressComplete(bossid, spellid); //Finish casting, but don't hide the castbar, to allow for showExtra
			#if WOW_CAST_BAR_SHOW_EXTRA_TIME <= 0 //Do hide castbar if showExtra is invalid
				WOW_InitBossCasting(bossid);
			#endif
		} else {
			WOW_Casting[bossid][CAST_PROGRESS] = progress;
		}
		//Don't update castbar with instants or if no show extra
		if(WOW_Spells[spellid][CAST_TIME] > 0) {
			#if WOW_CAST_BAR_SHOW_EXTRA_TIME > 0
				WOW_UpdateBossCastDisplay(bossid);
			#endif
		}
	    return 1;
	}
	return 0;
}
stock WOW_GetBossCastingTarget(bossid) {
	//Don't return anything if showExtra is true, because the boss isn't casting anymore even though the variable is still set to allow for the showExtra functionality
	if(WOW_IsValidBoss(bossid) && WOW_IsBossCasting(bossid)) {
	    return WOW_Casting[bossid][TARGETID];
	}
	return -1;
}
//The casting target doesn't have to be valid
//The casting target doesn't have to be streamed in
//The casting target doesn't have to be in aggro range
stock WOW_SetBossCastingTarget(bossid, targetid) {
	if(WOW_IsValidBoss(bossid) && WOW_IsBossCasting(bossid) && !FCNPC_IsDead(WOW_Bosses[bossid][NPCID]) && (IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)) {
		WOW_Casting[bossid][TARGETID] = targetid;
		return 1;
	}
	return 0;
}
stock WOW_GetBossCastingExtraProgress(bossid) {
	//Don't return anything if casting is true, because the spell isn't yet in showextra
	if(WOW_IsValidBoss(bossid) && WOW_IsBossCastBarExtra(bossid)) {
	    return WOW_Casting[bossid][CAST_PROGRESS] - WOW_Spells[WOW_Casting[bossid][SPELLID]][CAST_TIME];
	}
	return -1;
}
/*
Instant:
- Will never happen because, onstopcast gets called immediately after onstartcast
-Casting:
- Will never happen, because WOW_IsBossCastBarExtra is not true when the boss is casting. Use WOW_SetBossCastingProgress instead.
(Don't) KeepCastPercent:
- Not possible, because a spell can be used by multiple bosses. Therefore we can not set the CAST_TIME of a spell according to the showextraprogress of a particular boss.
  Say we change the showextraprogress of a boss and thus the cast time of the spell he is currently casting, why should another boss who is also casting the same spell be affected by this?
Other conditions:
- casttime 500, progress 525, showextra 25, showextramax 50 => showextra 0, showextra becomes 0 (progress 500), do nothing special
- casttime 500, progress 525, showextra 25, showextramax 50 => showextra 35, showextra becomes 35 (progress 535), do nothing special
- casttime 500, progress 525, showextra 25, showextramax 50 => showextra 50, showextra becomes 50 (progress 550), init cast immediately (not complete stopcast as well, because it has already been called, because there is extraprogress)
- casttime 500, progress 525, showextra 25, showextramax 50 => showextra 55, progress becomes 50 (progress 550), init cast immediately (not complete stopcast as well, because it has already been called, because there is extraprogress)
In other words: if the new showextra is >= the casttime + showextramax, init cast immediately, to allow for a consistent showextra time.
*/
stock WOW_SetBossCastingExtraProgress(bossid, progress) {
	if(WOW_IsValidBoss(bossid) && WOW_IsBossCastBarExtra(bossid) && !FCNPC_IsDead(WOW_Bosses[bossid][NPCID]) ) {
		if(progress < 0) {
	        progress = 0;
	    }
		//We don't need to update the castbar display, because showextra is not shown on the castbar
	    new spellid = WOW_Casting[bossid][SPELLID];
		if(progress + WOW_Spells[spellid][CAST_TIME] >= WOW_Spells[spellid][CAST_TIME] + WOW_CAST_BAR_SHOW_EXTRA_TIME) {
			WOW_Casting[bossid][CAST_PROGRESS] = WOW_Spells[spellid][CAST_TIME] + WOW_CAST_BAR_SHOW_EXTRA_TIME;
			WOW_InitBossCasting(bossid);
		} else {
			WOW_Casting[bossid][CAST_PROGRESS] = progress + WOW_Spells[spellid][CAST_TIME];
		}
	    return 1;
	}
	return 0;
}
