stock WOW_DamageBoss(bossid, damagerid, Float:amount) {
			WOW_SetBossTargetWithReason(bossid, damagerid, 1); //Called in WOW_SetBossThreatForPlayer
			//WOW_SetBossThreatForPlayer(bossid, damagerid, WOW_Bosses[bossid][THREAT][damagerid] + floatround(amount, floatround_floor); //Floor, because the next threat value hasn't been reached yet
			//TODO increase threat for damagerid and possibly switch target
}

public WOW_Update() {
				WOW_SetBossTargetWithReason(bossid, WOW_GetClosestPlayerToTakeAggro(bossid), 3);
				//TODO if first target, increase threat of closestPlayerid to undefined amount and set target
				//TODO if not first target, set target to player with highest threat, if available, else set closestPlayerid
}

stock WOW_SetBossAggroRange(bossid, Float:range, bool:checkForTarget = false) {
				//Reset target
				WOW_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0);
				//TODO again, swith to player with highest threat and in range
}

stock WOW_SetBossAllowNPCTargets(bossid, bool:allowNPCTargets, bool:checkForTarget = false) {
				//Reset target
				WOW_SetBossTargetWithReason(bossid, INVALID_PLAYER_ID, 0);
				//TODO again, switch to player (not NPC) with highest threat
}

stock WOW_SetBossTarget(bossid, playerid, bool:checkForAggroRange = false) {
	return WOW_SetBossTargetWithReason(bossid, playerid, 4, checkForAggroRange);
	//TODO what to do with threat?
}

/*
Reason:
- 0: reset (invalid new target)
- 1: bossDamaged (valid new target, invalid new target)
- 2: bossDeath (invalid new target)
- 3: target aggro (valid new target, invalid new target)
- 4: explicit set (valid new target, invalid new target, checkForAggroRange)
*/
static WOW_SetBossTargetWithReason(bossid, newtargetid, reason, bool:checkForAggroRange = false) {
}

//TODO SCENARIO'S:
/*
SCENARIO 1:
- Boss is idle
- Alle spelers hebben geen threat
- Een speler komt in aggro range
==> Zet threat van die speler op voorbepaalde waarde
==> Die speler wordt target

SCENARIO 2:
- Boss is idle
- Alle spelers hebben geen threat
- Een speler damaged de boss van ver
==> Zet threat van die speler op voorbepaalde waarde
==> Die speler wordt target

SCENARIO 3:
- Boss is niet idle
- 1 speler heeft threat, alle andere hebben geen threat
- De speler wordt invalid voor de boss of streamed out voor de boss
==> Zoek speler met 2e hoogste threat
==> Vindt niemand (INVALID_PLAYER_ID)
==> Zoek dichtst bijzijnde speler in aggro range
==> Vindt niemand (INVALID_PLAYER_ID), dus stop encounter

SCENARIO 4:
- Boss is niet idle
- 1 speler heeft threat, alle andere hebben geen threat
- De speler wordt invalid voor de boss of streamed out voor de boss
==> Zoek speler met 2e hoogste threat
==> Vindt niemand (INVALID_PLAYER_ID)
==> Zoek dichtst bijzijnde speler in aggro range
==> Vindt een speler
==> Zet threat van die speler op voorbepaalde waarde
==> Die speler wordt target

SCENARIO 5:
- Boss is niet idle
- 1 speler heeft threat, alle andere hebben geen threat
- De speler wordt invalid voor de boss of streamed out voor de boss
==> Zoek speler met 2e hoogste threat
==> Vindt een speler
==> Zet threat van die speler op voorbepaalde waarde
==> Die speler wordt target

SCENARIO 6:
- Boss is niet idle
- 1 speler heeft threat, alle andere hebben geen threat
- De speler damaged de boss
==> Verhoog de threat van die speler met de damage amount

SCENARIO 7:
- Boss is niet idle
- 1 speler heeft threat, alle andere hebben geen threat
- Een speler zonder threat damaged de boss
==> Verhoog de threat van die speler met de damage amount

SCENARIO 8:
- Boss is niet idle
- Meerdere spelers hebben threat, alle andere hebben geen threat
- De speler met hoogste threat wordt invalid voor de boss of streamed out voor de boss
==> Zoek speler met 2e hoogste threat
==> Vindt een speler
==> Threat van die speler moet niet verhogen
==> Die speler wordt target
*/
stock WOW_GetBossThreatForPlayer(bossid, playerid) {
	if(WOW_IsValidBoss(bossid) && playerid >= 0 && playerid < MAX_PLAYERS) {
		return WOW_Bosses[bossid][THREAT][playerid];
	}
	return -1;
}
stock WOW_SetBossThreatForPlayer(bossid, playerid, threat, bool:checkForAggroRange = false) {
	if(WOW_IsValidBoss(bossid)) {
		new oldthreat = WOW_Bosses[bossid][THREAT][playerid];
		if(threat < 0) {
		    threat = 0;
		} else if(threat > 2147483647) { //max integer
		    threat = 2147483647;
		}
		if(oldthreat != threat) {
		    new bool:playerValid = true;
		    new bool:playerStreamedIn = true;
	        if(!WOW_IsBossValidForPlayer(playerid, bossid)) {
	        	playerValid = false;
	        }
	        if(!IsPlayerStreamedIn(WOW_Bosses[bossid][NPCID], playerid)) {
	            playerStreamedIn = false;
	        }
	        new bool:playerInRange = true;
	        if(checkForAggroRange && !WOW_IsPlayerInAggroRange(playerid, bossid)) {
		        newTargetInRange = false;
		    }
			if(playerValid && playerStreamedIn && playerInRange) {
				WOW_Bosses[bossid][THREAT][playerid] = threat;
			    if(threat < oldthreat) {
			    	CallRemoteFunction("WOW_OnPlayerDecreaseThreat", "ddd", playerid, bossid, oldthreat - threat);
			    } else if (threat > oldthreat) {
			    	CallRemoteFunction("WOW_OnPlayerIncreaseThreat", "ddd", playerid, bossid, threat - oldthreat);
			    }
				if((threat < oldthreat && playerid == WOW_Bosses[bossid][TARGET]) || (threat > oldthreat && playerid != WOW_Bosses[bossid][TARGET])) {
					new highestPlayer = WOW_GetPlayerWithHighestThreat(bossid);
		    	    if(highestPlayer != WOW_Bosses[bossid][TARGET]) {
						WOW_SetBossTargetWithReason(bossid, highestPlayer, 0); //TODO reason en reason bij INVALID_PLAYER_ID (zie stream out gedoe)
		    	    }
				}
			    
			    //TODO 2 callbacks ook bij reset zetten?
			    //TODO threat = 0
			    //TODO threat is nog steeds hoogste, dus zelfde target
			    //TODO nieuwe speler met hoogste threat zoeken, ook o.b.v. aggro range?
			    //TODO stel allemaal hoogst mogelijke threat value (evetueel oplossen door alleen het target dan de hoogst mogelijke threat te laten en de rest 1 minder)
				return 1;
			}
		}
	}
	return 0;
}
static WOW_GetPlayerWithHighestThreat(bossid) {
	new highestPlayer = INVALID_PLAYER_ID;
	new highestPlayerThreat = 0;
	if(WOW_IsValidBoss(bossid)) {
		for(new playerid = 0, playerCount = GetPlayerPoolSize(); playerid <= playerCount; playerid++) {
		    if(WOW_IsBossValidForPlayer(playerid, bossid) && WOW_Bosses[bossid][THREAT][playerid] > 0 && (!IsPlayerNPC(playerid) || WOW_Bosses[bossid][ALLOW_NPC_TARGETS])) {
		        //TODO WOW_IsPlayerInAggroRange(playerid, bossid)
		        //TODO IsPlayerStreamedIn(WOW_Bosses[bossid][NPCID], playerid)
		  		if(highestPlayer == INVALID_PLAYER_ID || WOW_Bosses[bossid][THREAT][playerid] > highestPlayerThreat) {
			        highestPlayerThreat = WOW_Bosses[bossid][THREAT][playerid];
			        highestPlayer = playerid;
				}
			}
		}
	}
	return highestPlayer;
}
//TODO gebruik de onstreamout callback, niet de isplayerstreamedin functie (of toch niet, want dan kan het encounter vroegtijdig stoppen)
//TODO check over gebruik van aggro en streamedin en of streamedin eventueel kan toegevoegd worden in de getclosest methoden
//TODO alles van threat nakijken (soms mag de threat niet zomaar gereset worden, bv bij aggro range beter de volgende hoogste threat nemen als er een is)
//TODO check waar er overal settargetwithreason staat en kijk of het nog goed gaat werken
//TODO check waar er overal gewoon settarget staat en kijk of het nog goed gaat werken
//TODO player becomes invalid, streams out => reset threat
//TODO onplayergetaggro threat reason
//TODO overflow, meerdere spelers op max
//TODO withreason: reason 1, 3, 4
//TODO 2 callbacks in examples zetten en in samengesteld WOW bestand
stock WOW_ResetBossThreatForAll(bossid) {
	if(WOW_IsValidBoss(bossid)) {
		for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) { //Don't use GetPlayerPoolSize, because we need to reset all variables
			WOW_Bosses[bossid][THREAT][playerid] = 0;
		}
		return 1;
	}
	return 0;
}
//TODO opnieuw problemen, wanneer wordt het encounter nu gestopt bijvoorbeeld
//TODO ook threat callback oproepen? of enkel als de value verandert?
