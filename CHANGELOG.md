FCNPC A.I.
==========

2.0.0
-----
- TODO

1.1.1
-----
- Added behaviour
- Added billion suffix to FAI_SHORTEN_HEALTH
- Added special distance value -1 to FAI_SetBossRangedAttackInfo and FAI_SetBossMeleeAttackInfo to keep the NPC in place when attacking
- Renamed FAI_SHORTEN_HEALTH to FAI_SHORTEN_NUMBERS
- Renamed distance parameter from FAI_GetBossRangedAttackInfo, FAI_SetBossRangedAttackInfo, FAI_GetBossMeleeAttackInfo and FAI_SetBossMeleeAttackInfo to range
- Deleted spell and percent types
- Deleted FAI_CreateFull... natives
- Changed max health default to 100.0
- Changed display range default to 0.0
- Changed move type default to MOVE_TYPE_AUTO and changed move type default in FAI_SetBossMoveInfo to MOVE_TYPE_AUTO
- Changed allow NPC targets default to true
- Fixed unnecessary loop in FAI_DestroyAllSpells
- Added an additional check to FAI_IsPlayerInDisplayRange and FAI_IsPlayerInAggroRange
- Examples updated with above changes
- Added SummonAdds spell to MMO example
- Added reduce cast progress a bit when damaged to MMO example

1.1.0
-----
- Add license, credits and changelog files
- Add links in all files to the license and credits
- Added WOW_GetBossIDFromNPCID which is an alias for WOW_GetBossIDFromPlayerID
- Changed all aliases to macros, so that they don't call another pawn function
- Execute OnFilterScriptExit, OnGameModeExit and OnPlayerDisconnect hooks after they are called in the user's script, so you can use functions of the include in those callbacks
- Name change to FCNPC A.I. in whole repo
- Changed prefix to FAI_ (also for the above mentioned functions)
- Renamed source and include files to FAI.pwn and FAI.inc to be conform with the name change
- Updated example scripts by remove unnecessary destroy lines since the include does this automatically when the script exits
- Updated example scripts by destroying and resetting everything under OnPlayerDisconnect instead of OnFilterScriptExit, to handle all disconnect situations, including script exit
- Updated example scripts with changed prefix

1.0.3
-----
- Internal: Better strcpy function (by ZiGGi)
- Internal: Better GetTickCount overflow fix (by ZiGGi)
- Fixed useFightStyle default value to be conform with FCNPC (true to false)
- Added FAI_GetBossAllowNPCTargets and FAI_SetBossAllowNPCTargets which defaults to false
- Renamed FAI_GetBossNPCID and FAI_GetBossIDFromPlayerID to be conform with samp naming conventions
- Added FAI_GetBossPlayerID which is an alias for FAI_GetBossNPCID
- Added FAI_IsEncounterStarted and FAI_StopEncounter

1.0.2
-----
- Changed default move speed to MOVE_SPEED_AUTO to be conform with FCNPC 1.1.1
- Added individual useMapAndreas setting
- FAI_USE_MAP_ANDREAS is now a global value that determines if MapAndreas is used by any boss
- Refer to the wiki pages for more info
- Updated example scripts to handle the changes
- Updated credits
- Removed colandreas upcoming feature, since it will be implemented in FCNPC 2.0

1.0.1
-----
- Added check to see if MapAndreas was already initialized and don't initialize again when it is
- Added default values for the FAI_SetBoss...Info methods
- Added extra checks to prevent unnecessary FCNPC_GoToPlayer/FCNPC_AimAtPlayer/FCNP_MeleeAttack calls
- Added some extra FCNPC_IsSpawned checks
- Changed default speed to be equal to -1.0 (see FCNPC 1.1.0)
- Changed default ranged attack delay to be equal to -1 (see FCNPC 1.1.0)
- Fixed FAI_SpellToString spell name default color

1.0.0
-----
- Initial stable release