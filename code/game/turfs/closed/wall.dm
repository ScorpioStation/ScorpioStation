/turf/closed/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	density = TRUE
	explosion_block = 2

/turf/closed/wall/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = FALSE

/turf/closed/wall/fakedoor
	name = "Centcom Access"
	icon = 'icons/obj/doors/airlocks/centcom/centcom.dmi'
	icon_state = "closed"

/turf/closed/wall/splashscreen
	name = "Space Station 13"
	icon = 'icons/blank.png'
	icon_state = ""
	layer = FLY_LAYER

/turf/closed/wall/other
	icon_state = "r_wall"

/turf/closed/wall/metal
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"
	smooth = SMOOTH_TRUE

/turf/closed/wall/abductor
	icon_state = "alien1"
	explosion_block = 50

/turf/closed/indestructible
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	explosion_block = 50

/* Map Specific */

//Beach.dmm
/turf/closed/beach/water/deep/rock_wall
	name = "Reef Stone"
	icon_state = "desert7"
	density = TRUE
	opacity = TRUE
	explosion_block = 2
	mouse_opacity = MOUSE_OPACITY_ICON
	static_turf = TRUE
