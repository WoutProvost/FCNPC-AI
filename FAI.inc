/*
 * License:
 * See LICENSE.md included in the release download, or at https://github.com/WoutProvost/FCNPC-A.I./blob/master/LICENSE.md if not included.

 * Credits:
 * See CREDITS.md included in the release download, or at https://github.com/WoutProvost/FCNPC-A.I./blob/master/CREDITS.md if not included.
*/

//FAKE NATIVES
/*
//Boss
native FAI_CreateBoss(name[]);
native FAI_GetBossFullName(bossid, name[], len);
native FAI_SetBossFullName(bossid, name[]);
native FAI_GetBossMapiconInfo(bossid, &iconid, &iconMarker, &iconColor, &iconStyle);
native FAI_SetBossMapiconInfo(bossid, iconid = FAI_INVALID_ICON_ID, iconMarker = 23, iconColor = 0xff0000ff, iconStyle = MAPICON_LOCAL);
native FAI_GetBossMaxHealth(bossid, &Float:health);
native FAI_SetBossMaxHealth(bossid, Float:health, bool:keepHealthPercent = false);
native FAI_GetBossDisplayRange(bossid, &Float:range);
native FAI_SetBossDisplayRange(bossid, Float:range);
native FAI_GetBossAggroRange(bossid, &Float:range);
native FAI_SetBossAggroRange(bossid, Float:range, bool:checkForTarget = false);
native FAI_GetBossDisplayIfDead(bossid);
native FAI_SetBossDisplayIfDead(bossid, bool:displayIfDead);
native FAI_GetBossCurrentHealth(bossid, &Float:health);
native FAI_SetBossCurrentHealth(bossid, Float:health, bool:keepHealthPercent = false);
native FAI_GetBossTarget(bossid);
native FAI_SetBossTarget(bossid, playerid, bool:checkForAggroRange = false);
native FAI_GetBossMoveInfo(bossid, &type, &Float:speed, &bool:useMapAndreas, &Float:radius, &bool:setAngle);
native FAI_SetBossMoveInfo(bossid, type = MOVE_TYPE_AUTO, Float:speed = MOVE_SPEED_AUTO, bool:useMapAndreas = false, Float:radius = 0.0, bool:setAngle = true);
native FAI_GetBossRangedAttackInfo(bossid, &Float:range, &delay, &bool:setAngle);
native FAI_SetBossRangedAttackInfo(bossid, Float:range = 20.0, delay = -1, bool:setAngle = true);
native FAI_GetBossMeleeAttackInfo(bossid, &Float:range, &delay, &bool:useFightStyle);
native FAI_SetBossMeleeAttackInfo(bossid, Float:range = 1.0, delay = -1, bool:useFightStyle = false);
native FAI_GetBossAllowNPCTargets(bossid);
native FAI_SetBossAllowNPCTargets(bossid, bool:allowNPCTargets, bool:checkForTarget = false);
native FAI_GetBossBehaviour(bossid);
native FAI_SetBossBehaviour(bossid, behaviour, bool:checkForTarget = false);
native FAI_DestroyBoss(bossid);
native FAI_DestroyAllBosses();
native bool:FAI_IsValidBoss(bossid);
native bool:FAI_IsBossValidForPlayer(playerid, bossid);
native bool:FAI_IsPlayerInDisplayRange(playerid, bossid);
native bool:FAI_IsPlayerInAggroRange(playerid, bossid);
native bool:FAI_BossHasMeleeWeapons(bossid);
native FAI_GetBossNPCID(bossid);
native FAI_GetBossPlayerID(bossid);
native Text:FAI_GetBossTextDraw(bossid, textdraw);
native FAI_GetBossCurrentHealthPercent(bossid);
native FAI_GetBossIDFromNPCID(npcid);
native FAI_GetBossIDFromPlayerID(playerid);
native FAI_DamageBoss(bossid, damagerid, Float:amount);
native FAI_HealBoss(bossid, healerid, Float:amount);
native bool:FAI_IsEncounterStarted(bossid);
native FAI_StopEncounter(bossid);

//Spell
native FAI_CreateSpell(name[]);
native FAI_GetSpellName(spellid, name[], len);
native FAI_SetSpellName(spellid, name[]);
native FAI_GetSpellCastTime(spellid);
native FAI_SetSpellCastTime(spellid, castTime, bool:keepCastPercent = false);
native FAI_GetSpellAmount(spellid, &Float:amount);
native FAI_SetSpellAmount(spellid, Float:amount);
native FAI_GetSpellCastBarColorDark(spellid);
native FAI_SetSpellCastBarColorDark(spellid, color);
native FAI_GetSpellCastBarColorLight(spellid);
native FAI_SetSpellCastBarColorLight(spellid, color);
native bool:FAI_GetSpellCastBarInverted(spellid);
native FAI_SetSpellCastBarInverted(spellid, bool:inverted, bool:invertProgressMade = false);
native bool:FAI_GetSpellCastTimeInverted(spellid);
native FAI_SetSpellCastTimeInverted(spellid, bool:inverted, bool:invertProgressMade = false);
native bool:FAI_GetSpellCanMove(spellid);
native FAI_SetSpellCanMove(spellid, bool:canMove);
native bool:FAI_GetSpellCanAttack(spellid);
native FAI_SetSpellCanAttack(spellid, bool:canAttack);
native FAI_GetSpellInfo(spellid, info[], len);
native FAI_SetSpellInfo(spellid, info[]);
native FAI_DestroySpell(spellid);
native FAI_DestroyAllSpells();
native bool:FAI_IsValidSpell(spellid);
native FAI_SpellToString(spellid, string[], len, bool:allowDefaultColors = true);

//Casting
native FAI_StartBossCastingSpell(bossid, spellid, targetid = INVALID_PLAYER_ID);
native FAI_GetBossCastingSpell(bossid);
native FAI_SetBossCastingSpell(bossid, spellid, bool:keepCastPercent = false);
native FAI_GetBossCastingProgress(bossid);
native FAI_SetBossCastingProgress(bossid, progress);
native FAI_GetBossCastingTarget(bossid);
native FAI_SetBossCastingTarget(bossid, targetid);
native FAI_GetBossCastingExtraProgress(bossid);
native FAI_SetBossCastingExtraProgress(bossid, progress);
native FAI_StopBossCasting(bossid);
native FAI_StopBossCastingSpell(bossid, spellid);
native FAI_StopAllBossesCasting();
native FAI_StopAllBossesCastingSpell(spellid);
native bool:FAI_IsBossCasting(bossid);
native bool:FAI_IsBossCastingSpell(bossid, spellid);
native bool:FAI_IsBossCastBarExtra(bossid);
native bool:FAI_IsBossCastBarExtraForSpell(bossid, spellid);
*/

//CALLBACKS
//Boss
forward FAI_OnBossEncounterStart(bossid, bool:reasonShot, firstTarget);
forward FAI_OnBossEncounterStop(bossid, bool:reasonDeath, lastTarget);
forward FAI_OnPlayerGetAggro(playerid, bossid);
forward FAI_OnPlayerLoseAggro(playerid, bossid);

//Casting
forward FAI_OnBossStartCasting(bossid, spellid, targetid);
forward FAI_OnBossStopCasting(bossid, spellid, targetid, bool:castComplete);

//General
//Include guards are already built into pawn, so no need to check
#include <a_samp>
#define FAI_VERSION                       	"1.1.1"
#if !defined FAI_USE_MAP_ANDREAS
	#define FAI_USE_MAP_ANDREAS           	false
#endif
#if FAI_USE_MAP_ANDREAS == true
	#include <MapAndreas>
#endif
#if !defined FAI_MAP_ANDREAS_MODE
	#define FAI_MAP_ANDREAS_MODE          	MAP_ANDREAS_MODE_FULL
#endif
#include <FCNPC>
#define FAI_INVALID_STRING              	" "
#define FAI_INVALID_COLOR	              	-1
#define FAI_INVALID_TIMER_ID            	-1
#if !defined FAI_UPDATE_TIME
	#define FAI_UPDATE_TIME    				50
#endif
#if !defined FAI_CAST_BAR_SHOW_EXTRA_TIME
	#define FAI_CAST_BAR_SHOW_EXTRA_TIME    1000
#endif
#if !defined FAI_DECIMAL_MARK
	#define FAI_DECIMAL_MARK    			'.'
#endif
#if !defined FAI_SHORTEN_NUMBERS
	#define FAI_SHORTEN_NUMBERS            	false
#endif
#define FAI_isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
static FAI_UpdateTimer = FAI_INVALID_TIMER_ID;
static FAI_PauseTickCount[MAX_PLAYERS] = {0,...};
static bool:FAI_PlayerPaused[MAX_PLAYERS] = {false,...};
static FAI_PauseTimer = FAI_INVALID_TIMER_ID;

//Boss
#if !defined FAI_MAX_BOSSES
	#define FAI_MAX_BOSSES					20
#endif
#if !defined FAI_MAX_BOSS_FULL_NAME
	#define FAI_MAX_BOSS_FULL_NAME      	50
#endif
#define FAI_INVALID_BOSS_ID					-1
#define FAI_INVALID_ICON_ID					-1
#define FAI_MAX_BOSS_TEXTDRAWS              8
enum {
	FAI_BOSS_BEHAVIOUR_FRIENDLY,
	FAI_BOSS_BEHAVIOUR_NEUTRAL,
	FAI_BOSS_BEHAVIOUR_UNFRIENDLY
}
enum FAI_ENUM_BOSS {
	//Can be set by the user
	FULL_NAME[FAI_MAX_BOSS_FULL_NAME + 1],
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
	bool:MOVE_USE_MAP_ANDREAS,
	Float:MOVE_RADIUS,
	bool:MOVE_SET_ANGLE,
	Float:RANGED_ATTACK_RANGE,
	RANGED_ATTACK_DELAY,
	bool:RANGED_ATTACK_SET_ANGLE,
	Float:MELEE_ATTACK_RANGE,
	MELEE_ATTACK_DELAY,
	bool:MELEE_ATTACK_USE_FIGHT_STYLE,
	bool:ALLOW_NPC_TARGETS,
	BEHAVIOUR,
	THREAT[MAX_PLAYERS],
	//Cannot be set by the user
	NPCID,
	Text:TEXTDRAW[FAI_MAX_BOSS_TEXTDRAWS]
}
static FAI_Bosses[FAI_MAX_BOSSES][FAI_ENUM_BOSS];
static Text:FAI_BossBlackHealth = Text:INVALID_TEXT_DRAW;
static Text:FAI_BossDarkRed = Text:INVALID_TEXT_DRAW;
static Text:FAI_BossBlackCast = Text:INVALID_TEXT_DRAW;

//Spell
#if !defined FAI_MAX_SPELLS
	#define FAI_MAX_SPELLS					20
#endif
#if !defined FAI_MAX_SPELL_NAME
	#define FAI_MAX_SPELL_NAME				30
#endif
#if !defined FAI_MAX_SPELL_INFO
	#define FAI_MAX_SPELL_INFO				144
#endif
#define FAI_INVALID_SPELL_ID				-1
enum FAI_ENUM_SPELL {
	//Can be set by the user
	NAME[FAI_MAX_SPELL_NAME + 1],
	CAST_TIME,
	Float:AMOUNT,
	CAST_BAR_COLOR_DARK,
	CAST_BAR_COLOR_LIGHT,
	bool:CAST_BAR_INVERTED,
	bool:CAST_TIME_INVERTED,
	bool:CAN_MOVE,
	bool:CAN_ATTACK,
	INFO[FAI_MAX_SPELL_INFO + 1]
}
static FAI_Spells[FAI_MAX_SPELLS][FAI_ENUM_SPELL];

//Casting
#define FAI_INVALID_CAST_PROGRESS       	-1
enum FAI_ENUM_CASTING {
	//Can be set by the user
	SPELLID,
	CAST_PROGRESS,
	TARGETID
}
static FAI_Casting[FAI_MAX_BOSSES][FAI_ENUM_CASTING];

//General
static FAI_strcpy(dest[], const source[], maxlength = sizeof dest) {
	dest[0] = '\0';
	return strcat(dest, source, maxlength);
}
static FAI_strtokdelim(const string[], delimiter, &index) {
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
static FAI_DisplayReadableInteger(amount) {
	//Integer min: -2.147.483.648
	//Integer max: 2.147.483.647
	new amountAsString[14 + 1]; //10(2147483647) + 3(.) + 1(-)
	format(amountAsString, sizeof(amountAsString), "%d", amount < 0 ? amount*-1 : amount);
	new length = strlen(amountAsString);
	new modulo = length%3;
	for(new pos = modulo; pos < length; pos+= 3) {
	    if(pos != 0) { //Door modulo = 0
	        #if FAI_DECIMAL_MARK == '.'
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
static FAI_DisplayReadableFloat(Float:amount, maxDecimals = 6, minDecimals = 0) {
    new amountAsString[21 + 1], front[21 + 1], end[21 + 1], idx, frontval;
    FAI_strcpy(amountAsString, FAI_RemoveUnnecessaryDecimals(amount, maxDecimals, minDecimals));
	front = FAI_strtokdelim(amountAsString, '.', idx); //Bij een negatief getal wordt de - eraf gedaan? Oplossing zie hieronder.
	end = FAI_strtokdelim(amountAsString, '.', idx);
	frontval = strval(front);
	if(strlen(end) > 0) {
	    format(end, sizeof(end), "%c%s", FAI_DECIMAL_MARK, end);
	}
	format(amountAsString, sizeof(amountAsString), "%s%s", FAI_DisplayReadableInteger(amount < 0 ? frontval*-1 : frontval), end);
	return amountAsString;
}
static FAI_RemoveUnnecessaryDecimals(Float:amount, maxDecimals = 6, minDecimals = 0) {
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
	    FAI_InitScript();
	    #if defined FAI_OnFilterScriptInit
	        FAI_OnFilterScriptInit();
	    #endif
	    return 1;
	}
	#if defined _ALS_OnFilterScriptInit
	    #undef OnFilterScriptInit
	#else
	    #define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit FAI_OnFilterScriptInit
	#if defined FAI_OnFilterScriptInit
	    forward FAI_OnFilterScriptInit();
	#endif

    public OnFilterScriptExit()
	{
	    #if defined FAI_OnFilterScriptExit
	        FAI_OnFilterScriptExit();
	    #endif
	    FAI_ExitScript(); //Call after
	    return 1;
	}
	#if defined _ALS_OnFilterScriptExit
	    #undef OnFilterScriptExit
	#else
	    #define _ALS_OnFilterScriptExit
	#endif
	#define OnFilterScriptExit FAI_OnFilterScriptExit
	#if defined FAI_OnFilterScriptExit
	    forward FAI_OnFilterScriptExit();
	#endif
#else
    public OnGameModeInit()
	{
	    FAI_InitScript();
	    #if defined FAI_OnGameModeInit
	        FAI_OnGameModeInit();
	    #endif
	    return 1;
	}
	#if defined _ALS_OnGameModeInit
	    #undef OnGameModeInit
	#else
	    #define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit FAI_OnGameModeInit
	#if defined FAI_OnGameModeInit
	    forward FAI_OnGameModeInit();
	#endif

    public OnGameModeExit()
	{
	    #if defined FAI_OnGameModeExit
	        FAI_OnGameModeExit();
	    #endif
	    FAI_ExitScript(); //Call after
	    return 1;
	}
	#if defined _ALS_OnGameModeExit
	    #undef OnGameModeExit
	#else
	    #define _ALS_OnGameModeExit
	#endif
	#define OnGameModeExit FAI_OnGameModeExit
	#if defined FAI_OnGameModeExit
	    forward FAI_OnGameModeExit();
	#endif
#endif
static FAI_InitScript() {
	//General
	#if FAI_USE_MAP_ANDREAS == true
		new MapAndreasAddress = MapAndreas_GetAddress(); //Don't init MapAndreas when it was already initialized
		if(MapAndreasAddress == 0) {
	    	MapAndreas_Init(FAI_MAP_ANDREAS_MODE); //MapAndreas
	    }
		FCNPC_InitMapAndreas(MapAndreas_GetAddress()); //MapAndreas
	#endif
	FCNPC_SetUpdateRate(50);
 	FAI_UpdateTimer = SetTimer("FAI_Update", FAI_UPDATE_TIME, true);
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
		FAI_PauseTickCount[playerid] = GetTickCount();
		FAI_PlayerPaused[playerid] = false;
	}
	FAI_PauseTimer = SetTimer("FAI_CheckPausedPlayers", 1000, 1);

	//Boss
 	FAI_InitAllBosses();

	//Spell
 	FAI_InitAllSpells();
 	
 	//Casting
	FAI_InitAllBossesCasting();
	
	printf("---------------------");
	printf("  FCNPC A.I. loaded  ");
	printf("- Version: %s     ", FAI_VERSION);
	printf("- Author: Freaksken  ");
	printf("---------------------");
}
static FAI_ExitScript() {
	//General
	KillTimer(FAI_UpdateTimer);
 	FAI_UpdateTimer = FAI_INVALID_TIMER_ID;
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
		FAI_PauseTickCount[playerid] = GetTickCount();
		FAI_PlayerPaused[playerid] = false;
	}
	KillTimer(FAI_PauseTimer);
	FAI_PauseTimer = FAI_INVALID_TIMER_ID;

 	//Boss
    FAI_DestroyAllBosses();

    //Spell
 	FAI_DestroyAllSpells();
 	
 	//Casting
 	FAI_InitAllBossesCasting();
}

public OnPlayerDisconnect(playerid, reason) {
    #if defined FAI_OnPlayerDisconnect
        FAI_OnPlayerDisconnect(playerid, reason);
    #endif
    new bossid = FAI_GetBossIDFromNPCID(playerid);
    if(FAI_IsValidBoss(bossid)) {
		FAI_DestroyBossNoFCNPC_Destroy(bossid); //Call after
    }
	return 1;
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect FAI_OnPlayerDisconnect
#if defined FAI_OnPlayerDisconnect
    forward FAI_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerConnect(playerid) {
	FAI_PauseTickCount[playerid] = GetTickCount();
	FAI_PlayerPaused[playerid] = false;
    #if defined FAI_OnPlayerConnect
        FAI_OnPlayerConnect(playerid);
    #endif
	return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect FAI_OnPlayerConnect
#if defined FAI_OnPlayerConnect
    forward FAI_OnPlayerConnect(playerid);
#endif

public OnPlayerRequestClass(playerid, classid)
{
	//ForceClassSelection doesn't call a state change and thus PLAYER_STATE_WASTED isn't set
	for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][0]);
		TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][1]);
		TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][2]);
		TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][3]);
		TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][4]);
		TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][5]);
		TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][6]);
		TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][7]);
	}
    #if defined FAI_OnPlayerRequestClass
        FAI_OnPlayerRequestClass(playerid, classid);
    #endif
	return 1;
}
#if defined _ALS_OnPlayerRequestClass
    #undef OnPlayerRequestClass
#else
    #define _ALS_OnPlayerRequestClass
#endif
#define OnPlayerRequestClass FAI_OnPlayerRequestClass
#if defined FAI_OnPlayerRequestClass
    forward FAI_OnPlayerRequestClass(playerid, classid);
#endif

public OnPlayerUpdate(playerid)
{
	FAI_PauseTickCount[playerid] = GetTickCount();
    #if defined FAI_OnPlayerUpdate
        FAI_OnPlayerUpdate(playerid);
    #endif
	return 1;
}

#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate FAI_OnPlayerUpdate
#if defined FAI_OnPlayerUpdate
    forward FAI_OnPlayerUpdate(playerid);
#endif

/*
* FCNPC:
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
	new bossid = FAI_GetBossIDFromNPCID(npcid);
	if(FAI_IsValidBoss(bossid)) {
	    if(FAI_Bosses[bossid][CUR_HEALTH] != 0) {
			//In case the boss is casting when the encounter hasn't started yet (can happen by using startbosscastingspell). FAI_SetBossTargetWithReason doesn't take care of this for various reasons.
			if(FAI_Bosses[bossid][TARGET] == INVALID_PLAYER_ID && FAI_IsBossCasting(bossid)) {
		      	FAI_StopBossCasting(bossid);
			}
			//Reset target & threat for all players
			FAI_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0);
	    } else {
			FAI_SetBossCurrentHealth(bossid, FAI_Bosses[bossid][MAX_HEALTH]);
	    }
	}
    #if defined FAI_FCNPC_OnRespawn
        FAI_FCNPC_OnRespawn(npcid);
    #endif
    return 1;
}
#if defined _ALS_FCNPC_OnRespawn
    #undef FCNPC_OnRespawn
#else
    #define _ALS_FCNPC_OnRespawn
#endif
#define FCNPC_OnRespawn FAI_FCNPC_OnRespawn
#if defined FAI_FCNPC_OnRespawn
    forward FAI_FCNPC_OnRespawn(npcid);
#endif
public FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss)
{
	new ret = 1;
	new bossid = FAI_GetBossIDFromNPCID(npcid);
	if(FAI_IsValidBoss(bossid)) {
		ret = FAI_DamageBoss(bossid, damagerid, health_loss);
	}
    #if defined FAI_FCNPC_OnTakeDamage
        FAI_FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss);
    #endif
    return ret;
}
#if defined _ALS_FCNPC_OnTakeDamage
    #undef FCNPC_OnTakeDamage
#else
    #define _ALS_FCNPC_OnTakeDamage
#endif
#define FCNPC_OnTakeDamage FAI_FCNPC_OnTakeDamage
#if defined FAI_FCNPC_OnTakeDamage
    forward FAI_FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss);
#endif
stock FAI_DamageBoss(bossid, damagerid, Float:amount) {
	if(FAI_IsValidBoss(bossid) && (IsPlayerConnected(damagerid) || damagerid == INVALID_PLAYER_ID)) {
	    new bossplayerid = FAI_GetBossNPCID(bossid);
		//2nd part of condition: if the npc is dead, this function can still be called before the OnDeath callback gets called (mainly when shot with fast guns: minigun, ...)
		//3rd part of condition: damage not inflicted by players (falling, ...)
		//4th part of condition: neccesary to reject invalid damage done: the NPC is visible and thus damagable in other interiors
	 	if(FCNPC_IsSpawned(bossplayerid) && !FCNPC_IsDead(bossplayerid) && (damagerid == INVALID_PLAYER_ID || FAI_IsBossValidForPlayer(damagerid, bossid))) {
			//Only set target if the encounter has not yet started AND the behaviour is neutral or unfriendly
			if(FAI_Bosses[bossid][TARGET] == INVALID_PLAYER_ID && FAI_Bosses[bossid][BEHAVIOUR] != FAI_BOSS_BEHAVIOUR_FRIENDLY) {
				//Set target to damagerid if no target yet (valid damagerid + no target yet check in setter)
				FAI_SetBossTargetWithReason(bossid, damagerid, 1);
			}
			//Dont damage below 0
			if(FAI_Bosses[bossid][CUR_HEALTH] > amount) {
				FAI_SetBossCurrentHealth(bossid, FAI_Bosses[bossid][CUR_HEALTH] - amount);
			} else {
				//Make the damager that makes the last shot, kill the boss
				FCNPC_SetHealth(bossplayerid, FAI_Bosses[bossid][CUR_HEALTH]);
				//FAI_SetBossCurrentHealth(bossid, 0); //Happens in FCNPC_OnDeath
				//Return 1 to allow the dammage to be afflicted to npc, which will kill him in this case
				return 1;
			}
	 	}
	}
	//Return 0 to prevent damage to be afflicted to npc, update CUR_HEALTH instead
	return 0;
}
stock FAI_HealBoss(bossid, healerid, Float:amount) {
	if(FAI_IsValidBoss(bossid) && (IsPlayerConnected(healerid) || healerid == INVALID_PLAYER_ID)) {
		new bossplayerid = FAI_GetBossNPCID(bossid);
		if(FCNPC_IsSpawned(bossplayerid) && !FCNPC_IsDead(bossplayerid)) {
			//Don't heal above MAX_HEALTH
			if(FAI_Bosses[bossid][MAX_HEALTH] - FAI_Bosses[bossid][CUR_HEALTH] <= amount) {
				FAI_SetBossCurrentHealth(bossid, FAI_Bosses[bossid][MAX_HEALTH]);
				return 1;
			} else {
				FAI_SetBossCurrentHealth(bossid, FAI_Bosses[bossid][CUR_HEALTH] + amount);
			}
		}
	}
	return 0;
}
public FCNPC_OnDeath(npcid, killerid, weaponid)
{
	new bossid = FAI_GetBossIDFromNPCID(npcid);
	if(FAI_IsValidBoss(bossid)) {
		//In case the boss is casting when the encounter hasn't started yet (can happen by using startbosscastingspell). FAI_SetBossTargetWithReason doesn't take care of this for various reasons.
		if(FAI_Bosses[bossid][TARGET] == INVALID_PLAYER_ID && FAI_IsBossCasting(bossid)) {
	      	FAI_StopBossCasting(bossid);
		}
	    //Reset target & threat for all players
		FAI_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 2);
		//If the boss was killed with FCNPC_Kill or FCNPC_SetHealth with value <= 0.0, not by taking damage
		FAI_SetBossCurrentHealth(bossid, 0);
	}
	#if defined FAI_FCNPC_OnDeath
        FAI_FCNPC_OnDeath(npcid, killerid, weaponid);
    #endif
	return 1;
}
#if defined _ALS_FCNPC_OnDeath
    #undef FCNPC_OnDeath
#else
    #define _ALS_FCNPC_OnDeath
#endif
#define FCNPC_OnDeath FAI_FCNPC_OnDeath
#if defined FAI_FCNPC_OnDeath
    forward FAI_FCNPC_OnDeath(npcid, killerid, weaponid);
#endif

forward FAI_Update();
public FAI_Update() {
	//Boss
	//Show/hide boss textdraws & mapicon to player
	for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
		//Last part of condition:  we don't need to display things to an npc
	   if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid)) {
			new closestBoss = FAI_GetClosestBossToDisplay(playerid);
			//Hide the textdraws all bosses share if no boss is in range for a player
			if(!FAI_IsValidBoss(closestBoss)) {
				TextDrawHideForPlayer(playerid, FAI_BossBlackHealth);
				TextDrawHideForPlayer(playerid, FAI_BossDarkRed);
				TextDrawHideForPlayer(playerid, FAI_BossBlackCast);
			}
			//Show the textdraws all bosses share if a boss is in range for a player
			else {
				TextDrawShowForPlayer(playerid, FAI_BossBlackHealth);
				TextDrawShowForPlayer(playerid, FAI_BossDarkRed);
				if(FAI_IsBossCasting(closestBoss) || FAI_IsBossCastBarExtra(closestBoss)) {
					TextDrawShowForPlayer(playerid, FAI_BossBlackCast);
				} else {
					TextDrawHideForPlayer(playerid, FAI_BossBlackCast);
				}
			}
			for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
			    //Show the mapicon if the boss is valid for a player
			    if(FAI_IsBossValidForPlayer(playerid, bossid) && FAI_Bosses[bossid][ICONID] != FAI_INVALID_ICON_ID) {
    				new Float:bossX, Float:bossY, Float:bossZ;
	        		FCNPC_GetPosition(FAI_Bosses[bossid][NPCID], bossX, bossY, bossZ);
					SetPlayerMapIcon(playerid, FAI_Bosses[bossid][ICONID], bossX, bossY, bossZ, FAI_Bosses[bossid][ICON_MARKER], FAI_Bosses[bossid][ICON_COLOR], FAI_Bosses[bossid][ICON_STYLE]);
			    }
			    //Hide the mapicon if the boss is invalid for a player
				else {
					RemovePlayerMapIcon(playerid, FAI_Bosses[bossid][ICONID]);
			    }
				//Show the textdraws specific to a boss if he is the closest boss for a player
			    if(bossid == closestBoss) {
					TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][0]);
					TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][1]);
					TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][2]);
					TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][3]);
					if(FAI_IsBossCasting(bossid) || FAI_IsBossCastBarExtra(bossid)) {
						TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][4]);
						TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][5]);
						TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][6]);
						TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][7]);
					} else {
						TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][4]);
						TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][5]);
						TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][6]);
						TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][7]);
					}
			    }
				//Hide the textdraws specific to a boss if he is not the closest boss for a player
				//Otherwise if multiple bosses are in range, their textdraws will be put on top of eachother, which is ugly and we don't want of course
				else {
					TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][0]);
					TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][1]);
					TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][2]);
					TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][3]);
					TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][4]);
					TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][5]);
					TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][6]);
					TextDrawHideForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][7]);
			    }
			}
		}
	}
	
	//Update boss
	for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
	    if(FAI_IsValidBoss(bossid) && FCNPC_IsSpawned(FAI_Bosses[bossid][NPCID]) && !FCNPC_IsDead(FAI_Bosses[bossid][NPCID])) {
	        //Update casting bar
			FAI_IncreaseBossCastProgress(bossid);
			//Get new target if no target, or if old target invalid, or if the boss is not streamed in anymore for his old target
			if(!FAI_IsBossValidForPlayer(FAI_Bosses[bossid][TARGET], bossid) || !IsPlayerStreamedIn(FAI_Bosses[bossid][NPCID], FAI_Bosses[bossid][TARGET])) {
				//Only set target if the encounter has already started OR if the behaviour is unfriendly
				if(FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID || FAI_Bosses[bossid][BEHAVIOUR] == FAI_BOSS_BEHAVIOUR_UNFRIENDLY)  {
					//Set target to closestPlayerid (valid closestPlayerid check in setter)
					FAI_SetBossTargetWithReason(bossid, FAI_GetClosestPlayerToTakeAggro(bossid), 3);
				}
			}
	        //Attack target (which can be set above) if target known
	        if(FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
          		FAI_BossAttackTarget(bossid, FAI_Bosses[bossid][TARGET]);
          	}
	    }
	}
}

forward FAI_CheckPausedPlayers();
public FAI_CheckPausedPlayers() {
	for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
	    new PlayerState = GetPlayerState(playerid);
	    //On initialization and when the player is dead or when the player is in class selection, OnPlayerUpdate will not be called
	    if(IsPlayerConnected(playerid) && PlayerState != PLAYER_STATE_WASTED && PlayerState != PLAYER_STATE_NONE) {
	        new bool:PlayerInGame = true;
	        if(FAI_GetTickCountDiff(FAI_PauseTickCount[playerid], GetTickCount()) > 2000) {
				PlayerInGame = false;
			}
	        if(!PlayerInGame && !FAI_PlayerPaused[playerid]) {
				FAI_PlayerPaused[playerid] = true;
	        } else if(PlayerInGame && FAI_PlayerPaused[playerid]){
				FAI_PlayerPaused[playerid] = false;
	        }
		}
	}
	return 1;
}
//This fixes the problem with GetTickCount integer overflow when the server is run for 24+ days
static FAI_GetTickCountDiff(oldInteger, newInteger) {
	//Integer max: 2147483647
	if(oldInteger < 0 && newInteger >= 0) {
		return newInteger - oldInteger;
	} else if(oldInteger >= 0 && newInteger < 0 || oldInteger > newInteger) {
		return (cellmax - oldInteger + 1) - (cellmin - newInteger);
	}
	return newInteger - oldInteger;
}

//Boss
static FAI_InitAllBosses() {
	FAI_BossBlackHealth = TextDrawCreate(169.0, 429, "_");
	TextDrawUseBox(FAI_BossBlackHealth, 1);
	TextDrawBoxColor(FAI_BossBlackHealth, 0x000000ff);
	TextDrawLetterSize(FAI_BossBlackHealth, 0.0, 0.7);
	TextDrawTextSize(FAI_BossBlackHealth, 471.0, 0.0);
	FAI_BossDarkRed = TextDrawCreate(170.0, 430.0, "_");
	TextDrawUseBox(FAI_BossDarkRed, 1);
	TextDrawBoxColor(FAI_BossDarkRed, 0x5A0C0EFF);
	TextDrawLetterSize(FAI_BossDarkRed, 0.0, 0.5);
	TextDrawTextSize(FAI_BossDarkRed, 470.0, 0.0);
	FAI_BossBlackCast = TextDrawCreate(169.0, 439, "_");
	TextDrawUseBox(FAI_BossBlackCast, 1);
	TextDrawBoxColor(FAI_BossBlackCast, 0x000000ff);
	TextDrawLetterSize(FAI_BossBlackCast, 0.0, 0.7);
	TextDrawTextSize(FAI_BossBlackCast, 471.0, 0.0);
	for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
	    FAI_InitBoss(bossid);
	}
}
static FAI_InitBoss(bossid) {
	//Don't use FAI_IsValidBoss(bossid)
	if(bossid >= 0 && bossid < FAI_MAX_BOSSES) {
		FAI_Bosses[bossid][TEXTDRAW][0] = TextDrawCreate(170.0, 430.0, "_");
		TextDrawUseBox(FAI_Bosses[bossid][TEXTDRAW][0], 1);
		TextDrawBoxColor(FAI_Bosses[bossid][TEXTDRAW][0], 0xB4191DFF);
		TextDrawTextSize(FAI_Bosses[bossid][TEXTDRAW][0], 470.0, 0.0);
		TextDrawLetterSize(FAI_Bosses[bossid][TEXTDRAW][0], 0.0, 0.5);
		FAI_Bosses[bossid][TEXTDRAW][1] = TextDrawCreate(170.0, 429.0, "_");
		TextDrawFont(FAI_Bosses[bossid][TEXTDRAW][1], 1);
		TextDrawAlignment(FAI_Bosses[bossid][TEXTDRAW][1], 1);
		TextDrawSetProportional(FAI_Bosses[bossid][TEXTDRAW][1], 1);
		TextDrawColor(FAI_Bosses[bossid][TEXTDRAW][1], 0xffffffff);
		TextDrawSetShadow(FAI_Bosses[bossid][TEXTDRAW][1], 0);
		TextDrawSetOutline(FAI_Bosses[bossid][TEXTDRAW][1], 1);
		TextDrawLetterSize(FAI_Bosses[bossid][TEXTDRAW][1], 0.2, 0.7);
		FAI_Bosses[bossid][TEXTDRAW][2] = TextDrawCreate(470.0, 429.0, "_");
		TextDrawFont(FAI_Bosses[bossid][TEXTDRAW][2], 1);
		TextDrawAlignment(FAI_Bosses[bossid][TEXTDRAW][2], 3);
		TextDrawSetProportional(FAI_Bosses[bossid][TEXTDRAW][2], 1);
		TextDrawColor(FAI_Bosses[bossid][TEXTDRAW][2], 0xffffffff);
		TextDrawSetShadow(FAI_Bosses[bossid][TEXTDRAW][2], 0);
		TextDrawSetOutline(FAI_Bosses[bossid][TEXTDRAW][2], 1);
		TextDrawLetterSize(FAI_Bosses[bossid][TEXTDRAW][2], 0.2, 0.7);
		FAI_Bosses[bossid][TEXTDRAW][3] = TextDrawCreate(169.0, 415, "_");
		TextDrawFont(FAI_Bosses[bossid][TEXTDRAW][3], 0);
		TextDrawAlignment(FAI_Bosses[bossid][TEXTDRAW][3], 1);
		TextDrawSetProportional(FAI_Bosses[bossid][TEXTDRAW][3], 1);
		TextDrawColor(FAI_Bosses[bossid][TEXTDRAW][3], 0xffffffff);
		TextDrawSetShadow(FAI_Bosses[bossid][TEXTDRAW][3], 0);
		TextDrawSetOutline(FAI_Bosses[bossid][TEXTDRAW][3], 1);
		TextDrawLetterSize(FAI_Bosses[bossid][TEXTDRAW][3], 0.3, 1.0);
		FAI_Bosses[bossid][TEXTDRAW][4] = TextDrawCreate(170.0, 440.0, "_");
		TextDrawUseBox(FAI_Bosses[bossid][TEXTDRAW][4], 1);
		TextDrawBoxColor(FAI_Bosses[bossid][TEXTDRAW][4], 0x645005ff);
		TextDrawTextSize(FAI_Bosses[bossid][TEXTDRAW][4], 470.0, 0.0);
		TextDrawLetterSize(FAI_Bosses[bossid][TEXTDRAW][4], 0.0, 0.5);
		FAI_Bosses[bossid][TEXTDRAW][5] = TextDrawCreate(170.0, 440.0, "_");
		TextDrawUseBox(FAI_Bosses[bossid][TEXTDRAW][5], 1);
		TextDrawBoxColor(FAI_Bosses[bossid][TEXTDRAW][5], 0xB4820AFF);
		TextDrawTextSize(FAI_Bosses[bossid][TEXTDRAW][5], 470.0, 0.0);
		TextDrawLetterSize(FAI_Bosses[bossid][TEXTDRAW][5], 0.0, 0.5);
		FAI_Bosses[bossid][TEXTDRAW][6] = TextDrawCreate(170.0, 439.0, "_");
		TextDrawFont(FAI_Bosses[bossid][TEXTDRAW][6], 1);
		TextDrawAlignment(FAI_Bosses[bossid][TEXTDRAW][6], 1);
		TextDrawSetProportional(FAI_Bosses[bossid][TEXTDRAW][6], 1);
		TextDrawColor(FAI_Bosses[bossid][TEXTDRAW][6], 0xffffffff);
		TextDrawSetShadow(FAI_Bosses[bossid][TEXTDRAW][6], 0);
		TextDrawSetOutline(FAI_Bosses[bossid][TEXTDRAW][6], 1);
		TextDrawLetterSize(FAI_Bosses[bossid][TEXTDRAW][6], 0.2, 0.7);
		FAI_Bosses[bossid][TEXTDRAW][7] = TextDrawCreate(470.0, 439.0, "_");
		TextDrawFont(FAI_Bosses[bossid][TEXTDRAW][7], 1);
		TextDrawAlignment(FAI_Bosses[bossid][TEXTDRAW][7], 3);
		TextDrawSetProportional(FAI_Bosses[bossid][TEXTDRAW][7], 1);
		TextDrawColor(FAI_Bosses[bossid][TEXTDRAW][7], 0xffffffff);
		TextDrawSetShadow(FAI_Bosses[bossid][TEXTDRAW][7], 0);
		TextDrawSetOutline(FAI_Bosses[bossid][TEXTDRAW][7], 1);
		TextDrawLetterSize(FAI_Bosses[bossid][TEXTDRAW][7], 0.2, 0.7);
		FAI_ResetBossStats(bossid);
	}
}
static FAI_ResetBossStats(bossid) {
	//Don't use FAI_IsValidBoss(bossid)
	if(bossid >= 0 && bossid < FAI_MAX_BOSSES) {
		FAI_strcpy(FAI_Bosses[bossid][FULL_NAME], FAI_INVALID_STRING, FAI_MAX_BOSS_FULL_NAME + 1);
		FAI_Bosses[bossid][ICONID] = FAI_INVALID_ICON_ID;
		FAI_Bosses[bossid][ICON_MARKER] = 0;
		FAI_Bosses[bossid][ICON_COLOR] = FAI_INVALID_COLOR;
		FAI_Bosses[bossid][ICON_STYLE] = MAPICON_LOCAL;
		FAI_Bosses[bossid][MAX_HEALTH] = 0.0;
		FAI_Bosses[bossid][RANGE_DISPLAY] = 0.0;
		FAI_Bosses[bossid][RANGE_AGGRO] = 0.0;
		FAI_Bosses[bossid][DISPLAY_IF_DEAD] = false;
		FAI_Bosses[bossid][CUR_HEALTH] = 0.0;
		FAI_Bosses[bossid][TARGET] = INVALID_PLAYER_ID;
		FAI_Bosses[bossid][MOVE_TYPE] = MOVE_TYPE_AUTO;
		FAI_Bosses[bossid][MOVE_SPEED] = 0.0;
		FAI_Bosses[bossid][MOVE_USE_MAP_ANDREAS] = false;
		FAI_Bosses[bossid][MOVE_RADIUS] = 0.0;
		FAI_Bosses[bossid][MOVE_SET_ANGLE] = false;
		FAI_Bosses[bossid][RANGED_ATTACK_RANGE] = 0.0;
		FAI_Bosses[bossid][RANGED_ATTACK_DELAY] = 0;
		FAI_Bosses[bossid][RANGED_ATTACK_SET_ANGLE] = false;
		FAI_Bosses[bossid][MELEE_ATTACK_RANGE] = 0.0;
		FAI_Bosses[bossid][MELEE_ATTACK_DELAY] = 0;
		FAI_Bosses[bossid][MELEE_ATTACK_USE_FIGHT_STYLE] = false;
		FAI_Bosses[bossid][ALLOW_NPC_TARGETS] = false;
		FAI_Bosses[bossid][BEHAVIOUR] = FAI_BOSS_BEHAVIOUR_NEUTRAL;
		for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
			FAI_Bosses[bossid][THREAT][playerid] = 0;
		}
		FAI_Bosses[bossid][NPCID] = INVALID_PLAYER_ID;
	}
}
forward bool:FAI_IsValidBoss(bossid); //Silence 'used before declaration' warning
stock bool:FAI_IsValidBoss(bossid) {
	if(bossid >= 0 && bossid < FAI_MAX_BOSSES && FAI_Bosses[bossid][NPCID] != INVALID_PLAYER_ID) {
	    return true;
	}
	return false;
}
stock FAI_DestroyAllBosses() {
	TextDrawDestroy(FAI_BossBlackHealth);
	TextDrawDestroy(FAI_BossDarkRed);
	TextDrawDestroy(FAI_BossBlackCast);
	FAI_BossBlackHealth = Text:INVALID_TEXT_DRAW;
	FAI_BossDarkRed = Text:INVALID_TEXT_DRAW;
	FAI_BossBlackCast = Text:INVALID_TEXT_DRAW;
	for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
	    FAI_DestroyBoss(bossid);
	}
	return 1;
}
stock FAI_DestroyBoss(bossid) {
	if(FAI_IsValidBoss(bossid)) {
	    FCNPC_Destroy(FAI_Bosses[bossid][NPCID]);
	    //FAI_DestroyBossNoFCNPC_Destroy will be called by OnPlayerDisconnect
    	return 1;
    }
    return 0;
}
static FAI_DestroyBossNoFCNPC_Destroy(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
 			RemovePlayerMapIcon(playerid, FAI_Bosses[bossid][ICONID]);
		}
		//In case the boss is casting when the encounter hasn't started yet (can happen by using startbosscastingspell). FAI_SetBossTargetWithReason doesn't take care of this for various reasons.
		if(FAI_Bosses[bossid][TARGET] == INVALID_PLAYER_ID && FAI_IsBossCasting(bossid)) {
	      	FAI_StopBossCasting(bossid);
		}
		//Reset target & threat for all players
		FAI_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0); //FAI_Casting gets reset in here, so we don't need to reset it manually again
		TextDrawDestroy(FAI_Bosses[bossid][TEXTDRAW][0]);
		TextDrawDestroy(FAI_Bosses[bossid][TEXTDRAW][1]);
		TextDrawDestroy(FAI_Bosses[bossid][TEXTDRAW][2]);
		TextDrawDestroy(FAI_Bosses[bossid][TEXTDRAW][3]);
		TextDrawDestroy(FAI_Bosses[bossid][TEXTDRAW][4]);
		TextDrawDestroy(FAI_Bosses[bossid][TEXTDRAW][5]);
		TextDrawDestroy(FAI_Bosses[bossid][TEXTDRAW][6]);
		TextDrawDestroy(FAI_Bosses[bossid][TEXTDRAW][7]);
		FAI_Bosses[bossid][TEXTDRAW][0] = Text:INVALID_TEXT_DRAW;
		FAI_Bosses[bossid][TEXTDRAW][1] = Text:INVALID_TEXT_DRAW;
		FAI_Bosses[bossid][TEXTDRAW][2] = Text:INVALID_TEXT_DRAW;
		FAI_Bosses[bossid][TEXTDRAW][3] = Text:INVALID_TEXT_DRAW;
		FAI_Bosses[bossid][TEXTDRAW][4] = Text:INVALID_TEXT_DRAW;
		FAI_Bosses[bossid][TEXTDRAW][5] = Text:INVALID_TEXT_DRAW;
		FAI_Bosses[bossid][TEXTDRAW][6] = Text:INVALID_TEXT_DRAW;
		FAI_Bosses[bossid][TEXTDRAW][7] = Text:INVALID_TEXT_DRAW;
	    FAI_ResetBossStats(bossid);
	}
}
stock FAI_CreateBoss(name[]) {
	for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		if(FAI_Bosses[bossid][NPCID] == INVALID_PLAYER_ID) {
			FAI_Bosses[bossid][NPCID] = FCNPC_Create(name);
			if(FAI_Bosses[bossid][NPCID] != INVALID_PLAYER_ID) {
		 		FAI_SetBossFullName(bossid, FAI_INVALID_STRING);
				FAI_SetBossMapiconInfo(bossid, FAI_INVALID_ICON_ID, 23, 0xff0000ff, MAPICON_LOCAL);
				FAI_SetBossMaxHealth(bossid, 100.0, false);
				FAI_SetBossDisplayRange(bossid, 0.0);
				FAI_SetBossAggroRange(bossid, 20.0, false);
				FAI_SetBossDisplayIfDead(bossid, true);
				FAI_SetBossCurrentHealth(bossid, -1.0, false);
				FAI_SetBossTarget(bossid, INVALID_PLAYER_ID, false);
				FAI_SetBossMoveInfo(bossid, MOVE_TYPE_AUTO, MOVE_SPEED_AUTO, false, 0.0, true);
				FAI_SetBossRangedAttackInfo(bossid, 20.0, -1, true);
				FAI_SetBossMeleeAttackInfo(bossid, 1.0, -1, false);
				FAI_SetBossAllowNPCTargets(bossid, true, false);
				FAI_SetBossBehaviour(bossid, FAI_BOSS_BEHAVIOUR_NEUTRAL, false);
		    	return bossid;
		    } else {
		        //FCNPC_Create failed
		    	return FAI_INVALID_BOSS_ID;
		    }
		}
	}
	//Max amount of bosses reached
	return FAI_INVALID_BOSS_ID;
}
stock FAI_GetBossFullName(bossid, name[], len) {
	if(FAI_IsValidBoss(bossid)) {
	    FAI_strcpy(name, FAI_Bosses[bossid][FULL_NAME], len);
		return strlen(name);
	}
	return -1;
}
stock FAI_SetBossFullName(bossid, name[]) {
	if(FAI_IsValidBoss(bossid)) {
	    //If the user didn't provide a valid fullName, use the playerName
	    if(!FAI_isnull(name) && !strcmp(name, FAI_INVALID_STRING, true)) {
	        new playerName[MAX_PLAYER_NAME + 1];
	        GetPlayerName(FAI_Bosses[bossid][NPCID], playerName, sizeof(playerName));
			FAI_strcpy(FAI_Bosses[bossid][FULL_NAME], playerName, FAI_MAX_BOSS_FULL_NAME + 1);
		}
	    //If the user did provide a valid fullName, use that one
 		else {
			FAI_strcpy(FAI_Bosses[bossid][FULL_NAME], name, FAI_MAX_BOSS_FULL_NAME + 1);
		}
		TextDrawSetString(FAI_Bosses[bossid][TEXTDRAW][3], FAI_Bosses[bossid][FULL_NAME]);
		//FullName textdraw updates automatically
		return 1;
	}
	return 0;
}
stock FAI_GetBossMapiconInfo(bossid, &iconid, &iconMarker, &iconColor, &iconStyle) {
	if(FAI_IsValidBoss(bossid)) {
		iconid = FAI_Bosses[bossid][ICONID];
		iconMarker = FAI_Bosses[bossid][ICON_MARKER];
		iconColor = FAI_Bosses[bossid][ICON_COLOR];
		iconStyle = FAI_Bosses[bossid][ICON_STYLE];
		return 1;
	}
	return 0;
}
stock FAI_SetBossMapiconInfo(bossid, iconid = FAI_INVALID_ICON_ID, iconMarker = 23, iconColor = 0xff0000ff, iconStyle = MAPICON_LOCAL) {
	if(FAI_IsValidBoss(bossid)) {
		if(iconid == FAI_INVALID_ICON_ID) {
			for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
	 			RemovePlayerMapIcon(playerid, FAI_Bosses[bossid][ICONID]);
			}
		}
	    FAI_Bosses[bossid][ICONID] = iconid;
		//Icon settings below, update automatically (see FAI_Update)
		FAI_Bosses[bossid][ICON_MARKER] = iconMarker;
		FAI_Bosses[bossid][ICON_COLOR] = iconColor;
		FAI_Bosses[bossid][ICON_STYLE] = iconStyle;
		return 1;
	}
	return 0;
}
stock FAI_GetBossMaxHealth(bossid, &Float:health) {
	if(FAI_IsValidBoss(bossid)) {
		health = FAI_Bosses[bossid][MAX_HEALTH];
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
stock FAI_SetBossMaxHealth(bossid, Float:health, bool:keepHealthPercent = false) {
	if(FAI_IsValidBoss(bossid)) {
		if(health <= 0.0) {
		    if(!FCNPC_IsDead(FAI_Bosses[bossid][NPCID])) {
		    	FCNPC_Kill(FAI_Bosses[bossid][NPCID]);
		    }
		    health = 0.0;
		}
	    if(!keepHealthPercent) {
	        if(FAI_Bosses[bossid][CUR_HEALTH] > health) {
	    		FAI_Bosses[bossid][CUR_HEALTH] = health;
	    	}
	    } else {
	    	FAI_Bosses[bossid][CUR_HEALTH] = float(FAI_GetBossCurrentHealthPercent(bossid)) / 100 * health;
	    }
		FAI_Bosses[bossid][MAX_HEALTH] = health;
		FAI_UpdateBossHealthDisplay(bossid);
		return 1;
	}
	return 0;
}
stock FAI_GetBossDisplayRange(bossid, &Float:range) {
	if(FAI_IsValidBoss(bossid)) {
		range = FAI_Bosses[bossid][RANGE_DISPLAY];
		return 1;
	}
	return 0;
}
stock FAI_SetBossDisplayRange(bossid, Float:range) {
	if(FAI_IsValidBoss(bossid)) {
	    if(range < 0.0) {
	        range = 0.0;
	    }
		FAI_Bosses[bossid][RANGE_DISPLAY] = range;
		//Textdraws update automatically (see FAI_Update)
		return 1;
	}
	return 0;
}
stock FAI_GetBossAggroRange(bossid, &Float:range) {
	if(FAI_IsValidBoss(bossid)) {
		range = FAI_Bosses[bossid][RANGE_AGGRO];
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
stock FAI_SetBossAggroRange(bossid, Float:range, bool:checkForTarget = false) {
	if(FAI_IsValidBoss(bossid)) {
		if(range < 0.0) {
		    range = 0.0;
		}
		FAI_Bosses[bossid][RANGE_AGGRO] = range;
		if(checkForTarget) {
		    if(!FAI_IsPlayerInAggroRange(FAI_Bosses[bossid][TARGET], bossid)) {
		        //Reset target
				FAI_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0);
		    }
		}
		return 1;
	}
	return 0;
}
stock FAI_GetBossDisplayIfDead(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		return FAI_Bosses[bossid][DISPLAY_IF_DEAD];
	}
	return -1;
}
stock FAI_SetBossDisplayIfDead(bossid, bool:displayIfDead) {
	if(FAI_IsValidBoss(bossid)) {
		FAI_Bosses[bossid][DISPLAY_IF_DEAD] = displayIfDead;
		//Textdraws update automatically (see FAI_Update)
		return 1;
	}
	return 0;
}
stock FAI_GetBossCurrentHealth(bossid, &Float:health) {
	if(FAI_IsValidBoss(bossid)) {
		health = FAI_Bosses[bossid][CUR_HEALTH];
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
stock FAI_SetBossCurrentHealth(bossid, Float:health, bool:keepHealthPercent = false) {
	if(FAI_IsValidBoss(bossid)) {
		if(health < 0.0) {
		    health = FAI_Bosses[bossid][MAX_HEALTH];
		} else if(health == 0.0) {
		    if(!FCNPC_IsDead(FAI_Bosses[bossid][NPCID])) {
		    	FCNPC_Kill(FAI_Bosses[bossid][NPCID]);
		    }
		}
		if(!keepHealthPercent) {
	        if(FAI_Bosses[bossid][MAX_HEALTH] < health) {
	    		FAI_Bosses[bossid][MAX_HEALTH] = health;
	    	}
	    } else {
	    	FAI_Bosses[bossid][MAX_HEALTH] *= health / FAI_Bosses[bossid][CUR_HEALTH];
	    }
		FAI_Bosses[bossid][CUR_HEALTH] = health;
		FAI_UpdateBossHealthDisplay(bossid);
		return 1;
	}
	return 0;
}
stock FAI_GetBossTarget(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		return FAI_Bosses[bossid][TARGET];
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
stock FAI_SetBossTarget(bossid, playerid, bool:checkForAggroRange = false) {
	//Set target to playerid (valid playerid check in setter)
	//FAI_IsValidBoss in FAI_SetBossTargetWithReason
	return FAI_SetBossTargetWithReason(bossid, playerid, 4, checkForAggroRange);
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
static FAI_SetBossTargetWithReason(bossid, newtargetid, reason, bool:checkForAggroRange = false) {
	if(FAI_IsValidBoss(bossid)) {
		new oldtargetid = FAI_Bosses[bossid][TARGET];
		if(oldtargetid != newtargetid) {
		    new bool:newTargetValid = true;
		    new bool:newTargetStreamedIn = true;
		    if(newtargetid != INVALID_PLAYER_ID) {
		        if(!FAI_IsBossValidForPlayer(newtargetid, bossid)) {
		        	newTargetValid = false;
		        }
		        if(!IsPlayerStreamedIn(FAI_Bosses[bossid][NPCID], newtargetid)) {
		            newTargetStreamedIn = false;
		        }
		    }
		    new bool:newTargetInRange = true;
		    if(checkForAggroRange && !FAI_IsPlayerInAggroRange(newtargetid, bossid)) {
		        newTargetInRange = false;
		    }
		    if(newTargetValid && newTargetStreamedIn && newTargetInRange) {
		        if(oldtargetid != INVALID_PLAYER_ID) {
					CallRemoteFunction("FAI_OnPlayerLoseAggro", "dd", oldtargetid, bossid);
		        }
				FAI_Bosses[bossid][TARGET] = newtargetid;
				if(newtargetid != INVALID_PLAYER_ID) {
					CallRemoteFunction("FAI_OnPlayerGetAggro", "dd", newtargetid, bossid);
			        if(oldtargetid == INVALID_PLAYER_ID) {
			            new bool:reasonShot = false;
			            if(reason == 1) {
			                reasonShot = true;
			            }
						CallRemoteFunction("FAI_OnBossEncounterStart", "dbd", bossid, reasonShot, newtargetid);
					}
				} else {
			        if(oldtargetid != INVALID_PLAYER_ID) {
			            new bool:reasonDeath = false;
			            if(reason == 2) {
							reasonDeath = true;
			            }
	      				FAI_BossStopAttack(bossid);
	      				FAI_StopBossCasting(bossid);
	      				//Reset threat
						CallRemoteFunction("FAI_OnBossEncounterStop", "dbd", bossid, reasonDeath, oldtargetid);
					}
				}
				return 1;
		    }
	    }
	}
	return 0;
}
stock FAI_GetBossMoveInfo(bossid, &type, &Float:speed, &bool:useMapAndreas, &Float:radius, &bool:setAngle) {
	if(FAI_IsValidBoss(bossid)) {
	    type = FAI_Bosses[bossid][MOVE_TYPE];
	    speed = FAI_Bosses[bossid][MOVE_SPEED];
	    useMapAndreas = FAI_Bosses[bossid][MOVE_USE_MAP_ANDREAS];
	    radius = FAI_Bosses[bossid][MOVE_RADIUS];
	    setAngle = FAI_Bosses[bossid][MOVE_SET_ANGLE];
	    return 1;
	}
	return 0;
}
stock FAI_SetBossMoveInfo(bossid, type = MOVE_TYPE_AUTO, Float:speed = MOVE_SPEED_AUTO, bool:useMapAndreas = false, Float:radius = 0.0, bool:setAngle = true) {
	if(FAI_IsValidBoss(bossid)) {
	    FAI_Bosses[bossid][MOVE_TYPE] = type;
	    FAI_Bosses[bossid][MOVE_SPEED] = speed;
	    FAI_Bosses[bossid][MOVE_USE_MAP_ANDREAS] = useMapAndreas;
	    FAI_Bosses[bossid][MOVE_RADIUS] = radius;
	    FAI_Bosses[bossid][MOVE_SET_ANGLE] = setAngle;
        if(FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
      		FAI_BossAttackTarget(bossid, FAI_Bosses[bossid][TARGET]);
      	}
	    return 1;
	}
	return 0;
}
stock FAI_GetBossRangedAttackInfo(bossid, &Float:range, &delay, &bool:setAngle) {
	if(FAI_IsValidBoss(bossid)) {
	    range = FAI_Bosses[bossid][RANGED_ATTACK_RANGE];
	    delay = FAI_Bosses[bossid][RANGED_ATTACK_DELAY];
	    setAngle = FAI_Bosses[bossid][RANGED_ATTACK_SET_ANGLE];
	    return 1;
	}
	return 0;
}
stock FAI_SetBossRangedAttackInfo(bossid, Float:range = 20.0, delay = -1, bool:setAngle = true) {
	if(FAI_IsValidBoss(bossid)) {
	    FAI_Bosses[bossid][RANGED_ATTACK_RANGE] = range;
	    FAI_Bosses[bossid][RANGED_ATTACK_DELAY] = delay;
	    FAI_Bosses[bossid][RANGED_ATTACK_SET_ANGLE] = setAngle;
        if(FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
      		FAI_BossAttackTarget(bossid, FAI_Bosses[bossid][TARGET]);
      	}
	    return 1;
	}
	return 0;
}
stock FAI_GetBossMeleeAttackInfo(bossid, &Float:range, &delay, &bool:useFightStyle) {
	if(FAI_IsValidBoss(bossid)) {
	    range = FAI_Bosses[bossid][MELEE_ATTACK_RANGE];
	    delay = FAI_Bosses[bossid][MELEE_ATTACK_DELAY];
	    useFightStyle = FAI_Bosses[bossid][MELEE_ATTACK_USE_FIGHT_STYLE];
	    return 1;
	}
	return 0;
}
stock FAI_SetBossMeleeAttackInfo(bossid, Float:range = 1.0, delay = -1, bool:useFightStyle = false) {
	if(FAI_IsValidBoss(bossid)) {
	    FAI_Bosses[bossid][MELEE_ATTACK_RANGE] = range;
	    FAI_Bosses[bossid][MELEE_ATTACK_DELAY] = delay;
	    FAI_Bosses[bossid][MELEE_ATTACK_USE_FIGHT_STYLE] = useFightStyle;
        if(FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
      		FAI_BossAttackTarget(bossid, FAI_Bosses[bossid][TARGET]);
      	}
	    return 1;
	}
	return 0;
}
stock FAI_GetBossAllowNPCTargets(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		return FAI_Bosses[bossid][ALLOW_NPC_TARGETS];
	}
	return -1;
}
stock FAI_SetBossAllowNPCTargets(bossid, bool:allowNPCTargets, bool:checkForTarget = false) {
	if(FAI_IsValidBoss(bossid)) {
		FAI_Bosses[bossid][ALLOW_NPC_TARGETS] = allowNPCTargets;
		if(checkForTarget) {
		    if(!allowNPCTargets && FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID && IsPlayerNPC(FAI_Bosses[bossid][TARGET])) {
		        //Reset target
				FAI_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0);
		    }
		}
		return 1;
	}
	return 0;
}
stock FAI_GetBossBehaviour(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		return FAI_Bosses[bossid][BEHAVIOUR];
	}
	return -1;
}
stock FAI_SetBossBehaviour(bossid, behaviour, bool:checkForTarget = false) {
	if(FAI_IsValidBoss(bossid)) {
	    if(behaviour == FAI_BOSS_BEHAVIOUR_FRIENDLY || behaviour == FAI_BOSS_BEHAVIOUR_NEUTRAL || behaviour == FAI_BOSS_BEHAVIOUR_UNFRIENDLY) {
			FAI_Bosses[bossid][BEHAVIOUR] = behaviour;
			if(checkForTarget) {
			    if(behaviour == FAI_BOSS_BEHAVIOUR_FRIENDLY && FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
			        //Reset target
					FAI_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0);
			    }
			}
			return 1;
		}
	}
	return 0;
}
stock FAI_GetBossNPCID(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		return FAI_Bosses[bossid][NPCID];
	}
	return INVALID_PLAYER_ID;
}
#define FAI_GetBossPlayerID(%0) FAI_GetBossNPCID(%0) //Alias
/*stock FAI_GetBossPlayerID(bossid) {
	return FAI_GetBossNPCID(bossid);
}*/
stock Text:FAI_GetBossTextDraw(bossid, textdraw) {
	if(FAI_IsValidBoss(bossid) && textdraw >= 0 && textdraw < FAI_MAX_BOSS_TEXTDRAWS) {
		return FAI_Bosses[bossid][TEXTDRAW][textdraw];
	}
	return Text:INVALID_TEXT_DRAW;
}
stock FAI_GetBossCurrentHealthPercent(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		return floatround(FAI_Bosses[bossid][CUR_HEALTH] / FAI_Bosses[bossid][MAX_HEALTH] * 100, floatround_ceil);
	}
	return -1;
}

stock FAI_GetBossIDFromNPCID(npcid) {
	for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
	    if(npcid == FAI_Bosses[bossid][NPCID]) {
	        return bossid;
		}
	}
	return FAI_INVALID_BOSS_ID;
}
#define FAI_GetBossIDFromPlayerID(%0) FAI_GetBossIDFromNPCID(%0) //Alias
/*stock FAI_GetBossIDFromPlayerID(playerid) {
	return FAI_GetBossIDFromNPCID(playerid);
}*/
forward bool:FAI_IsBossValidForPlayer(playerid, bossid); //Silence 'used before declaration' warning
stock bool:FAI_IsBossValidForPlayer(playerid, bossid) {
	if(IsPlayerConnected(playerid) && FAI_IsValidBoss(bossid)) {
	    new playerState = GetPlayerState(playerid);
	    new bossplayerid = FAI_GetBossNPCID(bossid);
		if(bossplayerid != playerid && FCNPC_IsSpawned(bossplayerid) && (!FCNPC_IsDead(bossplayerid) || FAI_Bosses[bossid][DISPLAY_IF_DEAD])) {
		    new bossInterior = FCNPC_GetInterior(bossplayerid);
		    new bossWorld = FCNPC_GetVirtualWorld(bossplayerid);
		    if(!IsPlayerNPC(playerid)) {
				if(GetPlayerInterior(playerid) == bossInterior && GetPlayerVirtualWorld(playerid) == bossWorld && playerState != PLAYER_STATE_NONE && playerState != PLAYER_STATE_WASTED
				&& playerState != PLAYER_STATE_SPAWNED && playerState != PLAYER_STATE_SPECTATING && !FAI_PlayerPaused[playerid]) {
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
static FAI_GetClosestBossToDisplay(playerid) {
	new closestBoss = FAI_INVALID_BOSS_ID;
	new Float:closestBossRange = 0.0;
	if(IsPlayerConnected(playerid)) {
    	new Float:bossX, Float:bossY, Float:bossZ;
    	new Float:playerRange;
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		    if(FAI_IsBossValidForPlayer(playerid, bossid)) {
	        	FCNPC_GetPosition(FAI_Bosses[bossid][NPCID], bossX, bossY, bossZ);
	            playerRange = GetPlayerDistanceFromPoint(playerid, bossX, bossY, bossZ);
	            //Don't display if display range is <= 0
		  		if(FAI_IsPlayerInDisplayRange(playerid, bossid) && (!FAI_IsValidBoss(closestBoss) || playerRange < closestBossRange)) {
			        closestBossRange = playerRange;
			        closestBoss = bossid;
				}
			}
		}
	}
	return closestBoss;
}
static FAI_GetClosestPlayerToTakeAggro(bossid) {
	new closestPlayer = INVALID_PLAYER_ID;
	new Float:closestPlayerRange = 0.0;
	if(FAI_IsValidBoss(bossid)) {
    	new Float:playerX, Float:playerY, Float:playerZ;
    	new Float:bossRange;
		for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
		    if(FAI_IsBossValidForPlayer(playerid, bossid) && (!IsPlayerNPC(playerid) || FAI_Bosses[bossid][ALLOW_NPC_TARGETS])) {
		        if(!IsPlayerNPC(playerid)) {
		        	GetPlayerPos(playerid, playerX, playerY, playerZ);
		        } else {
		        	FCNPC_GetPosition(playerid, playerX, playerY, playerZ);
		        }
	            bossRange = GetPlayerDistanceFromPoint(FAI_Bosses[bossid][NPCID], playerX, playerY, playerZ);
		  		if(FAI_IsPlayerInAggroRange(playerid, bossid) && (closestPlayer == INVALID_PLAYER_ID || bossRange < closestPlayerRange)) {
			        closestPlayerRange = bossRange;
			        closestPlayer = playerid;
				}
			}
		}
	}
	return closestPlayer;
}
forward bool:FAI_IsPlayerInDisplayRange(playerid, bossid); //Silence 'used before declaration' warning
stock bool:FAI_IsPlayerInDisplayRange(playerid, bossid) {
	if(IsPlayerConnected(playerid) && FAI_IsValidBoss(bossid) && FAI_IsBossValidForPlayer(playerid, bossid)) {
		new Float:bossX, Float:bossY, Float:bossZ;
		FCNPC_GetPosition(FAI_Bosses[bossid][NPCID], bossX, bossY, bossZ);
	    new Float:playerRange = GetPlayerDistanceFromPoint(playerid, bossX, bossY, bossZ);
		//Don't display if display range is <= 0
		if(FAI_Bosses[bossid][RANGE_DISPLAY] > 0.0 && playerRange <= FAI_Bosses[bossid][RANGE_DISPLAY]) {
		    return true;
		}
	}
	return false;
}
forward bool:FAI_IsPlayerInAggroRange(playerid, bossid); //Silence 'used before declaration' warning
stock bool:FAI_IsPlayerInAggroRange(playerid, bossid) {
	if(IsPlayerConnected(playerid) && FAI_IsValidBoss(bossid) && FAI_IsBossValidForPlayer(playerid, bossid)) {
		new Float:playerX, Float:playerY, Float:playerZ;
        if(!IsPlayerNPC(playerid)) {
        	GetPlayerPos(playerid, playerX, playerY, playerZ);
        } else {
        	FCNPC_GetPosition(playerid, playerX, playerY, playerZ);
        }
		new Float:bossRange = GetPlayerDistanceFromPoint(FAI_Bosses[bossid][NPCID], playerX, playerY, playerZ);
		//Don't aggro if aggro range is <= 0.0
		if(FAI_Bosses[bossid][RANGE_AGGRO] > 0.0 && bossRange <= FAI_Bosses[bossid][RANGE_AGGRO]) {
		    return true;
		}
	}
	return false;
}
static FAI_UpdateBossHealthDisplay(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		TextDrawTextSize(FAI_Bosses[bossid][TEXTDRAW][0], (470.0 - 167.3) * FAI_Bosses[bossid][CUR_HEALTH] / FAI_Bosses[bossid][MAX_HEALTH] + 167.3, 0.0);
		for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
			//Only update the textdraw for a player if he is seeing the textdraw of the boss
			//Last part of condition:  we don't need to display things to an npc
			if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid)) {
				new closestBoss = FAI_GetClosestBossToDisplay(playerid);
				if(FAI_IsValidBoss(closestBoss) && bossid == closestBoss) {
					TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][0]);
				}
			}
		}
		new string[14 + 1];
		format(string, sizeof(string), "%d%", FAI_GetBossCurrentHealthPercent(bossid));
		TextDrawSetString(FAI_Bosses[bossid][TEXTDRAW][1], string);
		new healthInteger = floatround(FAI_Bosses[bossid][CUR_HEALTH], floatround_ceil); //Ceil so 0.3 still displays as 1 instead of 0
		#if FAI_SHORTEN_NUMBERS == false
			TextDrawSetString(FAI_Bosses[bossid][TEXTDRAW][2], FAI_DisplayReadableInteger(healthInteger));
		#else
			if(float(healthInteger) / 1000 / 1000 / 1000 >= 1) {
				format(string, sizeof(string), "%s B", FAI_DisplayReadableFloat(float(healthInteger) / 1000 / 1000 / 1000, 2, 2));
			} else if(float(healthInteger) / 1000 / 1000 >= 1) {
				format(string, sizeof(string), "%s M", FAI_DisplayReadableFloat(float(healthInteger) / 1000 / 1000, 2, 2));
			} else if(float(healthInteger) / 1000 >= 1) {
				format(string, sizeof(string), "%s K", FAI_DisplayReadableFloat(float(healthInteger) / 1000, 2, 2));
			} else {
				FAI_strcpy(string, FAI_DisplayReadableInteger(healthInteger));
			}
			TextDrawSetString(FAI_Bosses[bossid][TEXTDRAW][2], string);
		#endif
	}
}
static FAI_UpdateBossCastDisplay(bossid) {
	if(FAI_IsValidBoss(bossid) && (FAI_IsBossCasting(bossid) || FAI_IsBossCastBarExtra(bossid))) {
	    new spellid = FAI_Casting[bossid][SPELLID];
	    TextDrawBoxColor(FAI_Bosses[bossid][TEXTDRAW][4], FAI_Spells[spellid][CAST_BAR_COLOR_DARK]);
	    TextDrawBoxColor(FAI_Bosses[bossid][TEXTDRAW][5], FAI_Spells[spellid][CAST_BAR_COLOR_LIGHT]);
	    //Don't show the extraProgress on the bar and the number representation
		new showExtraProgress = FAI_Casting[bossid][CAST_PROGRESS] - FAI_Spells[spellid][CAST_TIME];
		if(showExtraProgress < 0) {
		    showExtraProgress = 0;
		}
		new progressWithoutShowExtra = FAI_Casting[bossid][CAST_PROGRESS] - showExtraProgress;
		//Show an inverted castbar if needed
	    if(!FAI_Spells[spellid][CAST_BAR_INVERTED]) {
			TextDrawTextSize(FAI_Bosses[bossid][TEXTDRAW][5], (470.0 - 167.3) * progressWithoutShowExtra / FAI_Spells[spellid][CAST_TIME] + 167.3, 0.0);
		} else {
			TextDrawTextSize(FAI_Bosses[bossid][TEXTDRAW][5], (470.0 - ((470.0 - 167.3) * progressWithoutShowExtra / FAI_Spells[spellid][CAST_TIME] + 167.3)) + 167.3, 0.0);
		}
		//Reshow the textdraw to make the changes (color + size) visible
		for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
			//Only update the textdraw for a player if he is seeing the textdraw of the boss
			//Last part of condition:  we don't need to display things to an npc
			if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid)) {
				new closestBoss = FAI_GetClosestBossToDisplay(playerid);
				if(FAI_IsValidBoss(closestBoss) && bossid == closestBoss) {
					TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][4]);
					TextDrawShowForPlayer(playerid, FAI_Bosses[bossid][TEXTDRAW][5]);
				}
			}
		}
		TextDrawSetString(FAI_Bosses[bossid][TEXTDRAW][6], FAI_Spells[spellid][NAME]);
		new string[21 + 1 + 21 + 2 + 1];
		new Float:castProgress = float(progressWithoutShowExtra);
		//Show an inverted number representation if needed
	    if(FAI_Spells[spellid][CAST_TIME_INVERTED]) {
	    	castProgress = float(FAI_Spells[spellid][CAST_TIME] - progressWithoutShowExtra);
	    }
		new Float:castTime = float(FAI_Spells[spellid][CAST_TIME]);
		if(castProgress / 1000 / 60 >= 1) {
			format(string, sizeof(string), "%sm", FAI_DisplayReadableFloat(castProgress / 1000 / 60, 2, 2));
		} else {
			format(string, sizeof(string), "%ss", FAI_DisplayReadableFloat(castProgress / 1000, 2, 2));
		}
		if(castTime / 1000 / 60 >= 1) {
			format(string, sizeof(string), "%s/%sm", string, FAI_DisplayReadableFloat(castTime / 1000 / 60, 2, 2));
		} else {
			format(string, sizeof(string), "%s/%ss", string, FAI_DisplayReadableFloat(castTime / 1000, 2, 2));
		}
		TextDrawSetString(FAI_Bosses[bossid][TEXTDRAW][7], string);
 	}
}
static FAI_IncreaseBossCastProgress(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		if(FAI_IsBossCasting(bossid)) {
		    new spellid = FAI_Casting[bossid][SPELLID];
			//Don't cast above castTime
			if(FAI_Spells[spellid][CAST_TIME] - FAI_Casting[bossid][CAST_PROGRESS] <= FAI_UPDATE_TIME) {
			    FAI_SetBossCastingProgress(bossid, FAI_Spells[spellid][CAST_TIME]); //We set the CAST_PROGRESS to CAST_TIME (say 500) instead of CAST_PROGRESS + FAI_UPDATE_TIME (say 490 + 49), because we want showextra to start exactly at 0 (say 500 - 500) and not something > 0 (say 490 - 500 + 49)
			} else {
			    FAI_SetBossCastingProgress(bossid, FAI_Casting[bossid][CAST_PROGRESS] + FAI_UPDATE_TIME);
			    //If the spell target becomes invalid, stop the cast
				//Otherwise: start cast, spell target dies before cast on him ends, spell target respawns, spell will still be executed on him
			    if(FAI_Casting[bossid][TARGETID] != INVALID_PLAYER_ID && !FAI_IsBossValidForPlayer(FAI_Casting[bossid][TARGETID], bossid)) {
					FAI_StopBossCasting(bossid);
			    }
			}
			FAI_UpdateBossCastDisplay(bossid);
		}
		//Keep showing the castbar for a small additional time after the cast is complete
		else if(FAI_IsBossCastBarExtra(bossid)) {
		    FAI_SetBossCastingExtraProgress(bossid, FAI_GetBossCastingExtraProgress(bossid) + FAI_UPDATE_TIME);
		}
	}
}
stock bool:FAI_BossHasMeleeWeapons(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		new weaponid = FCNPC_GetWeapon(FAI_GetBossNPCID(bossid));
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
static FAI_BossAttackTarget(bossid, targetid) {
	if(FAI_IsValidBoss(bossid) && FAI_IsBossValidForPlayer(targetid, bossid)) {
		new bossplayerid = FAI_GetBossNPCID(bossid);
		new Float:bossX, Float:bossY, Float:bossZ;
		FCNPC_GetPosition(bossplayerid, bossX, bossY, bossZ);
		new Float:distance = GetPlayerDistanceFromPoint(targetid, bossX, bossY, bossZ);
		new Float:attackRange = FAI_Bosses[bossid][RANGED_ATTACK_RANGE];
		new bool:isMelee = FAI_BossHasMeleeWeapons(bossid);
		if(isMelee) {
		    attackRange = FAI_Bosses[bossid][MELEE_ATTACK_RANGE];
		}
		new bool:canMove = true;
		new bool:canAttack = true;
		if(FAI_IsBossCasting(bossid)) {
		    new spellid = FAI_Casting[bossid][SPELLID];
		    canMove = FAI_Spells[spellid][CAN_MOVE];
		    canAttack = FAI_Spells[spellid][CAN_ATTACK];
		}
		//Target in attack range, attack if allowed
		if(attackRange == -1 || distance <= attackRange) {
		    if(canAttack) {
		        FAI_BossAttackAim(bossid, targetid);
		    } else {
		        if(canMove) {
		        	FAI_BossAttackMove(bossid, targetid);
		        } else {
		            FAI_BossStopAttack(bossid);
		        }
		    }
		}
		//Target not in attack range, move to target if allowed
		else {
		    if(canMove) {
		        FAI_BossAttackMove(bossid, targetid);
		    } else {
			    if(canAttack) {
		        	FAI_BossAttackAim(bossid, targetid);
			    } else {
		            FAI_BossStopAttack(bossid);
			    }
		    }
		}
	}
	return 1;
}
static FAI_BossAttackAim(bossid, targetid) {
	if(FAI_IsValidBoss(bossid) && FAI_IsBossValidForPlayer(targetid, bossid)) {
	    new bossplayerid = FAI_GetBossNPCID(bossid);
		new bool:isMelee = FAI_BossHasMeleeWeapons(bossid);
		if(FCNPC_IsMoving(bossplayerid)) {
 			FCNPC_Stop(bossplayerid);
	    }
	    if(!isMelee) {
	        if(FCNPC_IsAttacking(bossplayerid)) { //In case the npc switched weapons
	    		FCNPC_StopAttack(bossplayerid);
		    }
	        if(!FCNPC_IsAimingAtPlayer(bossplayerid, targetid)) { //So we don't aim again when we were already aiming at that same player. If aiming at another player, this will execute
				FCNPC_AimAtPlayer(bossplayerid, targetid, true, FAI_Bosses[bossid][RANGED_ATTACK_DELAY], FAI_Bosses[bossid][RANGED_ATTACK_SET_ANGLE]);
			}
		} else {
		    if(FCNPC_IsAiming(bossplayerid)) { //In case the npc switched weapons
			    FCNPC_StopAim(bossplayerid);
		    }
	        if(!FCNPC_IsAttacking(bossplayerid)) { //So we don't attack again when we were already attacking
		    	FCNPC_MeleeAttack(bossplayerid, FAI_Bosses[bossid][MELEE_ATTACK_DELAY], FAI_Bosses[bossid][MELEE_ATTACK_USE_FIGHT_STYLE]);
		    }
		}
	}
}
static FAI_BossAttackMove(bossid, targetid) {
	if(FAI_IsValidBoss(bossid) && FAI_IsBossValidForPlayer(targetid, bossid)) {
	    new bossplayerid = FAI_GetBossNPCID(bossid);
	    if(FCNPC_IsAiming(bossplayerid)) {
		    FCNPC_StopAim(bossplayerid);
	    }
        if(FCNPC_IsAttacking(bossplayerid)) {
    		FCNPC_StopAttack(bossplayerid);
    	}
    	if(!FCNPC_IsMovingAtPlayer(bossplayerid, targetid)) { //So we don't move again when we were already moving to that same player. If moving at another player, this will execute
    	    #if FAI_USE_MAP_ANDREAS == true
				FCNPC_GoToPlayer(bossplayerid, targetid, FAI_Bosses[bossid][MOVE_TYPE], FAI_Bosses[bossid][MOVE_SPEED], FAI_Bosses[bossid][MOVE_USE_MAP_ANDREAS], FAI_Bosses[bossid][MOVE_RADIUS], FAI_Bosses[bossid][MOVE_SET_ANGLE]);
			#else
				FCNPC_GoToPlayer(bossplayerid, targetid, FAI_Bosses[bossid][MOVE_TYPE], FAI_Bosses[bossid][MOVE_SPEED], false, FAI_Bosses[bossid][MOVE_RADIUS], FAI_Bosses[bossid][MOVE_SET_ANGLE]);
			#endif
		}
	}
}
static FAI_BossStopAttack(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		new bossplayerid = FAI_GetBossNPCID(bossid);
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
stock bool:FAI_IsEncounterStarted(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		if(FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
	 		return true;
		}
	}
	return false;
}
stock FAI_StopEncounter(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		//Reset target & threat for all players
		FAI_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0);
		return 1;
	}
	return 0;
}

//Spell
static FAI_InitAllSpells() {
	for(new spellid = 0; spellid < FAI_MAX_SPELLS; spellid++) {
	    FAI_InitSpell(spellid);
	}
}
static FAI_InitSpell(spellid) {
	//Don't use FAI_IsValidSpell(spellid)
	if(spellid >= 0 && spellid < FAI_MAX_SPELLS) {
		FAI_strcpy(FAI_Spells[spellid][NAME], FAI_INVALID_STRING, FAI_MAX_SPELL_NAME + 1);
		FAI_Spells[spellid][CAST_TIME] = 0;
		FAI_Spells[spellid][AMOUNT] = 0.0;
		FAI_Spells[spellid][CAST_BAR_COLOR_DARK] = FAI_INVALID_COLOR;
		FAI_Spells[spellid][CAST_BAR_COLOR_LIGHT] = FAI_INVALID_COLOR;
		FAI_Spells[spellid][CAST_BAR_INVERTED] = false;
		FAI_Spells[spellid][CAST_TIME_INVERTED] = false;
		FAI_Spells[spellid][CAN_MOVE] = false;
		FAI_Spells[spellid][CAN_ATTACK] = false;
		FAI_strcpy(FAI_Spells[spellid][INFO], FAI_INVALID_STRING, FAI_MAX_SPELL_INFO + 1);
	}
}
stock bool:FAI_IsValidSpell(spellid) {
	if(spellid >= 0 && spellid < FAI_MAX_SPELLS && strcmp(FAI_Spells[spellid][NAME], FAI_INVALID_STRING, true)) {
	    return true;
	}
	return false;
}
stock FAI_DestroyAllSpells() {
	for(new spellid = 0; spellid < FAI_MAX_SPELLS; spellid++) {
	    FAI_DestroySpell(spellid);
	}
	return 1;
}
stock FAI_DestroySpell(spellid) {
	if(FAI_IsValidSpell(spellid)) {
		FAI_StopAllBossesCastingSpell(spellid);
		FAI_InitSpell(spellid);
		return 1;
	}
	return 0;
}
stock FAI_CreateSpell(name[]) {
	for(new spellid = 0; spellid < FAI_MAX_SPELLS; spellid++) {
	    if(!strcmp(FAI_Spells[spellid][NAME], FAI_INVALID_STRING, true)) {
	    	FAI_strcpy(FAI_Spells[spellid][NAME], name, FAI_MAX_SPELL_NAME + 1);
			FAI_SetSpellName(spellid, name);
			FAI_SetSpellCastTime(spellid, 2000, false);
			FAI_SetSpellAmount(spellid, 0.0);
			FAI_SetSpellCastBarColorDark(spellid, 0x645005ff);
			FAI_SetSpellCastBarColorLight(spellid, 0xb4820aff);
			FAI_SetSpellCastBarInverted(spellid, false, false);
			FAI_SetSpellCastTimeInverted(spellid, false, false);
			FAI_SetSpellCanMove(spellid, false);
			FAI_SetSpellCanAttack(spellid, false);
			FAI_SetSpellInfo(spellid, FAI_INVALID_STRING);
	    	return spellid;
		}
	}
	//Max amount of spells reached
	return FAI_INVALID_SPELL_ID;
}
stock FAI_GetSpellName(spellid, name[], len) {
	if(FAI_IsValidSpell(spellid)) {
	    FAI_strcpy(name, FAI_Spells[spellid][NAME], len);
		return strlen(name);
	}
	return -1;
}
stock FAI_SetSpellName(spellid, name[]) {
	if(FAI_IsValidSpell(spellid)) {
	    FAI_strcpy(FAI_Spells[spellid][NAME], name, FAI_MAX_SPELL_NAME + 1);
	    for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
	        if(FAI_IsValidBoss(bossid) && (FAI_IsBossCastingSpell(bossid, spellid) || FAI_IsBossCastBarExtraForSpell(bossid, spellid))) {
				TextDrawSetString(FAI_Bosses[bossid][TEXTDRAW][6], FAI_Spells[spellid][NAME]);
				//Textdraw updates automatically
	        }
	    }
		return 1;
	}
	return 0;
}
stock FAI_GetSpellCastTime(spellid) {
	if(FAI_IsValidSpell(spellid)) {
	    return FAI_Spells[spellid][CAST_TIME];
	}
	return -1;
}
/*
Instant:
- casttime 500, progress 450, extraprogress 0 => casttime 0 (instant), progress becomes 0, execute complete stopcast and init cast immediately
- casttime 500, progress 850, extraprogress 350 => casttime 0 (instant), progress becomes 0, init cast immediately (not complete stopcast as well, because it has already been called, because there is extraprogress)
ShowExtra:
- casttime 500, progress 850, extraprogress 350 => casttime 400, progress becomes 750 which is casttime + extraprogress (keep showextra fixed, otherwise showextra will start again)
- casttime 500, progress 850, extraprogress 350 => casttime 900, progress becomes 1250 which is casttime + extraprogress (keep showextra fixed, otherwise FAI_OnBossStopCasting will be called again when progress reaches casttime again)
Keeppercent:
- casttime 500, progress 450, extraprogress 0 => casttime 400, progress becomes 360
- casttime 500, progress 450, extraprogress 0 => casttime 600, progress becomes 540
Dont keeppercent:
- casttime 500, progress 450, extraprogress 0 => casttime 400, progress becomes 400 which is casttime, execute complete stopcast immediately (not init cast as well to allow for showExtra, except if showExtra is invalid)
- casttime 500, progress 450, extraprogress 0 => casttime 600, progress stays 450
In other words: showextra does never scale it will always remain a fixed number. Instants don't have showextra time. Both are to prevent showextra from going over FAI_CAST_BAR_SHOW_EXTRA_TIME and to prevent FAI_OnBossStopCasting from being called twice.
*/
stock FAI_SetSpellCastTime(spellid, castTime, bool:keepCastPercent = false) {
	if(FAI_IsValidSpell(spellid)) {
	    if(castTime < 0) {
			castTime = 0;
		}
		new oldCastTime = FAI_Spells[spellid][CAST_TIME];
		FAI_Spells[spellid][CAST_TIME] = castTime;
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		    if(FAI_IsValidBoss(bossid) && (FAI_IsBossCastingSpell(bossid, spellid) || FAI_IsBossCastBarExtraForSpell(bossid, spellid))) {
			    new showExtraProgress = FAI_Casting[bossid][CAST_PROGRESS] - oldCastTime;
				if(showExtraProgress < 0) {
				    showExtraProgress = 0;
				}
		        if(castTime == 0) {
			    	FAI_Casting[bossid][CAST_PROGRESS] = 0; //Must be set before FAI_BossCastProgressComplete is called, because that function checks for CAST_PROGRESS == CAST_TIME
			    	if(showExtraProgress == 0) {
						FAI_BossCastProgressComplete(bossid, spellid);
					}
	    			FAI_InitBossCasting(bossid);
		        } else {
		            if(showExtraProgress != 0) {
		                FAI_Casting[bossid][CAST_PROGRESS] = castTime + showExtraProgress;
		            } else {
		                if(keepCastPercent) {
							FAI_Casting[bossid][CAST_PROGRESS] = floatround(float(FAI_Casting[bossid][CAST_PROGRESS]) / oldCastTime * castTime, floatround_floor); //floatround_floor, because (say 400.9) the next progress integer (401) wasn't reached yet
						} else {
							if(FAI_Casting[bossid][CAST_PROGRESS] >= castTime) {
								FAI_Casting[bossid][CAST_PROGRESS] = castTime; //Must be set before FAI_BossCastProgressComplete is called, because that function checks for CAST_PROGRESS == CAST_TIME
								FAI_BossCastProgressComplete(bossid, spellid);
								#if FAI_CAST_BAR_SHOW_EXTRA_TIME <= 0
									FAI_InitBossCasting(bossid);
								#endif
							}
		                }
		            }
		            //Don't update castbar with instants or if no show extra
		            #if FAI_CAST_BAR_SHOW_EXTRA_TIME > 0
						FAI_UpdateBossCastDisplay(bossid);
					#endif
				}
			}
		}
	    return 1;
	}
	return 0;
}
stock FAI_GetSpellAmount(spellid, &Float:amount) {
	if(FAI_IsValidSpell(spellid)) {
	    amount = FAI_Spells[spellid][AMOUNT];
	    return 1;
	}
	return 0;
}
stock FAI_SetSpellAmount(spellid, Float:amount) {
	if(FAI_IsValidSpell(spellid)) {
	    if(amount < 0.0) {
			amount = 0.0;
		}
	    FAI_Spells[spellid][AMOUNT] = amount;
	    return 1;
	}
	return 0;
}
stock FAI_GetSpellCastBarColorDark(spellid) {
	if(FAI_IsValidSpell(spellid)) {
		return FAI_Spells[spellid][CAST_BAR_COLOR_DARK];
	}
	return -1;
}
stock FAI_SetSpellCastBarColorDark(spellid, color) {
	if(FAI_IsValidSpell(spellid)) {
		FAI_Spells[spellid][CAST_BAR_COLOR_DARK] = color;
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		    if(FAI_IsValidBoss(bossid) && (FAI_IsBossCastingSpell(bossid, spellid) || FAI_IsBossCastBarExtraForSpell(bossid, spellid))) {
    			FAI_UpdateBossCastDisplay(bossid);
		    }
	    }
	    return 1;
	}
	return 0;
}
stock FAI_GetSpellCastBarColorLight(spellid) {
	if(FAI_IsValidSpell(spellid)) {
		return FAI_Spells[spellid][CAST_BAR_COLOR_LIGHT];
	}
	return -1;
}
stock FAI_SetSpellCastBarColorLight(spellid, color) {
	if(FAI_IsValidSpell(spellid)) {
		FAI_Spells[spellid][CAST_BAR_COLOR_LIGHT] = color;
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		    if(FAI_IsValidBoss(bossid) && (FAI_IsBossCastingSpell(bossid, spellid) || FAI_IsBossCastBarExtraForSpell(bossid, spellid))) {
    			FAI_UpdateBossCastDisplay(bossid);
		    }
	    }
	    return 1;
	}
	return 0;
}
stock bool:FAI_GetSpellCastBarInverted(spellid) {
	if(FAI_IsValidSpell(spellid)) {
		return FAI_Spells[spellid][CAST_BAR_INVERTED];
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
stock FAI_SetSpellCastBarInverted(spellid, bool:inverted, bool:invertProgressMade = false) {
	if(FAI_IsValidSpell(spellid)) {
	    //Don't inv if already inv and vice versa
	    new bool:oldInverted = FAI_Spells[spellid][CAST_BAR_INVERTED];
		FAI_Spells[spellid][CAST_BAR_INVERTED] = inverted;
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		    if(FAI_IsValidBoss(bossid) && (FAI_IsBossCastingSpell(bossid, spellid) || FAI_IsBossCastBarExtraForSpell(bossid, spellid))) {
    			FAI_UpdateBossCastDisplay(bossid);
		        if(invertProgressMade && FAI_IsBossCastingSpell(bossid, spellid) && oldInverted != inverted) { //Only invert when casting, not when showextra
		            FAI_Casting[bossid][CAST_PROGRESS] = FAI_Spells[spellid][CAST_TIME] - FAI_Casting[bossid][CAST_PROGRESS];
		        }
		    }
	    }
		return 1;
	}
	return 0;
}
stock bool:FAI_GetSpellCastTimeInverted(spellid) {
	if(FAI_IsValidSpell(spellid)) {
		return FAI_Spells[spellid][CAST_TIME_INVERTED];
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
stock FAI_SetSpellCastTimeInverted(spellid, bool:inverted, bool:invertProgressMade = false) {
	if(FAI_IsValidSpell(spellid)) {
	    //Don't inv if already inv and vice versa
	    new bool:oldInverted = FAI_Spells[spellid][CAST_TIME_INVERTED];
		FAI_Spells[spellid][CAST_TIME_INVERTED] = inverted;
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		    if(FAI_IsValidBoss(bossid) && (FAI_IsBossCastingSpell(bossid, spellid) || FAI_IsBossCastBarExtraForSpell(bossid, spellid))) {
    			FAI_UpdateBossCastDisplay(bossid);
		        if(invertProgressMade && FAI_IsBossCastingSpell(bossid, spellid) && oldInverted != inverted) { //Only invert when casting, not when showextra
		            FAI_Casting[bossid][CAST_PROGRESS] = FAI_Spells[spellid][CAST_TIME] - FAI_Casting[bossid][CAST_PROGRESS];
		        }
		    }
	    }
		return 1;
	}
	return 0;
}
stock bool:FAI_GetSpellCanMove(spellid) {
	if(FAI_IsValidSpell(spellid)) {
		return FAI_Spells[spellid][CAN_MOVE];
	}
	return false;
}
stock FAI_SetSpellCanMove(spellid, bool:canMove) {
	if(FAI_IsValidSpell(spellid)) {
		FAI_Spells[spellid][CAN_MOVE] = canMove;
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		    if(FAI_IsValidBoss(bossid) && (FAI_IsBossCastingSpell(bossid, spellid) || FAI_IsBossCastBarExtraForSpell(bossid, spellid)) && FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
		      	FAI_BossAttackTarget(bossid, FAI_Bosses[bossid][TARGET]);
		    }
	    }
		return 1;
	}
	return 0;
}
stock bool:FAI_GetSpellCanAttack(spellid) {
	if(FAI_IsValidSpell(spellid)) {
		return FAI_Spells[spellid][CAN_ATTACK];
	}
	return false;
}
stock FAI_SetSpellCanAttack(spellid, bool:canAttack) {
	if(FAI_IsValidSpell(spellid)) {
		FAI_Spells[spellid][CAN_ATTACK] = canAttack;
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		    if(FAI_IsValidBoss(bossid) && (FAI_IsBossCastingSpell(bossid, spellid) || FAI_IsBossCastBarExtraForSpell(bossid, spellid)) && FAI_Bosses[bossid][TARGET] != INVALID_PLAYER_ID) {
		      	FAI_BossAttackTarget(bossid, FAI_Bosses[bossid][TARGET]);
		    }
	    }
		return 1;
	}
	return 0;
}
stock FAI_GetSpellInfo(spellid, info[], len) {
	if(FAI_IsValidSpell(spellid)) {
	    return FAI_strcpy(info, FAI_Spells[spellid][INFO], len);
	}
	return -1;
}
stock FAI_SetSpellInfo(spellid, info[]) {
	if(FAI_IsValidSpell(spellid)) {
		//If the user didn't provide info, construct info based on other settings
		if(!FAI_isnull(info) && !strcmp(info, FAI_INVALID_STRING, true)) {
			new string[FAI_MAX_SPELL_INFO + 1];
			new amountString[21 + 8 + 1];
			format(amountString, sizeof(amountString), "Amount %s.", FAI_DisplayReadableFloat(FAI_Spells[spellid][AMOUNT], 2, 0));
			new castTimeString[21 + 7 + 1];
			if(FAI_Spells[spellid][CAST_TIME] != 0) {
				if(float(FAI_Spells[spellid][CAST_TIME]) / 1000 / 60 >= 1) {
					format(castTimeString, sizeof(castTimeString), "%s minute", FAI_DisplayReadableFloat(float(FAI_Spells[spellid][CAST_TIME]) / 1000 / 60, 2, 0));
				} else {
					format(castTimeString, sizeof(castTimeString), "%s second", FAI_DisplayReadableFloat(float(FAI_Spells[spellid][CAST_TIME]) / 1000, 2, 0));
				}
			} else {
				FAI_strcpy(castTimeString, "Instant");
			}
			format(string, sizeof(string), "%s %s cast.", amountString, castTimeString);
		    FAI_strcpy(FAI_Spells[spellid][INFO], string, FAI_MAX_SPELL_INFO + 1);
		}
		//If the user did provide info, use that one
		else {
		    FAI_strcpy(FAI_Spells[spellid][INFO], info, FAI_MAX_SPELL_INFO + 1);
		}
		return 1;
	}
	return 0;
}
stock FAI_SpellToString(spellid, string[], len, bool:allowDefaultColors = true) {
	if(FAI_IsValidSpell(spellid)) {
	    if(allowDefaultColors) {
	    	format(string, len, "{%06x}%s: {%06x}%s", 0xffffffff >>> 8, FAI_Spells[spellid][NAME], 0xffd517ff >>> 8, FAI_Spells[spellid][INFO]);
	    } else {
	    	format(string, len, "%s: %s", FAI_Spells[spellid][NAME], FAI_Spells[spellid][INFO]);
	    }
		return strlen(string);
	}
	return -1;
}

//Casting
stock FAI_StopAllBossesCasting() {
	for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		FAI_StopBossCasting(bossid);
	}
	return 1;
}
stock FAI_StopBossCasting(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		return FAI_StopBossCastingSpell(bossid, FAI_Casting[bossid][SPELLID]);
    }
    return 0;
}
stock FAI_StopAllBossesCastingSpell(spellid) {
	if(FAI_IsValidSpell(spellid)) {
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
			FAI_StopBossCastingSpell(bossid, spellid);
		}
		return 1;
	}
	return 0;
}
static FAI_InitAllBossesCasting() {
	for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		FAI_InitBossCasting(bossid);
	}
}
static FAI_InitBossCasting(bossid) {
	//Don't use FAI_IsValidBoss(bossid)
	if(bossid >= 0 && bossid < FAI_MAX_BOSSES) {
	    FAI_Casting[bossid][SPELLID] = FAI_INVALID_SPELL_ID;
	    FAI_Casting[bossid][CAST_PROGRESS] = FAI_INVALID_CAST_PROGRESS;
		FAI_Casting[bossid][TARGETID] = INVALID_PLAYER_ID;
	}
}
forward bool:FAI_IsBossCasting(bossid); //Silence 'used before declaration' warning
stock bool:FAI_IsBossCasting(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		new spellid = FAI_Casting[bossid][SPELLID];
		if(FAI_IsValidSpell(spellid) && FAI_Spells[spellid][CAST_TIME] > FAI_Casting[bossid][CAST_PROGRESS]) {
	    	return true;
	    }
	}
	return false;
}
forward bool:FAI_IsBossCastingSpell(bossid, spellid); //Silence used before definition warning
stock bool:FAI_IsBossCastingSpell(bossid, spellid) {
	//FAI_IsValidBoss & FAI_IsValidSpell in FAI_IsBossCasting
	return FAI_IsBossCasting(bossid) && spellid == FAI_Casting[bossid][SPELLID];
}
forward bool:FAI_IsBossCastBarExtra(bossid); //Silence used before definition warning
stock bool:FAI_IsBossCastBarExtra(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		new spellid = FAI_Casting[bossid][SPELLID];
		if(FAI_IsValidSpell(spellid) && FAI_Casting[bossid][CAST_PROGRESS] >= FAI_Spells[spellid][CAST_TIME]) {
			return true;
		}
	}
	return false;
}
forward bool:FAI_IsBossCastBarExtraForSpell(bossid, spellid); //Silence used before definition warning
stock bool:FAI_IsBossCastBarExtraForSpell(bossid, spellid) {
	//FAI_IsValidBoss & FAI_IsValidSpell in FAI_IsBossCastBarExtra
	return FAI_IsBossCastBarExtra(bossid) && spellid == FAI_Casting[bossid][SPELLID];
}
stock FAI_StopBossCastingSpell(bossid, spellid) {
	if(FAI_IsValidBoss(bossid) && FAI_IsValidSpell(spellid) && FAI_IsBossCastingSpell(bossid, spellid)) {
	    FAI_BossCastProgressInComplete(bossid, spellid);
	    FAI_InitBossCasting(bossid);
	    return 1;
	}
	return 0;
}
static FAI_BossCastProgressInComplete(bossid, spellid) {
	if(FAI_IsValidBoss(bossid) && FAI_IsValidSpell(spellid)) {
        if(FAI_IsBossCastingSpell(bossid, spellid)) { //Only call the end of the incomplete cast if CastProgress has actually not reached CastTime
			CallRemoteFunction("FAI_OnBossStopCasting", "ddd", bossid, spellid, FAI_Casting[bossid][TARGETID], false);
		}
	}
}
static FAI_BossCastProgressComplete(bossid, spellid) {
	if(FAI_IsValidBoss(bossid) && FAI_IsValidSpell(spellid)) {
        if(FAI_Casting[bossid][CAST_PROGRESS] == FAI_Spells[spellid][CAST_TIME]) { //Only call the end of the complete cast if CastProgress has actually reached CastTime
			CallRemoteFunction("FAI_OnBossStopCasting", "ddd", bossid, spellid, FAI_Casting[bossid][TARGETID], true);
		}
	}
}
stock FAI_StartBossCastingSpell(bossid, spellid, targetid = INVALID_PLAYER_ID) {
	//Don't replace if casting already, do replace if showExtra
	if(FAI_IsValidBoss(bossid) && FAI_IsValidSpell(spellid) && FCNPC_IsSpawned(FAI_Bosses[bossid][NPCID]) && !FCNPC_IsDead(FAI_Bosses[bossid][NPCID]) && (IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID) && !FAI_IsBossCasting(bossid)) {
        if(FAI_IsBossCastBarExtra(bossid)) {
    		FAI_InitBossCasting(bossid);
        }
		FAI_Casting[bossid][SPELLID] = spellid;
		FAI_Casting[bossid][CAST_PROGRESS] = 0;
		FAI_Casting[bossid][TARGETID] = targetid;
		CallRemoteFunction("FAI_OnBossStartCasting", "ddd", bossid, spellid, targetid);
		 //Immediately end cast if instant
		if(FAI_Spells[spellid][CAST_TIME] == 0) {
		    FAI_BossCastProgressComplete(bossid, spellid);
    		FAI_InitBossCasting(bossid);
		}
    	return 1;
	}
	return 0;
}
stock FAI_GetBossCastingSpell(bossid) {
	//Don't return anything if showExtra is true, because the boss isn't casting anymore even though the variable is still set to allow for the showExtra functionality
	if(FAI_IsValidBoss(bossid) && FAI_IsBossCasting(bossid)) {
	    return FAI_Casting[bossid][SPELLID];
	}
	return -1;
}
/*
Instant:
- Will never happen because, onstopcast gets called immediately after onstartcast
ShowExtra:
- Will never happen, because FAI_IsBossCasting is not true with showExtra. Use FAI_StartBossCastingSpell instead.
Keeppercent:
- casttime 500, progress 250 => casttime 200, progress becomes 100
- casttime 500, progress 250 => casttime 600, progress becomes 300
Dont keeppercent:
- casttime 500, progress 250 => casttime 200, progress becomes 200 which is casttime, execute complete stopcast immediately (not init cast as well to allow for showExtra, except if showExtra is invalid)
- casttime 500, progress 250 => casttime 600, progress stays 250
*/
stock FAI_SetBossCastingSpell(bossid, spellid, bool:keepCastPercent = false) {
	if(FAI_IsValidBoss(bossid) && FAI_IsValidSpell(spellid) && FAI_IsBossCasting(bossid) && FCNPC_IsSpawned(FAI_Bosses[bossid][NPCID]) && !FCNPC_IsDead(FAI_Bosses[bossid][NPCID])) {
		new oldCastTime = FAI_Spells[FAI_Casting[bossid][SPELLID]][CAST_TIME];
		new newCastTime = FAI_Spells[spellid][CAST_TIME];
		FAI_Casting[bossid][SPELLID] = spellid; //Must be called before
		if(keepCastPercent) {
			FAI_Casting[bossid][CAST_PROGRESS] = floatround(float(FAI_Casting[bossid][CAST_PROGRESS]) / oldCastTime * newCastTime, floatround_floor); //floatround_floor, because (say 400.9) the next progress integer (401) wasn't reached yet
	    } else {
			if(FAI_Casting[bossid][CAST_PROGRESS] > newCastTime) {
				FAI_Casting[bossid][CAST_PROGRESS] = newCastTime; //Must be set before FAI_BossCastProgressComplete is called, because that function checks for CAST_PROGRESS == CAST_TIME
				FAI_BossCastProgressComplete(bossid, spellid);
				#if FAI_CAST_BAR_SHOW_EXTRA_TIME <= 0
					FAI_InitBossCasting(bossid);
				#endif
			}
	    }
		//Don't update castbar with instants or if no show extra
		if(newCastTime > 0) {
			#if FAI_CAST_BAR_SHOW_EXTRA_TIME > 0
				FAI_UpdateBossCastDisplay(bossid);
			#endif
		}
	    return 1;
	}
	return 0;
}
stock FAI_GetBossCastingProgress(bossid) {
	//Don't return anything if showExtra is true, because the boss isn't casting anymore even though the variable is still set to allow for the showExtra functionality
	//If the showextra progress is needed, use FAI_GetBossCastingExtraProgress
	if(FAI_IsValidBoss(bossid) && FAI_IsBossCasting(bossid)) {
	    return FAI_Casting[bossid][CAST_PROGRESS];
	}
	return -1;
}
/*
Instant:
- Will never happen because, onstopcast gets called immediately after onstartcast
ShowExtra:
- Will never happen, because FAI_IsBossCasting is not true with showExtra. Use FAI_SetBossCastingExtraProgress instead.
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
stock FAI_SetBossCastingProgress(bossid, progress) {
	if(FAI_IsValidBoss(bossid) && FAI_IsBossCasting(bossid) && FCNPC_IsSpawned(FAI_Bosses[bossid][NPCID]) && !FCNPC_IsDead(FAI_Bosses[bossid][NPCID])) {
	    if(progress < 0) {
	        progress = 0;
	    }
		new spellid = FAI_Casting[bossid][SPELLID];
		if(progress >= FAI_Spells[spellid][CAST_TIME]) {
			FAI_Casting[bossid][CAST_PROGRESS] = FAI_Spells[spellid][CAST_TIME]; //Must be set before FAI_BossCastProgressComplete is called, because that function checks for CAST_PROGRESS == CAST_TIME
			FAI_BossCastProgressComplete(bossid, spellid); //Finish casting, but don't hide the castbar, to allow for showExtra
			#if FAI_CAST_BAR_SHOW_EXTRA_TIME <= 0 //Do hide castbar if showExtra is invalid
				FAI_InitBossCasting(bossid);
			#endif
		} else {
			FAI_Casting[bossid][CAST_PROGRESS] = progress;
		}
		//Don't update castbar with instants or if no show extra
		if(FAI_Spells[spellid][CAST_TIME] > 0) {
			#if FAI_CAST_BAR_SHOW_EXTRA_TIME > 0
				FAI_UpdateBossCastDisplay(bossid);
			#endif
		}
	    return 1;
	}
	return 0;
}
stock FAI_GetBossCastingTarget(bossid) {
	//Don't return anything if showExtra is true, because the boss isn't casting anymore even though the variable is still set to allow for the showExtra functionality
	if(FAI_IsValidBoss(bossid) && FAI_IsBossCasting(bossid)) {
	    return FAI_Casting[bossid][TARGETID];
	}
	return -1;
}
//The casting target doesn't have to be valid
//The casting target doesn't have to be streamed in
//The casting target doesn't have to be in aggro range
stock FAI_SetBossCastingTarget(bossid, targetid) {
	if(FAI_IsValidBoss(bossid) && FAI_IsBossCasting(bossid) && FCNPC_IsSpawned(FAI_Bosses[bossid][NPCID]) && !FCNPC_IsDead(FAI_Bosses[bossid][NPCID]) && (IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)) {
		FAI_Casting[bossid][TARGETID] = targetid;
		return 1;
	}
	return 0;
}
stock FAI_GetBossCastingExtraProgress(bossid) {
	//Don't return anything if casting is true, because the spell isn't yet in showextra
	if(FAI_IsValidBoss(bossid) && FAI_IsBossCastBarExtra(bossid)) {
	    return FAI_Casting[bossid][CAST_PROGRESS] - FAI_Spells[FAI_Casting[bossid][SPELLID]][CAST_TIME];
	}
	return -1;
}
/*
Instant:
- Will never happen because, onstopcast gets called immediately after onstartcast
-Casting:
- Will never happen, because FAI_IsBossCastBarExtra is not true when the boss is casting. Use FAI_SetBossCastingProgress instead.
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
stock FAI_SetBossCastingExtraProgress(bossid, progress) {
	if(FAI_IsValidBoss(bossid) && FAI_IsBossCastBarExtra(bossid) && FCNPC_IsSpawned(FAI_Bosses[bossid][NPCID]) && !FCNPC_IsDead(FAI_Bosses[bossid][NPCID]) ) {
		if(progress < 0) {
	        progress = 0;
	    }
		//We don't need to update the castbar display, because showextra is not shown on the castbar
	    new spellid = FAI_Casting[bossid][SPELLID];
		if(progress + FAI_Spells[spellid][CAST_TIME] >= FAI_Spells[spellid][CAST_TIME] + FAI_CAST_BAR_SHOW_EXTRA_TIME) {
			FAI_Casting[bossid][CAST_PROGRESS] = FAI_Spells[spellid][CAST_TIME] + FAI_CAST_BAR_SHOW_EXTRA_TIME;
			FAI_InitBossCasting(bossid);
		} else {
			FAI_Casting[bossid][CAST_PROGRESS] = progress + FAI_Spells[spellid][CAST_TIME];
		}
	    return 1;
	}
	return 0;
}