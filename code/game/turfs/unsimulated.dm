/turf/unsimulated
	intact = TRUE
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/unsimulated/floor/plating/vox
	icon_state = "plating"
	name = "plating"
	nitrogen = 100
	oxygen = 0

/turf/unsimulated/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	temperature = T0C

/turf/unsimulated/floor/plating/snow/concrete
	name = "concrete"
	icon = 'icons/turf/floors.dmi'
	icon_state = "concrete"

/turf/unsimulated/floor/plating/snow/ex_act(severity)
	return

/turf/unsimulated/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/unsimulated/floor/plating/airless/Initialize(mapload)
	. = ..()
	name = "plating"

/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"

/turf/unsimulated/floor/grass
	name = "grass patch"
	icon_state = "grass1"

/turf/unsimulated/floor/grass/Initialize(mapload)
	. = ..()
	icon_state = "grass[rand(1,4)]"

/turf/unsimulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/unsimulated/floor/abductor
	name = "alien floor"
	icon_state = "alienpod1"

/turf/unsimulated/floor/abductor/Initialize(mapload)
	. = ..()
	icon_state = "alienpod[rand(1,9)]"

/turf/unsimulated/floor/vox
	icon_state = "dark"
	nitrogen = 100
	oxygen = 0

/turf/unsimulated/floor/carpet
	name = "Carpet"
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet"
	smooth = SMOOTH_TRUE
	canSmoothWith = null

	footstep_sounds = list(
		"human" = list('sound/effects/footstep/carpet_human.ogg'),
		"xeno"  = list('sound/effects/footstep/carpet_xeno.ogg')
	)

/turf/unsimulated/floor/wood
	icon_state = "wood"

	footstep_sounds = list(
		"human" = list('sound/effects/footstep/wood_all.ogg'), //@RonaldVanWonderen of Freesound.org
		"xeno"  = list('sound/effects/footstep/wood_all.ogg')  //@RonaldVanWonderen of Freesound.org
	)

/turf/unsimulated/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1
	explosion_block = 2

/turf/unsimulated/wall/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = 0

/turf/unsimulated/wall/fakedoor
	name = "Centcom Access"
	icon = 'icons/obj/doors/airlocks/centcom/centcom.dmi'
	icon_state = "closed"

/turf/unsimulated/wall/splashscreen
	name = "Space Station 13"
	icon = 'icons/blank.png'
	icon_state = ""
	layer = FLY_LAYER

/turf/unsimulated/wall/other
	icon_state = "r_wall"

/turf/unsimulated/wall/metal
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"
	smooth = SMOOTH_TRUE

/turf/unsimulated/wall/abductor
	icon_state = "alien1"
	explosion_block = 50

// for second floor showing floor below
/turf/unsimulated/floor/upperlevel
	icon = 'icons/turf/areas.dmi'
	icon_state = "dark128"
	layer = AREA_LAYER + 0.5
	appearance_flags = TILE_BOUND | KEEP_TOGETHER
	var/turf/lower_turf
	var/obj/effect/portal_sensor/sensor

/turf/unsimulated/floor/upperlevel/New()
	..()
	var/obj/effect/levelref/R = locate() in get_area(src)
	if(R && R.other)
		init(R)

/turf/unsimulated/floor/upperlevel/Destroy()
	QDEL_NULL(sensor)
	return ..()

/turf/unsimulated/floor/upperlevel/proc/init(var/obj/effect/levelref/R)
	lower_turf = locate(x + R.offset_x, y + R.offset_y, z + R.offset_z)
	if(lower_turf)
		sensor = new(lower_turf, src)

/turf/unsimulated/floor/upperlevel/Entered(atom/movable/AM, atom/OL, ignoreRest = 0)
	if(isliving(AM) || istype(AM, /obj))
		if(isliving(AM))
			var/mob/living/M = AM
			M.emote("scream")
			M.SpinAnimation(5, 1)
		AM.forceMove(lower_turf)

/turf/unsimulated/floor/upperlevel/attack_ghost(mob/user)
	user.forceMove(lower_turf)

/turf/unsimulated/floor/upperlevel/proc/trigger()
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
