/*
 * License:
 * See LICENSE.md included in the release download, or at https://github.com/WoutProvost/FCNPC-A.I./blob/master/LICENSE.md if not included.

 * Credits:
 * See CREDITS.md included in the release download, or at https://github.com/WoutProvost/FCNPC-A.I./blob/master/CREDITS.md if not included.
*/

#define FILTERSCRIPT

#include <FAI>

#define USE_STREAMER    true //Set this to false, if you don't use Incognito's streamer. This example script uses this streamer to create dynamic pickups and objects
#if USE_STREAMER == true
	#include <streamer>
#endif

#define INTERIOR_NORMAL             	0
#define VIRTUAL_WORLD_NORMAL        	0
#define ATTACHED_OBJECT_INDEX           0
#define AUDIO_STREAM_HALLOWEEN          "http://dl.dropboxusercontent.com/s/oddvow4138cf204/Halloween.mp3"
#define DEFAULT_WEATHER                 1  //Default samp weather
#define DEFAULT_TIME_H                  12 //Default samp time
#define DEFAULT_TIME_M                 	0  //Default samp time

new BossLeatherface = FAI_INVALID_BOSS_ID;
new PlayerInRangeTimer = FAI_INVALID_TIMER_ID;
new AudioStreamCount[MAX_PLAYERS] = {-1, ...};
new bool:AlreadyInOutRange[MAX_PLAYERS] = {false, ...}; //True = in range, false = not in range
new Objects[66] = {INVALID_OBJECT_ID,...};
new IdleCount;
new DeathCount;
new bool:AnimationApplied;
		
#if defined FILTERSCRIPT
public OnFilterScriptInit()
{
	BossLeatherface = FAI_CreateBoss("BossLeatherface");
	FAI_SetBossMaxHealth(BossLeatherface, 2000.0);
	FAI_SetBossMoveInfo(BossLeatherface, MOVE_TYPE_SPRINT);
	FAI_SetBossMeleeAttackInfo(BossLeatherface, 1.5, -1, false);
	SetBossAtSpawn(BossLeatherface);
	PlayerInRangeTimer = SetTimer("CheckPlayerInRange", 100, true);
	CreateBossObjects();
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
		if(bossid == BossLeatherface) {
			//FAI_DestroyBoss(BossLeatherface); //We don't need to do this, since the boss is already disconnecting
			BossLeatherface = FAI_INVALID_BOSS_ID;
			KillTimer(PlayerInRangeTimer);
			PlayerInRangeTimer = FAI_INVALID_TIMER_ID;
			for(new otherplayerid = 0, highestPlayerid = GetPlayerPoolSize(); otherplayerid <= highestPlayerid; otherplayerid++) {
				if(IsPlayerConnected(otherplayerid) && !IsPlayerNPC(otherplayerid)) {
			        if(AlreadyInOutRange[otherplayerid]) {
			        	AlreadyInOutRange[otherplayerid] = false;
				        SetPlayerWeather(otherplayerid, DEFAULT_WEATHER);
				        SetPlayerTime(otherplayerid, DEFAULT_TIME_H, DEFAULT_TIME_M);
				        if(AudioStreamCount[otherplayerid] != -1) {
				        	StopAudioStreamForPlayer(otherplayerid);
				        	AudioStreamCount[otherplayerid] = -1;
				        }
			        }
		    	}
		    }
			DestroyBossObjects();
		}
	}
	return 1;
}

public FCNPC_OnReachDestination(npcid)
{
	if(FAI_GetBossIDFromNPCID(npcid) == BossLeatherface) {
	    if(IdleCount != -1) {
			new Float:x, Float:y, Float:z;
			FCNPC_GetPosition(npcid, x, y, z);
			if(x <= -2812.0 && x >= -2814.0 && y <= -1516.0 && y >= -1518.0 && z <= 141.0 && z >= 139.0) {
				FCNPC_ApplyAnimation(npcid, "CHAINSAW", "WEAPON_csawlo", 4.1, 0, 1, 1, 0, 0);
			} else if(x <= -2818.0 && x >= -2820.0 && y <= -1515.0 && y >= -1517.0 && z <= 141.0 && z >= 139.0) {
				FCNPC_ApplyAnimation(npcid, "CHAINSAW", "WEAPON_csaw", 4.1, 0, 1, 1, 0, 0);
			} else if(x <= -2819.0 && x >= -2821.0 && y <= -1517.0 && y >= -1519.0 && z <= 141.0 && z >= 139.0) {
				FCNPC_GoTo(npcid, -2822.3176, -1518.7068, 140.7656, MOVE_TYPE_WALK);
			} else if(x <= -2816.0 && x >= -2818.0 && y <= -1523.0 && y >= -1525.0 && z <= 141.0 && z >= 139.0) {
				FCNPC_ApplyAnimation(npcid, "CHAINSAW", "CSAW_G", 4.1, 0, 1, 1, 0, 0);
			} else if(x <= -2810.0 && x >= -2812.0 && y <= -1523.0 && y >= -1525.0 && z <= 141.0 && z >= 139.0) {
				FCNPC_GoTo(npcid, -2818.3503, -1530.7013, 140.8438, MOVE_TYPE_WALK);
			}
		}
	}
	return 1;
}

public FAI_OnBossEncounterStart(bossid, bool:reasonShot, firstTarget)
{
	if(bossid == BossLeatherface) {
	    IdleCount = -1;
	}
	return 1;
}

public FAI_OnBossEncounterStop(bossid, bool:reasonDeath, lastTarget)
{
	if(bossid == BossLeatherface) {
		if(!reasonDeath) {
			SetBossAtSpawn(bossid);
	    } else {
	        //Respawn the boss somewhere between 5 and 10 minutes (both included)
	    	new randomMinutes = random(6) + 5;
			DeathCount = randomMinutes * 60 * 10;
			for(new playerid = 0, highestPlayerid = GetPlayerPoolSize(); playerid <= highestPlayerid; playerid++) {
				if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid)) {
			        if(AlreadyInOutRange[playerid]) {
			        	AlreadyInOutRange[playerid] = false;
				        SetPlayerWeather(playerid, DEFAULT_WEATHER);
				        SetPlayerTime(playerid, DEFAULT_TIME_H, DEFAULT_TIME_M);
				        if(AudioStreamCount[playerid] != -1) {
				        	StopAudioStreamForPlayer(playerid);
				        	AudioStreamCount[playerid] = -1;
				        }
			        }
				}
			}
	    }
    }
	return 1;
}

stock CreateBossObjects() {
	#if USE_STREAMER == true
		Objects[0] = CreateDynamicObject(2589, -2820.283447, -1515.626831, 137.583969, 176.600158, 2.899999, -15.600064, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[1] = CreateDynamicObject(2590, -2809.102050, -1519.912963, 142.724533, 180.0, 180.0, 133.0, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[2] = CreateDynamicObject(2803, -2812.046142, -1530.383300, 140.203887, 0.0, 0.0, -102.500068, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[3] = CreateDynamicObject(2805, -2811.576416, -1529.652465, 140.313140, 7.700000, -0.300002, 73.499977, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[4] = CreateDynamicObject(2805, -2811.576416, -1529.652465, 140.313140, 7.700000, -0.300002, 73.499977, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[5] = CreateDynamicObject(2804, -2811.598632, -1515.496582, 139.903717, 180.0, 0.0, 174.0, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[6] = CreateDynamicObject(2806, -2811.841064, -1515.717895, 139.883789, 180.0, 0.0, 0.0, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[7] = CreateDynamicObject(2806, -2812.542480, -1515.494873, 139.853805, 0.0, 0.0, 114.899940, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[8] = CreateDynamicObject(2806, -2812.196777, -1515.754638, 139.853683, 0.000000, 0.000000, -143.899948, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[9] = CreateDynamicObject(2806, -2812.744628, -1515.080322, 139.853805, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[10] = CreateDynamicObject(2806, -2812.066162, -1515.261962, 139.853805, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[11] = CreateDynamicObject(2806, -2811.482177, -1515.970336, 139.853805, 0.000000, 0.000000, -161.900009, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[12] = CreateDynamicObject(2806, -2811.688476, -1515.475463, 139.983673, 0.000000, 0.000000, 67.700065, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[13] = CreateDynamicObject(2806, -2811.756103, -1515.412963, 141.013748, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[14] = CreateDynamicObject(2806, -2811.543945, -1515.579223, 140.803756, 0.000000, 0.000000, 17.399963, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[15] = CreateDynamicObject(2806, -2812.126708, -1515.293579, 140.893783, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[16] = CreateDynamicObject(2806, -2812.590820, -1515.395751, 140.753677, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[17] = CreateDynamicObject(2806, -2813.016601, -1515.581176, 140.643676, 0.000000, 0.000000, -152.899948, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[18] = CreateDynamicObject(2806, -2813.154296, -1515.236694, 140.167861, 57.699989, -84.400009, -179.500045, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[19] = CreateDynamicObject(2806, -2813.284667, -1515.344238, 139.853805, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[20] = CreateDynamicObject(2806, -2813.437744, -1515.286132, 140.196533, 57.600002, 0.000000, -82.699974, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[21] = CreateDynamicObject(2806, -2813.359619, -1515.630249, 140.196868, 58.700000, 1.199972, -57.200000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[22] = CreateDynamicObject(2806, -2813.704101, -1515.534667, 139.863800, 0.000000, 0.000000, -142.300018, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[23] = CreateDynamicObject(2806, -2812.384277, -1515.818725, 140.713806, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[24] = CreateDynamicObject(2806, -2811.709228, -1515.833740, 140.703826, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[25] = CreateDynamicObject(2806, -2812.042968, -1515.506347, 140.803756, 0.000000, 0.000000, -67.799972, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[26] = CreateDynamicObject(2806, -2811.797851, -1516.301635, 139.843811, 0.000000, 0.000000, -77.300003, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[27] = CreateDynamicObject(2806, -2813.293457, -1516.181274, 139.853805, 0.000000, 0.000000, -97.600059, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[28] = CreateDynamicObject(2806, -2812.561279, -1516.488769, 139.853805, 0.000000, 0.000000, -76.000015, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[29] = CreateDynamicObject(2806, -2811.656982, -1516.644165, 139.843887, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[30] = CreateDynamicObject(2806, -2811.715820, -1516.182617, 140.663818, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[31] = CreateDynamicObject(2806, -2811.692138, -1516.477294, 140.540893, 0.000000, 146.899917, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[32] = CreateDynamicObject(2806, -2811.389892, -1516.514892, 140.417037, -27.399986, 115.700019, 124.800003, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[33] = CreateDynamicObject(2806, -2811.519287, -1516.692626, 140.312561, 36.400009, 0.000000, 10.699976, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[34] = CreateDynamicObject(2806, -2811.511474, -1517.289550, 139.854324, 33.900001, 0.000000, 19.400024, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[35] = CreateDynamicObject(2806, -2811.984130, -1517.155273, 139.823806, 0.000000, 0.000000, -92.599990, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[36] = CreateDynamicObject(2806, -2813.416503, -1516.090087, 139.969879, -28.500005, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[37] = CreateDynamicObject(2806, -2812.256347, -1516.344970, 140.456451, 32.499996, 0.600000, -0.999983, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[38] = CreateDynamicObject(2806, -2811.971435, -1516.628417, 140.305068, -26.100000, 0.000000, -93.000038, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[39] = CreateDynamicObject(2806, -2811.876220, -1516.332153, 140.453765, 0.000000, 0.000000, -65.099990, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[40] = CreateDynamicObject(2806, -2812.140136, -1516.934936, 140.003768, 0.000000, 0.000000, 116.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[41] = CreateDynamicObject(2806, -2812.049560, -1516.640380, 140.153747, 0.000000, 0.000000, -91.099990, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[42] = CreateDynamicObject(2806, -2812.594726, -1516.386596, 140.361816, -28.399995, 0.000000, 175.100036, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[43] = CreateDynamicObject(2806, -2812.579589, -1516.207275, 140.499771, 25.300004, 0.000000, 4.300006, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[44] = CreateDynamicObject(2806, -2812.392822, -1516.901489, 140.048461, -25.699998, 0.000000, -168.100006, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[45] = CreateDynamicObject(2806, -2812.729003, -1516.819213, 140.030639, -21.500005, 0.000000, 178.700012, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[46] = CreateDynamicObject(2806, -2813.622558, -1516.522216, 139.827178, -178.900024, 0.000000, 155.599945, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[47] = CreateDynamicObject(2806, -2813.221191, -1516.885009, 139.853805, 0.000000, 0.000000, 75.400009, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[48] = CreateDynamicObject(2806, -2812.894531, -1516.119262, 140.506149, -26.199998, 30.300006, -169.600036, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[49] = CreateDynamicObject(2806, -2813.292968, -1516.152343, 140.164871, 38.499984, 0.000000, -58.900043, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[50] = CreateDynamicObject(2806, -2812.950927, -1516.503173, 140.145507, 0.000000, 36.199996, -129.499984, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[51] = CreateDynamicObject(2804, -2814.189208, -1515.342041, 139.892349, 0.000000, 0.500001, -74.700004, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[52] = CreateDynamicObject(2804, -2813.266113, -1516.066040, 140.422958, 50.200008, 0.000000, -54.000003, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[53] = CreateDynamicObject(2806, -2813.052734, -1515.990356, 140.396957, -51.500019, 0.000000, 121.200004, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[54] = CreateDynamicObject(2806, -2813.332275, -1516.409179, 139.992385, 0.000000, 37.099990, -147.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[55] = CreateDynamicObject(2907, -2817.714843, -1525.155761, 139.923934, 0.000000, 0.000000, -90.300018, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[56] = CreateDynamicObject(2908, -2818.315673, -1525.193603, 139.922134, 16.600000, 90.599998, -88.400009, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[57] = CreateDynamicObject(2906, -2817.869628, -1524.635375, 139.927902, 0.000000, 111.000015, 0.000000, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[58] = CreateDynamicObject(2906, -2817.750488, -1525.505126, 139.894653, 0.299999, 0.000000, -116.500122, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[58] = CreateDynamicObject(2905, -2816.912109, -1525.427490, 139.975051, 1.900001, 91.599990, -105.899925, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[59] = CreateDynamicObject(2905, -2817.004150, -1524.964843, 139.982269, -0.199999, 91.999969, 42.800048, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[60] = CreateDynamicObject(3007, -2812.885742, -1517.281616, 140.038085, 0.300006, -31.499979, -176.200012, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[61] = CreateDynamicObject(3012, -2812.687011, -1516.744262, 139.846237, 1.900001, 91.599990, -105.899925, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[62] = CreateDynamicObject(3008, -2813.350830, -1517.041137, 139.643081, 1.900001, -9.700015, -105.899925, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[63] = CreateDynamicObject(3009, -2812.101318, -1517.006835, 139.910110, -86.499885, 106.099937, -52.299839, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[64] = CreateDynamicObject(3010, -2812.721679, -1516.216552, 140.636306, 1.900001, 100.699928, -105.899925, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
		Objects[65] = CreateDynamicObject(3011, -2813.620849, -1516.083129, 139.596343, 27.699987, 91.599990, -107.499984, VIRTUAL_WORLD_NORMAL, INTERIOR_NORMAL);
	#else
		Objects[0] = CreateObject(2589, -2820.283447, -1515.626831, 137.583969, 176.600158, 2.899999, -15.600064);
		Objects[1] = CreateObject(2590, -2809.102050, -1519.912963, 142.724533, 180.0, 180.0, 133.0);
		Objects[2] = CreateObject(2803, -2812.046142, -1530.383300, 140.203887, 0.0, 0.0, -102.500068);
		Objects[3] = CreateObject(2805, -2811.576416, -1529.652465, 140.313140, 7.700000, -0.300002, 73.499977);
		Objects[4] = CreateObject(2805, -2811.576416, -1529.652465, 140.313140, 7.700000, -0.300002, 73.499977);
		Objects[5] = CreateObject(2804, -2811.598632, -1515.496582, 139.903717, 180.0, 0.0, 174.0);
		Objects[6] = CreateObject(2806, -2811.841064, -1515.717895, 139.883789, 180.0, 0.0, 0.0);
		Objects[7] = CreateObject(2806, -2812.542480, -1515.494873, 139.853805, 0.0, 0.0, 114.899940);
		Objects[8] = CreateObject(2806, -2812.196777, -1515.754638, 139.853683, 0.000000, 0.000000, -143.899948);
		Objects[9] = CreateObject(2806, -2812.744628, -1515.080322, 139.853805, 0.000000, 0.000000, 116.000000);
		Objects[10] = CreateObject(2806, -2812.066162, -1515.261962, 139.853805, 0.000000, 0.000000, 116.000000);
		Objects[11] = CreateObject(2806, -2811.482177, -1515.970336, 139.853805, 0.000000, 0.000000, -161.900009);
		Objects[12] = CreateObject(2806, -2811.688476, -1515.475463, 139.983673, 0.000000, 0.000000, 67.700065);
		Objects[13] = CreateObject(2806, -2811.756103, -1515.412963, 141.013748, 0.000000, 0.000000, 116.000000);
		Objects[14] = CreateObject(2806, -2811.543945, -1515.579223, 140.803756, 0.000000, 0.000000, 17.399963);
		Objects[15] = CreateObject(2806, -2812.126708, -1515.293579, 140.893783, 0.000000, 0.000000, 116.000000);
		Objects[16] = CreateObject(2806, -2812.590820, -1515.395751, 140.753677, 0.000000, 0.000000, 116.000000);
		Objects[17] = CreateObject(2806, -2813.016601, -1515.581176, 140.643676, 0.000000, 0.000000, -152.899948);
		Objects[18] = CreateObject(2806, -2813.154296, -1515.236694, 140.167861, 57.699989, -84.400009, -179.500045);
		Objects[19] = CreateObject(2806, -2813.284667, -1515.344238, 139.853805, 0.000000, 0.000000, 116.000000);
		Objects[20] = CreateObject(2806, -2813.437744, -1515.286132, 140.196533, 57.600002, 0.000000, -82.699974);
		Objects[21] = CreateObject(2806, -2813.359619, -1515.630249, 140.196868, 58.700000, 1.199972, -57.200000);
		Objects[22] = CreateObject(2806, -2813.704101, -1515.534667, 139.863800, 0.000000, 0.000000, -142.300018);
		Objects[23] = CreateObject(2806, -2812.384277, -1515.818725, 140.713806, 0.000000, 0.000000, 116.000000);
		Objects[24] = CreateObject(2806, -2811.709228, -1515.833740, 140.703826, 0.000000, 0.000000, 116.000000);
		Objects[25] = CreateObject(2806, -2812.042968, -1515.506347, 140.803756, 0.000000, 0.000000, -67.799972);
		Objects[26] = CreateObject(2806, -2811.797851, -1516.301635, 139.843811, 0.000000, 0.000000, -77.300003);
		Objects[27] = CreateObject(2806, -2813.293457, -1516.181274, 139.853805, 0.000000, 0.000000, -97.600059);
		Objects[28] = CreateObject(2806, -2812.561279, -1516.488769, 139.853805, 0.000000, 0.000000, -76.000015);
		Objects[29] = CreateObject(2806, -2811.656982, -1516.644165, 139.843887, 0.000000, 0.000000, 116.000000);
		Objects[30] = CreateObject(2806, -2811.715820, -1516.182617, 140.663818, 0.000000, 0.000000, 116.000000);
		Objects[31] = CreateObject(2806, -2811.692138, -1516.477294, 140.540893, 0.000000, 146.899917, 116.000000);
		Objects[32] = CreateObject(2806, -2811.389892, -1516.514892, 140.417037, -27.399986, 115.700019, 124.800003);
		Objects[33] = CreateObject(2806, -2811.519287, -1516.692626, 140.312561, 36.400009, 0.000000, 10.699976);
		Objects[34] = CreateObject(2806, -2811.511474, -1517.289550, 139.854324, 33.900001, 0.000000, 19.400024);
		Objects[35] = CreateObject(2806, -2811.984130, -1517.155273, 139.823806, 0.000000, 0.000000, -92.599990);
		Objects[36] = CreateObject(2806, -2813.416503, -1516.090087, 139.969879, -28.500005, 0.000000, 116.000000);
		Objects[37] = CreateObject(2806, -2812.256347, -1516.344970, 140.456451, 32.499996, 0.600000, -0.999983);
		Objects[38] = CreateObject(2806, -2811.971435, -1516.628417, 140.305068, -26.100000, 0.000000, -93.000038);
		Objects[39] = CreateObject(2806, -2811.876220, -1516.332153, 140.453765, 0.000000, 0.000000, -65.099990);
		Objects[40] = CreateObject(2806, -2812.140136, -1516.934936, 140.003768, 0.000000, 0.000000, 116.000000);
		Objects[41] = CreateObject(2806, -2812.049560, -1516.640380, 140.153747, 0.000000, 0.000000, -91.099990);
		Objects[42] = CreateObject(2806, -2812.594726, -1516.386596, 140.361816, -28.399995, 0.000000, 175.100036);
		Objects[43] = CreateObject(2806, -2812.579589, -1516.207275, 140.499771, 25.300004, 0.000000, 4.300006);
		Objects[44] = CreateObject(2806, -2812.392822, -1516.901489, 140.048461, -25.699998, 0.000000, -168.100006);
		Objects[45] = CreateObject(2806, -2812.729003, -1516.819213, 140.030639, -21.500005, 0.000000, 178.700012);
		Objects[46] = CreateObject(2806, -2813.622558, -1516.522216, 139.827178, -178.900024, 0.000000, 155.599945);
		Objects[47] = CreateObject(2806, -2813.221191, -1516.885009, 139.853805, 0.000000, 0.000000, 75.400009);
		Objects[48] = CreateObject(2806, -2812.894531, -1516.119262, 140.506149, -26.199998, 30.300006, -169.600036);
		Objects[49] = CreateObject(2806, -2813.292968, -1516.152343, 140.164871, 38.499984, 0.000000, -58.900043);
		Objects[50] = CreateObject(2806, -2812.950927, -1516.503173, 140.145507, 0.000000, 36.199996, -129.499984);
		Objects[51] = CreateObject(2804, -2814.189208, -1515.342041, 139.892349, 0.000000, 0.500001, -74.700004);
		Objects[52] = CreateObject(2804, -2813.266113, -1516.066040, 140.422958, 50.200008, 0.000000, -54.000003);
		Objects[53] = CreateObject(2806, -2813.052734, -1515.990356, 140.396957, -51.500019, 0.000000, 121.200004);
		Objects[54] = CreateObject(2806, -2813.332275, -1516.409179, 139.992385, 0.000000, 37.099990, -147.000000);
		Objects[55] = CreateObject(2907, -2817.714843, -1525.155761, 139.923934, 0.000000, 0.000000, -90.300018);
		Objects[56] = CreateObject(2908, -2818.315673, -1525.193603, 139.922134, 16.600000, 90.599998, -88.400009);
		Objects[57] = CreateObject(2906, -2817.869628, -1524.635375, 139.927902, 0.000000, 111.000015, 0.000000);
		Objects[58] = CreateObject(2906, -2817.750488, -1525.505126, 139.894653, 0.299999, 0.000000, -116.500122);
		Objects[58] = CreateObject(2905, -2816.912109, -1525.427490, 139.975051, 1.900001, 91.599990, -105.899925);
		Objects[59] = CreateObject(2905, -2817.004150, -1524.964843, 139.982269, -0.199999, 91.999969, 42.800048);
		Objects[60] = CreateObject(3007, -2812.885742, -1517.281616, 140.038085, 0.300006, -31.499979, -176.200012);
		Objects[61] = CreateObject(3012, -2812.687011, -1516.744262, 139.846237, 1.900001, 91.599990, -105.899925);
		Objects[62] = CreateObject(3008, -2813.350830, -1517.041137, 139.643081, 1.900001, -9.700015, -105.899925);
		Objects[63] = CreateObject(3009, -2812.101318, -1517.006835, 139.910110, -86.499885, 106.099937, -52.299839);
		Objects[64] = CreateObject(3010, -2812.721679, -1516.216552, 140.636306, 1.900001, 100.699928, -105.899925);
		Objects[65] = CreateObject(3011, -2813.620849, -1516.083129, 139.596343, 27.699987, 91.599990, -107.499984);
	#endif
}

stock DestroyBossObjects() {
    for(new object = 0; object < sizeof(Objects); object++) {
		#if USE_STREAMER == true
        	DestroyDynamicObject(Objects[object]);
        #else
            DestroyObject(Objects[object]);
        #endif
    }
}

forward SetBossAtSpawn(bossid);
public SetBossAtSpawn(bossid) {
	if(bossid == BossLeatherface) {
		new bossplayerid = FAI_GetBossNPCID(bossid);
		SetPlayerColor(bossplayerid, 0xff000000); //Alpha values = 00 because we don't want an additional playericon on the map
		if(!FCNPC_IsSpawned(bossplayerid)) {
		    FCNPC_Spawn(bossplayerid, 168, -2820.2534, -1530.3491, 140.8438);
		} else {
	    	if(FCNPC_IsDead(bossplayerid)) {
		    	FCNPC_Respawn(bossplayerid);
		    }
	    	FCNPC_SetSkin(bossplayerid, 168);
			FCNPC_SetPosition(bossplayerid, -2820.2534, -1530.3491, 140.8438);
		}
	    FCNPC_SetAngle(bossplayerid, 324.4991);
		FCNPC_SetInterior(bossplayerid, INTERIOR_NORMAL);
		FCNPC_SetVirtualWorld(bossplayerid, VIRTUAL_WORLD_NORMAL);
		FCNPC_SetWeapon(bossplayerid, WEAPON_CHAINSAW);
		FCNPC_SetHealth(bossplayerid, 100.0);
		FCNPC_SetArmour(bossplayerid, 0.0);
		FCNPC_SetInvulnerable(bossplayerid, false);
		new Float:maxHealth;
		FAI_GetBossMaxHealth(bossid, maxHealth);
		FAI_SetBossCurrentHealth(bossid, maxHealth);
		if(IsPlayerAttachedObjectSlotUsed(bossplayerid, ATTACHED_OBJECT_INDEX)) {
		    RemovePlayerAttachedObject(bossplayerid, ATTACHED_OBJECT_INDEX);
		}
		SetPlayerAttachedObject(bossplayerid, ATTACHED_OBJECT_INDEX, 19036, 2, 0.086, 0.043, -0.007, 86.100196, 91.500007, 0.0, 1.0, 1.0, 1.0);
		IdleCount = 0;
		DeathCount = -1;
		AnimationApplied = false;
		//Recreate objects, some objects can change positions and roll away
		DestroyBossObjects();
		CreateBossObjects();
		#if USE_STREAMER == true
			StreamerUpdateForValidPlayers(bossid);
		#endif
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

forward CheckPlayerInRange();
public CheckPlayerInRange() {
	new bossplayerid = FAI_GetBossNPCID(BossLeatherface);
	if(bossplayerid != INVALID_PLAYER_ID) {
	    if(FCNPC_IsDead(bossplayerid)) {
	        if(DeathCount != -1) {
	  			DeathCount--;
	  			if(DeathCount == 0) {
	  				SetBossAtSpawn(BossLeatherface);
	  			}
			}
	    } else {
			if(IdleCount != -1) {
		    	IdleCount++;
		    	switch(IdleCount) {
		    	    case 10: {
		    	        FCNPC_GoTo(bossplayerid, -2811.7888, -1528.6459, 140.8438, MOVE_TYPE_WALK);
		    	    }
		    	    case 100: {
		    	        FCNPC_GoTo(bossplayerid, -2813.3208, -1517.8263, 140.8438, MOVE_TYPE_WALK);
		    	    }
		    	    case 200: {
		    	        FCNPC_GoTo(bossplayerid, -2819.4717, -1516.2056, 140.8438, MOVE_TYPE_WALK);
		    	    }
		    	    case 280: {
		    	        FCNPC_GoTo(bossplayerid, -2820.0303, -1518.5581, 140.8438, MOVE_TYPE_WALK);
		    	    }
		    	    case 340: {
		    	        FCNPC_GoTo(bossplayerid, -2811.7930, -1518.4700, 140.8438, MOVE_TYPE_WALK);
		    	    }
		    	    case 440: {
		    	        FCNPC_GoTo(bossplayerid, -2817.3579, -1524.5388, 140.8438, MOVE_TYPE_WALK);
		    	    }
		    	    case 520: {
		    	        FCNPC_GoTo(bossplayerid, -2807.3572,- 1524.1216, 140.8438, MOVE_TYPE_WALK);
		    	    }
		    	    case 610: {
		    	        FCNPC_GoTo(bossplayerid, -2811.8003, -1524.0878, 140.8438, MOVE_TYPE_WALK);
		    	    }
		    	    case 730: {
						IdleCount = 0;
		    	    }
		    	}
		    } else {
                if(FCNPC_IsMoving(bossplayerid)) {
            		new Float:attackDistance, delay, bool:useFightStyle;
				    FAI_GetBossMeleeAttackInfo(BossLeatherface, attackDistance, delay, useFightStyle);
					new Float:x, Float:y, Float:z;
					FCNPC_GetPosition(bossplayerid, x, y, z);
                    new Float:distance = GetPlayerDistanceFromPoint(FAI_GetBossTarget(BossLeatherface), x, y, z);
                    if(distance > attackDistance + 2.0) {
	                    if(!AnimationApplied) {
							FCNPC_ApplyAnimation(bossplayerid, "ped", "FightSh_FWD", 4.1, 1, 1, 1, 0, 0);
							AnimationApplied = true;
						}
                    }
                    if(distance >= attackDistance && distance <= attackDistance + 2.0) {
						if(AnimationApplied) {
	                        FCNPC_ClearAnimations(bossplayerid);
							AnimationApplied = false;
						}
                    }
                }
		    }
    		new Float:x, Float:y, Float:z, Float:px, Float:py, Float:pz;
			FCNPC_GetPosition(bossplayerid, x, y, z);
			for(new playerid = 0, highestPlayerid = GetPlayerPoolSize(); playerid <= highestPlayerid; playerid++) {
				if(FAI_IsBossValidForPlayer(playerid, BossLeatherface) && !IsPlayerNPC(playerid)) {
				    if(IdleCount != -1) {
					    if(FAI_GetBossTarget(BossLeatherface) == INVALID_PLAYER_ID) {
							GetPlayerPos(playerid, px, py, pz);
							if(px <= -2811.0 && px >= -2821.0 && py <= -1515.0 && py >= -1531.0 && pz <= 143.0 && pz >= 140.0) {
							    FAI_SetBossTarget(BossLeatherface, playerid);
							}
					    }
				    }
				    if(IsPlayerInRangeOfPoint(playerid, 50.0, x, y, z)) {
				        if(!AlreadyInOutRange[playerid]) {
				        	AlreadyInOutRange[playerid] = true;
					        SetPlayerWeather(playerid, 9);
					        SetPlayerTime(playerid, 0, 0);
				        }
				        if(AudioStreamCount[playerid] == -1) {
					        PlayAudioStreamForPlayer(playerid, AUDIO_STREAM_HALLOWEEN);
					        AudioStreamCount[playerid] = 0;
				        } else {
				            AudioStreamCount[playerid]++;
				            if(AudioStreamCount[playerid] == 1600) {
						        StopAudioStreamForPlayer(playerid);
						        AudioStreamCount[playerid] = -1;
				            }
				        }
				    } else {
				        if(AlreadyInOutRange[playerid]) {
				        	AlreadyInOutRange[playerid] = false;
					        SetPlayerWeather(playerid, DEFAULT_WEATHER);
					        SetPlayerTime(playerid, DEFAULT_TIME_H, DEFAULT_TIME_M);
					        if(AudioStreamCount[playerid] != -1) {
					        	StopAudioStreamForPlayer(playerid);
					        	AudioStreamCount[playerid] = -1;
					        }
				        }
				    }
				}
			}
		}
	}
}
