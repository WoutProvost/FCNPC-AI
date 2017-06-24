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

#define WOW_MAX_EFFECTS                 20
#define WOW_MAX_EFFECT_NAME				20
#define WOW_MAX_EFFECT_INFO				144
#define WOW_MAX_EFFECTS_PER_PLAYER      9
#define WOW_MAX_WEAPONS                 205
#define WOW_MAX_BODYPARTS               10
#define WOW_INVALID_EFFECT_ID			-1
#define WOW_INVALID_WEAPON_ID			-1
#define WOW_INVALID_BODYPART_ID			-1
enum {
	WOW_EFFECT_TYPE_NONE,
	WOW_EFFECT_TYPE_DOT,
	WOW_EFFECT_TYPE_DAM_DONE_INC,
	WOW_EFFECT_TYPE_DAM_DONE_DEC,
	WOW_EFFECT_TYPE_DAM_RECV_INC,
	WOW_EFFECT_TYPE_DAM_RECV_DEC,
	WOW_EFFECT_TYPE_HOT,
	WOW_EFFECT_TYPE_HEAL_DONE_INC,
	WOW_EFFECT_TYPE_HEAL_DONE_DEC,
	WOW_EFFECT_TYPE_HEAL_RECV_INC,
	WOW_EFFECT_TYPE_HEAL_RECV_DEC
}
enum {
	WOW_PERCENT_TYPE_DAM_OR_HEAL
}
enum WOW_ENUM_EFFECT {
	NAME[WOW_MAX_EFFECT_NAME + 1],
	TYPE,
	Float:AMOUNT,
	IS_PERCENT_OF,
	DURATION,
	INTERVAL,
	IMMUNES[MAX_PLAYERS],
	PLAYERS[MAX_PLAYERS],
	WEAPONS[WOW_MAX_WEAPONS],
	BODYPARTS[WOW_MAX_BODYPARTS],
	INFO[WOW_MAX_EFFECT_INFO + 1]
}
enum WOW_ENUM_EFFECT_ON_PLAYER {
	EFFECT,
	ISSUERID,
	TICKS_LEFT,
	TIMERID,
	PlayerText:TEXTDRAW
}
new WOW_Effects[WOW_MAX_EFFECTS][WOW_ENUM_EFFECT];
new WOW_EffectsOnPlayer[MAX_PLAYERS][WOW_MAX_EFFECTS_PER_PLAYER][WOW_ENUM_EFFECT_ON_PLAYER];

enum {
	WOW_SPELL_TYPE_GIVE_EFFECT
}
enum WOW_ENUM_SPELL {
	EFFECT
}

new Text:WOW_Icons[WOW_MAX_EFFECTS_PER_PLAYER] = {Text:INVALID_TEXT_DRAW, ...};


//TODO replace effect when full???
#if defined FILTERSCRIPT
public OnFilterScriptInit()
{
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
	return 1;
}

public OnFilterScriptExit()
{
    WOW_DestroyAllEffects();
	for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
		TextDrawDestroy(WOW_Icons[effectslot]);
		WOW_Icons[effectslot] = Text:INVALID_TEXT_DRAW;
		for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
			PlayerTextDrawDestroy(playerid, WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW]);
			WOW_EffectsOnPlayer[playerid][effectslot][TEXTDRAW] = PlayerText:INVALID_TEXT_DRAW;
		}
 	}
	return 1;
}
#endif

//INTERNAL
stock WOW_Init() {
	//Can't use removeall, because this won't work with isvalid, because [EFFECT] & [SPELL] default to 0 ipv -1
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
	    for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
			WOW_EffectsOnPlayer[playerid][effectslot][EFFECT] = WOW_INVALID_EFFECT_ID;
		}
	}
	return 1;
}
stock bool:WOW_ArrayContains(item, array[], asize = sizeof(array)) {
	for(new a = 0; a < asize; a++) {
	    if(array[a] == item) {
	        return true;
	    }
	}
	return false;
}
stock bool:WOW_IsValidEffect(effect) {
	if(effect != WOW_INVALID_EFFECT_ID && effect >= 0 && effect < WOW_MAX_EFFECTS && WOW_Effects[effect][TYPE] != WOW_EFFECT_TYPE_NONE) {
	     return true;
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
stock WOW_GetEffectIdFromName(name[]) {
	for(new globalEffect = 0; globalEffect < WOW_MAX_EFFECTS; globalEffect++) {
	    if(!strcmp(WOW_Effects[globalEffect][NAME], name, true)) {
	        return globalEffect;
		}
	}
	return WOW_INVALID_EFFECT_ID;
}
stock WOW_GetSpellIdFromName(name[]) {
	for(new spell = 0; spell < WOW_MAX_SPELLS; spell++) {
	    if(!strcmp(WOW_Spells[spell][NAME], name, true)) {
	        return spell;
		}
	}
	return WOW_INVALID_SPELL_ID;
}
stock WOW_DestroyAllEffects() {
	for(new globalEffect = 0; globalEffect < WOW_MAX_EFFECTS; globalEffect++) {
	    if(WOW_IsValidEffect(globalEffect)) {
	    	WOW_DestroyEffect(globalEffect);
	    }
	}
	return 1;
}
stock WOW_DestroyEffect(effect) {
	if(WOW_IsValidEffect(effect)) {
		WOW_RemoveEffectFromAll(effect);

		format(WOW_Effects[effect][NAME], WOW_MAX_EFFECT_NAME + 1, "%s", WOW_INVALID_STRING);
		WOW_Effects[effect][TYPE] = WOW_EFFECT_TYPE_NONE;
		WOW_Effects[effect][AMOUNT] = 0.0;
		WOW_Effects[effect][IS_PERCENT_OF] = WOW_PERCENT_TYPE_NONE;
		WOW_Effects[effect][DURATION] = 0;
		WOW_Effects[effect][INTERVAL] = 0;
		/*WOW_Effects[effect][IMMUNES] = {INVALID_PLAYER_ID};
		WOW_Effects[effect][PLAYERS] = {-1};
		WOW_Effects[effect][WEAPONS] = {-1};
		WOW_Effects[effect][BODYPARTS] = {-1};*/
		//TODO
		format(WOW_Effects[effect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s", WOW_INVALID_STRING);
		return 1;
	}
	return -1;
}
stock WOW_RemoveEffectFromAll(effect) {
	if(WOW_IsValidEffect(effect)) {
		for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
			WOW_RemoveEffectFromPlayer(playerid, effect);
		}
		return 1;
	}
	return -1;
}
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
stock WOW_RemoveAllEffectsFromAll() {
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
		WOW_RemoveAllEffectsFromPlayer(playerid);
	}
	return 1;
}
stock WOW_RemoveAllEffectsFromPlayer(playerid) {
	for(new effectslot = 0; effectslot < WOW_MAX_EFFECTS_PER_PLAYER; effectslot++) {
	    if(WOW_IsValidEffectInSlot(playerid, effectslot)) {
			WOW_RemoveEffectInSlot(playerid, effectslot);
		}
	}
	return 1;
}
stock WOW_CreateEffect(name[], type, Float:amount, isPercentOf, duration, interval, immunes[] = {INVALID_PLAYER_ID}, players[] = {-1}, weapons[] = {-1}, bodyparts[] = {-1},
completeString[] = WOW_INVALID_STRING, playersString[] = WOW_INVALID_STRING, weaponsString[] = WOW_INVALID_STRING, bodypartsString[] = WOW_INVALID_STRING, isize = sizeof(immunes), psize = sizeof(players), wsize = sizeof(weapons), bsize = sizeof(bodyparts)) {
	if(type != WOW_EFFECT_TYPE_NONE && isPercentOf != WOW_PERCENT_TYPE_NONE) {
		for(new globalEffect = 0; globalEffect < WOW_MAX_EFFECTS; globalEffect++) {
		    if(WOW_Effects[globalEffect][TYPE] == WOW_EFFECT_TYPE_NONE) {
	    		format(WOW_Effects[globalEffect][NAME], WOW_MAX_EFFECT_NAME + 1, "%s", name);
		    	WOW_Effects[globalEffect][TYPE] = type;
		    	WOW_Effects[globalEffect][AMOUNT] = amount;
		    	WOW_Effects[globalEffect][IS_PERCENT_OF] = isPercentOf;
		    	WOW_Effects[globalEffect][DURATION] = duration;
		    	WOW_Effects[globalEffect][INTERVAL] = interval;
		    	/*WOW_Effects[globalEffect][IMMUNES] = immunes;
				WOW_Effects[globalEffect][PLAYERS] = players;
		    	WOW_Effects[globalEffect][WEAPONS] = weapons;
		    	WOW_Effects[globalEffect][BODYPARTS] = bodypars;*/
		    	//TODO

				//Reduce can't be above 100.0 and increase can't be below 0.0, because that would lead to the opposite effect
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
				if(!isnull(completeString) && !strcmp(completeString, WOW_INVALID_STRING, true)) {
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
			    	new percentString[30];
		    		WOW_RemoveUnnecessaryDecimals(percentString, amount, 2);
			    	switch(isPercentOf) {
			    	    case WOW_PERCENT_TYPE_NOT: {format(percentString, sizeof(percentString), "%s", percentString);}
			    		case WOW_PERCENT_TYPE_TARG_MAX_HP: {format(percentString, sizeof(percentString), "%s%s of target's max HP", percentString, "%%");}
			    		case WOW_PERCENT_TYPE_CAST_MAX_HP: {format(percentString, sizeof(percentString), "%s%s of caster's max HP", percentString, "%%");}
			    		case WOW_PERCENT_TYPE_TARG_CUR_HP: {format(percentString, sizeof(percentString), "%s%s of target's remaining HP", percentString, "%%");}
			    		case WOW_PERCENT_TYPE_CAST_CUR_HP: {format(percentString, sizeof(percentString), "%s%s of caster's remaining HP", percentString, "%%");}
			    	    case WOW_PERCENT_TYPE_DAM_OR_HEAL: {format(percentString, sizeof(percentString), "%s%s", percentString, "%%");}
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
		    	} else {
		    	    format(WOW_Effects[globalEffect][INFO], WOW_MAX_EFFECT_INFO + 1, "%s: %s.", name, completeString);
		    	}
		        return globalEffect;
		    }
		}
	}
	return WOW_INVALID_EFFECT_ID;
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
