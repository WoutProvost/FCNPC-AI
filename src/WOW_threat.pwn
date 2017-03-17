/*
//Boss
native WOW_GetBossThreatForPlayer(bossid, playerid);
native WOW_SetBossThreatForPlayer(bossid, playerid, threat);
*/

//Boss
enum WOW_ENUM_BOSS {
	//Can be set by the user
	THREAT[MAX_PLAYERS],
}

stock WOW_DamageBoss(bossid, damagerid, Float:amount) {
	if(WOW_IsValidBoss(bossid) && (IsPlayerConnected(damagerid) || damagerid == INVALID_PLAYER_ID)) {
	    new bossplayerid = WOW_GetBossNPCID(bossid);
		//2nd part of condition: if the npc is dead, this function can still be called before the OnDeath callback gets called (mainly when shot with fast guns: minigun, ...)
		//3rd part of condition: damage not inflicted by players (falling, ...)
		//4th part of condition: neccesary to reject invalid damage done: the NPC is visible and thus damagable in other interiors
	 	if(FCNPC_IsSpawned(bossplayerid) && !FCNPC_IsDead(bossplayerid) && (damagerid == INVALID_PLAYER_ID || WOW_IsBossValidForPlayer(damagerid, bossid))) {
			//Set target to damagerid if no target yet (valid damagerid + no target yet check in setter)
			WOW_SetBossTargetWithReason(bossid, damagerid, 1);
			WOW_SetBossThreatForPlayer(bossid, damagerid, WOW_Bosses[bossid][THREAT][damagerid] + floatround(amount, floatround_floor); //Floor, because the next threat value hasn't been reached yet
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
static WOW_ResetBossStats(bossid) {
	//Don't use WOW_IsValidBoss(bossid)
	if(bossid >= 0 && bossid < WOW_MAX_BOSSES) {
		for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
			WOW_Bosses[bossid][THREAT][playerid] = 0;
		}
	}
}
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
						//Threat
						for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
							WOW_Bosses[bossid][THREAT][playerid] = 0;
						}
					}
				}
				return 1;
		    }
	    }
	}
	return 0;
}
stock WOW_GetBossThreatForPlayer(bossid, playerid) {
	if(WOW_IsValidBoss(bossid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		return WOW_Bosses[bossid][THREAT][playerid];
	}
	return -1;
}
stock WOW_SetBossThreatForPlayer(bossid, playerid, threat) {
	if(WOW_IsValidBoss(bossid)) {
		if(threat < 0) {
		    threat = 0;
		} else if(threat > 2147483647) { //max integer
		    threat = 2147483647;
		}
	    new bool:playerValid = true;
	    new bool:playerStreamedIn = true;
        if(!WOW_IsBossValidForPlayer(playerid, bossid)) {
        	playerValid = false;
        }
        if(!IsPlayerStreamedIn(WOW_Bosses[bossid][NPCID], playerid)) {
            playerStreamedIn = false;
        }
		if(playerValid && playerStreamedIn) {
			WOW_Bosses[bossid][THREAT][playerid] = threat;
			//Get highest threat player
			new highestThreat = 0;
			new highestThreatPlayer = INVALID_PLAYER_ID;
			new otherplayerThreat;
			for(new otherplayerid = 0, playerCount = GetPlayerPoolSize(); otherplayerid <= playerCount; otherplayerid++) {
			    otherplayerThreat = WOW_Bosses[bossid][THREAT][otherplayerid];
			    if(WOW_IsBossValidForPlayer(otherplayerid, bossid) && IsPlayerStreamedIn(WOW_Bosses[bossid][NPCID], otherplayerid) && (highestThreatPlayer == INVALID_PLAYER_ID || otherplayerThreat > highestThreat)) {
			        highestThreat = otherplayerThreat;
			        highestThreatPlayer = otherplayerid;
			    }
			}
	        //Switch target
			WOW_SetBossTargetWithReason(bossid, highestThreatPlayer, 0); //TODO reason
			return 1;
		}
	}
	return 0;
}
//TODO player becomes invalid, streams out => reset threat
//TODO onplayergetaggro threat reason
//TODO overflow, meerdere spelers op max
//TODO withreason: reason 1, 3, 4
