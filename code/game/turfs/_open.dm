#define WATER_STUN_TIME 2 //Stun time for water, to edit/find easier
#define WATER_WEAKEN_TIME 1 //Weaken time for water, to edit/find easier

/turf/open
	name = "station"
	///Properties for open tiles (/floor)
	/// All the gas vars, on the turf, are meant to be utilized for initializing a gas datum and setting its first gas values; the turf vars are never further modified at runtime; it is never directly used for calculations by the atmospherics system.
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	blocks_air = FALSE
	indestructible_turf = FALSE

	var/to_be_destroyed = FALSE //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/wet = FALSE
	var/image/wet_overlay = null
	var/cannot_wet = FALSE

/turf/open/handle_fall(mob/faller, forced)
	faller.lying = pick(90, 270)
	if(!forced)
		return
	if(has_gravity(src))
		playsound(src, "bodyfall", 50, TRUE)

/turf/open/Entered(atom/movable/A, atom/OL, ignoreRest = FALSE)
	//slipping
	if(!ignoreRest)
		if(ishuman(A))
			var/mob/living/carbon/human/M = A
			if(M.lying)
				return TRUE
			if(M.flying)
				return ..()
			switch(wet)
				if(TURF_WET_WATER)
					if(!(M.slip("the wet floor", WATER_STUN_TIME, WATER_WEAKEN_TIME, tilesSlipped = 0, walkSafely = TRUE)))
						M.inertia_dir = 0
						return
				if(TURF_WET_LUBE) //lube
					M.slip("the floor", 0, 5, tilesSlipped = 3, walkSafely = FALSE, slipAny = TRUE)
				if(TURF_WET_ICE) // Ice
					if(M.slip("the icy floor", 4, 2, tilesSlipped = 0, walkSafely = FALSE))
						M.inertia_dir = 0
						if(prob(5))
							var/obj/item/organ/external/affected = M.get_organ("head")
							if(affected)
								M.apply_damage(5, BRUTE, "head")
								M.visible_message("<span class='warning'><b>[M]</b> hits their head on the ice!</span>")
								playsound(src, 'sound/weapons/genhit1.ogg', 50, 1)
				if(TURF_WET_PERMAFROST) // Permafrost
					M.slip("the frosted floor", 0, 5, tilesSlipped = 1, walkSafely = FALSE, slipAny = TRUE)

/turf/open/water_act(volume, temperature, source)
	if(cannot_wet)
		return
	. = ..()
	if(volume >= 3)
		MakeSlippery()
	var/hotspot = (locate(/obj/effect/hotspot) in src)
	if(hotspot)
		var/datum/gas_mixture/lowertemp = remove_air(air.total_moles())
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature/2), 0)
		lowertemp.react()
		assume_air(lowertemp)
		qdel(hotspot)

/*
 * Makes a turf slippery using the given parameters
 * @param wet_setting The type of slipperyness used
 * @param time Time the turf is slippery. If null it will pick a random time between 790 and 820 ticks. If INFINITY then it won't dry up ever
*/
/turf/open/proc/MakeSlippery(wet_setting = TURF_WET_WATER, time = null) // 1 = Water, 2 = Lube, 3 = Ice, 4 = Permafrost
	if(cannot_wet)
		return
	if(wet >= wet_setting)
		return
	wet = wet_setting
	if(wet_setting != TURF_DRY)
		if(wet_overlay)
			overlays -= wet_overlay
			wet_overlay = null
		var/turf/open/floor/F = src
		if(istype(F))
			if(wet_setting >= TURF_WET_ICE)
				wet_overlay = image('icons/effects/water.dmi', src, "ice_floor")
			else
				wet_overlay = image('icons/effects/water.dmi', src, "wet_floor_static")
		else
			if(wet_setting >= TURF_WET_ICE)
				wet_overlay = image('icons/effects/water.dmi', src, "ice_floor")
			else
				wet_overlay = image('icons/effects/water.dmi', src, "wet_static")
		wet_overlay.plane = FLOOR_OVERLAY_PLANE
		overlays += wet_overlay
	if(time == INFINITY)
		return
	if(!time)
		time =	rand(790, 820)
	addtimer(CALLBACK(src, .proc/MakeDry, wet_setting), time)

/turf/open/MakeDry(wet_setting = TURF_WET_WATER)
	if(cannot_wet)
		return
	if(wet > wet_setting)
		return
	wet = TURF_DRY
	if(wet_overlay)
		overlays -= wet_overlay

/turf/open/ChangeTurf(path, defer_change = FALSE, keep_icon = TRUE, ignore_air = FALSE)
	. = ..()
	queue_smooth_neighbors(src)

/turf/open/AfterChange(ignore_air = FALSE, keep_cabling = FALSE)
	..()
	RemoveLattice()
	if(!ignore_air)
		Assimilate_Air()

//////Assimilate Air//////
/turf/open/proc/Assimilate_Air()
	if(blocks_air)
		return
	if(air)
		var/aoxy = 0 //Holders to assimilate air from nearby turfs
		var/anitro = 0
		var/aco = 0
		var/atox = 0
		var/asleep = 0
		var/ab = 0
		var/atemp = 0
		var/turf_count = 0
		for(var/T in atmos_adjacent_turfs)
			var/turf/open/S = T
			if(S.air)//Add the air's contents to the holders
				aoxy += S.air.oxygen
				anitro += S.air.nitrogen
				aco += S.air.carbon_dioxide
				atox += S.air.toxins
				asleep += S.air.sleeping_agent
				ab += S.air.agent_b
				atemp += S.air.temperature
			turf_count++
		if(!turf_count)	//If there weren't any open turfs, no need to update.
			return
		air.oxygen = (aoxy / max(turf_count, 1)) //Averages contents of the turfs, ignoring walls and the like
		air.nitrogen = (anitro / max(turf_count, 1))
		air.carbon_dioxide = (aco / max(turf_count, 1))
		air.toxins = (atox / max(turf_count, 1))
		air.sleeping_agent = (asleep / max(turf_count, 1))
		air.agent_b = (ab / max(turf_count, 1))
		air.temperature = (atemp / max(turf_count, 1))
		if(SSair)
			SSair.add_to_active(src)

/turf/open/singularity_act()
	return ..()

/turf/open/singularity_pull(S, current_size)
	if(indestructible_turf)	// this proc is on /atom, not /turf, so I put this check here.
		return
	return ..()

#undef WATER_STUN_TIME
#undef WATER_WEAKEN_TIME
