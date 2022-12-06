#if defined _FCNPC_AI_included
	#endinput
#endif
#define _FCNPC_AI_included

#include <a_samp>
#include <FCNPC>
#include <util>

// ========================================FAKE NATIVES========================================
/*
// General
native FAI_UseDestroyNPCsOnExit(bool:use = true);
native bool:FAI_IsDestroyNPCsOnExitUsed();

// NPCs
native bool:FAI_IsValidNPC(npcid);
native bool:FAI_IsValidNPCForPlayer(npcid, playerid);
native FCNPC_SetHealth(npcid, Float:health, Float:max = -1.0);
native Float:FCNPC_GetHealth(npcid, &Float:max = 100.0);
native FCNPC_SetTarget(npcid, playerid);
native FCNPC_GetTarget(npcid);
native FCNPC_SetGoToInfo(npcid, type = FCNPC_MOVE_TYPE_AUTO, Float:speed = FCNPC_MOVE_SPEED_AUTO, mode = FCNPC_MOVE_MODE_AUTO, pathfinding = FCNPC_MOVE_PATHFINDING_AUTO, Float:radius = 0.0, bool:set_angle = true, Float:min_distance = 0.0, Float:dist_check = 1.5, stop_delay = 250, playerid = -1);
native FCNPC_GetGoToInfo(npcid, playerid, &type, &Float:speed, &mode, &pathfinding, &Float:radius, &bool:set_angle, &Float:min_distance, &Float:dist_check, &stop_delay);
native FCNPC_SetAimAtInfo(npcid, Float:range = 20.0, bool:shoot = false, shoot_delay = -1, bool:set_angle = true, Float:offset_x = 0.0, Float:offset_y = 0.0, Float:offset_z = 0.0, Float:offset_from_x = 0.0, Float:offset_from_y = 0.0, Float:offset_from_z = 0.0, between_check_mode = FCNPC_ENTITY_MODE_AUTO, between_check_flags = FCNPC_ENTITY_CHECK_ALL, playerid = -1);
native FCNPC_GetAimAtInfo(npcid, playerid, &Float:range, &bool:shoot, &shoot_delay, &bool:set_angle, &Float:offset_x, &Float:offset_y, &Float:offset_z, &Float:offset_from_x, &Float:offset_from_y, &Float:offset_from_z, &between_check_mode, &between_check_flags);
native FCNPC_SetMeleeAttackInfo(npcid, Float:range = 0.5, delay = -1, bool:fighting_style = false, playerid = -1);
native FCNPC_GetMeleeAttackInfo(npcid, playerid, &Float:range, &delay, &bool:fighting_style);
native FCNPC_SetOutOfAmmoMeleeWeapon(npcid, weaponid, playerid = -1);
native FCNPC_GetOutOfAmmoMeleeWeapon(npcid, playerid);
native FCNPC_SetBehaviour(npcid, FCNPC_E_BEHAVIOUR:behaviour, playerid = -1);
native FCNPC_E_BEHAVIOUR:FCNPC_GetBehaviour(npcid, playerid);
native FCNPC_SetAggroViewingAngle(npcid, Float:angle, Float:vangle = 180.0, playerid = -1);
native Float:FCNPC_GetAggroViewingAngle(npcid, playerid, &Float:vangle = 180.0);
native FCNPC_UseAggroLineOfSight(npcid, bool:use = true, playerid = -1);
native bool:FCNPC_IsAggroLineOfSightUsed(npcid, playerid);
native FCNPC_SetAggroSightRange(npcid, Float:range, playerid = -1);
native Float:FCNPC_GetAggroSightRange(npcid, playerid);
native FCNPC_SetLeashRange(npcid, Float:range, playerid = -1);
native Float:FCNPC_GetLeashRange(npcid, playerid);
native FCNPC_SetThreat(npcid, Float:threat, playerid = -1);
native Float:FCNPC_GetThreat(npcid, playerid);

// Debug
native FAI_ToggleRangeDebugging(npcid, playerid, FAI_E_DEBUG_RANGE:ranges);
native FAI_E_DEBUG_RANGE:FAI_GetRangeDebugging(npcid);
native FAI_ToggleAngleDebugging(npcid, playerid, FAI_E_DEBUG_ANGLE:angles);
native FAI_E_DEBUG_ANGLE:FAI_GetAngleDebugging(npcid);
*/

// ========================================CALLBACKS========================================
// NPCs
forward FCNPC_OnEncounterStart(npcid, firsttargetid, reason);
forward FCNPC_OnEncounterStop(npcid, lasttargetid, reason);
forward FCNPC_OnPlayerGetAggro(playerid, npcid);
forward FCNPC_OnPlayerLoseAggro(playerid, npcid);

// ========================================CONSTANTS========================================
// General
#define FCNPC_AI_VERSION					"2.0.0"

// NPCs
enum {
	FCNPC_OEA_DAMAGE,
	FCNPC_OEA_AGGRO,
	FCNPC_OEA_EXPLICIT_TARGET_SET
}
enum {
	FCNPC_OEO_NPC_DEATH,
	FCNPC_OEO_NPC_RESPAWN,
	FCNPC_OEO_NPC_DESTROY,
	FCNPC_OEO_NO_VALID_NEW_TARGET,
	FCNPC_OEO_EXPLICIT_TARGET_SET
}
enum FCNPC_E_BEHAVIOUR {
	FCNPC_BEHAVIOUR_FRIENDLY,
	FCNPC_BEHAVIOUR_NEUTRAL,
	FCNPC_BEHAVIOUR_UNFRIENDLY
}

// Debug
enum FAI_E_DEBUG_RANGE (<<=1) {
	FAI_DEBUG_RANGE_ALL = -1,
	FAI_DEBUG_RANGE_NONE = 0,
	FAI_DEBUG_AIM_AT_RANGE = 1,
	FAI_DEBUG_MELEE_ATTACK_RANGE,
	FAI_DEBUG_AGGRO_SIGHT_RANGE,
	FAI_DEBUG_LEASH_RANGE
}
enum FAI_E_DEBUG_ANGLE (<<=1) {
	FAI_DEBUG_ANGLE_ALL = -1,
	FAI_DEBUG_ANGLE_NONE = 0,
	FAI_DEBUG_FACING_ANGLE = 1,
	FAI_DEBUG_VIEWING_ANGLE
}

// ========================================VARIABLES========================================
// General
static bool:FAI_DestroyNPCsOnExit = false;

// Players
static FAI_PauseTickCount[MAX_PLAYERS] = {0, ...};
static bool:FAI_PlayerPaused[MAX_PLAYERS] = {false, ...};
static FAI_PauseTimer = INVALID_TIMER_ID;

// NPCs
enum FAI_E_NPC {
	// Can't be set by the user
	bool:FAI_NPC_VALID,
	// Can be set by the user
	Float:FAI_NPC_HEALTH, // Can be changed automatically by the script
	Float:FAI_NPC_MAX_HEALTH,
	FAI_NPC_TARGET, // Can be changed automatically by the script
	FAI_NPC_GO_TO_TYPE[MAX_PLAYERS],
	Float:FAI_NPC_GO_TO_SPEED[MAX_PLAYERS],
	FAI_NPC_GO_TO_MODE[MAX_PLAYERS],
	FAI_NPC_GO_TO_PATHFINDING[MAX_PLAYERS],
	Float:FAI_NPC_GO_TO_RADIUS[MAX_PLAYERS],
	bool:FAI_NPC_GO_TO_SET_ANGLE[MAX_PLAYERS],
	Float:FAI_NPC_GO_TO_MIN_DISTANCE[MAX_PLAYERS],
	Float:FAI_NPC_GO_TO_DIST_CHECK[MAX_PLAYERS],
	FAI_NPC_GO_TO_STOP_DELAY[MAX_PLAYERS],
	Float:FAI_NPC_AIM_AT_RANGE[MAX_PLAYERS],
	bool:FAI_NPC_AIM_AT_SHOOT[MAX_PLAYERS],
	FAI_NPC_AIM_AT_SHOOT_DELAY[MAX_PLAYERS],
	bool:FAI_NPC_AIM_AT_SET_ANGLE[MAX_PLAYERS],
	Float:FAI_NPC_AIM_AT_OFFSET_X[MAX_PLAYERS],
	Float:FAI_NPC_AIM_AT_OFFSET_Y[MAX_PLAYERS],
	Float:FAI_NPC_AIM_AT_OFFSET_Z[MAX_PLAYERS],
	Float:FAI_NPC_AIM_AT_OFFSET_FROM_X[MAX_PLAYERS],
	Float:FAI_NPC_AIM_AT_OFFSET_FROM_Y[MAX_PLAYERS],
	Float:FAI_NPC_AIM_AT_OFFSET_FROM_Z[MAX_PLAYERS],
	FAI_NPC_AIM_AT_BTWN_CHECK_MODE[MAX_PLAYERS],
	FAI_NPC_AIM_AT_BTWN_CHECK_FLAGS[MAX_PLAYERS],
	Float:FAI_NPC_MELEE_ATTACK_RANGE[MAX_PLAYERS],
	FAI_NPC_MELEE_ATTACK_DELAY[MAX_PLAYERS],
	bool:FAI_NPC_MELEE_ATTACK_FIGHT_STL[MAX_PLAYERS],
	FAI_NPC_OUT_OF_AMMO_MELEE_WEAP[MAX_PLAYERS],
	FCNPC_E_BEHAVIOUR:FAI_NPC_BEHAVIOUR[MAX_PLAYERS],
	Float:FAI_NPC_AGGRO_HOR_VIEWING_ANGLE[MAX_PLAYERS],
	Float:FAI_NPC_AGGRO_VER_VIEWING_ANGLE[MAX_PLAYERS],
	bool:FAI_NPC_AGGRO_LINE_OF_SIGHT[MAX_PLAYERS],
	Float:FAI_NPC_AGGRO_SIGHT_RANGE[MAX_PLAYERS],
	Float:FAI_NPC_LEASH_RANGE[MAX_PLAYERS],
	Float:FAI_NPC_THREAT[MAX_PLAYERS] // Can be changed automatically by the script
}
static FAI_NPCs[MAX_PLAYERS][FAI_E_NPC];

// Debug
static FAI_E_DEBUG_RANGE:FAI_DebugRanges[MAX_PLAYERS] = {FAI_DEBUG_RANGE_NONE, ...};
static FAI_DebugRangesPlayerID[MAX_PLAYERS] = INVALID_PLAYER_ID;
static FAI_E_DEBUG_ANGLE:FAI_DebugAngles[MAX_PLAYERS] = {FAI_DEBUG_ANGLE_NONE, ...};
static FAI_DebugAnglesPlayerID[MAX_PLAYERS] = INVALID_PLAYER_ID;

// ========================================INTERNAL FUNCTIONS========================================
// Silence warning 208
forward bool:FAI_IsPlayerInLeashRange(playerid, npcid);
forward bool:FAI_IsValidNPC(npcid);
forward bool:FAI_IsValidNPCForPlayer(npcid, playerid);

// General
static FAI_ScriptInit() {
	// General
	FAI_DestroyNPCsOnExit = false;

	// Players
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
		FAI_PauseTickCount[playerid] = GetTickCount();
		FAI_PlayerPaused[playerid] = false;
	}
	FAI_PauseTimer = SetTimer("FAI_CheckPlayersPausedState", 1000, true);

	// NPCs
	for(new npcid = 0; npcid < MAX_PLAYERS; npcid++) {
		FAI_ResetNPC(npcid);
	}

	// printf("---------------------");
	// printf("  FCNPC-AI loaded    ");
	// printf("- Version: %s     ", FCNPC_AI_VERSION);
	// printf("- Author: Freaksken  ");
	// printf("---------------------");
}

static FAI_ScriptExit() {
	// Players
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
		FAI_PauseTickCount[playerid] = 0;
		FAI_PlayerPaused[playerid] = false;
	}
	KillTimer(FAI_PauseTimer);
	FAI_PauseTimer = INVALID_TIMER_ID;

	// NPCs
	if(FAI_DestroyNPCsOnExit) {
		// Automatically destroy NPCs on script exit
		for(new npcid = 0; npcid < MAX_PLAYERS; npcid++) {
			if(FAI_IsValidNPC(npcid)) {
				FCNPC_Destroy(npcid);
			}
		}
	}

	// General
	FAI_DestroyNPCsOnExit = false;
}

// Players
forward FAI_CheckPlayersPausedState();
public FAI_CheckPlayersPausedState() {
	for(new playerid = 0, highestPlayerid = GetPlayerPoolSize(); playerid <= highestPlayerid; playerid++) {
		new playerState = GetPlayerState(playerid);
		// OnPlayerUpdate isn't called when the player is initializing, dead or in class selection
		if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && playerState != PLAYER_STATE_WASTED && playerState != PLAYER_STATE_NONE) {
			new bool:playerInGame = true;
			if(GetTickCount() - FAI_PauseTickCount[playerid] > 2000) {
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

// NPCs
static FAI_ResetNPC(npcid) {
	// Don't use FAI_IsValidNPC
	FAI_NPCs[npcid][FAI_NPC_VALID] = false;
	FAI_NPCs[npcid][FAI_NPC_HEALTH] = 100.0;
	FAI_NPCs[npcid][FAI_NPC_MAX_HEALTH] = 100.0;
	FAI_NPCs[npcid][FAI_NPC_TARGET] = INVALID_PLAYER_ID;
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
		FAI_NPCs[npcid][FAI_NPC_GO_TO_TYPE][playerid] = FCNPC_MOVE_TYPE_AUTO;
		FAI_NPCs[npcid][FAI_NPC_GO_TO_SPEED][playerid] = FCNPC_MOVE_SPEED_AUTO;
		FAI_NPCs[npcid][FAI_NPC_GO_TO_MODE][playerid] = FCNPC_MOVE_MODE_AUTO;
		FAI_NPCs[npcid][FAI_NPC_GO_TO_PATHFINDING][playerid] = FCNPC_MOVE_PATHFINDING_AUTO;
		FAI_NPCs[npcid][FAI_NPC_GO_TO_RADIUS][playerid] = 0.0;
		FAI_NPCs[npcid][FAI_NPC_GO_TO_SET_ANGLE][playerid] = true;
		FAI_NPCs[npcid][FAI_NPC_GO_TO_MIN_DISTANCE][playerid] = 0.0;
		FAI_NPCs[npcid][FAI_NPC_GO_TO_DIST_CHECK][playerid] = 1.5;
		FAI_NPCs[npcid][FAI_NPC_GO_TO_STOP_DELAY][playerid] = 250;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_RANGE][playerid] = 20.0;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT][playerid] = false;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT_DELAY][playerid] = -1;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_SET_ANGLE][playerid] = true;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_X][playerid] = 0.0;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Y][playerid] = 0.0;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Z][playerid] = 0.0;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_X][playerid] = 0.0;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Y][playerid] = 0.0;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Z][playerid] = 0.0;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_MODE][playerid] = FCNPC_ENTITY_MODE_AUTO;
		FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_FLAGS][playerid] = FCNPC_ENTITY_CHECK_ALL;
		FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_RANGE][playerid] = 0.5;
		FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_DELAY][playerid] = -1;
		FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_FIGHT_STL][playerid] = false;
		FAI_NPCs[npcid][FAI_NPC_OUT_OF_AMMO_MELEE_WEAP][playerid] = 0; // Fist weapon
		FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][playerid] = FCNPC_BEHAVIOUR_FRIENDLY;
		FAI_NPCs[npcid][FAI_NPC_AGGRO_HOR_VIEWING_ANGLE][playerid] = 360.0;
		FAI_NPCs[npcid][FAI_NPC_AGGRO_VER_VIEWING_ANGLE][playerid] = 180.0;
		FAI_NPCs[npcid][FAI_NPC_AGGRO_LINE_OF_SIGHT][playerid] = false;
		FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid] = 20.0;
		FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid] = 200.0; // The default SA-MP stream_distance
		FAI_NPCs[npcid][FAI_NPC_THREAT][playerid] = 0.0;
	}

	// Debug
	FAI_DebugRanges[npcid] = FAI_DEBUG_RANGE_NONE;
	FAI_DebugRangesPlayerID[npcid] = INVALID_PLAYER_ID;
	FAI_DebugAngles[npcid] = FAI_DEBUG_ANGLE_NONE;
	FAI_DebugAnglesPlayerID[npcid] = INVALID_PLAYER_ID;
}

static bool:FAI_HasNPCMeleeWeapon(npcid) {
	new weaponid = FCNPC_GetWeapon(npcid);
	return IsMeleeWeapon(weaponid);
}

static FAI_UpdateNPCAttackMove(npcid) {
	if(!FCNPC_IsDead(npcid) && FAI_IsValidNPCForPlayer(npcid, FAI_NPCs[npcid][FAI_NPC_TARGET])) {
		new Float:x, Float:y, Float:z;
		FCNPC_GetPosition(npcid, x, y, z);
		new Float:attackRange = FAI_NPCs[npcid][FAI_NPC_AIM_AT_RANGE][FAI_NPCs[npcid][FAI_NPC_TARGET]];
		if(FAI_HasNPCMeleeWeapon(npcid) || (FCNPC_GetAmmo(npcid) == 0 && !FCNPC_IsInfiniteAmmoUsed(npcid))) {
			attackRange = FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_RANGE][FAI_NPCs[npcid][FAI_NPC_TARGET]];
		}
		new bool:canMove = true;
		new bool:canAttack = true;
		// Target in attack range, attack if allowed, otherwise move if allowed, otherwise stop attacking
		if(attackRange < 0.0 || GetPlayerDistanceFromPoint(FAI_NPCs[npcid][FAI_NPC_TARGET], x, y, z) <= attackRange) {
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
		// Target not in attack range, move to target if allowed, otherwise attack if allowed, otherwise stop attacking
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
	if(!FAI_HasNPCMeleeWeapon(npcid) && (FCNPC_GetAmmo(npcid) != 0 || FCNPC_IsInfiniteAmmoUsed(npcid))) {
		// In case the npc switched weapons
		if(FCNPC_IsAttacking(npcid)) {
			FCNPC_StopAttack(npcid);
		}
		// So we don't aim again when we were already aiming at that same player. If aiming at another player, this will execute
		if(!FCNPC_IsAimingAtPlayer(npcid, FAI_NPCs[npcid][FAI_NPC_TARGET]) || (FCNPC_IsShooting(npcid) && !FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT]) || (!FCNPC_IsShooting(npcid) && FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT])) {
			FCNPC_AimAtPlayer(npcid, FAI_NPCs[npcid][FAI_NPC_TARGET], FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT_DELAY][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_AIM_AT_SET_ANGLE][FAI_NPCs[npcid][FAI_NPC_TARGET]],
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_X][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Y][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Z][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_X][FAI_NPCs[npcid][FAI_NPC_TARGET]],
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Y][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Z][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_MODE][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_FLAGS][FAI_NPCs[npcid][FAI_NPC_TARGET]]);
		}
	} else {
		// In case the npc switched weapons
		if(FCNPC_IsAiming(npcid)) {
			FCNPC_StopAim(npcid);
		}
		// So we don't attack again when we were already attacking
		if(!FCNPC_IsAttacking(npcid)) {
			FCNPC_MeleeAttack(npcid, FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_DELAY][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_FIGHT_STL][FAI_NPCs[npcid][FAI_NPC_TARGET]]);
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
	// In case the npc is out of ammo
	if(!FAI_HasNPCMeleeWeapon(npcid) && FCNPC_GetAmmo(npcid) == 0 && !FCNPC_IsInfiniteAmmoUsed(npcid)) {
		FCNPC_SetWeapon(npcid, FAI_NPCs[npcid][FAI_NPC_OUT_OF_AMMO_MELEE_WEAP][FAI_NPCs[npcid][FAI_NPC_TARGET]]);
	}
	// So we don't move again when we were already moving to that same player. If moving at another player, this will execute
	if(!FCNPC_IsMovingAtPlayer(npcid, FAI_NPCs[npcid][FAI_NPC_TARGET])) {
		FCNPC_GoToPlayer(npcid, FAI_NPCs[npcid][FAI_NPC_TARGET], FAI_NPCs[npcid][FAI_NPC_GO_TO_TYPE][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_GO_TO_SPEED][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_GO_TO_MODE][FAI_NPCs[npcid][FAI_NPC_TARGET]],
		FAI_NPCs[npcid][FAI_NPC_GO_TO_PATHFINDING][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_GO_TO_RADIUS][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_GO_TO_SET_ANGLE][FAI_NPCs[npcid][FAI_NPC_TARGET]],
		FAI_NPCs[npcid][FAI_NPC_GO_TO_MIN_DISTANCE][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_GO_TO_DIST_CHECK][FAI_NPCs[npcid][FAI_NPC_TARGET]], FAI_NPCs[npcid][FAI_NPC_GO_TO_STOP_DELAY][FAI_NPCs[npcid][FAI_NPC_TARGET]]);
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
	if(!FCNPC_IsDead(npcid)) {
		new newtargetid = INVALID_PLAYER_ID;
		new reason = FCNPC_OEA_AGGRO;
		// When the encounter has been started, search for an overaggroing player
		if(FAI_NPCs[npcid][FAI_NPC_TARGET] != INVALID_PLAYER_ID) {
			new highestplayerid = FAI_GetHighestThreatPlayer(npcid);
			// For another player to become the target during the encounter, he must exceed 130% of the current valid target's threat (also accounted for divide by 0), or the current target must be invalid, or the behaviour for the current target is friendly
			if(highestplayerid != INVALID_PLAYER_ID && (FAI_NPCs[npcid][FAI_NPC_THREAT][FAI_NPCs[npcid][FAI_NPC_TARGET]] == 0.0 || FAI_NPCs[npcid][FAI_NPC_THREAT][highestplayerid] / FAI_NPCs[npcid][FAI_NPC_THREAT][FAI_NPCs[npcid][FAI_NPC_TARGET]] > 1.3
			|| !FAI_IsValidNPCForPlayer(npcid, FAI_NPCs[npcid][FAI_NPC_TARGET]) || FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][FAI_NPCs[npcid][FAI_NPC_TARGET]] == FCNPC_BEHAVIOUR_FRIENDLY || !FAI_IsPlayerInLeashRange(FAI_NPCs[npcid][FAI_NPC_TARGET], npcid))) {
				// Set target to player with highest threat
				newtargetid = highestplayerid;
				FAI_ChangeNPCTarget(npcid, newtargetid, reason);
			}
		}
		// When the encounter hasn't been started, or there is no overaggroing player
		if(newtargetid == INVALID_PLAYER_ID) {
			// When there is no target, or if the current target is invalid, or if the behaviour for the current target is friendly
			if(!FAI_IsValidNPCForPlayer(npcid, FAI_NPCs[npcid][FAI_NPC_TARGET]) || FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][FAI_NPCs[npcid][FAI_NPC_TARGET]] == FCNPC_BEHAVIOUR_FRIENDLY || !FAI_IsPlayerInLeashRange(FAI_NPCs[npcid][FAI_NPC_TARGET], npcid)) {
				// When the encounter hasn't been started
				if(FAI_NPCs[npcid][FAI_NPC_TARGET] == INVALID_PLAYER_ID) {
					// Set target to closest player in viewing angle and line of sight
					newtargetid = FAI_ClosestPlayerInAggroSghtRng(npcid, true, true);
				}
				// When the encounter has been started
				else {
					// Set target to closest player
					newtargetid = FAI_ClosestPlayerInAggroSghtRng(npcid);
				}
				// Don't do anything when the target doesn't change
				if(FAI_NPCs[npcid][FAI_NPC_TARGET] != newtargetid) {
					if(newtargetid == INVALID_PLAYER_ID) {
						reason = FCNPC_OEO_NO_VALID_NEW_TARGET;
					}
					FAI_ChangeNPCTarget(npcid, newtargetid, reason);
				}
			}
		}
	}
}

static FAI_ChangeNPCTarget(npcid, newtargetid, reason) {
	if(newtargetid == INVALID_PLAYER_ID || (!FCNPC_IsDead(npcid) && FAI_IsValidNPCForPlayer(npcid, newtargetid) && FAI_IsPlayerInLeashRange(newtargetid, npcid))) {
		new oldtargetid = FAI_NPCs[npcid][FAI_NPC_TARGET];
		if(oldtargetid != newtargetid) {
			if(oldtargetid != INVALID_PLAYER_ID) {
				CallLocalFunction("FCNPC_OnPlayerLoseAggro", "dd", oldtargetid, npcid);
			}
			FAI_NPCs[npcid][FAI_NPC_TARGET] = newtargetid;
			if(newtargetid != INVALID_PLAYER_ID) {
				CallLocalFunction("FCNPC_OnPlayerGetAggro", "dd", newtargetid, npcid);
				FAI_UpdateNPCAttackMove(npcid);
				if(oldtargetid == INVALID_PLAYER_ID) {
					CallLocalFunction("FCNPC_OnEncounterStart", "ddd", npcid, newtargetid, reason);
				}
			} else {
				if(oldtargetid != INVALID_PLAYER_ID) {
					for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
						FAI_NPCs[npcid][FAI_NPC_THREAT][playerid] = 0.0;
					}
					FAI_ChangeNPCStopAttackMove(npcid);
					CallLocalFunction("FCNPC_OnEncounterStop", "ddd", npcid, oldtargetid, reason);
				}
			}
			return 1;
		}
	}
	return 0;
}

static bool:FAI_IsPlayerInAggroViewingAngle(playerid, npcid) {
	// Get NPC position
	new Float:xn, Float:yn, Float:zn;
	FCNPC_GetPosition(npcid, xn, yn, zn);

	// Get player position
	new Float:xp, Float:yp, Float:zp;
	if(!IsPlayerNPC(playerid)) {
		GetPlayerPos(playerid, xp, yp, zp);
	} else {
		FCNPC_GetPosition(playerid, xp, yp, zp);
	}

	// ===== HORIZONTAL VIEWING ANGLE =====
	// Get the NPC horizontal facing angle adjusted for the weird GTA angle system
	new Float:npcHorizontalFacingAngle = FCNPC_GetAngle(npcid) + 90.0;

	// Calculate the angle between these 2 points in the horizontal plane
	new Float:horizontalAngleBetweenPoints = atan2(yp - yn, xp - xn);

	// Calculate the smallest difference between these 2 angles as a value between -180.0 and 180.0
	new Float:horizontalAngleDifference = horizontalAngleBetweenPoints - npcHorizontalFacingAngle;
	if(horizontalAngleDifference > 180.0) {
		horizontalAngleDifference -= 360.0;
	}
	if(horizontalAngleDifference < -180.0) {
		horizontalAngleDifference += 360.0;
	}

	// Get the absolute value of this angle
	horizontalAngleDifference = floatabs(horizontalAngleDifference);

	// ===== VERTICAL VIEWING ANGLE =====
	// Calculate the Euclidean distance in the horizontal plane
	new Float:horizontalDistance = VectorSize(xp - xn, yp - yn, 0.0);

	// Calculate the angle between these 2 points in the vertical plane as a value between -90.0 and 90.0
	// The game only has the ability to rotate the NPC along the vertical axis, so the NPC vertical facing angle is always 0.0, so we don't need to subtract it from the calculated angle
	new Float:verticalAngleBetweenPoints = atan2(zp - zn, horizontalDistance);

	// Get the absolute value of this angle
	verticalAngleBetweenPoints = floatabs(verticalAngleBetweenPoints);

	// Check if the player is within the horizontal and vertical aggro viewing angles
	if(horizontalAngleDifference <= FAI_NPCs[npcid][FAI_NPC_AGGRO_HOR_VIEWING_ANGLE][playerid]/2 && verticalAngleBetweenPoints <= FAI_NPCs[npcid][FAI_NPC_AGGRO_VER_VIEWING_ANGLE][playerid]/2) {
		return true;
	}
	return false;
}

static bool:FAI_IsPlayerInAggroLineOfSight(playerid, npcid) {
	// Get NPC position and special action
	new Float:xn, Float:yn, Float:zn, npcAction;
	FCNPC_GetPosition(npcid, xn, yn, zn);
	npcAction = FCNPC_GetSpecialAction(npcid);

	// Get player position and special action
	new Float:xp, Float:yp, Float:zp, playerAction;
	if(!IsPlayerNPC(playerid)) {
		GetPlayerPos(playerid, xp, yp, zp);
		playerAction = GetPlayerSpecialAction(playerid);
	} else {
		FCNPC_GetPosition(playerid, xp, yp, zp);
		playerAction = FCNPC_GetSpecialAction(playerid);
	}

	// Adjust height position of the NPC so that the ray will be cast from the shoulder instead of the groin
	new Float:offset_from_z = 0.5;
	if(npcAction == SPECIAL_ACTION_DUCK) {
		offset_from_z -= 0.2;
	}

	// Adjust height position of the player so that the ray will be cast to the shoulder instead of the groin
	if(playerAction == SPECIAL_ACTION_DUCK) {
		zp -= 0.2;
	} else {
		zp += 0.5;
	}

	// Check if a ray cast between the NPC and the player collides with anything
	new Float:range = GetPlayerDistanceFromPoint(npcid, xp, yp, zp);
	new entity_id;
	FCNPC_GetClosestEntityInBetween(npcid, xp, yp, zp, range, FCNPC_ENTITY_MODE_COLANDREAS, FCNPC_ENTITY_CHECK_ALL, 0.0, 0.0, offset_from_z, entity_id);
	if(entity_id != 0xFFFF) {
		return false;
	}
	return true;
}

static bool:FAI_IsPlayerInAggroSightRange(playerid, npcid) {
	new Float:x, Float:y, Float:z;
	if(!IsPlayerNPC(playerid)) {
		GetPlayerPos(playerid, x, y, z);
	} else {
		FCNPC_GetPosition(playerid, x, y, z);
	}
	new Float:npcRange = GetPlayerDistanceFromPoint(npcid, x, y, z);
	if(FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid] < 0.0 || npcRange <= FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid]) {
		return true;
	}
	return false;
}

static bool:FAI_IsPlayerInLeashRange(playerid, npcid) {
	new Float:x, Float:y, Float:z;
	if(!IsPlayerNPC(playerid)) {
		GetPlayerPos(playerid, x, y, z);
	} else {
		FCNPC_GetPosition(playerid, x, y, z);
	}
	new Float:npcRange = GetPlayerDistanceFromPoint(npcid, x, y, z);
	if(FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid] < 0.0 || npcRange <= FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid]) {
		return true;
	}
	return false;
}

static FAI_ClosestPlayerInAggroSghtRng(npcid, bool:checkViewingAngle = false, bool:checkLineOfSight = false) {
	new closestPlayer = INVALID_PLAYER_ID;
	new Float:closestPlayerRange = 0.0;
	for(new playerid = 0, highestPlayerid = GetPlayerPoolSize(); playerid <= highestPlayerid; playerid++) {
		// Only set target if the encounter has already started OR if the behaviour is unfriendly for that player
		// Don't check for death, because won't be called when dead
		if(FAI_IsValidNPCForPlayer(npcid, playerid) && ((FAI_NPCs[npcid][FAI_NPC_TARGET] != INVALID_PLAYER_ID && FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][playerid] != FCNPC_BEHAVIOUR_FRIENDLY)
		|| (FAI_NPCs[npcid][FAI_NPC_TARGET] == INVALID_PLAYER_ID && FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][playerid] == FCNPC_BEHAVIOUR_UNFRIENDLY))) {
			new Float:x, Float:y, Float:z;
			if(!IsPlayerNPC(playerid)) {
				GetPlayerPos(playerid, x, y, z);
			} else {
				FCNPC_GetPosition(playerid, x, y, z);
			}
			new Float:npcRange = GetPlayerDistanceFromPoint(npcid, x, y, z);
			if(FAI_IsPlayerInAggroSightRange(playerid, npcid) && (!checkViewingAngle || FAI_IsPlayerInAggroViewingAngle(playerid, npcid)) && (!checkLineOfSight || !FAI_NPCs[npcid][FAI_NPC_AGGRO_LINE_OF_SIGHT][playerid] || FAI_IsPlayerInAggroLineOfSight(playerid, npcid)) && (closestPlayer == INVALID_PLAYER_ID || npcRange < closestPlayerRange)) {
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
		// Only set target if the player has any threat AND the behaviour is not friendly for that player
		// Don't check for death, because won't be called when dead
		if(FAI_IsValidNPCForPlayer(npcid, playerid) && FAI_IsPlayerInLeashRange(playerid, npcid) && FAI_NPCs[npcid][FAI_NPC_THREAT][playerid] > 0.0 && FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][playerid] != FCNPC_BEHAVIOUR_FRIENDLY) {
			// When there are multiple players with the same threat, the first ID will be used
			if(highestPlayer == INVALID_PLAYER_ID || FAI_NPCs[npcid][FAI_NPC_THREAT][playerid] > highestPlayerThreat) {
				highestPlayerThreat = FAI_NPCs[npcid][FAI_NPC_THREAT][playerid];
				highestPlayer = playerid;
			}
		}
	}
	return highestPlayer;
}

// Debug
static FAI_ToggleDebugRangeObjects(npcid) {
	new Float:iScale = 1.0, Float:radius = 50.0; // Radius of modelid is 50.0
	if(FAI_DebugRanges[npcid] & FAI_DEBUG_AIM_AT_RANGE && FAI_NPCs[npcid][FAI_NPC_AIM_AT_RANGE][FAI_DebugRangesPlayerID[npcid]] > 0.0) { // Yellow
		new Float:scale = iScale / radius * FAI_NPCs[npcid][FAI_NPC_AIM_AT_RANGE][FAI_DebugRangesPlayerID[npcid]];
		SetPlayerAttachedObject(npcid, 0, 18843, 1, .fRotY = 90.0, .fScaleX = scale, .fScaleY = scale, .fScaleZ = scale, .materialcolor1 = 0xFFFFFF00);
	} else {
		RemovePlayerAttachedObject(npcid, 0);
	}
	if(FAI_DebugRanges[npcid] & FAI_DEBUG_MELEE_ATTACK_RANGE && FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_RANGE][FAI_DebugRangesPlayerID[npcid]] > 0.0) { // Purple
		new Float:scale = iScale / radius * FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_RANGE][FAI_DebugRangesPlayerID[npcid]];
		SetPlayerAttachedObject(npcid, 1, 18843, 1, .fRotY = 90.0, .fScaleX = scale, .fScaleY = scale, .fScaleZ = scale, .materialcolor1 = 0xFF800080);
	} else {
		RemovePlayerAttachedObject(npcid, 1);
	}
	if(FAI_DebugRanges[npcid] & FAI_DEBUG_AGGRO_SIGHT_RANGE && FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][FAI_DebugRangesPlayerID[npcid]] > 0.0) { // Red
		new Float:scale = iScale / radius * FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][FAI_DebugRangesPlayerID[npcid]];
		SetPlayerAttachedObject(npcid, 2, 18843, 1, .fRotY = 90.0, .fScaleX = scale, .fScaleY = scale, .fScaleZ = scale, .materialcolor1 = 0xFFFF0000);
	} else {
		RemovePlayerAttachedObject(npcid, 2);
	}
	if(FAI_DebugRanges[npcid] & FAI_DEBUG_LEASH_RANGE && FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][FAI_DebugRangesPlayerID[npcid]] > 0.0) { // Green
		new Float:scale = iScale / radius * FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][FAI_DebugRangesPlayerID[npcid]];
		SetPlayerAttachedObject(npcid, 4, 18843, 1, .fRotY = 90.0, .fScaleX = scale, .fScaleY = scale, .fScaleZ = scale, .materialcolor1 = 0xFF00FF00);
	} else {
		RemovePlayerAttachedObject(npcid, 4);
	}
}

static FAI_ToggleDebugAngleObjects(npcid) {
	if(FAI_DebugAngles[npcid] & FAI_DEBUG_FACING_ANGLE) { // Red
		SetPlayerAttachedObject(npcid, 0, 18643, 1, .fRotZ = 90.0);
	} else {
		RemovePlayerAttachedObject(npcid, 0);
	}
	if(FAI_DebugAngles[npcid] & FAI_DEBUG_VIEWING_ANGLE) { // Green
		SetPlayerAttachedObject(npcid, 1, 19083, 1, .fRotX = FAI_NPCs[npcid][FAI_NPC_AGGRO_HOR_VIEWING_ANGLE][FAI_DebugAnglesPlayerID[npcid]]/2, .fRotZ = 90.0 - FAI_NPCs[npcid][FAI_NPC_AGGRO_VER_VIEWING_ANGLE][FAI_DebugAnglesPlayerID[npcid]]/2);
		SetPlayerAttachedObject(npcid, 2, 19083, 1, .fRotX = -FAI_NPCs[npcid][FAI_NPC_AGGRO_HOR_VIEWING_ANGLE][FAI_DebugAnglesPlayerID[npcid]]/2, .fRotZ = 90.0 - FAI_NPCs[npcid][FAI_NPC_AGGRO_VER_VIEWING_ANGLE][FAI_DebugAnglesPlayerID[npcid]]/2);
		SetPlayerAttachedObject(npcid, 3, 19083, 1, .fRotX = FAI_NPCs[npcid][FAI_NPC_AGGRO_HOR_VIEWING_ANGLE][FAI_DebugAnglesPlayerID[npcid]]/2, .fRotZ = 90.0 + FAI_NPCs[npcid][FAI_NPC_AGGRO_VER_VIEWING_ANGLE][FAI_DebugAnglesPlayerID[npcid]]/2);
		SetPlayerAttachedObject(npcid, 4, 19083, 1, .fRotX = -FAI_NPCs[npcid][FAI_NPC_AGGRO_HOR_VIEWING_ANGLE][FAI_DebugAnglesPlayerID[npcid]]/2, .fRotZ = 90.0 + FAI_NPCs[npcid][FAI_NPC_AGGRO_VER_VIEWING_ANGLE][FAI_DebugAnglesPlayerID[npcid]]/2);
	} else {
		RemovePlayerAttachedObject(npcid, 1);
		RemovePlayerAttachedObject(npcid, 2);
		RemovePlayerAttachedObject(npcid, 3);
		RemovePlayerAttachedObject(npcid, 4);
	}
}

// ========================================HOOKED CALLBACKS========================================
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

		FAI_ScriptExit(); // Call after
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

		FAI_ScriptExit(); // Call after
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
	// Players
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

public OnPlayerDisconnect(playerid, reason) {
	// Players
	FAI_PauseTickCount[playerid] = 0;
	FAI_PlayerPaused[playerid] = false;

	new ret = 1;
	#if defined FAI_OnPlayerDisconnect
		ret = FAI_OnPlayerDisconnect(playerid, reason);
	#endif
	return ret;
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

public OnPlayerUpdate(playerid)
{
	// Players
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

// This will both handle NPCs being destroyed programmatically and NPCs being disconnected (kicked/banned)
public FCNPC_OnDestroy(npcid)
{
	// NPCs
	if(FAI_IsValidNPC(npcid)) {
		FAI_ChangeNPCTarget(npcid, INVALID_PLAYER_ID, FCNPC_OEO_NPC_DESTROY);
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
	// NPCs
	if(FAI_IsValidNPC(npcid)) {
		FAI_UpdateNPCTarget(npcid);
		FAI_UpdateNPCAttackMove(npcid); // Call after setting target
		// Reset threat of recently invalid players
		// We also need to reset recently disconnected players, so we need to use MAX_PLAYERS here
		for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
			// Don't check for death, because won't be called when dead
			if(FAI_NPCs[npcid][FAI_NPC_THREAT][playerid] != 0.0 && !FAI_IsValidNPCForPlayer(npcid, playerid)) {
				FAI_NPCs[npcid][FAI_NPC_THREAT][playerid] = 0.0;
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
	// NPCs
	if(FAI_IsValidNPC(npcid)) {
		if(FAI_NPCs[npcid][FAI_NPC_HEALTH] == 0.0) {
			FAI_NPCs[npcid][FAI_NPC_HEALTH] = FAI_NPCs[npcid][FAI_NPC_MAX_HEALTH];
		} else {
			FAI_ChangeNPCTarget(npcid, INVALID_PLAYER_ID, FCNPC_OEO_NPC_RESPAWN);
		}

		// Debug
		FAI_ToggleDebugRangeObjects(npcid);
		FAI_ToggleDebugAngleObjects(npcid);
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

public FCNPC_OnDeath(npcid, killerid, reason)
{
	// NPCs
	if(FAI_IsValidNPC(npcid)) {
		// In case the NPC was killed programmatically, or by setting it's health to 0.0, or by getting damaged
		FAI_NPCs[npcid][FAI_NPC_HEALTH] = 0.0;

		FAI_ChangeNPCTarget(npcid, INVALID_PLAYER_ID, FCNPC_OEO_NPC_DEATH);
	}

	new ret = 1;
	#if defined FAI_FCNPC_OnDeath
		ret = FAI_FCNPC_OnDeath(npcid, killerid, reason);
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
	forward FAI_FCNPC_OnDeath(npcid, killerid, reason);
#endif

// Has to remain before hooking the health native!
public FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart)
{
	new ret = 1;
	#if defined FAI_FCNPC_OnTakeDamage
		// The user can override the decision for the damage to be afflicted to the NPC
		ret = FAI_FCNPC_OnTakeDamage(npcid, issuerid, amount, weaponid, bodypart);
	#endif

	if(ret == 1) { // Call after
		// NPCs
		if(FAI_IsValidNPC(npcid)) {
			// 2nd part of condition: if the npc is dead, this function can still be called before the OnDeath callback gets called (mainly when shot with fast guns: minigun, ...)
			// 3rd part of condition: damage not inflicted by players (falling, ...)
			// 4th part of condition: necessary to reject invalid damage done: the NPC is visible and thus damagable in other interiors
			if(FCNPC_IsSpawned(npcid) && !FCNPC_IsDead(npcid) && (issuerid == INVALID_PLAYER_ID || FAI_IsValidNPCForPlayer(npcid, issuerid))) {
				// If the behaviour is neutral or unfriendly for that player
				// Threat won't increase and target won't be set when the behaviour is friendly for that player
				if(issuerid == INVALID_PLAYER_ID || FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][issuerid] != FCNPC_BEHAVIOUR_FRIENDLY) {
					// Increase threat according to damage done
					if(issuerid != INVALID_PLAYER_ID) {
						FAI_NPCs[npcid][FAI_NPC_THREAT][issuerid] += amount;
					}
					// If the encounter has been started
					if(FAI_NPCs[npcid][FAI_NPC_TARGET] != INVALID_PLAYER_ID) {
						FAI_UpdateNPCTarget(npcid);
					}
					// If the encounter has not been started
					else {
						// Set target to issuerid
						FAI_ChangeNPCTarget(npcid, issuerid, FCNPC_OEA_DAMAGE);
					}
				}

				new Float:armour = FCNPC_GetArmour(npcid);
				// Affect only armour
				if(armour - amount >= 0.0) {
					amount = 0.0;

					// Allow the damage to be afflicted to the NPC, to let the armour decrease
					ret = 1;
				}
				// Affect both armour and health, or only health
				else {
					if(armour != 0.0) {
						FCNPC_SetArmour(npcid, 0.0);
						amount -= armour;
					}

					// Dont damage below 0
					if(FAI_NPCs[npcid][FAI_NPC_HEALTH] > amount) {
						FAI_NPCs[npcid][FAI_NPC_HEALTH] -= amount;

						// Prevent the damage to be afflicted to the NPC
						ret = 0;
					}
					// Make the damager that makes the last shot, kill the NPC
					else {
						// Has to be the original function, not the hook! Therefore this code must be put before the native hook!
						FCNPC_SetHealth(npcid, FAI_NPCs[npcid][FAI_NPC_HEALTH]);

						// Allow the damage to be afflicted to the NPC, which will kill him in this case
						ret = 1;
					}
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
	forward FAI_FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart);
#endif

// ========================================HOOKED FUNCTIONS========================================
// NPCs
// Using function hook instead of callback hook, so that this script only handles NPCs created in this FS/GM
stock FAI_FCNPC_Create(const name[]) {
	new npcid = FCNPC_Create(name);
	if(npcid != INVALID_PLAYER_ID) {
		FAI_NPCs[npcid][FAI_NPC_VALID] = true;
	}
	return npcid;
}
#if defined _ALS_FCNPC_Create
	#undef FCNPC_Create
#else
	#define _ALS_FCNPC_Create
#endif
#define FCNPC_Create FAI_FCNPC_Create

// Has to remain after hooking the damage callback!
stock FAI_FCNPC_SetHealth(npcid, Float:health, Float:max = -1.0) {
	if(FAI_IsValidNPC(npcid)) {
		if(health < 0.0) {
			health = 0.0;
		}

		// Keep previous max health when using a negative value
		if(max < 0.0) {
			max = FAI_NPCs[npcid][FAI_NPC_MAX_HEALTH];
		}

		if(health > max) {
			max = health;
		}
		FAI_NPCs[npcid][FAI_NPC_HEALTH] = health;
		FAI_NPCs[npcid][FAI_NPC_MAX_HEALTH] = max;

		// Should be last, otherwise calling respawn in OnDeath will not reset the health to max health but will remain 0
		if(health == 0.0) {
			if(!FCNPC_IsDead(npcid)) {
				FCNPC_Kill(npcid);
			}
		}
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

// Default value can be anything, since it will be ignored anyway
stock Float:FAI_FCNPC_GetHealth(npcid, &Float:max = 100.0) {
	if(FAI_IsValidNPC(npcid)) {
		max = FAI_NPCs[npcid][FAI_NPC_MAX_HEALTH];
		return FAI_NPCs[npcid][FAI_NPC_HEALTH];
	}

	return FCNPC_GetHealth(npcid);
}
#if defined _ALS_FCNPC_GetHealth
	#undef FCNPC_GetHealth
#else
	#define _ALS_FCNPC_GetHealth
#endif
#define FCNPC_GetHealth FAI_FCNPC_GetHealth

// ========================================FUNCTIONS========================================
// General
stock FAI_UseDestroyNPCsOnExit(bool:use = true) {
	FAI_DestroyNPCsOnExit = use;
	return 1;
}

stock bool:FAI_IsDestroyNPCsOnExitUsed() {
	return FAI_DestroyNPCsOnExit;
}

// NPCs
// Only handle NPCs created in this FS/GM
stock bool:FAI_IsValidNPC(npcid) {
	return npcid >= 0 && npcid < MAX_PLAYERS && FAI_NPCs[npcid][FAI_NPC_VALID];
}

stock bool:FAI_IsValidNPCForPlayer(npcid, playerid) {
	// Check for death outside this function
	if(FAI_IsValidNPC(npcid) && IsPlayerConnected(playerid) && npcid != playerid && FCNPC_IsSpawned(npcid)) {
		new npcInterior = FCNPC_GetInterior(npcid);
		new npcWorld = FCNPC_GetVirtualWorld(npcid);
		if(!IsPlayerNPC(playerid)) {
			new playerState = GetPlayerState(playerid);
			if(GetPlayerInterior(playerid) == npcInterior && GetPlayerVirtualWorld(playerid) == npcWorld && playerState != PLAYER_STATE_NONE && playerState != PLAYER_STATE_WASTED
			&& playerState != PLAYER_STATE_SPAWNED && playerState != PLAYER_STATE_SPECTATING && !FAI_PlayerPaused[playerid]) {
				return true;
			}
		} else {
			// FCNPC_IsValid ==> only support FCNPC bots, no standard bots because those can't react to anything anyway
			if(FCNPC_IsValid(playerid) && FCNPC_GetInterior(playerid) == npcInterior && FCNPC_GetVirtualWorld(playerid) == npcWorld && FCNPC_IsSpawned(playerid) && !FCNPC_IsDead(playerid)) {
				return true;
			}
		}
	}
	return false;
}

stock FCNPC_SetTarget(npcid, playerid) {
	if(FAI_IsValidNPC(npcid)) {
		new reason = FCNPC_OEA_EXPLICIT_TARGET_SET;
		if(playerid == INVALID_PLAYER_ID) {
			reason = FCNPC_OEO_EXPLICIT_TARGET_SET;
		}
		return FAI_ChangeNPCTarget(npcid, playerid, reason); // Can be INVALID_PLAYER_ID
	}
	return 0;
}

stock FCNPC_GetTarget(npcid) {
	if(FAI_IsValidNPC(npcid)) {
		return FAI_NPCs[npcid][FAI_NPC_TARGET];
	}
	return 0;
}

stock FCNPC_SetGoToInfo(npcid, type = FCNPC_MOVE_TYPE_AUTO, Float:speed = FCNPC_MOVE_SPEED_AUTO, mode = FCNPC_MOVE_MODE_AUTO, pathfinding = FCNPC_MOVE_PATHFINDING_AUTO, Float:radius = 0.0, bool:set_angle = true, Float:min_distance = 0.0, Float:dist_check = 1.5, stop_delay = 250, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(playerid != -1) {
			FAI_NPCs[npcid][FAI_NPC_GO_TO_TYPE][playerid] = type;
			FAI_NPCs[npcid][FAI_NPC_GO_TO_SPEED][playerid] = speed;
			FAI_NPCs[npcid][FAI_NPC_GO_TO_MODE][playerid] = mode;
			FAI_NPCs[npcid][FAI_NPC_GO_TO_PATHFINDING][playerid] = pathfinding;
			FAI_NPCs[npcid][FAI_NPC_GO_TO_RADIUS][playerid] = radius;
			FAI_NPCs[npcid][FAI_NPC_GO_TO_SET_ANGLE][playerid] = set_angle;
			FAI_NPCs[npcid][FAI_NPC_GO_TO_MIN_DISTANCE][playerid] = min_distance;
			FAI_NPCs[npcid][FAI_NPC_GO_TO_DIST_CHECK][playerid] = dist_check;
			FAI_NPCs[npcid][FAI_NPC_GO_TO_STOP_DELAY][playerid] = stop_delay;
		} else {
			for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
				FAI_NPCs[npcid][FAI_NPC_GO_TO_TYPE][playerid1] = type;
				FAI_NPCs[npcid][FAI_NPC_GO_TO_SPEED][playerid1] = speed;
				FAI_NPCs[npcid][FAI_NPC_GO_TO_MODE][playerid1] = mode;
				FAI_NPCs[npcid][FAI_NPC_GO_TO_PATHFINDING][playerid1] = pathfinding;
				FAI_NPCs[npcid][FAI_NPC_GO_TO_RADIUS][playerid1] = radius;
				FAI_NPCs[npcid][FAI_NPC_GO_TO_SET_ANGLE][playerid1] = set_angle;
				FAI_NPCs[npcid][FAI_NPC_GO_TO_MIN_DISTANCE][playerid1] = min_distance;
				FAI_NPCs[npcid][FAI_NPC_GO_TO_DIST_CHECK][playerid1] = dist_check;
				FAI_NPCs[npcid][FAI_NPC_GO_TO_STOP_DELAY][playerid1] = stop_delay;
			}
		}
		FAI_UpdateNPCAttackMove(npcid);
		return 1;
	}
	return 0;
}

stock FCNPC_GetGoToInfo(npcid, playerid, &type, &Float:speed, &mode, &pathfinding, &Float:radius, &bool:set_angle, &Float:min_distance, &Float:dist_check, &stop_delay) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		type = FAI_NPCs[npcid][FAI_NPC_GO_TO_TYPE][playerid];
		speed = FAI_NPCs[npcid][FAI_NPC_GO_TO_SPEED][playerid];
		mode = FAI_NPCs[npcid][FAI_NPC_GO_TO_MODE][playerid];
		pathfinding = FAI_NPCs[npcid][FAI_NPC_GO_TO_PATHFINDING][playerid];
		radius = FAI_NPCs[npcid][FAI_NPC_GO_TO_RADIUS][playerid];
		set_angle = FAI_NPCs[npcid][FAI_NPC_GO_TO_SET_ANGLE][playerid];
		min_distance = FAI_NPCs[npcid][FAI_NPC_GO_TO_MIN_DISTANCE][playerid];
		dist_check = FAI_NPCs[npcid][FAI_NPC_GO_TO_DIST_CHECK][playerid];
		stop_delay = FAI_NPCs[npcid][FAI_NPC_GO_TO_STOP_DELAY][playerid];
		return 1;
	}
	return 0;
}

stock FCNPC_SetAimAtInfo(npcid, Float:range = 20.0, bool:shoot = false, shoot_delay = -1, bool:set_angle = true, Float:offset_x = 0.0, Float:offset_y = 0.0, Float:offset_z = 0.0, Float:offset_from_x = 0.0, Float:offset_from_y = 0.0, Float:offset_from_z = 0.0, between_check_mode = FCNPC_ENTITY_MODE_AUTO, between_check_flags = FCNPC_ENTITY_CHECK_ALL, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(playerid != -1) {
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_RANGE][playerid] = range; // Can be negative
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT][playerid] = shoot;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT_DELAY][playerid] = shoot_delay;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_SET_ANGLE][playerid] = set_angle;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_X][playerid] = offset_x;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Y][playerid] = offset_y;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Z][playerid] = offset_z;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_X][playerid] = offset_from_x;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Y][playerid] = offset_from_y;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Z][playerid] = offset_from_z;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_MODE][playerid] = between_check_mode;
			FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_FLAGS][playerid] = between_check_flags;
		} else {
			for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_RANGE][playerid1] = range; // Can be negative
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT][playerid1] = shoot;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT_DELAY][playerid1] = shoot_delay;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_SET_ANGLE][playerid1] = set_angle;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_X][playerid1] = offset_x;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Y][playerid1] = offset_y;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Z][playerid1] = offset_z;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_X][playerid1] = offset_from_x;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Y][playerid1] = offset_from_y;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Z][playerid1] = offset_from_z;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_MODE][playerid1] = between_check_mode;
				FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_FLAGS][playerid1] = between_check_flags;
			}
		}
		FAI_UpdateNPCAttackMove(npcid);

		// Debug
		FAI_ToggleDebugRangeObjects(npcid);
		FAI_ToggleDebugAngleObjects(npcid);
		return 1;
	}
	return 0;
}

stock FCNPC_GetAimAtInfo(npcid, playerid, &Float:range, &bool:shoot, &shoot_delay, &bool:set_angle, &Float:offset_x, &Float:offset_y, &Float:offset_z, &Float:offset_from_x, &Float:offset_from_y, &Float:offset_from_z, &between_check_mode, &between_check_flags) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		range = FAI_NPCs[npcid][FAI_NPC_AIM_AT_RANGE][playerid];
		shoot = FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT][playerid];
		shoot_delay = FAI_NPCs[npcid][FAI_NPC_AIM_AT_SHOOT_DELAY][playerid];
		set_angle = FAI_NPCs[npcid][FAI_NPC_AIM_AT_SET_ANGLE][playerid];
		offset_x = FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_X][playerid];
		offset_y = FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Y][playerid];
		offset_z = FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_Z][playerid];
		offset_from_x = FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_X][playerid];
		offset_from_y = FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Y][playerid];
		offset_from_z = FAI_NPCs[npcid][FAI_NPC_AIM_AT_OFFSET_FROM_Z][playerid];
		between_check_mode = FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_MODE][playerid];
		between_check_flags = FAI_NPCs[npcid][FAI_NPC_AIM_AT_BTWN_CHECK_FLAGS][playerid];
		return 1;
	}
	return 0;
}

stock FCNPC_SetMeleeAttackInfo(npcid, Float:range = 0.5, delay = -1, bool:fighting_style = false, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(playerid != -1) {
			FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_RANGE][playerid] = range; // Can be negative
			FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_DELAY][playerid] = delay;
			FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_FIGHT_STL][playerid] = fighting_style;
		} else {
			for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
				FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_RANGE][playerid1] = range; // Can be negative
				FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_DELAY][playerid1] = delay;
				FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_FIGHT_STL][playerid1] = fighting_style;
			}
		}
		FAI_UpdateNPCAttackMove(npcid);

		// Debug
		FAI_ToggleDebugRangeObjects(npcid);
		FAI_ToggleDebugAngleObjects(npcid);
		return 1;
	}
	return 0;
}

stock FCNPC_GetMeleeAttackInfo(npcid, playerid, &Float:range, &delay, &bool:fighting_style) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		range = FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_RANGE][playerid];
		delay = FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_DELAY][playerid];
		fighting_style = FAI_NPCs[npcid][FAI_NPC_MELEE_ATTACK_FIGHT_STL][playerid];
		return 1;
	}
	return 0;
}

stock FCNPC_SetOutOfAmmoMeleeWeapon(npcid, weaponid, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(IsMeleeWeapon(weaponid)) {
			if(playerid != -1) {
				FAI_NPCs[npcid][FAI_NPC_OUT_OF_AMMO_MELEE_WEAP][playerid] = weaponid;
			} else {
				for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
					FAI_NPCs[npcid][FAI_NPC_OUT_OF_AMMO_MELEE_WEAP][playerid1] = weaponid;
				}
			}
			FAI_UpdateNPCAttackMove(npcid);
			return 1;
		}
	}
	return 0;
}

stock FCNPC_GetOutOfAmmoMeleeWeapon(npcid, playerid) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		return FAI_NPCs[npcid][FAI_NPC_OUT_OF_AMMO_MELEE_WEAP][playerid];
	}
	return 0;
}

stock FCNPC_SetBehaviour(npcid, FCNPC_E_BEHAVIOUR:behaviour, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(behaviour >= FCNPC_E_BEHAVIOUR:0 && behaviour < FCNPC_E_BEHAVIOUR) {
			if(playerid != -1) {
				FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][playerid] = behaviour;
			} else {
				for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
					FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][playerid1] = behaviour;
				}
			}
			FAI_UpdateNPCTarget(npcid);
			return 1;
		}
	}
	return 0;
}

stock FCNPC_E_BEHAVIOUR:FCNPC_GetBehaviour(npcid, playerid) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		return FAI_NPCs[npcid][FAI_NPC_BEHAVIOUR][playerid];
	}
	return 0;
}

stock FCNPC_SetAggroViewingAngle(npcid, Float:angle, Float:vangle = 180.0, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(angle >= 0.0 && angle <= 360.0 && vangle >= 0.0 && vangle <= 180.0) {
			if(playerid != -1) {
				FAI_NPCs[npcid][FAI_NPC_AGGRO_HOR_VIEWING_ANGLE][playerid] = angle;
				FAI_NPCs[npcid][FAI_NPC_AGGRO_VER_VIEWING_ANGLE][playerid] = vangle;
			} else {
				for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
					FAI_NPCs[npcid][FAI_NPC_AGGRO_HOR_VIEWING_ANGLE][playerid1] = angle;
					FAI_NPCs[npcid][FAI_NPC_AGGRO_VER_VIEWING_ANGLE][playerid1] = vangle;
				}
			}
			FAI_UpdateNPCTarget(npcid);

			// Debug
			FAI_ToggleDebugRangeObjects(npcid);
			FAI_ToggleDebugAngleObjects(npcid);
			return 1;
		}
	}
	return 0;
}

stock Float:FCNPC_GetAggroViewingAngle(npcid, playerid, &Float:vangle = 180.0) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		vangle = FAI_NPCs[npcid][FAI_NPC_AGGRO_VER_VIEWING_ANGLE][playerid];
		return FAI_NPCs[npcid][FAI_NPC_AGGRO_HOR_VIEWING_ANGLE][playerid];
	}
	return 0.0;
}

stock FCNPC_UseAggroLineOfSight(npcid, bool:use = true, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(playerid != -1) {
			FAI_NPCs[npcid][FAI_NPC_AGGRO_LINE_OF_SIGHT][playerid] = use;
		} else {
			for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
				FAI_NPCs[npcid][FAI_NPC_AGGRO_LINE_OF_SIGHT][playerid1] = use;
			}
		}
		FAI_UpdateNPCTarget(npcid);
		return 1;
	}
	return 0;
}

stock bool:FCNPC_IsAggroLineOfSightUsed(npcid, playerid) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		return FAI_NPCs[npcid][FAI_NPC_AGGRO_LINE_OF_SIGHT][playerid];
	}
}

stock FCNPC_SetAggroSightRange(npcid, Float:range, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(playerid != -1) {
			if(range >= 0.0 && range > FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid]) {
				range = FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid];
			}
			FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid] = range; // Can be negative
		} else {
			for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
				if(range >= 0.0 && range > FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid1]) {
					range = FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid1];
				}
				FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid1] = range; // Can be negative
			}
		}
		FAI_UpdateNPCTarget(npcid);

		// Debug
		FAI_ToggleDebugRangeObjects(npcid);
		FAI_ToggleDebugAngleObjects(npcid);
		return 1;
	}
	return 0;
}

stock Float:FCNPC_GetAggroSightRange(npcid, playerid) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		return FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid];
	}
	return 0.0;
}

stock FCNPC_SetLeashRange(npcid, Float:range, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(playerid != -1) {
			if(range >= 0.0 && range < FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid]) {
				range = FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid];
			}
			FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid] = range; // Can be negative
		} else {
			for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
				if(range >= 0.0 && range < FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid1]) {
					range = FAI_NPCs[npcid][FAI_NPC_AGGRO_SIGHT_RANGE][playerid1];
				}
				FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid1] = range; // Can be negative
			}
		}
		FAI_UpdateNPCTarget(npcid);

		// Debug
		FAI_ToggleDebugRangeObjects(npcid);
		FAI_ToggleDebugAngleObjects(npcid);
		return 1;
	}
	return 0;
}

stock Float:FCNPC_GetLeashRange(npcid, playerid) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		return FAI_NPCs[npcid][FAI_NPC_LEASH_RANGE][playerid];
	}
	return 0.0;
}

stock FCNPC_SetThreat(npcid, Float:threat, playerid = -1) {
	if(FAI_IsValidNPC(npcid) && playerid >= -1 && playerid < MAX_PLAYERS) {
		if(threat < 0.0) {
			threat = 0.0;
		}
		if(playerid != -1) {
			FAI_NPCs[npcid][FAI_NPC_THREAT][playerid] = threat; // Can't be negative
		} else {
			for(new playerid1 = 0; playerid1 < MAX_PLAYERS; playerid1++) {
				FAI_NPCs[npcid][FAI_NPC_THREAT][playerid1] = threat; // Can't be negative
			}
		}
		FAI_UpdateNPCTarget(npcid);
		return 1;
	}
	return 0;
}

stock Float:FCNPC_GetThreat(npcid, playerid) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		return FAI_NPCs[npcid][FAI_NPC_THREAT][playerid];
	}
	return 0.0;
}

// Debug
stock FAI_ToggleRangeDebugging(npcid, playerid, FAI_E_DEBUG_RANGE:ranges) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		// Not enough attached object slots to show both ranges and angles
		FAI_DebugAngles[npcid] = FAI_DEBUG_ANGLE_NONE;
		FAI_ToggleDebugAngleObjects(npcid);

		FAI_DebugRanges[npcid] = ranges;
		FAI_DebugRangesPlayerID[npcid] = playerid;
		FAI_ToggleDebugRangeObjects(npcid);
		return 1;
	}
	return 0;
}

stock FAI_E_DEBUG_RANGE:FAI_GetRangeDebugging(npcid) {
	if(FAI_IsValidNPC(npcid)) {
		return FAI_DebugRanges[npcid];
	}
	return FAI_DEBUG_RANGE_NONE;
}

stock FAI_ToggleAngleDebugging(npcid, playerid, FAI_E_DEBUG_ANGLE:angles) {
	if(FAI_IsValidNPC(npcid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		// Not enough attached object slots to show both ranges and angles
		FAI_DebugRanges[npcid] = FAI_DEBUG_RANGE_NONE;
		FAI_ToggleDebugRangeObjects(npcid);

		FAI_DebugAngles[npcid] = angles;
		FAI_DebugAnglesPlayerID[npcid] = playerid;
		FAI_ToggleDebugAngleObjects(npcid);
		return 1;
	}
	return 0;
}

stock FAI_E_DEBUG_ANGLE:FAI_GetAngleDebugging(npcid) {
	if(FAI_IsValidNPC(npcid)) {
		return FAI_DebugAngles[npcid];
	}
	return FAI_DEBUG_ANGLE_NONE;
}