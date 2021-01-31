/turf/open/ind_floor/plating
	name = "plating"
	icon_state = "plating"
	icon = 'icons/turf/floors/plating.dmi'
	intact = FALSE
	indestructible_turf = TRUE	//Establish as indestructible_turf

	var/floor_tile = null

	footstep_sounds = list(
	"human" = list('sound/effects/footstep/plating_human.ogg'),
	"xeno"  = list('sound/effects/footstep/plating_xeno.ogg')
	)

/turf/open/ind_floor/plating/attackby(obj/item/C, mob/user, params) // Lava (heh I stole this line from lava.dm) isn't a good foundation to build on
	return															// In all seriousness, if you're mapping with indestructible floor plating, uh, look, I don't know what you're going for, but okay x3

/turf/open/ind_floor/plating/screwdriver_act()
	return

/turf/open/ind_floor/plating/welder_act()
	return

/turf/open/ind_floor/plating/screwdriver_act()
	return

/turf/open/floor/plating/lava/welder_act()
	return

/turf/open/ind_floor/plating/break_tile()
	return

/turf/open/ind_floor/plating/burn_tile()
	return

//Airless Plating

/turf/open/ind_floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/open/ind_floor/plating/airless/Initialize(mapload)
	. = ..()
	name = "plating"
