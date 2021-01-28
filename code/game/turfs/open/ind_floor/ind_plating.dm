/turf/open/ind_floor/plating
	name = "plating"
	icon_state = "plating"
	icon = 'icons/turf/floors/plating.dmi'
	intact = FALSE
	indesctructible_turf = TRUE

	var/floor_tile = null

	footstep_sounds = list(
	"human" = list('sound/effects/footstep/plating_human.ogg'),
	"xeno"  = list('sound/effects/footstep/plating_xeno.ogg')
	)

/turf/open/ind_floor/plating/attackby(obj/item/C, mob/user, params) //Lava (heh I stole this from lava.dm) isn't a good foundation to build on
	return

/turf/open/floor/plating/screwdriver_act()
	return

/turf/open/floor/plating/welder_act()
	return
