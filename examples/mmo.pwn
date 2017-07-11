/*
 * License:
 * See LICENSE.md included in the release download, or at https://github.com/WoutProvost/FCNPC-A.I./blob/master/LICENSE.md if not included.

 * Credits:
 * See CREDITS.md included in the release download, or at https://github.com/WoutProvost/FCNPC-A.I./blob/master/CREDITS.md if not included.
*/

#define FILTERSCRIPT

#define FAI_USE_MAP_ANDREAS             true //Redefinition before #include <FAI>

#define FAI_DECIMAL_MARK                ',' //Redefinition before #include <FAI>
#include <FAI>

#define USE_STREAMER    true //Set this to false, if you don't use Incognito's streamer. This example script uses this streamer to create dynamic pickups and objects
#if USE_STREAMER == true
	#include <streamer>
#endif
#define INTERIOR_NORMAL             	0
#define VIRTUAL_WORLD_NORMAL        	0

new BossBigSmoke = FAI_INVALID_BOSS_ID;
new SpellCarpetOfFire = FAI_INVALID_SPELL_ID;
new SpellWallOfFire = FAI_INVALID_SPELL_ID;
new SpellMarkOfDeath = FAI_INVALID_SPELL_ID;
new SpellNoPlaceIsSafe = FAI_INVALID_SPELL_ID;
new SpellFlightOfTheBumblebee = FAI_INVALID_SPELL_ID;
new SpellRockOfLife = FAI_INVALID_SPELL_ID;
new SpellSummonAdds = FAI_INVALID_SPELL_ID;
new BossIdleMessageTimer = FAI_INVALID_TIMER_ID; //3 purpose timer: works as an idle message timer when he is spawned but an encounter hasn't started, works as a respawn timer when he is dead, works as a casting timer during an encounter
new BossExecuteSpellCount = 0;
new Float:BossTargetNotMovingPos[3] = {0.0, ...};
new BossTargetNotMovingObject = INVALID_OBJECT_ID;
new BossTargetNotMovingTimer = FAI_INVALID_TIMER_ID;
new BossBigSmokeHealthState = 100;
new RewardPickups[500] = {-1, ...};
//Some variables, shared by all spells created in this script
//Don't do this if you want spells to be able to be cast at the same time (by different bosses).
//This script (created for demonstration purposes) uses only 1 boss who can obviously cast only 1 spell at a time, so it doesn't really matter.
//In this case GroundMarks and Bombs have an equal size, so we can handle everything in the same loop
new GroundMarks[20] = {INVALID_OBJECT_ID, ...};
new Bombs[20] = {INVALID_OBJECT_ID, ...};
new ExplosionTimer = FAI_INVALID_TIMER_ID;
new ExplosionCount = 0;
new BossAdds[2] = {FAI_INVALID_BOSS_ID, ...};
new SpellRockOfLifeTarget = INVALID_PLAYER_ID;

#if defined FILTERSCRIPT
public OnFilterScriptInit()
{
	BossBigSmoke = FAI_CreateBoss("BossBigSmoke");
	FAI_SetBossFullName(BossBigSmoke, "Melvin \"Big Smoke\" Harris");
	FAI_SetBossMapiconInfo(BossBigSmoke, 65, 8);
 	FAI_SetBossMaxHealth(BossBigSmoke, 5000.0);
 	FAI_SetBossDisplayRange(BossBigSmoke, 100.0);
	FAI_SetBossMoveInfo(BossBigSmoke, MOVE_TYPE_SPRINT, MOVE_SPEED_AUTO, true);
	FAI_SetBossAllowNPCTargets(BossBigSmoke, false);
	FAI_SetBossBehaviour(BossBigSmoke, FAI_BOSS_BEHAVIOUR_UNFRIENDLY);
	SetBossAtSpawn(BossBigSmoke);
    SpellCarpetOfFire = FAI_CreateSpell("Carpet of Fire");
    SpellWallOfFire = FAI_CreateSpell("Wall of Fire");
    SpellMarkOfDeath = FAI_CreateSpell("Mark of Death");
    FAI_SetSpellCastTime(SpellMarkOfDeath, 0);
	SpellNoPlaceIsSafe = FAI_CreateSpell("No place is safe");
	FAI_SetSpellCastTime(SpellNoPlaceIsSafe, 20000);
	FAI_SetSpellCastBarColorDark(SpellNoPlaceIsSafe, 0x645005ff);
	FAI_SetSpellCastBarColorLight(SpellNoPlaceIsSafe, 0xb4820aff);
	FAI_SetSpellCastBarInverted(SpellNoPlaceIsSafe, true);
	FAI_SetSpellCastTimeInverted(SpellNoPlaceIsSafe, true);
	SpellFlightOfTheBumblebee = FAI_CreateSpell("Flight of the Bumblebee");
    FAI_SetSpellCastTime(SpellFlightOfTheBumblebee, 2000);
	FAI_SetSpellCastBarColorDark(SpellFlightOfTheBumblebee, 0x3333ccff);
	FAI_SetSpellCastBarColorLight(SpellFlightOfTheBumblebee, 0x6699ffff);
	SpellRockOfLife = FAI_CreateSpell("Rock of Life");
    FAI_SetSpellCastTime(SpellRockOfLife, 5000);
	FAI_SetSpellCastBarColorDark(SpellRockOfLife, 0x00cc66ff);
	FAI_SetSpellCastBarColorLight(SpellRockOfLife, 0x00ff99ff);
	SpellSummonAdds = FAI_CreateSpell("Summon Adds");
    FAI_SetSpellCastTime(SpellSummonAdds, 6000);
	FAI_SetSpellCastBarColorDark(SpellSummonAdds, 0x800080ff);
	FAI_SetSpellCastBarColorLight(SpellSummonAdds, 0xda70d6ff);
	for(new add = 0, addCount = sizeof(BossAdds); add < addCount; add++) {
		new name[MAX_PLAYER_NAME + 1];
		format(name, sizeof(name), "BossBigSmokeAdd%d", add);
		BossAdds[add] = FAI_CreateBoss(name);
		FAI_SetBossAggroRange(BossAdds[add], 1000.0);
		FAI_SetBossBehaviour(BossAdds[add], FAI_BOSS_BEHAVIOUR_FRIENDLY);
		FAI_SetBossMoveInfo(BossAdds[add], MOVE_TYPE_AUTO, MOVE_SPEED_AUTO, true);
		FAI_SetBossAllowNPCTargets(BossAdds[add], false);
		new npcid = FAI_GetBossNPCID(BossAdds[add]);
		SetPlayerColor(npcid, 0xffffff00);
		FCNPC_Spawn(npcid, 0, 1086.9752, 1074.7021, -50.0);
		FCNPC_SetInterior(npcid, INTERIOR_NORMAL);
		FCNPC_SetVirtualWorld(npcid, VIRTUAL_WORLD_NORMAL);
	}
	return 1;
}

public OnFilterScriptExit()
{
	//The include will automatically destroy the spells and bosses when the script exits
	//When a boss gets destroyed, OnPlayerDisconnect will be called, so we can safely put everything that should be destroyed along with the boss there
	return 1;
}
#endif

public OnPlayerDisconnect(playerid, reason)
{
	new bossid = FAI_GetBossIDFromNPCID(playerid);
	if(bossid != FAI_INVALID_BOSS_ID) {
		if(bossid == BossBigSmoke) {
			//FAI_DestroyBoss(BossBigSmoke); //We don't need to do this, since the boss is already disconnecting
			BossBigSmoke = FAI_INVALID_BOSS_ID;
		    //We still need to destroy the spells, since it is possible that the boss is just disconnecting and the script isn't exiting and we want that the spells destroy along with the boss
			FAI_DestroySpell(SpellCarpetOfFire);
			SpellCarpetOfFire = FAI_INVALID_SPELL_ID;
			FAI_DestroySpell(SpellNoPlaceIsSafe);
			SpellNoPlaceIsSafe = FAI_INVALID_SPELL_ID;
			FAI_DestroySpell(SpellWallOfFire);
			SpellWallOfFire = FAI_INVALID_SPELL_ID;
			FAI_DestroySpell(SpellMarkOfDeath);
			SpellMarkOfDeath = FAI_INVALID_SPELL_ID;
			FAI_DestroySpell(SpellFlightOfTheBumblebee);
			SpellFlightOfTheBumblebee = FAI_INVALID_SPELL_ID;
			FAI_DestroySpell(SpellRockOfLife);
			SpellRockOfLife = FAI_INVALID_SPELL_ID;
			FAI_DestroySpell(SpellSummonAdds);
			SpellSummonAdds = FAI_INVALID_SPELL_ID;
			for(new groundMark = 0, groundMarkCount = sizeof(GroundMarks); groundMark < groundMarkCount; groundMark++) {
				#if USE_STREAMER == false
				    DestroyObject(GroundMarks[groundMark]);
				    DestroyObject(Bombs[groundMark]);
			    #else
					DestroyDynamicObject(GroundMarks[groundMark]);
					DestroyDynamicObject(Bombs[groundMark]);
				#endif
				GroundMarks[groundMark] = INVALID_OBJECT_ID;
				Bombs[groundMark] = INVALID_OBJECT_ID;
			}
			KillTimer(ExplosionTimer);
			ExplosionTimer = FAI_INVALID_TIMER_ID;
			ExplosionCount = 0;
			for(new add = 0, addCount = sizeof(BossAdds); add < addCount; add++) {
				FAI_DestroyBoss(BossAdds[add]); //Destroy the adds when their master gets destroyed
				BossAdds[add] = FAI_INVALID_BOSS_ID;
			}
			KillTimer(BossIdleMessageTimer);
			BossIdleMessageTimer = FAI_INVALID_TIMER_ID;
			BossExecuteSpellCount = 0;
			BossTargetNotMovingPos[0] = 0.0;
			BossTargetNotMovingPos[1] = 0.0;
			BossTargetNotMovingPos[2] = 0.0;
			KillTimer(BossTargetNotMovingTimer);
			BossTargetNotMovingTimer = FAI_INVALID_TIMER_ID;
			#if USE_STREAMER == false
				DestroyObject(BossTargetNotMovingObject);
			#else
				DestroyDynamicObject(BossTargetNotMovingObject);
			#endif
			BossTargetNotMovingObject = INVALID_OBJECT_ID;
			BossBigSmokeHealthState = 0;
			for(new rewardPickup = 0, rewardPickupCount = sizeof(RewardPickups); rewardPickup < rewardPickupCount; rewardPickup++) {
			    #if USE_STREAMER == false
			    	DestroyPickup(RewardPickups[rewardPickup]);
			    #else
			    	DestroyDynamicPickup(RewardPickups[rewardPickup]);
			    #endif
			    RewardPickups[rewardPickup] = -1;
			}
			if(SpellRockOfLifeTarget != INVALID_PLAYER_ID) {
			    SpellRockOfLifeEnd(SpellRockOfLifeTarget);
				SpellRockOfLifeTarget = INVALID_PLAYER_ID;
			}
		} else {
			for(new add = 0, addCount = sizeof(BossAdds); add < addCount; add++) {
				if(bossid == BossAdds[add]) {
				    //FAI_DestroyBoss(BossAdds[add]); //We don't need to do this, since the add is already disconnecting
					BossAdds[add] = FAI_INVALID_BOSS_ID;
				    break;
				}
			}
		}
	}
	return 1;
}

public FCNPC_OnSpawn(npcid)
{
	BossYellSpawnMessage(npcid);
	return 1;
}

public FCNPC_OnRespawn(npcid)
{
	BossYellSpawnMessage(npcid);
	return 1;
}

public FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss)
{
	new bossid = FAI_GetBossIDFromNPCID(npcid);
	if(bossid != FAI_INVALID_BOSS_ID) {
		if(bossid == BossBigSmoke) {
      /*
			BossBigSmokeHealthState: we need to use this since there is a setCurrentHealth mechanic
			- Say: boss gets damaged to 90% health => Make boss yell because he is past a certain health amount
			- Next: some healing spell heals the boss to 95%
			- Next: boss gets damaged to 90%, we don't want to call make the boss yell again because he passed the same point
   */
			new BossHealthPercent = FAI_GetBossCurrentHealthPercent(bossid);
			if(BossHealthPercent < BossBigSmokeHealthState && FAI_GetBossBehaviour(bossid) != FAI_BOSS_BEHAVIOUR_FRIENDLY) {
				BossBigSmokeHealthState = BossHealthPercent;
				switch(BossBigSmokeHealthState) {
					case 90: {BossYell(bossid, "Fry, motherfuckers", 35713); ExecuteSpell(bossid);}
					case 80: {BossYell(bossid, "All kinds of crazy cats out there want a piece of me", 33301); ExecuteSpell(bossid);}
					case 60: {BossYell(bossid, "This guy is really getting on my fucking nerves", 35224); ExecuteSpell(bossid);}
					case 40: {BossYell(bossid, "Somebody save the Smoke", 33303); ExecuteSpell(bossid);}
					case 20: {BossYell(bossid, "Shoot him! Help me", 33302); ExecuteSpell(bossid);}
				}
			}
			//Reduce cast progress a bit when damaged
			if(FAI_IsBossCastingSpell(bossid, SpellFlightOfTheBumblebee)) {
			    FAI_SetBossCastingProgress(bossid, FAI_GetBossCastingProgress(bossid) - floatround(health_loss, floatround_floor));
			}
		}
	}
	return 1;
}

#if USE_STREAMER == false
	public OnPlayerPickUpPickup(playerid, pickupid)
	{
		for(new rewardPickup = 0, rewardPickupCount = sizeof(RewardPickups); rewardPickup < rewardPickupCount; rewardPickup++) {
			if(pickupid == RewardPickups[rewardPickup]) {
			    GivePlayerMoney(playerid, 100);
			    DestroyPickup(RewardPickups[rewardPickup]);
		    	RewardPickups[rewardPickup] = -1;
			    break;
		    }
		}
		return 1;
	}
#else
	public OnPlayerPickUpDynamicPickup(playerid, pickupid)
	{
		for(new rewardPickup = 0, rewardPickupCount = sizeof(RewardPickups); rewardPickup < rewardPickupCount; rewardPickup++) {
			if(pickupid == RewardPickups[rewardPickup]) {
			    GivePlayerMoney(playerid, 100);
			    DestroyDynamicPickup(RewardPickups[rewardPickup]);
		    	RewardPickups[rewardPickup] = -1;
			    break;
		    }
		}
		return 1;
	}
#endif

public FAI_OnBossEncounterStart(bossid, bool:reasonShot, firstTarget)
{
	if(bossid == BossBigSmoke) {
	    //The boss encounter started because a player came in his aggro range
	    if(!reasonShot) {
			BossYell(bossid, "Here we go", 35848);
		}
	    //The boss encounter started because the boss was shot
		else {
			BossYell(bossid, "Hey, I'm a motherfucking celebrity", 33300);
		}
		KillTimer(BossIdleMessageTimer);
		//Cast a spell somewhere between 10 and 20 seconds (both included)
		BossExecuteSpellCount = 0;
		GetPlayerPos(firstTarget, BossTargetNotMovingPos[0], BossTargetNotMovingPos[1], BossTargetNotMovingPos[2]);
		BossIdleMessageTimer = SetTimerEx("TargetNotMovingCheck", 1000, true, "ii", bossid, random(11) + 10);
	}
	return 1;
}

public FAI_OnBossEncounterStop(bossid, bool:reasonDeath, lastTarget)
{
	if(bossid == BossBigSmoke) {
		if(!reasonDeath) {
		    //The boss encounter ended because his target died and there were no more other players in his aggro range
		    if(GetPlayerState(lastTarget) == PLAYER_STATE_WASTED) {
				BossYell(bossid, "The business at hand, motherfucker, the business at hand", 37618);
			}
		    //The boss encounter ended because his target escaped and there were no more other players in his aggro range
			else {
				BossYell(bossid, "Man, I'm done", 35214);
			}
			//Respawn the boss to his starting position and refill his health
			SetBossAtSpawn(bossid);
		}
	    //The boss encounter ended because the boss died
		else {
  			BossYell(bossid, "I wish I'd have stayed home and watched the fucking game", 15891);
			//Reward for killing the boss
			new Float:bossX, Float:bossY, Float:bossZ, Float:cashX, Float:cashY, Float:cashZ, Float:radius, Float:angle;
			new bossplayerid = FAI_GetBossNPCID(bossid);
			#if USE_STREAMER == true
				new bossInterior = FCNPC_GetInterior(bossplayerid);
			#endif
			new bossWorld = FCNPC_GetVirtualWorld(bossplayerid);
			FCNPC_GetPosition(bossplayerid, bossX, bossY, bossZ);
			for(new rewardPickup = 0, rewardPickupCount = sizeof(RewardPickups); rewardPickup < rewardPickupCount; rewardPickup++) {
			    radius = RandomFloatGivenInteger(10);
			    angle = RandomFloatGivenInteger(360);
				cashX = bossX + (radius * floatcos(angle + 90, degrees));
				cashY = bossY + (radius * floatsin(angle + 90, degrees));
                #if FAI_USE_MAP_ANDREAS == true
					MapAndreas_FindZ_For2DCoord(cashX, cashY, cashZ);
				#endif
				#if USE_STREAMER == false
			    	DestroyPickup(RewardPickups[rewardPickup]);
					RewardPickups[rewardPickup] = CreatePickup(1212, 19, cashX, cashY, cashZ + 0.1, bossWorld);
				#else
				    DestroyDynamicPickup(RewardPickups[rewardPickup]);
					RewardPickups[rewardPickup] = CreateDynamicPickup(1212, 19, cashX, cashY, cashZ + 0.1, bossWorld, bossInterior);
				#endif
			}
			KillTimer(BossIdleMessageTimer);
  			//Respawn the boss somewhere between 5 and 10 minutes (both included)
  			new randomMinutes = random(6) + 5;
			BossIdleMessageTimer = SetTimerEx("SetBossAtSpawn", 1000 * 60 * randomMinutes, false, "d", bossid);
		}
		BossExecuteSpellCount = 0;
		BossTargetNotMovingPos[0] = 0.0;
		BossTargetNotMovingPos[1] = 0.0;
		BossTargetNotMovingPos[2] = 0.0;
		KillTimer(BossTargetNotMovingTimer);
		BossTargetNotMovingTimer = FAI_INVALID_TIMER_ID;
		#if USE_STREAMER == false
			DestroyObject(BossTargetNotMovingObject);
		#else
			DestroyDynamicObject(BossTargetNotMovingObject);
		#endif
		BossTargetNotMovingObject = INVALID_OBJECT_ID;
		for(new groundMark = 0, groundMarkCount = sizeof(GroundMarks); groundMark < groundMarkCount; groundMark++) {
			#if USE_STREAMER == false
			    DestroyObject(GroundMarks[groundMark]);
			    DestroyObject(Bombs[groundMark]);
		    #else
				DestroyDynamicObject(GroundMarks[groundMark]);
				DestroyDynamicObject(Bombs[groundMark]);
			#endif
			GroundMarks[groundMark] = INVALID_OBJECT_ID;
			Bombs[groundMark] = INVALID_OBJECT_ID;
		}
		KillTimer(ExplosionTimer);
		ExplosionTimer = FAI_INVALID_TIMER_ID;
		ExplosionCount = 0;
		for(new add = 0, addCount = sizeof(BossAdds); add < addCount; add++) {
		    if(BossAdds[add] != FAI_INVALID_BOSS_ID) {
				new npcid = FAI_GetBossNPCID(BossAdds[add]);
				SetPlayerColor(npcid, 0xffffff00);
				FCNPC_SetPosition(npcid, 1086.9752, 1074.7021, -50.0);
				FAI_SetBossBehaviour(BossAdds[add], FAI_BOSS_BEHAVIOUR_FRIENDLY);
			}
		}
		if(SpellRockOfLifeTarget != INVALID_PLAYER_ID) {
		    SpellRockOfLifeEnd(SpellRockOfLifeTarget);
			SpellRockOfLifeTarget = INVALID_PLAYER_ID;
		}
	} else {
		for(new add = 0, addCount = sizeof(BossAdds); add < addCount; add++) {
			if(BossAdds[add] != FAI_INVALID_BOSS_ID && bossid == BossAdds[add]) {
				new npcid = FAI_GetBossNPCID(bossid);
				SetPlayerColor(npcid, 0xffffff00);
				FCNPC_SetPosition(npcid, 1086.9752, 1074.7021, -50.0);
				FAI_SetBossBehaviour(bossid, FAI_BOSS_BEHAVIOUR_FRIENDLY);
			    break;
			}
		}
	}
	return 1;
}

public FAI_OnPlayerGetAggro(playerid, bossid)
{
	if(bossid == BossBigSmoke) {
		new bossPlayerColor = GetPlayerColor(FAI_GetBossNPCID(bossid));
		new string[144 + 1], fullName[FAI_MAX_BOSS_FULL_NAME + 1];
		FAI_GetBossFullName(bossid, fullName, sizeof(fullName));
		format(string, sizeof(string), "{%06x}[Boss] %s whispers:{%06x} Come here, I will get you!", bossPlayerColor >>> 8, fullName, 0xffffffff >>> 8);
		SendClientMessage(playerid, -1, string);
	}
	return 1;
}

public FAI_OnPlayerLoseAggro(playerid, bossid)
{
	if(bossid == BossBigSmoke) {
		new bossPlayerColor = GetPlayerColor(FAI_GetBossNPCID(bossid));
		new string[144 + 1], fullName[FAI_MAX_BOSS_FULL_NAME + 1];
		FAI_GetBossFullName(bossid, fullName, sizeof(fullName));
		format(string, sizeof(string), "{%06x}[Boss] %s whispers:{%06x} Maybe next time when our paths cross...", bossPlayerColor >>> 8, fullName, 0xffffffff >>> 8);
		SendClientMessage(playerid, -1, string);
	}
	return 1;
}

public FAI_OnBossStartCasting(bossid, spellid, targetid)
{
	if(bossid == BossBigSmoke) {
	    new bossplayerid = FAI_GetBossNPCID(bossid);
		FCNPC_ApplyAnimation(bossplayerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 1, 1, 0, 0);
		if(spellid == SpellCarpetOfFire) {
		    new spellCastTime = FAI_GetSpellCastTime(spellid);
			new Float:bossX, Float:bossY, Float:bossZ, Float:markX, Float:markY, Float:markZ, Float:radius, Float:angle, Float:bombHeight = 50.0;
			#if USE_STREAMER == true
				new bossInterior = FCNPC_GetInterior(bossplayerid);
				new bossWorld = FCNPC_GetVirtualWorld(bossplayerid);
			#endif
		    FCNPC_GetPosition(bossplayerid, bossX, bossY, bossZ);
			for(new groundMark = 0, groundMarkCount = sizeof(GroundMarks); groundMark < groundMarkCount; groundMark++) {
			    radius = RandomFloatGivenInteger(50) + 1.0;
			    angle = RandomFloatGivenInteger(360);
				markX = bossX + (radius * floatcos(angle + 90, degrees));
				markY = bossY + (radius * floatsin(angle + 90, degrees));
                #if FAI_USE_MAP_ANDREAS == true
		    		MapAndreas_FindZ_For2DCoord(markX, markY, markZ);
			    	//For positions under bridges, ..., should be replaced with a ColAndreas implementation for better results
			    	//With MapAndreas: problem with small height changes
			  	 	//if(bossZ < markZ) {
				 	//    markZ = bossZ - 0.76;
				 	//}
		    	#endif
				#if USE_STREAMER == false
				 	DestroyObject(GroundMarks[groundMark]);
				 	GroundMarks[groundMark] = CreateObject(354, markX, markY, markZ - 2.0, 0.0, 0.0, 0.0);
					//Is only scriptable like this if GroundMarks and Bombs have an equal size
				 	DestroyObject(Bombs[groundMark]);
				 	Bombs[groundMark] = CreateObject(1636, markX, markY, markZ + bombHeight, 270.0, 0.0, 0.0);
				 	MoveObject(Bombs[groundMark], markX, markY, markZ, bombHeight/((spellCastTime)/1000));
				#else
				 	DestroyDynamicObject(GroundMarks[groundMark]); //If for some reason the previous groundMark wasn't destroyed
				 	GroundMarks[groundMark] = CreateDynamicObject(354, markX, markY, markZ - 2.0, 0.0, 0.0, 0.0, bossWorld, bossInterior); //markZ - 2.0 to lower the object below ground a bit, because the flare object that is used is very bright
					DestroyDynamicObject(Bombs[groundMark]); //If for some reason the previous bomb wasn't destroyed
				 	Bombs[groundMark] = CreateDynamicObject(1636, markX, markY, markZ + bombHeight, 270.0, 0.0, 0.0, bossWorld, bossInterior); //markZ + bombHeight to create the bomb 50.0 meters above the groundMark; rX = 270.0 to make the bomb point to the ground
					MoveDynamicObject(Bombs[groundMark], markX, markY, markZ, bombHeight/((spellCastTime)/1000)); //Move the bomb at a speed so that it will touch the ground when the boss finishes the cast
					StreamerUpdateForValidPlayers(bossid); //Make the streamer perform an update for every player that is in the same interior and world as the boss, so the objects will also appear to them if they are not moving
				#endif
			}
		}
		if(spellid == SpellWallOfFire) {
			new Float:bossX, Float:bossY, Float:bossZ, Float:bossA, Float:markX, Float:markY, Float:markZ, Float:radius;
			#if USE_STREAMER == true
				new bossInterior = FCNPC_GetInterior(bossplayerid);
				new bossWorld = FCNPC_GetVirtualWorld(bossplayerid);
			#endif
		    FCNPC_GetPosition(bossplayerid, bossX, bossY, bossZ);
		    bossA = FCNPC_GetAngle(bossplayerid);
			for(new groundMark = 19; groundMark >= 0; groundMark--) {
			    radius = 40.0 - 40.0 / 20 * groundMark;
				markX = bossX + (radius * floatcos(bossA + 90, degrees));
				markY = bossY + (radius * floatsin(bossA + 90, degrees));
                #if FAI_USE_MAP_ANDREAS == true
		    		MapAndreas_FindZ_For2DCoord(markX, markY, markZ);
		    	#endif
				#if USE_STREAMER == false
			 		DestroyObject(GroundMarks[groundMark]);
			 		GroundMarks[groundMark] = CreateObject(354, markX, markY, markZ - 2.0, 0.0, 0.0, 0.0);
			 	#else
				 	DestroyDynamicObject(GroundMarks[groundMark]);
				 	GroundMarks[groundMark] = CreateDynamicObject(354, markX, markY, markZ - 2.0, 0.0, 0.0, 0.0, bossWorld, bossInterior);
			 		StreamerUpdateForValidPlayers(bossid);
			 	#endif
			}
		}
		if(spellid == SpellMarkOfDeath) {
			if(targetid != INVALID_PLAYER_ID) {
				new Float:playerX, Float:playerY, Float:playerZ;
			  	GetPlayerPos(targetid, playerX, playerY, playerZ);
                #if FAI_USE_MAP_ANDREAS == true
			  		MapAndreas_FindZ_For2DCoord(playerX, playerY, playerZ);
			  	#endif
				#if USE_STREAMER == false
			 		DestroyObject(BossTargetNotMovingObject);
			 		BossTargetNotMovingObject = CreateObject(354, playerX, playerY, playerZ - 2.0, 0.0, 0.0, 0.0);
			 	#else
					DestroyDynamicObject(BossTargetNotMovingObject);
					BossTargetNotMovingObject = CreateDynamicObject(354, playerX, playerY, playerZ - 2.0, 0.0, 0.0, 0.0, FCNPC_GetVirtualWorld(bossplayerid), FCNPC_GetInterior(bossplayerid));
			 		StreamerUpdateForValidPlayers(bossid);
				#endif
				KillTimer(BossTargetNotMovingTimer);
				BossTargetNotMovingTimer = SetTimerEx("SpellMarkOfDeathExplosion", 1000, false, "d", bossid); //Different timer to avoid conflict with other spells
			 	SendTargetidStartCastMessage(targetid, bossid, spellid);
			}
		}
		if(spellid == SpellNoPlaceIsSafe) {
			ExplosionCount = 0;
			KillTimer(ExplosionTimer);
			ExplosionTimer = SetTimerEx("SpellNoPlaceIsSafeExplosion", 50, true, "dd", bossid, spellid);
		}
		if(spellid == SpellFlightOfTheBumblebee) {
			 SendTargetidStartCastMessage(targetid, bossid, spellid);
		}
		if(spellid == SpellRockOfLife) {
			 SendTargetidStartCastMessage(targetid, bossid, spellid);
		}
		if(spellid == SpellSummonAdds) {
		    new currentAddCount = 0;
		    for(new add = 0, addCount = sizeof(BossAdds); add < addCount; add++) {
		        //If the add is not available, count as used
		        if(BossAdds[add] == FAI_INVALID_BOSS_ID) {
		            currentAddCount++;
		        }
		        //If the add is available, count as used when above -45.0 z position
				else {
				    new Float:x, Float:y, Float:z;
				    FCNPC_GetPosition(FAI_GetBossNPCID(BossAdds[add]), x, y, z);
				    if(z > -45.0) {
				    	currentAddCount++;
				    }
		        }
		    }
		    //Only show the message when we are actually able to spawn adds
		    if(currentAddCount != sizeof(BossAdds)) {
				BossYell(bossid, "Back me up", 35648);
		    }
		}
	}
	return 1;
}

public FAI_OnBossStopCasting(bossid, spellid, targetid, bool:castComplete)
{
	if(bossid == BossBigSmoke) {
	    new bossplayerid = FAI_GetBossNPCID(bossid);
		FCNPC_ClearAnimations(bossplayerid);
		if(spellid == SpellCarpetOfFire) {
			new Float:markX, Float:markY, Float:markZ;
			for(new groundMark = 0, groundMarkCount = sizeof(GroundMarks); groundMark < groundMarkCount; groundMark++) {
				#if USE_STREAMER == false
	   				//Destroy the objects allways
					GetObjectPos(GroundMarks[groundMark], markX, markY, markZ);
			 		DestroyObject(GroundMarks[groundMark]);
					//Is only scriptable like this if GroundMarks and Bombs have an equal size
			 		DestroyObject(Bombs[groundMark]);
			    #else
					GetDynamicObjectPos(GroundMarks[groundMark], markX, markY, markZ);
					DestroyDynamicObject(GroundMarks[groundMark]);
					DestroyDynamicObject(Bombs[groundMark]);
				#endif
				GroundMarks[groundMark] = INVALID_OBJECT_ID;
				Bombs[groundMark] = INVALID_OBJECT_ID;
				//Only create the explosions if the boss was able to finish the cast
				if(castComplete) {
					CreateExplosionForValidPlayers(bossid, markX, markY, markZ);
				}
			}
		}
		if(spellid == SpellWallOfFire) {
			if(castComplete) {
				ExplosionCount = 19;
				KillTimer(ExplosionTimer);
				ExplosionTimer = SetTimerEx("WallOfFireExplosion", 50, true, "d", bossid);
			} else {
				for(new groundMark = 19; groundMark >= 0; groundMark--) {
					#if USE_STREAMER == false
			 			DestroyObject(GroundMarks[groundMark]);
			 		#else
						DestroyDynamicObject(GroundMarks[groundMark]);
					#endif
					GroundMarks[groundMark] = INVALID_OBJECT_ID;
				}
			}
		}
		if(spellid == SpellNoPlaceIsSafe) {
			ExplosionCount = 0;
			KillTimer(ExplosionTimer);
			ExplosionTimer = FAI_INVALID_TIMER_ID;
		}
		if(spellid == SpellFlightOfTheBumblebee) {
		    if(castComplete) {
				if(targetid != INVALID_PLAYER_ID) {
					new Float:playerX, Float:playerY, Float:playerZ;
				  	GetPlayerPos(targetid, playerX, playerY, playerZ);
				  	SetPlayerPos(targetid, playerX, playerY, playerZ + 10.0);
				}
			}
		}
		if(spellid == SpellRockOfLife) {
			if(castComplete) {
				if(targetid != INVALID_PLAYER_ID) {
					new Float:playerX, Float:playerY, Float:playerZ, Float:camX, Float:camY, Float:angle = RandomFloatGivenInteger(360), Float:radius = 20.0;
				  	GetPlayerPos(targetid, playerX, playerY, playerZ);
					TogglePlayerControllable(targetid, 0);
					#if USE_STREAMER == false
			 			DestroyObject(GroundMarks[0]);
			 			GroundMarks[0] = CreateObject(749, playerX, playerY, playerZ - 2.0, 0.0, 0.0, 0.0);
			 		#else
				  		DestroyDynamicObject(GroundMarks[0]);
						GroundMarks[0] = CreateDynamicObject(749, playerX, playerY, playerZ - 2.0, 0.0, 0.0, 0.0, FCNPC_GetVirtualWorld(bossplayerid), FCNPC_GetInterior(bossplayerid));
				 		StreamerUpdateForValidPlayers(bossid);
					#endif
					camX = playerX + (radius * floatcos(angle + 90, degrees));
					camY = playerY + (radius * floatsin(angle + 90, degrees));
				 	SetPlayerCameraPos(targetid, camX, camY, playerZ + 10.0);
				 	SetPlayerCameraLookAt(targetid, playerX, playerY, playerZ);
				 	SpellRockOfLifeTarget = targetid;
					KillTimer(ExplosionTimer);
					ExplosionTimer = SetTimerEx("SpellRockOfLifeEnd", 2000, false, "d", targetid);
				}
			}
		}
		if(spellid == SpellSummonAdds) {
		    if(castComplete) {
			    new currentAddCount = 0;
			    for(new add = 0, addCount = sizeof(BossAdds); add < addCount; add++) {
			    	//If the add is not available, count as used
			        if(BossAdds[add] == FAI_INVALID_BOSS_ID) {
			            currentAddCount++;
			        }
			        //If the add is available, count as used when above -45.0 z position
					else {
					    new Float:x, Float:y, Float:z;
					    FCNPC_GetPosition(FAI_GetBossNPCID(BossAdds[add]), x, y, z);
					    if(z > -45.0) {
					    	currentAddCount++;
					    } else {
					        new Float:BSX, Float:BSY, Float:BSZ, Float:addX, Float:addY, Float:addZ, Float:angle;
					        FCNPC_GetPosition(FAI_GetBossNPCID(BossBigSmoke), BSX, BSY, BSZ);
						    angle = RandomFloatGivenInteger(360);
							addX = BSX + (50.0 * floatcos(angle + 90, degrees));
							addY = BSY + (50.0 * floatsin(angle + 90, degrees));
						    #if FAI_USE_MAP_ANDREAS == true
								MapAndreas_FindZ_For2DCoord(addX, addY, addZ);
							#endif
				            new randomSkin = random(3) + 102;
				            new randomWeapon = random(2);
							new addplayerid = FAI_GetBossNPCID(BossAdds[add]);
							if(!FCNPC_IsSpawned(addplayerid)) {
							    FCNPC_Spawn(addplayerid, randomSkin, addX, addY, addZ + 1.0);
							} else {
								if(FCNPC_IsDead(addplayerid)) {
							    	FCNPC_Respawn(addplayerid);
							    }
								FCNPC_SetSkin(addplayerid, randomSkin);
								FCNPC_SetPosition(addplayerid, addX, addY, addZ + 1.0);
							}
							FCNPC_SetAngle(addplayerid, angle + 180);
							FCNPC_SetInterior(addplayerid, INTERIOR_NORMAL);
							FCNPC_SetVirtualWorld(addplayerid, VIRTUAL_WORLD_NORMAL);
							FCNPC_ToggleReloading(addplayerid, true);
							FCNPC_ToggleInfiniteAmmo(addplayerid, true);
							switch(randomWeapon) {
								case 0: {
									FCNPC_SetWeapon(addplayerid, WEAPON_UZI);
									FCNPC_SetWeaponSkillLevel(addplayerid, WEAPONSKILL_MICRO_UZI, 0);
									FCNPC_SetWeaponInfo(addplayerid, WEAPON_UZI, 1200, 200, 50, 0.5);
									FCNPC_SetAmmoInClip(addplayerid, 50);
									FCNPC_SetWeaponState(addplayerid, WEAPONSTATE_MORE_BULLETS);
								}
								case 1: {
							        FCNPC_SetWeapon(addplayerid, WEAPON_COLT45);
									FCNPC_SetWeaponSkillLevel(addplayerid, WEAPONSKILL_PISTOL, 0);
									FCNPC_SetWeaponInfo(addplayerid, WEAPON_COLT45, 1300, 160, 17, 0.5);
									FCNPC_SetAmmoInClip(addplayerid, 17);
									FCNPC_SetWeaponState(addplayerid, WEAPONSTATE_MORE_BULLETS);
								}
							}
							FCNPC_SetFightingStyle(addplayerid, FIGHT_STYLE_NORMAL);
							FCNPC_SetHealth(addplayerid, 100.0);
							FCNPC_SetArmour(addplayerid, 0.0);
							FCNPC_SetInvulnerable(addplayerid, false);
							FAI_SetBossMaxHealth(BossAdds[add], 100.0);
							FAI_SetBossCurrentHealth(BossAdds[add], 100.0);
							FAI_SetBossBehaviour(BossAdds[add], FAI_BOSS_BEHAVIOUR_UNFRIENDLY);
							SetPlayerColor(addplayerid, 0xb31a1eff);
					    }
			        }
				}
			    //Only show the message when we are actually able to spawn adds
			    if(currentAddCount != sizeof(BossAdds)) {
					BossYell(bossid, "What took you so long?", 35623);
			    }
		    }
		}
	}
	return 1;
}

forward TargetNotMovingCheck(bossid, randomSeconds);
public TargetNotMovingCheck(bossid, randomSeconds) {
	if(randomSeconds == BossExecuteSpellCount) {
		KillTimer(BossIdleMessageTimer);
		BossExecuteSpellCount = 0;
		new rand = random(2);
		switch(rand) {
		    case 0: {
		        //Execute normal spell
        		ExecuteSpell(bossid);
		    }
		    case 1: {
			    new currentAddCount = 0;
			    for(new add = 0, addCount = sizeof(BossAdds); add < addCount; add++) {
			        //If the add is not available, count as used
			        if(BossAdds[add] == FAI_INVALID_BOSS_ID) {
			            currentAddCount++;
			        }
			        //If the add is available, count as used when above -45.0 z position
					else {
					    new Float:x, Float:y, Float:z;
					    FCNPC_GetPosition(FAI_GetBossNPCID(BossAdds[add]), x, y, z);
					    if(z > -45.0) {
					    	currentAddCount++;
					    }
			        }
			    }
		        //Spawn add(s) if there is at least 1 add slot free
			    if(currentAddCount != sizeof(BossAdds)) {
					FAI_StartBossCastingSpell(bossid, SpellSummonAdds);
			    }
			    //Otherwise execute a normal spell
				else {
        			ExecuteSpell(bossid);
			    }
		    }
		}
		BossIdleMessageTimer = SetTimerEx("TargetNotMovingCheck", 1000, true, "ii", bossid, random(11) + 10);
	} else {
		BossExecuteSpellCount++;
	    //Make sure the boss's target doesn't stand still when the boss is not casting
	    new targetid = FAI_GetBossTarget(bossid);
	    new Float:x, Float:y, Float:z;
	    GetPlayerPos(targetid, x, y, z);
	    //2nd last part of condition: we don't need to cast the instant spell again when the previous explosion hasn't happened already
	    //Last part of condition: we don't need to cast the instant spell when another spell was stopped being cast, but the timer is still going on (like with RockOfLife)
	    if(BossTargetNotMovingPos[0] == x && BossTargetNotMovingPos[1] == y && BossTargetNotMovingPos[2] == z && BossTargetNotMovingTimer == FAI_INVALID_TIMER_ID && ExplosionTimer == FAI_INVALID_TIMER_ID) {
			FAI_StartBossCastingSpell(bossid, SpellMarkOfDeath, targetid);
	    }
		GetPlayerPos(targetid, BossTargetNotMovingPos[0], BossTargetNotMovingPos[1], BossTargetNotMovingPos[2]);
	}
}

stock ExecuteSpell(bossid) {
	switch(BossBigSmokeHealthState) {
	    case 81 .. 100: {FAI_StartBossCastingSpell(bossid, SpellFlightOfTheBumblebee, GetRandomPlayerInRange(bossid));}
	    case 61 .. 80: {FAI_StartBossCastingSpell(bossid, SpellRockOfLife, GetRandomPlayerInRange(bossid, false));}
	    case 41 .. 60: {FAI_StartBossCastingSpell(bossid, SpellWallOfFire);}
	    case 21 .. 40: {FAI_StartBossCastingSpell(bossid, SpellCarpetOfFire);}
	    case 0 .. 20: {FAI_StartBossCastingSpell(bossid, SpellNoPlaceIsSafe);}
	}
}

new const IdleMessages[][] = {
	"I knew I shouldn't have accepted Tenpenny's deal",
	"Grove Street Families was my home",
	"I didn't like Ryder anyway",
	"I'm sorry about your mother, Carl",
	"The drive-by on your home wasn't my idea",
	"I should've stayed with my homies"
};
forward BossIdleMessage(bossid);
public BossIdleMessage(bossid) {
	if(FAI_IsValidBoss(bossid)) { //Only make the boss yell if he actually exists (if he is destroyed for some reason, we don't need to make him yell)
		new randomMessage = random(sizeof(IdleMessages));
		BossYell(bossid, IdleMessages[randomMessage]);
	}
}

stock SendTargetidStartCastMessage(targetid, bossid, spellid) {
	new bossPlayerColor = GetPlayerColor(FAI_GetBossNPCID(bossid));
	new string[144 + 1], fullName[FAI_MAX_BOSS_FULL_NAME + 1], spellName[FAI_MAX_SPELL_NAME + 1];
	FAI_GetBossFullName(bossid, fullName, sizeof(fullName));
	FAI_GetSpellName(spellid, spellName, sizeof(spellName));
	format(string, sizeof(string), "{%06x}[Boss] %s{%06x} is casting {%06x}%s{%06x} on you!", bossPlayerColor >>> 8, fullName, 0xffffffff >>> 8, 0xffd517ff >>> 8, spellName, 0xffffffff >>> 8);
	if(spellid == SpellMarkOfDeath) {
		format(string, sizeof(string), "%s Don't stand still when you have aggro!", string);
	}
	SendClientMessage(targetid, -1, string);
	return 1;
}

stock GetRandomPlayerInRange(bossid, bool:vehicleAllowed = true) {
	new bossplayerid = FAI_GetBossNPCID(bossid);
	new Float:bossX, Float:bossY, Float:bossZ, Float:playerDistanceToBoss;
	new playersInRange[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
	new playersInRangeCount = 0;
	FCNPC_GetPosition(bossplayerid, bossX, bossY, bossZ);
	for(new playerid = 0, maxplayerid = GetPlayerPoolSize(); playerid <= maxplayerid; playerid++) {
	    if(FAI_IsBossValidForPlayer(playerid, bossid) && (vehicleAllowed || !IsPlayerInAnyVehicle(playerid)) && !IsPlayerNPC(playerid)) {
            playerDistanceToBoss = GetPlayerDistanceFromPoint(playerid, bossX, bossY, bossZ);
	  		if(playerDistanceToBoss <= 50.0) {
		        playersInRange[playersInRangeCount] = playerid;
		        playersInRangeCount++;
			}
	    }
	}
	if(playersInRangeCount != 0) {
		return playersInRange[random(playersInRangeCount)];
	}
	return INVALID_PLAYER_ID;
}

//Display a message in the playercolor of the boss and play a sound, to all players (not npcs) who are in the same interior and world as the boss
stock BossYell(bossid, message[], soundid = -1, Float:soundX = 0.0, Float:soundY = 0.0, Float:soundZ = 0.0) {
	new string[144 + 1], fullName[FAI_MAX_BOSS_FULL_NAME + 1];
	new bossplayerid = FAI_GetBossNPCID(bossid);
	new bossInterior = FCNPC_GetInterior(bossplayerid);
	new bossWorld = FCNPC_GetVirtualWorld(bossplayerid);
	new bossPlayerColor = GetPlayerColor(bossplayerid);
	FAI_GetBossFullName(bossid, fullName, sizeof(fullName));
	for(new playerid = 0, maxplayerid = GetPlayerPoolSize(); playerid <= maxplayerid; playerid++) {
		if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && GetPlayerInterior(playerid) == bossInterior && GetPlayerVirtualWorld(playerid) == bossWorld) {
			format(string, sizeof(string), "[Boss] %s yells: %s!", fullName, message);
			SendClientMessage(playerid, bossPlayerColor, string);
			if(soundid != -1) {
				PlayerPlaySound(playerid, soundid, soundX, soundY, soundZ);
			}
		}
	}
	return 1;
}

stock BossYellSpawnMessage(npcid) {
	new bossid = FAI_GetBossIDFromNPCID(npcid);
	if(bossid != FAI_INVALID_BOSS_ID) {
		if(bossid == BossBigSmoke) {
	        BossYell(bossid, "You've killed me once CJ, however once wasn't enough");
	    }
	}
	return 1;
}

stock CreateExplosionForValidPlayers(bossid, Float:markX, Float:markY, Float:markZ) {
	for(new playerid = 0, maxplayerid = GetPlayerPoolSize(); playerid <= maxplayerid; playerid++) {
 	    if(FAI_IsBossValidForPlayer(playerid, bossid)) {
			CreateExplosionForPlayer(playerid, markX, markY, markZ + 2.0, 11, 1.0); //markZ + 2.0 because we lowered the object below ground a bit
		}
	}
	return 1;
}


#if USE_STREAMER == true
	stock StreamerUpdateForValidPlayers(bossid) {
		for(new playerid = 0, maxplayerid = GetPlayerPoolSize(); playerid <= maxplayerid; playerid++) {
	 	    if(FAI_IsBossValidForPlayer(playerid, bossid)) {
				Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
			}
		}
		return 1;
	}
#endif

forward Float:RandomFloatGivenInteger(integer);
stock Float:RandomFloatGivenInteger(integer) {
	//Float has 6 decimals
	//0.1 => 10
	//so
	//0.000001 => 1000000
	//Random 1000000 has possible values of 0 to 999999 which covers the complete decimal range of 0.000000 to 0.999999
	new randomDecimals = random(1000000);
	new randomInteger = random(integer); //We will need to pad with zero's: say we get '1', if we dont pad it will become '0.1', which is incorrect, if we do pad it will become '0.000001', which is correct
	new string[21 + 1];
	format(string, sizeof(string), "%d.%06d", randomInteger, randomDecimals); //0: pad with zero's, 6: width
	return floatstr(string);
}

forward SetBossAtSpawn(bossid);
public SetBossAtSpawn(bossid) {
	if(bossid == BossBigSmoke) {
		new bossplayerid = FAI_GetBossNPCID(bossid);
		SetPlayerColor(bossplayerid, 0xff000000); //Alpha values = 00 because we don't want an additional playericon on the map
		if(!FCNPC_IsSpawned(bossplayerid)) {
		    FCNPC_Spawn(bossplayerid, 149, 1086.9752, 1074.7021, 10.8382);
		} else {
	    	if(FCNPC_IsDead(bossplayerid)) {
		    	FCNPC_Respawn(bossplayerid);
		    }
			FCNPC_SetSkin(bossplayerid, 149);
			FCNPC_SetPosition(bossplayerid, 1086.9752, 1074.7021, 10.8382);
		}
	    FCNPC_SetAngle(bossplayerid, 39.3813);
		FCNPC_SetInterior(bossplayerid, INTERIOR_NORMAL);
		FCNPC_SetVirtualWorld(bossplayerid, VIRTUAL_WORLD_NORMAL);
		FCNPC_ToggleReloading(bossplayerid, true);
		FCNPC_ToggleInfiniteAmmo(bossplayerid, true);
	    //FCNPC_SetWeapon(bossplayerid, WEAPON_COLT45);
	    //FCNPC_SetAmmo(bossplayerid, 1000);
	    //FCNPC_SetAmmoInClip(bossplayerid, 17);
		//FCNPC_SetWeaponState(bossplayerid, WEAPONSTATE_MORE_BULLETS);
		//FCNPC_SetWeaponSkillLevel(bossplayerid, WEAPONSKILL_PISTOL, 0);
		//FCNPC_SetWeaponInfo(bossplayerid, WEAPON_COLT45, -1, -1, -1, 1.0);
		FCNPC_SetWeapon(bossplayerid, WEAPON_BRASSKNUCKLE);
		FCNPC_SetFightingStyle(bossplayerid, FIGHT_STYLE_NORMAL);
		FCNPC_SetHealth(bossplayerid, 100.0);
		FCNPC_SetArmour(bossplayerid, 0.0);
		FCNPC_SetInvulnerable(bossplayerid, false);
		new Float:maxHealth;
		FAI_GetBossMaxHealth(bossid, maxHealth);
		FAI_SetBossCurrentHealth(bossid, maxHealth);
		BossBigSmokeHealthState = 100;
		KillTimer(BossIdleMessageTimer);
		BossIdleMessageTimer = SetTimerEx("BossIdleMessage", 1000 * 60 * 10, true, "d", bossid);
	}
	return 1;
}
forward SpellMarkOfDeathExplosion(bossid);
public SpellMarkOfDeathExplosion(bossid) {
	new Float:markX, Float:markY, Float:markZ;
	#if USE_STREAMER == false
		GetObjectPos(BossTargetNotMovingObject, markX, markY, markZ);
 		DestroyObject(BossTargetNotMovingObject);
 	#else
		GetDynamicObjectPos(BossTargetNotMovingObject, markX, markY, markZ);
		DestroyDynamicObject(BossTargetNotMovingObject);
	#endif
	BossTargetNotMovingObject = INVALID_OBJECT_ID;
	CreateExplosionForValidPlayers(bossid, markX, markY, markZ);
	KillTimer(BossTargetNotMovingTimer);
	BossTargetNotMovingTimer = FAI_INVALID_TIMER_ID;
	return 1;
}
			
forward WallOfFireExplosion(bossid);
public WallOfFireExplosion(bossid) {
	new Float:markX, Float:markY, Float:markZ;
	#if USE_STREAMER == false
		GetObjectPos(GroundMarks[ExplosionCount], markX, markY, markZ);
 		DestroyObject(GroundMarks[ExplosionCount]);
 	#else
	    GetDynamicObjectPos(GroundMarks[ExplosionCount], markX, markY, markZ);
	 	DestroyDynamicObject(GroundMarks[ExplosionCount]);
 	#endif
	GroundMarks[ExplosionCount] = INVALID_OBJECT_ID;
	CreateExplosionForValidPlayers(bossid, markX, markY, markZ);
	ExplosionCount--;
	if(ExplosionCount < 0) {
		KillTimer(ExplosionTimer);
		ExplosionTimer = FAI_INVALID_TIMER_ID;
		ExplosionCount = 0;
	}
	return 1;
}
forward SpellNoPlaceIsSafeExplosion(bossid, spell);
public SpellNoPlaceIsSafeExplosion(bossid, spell) {
	new Float:bossX, Float:bossY, Float:bossZ, Float:markX, Float:markY, Float:markZ, Float:radius, Float:angle;
	new bossplayerid = FAI_GetBossNPCID(bossid);
    FCNPC_GetPosition(bossplayerid, bossX, bossY, bossZ);
    radius = RandomFloatGivenInteger(50) + 1.0;
    angle = RandomFloatGivenInteger(360);
	markX = bossX + (radius * floatcos(angle + 90, degrees));
	markY = bossY + (radius * floatsin(angle + 90, degrees));
    #if FAI_USE_MAP_ANDREAS == true
		MapAndreas_FindZ_For2DCoord(markX, markY, markZ);
	#endif
	CreateExplosionForValidPlayers(bossid, markX, markY, markZ - 2.0);
	ExplosionCount++;
	if(ExplosionCount == sizeof(Bombs)) {
	    ExplosionCount = 0;
	}
	return 1;
}

forward SpellRockOfLifeEnd(playerid);
public SpellRockOfLifeEnd(playerid) {
	#if USE_STREAMER == false
 		DestroyObject(GroundMarks[0]);
 	#else
		DestroyDynamicObject(GroundMarks[0]);
	#endif
	GroundMarks[0] = INVALID_OBJECT_ID;
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	SpellRockOfLifeTarget = INVALID_PLAYER_ID;
	KillTimer(ExplosionTimer);
	ExplosionTimer = FAI_INVALID_TIMER_ID;
	return 1;
}
