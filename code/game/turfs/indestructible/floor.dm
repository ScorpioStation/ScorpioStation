/turf/open/ind_floor	// Indestructible Floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"
	indesctructible_turf = TRUE

//Grass
/turf/open/ind_floor/grass
	name = "grass patch"
	icon_state = "grass1"

/turf/open/ind_floor/grass/Initialize(mapload)
	. = ..()
	icon_state = "grass[rand(1,4)]"

//Snow
/turf/open/ind_floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

//Abductor
/turf/open/ind_floor/abductor
	name = "alien floor"
	icon_state = "alienpod1"

/turf/open/ind_floor/abductor/Initialize(mapload)
	. = ..()
	icon_state = "alienpod[rand(1,9)]"

//Vox
/turf/open/ind_floor/vox
	icon_state = "dark"
	nitrogen = 100
	oxygen = 0

//Carpet
/turf/open/ind_floor/carpet
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
/turf/open/ind_floor/wood
	icon_state = "wood"

	footstep_sounds = list(
		"human" = list('sound/effects/footstep/wood_all.ogg'), //@RonaldVanWonderen of Freesound.org
		"xeno"  = list('sound/effects/footstep/wood_all.ogg')  //@RonaldVanWonderen of Freesound.org
	)

