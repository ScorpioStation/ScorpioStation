// This file is just for the necessary /world definition
// Try looking in game/world.dm

/world
	mob = /mob/new_player
	turf = /turf/open/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session
	fps = 20 // If this isnt hard-defined, anything relying on this variable before world load will cry a lot
