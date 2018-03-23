/*
Spell cooldown:
-When does the cooldown start? From start of cast or from end of cast?
-Cooldown should be per boss per spell

Spell mana:
-Mana is not consumed until the casting time is completed.
-A spell cast can't be started when the spell requires more mana than the boss has.
-With an inverted cast progress, mana is consumed before the channeling starts.

Spell examples:
-mimic: the boss asumes the skin of the target and the weapon that target has currently equiped
*/

//ENUM_SPELL
IMMUNES[MAX_PLAYERS],

//INTERNAL
forward WOW_CastSpellDone(issuerid);
public WOW_CastSpellDone(issuerid) {
	if(IsPlayerConnected(issuerid) && WOW_IsPlayerCasting(issuerid) && IsPlayerConnected(WOW_CastingSpell[issuerid][TARGETID])) {
	    new spell = WOW_CastingSpell[issuerid][SPELL];
		if(WOW_IsValidSpell(spell)) {
			if(!WOW_ArrayContains(WOW_CastingSpell[issuerid][TARGETID], WOW_Spells[spell][IMMUNES])) {
			    new Float:newAmount = 0.0;
			    new Float:effectAmount = WOW_Spells[spell][AMOUNT];
	  			switch(WOW_Spells[spell][IS_PERCENT_OF]) {
					case WOW_PERCENT_TYPE_NOT: {newAmount += effectAmount;}
					case WOW_PERCENT_TYPE_TARG_MAX_HP: {newAmount += 200 / 100 * effectAmount;}
					case WOW_PERCENT_TYPE_CAST_MAX_HP: {newAmount += 200 / 100 * effectAmount;}
					case WOW_PERCENT_TYPE_TARG_CUR_HP: {
					    new Float:health, Float:armour;
					    GetPlayerHealth(WOW_CastingSpell[issuerid][TARGETID], health);
					    GetPlayerArmour(WOW_CastingSpell[issuerid][TARGETID], armour);
						newAmount += (health + armour) / 100 * effectAmount;
					}
					case WOW_PERCENT_TYPE_CAST_CUR_HP: {
					    new Float:health, Float:armour;
					    GetPlayerHealth(issuerid, health);
					    GetPlayerArmour(issuerid, armour);
						newAmount += (health + armour) / 100 * effectAmount;
					}
	  		 	}
				switch(WOW_Spells[spell][TYPE]) {
				    case WOW_SPELL_TYPE_DAM: {WOW_DamagePlayer(WOW_CastingSpell[issuerid][TARGETID], issuerid, newAmount);}
				    case WOW_SPELL_TYPE_HEAL: {WOW_HealPlayer(WOW_CastingSpell[issuerid][TARGETID], issuerid, newAmount);}
				    case WOW_SPELL_TYPE_GIVE_EFFECT: {}
				    case WOW_SPELL_TYPE_INTERRUPT: {} //TODO
				    case WOW_SPELL_TYPE_DISPEL: {} //TODO
				}
				if(WOW_IsValidEffect(WOW_Spells[spell][EFFECT])) {
					WOW_GivePlayerEffect(WOW_CastingSpell[issuerid][TARGETID], issuerid, WOW_Spells[spell][EFFECT]);
				}
	    		WOW_StopPlayerCasting(issuerid);
			} else {
			    //TODO
			}
		}
	    WOW_StopPlayerCasting(issuerid);
	    return 1;
	}
 	WOW_StopPlayerCasting(issuerid);
	return -1;
}
stock WOW_CastSpellOnPlayer(playerid, issuerid, spell) {
//&& !WOW_ArrayContains(playerid, WOW_Spells[spell][IMMUNES])
	if(&& IsPlayerConnected(issuerid)) {
	}
}
stock WOW_DestroySpell(spell) {
	WOW_Spells[spell][EFFECT] = WOW_INVALID_EFFECT_ID;
	WOW_Spells[spell][IMMUNES] = {INVALID_PLAYER_ID}; //TODO
	return 1;
}
stock WOW_CreateSpell(effect = WOW_INVALID_EFFECT_ID, immunes[] = {INVALID_PLAYER_ID}) {
	WOW_Spells[spell][EFFECT] = effect;
	//WOW_Spells[spell][IMMUNES] = immunes; //TODO

	//Percentstring above
	new effectString[30];
	if(WOW_IsValidEffect(effect)) {
		format(effectString, sizeof(effectString), "Applies %s. ", WOW_Effects[effect][NAME]);
	}
	//Casttimestring under

    switch(type) {
		case WOW_SPELL_TYPE_GIVE_EFFECT: {format(WOW_Spells[spell][INFO], WOW_MAX_SPELL_INFO + 1, "%s: %s%s cast.", name, effectString, castTimeString);}
		case WOW_SPELL_TYPE_INTERRUPT: {} //TODO
		case WOW_SPELL_TYPE_DISPEL: {} //TODO
	}
}

/*
stock WOW_DamagePlayer(playerid, issuerid, Float:amount, weaponid = WOW_INVALID_WEAPON_ID, bodypart = WOW_INVALID_BODYPART_ID) {
	if(IsPlayerConnected(playerid) && (issuerid == INVALID_PLAYER_ID || IsPlayerConnected(issuerid))) {
		//Calculate damage change
		new Float:damageChange = 0.0;
		for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
			if(issuerid != INVALID_PLAYER_ID) {
		    	new effect = WOW_EffectsOnPlayer[issuerid][effectslot][EFFECT];
		    	if(WOW_IsValidEffect(effect)) {
					new Float:effectAmount = WOW_Effects[effect][AMOUNT];
					if((weaponid == WOW_INVALID_WEAPON_ID || WOW_Effects[effect][WEAPONS][0] == -1 || WOW_ArrayContains(weaponid, WOW_Effects[effect][WEAPONS]))
					&& (bodypart == WOW_INVALID_BODYPART_ID || WOW_Effects[effect][BODYPARTS][0] == -1 || WOW_ArrayContains(bodypart, WOW_Effects[effect][BODYPARTS]))) {
						switch(WOW_Effects[effect][TYPE]) {
					  		case WOW_EFFECT_TYPE_DAM_DONE_INC: {
					  		    switch(WOW_Effects[effect][IS_PERCENT_OF]) {
									case WOW_PERCENT_TYPE_NOT: {damageChange += effectAmount;}
									case WOW_PERCENT_TYPE_DAM_OR_HEAL: {damageChange += amount * (effectAmount / 100);}
									case WOW_PERCENT_TYPE_TARG_MAX_HP: {damageChange += 200 / 100 * effectAmount;}
									case WOW_PERCENT_TYPE_CAST_MAX_HP: {damageChange += 200 / 100 * effectAmount;}
									case WOW_PERCENT_TYPE_TARG_CUR_HP: {
									    new Float:health, Float:armour;
									    GetPlayerHealth(playerid, health);
									    GetPlayerArmour(playerid, armour);
										damageChange += (health + armour) / 100 * effectAmount;
									}
									case WOW_PERCENT_TYPE_CAST_CUR_HP: {
									    new Float:health, Float:armour;
									    GetPlayerHealth(issuerid, health);
									    GetPlayerArmour(issuerid, armour);
										damageChange += (health + armour) / 100 * effectAmount;
									}
					  		    }
					  		}
						  	case WOW_EFFECT_TYPE_DAM_DONE_DEC: {
		 		    			switch(WOW_Effects[effect][IS_PERCENT_OF]) {
									case WOW_PERCENT_TYPE_NOT: {damageChange -= effectAmount;}
									case WOW_PERCENT_TYPE_DAM_OR_HEAL: {damageChange -= amount * (effectAmount / 100);}
									case WOW_PERCENT_TYPE_TARG_MAX_HP: {damageChange -= 200 / 100 * effectAmount;}
									case WOW_PERCENT_TYPE_CAST_MAX_HP: {damageChange -= 200 / 100 * effectAmount;}
									case WOW_PERCENT_TYPE_TARG_CUR_HP: {
									    new Float:health, Float:armour;
									    GetPlayerHealth(playerid, health);
									    GetPlayerArmour(playerid, armour);
										damageChange -= (health + armour) / 100 * effectAmount;
									}
									case WOW_PERCENT_TYPE_CAST_CUR_HP: {
									    new Float:health, Float:armour;
									    GetPlayerHealth(issuerid, health);
									    GetPlayerArmour(issuerid, armour);
										damageChange -= (health + armour) / 100 * effectAmount;
									}
					  		    }
					  		}
						}
					}
				}
			}

			new effect = WOW_EffectsOnPlayer[playerid][effectslot][EFFECT];
	 		if(WOW_IsValidEffect(effect)) {
				new Float:effectAmount = WOW_Effects[effect][AMOUNT];
			    if((weaponid == WOW_INVALID_WEAPON_ID || WOW_Effects[effect][WEAPONS][0] == -1 || WOW_ArrayContains(weaponid, WOW_Effects[effect][WEAPONS]))
			  	&& (bodypart == WOW_INVALID_BODYPART_ID || WOW_Effects[effect][BODYPARTS][0] == -1 || WOW_ArrayContains(bodypart, WOW_Effects[effect][BODYPARTS]))
			  	&& (issuerid == INVALID_PLAYER_ID || WOW_Effects[effect][PLAYERS][0] == -1 || WOW_ArrayContains(issuerid, WOW_Effects[effect][PLAYERS]))) {
					switch(WOW_Effects[effect][TYPE]) {
				  		case WOW_EFFECT_TYPE_DAM_RECV_INC: {
				  		    switch(WOW_Effects[effect][IS_PERCENT_OF]) {
								case WOW_PERCENT_TYPE_NOT: {damageChange += effectAmount;}
								case WOW_PERCENT_TYPE_DAM_OR_HEAL: {damageChange += amount * (effectAmount / 100);}
								case WOW_PERCENT_TYPE_TARG_MAX_HP: {damageChange += 200 / 100 * effectAmount;}
								case WOW_PERCENT_TYPE_CAST_MAX_HP: {
									if(issuerid != INVALID_PLAYER_ID) {
										damageChange += 200 / 100 * effectAmount;
									}
								}
								case WOW_PERCENT_TYPE_TARG_CUR_HP: {
								    new Float:health, Float:armour;
								    GetPlayerHealth(playerid, health);
								    GetPlayerArmour(playerid, armour);
									damageChange += (health + armour) / 100 * effectAmount;
								}
								case WOW_PERCENT_TYPE_CAST_CUR_HP: {
								    if(issuerid != INVALID_PLAYER_ID) {
									    new Float:health, Float:armour;
									    GetPlayerHealth(issuerid, health);
									    GetPlayerArmour(issuerid, armour);
										damageChange += (health + armour) / 100 * effectAmount;
									}
								}
				  		    }
			  		 	}
				  		case WOW_EFFECT_TYPE_DAM_RECV_DEC: {
			    			switch(WOW_Effects[effect][IS_PERCENT_OF]) {
								case WOW_PERCENT_TYPE_NOT: {damageChange -= effectAmount;}
								case WOW_PERCENT_TYPE_DAM_OR_HEAL: {damageChange -= amount * (effectAmount / 100);}
								case WOW_PERCENT_TYPE_TARG_MAX_HP: {damageChange -= 200 / 100 * effectAmount;}
								case WOW_PERCENT_TYPE_CAST_MAX_HP: {
									if(issuerid != INVALID_PLAYER_ID) {
										damageChange -= 200 / 100 * effectAmount;
									}
								}
								case WOW_PERCENT_TYPE_TARG_CUR_HP: {
								    new Float:health, Float:armour;
								    GetPlayerHealth(playerid, health);
								    GetPlayerArmour(playerid, armour);
									damageChange -= (health + armour) / 100 * effectAmount;
								}
								case WOW_PERCENT_TYPE_CAST_CUR_HP: {
								    if(issuerid != INVALID_PLAYER_ID) {
									    new Float:health, Float:armour;
									    GetPlayerHealth(issuerid, health);
									    GetPlayerArmour(issuerid, armour);
										damageChange -= (health + armour) / 100 * effectAmount;
									}
								}
				  		    }
				  		}
				  	}
		  		}
	  		}
		}
		//Assign damage change
	    new Float:health, Float:armour;
		GetPlayerHealth(playerid, health);
		GetPlayerArmour(playerid, armour);
		new Float:totalDamage = amount + damageChange;
		if(weaponid <= 46) {
			if(armour < totalDamage) {
				totalDamage -= armour;
			    SetPlayerArmour(playerid, 0);
				SetPlayerHealth(playerid, health - totalDamage);
			} else {
				SetPlayerArmour(playerid, armour - totalDamage);
			}
		} else { //Does only health damage
			SetPlayerHealth(playerid, health - totalDamage);
		}
	}
	return 1;
}
stock WOW_HealPlayer(playerid, issuerid, Float:amount) {
	if(IsPlayerConnected(playerid) && (issuerid == INVALID_PLAYER_ID || IsPlayerConnected(issuerid))) {
		//Calculate healing change
		new Float:healingChange = 0.0;
		for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
			if(issuerid != INVALID_PLAYER_ID) {
	    		new effect = WOW_EffectsOnPlayer[issuerid][effectslot][EFFECT];
				if(WOW_IsValidEffect(effect)) {
			    	new Float:effectAmount = WOW_Effects[effect][AMOUNT];
					switch(WOW_Effects[effect][TYPE]) {
				  		case WOW_EFFECT_TYPE_HEAL_DONE_INC: {
				  		    switch(WOW_Effects[effect][IS_PERCENT_OF]) {
								case WOW_PERCENT_TYPE_NOT: {healingChange += effectAmount;}
								case WOW_PERCENT_TYPE_DAM_OR_HEAL: {healingChange += amount * (effectAmount / 100);}
								case WOW_PERCENT_TYPE_TARG_MAX_HP: {healingChange += 200 / 100 * effectAmount;}
								case WOW_PERCENT_TYPE_CAST_MAX_HP: {healingChange += 200 / 100 * effectAmount;}
								case WOW_PERCENT_TYPE_TARG_CUR_HP: {
								    new Float:health, Float:armour;
								    GetPlayerHealth(playerid, health);
								    GetPlayerArmour(playerid, armour);
									healingChange += (health + armour) / 100 * effectAmount;
								}
								case WOW_PERCENT_TYPE_CAST_CUR_HP: {
								    new Float:health, Float:armour;
								    GetPlayerHealth(issuerid, health);
								    GetPlayerArmour(issuerid, armour);
									healingChange += (health + armour) / 100 * effectAmount;
								}
				  		    }
				  		}
					  	case WOW_EFFECT_TYPE_HEAL_DONE_DEC: {
				  		    switch(WOW_Effects[effect][IS_PERCENT_OF]) {
								case WOW_PERCENT_TYPE_NOT: {healingChange -= effectAmount;}
								case WOW_PERCENT_TYPE_DAM_OR_HEAL: {healingChange -= amount * (effectAmount / 100);}
								case WOW_PERCENT_TYPE_TARG_MAX_HP: {healingChange -= 200 / 100 * effectAmount;}
								case WOW_PERCENT_TYPE_CAST_MAX_HP: {healingChange -= 200 / 100 * effectAmount;}
								case WOW_PERCENT_TYPE_TARG_CUR_HP: {
								    new Float:health, Float:armour;
								    GetPlayerHealth(playerid, health);
								    GetPlayerArmour(playerid, armour);
									healingChange -= (health + armour) / 100 * effectAmount;
								}
								case WOW_PERCENT_TYPE_CAST_CUR_HP: {
								    new Float:health, Float:armour;
								    GetPlayerHealth(issuerid, health);
								    GetPlayerArmour(issuerid, armour);
									healingChange -= (health + armour) / 100 * effectAmount;
								}
				  		    }
				  		}
					}
				}
			}

			new effect = WOW_EffectsOnPlayer[playerid][effectslot][EFFECT];
			if(WOW_IsValidEffect(effect)) {
				new Float:effectAmount = WOW_Effects[effect][AMOUNT];
				if(issuerid == INVALID_PLAYER_ID || WOW_Effects[effect][PLAYERS][0] == -1 || WOW_ArrayContains(issuerid, WOW_Effects[effect][PLAYERS])) {
					switch(WOW_Effects[effect][TYPE]) {
				  		case WOW_EFFECT_TYPE_HEAL_RECV_INC: {
				  		    switch(WOW_Effects[effect][IS_PERCENT_OF]) {
								case WOW_PERCENT_TYPE_NOT: {healingChange += effectAmount;}
								case WOW_PERCENT_TYPE_DAM_OR_HEAL: {healingChange += amount * (effectAmount / 100);}
								case WOW_PERCENT_TYPE_TARG_MAX_HP: {healingChange += 200 / 100 * effectAmount;}
								case WOW_PERCENT_TYPE_CAST_MAX_HP: {
									if(issuerid != INVALID_PLAYER_ID) {
										healingChange += 200 / 100 * effectAmount;
									}
								}
								case WOW_PERCENT_TYPE_TARG_CUR_HP: {
								    new Float:health, Float:armour;
								    GetPlayerHealth(playerid, health);
								    GetPlayerArmour(playerid, armour);
									healingChange += (health + armour) / 100 * effectAmount;
								}
								case WOW_PERCENT_TYPE_CAST_CUR_HP: {
									if(issuerid != INVALID_PLAYER_ID) {
									    new Float:health, Float:armour;
									    GetPlayerHealth(issuerid, health);
									    GetPlayerArmour(issuerid, armour);
										healingChange += (health + armour) / 100 * effectAmount;
									}
								}
				  		    }
				  		}
					  	case WOW_EFFECT_TYPE_HEAL_RECV_DEC: {
				  		    switch(WOW_Effects[effect][IS_PERCENT_OF]) {
								case WOW_PERCENT_TYPE_NOT: {healingChange -= effectAmount;}
								case WOW_PERCENT_TYPE_DAM_OR_HEAL: {healingChange -= amount * (effectAmount / 100);}
								case WOW_PERCENT_TYPE_TARG_MAX_HP: {healingChange -= 200 / 100 * effectAmount;}
								case WOW_PERCENT_TYPE_CAST_MAX_HP: {
									if(issuerid != INVALID_PLAYER_ID) {
										healingChange -= 200 / 100 * effectAmount;
									}
								}
								case WOW_PERCENT_TYPE_TARG_CUR_HP: {
								    new Float:health, Float:armour;
								    GetPlayerHealth(playerid, health);
								    GetPlayerArmour(playerid, armour);
									healingChange -= (health + armour) / 100 * effectAmount;
								}
								case WOW_PERCENT_TYPE_CAST_CUR_HP: {
									if(issuerid != INVALID_PLAYER_ID) {
									    new Float:health, Float:armour;
									    GetPlayerHealth(issuerid, health);
									    GetPlayerArmour(issuerid, armour);
										healingChange -= (health + armour) / 100 * effectAmount;
									}
								}
				  		    }
				  		}
					}
				}
			}
	 	}
	 	//Assign healing change
	    new Float:health, Float:armour;
		GetPlayerHealth(playerid, health);
		GetPlayerArmour(playerid, armour);
		new Float:damageHealth = 100.0 - health;
		new Float:damageArmour = 100.0 - armour;
		new Float:totalHealing = amount + healingChange;
		if(damageHealth != 0) {
		    if(damageHealth < totalHealing) {
				totalHealing -= damageHealth;
				SetPlayerHealth(playerid, 100.0);
				if(damageArmour != 0) {
					if(damageArmour < totalHealing) {
						SetPlayerArmour(playerid, 100.0);
					} else {
						SetPlayerArmour(playerid, armour + totalHealing);
					}
				}
		    } else {
				SetPlayerHealth(playerid, health + totalHealing);
		    }
		} else {
			if(damageArmour != 0) {
				if(damageArmour < totalHealing) {
					SetPlayerArmour(playerid, 100.0);
				} else {
					SetPlayerArmour(playerid, armour + totalHealing);
				}
			}
		}
	}
	return 1;
}
*/
