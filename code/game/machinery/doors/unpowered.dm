/obj/machinery/door/unpowered
	explosion_block = 1

/obj/machinery/door/unpowered/Bumped(atom/AM)
	if(locked)
		return
	..()

/obj/machinery/door/unpowered/attackby(obj/item/I, mob/user, params)
	if(locked)
		return
	else
		return ..()

/obj/machinery/door/unpowered/emag_act()
	return

/obj/machinery/door/unpowered/shuttle
	var/soundsopen = 'sound/machines/airlock_open.ogg'
	var/soundsclosed = 'sound/machines/airlock_close.ogg'
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "door1"

/obj/machinery/door/unpowered/shuttle/open()
	playsound(loc, soundsopen, 30, 1)
	. = ..()

/obj/machinery/door/unpowered/shuttle/close()
	if(density)
		return TRUE
	if(operating || welded)
		return
	if(safe)
		for(var/turf/turf in locs)
			for(var/atom/movable/M in turf)
				if(M.density && M != src) //something is blocking the door
					if(autoclose)
						autoclose_in(60)
					return

	operating = TRUE

	playsound(loc, soundsclosed, 30, 1)
	do_animate("closing")
	layer = closingLayer
	sleep(5)
	density = TRUE
	sleep(5)
	update_icon()
	if(visible && !glass)
		set_opacity(1)
	operating = 0
	air_update_turf(1)
	update_freelook_sight()
	if(safe)
		CheckForMobs()
	else
		crush()
	return TRUE

