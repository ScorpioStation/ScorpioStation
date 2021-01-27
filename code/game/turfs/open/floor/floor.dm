
/* Engine Floors */
/turf/open/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	var/insulated
	heat_capacity = 325000
	floor_tile = /obj/item/stack/rods

/turf/open/floor/engine/break_tile()
	return //unbreakable

/turf/open/floor/engine/burn_tile()
	return //unburnable

/turf/open/floor/engine/make_plating(force = 0)
	if(force)
		..()
	return //unplateable

/turf/open/floor/engine/attack_hand(mob/user as mob)
	user.Move_Pulled(src)

/turf/open/floor/engine/pry_tile(obj/item/C, mob/user, silent = FALSE)
	return

/turf/open/floor/engine/acid_act(acidpwr, acid_volume)
	acidpwr = min(acidpwr, 50) //we reduce the power so reinf floor never get melted.
	. = ..()

/turf/open/floor/engine/attackby(obj/item/C as obj, mob/user as mob, params)
	if(!C || !user)
		return
	if(istype(C, /obj/item/wrench))
		to_chat(user, "<span class='notice'>You begin removing rods...</span>")
		playsound(src, C.usesound, 80, 1)
		if(do_after(user, 30 * C.toolspeed, target = src))
			if(!istype(src, /turf/open/floor/engine))
				return
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/open/floor/plating)
			return

	if(istype(C, /obj/item/stack/sheet/plasteel) && !insulated) //Insulating the floor
		to_chat(user, "<span class='notice'>You begin insulating [src]...</span>")
		if(do_after(user, 40, target = src) && !insulated) //You finish insulating the insulated insulated insulated insulated insulated insulated insulated insulated vacuum floor
			to_chat(user, "<span class='notice'>You finish insulating [src].</span>")
			var/obj/item/stack/sheet/plasteel/W = C
			W.use(1)
			thermal_conductivity = 0
			insulated = 1
			name = "insulated " + name
			return

/turf/open/floor/engine/ex_act(severity)
	switch(severity)
		if(1)
			ChangeTurf(baseturf)
		if(2)
			if(prob(50))
				ChangeTurf(baseturf)

/turf/open/floor/engine/blob_act(obj/structure/blob/B)
	if(prob(25))
		ChangeTurf(baseturf)

/turf/open/floor/engine/cult/narsie_act()
	return

/turf/open/floor/engine/cult/ratvar_act()
	. = ..()
	if(istype(src, /turf/open/floor/engine/cult)) //if we haven't changed type
		var/previouscolor = color
		color = "#FAE48C"
		animate(src, color = previouscolor, time = 8)


/turf/open/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"

/turf/open/floor/engine/cult/Initialize(mapload)
	. = ..()
	if(SSticker.mode)//only do this if the round is going..otherwise..fucking asteroid..
		icon_state = SSticker.cultdat.cult_floor_icon_state


//air filled floors; used in atmos pressure chambers

/turf/open/floor/engine/n20
	name = "\improper N2O floor"
	sleeping_agent = 6000
	oxygen = 0
	nitrogen = 0

/turf/open/floor/engine/co2
	name = "\improper CO2 floor"
	carbon_dioxide = 50000
	oxygen = 0
	nitrogen = 0

/turf/open/floor/engine/plasma
	name = "plasma floor"
	toxins = 70000
	oxygen = 0
	nitrogen = 0

/turf/open/floor/engine/o2
	name = "\improper O2 floor"
	oxygen = 100000
	nitrogen = 0

/turf/open/floor/engine/n2
	name = "\improper N2 floor"
	nitrogen = 100000
	oxygen = 0

/turf/open/floor/engine/air
	name = "air floor"
	oxygen = 2644
	nitrogen = 10580


/turf/open/floor/engine/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		if(floor_tile)
			if(prob(30))
				new floor_tile(src)
				make_plating()
		else if(prob(30))
			ReplaceWithLattice()

/turf/open/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/open/floor/engine/insulated
	name = "insulated reinforced floor"
	icon_state = "engine"
	insulated = TRUE
	thermal_conductivity = 0

/turf/open/floor/engine/insulated/vacuum
	name = "insulated vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0

/* End Engine Floors */

//Snow

/turf/open/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	static_turf = FALSE
