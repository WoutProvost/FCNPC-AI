FCNPC A.I.
==========

1.1.0
-----

- Add license, credits and changelog files
- Add links in all files to the license and credits
- Added WOW_GetBossIDFromNPCID which is an alias for WOW_GetBossIDFromPlayerID
- Changed all aliases to macros, so that they don't call another pawn function
- Execute OnFilterScriptExit, OnGameModeExit and OnPlayerDisconnect hooks after they are called in the user's script, so you can use functions of the include in those callbacks
- Namechange to FCNPC A.I. in whole repo
- Changed prefix to FAI_ (also for the above mentioned functions)
- Renamed source and include files to FAI.pwn and FAI.inc to be conform with the namechange
- Updated example scripts by remove unnecessary destroy lines since the include does this automatically when the script exits
- Updated example scripts by destroying and resetting everything under OnPlayerDisconnect instead of OnFilterScriptExit, to handle all disconnect situatons, including script exit
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
- Added some extra checks FCNPC_IsSpawned checks
- Changed default speed to be eqaul to -1.0 (see FCNPC 1.1.0)
- Changed default ranged attack delay to be eqaul to -1 (see FCNPC 1.1.0)
- Fixed FAI_SpellToString spell name default color

1.0.0
-----

- Initial stable release
