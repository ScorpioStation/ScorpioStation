/turf/space/openspace
	name = "open space"
	desc = "Watch your step!"
	icon_state = "grey"
	CanAtmosPassVertical = ATMOS_PASS_YES
	plane = FLOOR_OPENSPACE_PLANE
	layer = OPENSPACE_LAYER
	//mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/can_cover_up = TRUE
	var/can_build_on = TRUE

/turf/space/openspace/debug/update_multiz()
	..()
	return TRUE

/turf/space/openspace/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/turf/space/openspace/LateInitialize()
	update_multiz(TRUE, TRUE)

/turf/space/openspace/Destroy()
	vis_contents.len = 0
	return ..()

/turf/space/openspace/update_multiz(prune_on_fail = FALSE, init = FALSE)
	. = ..()
	var/turf/T = below()
	if(!T)
		vis_contents.len = 0
		if(prune_on_fail)
			ChangeTurf(/turf/open/floor/plating)
		return FALSE
	if(init)
		vis_contents += T
	return TRUE

/turf/space/openspace/multiz_turf_del(turf/T, dir)
	if(dir != DOWN)
		return
	update_multiz()

/turf/space/openspace/multiz_turf_new(turf/T, dir)
	if(dir != DOWN)
		return
	update_multiz()

/turf/space/openspace/zAirIn()
	return TRUE

/turf/space/openspace/zAirOut()
	return TRUE

/turf/space/openspace/zPassIn(atom/movable/A, direction, turf/source)
	return TRUE

/turf/space/openspace/zPassOut(atom/movable/A, direction, turf/destination)
	return TRUE

/turf/space/openspace/proc/CanCoverUp()
	return can_cover_up

/turf/space/openspace/proc/CanBuildHere()
	return can_build_on

/turf/space/openspace/attackby(obj/item/C, mob/user, params)
	..()
	if(!CanBuildHere())
		return
	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			to_chat(user, "<span class='warning'>There is already a catwalk here!</span>")
			return
		if(L)
			if(R.use(1))
				to_chat(user, "<span class='notice'>You construct a catwalk.</span>")
				playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
				new/obj/structure/lattice/catwalk(src)
			else
				to_chat(user, "<span class='warning'>You need two rods to build a catwalk!</span>")
			return
		if(R.use(1))
			to_chat(user, "<span class='notice'>You construct a lattice.</span>")
			playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
			ReplaceWithLattice()
		else
			to_chat(user, "<span class='warning'>You need one rod to build a lattice.</span>")
		return
	if(istype(C, /obj/item/stack/tile/plasteel))
		if(!CanCoverUp())
			return
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if(S.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You build a floor.</span>")
				PlaceOnTop(/turf/open/floor/plating)
			else
				to_chat(user, "<span class='warning'>You need one floor tile to build a floor!</span>")
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support! Place metal rods first.</span>")
