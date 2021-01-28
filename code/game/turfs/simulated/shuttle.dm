/turf/open/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2
	static_turf = TRUE

/turf/open/shuttle/rpd_act(mob/user, obj/item/rpd/our_rpd)
	if(our_rpd.mode == RPD_DELETE_MODE)//No pipes on shuttles
		our_rpd.delete_all_pipes(user, src)

/turf/open/shuttle/narsie_act()
	if(prob(20))
		ChangeTurf(/turf/closed/wall/cult)

//sub-type to be used for interior shuttle walls
//won't get an underlay of the destination turf on shuttle move
/turf/closed/shuttle/wall/interior/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(T.color != color)
		T.color = color
	if(T.dir != dir)
		T.dir = dir
	T.transform = transform
	return T

/turf/closed/shuttle/wall/copyTurf(turf/T)
	. = ..()
	T.transform = transform

//why don't shuttle walls habe smoothwall? now i gotta do rotation the dirty way
/turf/open/shuttle/shuttleRotate(rotation)
	..()
	var/matrix/M = transform
	M.Turn(rotation)
	transform = M

/turf/open/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/open/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/open/shuttle/plating/vox	//Vox skipjack plating
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/open/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/open/shuttle/floor4/vox	//Vox skipjack floors
	name = "skipjack floor"
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

//The ~Freaking~ Shuttle Walls
/turf/closed/shuttle/wall
	name = "wall"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall1"
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	static_turf = TRUE		// I guess? I don't want people using RPDs and welders on this, okay?
	canSmoothWith = list(
		/turf/closed/shuttle/wall,	//It smooths with itself	In this case, I assume it will use swall12, swall13, and etc for this purpose
		/obj/structure/shuttle/window)	//Possibly a bad idea
	smooth = SMOOTH_TRUE | SMOOTH_DIAGONAL

