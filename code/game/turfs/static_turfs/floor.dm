/turf/open/locked/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"
	static_turf = TRUE

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

/* Map Specific */
// Space Hotel
/// for second floor showing floor below
/turf/open/locked/floor/upperlevel
	icon = 'icons/turf/areas.dmi'
	icon_state = "dark128"
	layer = AREA_LAYER + 0.5
	appearance_flags = TILE_BOUND | KEEP_TOGETHER
	var/turf/lower_turf
	var/obj/effect/portal_sensor/sensor

/turf/open/locked/floor/upperlevel/New()
	..()
	var/obj/effect/levelref/R = locate() in get_area(src)
	if(R && R.other)
		init(R)

/turf/open/locked/floor/upperlevel/Destroy()
	QDEL_NULL(sensor)
	return ..()

/turf/open/locked/floor/upperlevel/proc/init(var/obj/effect/levelref/R)
	lower_turf = locate(x + R.offset_x, y + R.offset_y, z + R.offset_z)
	if(lower_turf)
		sensor = new(lower_turf, src)

/turf/open/locked/floor/upperlevel/Entered(atom/movable/AM, atom/OL, ignoreRest = 0)
	if(isliving(AM) || istype(AM, /obj))
		if(isliving(AM))
			var/mob/living/M = AM
			M.emote("scream")
			M.SpinAnimation(5, 1)
		AM.forceMove(lower_turf)

/turf/open/locked/floor/upperlevel/attack_ghost(mob/user)
	user.forceMove(lower_turf)

/turf/open/locked/floor/upperlevel/proc/trigger()
	name = lower_turf.name
	desc = lower_turf.desc

	// render each atom
	underlays.Cut()
	for(var/X in list(lower_turf) + lower_turf.contents)
		var/atom/A = X
		if(A && A.invisibility <= SEE_INVISIBLE_LIVING)
			var/image/I = image(A, layer = AREA_LAYER + A.layer * 0.01, dir = A.dir)
			I.pixel_x = A.pixel_x
			I.pixel_y = A.pixel_y
			underlays += I
