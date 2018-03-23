/*
Effect examples:
-decrease/increase damage from some weapon (maybe even immunity)
-decrease/increase max/current HP
-movement slower/quicker
-decrease/increase cast time

Effect considerations:
-damage decrease can't be above 100%
-damage increase can be above 100%

Effect textdraws:
-icons with textdraw previews or text like (H+ and H-)
-show remaining effect ticks visually with a decreasing y axis
*/

#define WOW_MAX_WEAPONS                 205
#define WOW_MAX_BODYPARTS               10
#define WOW_INVALID_WEAPON_ID			-1
#define WOW_INVALID_BODYPART_ID			-1
enum WOW_ENUM_EFFECT {
	INTERVAL,
	IMMUNES[MAX_PLAYERS],
	PLAYERS[MAX_PLAYERS],
	WEAPONS[WOW_MAX_WEAPONS],
	BODYPARTS[WOW_MAX_BODYPARTS]
}
enum WOW_ENUM_EFFECT_ON_PLAYER {
	ISSUERID,
	PlayerText:TEXTDRAW
}
enum WOW_ENUM_SPELL {
	EFFECT
}

//TODO duration, keeppercent: native, function, createfull body?
//TODO canMove?
//TODO canAttack?
//TODO replace effect when full?
//TODO cast bar extra & extra progress?
//TODO progress?
//TODO set effects, keeppercent: native, function

//Declare textdraws
new Text:WOW_Icons[WOW_MAX_EFFECTS_PER_PLAYER] = {Text:INVALID_TEXT_DRAW, ...};
//Init textdraws
for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
	new Float:startX = 598.0 - effectslot * 12.5 + floatround(float(effectslot)/9, floatround_floor) * 12.5 * 9;
	new Float:endX = startX + 9;
	new Float:startY = 114.0 + floatround(float(effectslot)/9, floatround_floor) * 14;
	WOW_Icons[effectslot] = TextDrawCreate(startX, startY, "_");
	TextDrawFont(WOW_Icons[effectslot], 1);
	TextDrawAlignment(WOW_Icons[effectslot], 1);
	TextDrawSetProportional(WOW_Icons[effectslot], 1);
	TextDrawColor(WOW_Icons[effectslot], 0xffffffff);
	TextDrawSetShadow(WOW_Icons[effectslot], 0);
	TextDrawSetOutline(WOW_Icons[effectslot], 1);
	TextDrawBackgroundColor(WOW_Icons[effectslot], 0x000000FF);
	TextDrawUseBox(WOW_Icons[effectslot], 1);
	TextDrawBoxColor(WOW_Icons[effectslot], 0x000000FF);
	TextDrawTextSize(WOW_Icons[effectslot], endX, 0.0);
	TextDrawLetterSize(WOW_Icons[effectslot], 0.2, 1.0);
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
		WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW] = CreatePlayerTextDraw(playerid, startX + 4.75, startY, "_");
		PlayerTextDrawFont(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], 1);
		PlayerTextDrawAlignment(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], 2);
		PlayerTextDrawSetProportional(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], 1);
		PlayerTextDrawColor(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], 0xffffffff);
		PlayerTextDrawSetShadow(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], 0);
		PlayerTextDrawSetOutline(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], 1);
		PlayerTextDrawLetterSize(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], 0.2, 1.0);
	}
}
//Exit textdraws
for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
	TextDrawDestroy(WOW_Icons[effectslot]);
	WOW_Icons[effectslot] = Text:INVALID_TEXT_DRAW;
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
		PlayerTextDrawDestroy(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW]);
		WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW] = PlayerText:INVALID_TEXT_DRAW;
	}
}

//INTERNAL
stock bool:WOW_ArrayContains(item, array[], asize = sizeof(array)) {
	for(new a = 0; a < asize; a++) {
	    if(array[a] == item) {
	        return true;
	    }
	}
	return false;
}
stock bool:WOW_IsValidEffectInSlot(playerid, effectslot) {
	if(playerid >= 0 && playerid < MAX_PLAYERS
	&& effectslot >= 0 && effectslot < WOW_MAX_EFFECTS_PER_PLAYER && WOW_EffectsOnPlayer[playerid][effectslot][EFFECT] != WOW_INVALID_EFFECT_ID) {
	     return true;
	}
	return false;
}
stock WOW_RemoveEffectInSlot(playerid, effectslot) {
	if(WOW_IsValidEffectInSlot(playerid, effectslot)) {
		WOW_EffectsOnPlayer[playerid][effectslot][EFFECT] = WOW_INVALID_EFFECT_ID;
		WOW_EffectsOnPlayer[playerid][effectslot][ISSUERID] = INVALID_PLAYER_ID;
		WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] = 0;
		if(WOW_EffectsOnPlayer[playerid][effectslot][TIMERID] != WOW_INVALID_TIMER_ID) {
			KillTimer(WOW_EffectsOnPlayer[playerid][effectslot][TIMERID]);
			WOW_EffectsOnPlayer[playerid][effectslot][TIMERID] = WOW_INVALID_TIMER_ID;
		}
		TextDrawHideForPlayer(playerid, WOW_Icons[effectslot]);
		PlayerTextDrawHide(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW]);

		//TODO switch
		/*new effectslot2 = effectslot + 1;
		if(effectslot2 < WOW_MAX_EFFECTS_PER_PLAYER && WOW_EffectsOnPlayer[playerid][effectslot2][EFFECT] != WOW_INVALID_EFFECT_ID) {
			WOW_EffectsOnPlayer[playerid][effectslot][EFFECT] = WOW_EffectsOnPlayer[playerid][effectslot2][EFFECT];
			WOW_EffectsOnPlayer[playerid][effectslot][ISSUERID] = WOW_EffectsOnPlayer[playerid][effectslot2][ISSUERID];
			WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] = WOW_EffectsOnPlayer[playerid][effectslot2][TICKS_LEFT];
			WOW_EffectsOnPlayer[playerid][effectslot][TIMERID] = WOW_EffectsOnPlayer[playerid][effectslot2][TIMERID];
			TextDrawShowForPlayer(playerid, WOW_Icons[effectslot]);
			if(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] != -1) {
				new string[5];
				if(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] < 60) {
					format(string, sizeof(string), "%d", WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT]);
				} else {
					format(string, sizeof(string), "%dm", floatround(float(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT]) / 60, floatround_ceil));
				}
				PlayerTextDrawSetString(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], string);
				PlayerTextDrawShow(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW]);
			}
			WOW_EffectsOnPlayer[playerid][effectslot2][TIMERID] = WOW_INVALID_TIMER_ID;
				
			WOW_RemoveEffectInSlot(playerid, effectslot2);
		}*/
		return 1;
	}
	return -1;
}
forward WOW_EffectTick(playerid, effectslot);
public WOW_EffectTick(playerid, effectslot) {
	if(IsPlayerConnected(playerid) && WOW_IsValidEffectInSlot(playerid, effectslot) && IsPlayerConnected(WOW_EffectsOnPlayer[playerid][effectslot][ISSUERID])) {
		if(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] == 0) {
			WOW_RemoveEffectInSlot(playerid, effectslot);
		} else {
		    if(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] != -1) {
		    	WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT]--;
				//TODO dit is per tick, niet per seconde!!!
				PlayerTextDrawHide(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW]);
				new string[5];
				if(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] < 60) {
					format(string, sizeof(string), "%d", WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT]);
				} else {
					format(string, sizeof(string), "%dm", floatround(float(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT]) / 60, floatround_ceil));
				}
				PlayerTextDrawSetString(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], string);
				PlayerTextDrawShow(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW]);
		    }
		    new effect = WOW_EffectsOnPlayer[playerid][effectslot][EFFECT];
		    if(WOW_IsValidEffect(effect)) {
				switch(WOW_Effects[effect][TYPE]) {
					case WOW_EFFECT_TYPE_DOT: {WOW_DamagePlayer(playerid, WOW_EffectsOnPlayer[playerid][effectslot][ISSUERID], WOW_Effects[effect][AMOUNT]);}
					case WOW_EFFECT_TYPE_HOT: {WOW_HealPlayer(playerid, WOW_EffectsOnPlayer[playerid][effectslot][ISSUERID], WOW_Effects[effect][AMOUNT]);}
				}
			}
		}
	    return 1;
	}
	WOW_RemoveEffectInSlot(playerid, effectslot);
	return -1;
}

//PUBLIC
stock WOW_RemoveEffectFromPlayer(playerid, effect) {
	if(WOW_IsValidEffect(effect)) {
		for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
		    if(WOW_IsValidEffectInSlot(playerid, effectslot) && WOW_EffectsOnPlayer[playerid][effectslot][EFFECT] == effect) {
		    	WOW_RemoveEffectInSlot(playerid, effectslot);
		    }
		}
		return 1;
	}
	return -1;
}
stock WOW_RemoveAllEffectsFromPlayer(playerid) {
	for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
	    if(WOW_IsValidEffectInSlot(playerid, effectslot)) {
			WOW_RemoveEffectInSlot(playerid, effectslot);
		}
	}
	return 1;
}
stock WOW_CreateEffect(name[]) {
	//TODO reduce can't be above 100.0 and increase can't be below 0.0, because that would lead to the opposite effect
	//TODO + combined increase / reduction in DamagePlayer
	/*switch(type) {
	    case WOW_EFFECT_TYPE_DAM_DONE_INC, WOW_EFFECT_TYPE_HEAL_DONE_INC, WOW_EFFECT_TYPE_DAM_RECV_INC, WOW_EFFECT_TYPE_HEAL_RECV_INC: {
	        if(amount < 0.0) {
				amount = 0.0;
				WOW_Effects[globalEffect][AMOUNT] = amount;
	        }
		}
	    case WOW_EFFECT_TYPE_DAM_DONE_DEC, WOW_EFFECT_TYPE_HEAL_DONE_DEC, WOW_EFFECT_TYPE_DAM_RECV_DEC, WOW_EFFECT_TYPE_HEAL_RECV_DEC: {
	        if(amount > 100.0) {
				amount = 100.0;
				WOW_Effects[globalEffect][AMOUNT] = amount;
			}
		}
	}*/
	new intervalString[20];
	WOW_RemoveUnnecessaryDecimals(intervalString, float(interval) / 1000, 2);
	if(strfind(intervalString, ".", true) == -1 && floatround(float(interval) / 1000, floatround_floor) == 1) {
		format(intervalString, sizeof(intervalString), "second");
	} else {
		format(intervalString, sizeof(intervalString), "%s seconds", intervalString);
	}
	if(float(interval) / 1000 / 60 >= 1) {
		WOW_RemoveUnnecessaryDecimals(intervalString, float(interval) / 1000 / 60, 2);
		if(strfind(intervalString, ".", true) == -1 && floatround(float(interval) / 1000 / 60, floatround_floor) == 1) {
			format(intervalString, sizeof(intervalString), "minute");
		} else {
			format(intervalString, sizeof(intervalString), "%s minutes", intervalString);
		}
	}
	
	new durationString[20];
	if(duration == -1) {
		//format(durationString, sizeof(durationString), " permanently");
		format(durationString, sizeof(durationString), "%s", "");
	} else if(duration == 1) {
		format(durationString, sizeof(durationString), " for %d second", duration);
	} else if(duration <= 59) {
		format(durationString, sizeof(durationString), " for %d seconds", duration);
	} else {
		WOW_RemoveUnnecessaryDecimals(durationString, float(duration) / 60, 2);
		if(strfind(durationString, ".", true) == -1 && floatround(float(duration) / 60, floatround_floor) == 1) {
			format(durationString, sizeof(durationString), " for %s minute", durationString);
		} else {
			format(durationString, sizeof(durationString), " for %s minutes", durationString);
		}
	}
	
	new bodypartsString2[144 + 1];
	format(bodypartsString2, sizeof(bodypartsString2), "%s", bodypartsString);
	if(!isnull(bodypartsString)) {
    	if(!strcmp(bodypartsString, WOW_INVALID_STRING, true)) {
    	    if(bsize == 1) {
    	        if(bodyparts[0] == -1) {
    	        	//format(bodypartsString2, sizeof(bodypartsString2), " %s", "for all players");
    	        	format(bodypartsString2, sizeof(bodypartsString2), "%s", "");
    	        } else {
    	        	format(bodypartsString2, sizeof(bodypartsString2), " on bodypart %d", bodyparts[0]);
    	        }
    	    } else {
				format(bodypartsString2, sizeof(bodypartsString2), " on bodyparts");
	    	    for(new bodypart = 0; bodypart < bsize; bodypart++) {
	    	        if(bodypart != 0) {
						format(bodypartsString2, sizeof(bodypartsString2), "%s, %d", bodypartsString2, bodyparts[bodypart]);
					} else {
						format(bodypartsString2, sizeof(bodypartsString2), "%s %d", bodypartsString2, bodyparts[bodypart]);
					}
	    	    }
    	    }
    	} else {
    	    strins(bodypartsString2, " ", 0, sizeof(bodypartsString2));
    	}
	}
	
	new weaponsString2[144 + 1];
	format(weaponsString2, sizeof(weaponsString2), "%s", weaponsString);
	if(!isnull(weaponsString)) {
    	if(!strcmp(weaponsString, WOW_INVALID_STRING, true)) {
    	    if(wsize == 1) {
    	        if(weapons[0] == -1) {
    	        	//format(weaponsString2, sizeof(weaponsString2), " %s", "with all weapons");
    	        	format(weaponsString2, sizeof(weaponsString2), "%s", "");
    	        } else {
    	        	format(weaponsString2, sizeof(weaponsString2), " with weapon %d", weapons[0]);
    	        }
    	    } else {
				format(weaponsString2, sizeof(weaponsString2), " with weapons");
	    	    for(new weapon = 0; weapon < wsize; weapon++) {
	    	        if(weapon != 0) {
						format(weaponsString2, sizeof(weaponsString2), "%s, %d", weaponsString2, weapons[weapon]);
					} else {
						format(weaponsString2, sizeof(weaponsString2), "%s %d", weaponsString2, weapons[weapon]);
					}
	    	    }
    	    }
    	} else {
    	    strins(weaponsString2, " ", 0, sizeof(weaponsString2));
    	}
	}
	
	new typeString[5];
	switch(type) {
	    case WOW_EFFECT_TYPE_DAM_DONE_INC, WOW_EFFECT_TYPE_DAM_DONE_DEC, WOW_EFFECT_TYPE_HEAL_DONE_INC, WOW_EFFECT_TYPE_HEAL_DONE_DEC: {format(typeString, sizeof(typeString), "to");}
	    case WOW_EFFECT_TYPE_DAM_RECV_INC, WOW_EFFECT_TYPE_DAM_RECV_DEC, WOW_EFFECT_TYPE_HEAL_RECV_INC, WOW_EFFECT_TYPE_HEAL_RECV_DEC: {format(typeString, sizeof(typeString), "from");}
	}
	
	new playersString2[144 + 1];
	format(playersString2, sizeof(playersString2), "%s", playersString);
	if(!isnull(playersString)) {
    	if(!strcmp(playersString, WOW_INVALID_STRING, true)) {
    	    if(psize == 1) {
    	        if(players[0] == -1) {
    	        	//format(playersString2, sizeof(playersString2), " %s", "for all players");
    	        	format(playersString2, sizeof(playersString2), "%s", "");
    	        } else {
    	        	format(playersString2, sizeof(playersString2), " %s player %d", typeString, players[0]);
    	        }
    	    } else {
				format(playersString2, sizeof(playersString2), " %s players", typeString);
	    	    for(new player = 0; player < psize; player++) {
	    	        if(player != 0) {
						format(playersString2, sizeof(playersString2), "%s, %d", playersString2, players[player]);
					} else {
						format(playersString2, sizeof(playersString2), "%s %d", playersString2, players[player]);
					}
	    	    }
    	    }
    	} else {
    	    strins(playersString2, " ", 0, sizeof(playersString2));
    	}
	}
	
	new damRecvString[60];
	if(type == WOW_EFFECT_TYPE_DAM_RECV_DEC) {
	    if(amount >= 100.0) {
			format(damRecvString, sizeof(damRecvString), "Immune to all damage");
		} else {
			format(damRecvString, sizeof(damRecvString), "Damage taken reduced by %s", percentString);
		}
	}
	switch(type) {
		case WOW_EFFECT_TYPE_DOT: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: Damages %s every %s%s.", name, percentString, intervalString, durationString);}
		case WOW_EFFECT_TYPE_HOT: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: Heals %s every %s%s.", name, percentString, intervalString, durationString);}
		case WOW_EFFECT_TYPE_HEAL_DONE_INC: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: Healing done increased by %s%s%s.", name, percentString, durationString, playersString2);}
		case WOW_EFFECT_TYPE_HEAL_DONE_DEC: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: Healing done reduced by %s%s%s.", name, percentString, durationString, playersString2);}
		case WOW_EFFECT_TYPE_HEAL_RECV_INC: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: Healing received increased by %s%s%s.", name, percentString, durationString, playersString2);}
		case WOW_EFFECT_TYPE_HEAL_RECV_DEC: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: Healing received reduced by %s%s%s.", name, percentString, durationString, playersString2);}
		case WOW_EFFECT_TYPE_DAM_DONE_INC: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: Damage done increased by %s%s%s%s%s.", name, percentString, durationString, bodypartsString2, weaponsString2, playersString2);}
		case WOW_EFFECT_TYPE_DAM_DONE_DEC: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: Damage done reduced by %s%s%s%s%s.", name, percentString, durationString, bodypartsString2, weaponsString2, playersString2);}
		case WOW_EFFECT_TYPE_DAM_RECV_INC: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: Damage taken increased by %s%s%s%s%s.", name, percentString, durationString, bodypartsString2, weaponsString2, playersString2);}
		case WOW_EFFECT_TYPE_DAM_RECV_DEC: {format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: %s%s%s%s%s.", name, damRecvString, durationString, bodypartsString2, weaponsString2, playersString2);}
	}
}
stock WOW_GivePlayerEffect(playerid, issuerid, effect) {
	//TODO start eerste keer X2
	if(IsPlayerConnected(playerid) && WOW_IsValidEffect(effect) && IsPlayerConnected(issuerid) && !WOW_ArrayContains(playerid, WOW_Effects[effect][IMMUNES])) {
	    //Refresh
	    //TODO moment wnn ticks gebeuren nakijken
		for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
			if(WOW_EffectsOnPlayer[playerid][effectslot][EFFECT] == effect && WOW_EffectsOnPlayer[playerid][effectslot][ISSUERID] == issuerid) {
				KillTimer(WOW_EffectsOnPlayer[playerid][effectslot][TIMERID]);
				WOW_EffectsOnPlayer[playerid][effectslot][TIMERID] = WOW_INVALID_TIMER_ID;
				WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] = WOW_Effects[effect][DURATION];
				if(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] != -1) {
					new string[5];
					if(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] < 60) {
						format(string, sizeof(string), "%d", WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT]);
					} else {
						format(string, sizeof(string), "%dm", floatround(float(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT]) / 60, floatround_ceil));
					}
					PlayerTextDrawSetString(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], string);
					PlayerTextDrawShow(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW]);
				}
				WOW_EffectsOnPlayer[playerid][effectslot][TIMERID] = SetTimerEx("WOW_EffectTick", WOW_Effects[effect][INTERVAL], true, "dd", playerid, effectslot);
				return effectslot;
			}
		}
		//New
		for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
			if(WOW_EffectsOnPlayer[playerid][effectslot][EFFECT] == WOW_INVALID_EFFECT_ID) {
				WOW_EffectsOnPlayer[playerid][effectslot][EFFECT] = effect;
			    WOW_EffectsOnPlayer[playerid][effectslot][ISSUERID] = issuerid;
  				WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] = WOW_Effects[effect][DURATION];
				TextDrawShowForPlayer(playerid, WOW_Icons[effectslot]);
				if(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] != -1) {
					new string[5];
					if(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT] < 60) {
						format(string, sizeof(string), "%d", WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT]);
					} else {
						format(string, sizeof(string), "%dm", floatround(float(WOW_EffectsOnPlayer[playerid][effectslot][TICKS_LEFT]) / 60, floatround_ceil));
					}
					PlayerTextDrawSetString(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW], string);
					PlayerTextDrawShow(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW]);
				}
				WOW_EffectsOnPlayer[playerid][effectslot][TIMERID] = SetTimerEx("WOW_EffectTick", WOW_Effects[effect][INTERVAL], true, "dd", playerid, effectslot);
				return effectslot;
		    }
	    }
    }
	return -1;
}



//Effect
native FAI_CreateEffectFull(name[], duration = 2000, Float:amount = 0.0, info[] = FAI_INVALID_STRING);
native FAI_CreateEffect(name[]);
native FAI_GetEffectName(effectid, name[], len);
native FAI_SetEffectName(effectid, name[]);
native FAI_GetEffectDuration(effectid);
native FAI_SetEffectDuration(effectid, duration);
native FAI_GetEffectAmount(effectid, &Float:amount);
native FAI_SetEffectAmount(effectid, Float:amount);
native FAI_GetEffectInfo(effectid, info[], len);
native FAI_SetEffectInfo(effectid, info[]);
native FAI_DestroyEffect(effectid);
native FAI_DestroyAllEffects();
native bool:FAI_IsValidEffect(effectid);
native FAI_EffectToString(effectid, string[], len, bool:allowDefaultColors = true);

//Tick
//TODO

//Tick
//TODO

//Effect
#if !defined FAI_MAX_EFFECTS
	#define FAI_MAX_EFFECTS					20
#endif
#if !defined FAI_MAX_EFFECT_NAME
	#define FAI_MAX_EFFECT_NAME				30
#endif
#if !defined FAI_MAX_EFFECT_INFO
	#define FAI_MAX_EFFECT_INFO				144
#endif
#define FAI_INVALID_EFFECT_ID				-1
enum FAI_ENUM_EFFECT {
	//Can be set by the user
	NAME[FAI_MAX_EFFECT_NAME + 1],
	DURATION,
	Float:AMOUNT,
	INFO[FAI_MAX_EFFECT_INFO + 1]
}
static FAI_Effects[FAI_MAX_EFFECTS][FAI_ENUM_EFFECT];

//Tick
//TODO
#define FAI_MAX_EFFECTS_PER_BOSS            10
#define FAI_INVALID_TICK_PROGRESS       	-1
enum FAI_ENUM_TICK {
	//Can be set by the user
	EFFECTID,
	TICK_PROGRESS
}
static FAI_Ticks[FAI_MAX_BOSSES][FAI_MAX_EFFECTS_PER_BOSS][FAI_ENUM_TICK];

//Effect
//FAI_InitAllEffects();

//Tick
//TODO

//Effect
//FAI_DestroyAllEffects();

//Tick
//TODO

//Effect
static FAI_InitAllEffects() {
	for(new effectid = 0; effectid < FAI_MAX_EFFECTS; effectid++) {
	    FAI_InitEffect(effectid);
	}
}
static FAI_InitEffect(effectid) {
	//Don't use FAI_IsValidEffect(effectid)
	if(effectid >= 0 && effectid < FAI_MAX_EFFECTS) {
		FAI_strcpy(FAI_Effects[effectid][NAME], FAI_INVALID_STRING, FAI_MAX_EFFECT_NAME + 1);
		FAI_Effects[effectid][DURATION] = 0;
		FAI_Effects[effectid][AMOUNT] = 0.0;
		FAI_strcpy(FAI_Effects[effectid][INFO], FAI_INVALID_STRING, FAI_MAX_EFFECT_INFO + 1);
	}
}
stock bool:FAI_IsValidEffect(effectid) {
	if(effectid >= 0 && effectid < FAI_MAX_EFFECTS && strcmp(FAI_Effects[effectid][NAME], FAI_INVALID_STRING, true)) {
	    return true;
	}
	return false;
}
stock FAI_DestroyAllEffects() {
	for(new effectid = 0; effectid < FAI_MAX_EFFECTS; effectid++) {
	    FAI_DestroyEffect(effectid);
	}
	return 1;
}
stock FAI_DestroyEffect(effectid) {
	if(FAI_IsValidEffect(effectid)) {
		FAI_RemoveEffectFromAllBosses(effectid);
		FAI_InitEffect(effectid);
		return 1;
	}
	return 0;
}
stock FAI_CreateEffectFull(name[], duration = 2000, Float:amount = 0.0, info[] = FAI_INVALID_STRING) {
	for(new effectid = 0; effectid < FAI_MAX_EFFECTS; effectid++) {
	    if(!strcmp(FAI_Effects[effectid][NAME], FAI_INVALID_STRING, true)) {
	    	FAI_strcpy(FAI_Effects[effectid][NAME], name, FAI_MAX_EFFECT_NAME + 1);
			FAI_SetEffectName(effectid, name);
			FAI_SetEffectDuration(effectid, duration);
			FAI_SetEffectAmount(effectid, amount);
			FAI_SetEffectInfo(effectid, info);
	    	return effectid;
		}
	}
	//Max amount of effects reached
	return FAI_INVALID_EFFECT_ID;
}
stock FAI_CreateEffect(name[]) {
	return FAI_CreateEffectFull(name);
}
stock FAI_GetEffectName(effectid, name[], len) {
	if(FAI_IsValidEffect(effectid)) {
	    FAI_strcpy(name, FAI_Effects[effectid][NAME], len);
		return strlen(name);
	}
	return -1;
}
stock FAI_SetEffectName(effectid, name[]) {
	if(FAI_IsValidEffect(effectid)) {
	    FAI_strcpy(FAI_Effects[effectid][NAME], name, FAI_MAX_EFFECT_NAME + 1);
	    //TODO
	    for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
	        if(FAI_IsValidBoss(bossid) && (FAI_IsBossCastingSpell(bossid, spellid) || FAI_IsBossCastBarExtraForSpell(bossid, spellid))) {
				TextDrawSetString(FAI_Bosses[bossid][TEXTDRAW][6], FAI_Spells[spellid][NAME]);
				//Textdraw updates automatically
	        }
	    }
	    //END TODO
		return 1;
	}
	return 0;
}
stock FAI_GetEffectDuration(effectid) {
	if(FAI_IsValidEffect(effectid)) {
	    return FAI_Effects[effectid][DURATION];
	}
	return -1;
}
stock FAI_SetEffectDuration(effectid, duration) {
	if(FAI_IsValidSpell(spellid)) {
	    if(duration < 0) {
			duration = 0;
		}
		new oldDuration = FAI_Effects[effectid][DURATION];
		FAI_Effects[effectid][DURATION] = duration;
		//TODO
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
		//END TODO
	    return 1;
	}
	return 0;
}
stock FAI_GetEffectAmount(effectid, &Float:amount) {
	if(FAI_IsValidEffect(effectid)) {
	    amount = FAI_Effects[effectid][AMOUNT];
	    return 1;
	}
	return 0;
}
stock FAI_SetEffectAmount(effectid, Float:amount) {
	if(FAI_IsValidEffect(effectid)) {
	    if(amount < 0.0) {
			amount = 0.0;
		}
	    FAI_Effects[effectid][AMOUNT] = amount;
	    return 1;
	}
	return 0;
}
stock FAI_GetEffectInfo(effectid, info[], len) {
	if(FAI_IsValidEffect(effectid)) {
	    return FAI_strcpy(info, FAI_Effects[effectid][INFO], len);
	}
	return -1;
}
stock FAI_SetEffectInfo(effectid, info[]) {
	if(FAI_IsValidEffect(effectid)) {
		//If the user didn't provide info, construct info based on other settings
		if(!FAI_isnull(info) && !strcmp(info, FAI_INVALID_STRING, true)) {
			new string[FAI_MAX_EFFECT_INFO + 1];
			new amountString[21 + 8 + 1];
			format(amountString, sizeof(amountString), "Amount %s.", FAI_DisplayReadableFloat(FAI_Effects[effectid][AMOUNT], 2, 0));
			new durationString[21 + 7 + 1];
			if(FAI_Effects[effectid][DURATION] != 0) {
				if(float(FAI_Effects[effectid][DURATION]) / 1000 / 60 >= 1) {
					format(durationString, sizeof(durationString), "%s minute", FAI_DisplayReadableFloat(float(FAI_Effects[effectid][DURATION]) / 1000 / 60, 2, 0));
				} else {
					format(durationString, sizeof(durationString), "%s second", FAI_DisplayReadableFloat(float(FAI_Effects[effectid][DURATION]) / 1000, 2, 0));
				}
			} else {
				FAI_strcpy(durationString, "Permanent");
			}
			format(string, sizeof(string), "%s %s duration.", amountString, durationString);
		    FAI_strcpy(FAI_Effects[effectid][INFO], string, FAI_MAX_EFFECT_INFO + 1);
		}
		//If the user did provide info, use that one
		else {
		    FAI_strcpy(FAI_Effects[effectid][INFO], info, FAI_MAX_EFFECT_INFO + 1);
		}
		return 1;
	}
	return 0;
}
stock FAI_EffectToString(effectid, string[], len, bool:allowDefaultColors = true) {
	if(FAI_IsValidEffect(effectid)) {
	    if(allowDefaultColors) {
	    	format(string, len, "{%06x}%s: {%06x}%s", 0xffffffff >>> 8, FAI_Effects[effectid][NAME], 0xffd517ff >>> 8, FAI_Effects[effectid][INFO]);
	    } else {
	    	format(string, len, "%s: %s", FAI_Effects[effectid][NAME], FAI_Effects[effectid][INFO]);
	    }
		return strlen(string);
	}
	return -1;
}

/*stock FAI_RemoveAllEffectsFromAllBosses() {
	for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
		FAI_RemoveAllEffectsFromBoss(bossid);
	}
	return 1;
}
stock FAI_RemoveAllEffectsFromBoss(bossid) {
	if(FAI_IsValidBoss(bossid)) {
		return FAI_RemoveEffectFromBoss(bossid, FAI_Casting[bossid][EFFECTID]); //TODO casting
    }
    return 0;
}
stock FAI_RemoveEffectFromAllBosses(effectid) {
	if(FAI_IsValidEffect(effectid)) {
		for(new bossid = 0; bossid < FAI_MAX_BOSSES; bossid++) {
			FAI_RemoveEffectFromBoss(bossid, effectid);
		}
		return 1;
	}
	return 0;
}
stock FAI_RemoveEffectFromBoss(bossid, effectid) {
	if(FAI_IsValidBoss(bossid) && FAI_IsValidEffect(effectid) && FAI_IsBossCastingSpell(bossid, effectid)) {
	    FAI_BossCastProgressInComplete(bossid, spellid);
	    FAI_InitBossCasting(bossid);
	    return 1;
	}
	return 0;
}*/
/*native FAI_GiveBossEffect(bossid, effectid);
native FAI_GetBossEffects(bossid);
native FAI_SetBossEffects(bossid, effectid, bool:keepCastPercent = false);
native FAI_RemoveAllEffectsFromBoss(bossid);
native FAI_RemoveEffectFromBoss(bossid, effectid);
native FAI_RemoveAllEffectsFromAllBosses();
native FAI_RemoveEffectFromAllBosses(effectid);
native bool:FAI_HasBossAnyEffects(bossid);
native bool:FAI_HasBossEffect(bossid, effectid);*/

//Tick
//TODO
