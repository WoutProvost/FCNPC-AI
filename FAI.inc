/*
 * License:
 * See LICENSE.md included in the release download, or at https://github.com/WoutProvost/FCNPC-A.I./blob/master/LICENSE.md if not included.

 * Credits:
 * See CREDITS.md included in the release download, or at https://github.com/WoutProvost/FCNPC-A.I./blob/master/CREDITS.md if not included.

 * Changelog:
 * See CHANGELOG.md included in the release download, or at https://github.com/WoutProvost/FCNPC-A.I./blob/master/CHANGELOG.md if not included.

 * Documentation:
 * Every function, callback or define is extensively explained at https://github.com/WoutProvost/FCNPC-A.I./wiki and its various subsections.
*/

#if defined _FAI_included
	#endinput
#endif
#define _FAI_included
#pragma library FAI

#if !defined _FCNPC_included
	#error Include FCNPC before this include
#endif
 
//========================================FAKE NATIVES========================================
/*
//NPCs
native bool:FAI_IsValidNPC(npcid);
native bool:FAI_IsValidNPCForPlayer(npcid, playerid);
native FCNPC_SetHealth(npcid, Float:health, Float:maxHealth = 100.0);
native Float:FCNPC_GetHealth(npcid, &Float:maxHealth = 100.0);
native FCNPC_SetGoToInfo(npcid, type = FCNPC_MOVE_TYPE_AUTO, Float:speed = FCNPC_MOVE_SPEED_AUTO, bool:useMapAndreas = false, Float:radius = 0.0, bool:setAngle = true, Float:dist_offset = 0.0, Float:dist_check = 1.5, stopdelay = 250);
native FCNPC_GetGoToInfo(npcid, &type, &Float:speed, &bool:useMapAndreas, &Float:radius, &bool:setAngle, &Float:dist_offset, &Float:dist_check, &stopdelay);
native FCNPC_SetAimAtInfo(npcid, Float:range = 20.0, bool:shoot = false, shoot_delay = -1, bool:setAngle = true, Float:offset_x = 0.0, Float:offset_y = 0.0, Float:offset_z = 0.0, Float:offset_from_x = 0.0, Float:offset_from_y = 0.0, Float:offset_from_z = 0.0);
native FCNPC_GetAimAtInfo(npcid, &Float:range, &bool:shoot, &shoot_delay, &bool:setAngle, &Float:offset_x, &Float:offset_y, &Float:offset_z, &Float:offset_from_x, &Float:offset_from_y, &Float:offset_from_z);
native FCNPC_SetMeleeAttackInfo(npcid, Float:range = 0.5, delay = -1, bool:useFightStyle = false);
native FCNPC_GetMeleeAttackInfo(npcid, &Float:range, &delay, &bool:useFightStyle);
native FCNPC_SetTarget(npcid, playerid);
native FCNPC_GetTarget(npcid);
native FCNPC_SetBehaviour(npcid, playerid, behaviour);
native FCNPC_GetBehaviour(npcid, playerid);
native FCNPC_SetAggroRange(npcid, playerid, Float:range);
native FCNPC_GetAggroRange(npcid, playerid, &Float:range);
native FCNPC_SetThreat(npcid, playerid, Float:threat);
native FCNPC_GetThreat(npcid, playerid, &Float:threat);
*/

//========================================CALLBACKS========================================
//NPCs
forward FCNPC_OnEncounterStart(npcid, firstTarget, reason);
forward FCNPC_OnEncounterStop(npcid, lastTarget, reason);
forward FCNPC_OnPlayerGetAggro(playerid, npcid);
forward FCNPC_OnPlayerLoseAggro(playerid, npcid);

//========================================DEFINES========================================
//General
#define FAI_VERSION							"2.0"
#if !defined INVALID_TIMER_ID
	#define INVALID_TIMER_ID				-1
#endif

//NPCs
enum {
	FCNPC_EAR_DAMAGE,
	FCNPC_EAR_AGGRO,
	FCNPC_EAR_EXPLICIT_TARGET_SET
}
enum {
	FCNPC_EOR_NPC_DEATH,
	FCNPC_EOR_NPC_RESPAWN,
	FCNPC_EOR_NPC_DESTROY,
	FCNPC_EOR_NO_VALID_NEW_TARGET,
	FCNPC_EOR_EXPLICIT_TARGET_SET
}
enum {
	FCNPC_BEHAVIOUR_FRIENDLY,
	FCNPC_BEHAVIOUR_NEUTRAL,
	FCNPC_BEHAVIOUR_UNFRIENDLY
}

//========================================VARIABLES========================================
//Players
static FAI_PauseTickCount[MAX_PLAYERS] = {0, ...};
static bool:FAI_PlayerPaused[MAX_PLAYERS] = {false, ...};
static FAI_PauseTimer = INVALID_TIMER_ID;

//NPCs
enum FAI_ENUM_NPC {
	//Can't be set by the user
	bool:VALID,
	//Can be set by the user
	Float:HEALTH, //Can be changed automatically by the script
	Float:MAX_HEALTH,
	GO_TO_TYPE,
	Float:GO_TO_SPEED,
	bool:GO_TO_USE_MAP_ANDREAS,
	Float:GO_TO_RADIUS,
	bool:GO_TO_SET_ANGLE,
	Float:GO_TO_DIST_OFFSET,
	Float:GO_TO_DIST_CHECK,
	GO_TO_STOP_DELAY,
	Float:AIM_AT_RANGE,
	bool:AIM_AT_SHOOT,
	AIM_AT_SHOOT_DELAY,
	bool:AIM_AT_SET_ANGLE,
	Float:AIM_AT_OFFSET_X,
	Float:AIM_AT_OFFSET_Y,
	Float:AIM_AT_OFFSET_Z,
	Float:AIM_AT_OFFSET_FROM_X,
	Float:AIM_AT_OFFSET_FROM_Y,
	Float:AIM_AT_OFFSET_FROM_Z,
	Float:MELEE_ATTACK_RANGE,
	MELEE_ATTACK_DELAY,
	bool:MELEE_ATTACK_USE_FIGHT_STYLE,
	TARGET, //Can be changed automatically by the script
	BEHAVIOUR[MAX_PLAYERS],
	Float:AGGRO_RANGE[MAX_PLAYERS],
	Float:THREAT[MAX_PLAYERS] //Can be changed automatically by the script
}
static FAI_NPCs[MAX_PLAYERS][FAI_ENUM_NPC];

//========================================INTERNAL FUNCTIONS========================================
//General
static FAI_ScriptInit() {
	//Players
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
		FAI_PauseTickCount[playerid] = GetTickCount();
		FAI_PlayerPaused[playerid] = false;
	}
	FAI_PauseTimer = SetTimer("FAI_CheckPlayersPausedState", 1000, 1);

	//NPCs
	for(new npcid = 0; npcid < MAX_PLAYERS; npcid++) {
		FAI_ResetNPC(npcid);
	}

	//General
	printf("---------------------");
	printf("  FCNPC A.I. loaded  ");
	printf("- Version: %s     ", FAI_VERSION);
	printf("- Author: Freaksken  ");
	printf("---------------------");
}
static FAI_ScriptExit() {
	//Players
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
		FAI_PauseTickCount[playerid] = 0;
		FAI_PlayerPaused[playerid] = false;
	}
	KillTimer(FAI_PauseTimer);
	FAI_PauseTimer = INVALID_TIMER_ID;

	//NPCs
	/*for(new npcid = 0; npcid < MAX_PLAYERS; npcid++) { //Automatically destroy NPCs on script exit
		if(FAI_IsValidNPC(npcid)) {
			FCNPC_Destroy(npcid);
		}
	}*/
}

//Players
forward FAI_CheckPlayersPausedState();
public FAI_CheckPlayersPausedState() {
	for(new playerid = 0, highestPlayerid = GetPlayerPoolSize(); playerid <= highestPlayerid; playerid++) {
		new playerState = GetPlayerState(playerid);
		if(IsPlayerConnected(playerid) && playerState != PLAYER_STATE_WASTED && playerState != PLAYER_STATE_NONE) { //OnPlayerUpdate isn't called when the player is initializing, dead or in class selection
			new bool:playerInGame = true;
			if(FAI_GetTickCountDiff(FAI_PauseTickCount[playerid], GetTickCount()) > 2000) {
				playerInGame = false;
			}
			if(!playerInGame && !FAI_PlayerPaused[playerid]) {
				FAI_PlayerPaused[playerid] = true;
			} else if(playerInGame && FAI_PlayerPaused[playerid]) {
				FAI_PlayerPaused[playerid] = false;
			}
		}
	}
}
static FAI_GetTickCountDiff(oldInteger, newInteger) { //Fix for the GetTickCount integer overflow problem when the server is run for 24+ days
	if(oldInteger < 0 && newInteger >= 0) {
		return newInteger - oldInteger;
	} else if(oldInteger >= 0 && newInteger < 0 || oldInteger > newInteger) {
		return (cellmax - oldInteger + 1) - (cellmin - newInteger);
	}
	return newInteger - oldInteger;
}

//NPCs
static FAI_ResetNPC(npcid) {
	//Don't use FAI_IsValidNPC
	FAI_NPCs[npcid][VALID] = false;
	FAI_NPCs[npcid][HEALTH] = 100.0;
	FAI_NPCs[npcid][MAX_HEALTH] = 100.0;
	FAI_NPCs[npcid][GO_TO_TYPE] = FCNPC_MOVE_TYPE_AUTO;
	FAI_NPCs[npcid][GO_TO_SPEED] = FCNPC_MOVE_SPEED_AUTO;
	FAI_NPCs[npcid][GO_TO_USE_MAP_ANDREAS] = false;
	FAI_NPCs[npcid][GO_TO_RADIUS] = 0.0;
	FAI_NPCs[npcid][GO_TO_SET_ANGLE] = true;
	FAI_NPCs[npcid][GO_TO_DIST_OFFSET] = 0.0;
	FAI_NPCs[npcid][GO_TO_DIST_CHECK] = 1.5;
	FAI_NPCs[npcid][GO_TO_STOP_DELAY] = 250;
	FAI_NPCs[npcid][AIM_AT_RANGE] = 20.0;
	FAI_NPCs[npcid][AIM_AT_SHOOT] = false;
	FAI_NPCs[npcid][AIM_AT_SHOOT_DELAY] = -1;
	FAI_NPCs[npcid][AIM_AT_SET_ANGLE] = true;
	FAI_NPCs[npcid][AIM_AT_OFFSET_X] = 0.0;
	FAI_NPCs[npcid][AIM_AT_OFFSET_Y] = 0.0;
	FAI_NPCs[npcid][AIM_AT_OFFSET_Z] = 0.0;
	FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_X] = 0.0;
	FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_Y] = 0.0;
	FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_Z] = 0.0;
	FAI_NPCs[npcid][MELEE_ATTACK_RANGE] = 0.5;
	FAI_NPCs[npcid][MELEE_ATTACK_DELAY] = -1;
	FAI_NPCs[npcid][MELEE_ATTACK_USE_FIGHT_STYLE] = false;
	FAI_NPCs[npcid][TARGET] = INVALID_PLAYER_ID;
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
		FAI_NPCs[npcid][BEHAVIOUR][playerid] = FCNPC_BEHAVIOUR_FRIENDLY;
		FAI_NPCs[npcid][AGGRO_RANGE][playerid] = 0.0;
		FAI_NPCs[npcid][THREAT][playerid] = 0.0;
	}
}
static bool:FAI_HasNPCMeleeWeapon(npcid) {
	if(FAI_IsValidNPC(npcid)) {
		new weaponid = FCNPC_GetWeapon(npcid);
		if(weaponid >= 0 && weaponid <= 15) {
			return true;
		}
	}
	return false;
}
static FAI_UpdateNPCAttackMove(npcid) {
	if(FAI_IsValidNPCForPlayer(npcid, FAI_NPCs[npcid][TARGET])) {
		new Float:x, Float:y, Float:z;
		FCNPC_GetPosition(npcid, x, y, z);
		new Float:attackRange = FAI_NPCs[npcid][AIM_AT_RANGE];
		if(FAI_HasNPCMeleeWeapon(npcid)) {
			attackRange = FAI_NPCs[npcid][MELEE_ATTACK_RANGE];
		}
		new bool:canMove = true;
		new bool:canAttack = true;
		//Target in attack range, attack if allowed, otherwise move if allowed, otherwise stop attacking
		if(attackRange < 0.0 || GetPlayerDistanceFromPoint(FAI_NPCs[npcid][TARGET], x, y, z) <= attackRange) {
			if(canAttack) {
				FAI_ChangeNPCAttack(npcid);
			} else {
				if(canMove) {
					FAI_ChangeNPCMove(npcid);
				} else {
					FAI_ChangeNPCStopAttackMove(npcid);
				}
			}
		}
		//Target not in attack range, move to target if allowed, otherwise attack if allowed, otherwise stop attacking
		else {
			if(canMove) {
				FAI_ChangeNPCMove(npcid);
			} else {
				if(canAttack) {
					FAI_ChangeNPCAttack(npcid);
				} else {
					FAI_ChangeNPCStopAttackMove(npcid);
				}
			}
		}
	}
}
static FAI_ChangeNPCAttack(npcid) {
	if(FCNPC_IsMoving(npcid)) {
		FCNPC_Stop(npcid);
	}
	if(!FAI_HasNPCMeleeWeapon(npcid)) {
		//In case the npc switched weapons
		if(FCNPC_IsAttacking(npcid)) {
			FCNPC_StopAttack(npcid);
		}
		//So we don't aim again when we were already aiming at that same player. If aiming at another player, this will execute
		if(!FCNPC_IsAimingAtPlayer(npcid, FAI_NPCs[npcid][TARGET]) || (FCNPC_IsShooting(npcid) && !FAI_NPCs[npcid][AIM_AT_SHOOT]) || (!FCNPC_IsShooting(npcid) && FAI_NPCs[npcid][AIM_AT_SHOOT])) {
			FCNPC_AimAtPlayer(npcid, FAI_NPCs[npcid][TARGET], FAI_NPCs[npcid][AIM_AT_SHOOT], FAI_NPCs[npcid][AIM_AT_SHOOT_DELAY], FAI_NPCs[npcid][AIM_AT_SET_ANGLE],
			FAI_NPCs[npcid][AIM_AT_OFFSET_X], FAI_NPCs[npcid][AIM_AT_OFFSET_Y], FAI_NPCs[npcid][AIM_AT_OFFSET_Z], FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_X], FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_Y], FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_Z]);
		}
	} else {
		//In case the npc switched weapons
		if(FCNPC_IsAiming(npcid)) {
			FCNPC_StopAim(npcid);
		}
		//So we don't attack again when we were already attacking
		if(!FCNPC_IsAttacking(npcid)) {
			FCNPC_MeleeAttack(npcid, FAI_NPCs[npcid][MELEE_ATTACK_DELAY], FAI_NPCs[npcid][MELEE_ATTACK_USE_FIGHT_STYLE]);
		}
	}
}
static FAI_ChangeNPCMove(npcid) {
	if(FCNPC_IsAiming(npcid)) {
		FCNPC_StopAim(npcid);
	}
	if(FCNPC_IsAttacking(npcid)) {
		FCNPC_StopAttack(npcid);
	}
	//So we don't move again when we were already moving to that same player. If moving at another player, this will execute
	if(!FCNPC_IsMovingAtPlayer(npcid, FAI_NPCs[npcid][TARGET])) {
		FCNPC_GoToPlayer(npcid, FAI_NPCs[npcid][TARGET], FAI_NPCs[npcid][GO_TO_TYPE], FAI_NPCs[npcid][GO_TO_SPEED], FAI_NPCs[npcid][GO_TO_USE_MAP_ANDREAS], FAI_NPCs[npcid][GO_TO_RADIUS], FAI_NPCs[npcid][GO_TO_SET_ANGLE],
		FAI_NPCs[npcid][GO_TO_DIST_OFFSET], FAI_NPCs[npcid][GO_TO_DIST_CHECK], FAI_NPCs[npcid][GO_TO_STOP_DELAY]);
	}
}
static FAI_ChangeNPCStopAttackMove(npcid) {
	if(FCNPC_IsMoving(npcid)) {
		FCNPC_Stop(npcid);
	}
	if(FCNPC_IsAiming(npcid)) {
		FCNPC_StopAim(npcid);
	}
	if(FCNPC_IsAttacking(npcid)) {
		FCNPC_StopAttack(npcid);
	}
}
static FAI_UpdateNPCTarget(npcid) {
	new newtargetid = INVALID_PLAYER_ID;
	new reason = FCNPC_EAR_AGGRO;
	//When the encounter has been started, search for an overaggroing player
	if(FAI_NPCs[npcid][TARGET] != INVALID_PLAYER_ID) {
		new highestplayerid = FAI_GetHighestThreatPlayer(npcid);
		//For another player to become the target during the encounter, he must exceed 130% of the current valid target's threat (also accounted for divide by 0), or the current target must be invalid, or the behaviour for the current target is friendly
		if(highestplayerid != INVALID_PLAYER_ID && (FAI_NPCs[npcid][THREAT][FAI_NPCs[npcid][TARGET]] == 0.0 || FAI_NPCs[npcid][THREAT][highestplayerid] / FAI_NPCs[npcid][THREAT][FAI_NPCs[npcid][TARGET]] > 1.3
		|| !FAI_IsValidNPCForPlayer(npcid, FAI_NPCs[npcid][TARGET]) || FAI_NPCs[npcid][BEHAVIOUR][FAI_NPCs[npcid][TARGET]] == FCNPC_BEHAVIOUR_FRIENDLY)) {
			//Set target to player with highest threat
			newtargetid = highestplayerid;
			FAI_ChangeNPCTarget(npcid, newtargetid, reason);
		}
	}
	//When the encounter hasn't been started, or there is no overaggroing player
	if(newtargetid == INVALID_PLAYER_ID) {
		//When there is no target, or if the current target is invalid, or if the behaviour for the current target is friendly
		if(!FAI_IsValidNPCForPlayer(npcid, FAI_NPCs[npcid][TARGET]) || FAI_NPCs[npcid][BEHAVIOUR][FAI_NPCs[npcid][TARGET]] == FCNPC_BEHAVIOUR_FRIENDLY) {
			//Set target to closest player
			newtargetid = FAI_GetClosestPlayer(npcid);
			if(newtargetid == INVALID_PLAYER_ID) {
				reason = FCNPC_EOR_NO_VALID_NEW_TARGET;
			}
			//Don't do anything when the target doesn't change
			if(FAI_NPCs[npcid][TARGET] != newtargetid) {
				FAI_ChangeNPCTarget(npcid, newtargetid, reason);
			}
		}		
	}

	//Old code before threat implementation
	/*
	//Get new target when there is no target, or if the current target is invalid, or if the behaviour for the current target is friendly
	if(!FAI_IsValidNPCForPlayer(npcid, FAI_NPCs[npcid][TARGET]) || FAI_NPCs[npcid][BEHAVIOUR][FAI_NPCs[npcid][TARGET]] == FCNPC_BEHAVIOUR_FRIENDLY) {
		//Set target to closestPlayerid
		new newtargetid = FAI_GetClosestPlayer(npcid);
		new reason = FCNPC_EAR_AGGRO;
		if(newtargetid == INVALID_PLAYER_ID) {
			reason = FCNPC_EOR_NO_VALID_NEW_TARGET;
		}
		FAI_ChangeNPCTarget(npcid, newtargetid, reason);
	}
	*/
}
static FAI_ChangeNPCTarget(npcid, newtargetid, reason) {
	if(newtargetid == INVALID_PLAYER_ID || FAI_IsValidNPCForPlayer(npcid, newtargetid)) {
		new oldtargetid = FAI_NPCs[npcid][TARGET];
		if(oldtargetid != newtargetid) {
			if(oldtargetid != INVALID_PLAYER_ID) {
				CallRemoteFunction("FCNPC_OnPlayerLoseAggro", "dd", oldtargetid, npcid);
			}
			FAI_NPCs[npcid][TARGET] = newtargetid;
			if(newtargetid != INVALID_PLAYER_ID) {
				CallRemoteFunction("FCNPC_OnPlayerGetAggro", "dd", newtargetid, npcid);
				FAI_UpdateNPCAttackMove(npcid);
				if(oldtargetid == INVALID_PLAYER_ID) {
					CallRemoteFunction("FCNPC_OnEncounterStart", "ddd", npcid, newtargetid, reason);
				}
			} else {
				if(oldtargetid != INVALID_PLAYER_ID) {
					for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
						FAI_NPCs[npcid][THREAT][playerid] = 0.0;
					}
					FAI_ChangeNPCStopAttackMove(npcid);
					CallRemoteFunction("FCNPC_OnEncounterStop", "ddd", npcid, oldtargetid, reason);
				}
			}
			return 1;
		}
	}
	return 0;
}
static bool:FAI_IsPlayerInAggroRange(playerid, npcid) {
	if(FAI_IsValidNPCForPlayer(npcid, playerid)) {
		new Float:x, Float:y, Float:z;
		if(!IsPlayerNPC(playerid)) {
			GetPlayerPos(playerid, x, y, z);
		} else {
			FCNPC_GetPosition(playerid, x, y, z);
		}
		new Float:npcRange = GetPlayerDistanceFromPoint(npcid, x, y, z);
		if(FAI_NPCs[npcid][AGGRO_RANGE][playerid] < 0.0 || npcRange <= FAI_NPCs[npcid][AGGRO_RANGE][playerid]) {
			return true;
		}
	}
	return false;
}
static FAI_GetClosestPlayer(npcid) {
	new closestPlayer = INVALID_PLAYER_ID;
	new Float:closestPlayerRange = 0.0;
	for(new playerid = 0, highestPlayerid = GetPlayerPoolSize(); playerid <= highestPlayerid; playerid++) {
		//Only set target if the encounter has already started OR if the behaviour is unfriendly for that player
		if(FAI_IsValidNPCForPlayer(npcid, playerid) && ((FAI_NPCs[npcid][TARGET] != INVALID_PLAYER_ID && FAI_NPCs[npcid][BEHAVIOUR][playerid] != FCNPC_BEHAVIOUR_FRIENDLY)
		|| (FAI_NPCs[npcid][TARGET] == INVALID_PLAYER_ID && FAI_NPCs[npcid][BEHAVIOUR][playerid] == FCNPC_BEHAVIOUR_UNFRIENDLY))) {
			new Float:x, Float:y, Float:z;
			if(!IsPlayerNPC(playerid)) {
				GetPlayerPos(playerid, x, y, z);
			} else {
				FCNPC_GetPosition(playerid, x, y, z);
			}
			new Float:npcRange = GetPlayerDistanceFromPoint(npcid, x, y, z);
			if(FAI_IsPlayerInAggroRange(playerid, npcid) && (closestPlayer == INVALID_PLAYER_ID || npcRange < closestPlayerRange)) {
				closestPlayerRange = npcRange;
				closestPlayer = playerid;
			}
		}
	}
	return closestPlayer;
}
static FAI_GetHighestThreatPlayer(npcid) {
	new highestPlayer = INVALID_PLAYER_ID;
	new Float:highestPlayerThreat = 0.0;
	for(new playerid = 0, highestPlayerid = GetPlayerPoolSize(); playerid <= highestPlayerid; playerid++) {
		//Only set target if the player has any threat AND the behaviour is not friendly for that player
		if(FAI_IsValidNPCForPlayer(npcid, playerid) && FAI_NPCs[npcid][THREAT][playerid] > 0.0 && FAI_NPCs[npcid][BEHAVIOUR][playerid] != FCNPC_BEHAVIOUR_FRIENDLY) {
			//When there are multiple players with the same threat, the first ID will be used.
			if(highestPlayer == INVALID_PLAYER_ID || FAI_NPCs[npcid][THREAT][playerid] > highestPlayerThreat) {
				highestPlayerThreat = FAI_NPCs[npcid][THREAT][playerid];
				highestPlayer = playerid;
			}
		}
	}
	return highestPlayer;
}

//========================================HOOKED CALLBACKS========================================
#if defined FILTERSCRIPT
	public OnFilterScriptInit()
	{
		FAI_ScriptInit();
		new ret = 1;
		#if defined FAI_OnFilterScriptInit
			ret = FAI_OnFilterScriptInit();
		#endif
		return ret;
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
		new ret = 1;
		#if defined FAI_OnFilterScriptExit
			ret = FAI_OnFilterScriptExit();
		#endif
		FAI_ScriptExit(); //Call after
		return ret;
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
		FAI_ScriptInit();
		new ret = 1;
		#if defined FAI_OnGameModeInit
			ret = FAI_OnGameModeInit();
		#endif
		return ret;
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
		new ret = 1;
		#if defined FAI_OnGameModeExit
			ret = FAI_OnGameModeExit();
		#endif
		FAI_ScriptExit(); //Call after
		return ret;
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

public OnPlayerConnect(playerid) {
	//Players
	FAI_PauseTickCount[playerid] = GetTickCount();
	FAI_PlayerPaused[playerid] = false;
	new ret = 1;
	#if defined FAI_OnPlayerConnect
		ret = FAI_OnPlayerConnect(playerid);
	#endif
	return ret;
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

public OnPlayerUpdate(playerid)
{
	//Players
	FAI_PauseTickCount[playerid] = GetTickCount();
	new ret = 1;
	#if defined FAI_OnPlayerUpdate
		ret = FAI_OnPlayerUpdate(playerid);
	#endif
	return ret;
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

public FCNPC_OnDestroy(npcid) //This will both handle NPCs being destroyed programmatically and NPCs being disconnected (kicked/banned)
{
	//NPCs
	if(FAI_IsValidNPC(npcid)) {
		FAI_ChangeNPCTarget(npcid, INVALID_PLAYER_ID, FCNPC_EOR_NPC_DESTROY);
		FAI_ResetNPC(npcid);
	}
	new ret = 1;
	#if defined FAI_FCNPC_OnDestroy
		ret = FAI_FCNPC_OnDestroy(npcid);
	#endif
	return ret;
}
#if defined _ALS_FCNPC_OnDestroy
	#undef FCNPC_OnDestroy
#else
	#define _ALS_FCNPC_OnDestroy
#endif
#define FCNPC_OnDestroy FAI_FCNPC_OnDestroy
#if defined FAI_FCNPC_OnDestroy
	forward FAI_FCNPC_OnDestroy(npcid);
#endif

public FCNPC_OnUpdate(npcid)
{
	//NPCs
	if(FAI_IsValidNPC(npcid)) {
		FAI_UpdateNPCTarget(npcid);
		FAI_UpdateNPCAttackMove(npcid); //Call after setting target
		//Reset threat of recently invalid players
		for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we also need to reset recently disconnected players
			if(FAI_NPCs[npcid][THREAT][playerid] != 0.0 && !FAI_IsValidNPCForPlayer(npcid, playerid)) {
				FAI_NPCs[npcid][THREAT][playerid] = 0.0;
			}
		}
	}
	new ret = 1;
	#if defined FAI_FCNPC_OnUpdate
		ret = FAI_FCNPC_OnUpdate(npcid);
	#endif
	return ret;
}
#if defined _ALS_FCNPC_OnUpdate
	#undef FCNPC_OnUpdate
#else
	#define _ALS_FCNPC_OnUpdate
#endif
#define FCNPC_OnUpdate FAI_FCNPC_OnUpdate
#if defined FAI_FCNPC_OnUpdate
	forward FAI_FCNPC_OnUpdate(npcid);
#endif

public FCNPC_OnRespawn(npcid)
{
	if(FAI_IsValidNPC(npcid)) {
		if(FAI_NPCs[npcid][HEALTH] == 0.0) {
			FAI_NPCs[npcid][HEALTH] = FAI_NPCs[npcid][MAX_HEALTH];
		} else {
			FAI_ChangeNPCTarget(npcid, INVALID_PLAYER_ID, FCNPC_EOR_NPC_RESPAWN);
		}
	}
	new ret = 1;
	#if defined FAI_FCNPC_OnRespawn
		ret = FAI_FCNPC_OnRespawn(npcid);
	#endif
	return ret;
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

public FCNPC_OnDeath(npcid, killerid, weaponid)
{
	if(FAI_IsValidNPC(npcid)) {
		FAI_NPCs[npcid][HEALTH] = 0.0; //In case the NPC was killed programmatically, or by setting it's health to 0.0, or by getting damaged
		FAI_ChangeNPCTarget(npcid, INVALID_PLAYER_ID, FCNPC_EOR_NPC_DEATH);
	}
	new ret = 1;
	#if defined FAI_FCNPC_OnDeath
		ret = FAI_FCNPC_OnDeath(npcid, killerid, weaponid);
	#endif
	return ret;
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

public FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss) //Has to remain before hooking the health native!
{
	new ret = 1;
	#if defined FAI_FCNPC_OnTakeDamage
		ret = FAI_FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss); //The user can override the decision for the dammage to be afflicted to the NPC
	#endif
	if(ret == 1) { //Call after
		if(FAI_IsValidNPC(npcid)) {
			//2nd part of condition: if the npc is dead, this function can still be called before the OnDeath callback gets called (mainly when shot with fast guns: minigun, ...)
			//3rd part of condition: damage not inflicted by players (falling, ...)
			//4th part of condition: necessary to reject invalid damage done: the NPC is visible and thus damagable in other interiors		
			if(FCNPC_IsSpawned(npcid) && !FCNPC_IsDead(npcid) && (damagerid == INVALID_PLAYER_ID || FAI_IsValidNPCForPlayer(npcid, damagerid))) {
				//If the behaviour is neutral or unfriendly for that player
				if(damagerid == INVALID_PLAYER_ID || FAI_NPCs[npcid][BEHAVIOUR][damagerid] != FCNPC_BEHAVIOUR_FRIENDLY) { //Threat won't increase and target won't be set when the behaviour is friendly for that player
					//Increase threat according to damage done
					if(damagerid != INVALID_PLAYER_ID) {
						FAI_NPCs[npcid][THREAT][damagerid] += health_loss;
					}
					//If the encounter has been started
					if(FAI_NPCs[npcid][TARGET] != INVALID_PLAYER_ID) {
						FAI_UpdateNPCTarget(npcid);
					}
					//If the encounter has not been started
					else {
						//Set target to damagerid
						FAI_ChangeNPCTarget(npcid, damagerid, FCNPC_EAR_DAMAGE);
					}
				}
				//Dont damage below 0
				if(FAI_NPCs[npcid][HEALTH] > health_loss) {
					FAI_NPCs[npcid][HEALTH] -= health_loss;
					ret = 0; //Prevent the damage to be afflicted to the NPC
				}
				//Make the damager that makes the last shot, kill the NPC
				else {
					FCNPC_SetHealth(npcid, FAI_NPCs[npcid][HEALTH]); //Has to be the original function, not the hook! Therefore this code must be put before the native hook!
					ret = 1; //Allow the dammage to be afflicted to the NPC, which will kill him in this case
				}
			}
		}
	}
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

//========================================HOOKED FUNCTIONS========================================
//NPCs
stock FAI_FCNPC_Create(name[]) { //Using function hook instead of callback hook, so that this script only handles NPCs created in this FS/GM
	new npcid = FCNPC_Create(name);
	if(npcid != INVALID_PLAYER_ID) {
		FAI_NPCs[npcid][VALID] = true;
	}
	return npcid;
}
#if defined _ALS_FCNPC_Create
	#undef FCNPC_Create
#else
	#define _ALS_FCNPC_Create
#endif
#define FCNPC_Create FAI_FCNPC_Create

stock FAI_FCNPC_SetHealth(npcid, Float:health, Float:maxHealth = -1.0) { //Has to remain after hooking the damage callback!
	if(FAI_IsValidNPC(npcid)) {
		if(health < 0.0) {
			health = 0.0;
		}
		if(maxHealth < 0.0) { //Keep previous maxHealth when using a negative value
			maxHealth = FAI_NPCs[npcid][MAX_HEALTH];
		}
		if(health > maxHealth) {
			maxHealth = health;
		}
		if(health == 0.0) {
			if(!FCNPC_IsDead(npcid)) {
				FCNPC_Kill(npcid);
			}
		}
		FAI_NPCs[npcid][HEALTH] = health;
		FAI_NPCs[npcid][MAX_HEALTH] = maxHealth;
		return 1;
	}
	return FCNPC_SetHealth(npcid, health);
}
#if defined _ALS_FCNPC_SetHealth
	#undef FCNPC_SetHealth
#else
	#define _ALS_FCNPC_SetHealth
#endif
#define FCNPC_SetHealth FAI_FCNPC_SetHealth

stock Float:FAI_FCNPC_GetHealth(npcid, &Float:maxHealth = 100.0) { //Default value can be anything, since it will be ignored anyway
	if(FAI_IsValidNPC(npcid)) {
		maxHealth = FAI_NPCs[npcid][MAX_HEALTH];
		return FAI_NPCs[npcid][HEALTH];
	}
	return FCNPC_GetHealth(npcid);
}
#if defined _ALS_FCNPC_GetHealth
	#undef FCNPC_GetHealth
#else
	#define _ALS_FCNPC_GetHealth
#endif
#define FCNPC_GetHealth FAI_FCNPC_GetHealth

//========================================FUNCTIONS========================================
//NPCs
forward bool:FAI_IsValidNPC(npcid); //Silence warning 208
stock bool:FAI_IsValidNPC(npcid) { //Only handle NPCs created in this FS/GM
	return npcid >= 0 && npcid < MAX_PLAYERS && FAI_NPCs[npcid][VALID];
}
forward bool:FAI_IsValidNPCForPlayer(npcid, playerid); //Silence warning 208
stock bool:FAI_IsValidNPCForPlayer(npcid, playerid) {
	if(FAI_IsValidNPC(npcid) && IsPlayerConnected(playerid) && npcid != playerid && FCNPC_IsSpawned(npcid) && !FCNPC_IsDead(npcid)) {
		new npcInterior = FCNPC_GetInterior(npcid);
		new npcWorld = FCNPC_GetVirtualWorld(npcid);
		if(!IsPlayerNPC(playerid)) {
			new playerState = GetPlayerState(playerid);
			if(GetPlayerInterior(playerid) == npcInterior && GetPlayerVirtualWorld(playerid) == npcWorld && playerState != PLAYER_STATE_NONE && playerState != PLAYER_STATE_WASTED
			&& playerState != PLAYER_STATE_SPAWNED && playerState != PLAYER_STATE_SPECTATING && !FAI_PlayerPaused[playerid] && IsPlayerStreamedIn(npcid, playerid)) {
				return true;
			}
		} else {
			//FCNPC_IsValid ==> only support FCNPC bots, no standard bots because those can't react to anything anyway
			if(FCNPC_IsValid(playerid) && FCNPC_GetInterior(playerid) == npcInterior && FCNPC_GetVirtualWorld(playerid) == npcWorld && FCNPC_IsSpawned(playerid) && !FCNPC_IsDead(playerid)/* && IsPlayerStreamedIn(npcid, playerid)*/) {
				return true;
			}
		}
	}
	return false;
}
stock FCNPC_SetGoToInfo(npcid, type = FCNPC_MOVE_TYPE_AUTO, Float:speed = FCNPC_MOVE_SPEED_AUTO, bool:useMapAndreas = false, Float:radius = 0.0, bool:setAngle = true, Float:dist_offset = 0.0, Float:dist_check = 1.5, stopdelay = 250) {
	if(FAI_IsValidNPC(npcid)) {
		FAI_NPCs[npcid][GO_TO_TYPE] = type;
		FAI_NPCs[npcid][GO_TO_SPEED] = speed;
		FAI_NPCs[npcid][GO_TO_USE_MAP_ANDREAS] = useMapAndreas;
		FAI_NPCs[npcid][GO_TO_RADIUS] = radius;
		FAI_NPCs[npcid][GO_TO_SET_ANGLE] = setAngle;
		FAI_NPCs[npcid][GO_TO_DIST_OFFSET] = dist_offset;
		FAI_NPCs[npcid][GO_TO_DIST_CHECK] = dist_check;
		FAI_NPCs[npcid][GO_TO_STOP_DELAY] = stopdelay;
		FAI_UpdateNPCAttackMove(npcid);
		return 1;		
	}
	return 0;
}
stock FCNPC_GetGoToInfo(npcid, &type, &Float:speed, &bool:useMapAndreas, &Float:radius, &bool:setAngle, &Float:dist_offset, &Float:dist_check, &stopdelay) {
	if(FAI_IsValidNPC(npcid)) {
		type = FAI_NPCs[npcid][GO_TO_TYPE];
		speed = FAI_NPCs[npcid][GO_TO_SPEED];
		useMapAndreas = FAI_NPCs[npcid][GO_TO_USE_MAP_ANDREAS];
		radius = FAI_NPCs[npcid][GO_TO_RADIUS];
		setAngle = FAI_NPCs[npcid][GO_TO_SET_ANGLE];
		dist_offset = FAI_NPCs[npcid][GO_TO_DIST_OFFSET];
		dist_check = FAI_NPCs[npcid][GO_TO_DIST_CHECK];
		stopdelay = FAI_NPCs[npcid][GO_TO_STOP_DELAY];
		return 1;
	}
	return 0;
}
stock FCNPC_SetAimAtInfo(npcid, Float:range = 20.0, bool:shoot = false, shoot_delay = -1, bool:setAngle = true, Float:offset_x = 0.0, Float:offset_y = 0.0, Float:offset_z = 0.0, Float:offset_from_x = 0.0, Float:offset_from_y = 0.0, Float:offset_from_z = 0.0) {
	if(FAI_IsValidNPC(npcid)) {
		FAI_NPCs[npcid][AIM_AT_RANGE] = range; //Can be negative
		FAI_NPCs[npcid][AIM_AT_SHOOT] = shoot;
		FAI_NPCs[npcid][AIM_AT_SHOOT_DELAY] = shoot_delay;
		FAI_NPCs[npcid][AIM_AT_SET_ANGLE] = setAngle;
		FAI_NPCs[npcid][AIM_AT_OFFSET_X] = offset_x;
		FAI_NPCs[npcid][AIM_AT_OFFSET_Y] = offset_y;
		FAI_NPCs[npcid][AIM_AT_OFFSET_Z] = offset_z;
		FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_X] = offset_from_x;
		FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_Y] = offset_from_y;
		FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_Z] = offset_from_z;
		FAI_UpdateNPCAttackMove(npcid);
		return 1;		
	}
	return 0;
}
stock FCNPC_GetAimAtInfo(npcid, &Float:range, &bool:shoot, &shoot_delay, &bool:setAngle, &Float:offset_x, &Float:offset_y, &Float:offset_z, &Float:offset_from_x, &Float:offset_from_y, &Float:offset_from_z) {
	if(FAI_IsValidNPC(npcid)) {
		range = FAI_NPCs[npcid][AIM_AT_RANGE];
		shoot = FAI_NPCs[npcid][AIM_AT_SHOOT];
		shoot_delay = FAI_NPCs[npcid][AIM_AT_SHOOT_DELAY];
		setAngle = FAI_NPCs[npcid][AIM_AT_SET_ANGLE];
		offset_x = FAI_NPCs[npcid][AIM_AT_OFFSET_X];
		offset_y = FAI_NPCs[npcid][AIM_AT_OFFSET_Y];
		offset_z = FAI_NPCs[npcid][AIM_AT_OFFSET_Z];
		offset_from_x = FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_X];
		offset_from_y = FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_Y];
		offset_from_z = FAI_NPCs[npcid][AIM_AT_OFFSET_FROM_Z];
		return 1;
	}
	return 0;
}
stock FCNPC_SetMeleeAttackInfo(npcid, Float:range = 0.5, delay = -1, bool:useFightStyle = false) {
	if(FAI_IsValidNPC(npcid)) {
		FAI_NPCs[npcid][MELEE_ATTACK_RANGE] = range; //Can be negative
		FAI_NPCs[npcid][MELEE_ATTACK_DELAY] = delay;
		FAI_NPCs[npcid][MELEE_ATTACK_USE_FIGHT_STYLE] = useFightStyle;
		FAI_UpdateNPCAttackMove(npcid);
		return 1;		
	}
	return 0;
}
stock FCNPC_GetMeleeAttackInfo(npcid, &Float:range, &delay, &bool:useFightStyle) {
	if(FAI_IsValidNPC(npcid)) {
		range = FAI_NPCs[npcid][MELEE_ATTACK_RANGE];
		delay = FAI_NPCs[npcid][MELEE_ATTACK_DELAY];
		useFightStyle = FAI_NPCs[npcid][MELEE_ATTACK_USE_FIGHT_STYLE];
		return 1;
	}
	return 0;
}
stock FCNPC_SetTarget(npcid, playerid) {
	if(FAI_IsValidNPC(npcid)) {
		new reason = FCNPC_EAR_EXPLICIT_TARGET_SET;
		if(playerid == INVALID_PLAYER_ID) {
			reason = FCNPC_EOR_EXPLICIT_TARGET_SET;
		}
		return FAI_ChangeNPCTarget(npcid, playerid, reason); //Can be INVALID_PLAYER_ID
	}
	return 0;
}
stock FCNPC_GetTarget(npcid) {
	if(FAI_IsValidNPC(npcid)) {
		return FAI_NPCs[npcid][TARGET];
	}
	return -1;
}
stock FCNPC_SetBehaviour(npcid, playerid, behaviour) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		if(behaviour == FCNPC_BEHAVIOUR_FRIENDLY || behaviour == FCNPC_BEHAVIOUR_NEUTRAL || behaviour == FCNPC_BEHAVIOUR_UNFRIENDLY) {
			FAI_NPCs[npcid][BEHAVIOUR][playerid] = behaviour;
			FAI_UpdateNPCTarget(npcid);
			return 1;
		}
	}
	return 0;
}
stock FCNPC_GetBehaviour(npcid, playerid) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		return FAI_NPCs[npcid][BEHAVIOUR][playerid];
	}
	return -1;
}
stock FCNPC_SetAggroRange(npcid, playerid, Float:range) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		FAI_NPCs[npcid][AGGRO_RANGE][playerid] = range; //Can be negative
		FAI_UpdateNPCTarget(npcid);
		return 1;
	}
	return 0;
}
stock FCNPC_GetAggroRange(npcid, playerid, &Float:range) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		range = FAI_NPCs[npcid][AGGRO_RANGE][playerid];
		return 1;
	}
	return 0;
}
stock FCNPC_SetThreat(npcid, playerid, Float:threat) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		if(threat < 0.0) {
			threat = 0.0;
		}
		FAI_NPCs[npcid][THREAT][playerid] = threat; //Can't be negative
		FAI_UpdateNPCTarget(npcid);
		return 1;
	}
	return 0;
}
stock FCNPC_GetThreat(npcid, playerid, &Float:threat) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		threat = FAI_NPCs[npcid][THREAT][playerid];
		return 1;
	}
	return 0;
}