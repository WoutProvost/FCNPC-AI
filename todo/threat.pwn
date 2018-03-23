/*
The threat system is based on the one used in World of Warcraft. Documentation on that system can be found [here](http://wowwiki.wikia.com/wiki/Threat) and [here](http://wowwiki.wikia.com/wiki/Kenco%27s_research_on_threat). The following bullet points summarize what parts of that system are implemented in this include.

Threat summary:
- When a player has aggro it means that the NPC is attacking that particular player.
- Threat is a numeric value that an NPC has towards each player. 1 point of damage results in 1 point of threat.
- The target is not necessarily the player with the most threat. When player0 is the target, player1 must do more than just exceed the threat of player0. For player1 to become the target, he must exceed 130% of player0's threat.
- There is no threat associated with body-pulling. The NPC just targets the player without the player generating threat.
- Since 2 or more players can have the same threat value, the player with the lowest ID will have precedence.
- When using a potential taunt ability, the taunting player should be given as much threat as the target. This means that there could be a player3 who has more threat than the target, due to 130% needed, that could easily overaggro the taunting player.
*/

/*
SCENARIO (OK):
- Encounter not started
- No closest player
==> Remain idle

SCENARIO (OK):
- Encounter not started
- A player with unfriendly behaviour enters aggro range
==> That player becomes target

SCENARIO (OK):
- Encounter not started
- A player with neutral/unfriendly behaviour deals damage
==> Increase threat according to damage
==> That player becomes target

SCENARIO (OK):
- Encounter started
- No players with threat
- A player with neutral/unfriendly behaviour deals damage
==> Increase threat according to damage
==> Get player with highest threat (THAT_PLAYER)
==> That player becomes target

SCENARIO (OK):
- Encounter started
- 1 player with threat (target)
- A player with neutral/unfriendly behaviour deals damage
==> Increase threat according to damage
==> Get player with highest threat (THAT_PLAYER)
==> That player becomes target

SCENARIO (OK):
- Encounter started
- No players with threat
- Target becomes invalid
==> Reset his threat
==> Get player with highest threat (INVALID_PLAYER_ID)
==> Get closest player (INVALID_PLAYER_ID)
==> Stop encounter

SCENARIO (OK):
- Encounter started
- No players with threat
- Target becomes invalid
==> Reset his threat
==> Get player with highest threat (INVALID_PLAYER_ID)
==> Get closest player (VALID_PLAYER_ID)
==> That player becomes target

SCENARIO (OK):
- Encounter started
- 1 player with threat (target)
- Target becomes invalid
==> Reset his threat
==> Get player with highest threat (INVALID_PLAYER_ID)
==> Get closest player (INVALID_PLAYER_ID)
==> Stop encounter

SCENARIO (OK):
- Encounter started
- 1 player with threat (target)
- Target becomes invalid
==> Reset his threat
==> Get player with highest threat (INVALID_PLAYER_ID)
==> Get closest player (VALID_PLAYER_ID)
==> That player becomes target

SCENARIO (OK):
- Encounter started
- Multiple players with threat (including target)
- One of those players (not the target) becomes invalid
==> Reset his threat

SCENARIO (OK):
- Encounter started
- Multiple players with threat (including target)
- Target becomes invalid
==> Reset his threat
==> Get player with highest threat (VALID_PLAYER_ID)
==> That player becomes target

SCENARIO (OK):
- Encounter started
- Multiple players with threat (including target)
- One of those players with highest threat (not the target) gets > 130% of target's threat
==> That player becomes target
*/