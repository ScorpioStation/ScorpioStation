/obj/decal/wrestling/rope
	name = "Wrestling Ropes"
	desc = "Do not exit the ring."
	density = TRUE
	anchored = TRUE
	icon = 'icons/misc/wrestling_ring.dmi'
	icon_state = "border_2"
	layer = OBJ_LAYER

/obj/decal/wrestling/rope/north
	dir = NORTH

/obj/decal/wrestling/rope/west
	dir = WEST

/obj/decal/wrestling/rope/east
	dir = EAST

/obj/decal/wrestling/rope/south
	dir = SOUTH
	layer = 4

/obj/decal/wrestling/rope/southmost/CanPass(atom/movable/mover, turf/target, height=0, air_group=0) // stolen from window.dm
	return FALSE

/obj/decal/wrestling/rope/CanPass(atom/movable/mover, turf/target, height=0, air_group=0) // stolen from window.dm
//	if (src.dir == SOUTHWEST || src.dir == SOUTHEAST || src.dir == NORTHWEST || src.dir == NORTHEAST || src.dir == SOUTH || src.dir == NORTH)
//		return 0
	if(get_dir(loc, target) == dir)
		return !density
	else
		return TRUE

/obj/decal/wrestling/rope/CheckExit(atom/movable/O as mob|obj, target as turf)
	if (!src.density)
		return TRUE
	if (get_dir(O.loc, target) == src.dir)
		return FALSE
	return TRUE

/obj/decal/wrestling/enter
	name = "Ring Entrance"
	desc = "Do not exit the ring."
	density = FALSE
	anchored = TRUE
	icon = 'icons/misc/wrestling_ring.dmi'
	icon_state = "border_2"
	layer = OBJ_LAYER


/obj/decal/wrestling/rope/pillar
	name = "Corner Pillars"
	desc = "Looks climbable."
	density = TRUE
	anchored = TRUE
	icon = 'icons/misc/wrestling_ring.dmi'
	icon_state = "pillar_2"
	layer = OBJ_LAYER

/obj/decal/wrestling/rope/pillar/s/CanPass(atom/movable/mover, turf/target, height=0, air_group=0) // stolen from window.dm
	return FALSE

/obj/decal/wrestling/rope/pillar/nw
	dir = WEST

/obj/decal/wrestling/rope/pillar/ne
	dir = EAST


/obj/structure/stairs
	name = "stairs"
	desc = "For climbing."
	density = FALSE
	anchored = TRUE
	icon = 'icons/misc/wrestling_ring.dmi'
	icon_state = "stairs"