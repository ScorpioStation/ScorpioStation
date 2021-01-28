/turf/closed/ind_wall	// Indestrucible Walls
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	density = TRUE
	explosion_block = 2
	indesctructible_turf = TRUE

/turf/closed/ind_wall/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = FALSE

/turf/closed/ind_wall/fakedoor
	name = "Centcom Access"
	icon = 'icons/obj/doors/airlocks/centcom/centcom.dmi'
	icon_state = "closed"

/turf/closed/ind_wall/splashscreen
	name = "Space Station 13"
	icon = 'icons/blank.png'
	icon_state = ""
	layer = FLY_LAYER

/turf/closed/ind_wall/other
	icon_state = "r_wall"

/turf/closed/ind_wall/metal
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"
	smooth = SMOOTH_TRUE

/turf/closed/ind_wall/abductor
	icon_state = "alien1"
	explosion_block = 50

/turf/closed/ind_wall/necropolis
	name = "necropolis wall"
	desc = "A seemingly impenetrable wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "necro"
	explosion_block = 50
	baseturf = /turf/closed/ind_wall/necropolis

/turf/closed/ind_wall/boss
	name = "necropolis wall"
	desc = "A thick, seemingly indestructible stone wall."
	icon = 'icons/turf/walls/boss_wall.dmi'
	icon_state = "wall"
	canSmoothWith = list(/turf/closed/ind_wall/boss, /turf/closed/ind_wall/boss/see_through)
	explosion_block = 50
	baseturf = /turf/open/floor/plating/asteroid/basalt
	smooth = SMOOTH_TRUE

/turf/closed/ind_wall/boss/see_through
	opacity = FALSE

/turf/closed/ind_wall/hierophant
	name = "wall"
	desc = "A wall made out of a strange metal. The squares on it pulse in a predictable pattern."
	icon = 'icons/turf/walls/hierophant_wall.dmi'
	icon_state = "wall"
	smooth = SMOOTH_TRUE

/turf/closed/ind_wall/uranium
	icon = 'icons/turf/walls/uranium_wall.dmi'
	icon_state = "uranium"
