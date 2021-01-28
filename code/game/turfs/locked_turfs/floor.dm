/turf/open/locked/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"
	locked_turf = TRUE

//Grass
/turf/open/locked/floor/grass
	name = "grass patch"
	icon_state = "grass1"

/turf/open/locked/floor/grass/Initialize(mapload)
	. = ..()
	icon_state = "grass[rand(1,4)]"

//Snow
/turf/open/locked/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

//Abductor
/turf/open/locked/floor/abductor
	name = "alien floor"
	icon_state = "alienpod1"

/turf/open/locked/floor/abductor/Initialize(mapload)
	. = ..()
	icon_state = "alienpod[rand(1,9)]"

//Vox
/turf/open/locked/floor/vox
	icon_state = "dark"
	nitrogen = 100
	oxygen = 0

//Carpet
/turf/open/locked/floor/carpet
	name = "Carpet"
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet"
	smooth = SMOOTH_TRUE
	canSmoothWith = null

	footstep_sounds = list(
		"human" = list('sound/effects/footstep/carpet_human.ogg'),
		"xeno"  = list('sound/effects/footstep/carpet_xeno.ogg')
	)

//Wood
/turf/open/locked/floor/wood
	icon_state = "wood"

	footstep_sounds = list(
		"human" = list('sound/effects/footstep/wood_all.ogg'), //@RonaldVanWonderen of Freesound.org
		"xeno"  = list('sound/effects/footstep/wood_all.ogg')  //@RonaldVanWonderen of Freesound.org
	)

