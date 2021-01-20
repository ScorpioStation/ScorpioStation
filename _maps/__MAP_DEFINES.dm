
// Linkage flags
	#define CROSSLINKED 2
	#define SELFLOOPING 1
	#define UNAFFECTED 0
// Attributes (In text for the convenience of those using VV)
	#define BLOCK_TELEPORT "Blocks Teleport"
	#define IMPEDES_MAGIC "Impedes Magic"		// Impedes with the casting of some spells
	#define STATION_LEVEL "Station Level"		// A level the station exists on
	#define STATION_CONTACT "Station Contact"	// A level affected by Code Red announcements, cargo telepads, or similar
	#define ADMIN_LEVEL "Admin Level"			// A level dedicated to admin use
	#define REACHABLE "Reachable"				// A level that can be navigated to through space
	#define AWAY_LEVEL "Away"					// For away missions - used by some consoles
	#define HAS_WEATHER "Weather"				// Allows weather
	#define BOOSTS_SIGNAL "Boosts signals"		// Enhances telecomms signals
	#define ORE_LEVEL "Mining"					// Currently used for determining mining score
	#define AI_OK "AI Allowed"					// Levels the AI can control bots on
	#define SPAWN_RUINS "Spawn Ruins"			/// Ruins will spawn on this z-level

// Level names
	#define MAIN_STATION "Main Station"
	#define CENTCOMM "CentComm"
	#define TELECOMMS "Telecomms Satellite"
	#define DERELICT "Derelicted Station"
	#define MINING "Lavaland"
	#define CONSTRUCTION "Construction Area"
	#define EMPTY_AREA "Empty Area"
	#define EMPTY_AREA_2 "Empty Area 2"
	#define EMPTY_AREA_3 "Empty Area 3"
	#define AWAY_MISSION "Away Mission"

/*
The /tg/ codebase allows mixing of hardcoded and dynamically-loaded z-levels.
Z-levels can be reordered as desired and their properties are set by "traits".
See map_config.dm for how a particular station's traits may be chosen.
The list DEFAULT_MAP_TRAITS at the bottom of this file should correspond to
the maps that are hardcoded, as set in _maps/_basemap.dm. SSmapping is
responsible for loading every non-hardcoded z-level.

As of 2020-01-19, the typical z-levels for a single-level station are:
1: CentCom
2: Station (Emerald)
3-4: Randomized space
4: Mining
5: Mining
6: City of Cogs
7-11: Randomized space
12: Empty space
13: Transit space

Multi-Z stations are supported and multi-Z mining and away missions would
require only minor tweaks.
*/

// helpers for modifying jobs, used in various job_changes.dm files
#define MAP_JOB_CHECK if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return; }
#define MAP_JOB_CHECK_BASE if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return ..(); }
#define MAP_REMOVE_JOB(jobpath) /datum/job/##jobpath/map_check() { return (SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) && ..() }

#define SPACERUIN_MAP_EDGE_PAD 15

// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_MAINSTATION "Main Station"
#define ZTRAIT_MINING "Mining"
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_AWAY "Away Mission"
#define ZTRAIT_SPACE_RUINS "Space Ruins"
#define ZTRAIT_LAVA_RUINS "Lava Ruins"
#define ZTRAIT_ICE_RUINS "Ice Ruins"
#define ZTRAIT_ICE_RUINS_UNDERGROUND "Ice Ruins Underground"
#define ZTRAIT_ISOLATED_RUINS "Isolated Ruins"	//Placing ruins on z levels with this trait will use turf reservation instead of usual placement.

#define ZTRAIT_ASHSTORM "Weather_Ashstorm"	// boolean - weather types that occur on the level
#define ZTRAIT_GRAVITY "Gravity"	// number - default gravity if there's no gravity generators or area overrides present

// numeric offsets - e.g. {"Down": -1} means that chasms will fall to z - 1 rather than oblivion
#define ZTRAIT_UP "Up"
#define ZTRAIT_DOWN "Down"

#define ZTRAIT_LINKAGE "Linkage"	// enum - how space transitions should affect this level
#define ZTRAIT_BASETURF "Baseturf"	// string - type path of the z-level's baseturf (defaults to space)

// default trait definitions, used by SSmapping
#define ZTRAITS_CENTCOM list(ZTRAIT_CENTCOM = TRUE)
#define ZTRAITS_MAINSTATION list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_MAINSTATION = TRUE)
#define ZTRAITS_SPACE list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_SPACE_RUINS = TRUE)
#define ZTRAITS_LAVALAND list(\
	ZTRAIT_MINING = TRUE, \
	ZTRAIT_ASHSTORM = TRUE, \
	ZTRAIT_LAVA_RUINS = TRUE, \
	ZTRAIT_BASETURF = /turf/simulated/floor/plating/lava/smooth/lava_land_surface)

// Convenience define
#define DL_NAME "name"
#define DL_TRAITS "attributes"
#define DL_LINKS "linkage"

#define DECLARE_LEVEL(NAME,LINKS,TRAITS) list(DL_NAME = NAME, DL_LINKS, DL_TRAITS = TRAITS)
#define AWAY_MISSION_LIST list(\
	DECLARE_LEVEL(AWAY_MISSION,UNAFFECTED, list(BLOCK_TELEPORT, AWAY_LEVEL)))

// This must match emerald.dm for things to work correctly
#define DEFAULT_MAP_TRAITS list(\
	ZTRAIT_LINKAGE = CROSSLINKED,\
	ZTRAIT_MAIN_STATION = TRUE, \
	ZTRAIT_GRAVITY = TRUE, \
	ZTRAIT_UP = FALSE, \
	ZTRAIT_DOWN = FALSE)


//Reserved/Transit turf type
#define RESERVED_TURF_TYPE /turf/space/openspace/basic			//What the turf is when not being used

//Ruin Generation
#define PLACEMENT_TRIES 100			//How many times we try to fit the ruin somewhere until giving up (really should just swap to some packing algo)
#define PLACE_DEFAULT "random"		//On a randomized Z-Level
#define PLACE_SAME_Z "same"			//On the same Z-Level as the Original Ruin
#define PLACE_SPACE_RUIN "space"	//On Space Ruin Z-Level(s)
#define PLACE_LAVA_RUIN "lavaland"	//On Lavaland Ruin Z-Levels(s)
#define PLACE_BELOW "below"			//On the Z-Level Below - Centered on same tile
#define PLACE_ISOLATED "isolated"	//On Isolated Ruin Z-Level
