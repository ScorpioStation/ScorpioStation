/obj/decal/wrestlingrope
	name = "Wrestling Ropes"
	desc = "Do not exit the ring."
	density = 1
	anchored = 1
	icon = 'icons/misc/wrestling_ring.dmi'
	icon_state = "border_2"
	layer = OBJ_LAYER



/obj/decal/wrestlingrope/north/CanPass(atom/movable/mover, turf/target, height=0, air_group=0) // stolen from window.dm
	if(get_dir(mover, target) == NORTH)
		return 1
	else
		return 0

/obj/decal/wrestlingrope/west/CanPass(atom/movable/mover, turf/target, height=0, air_group=0) // stolen from window.dm
	if(get_dir(mover, target) == WEST)
		return 1
	else
		return 0

/obj/decal/wrestlingrope/east/CanPass(atom/movable/mover, turf/target, height=0, air_group=0) // stolen from window.dm
	if(get_dir(mover, target) == EAST)
		return 1
	else
		return 0

/obj/decal/wrestlingrope/south/CanPass(atom/movable/mover, turf/target, height=0, air_group=0) // stolen from window.dm
	if(get_dir(mover, target) == SOUTH)
		return 1
	else
		return 0

/obj/decal/wrestlingrope/southmost/CanPass(atom/movable/mover, turf/target, height=0, air_group=0) // stolen from window.dm
	return 0

/*
		if (src.dir == SOUTHWEST || src.dir == SOUTHEAST || src.dir == NORTHWEST || src.dir == NORTHEAST || src.dir == SOUTH || src.dir == NORTH)
			return 0
		if(get_dir(loc, target) == dir)

			return !density
		else
			return 1

/obj/decal/wrestlingrope/CheckExit(atom/movable/O as mob|obj, target as turf)
		if (!src.density)
			return 1
		if (get_dir(O.loc, target) == src.dir)
			return 0
		return 1

/obj/decal/boxingropeenter
	name = "Ring entrance"
	desc = "Do not exit the ring."
	density = 0
	anchored = 1
	icon = 'icons/obj/decoration.dmi'
	icon_state = "ringrope"
	layer = OBJ_LAYER
*/