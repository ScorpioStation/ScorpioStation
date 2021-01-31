
//Lava
/turf/open/floor/plating/lava
	name = "lava"
	icon_state = "lava"
	baseturf = /turf/open/floor/plating/lava //lava all the way down
	gender = PLURAL //"That's some lava."
	slowdown = 2
	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA
	cannot_wet = TRUE
	indestructible_turf = FALSE // Blame Swarmers

/turf/open/floor/plating/lava/airless
	temperature = TCMB

/turf/open/floor/plating/lava/smooth
	name = "lava"
	icon = 'icons/turf/floors/lava.dmi'
	icon_state = "unsmooth"
	baseturf = /turf/open/floor/plating/lava/smooth
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = null	// Smooths with itself

/turf/open/floor/plating/lava/smooth/lava_land_surface
	temperature = 300
	oxygen = 14
	nitrogen = 23
	planetary_atmos = TRUE
	baseturf = /turf/open/floor/chasm/straight_down/lava_land_surface

/turf/open/floor/plating/lava/smooth/airless
	temperature = TCMB

/turf/open/floor/plating/lava/Entered(atom/movable/AM)
	if(burn_stuff(AM))
		START_PROCESSING(SSprocessing, src)

/turf/open/floor/plating/lava/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(burn_stuff(AM))
		START_PROCESSING(SSprocessing, src)

/turf/open/floor/plating/lava/process()
	if(!burn_stuff())
		STOP_PROCESSING(SSprocessing, src)

/turf/open/floor/plating/lava/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/open/floor/plating/lava/proc/is_safe()
	var/static/list/lava_safeties_typecache = typecacheof(list(/obj/structure/lattice/catwalk, /obj/structure/stone_tile))
	var/list/found_safeties = typecache_filter_list(contents, lava_safeties_typecache)
	for(var/obj/structure/stone_tile/S in found_safeties)
		if(S.fallen)
			LAZYREMOVE(found_safeties, S)
	return LAZYLEN(found_safeties)

/turf/open/floor/plating/lava/proc/burn_stuff(AM)
	. = FALSE
	if(is_safe())
		return FALSE
	var/thing_to_check = src
	if(AM)
		thing_to_check = list(AM)
	for(var/thing in thing_to_check)
		if(isobj(thing))
			var/obj/O = thing
			if(!O.simulated)
				continue
			if((O.resistance_flags & (LAVA_PROOF | INDESTRUCTIBLE)) || O.throwing)
				continue
			. = TRUE
			if((O.resistance_flags & (ON_FIRE)))
				continue
			if(!(O.resistance_flags & FLAMMABLE))
				O.resistance_flags |= FLAMMABLE //Even fireproof things burn up in lava
			if(O.resistance_flags & FIRE_PROOF)
				O.resistance_flags &= ~FIRE_PROOF
			if(O.armor.getRating("fire") > 50) //obj with 100% fire armor still get slowly burned away.
				O.armor = O.armor.setRating(fire_value = 50)
			O.fire_act(10000, 1000)

		else if(isliving(thing))
			. = TRUE
			var/mob/living/L = thing
			if(L.flying)
				continue	//YOU'RE FLYING OVER IT
			var/buckle_check = L.buckling
			if(!buckle_check)
				buckle_check = L.buckled
			if(isobj(buckle_check))
				var/obj/O = buckle_check
				if(O.resistance_flags & LAVA_PROOF)
					continue
			else if(isliving(buckle_check))
				var/mob/living/live = buckle_check
				if("lava" in live.weather_immunities)
					continue

			if("lava" in L.weather_immunities)
				continue

			L.adjustFireLoss(20)
			if(L) //mobs turning into object corpses could get deleted here.
				L.adjust_fire_stacks(20)
				L.IgniteMob()

/turf/open/floor/plating/lava/swarmer_act()
	if(!is_safe())
		new /obj/structure/lattice/catwalk/swarmer_catwalk(src)
	return FALSE

/turf/open/floor/plating/lava/can_have_cabling()	// Override for ind_floor
	if(locate(/obj/structure/lattice/catwalk/swarmer_catwalk, src))
		return TRUE
	return FALSE

//Lava floor plating overrides - All because of Swarmers.
/turf/open/floor/plating/lava/singularity_act()
	return

/turf/open/floor/plating/lava/singularity_pull(S, current_size)
	return

/turf/open/floor/plating/lava/make_plating()
	return

/turf/open/floor/plating/lava/remove_plating()
	return

/turf/open/floor/plating/lava/ex_act()
	return

/turf/open/floor/plating/lava/acid_act(acidpwr, acid_volume)
	return

/turf/open/floor/plating/lava/attackby(obj/item/C, mob/user, params) //Lava isn't a good foundation to build on
	return

/turf/open/floor/plating/lava/screwdriver_act()
	return

/turf/open/floor/plating/lava/welder_act()
	return

/turf/open/floor/plating/lava/break_tile()
	return

/turf/open/floor/plating/lava/burn_tile()
	return
