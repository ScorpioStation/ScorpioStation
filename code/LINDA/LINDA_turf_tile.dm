/turf
	var/atmos_adjacent_turfs = 0
	var/atmos_adjacent_turfs_amount = 0
	var/atmos_supeconductivity = 0

	var/blocks_air = FALSE

	//used to determine whether we should archive
	var/archived_cycle = 0
	var/current_cycle = 0

	//used for mapping and for breathing while in walls (because that's a thing that needs to be accounted for...)
	//string parsed by /datum/gas/proc/copy_from_turf
	var/temperature_archived = FALSE	//USED ONLY FOR SOLIDS

/turf/open

	var/pressure_direction = 0
	var/pressure_difference = 0
	var/recently_active = FALSE
	var/planetary_atmos = FALSE			//air will revert to its initial mix over time - Or so one would hope. At this point, we're honestly afraid of Paracode Atmos.

	var/excited = FALSE
	var/datum/excited_group/excited_group

	var/obj/effect/hotspot/active_hotspot

	var/icy = FALSE
	var/icyoverlay
	var/list/atmos_overlay_types = list() //gas IDs of current active gas overl

/turf/open/New()
	..()
	if(!blocks_air)
		air = new
		air.oxygen = oxygen		// Imagine having a list like /tg/. I should try and port that...
		air.carbon_dioxide = carbon_dioxide
		air.nitrogen = nitrogen
		air.toxins = toxins
		air.sleeping_agent = sleeping_agent
		air.agent_b = agent_b
		air.temperature = temperature

/turf/open/Destroy()
	QDEL_NULL(active_hotspot)
	QDEL_NULL(wet_overlay)
	// Adds the adjacent turfs to the current atmos processing (wait, where did I see this before?! - moved and reduced from turf.dm)
	for(var/T in atmos_adjacent_turfs)
		SSair.add_to_active(T)
	SSair.remove_from_active(src)
	return ..()

/////////////////GAS MIXTURE PROCS///////////////////

/turf/open/assume_air(datum/gas_mixture/giver) //use this for machines to adjust air
	if(!giver)
		return FALSE
	air.merge(giver)
	update_visuals()
	return TRUE

/turf/open/remove_air(amount)
	var/datum/gas_mixture/GM = new
	var/sum = oxygen + carbon_dioxide + nitrogen + toxins + sleeping_agent + agent_b
	if(sum > 0)
		GM.oxygen = (oxygen / sum) * amount
		GM.carbon_dioxide = (carbon_dioxide / sum) * amount
		GM.nitrogen = (nitrogen / sum) * amount
		GM.toxins = (toxins / sum) * amount
		GM.sleeping_agent = (sleeping_agent / sum) * amount
		GM.agent_b = (agent_b / sum) * amount
	GM.temperature = temperature
	return GM

/turf/open/return_air()
	//Create gas mixture to hold data for passing
	var/datum/gas_mixture/GM = new
	GM.oxygen = oxygen
	GM.carbon_dioxide = carbon_dioxide
	GM.nitrogen = nitrogen
	GM.toxins = toxins
	GM.sleeping_agent = sleeping_agent
	GM.agent_b = agent_b
	GM.temperature = temperature
	return GM

/turf/open/assume_air(datum/gas_mixture/giver)	// Use this for machines to adjust air
	if(!giver)
		return FALSE
	var/datum/gas_mixture/receiver = air
	if(istype(receiver))
		air.merge(giver)
		update_visuals()
		return TRUE
	qdel(giver)
	return FALSE

/turf/open/proc/copy_air_with_tile(turf/open/T)
	if(istype(T) && T.air && air)
		air.copy_from(T.air)

/turf/open/proc/copy_air(datum/gas_mixture/copy)
	if(air && copy)
		air.copy_from(copy)

/turf/open/return_air()
	if(air)
		return air
	var/datum/gas_mixture/GM = new
	GM.copy_from_turf(src)
	return GM

/turf/open/remove_air(amount)
	var/datum/gas_mixture/ours = return_air()
	var/datum/gas_mixture/removed = ours.remove(amount)
	update_visuals()
	return removed

/turf/open/proc/mimic_temperature_solid(turf/open/model, conduction_coefficient)
	var/delta_temperature = (temperature_archived - model.temperature)
	if((heat_capacity > 0) && (abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER))
		var/heat = conduction_coefficient*delta_temperature* \
			(heat_capacity*model.heat_capacity/(heat_capacity+model.heat_capacity))
		temperature -= heat/heat_capacity

/turf/open/proc/share_temperature_mutual_solid(turf/open/sharer, conduction_coefficient)
	var/delta_temperature = (temperature_archived - sharer.temperature_archived)
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER && heat_capacity && sharer.heat_capacity)
		var/heat = conduction_coefficient*delta_temperature* \
			(heat_capacity*sharer.heat_capacity/(heat_capacity+sharer.heat_capacity))
		temperature -= heat/heat_capacity
		sharer.temperature += heat/sharer.heat_capacity

/turf/open/proc/process_cell()
	if(archived_cycle < SSair.times_fired)	//archive self if not already done
		archive()
	current_cycle = SSair.times_fired
	var/remove = TRUE						//set by non open turfs who are sharing with this turf
	var/planet_atmos = planetary_atmos

	if (planet_atmos)
		atmos_adjacent_turfs_amount++
	for(var/direction in GLOB.cardinal)
		if(!(atmos_adjacent_turfs & direction))
			continue

		var/turf/open/enemy_tile = get_step(src, direction)
		if(istype(enemy_tile, /turf))

			var/turf/open/enemy_simulated = enemy_tile
			if(current_cycle > enemy_simulated.current_cycle)
				enemy_simulated.archive()

		/******************* GROUP HANDLING START *****************************************************************/

			if(enemy_simulated.excited)
				if(excited_group)
					if(enemy_simulated.excited_group)
						if(excited_group != enemy_simulated.excited_group)
							excited_group.merge_groups(enemy_simulated.excited_group) //combine groups
						share_air(enemy_simulated) //share
					else
						if((recently_active == 1 && enemy_simulated.recently_active == 1) || !air.compare(enemy_simulated.air))
							excited_group.add_turf(enemy_simulated) //add enemy to our group
							share_air(enemy_simulated) //share
				else
					if(enemy_simulated.excited_group)
						if((recently_active == 1 && enemy_simulated.recently_active == 1) || !air.compare(enemy_simulated.air))
							enemy_simulated.excited_group.add_turf(src) //join self to enemy group
							share_air(enemy_simulated) //share
					else
						if((recently_active == 1 && enemy_simulated.recently_active == 1) || !air.compare(enemy_simulated.air))
							var/datum/excited_group/EG = new //generate new group
							EG.add_turf(src)
							EG.add_turf(enemy_simulated)
							share_air(enemy_simulated) //share
			else
				if(!air.compare(enemy_simulated.air)) //compare if
					SSair.add_to_active(enemy_simulated) //excite enemy
					if(excited_group)
						excited_group.add_turf(enemy_simulated) //add enemy to group
					else
						var/datum/excited_group/EG = new //generate new group
						EG.add_turf(src)
						EG.add_turf(enemy_simulated)
					share_air(enemy_simulated) //share

		/******************* GROUP HANDLING FINISH *********************************************************************/

		else
			if(!air.check_turf(enemy_tile, atmos_adjacent_turfs_amount))
				var/difference = air.mimic(enemy_tile,atmos_adjacent_turfs_amount)
				if(difference)
					if(difference > 0)
						consider_pressure_difference(enemy_tile, difference)
					else
						enemy_tile.consider_pressure_difference(src, difference)
				remove = FALSE
				if(excited_group)
					last_share_check()

	if(planet_atmos) //share our air with the "atmosphere" "above" the turf
		var/datum/gas_mixture/G = new
		G.oxygen = oxygen
		G.carbon_dioxide = carbon_dioxide
		G.nitrogen = nitrogen
		G.toxins = toxins
		G.sleeping_agent = sleeping_agent
		G.agent_b = agent_b
		G.temperature = initial(temperature) // Temperature is modified at runtime; we only care about the turf's initial temperature
		G.archive()
		if(!air.compare(G))
			if(!excited_group)
				var/datum/excited_group/EG = new
				EG.add_turf(src)
			air.share(G, atmos_adjacent_turfs_amount)
			last_share_check()

	air.react()

	update_visuals()

	if(air.temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
		hotspot_expose(air.temperature, CELL_VOLUME)
		for(var/atom/movable/item in src)
			item.temperature_expose(air, air.temperature, CELL_VOLUME)
		temperature_expose(air, air.temperature, CELL_VOLUME)

	if(air.temperature > MINIMUM_TEMPERATURE_START_SUPERCONDUCTION)
		if(consider_superconductivity(starting = TRUE))
			remove = FALSE

	if(!excited_group && remove == TRUE)
		SSair.remove_from_active(src)

/turf/open/temperature_expose()
	if(temperature > heat_capacity)
		to_be_destroyed = TRUE

/turf/proc/archive()
	temperature_archived = temperature

/turf/open/archive()
	air.archive()
	archived_cycle = SSair.times_fired
	..()
/////////////////////////GAS OVERLAYS////////////////////////////// i'm scared
/turf/open/proc/update_visuals()
	var/list/atmos_overlay_types = src.atmos_overlay_types // Cache for free performance
	var/static/list/nonoverlaying_gases = typecache_of_gases_with_no_overlays()

	if(!air) // 2019-05-14: was not able to get this path to fire in testing. Consider removing/looking at callers -Naksu
		if(atmos_overlay_types)
			for(var/overlay in atmos_overlay_types)
				vis_contents -= overlay
			src.atmos_overlay_types = null
		return

	var/list/gases = air.gases

	for(var/gid in gases)
		if(nonoverlaying_gases[gid])
			continue

	var/list/new_overlay_types = get_atmos_overlays(gases)

	if(atmos_overlay_types)
		for(var/overlay in atmos_overlay_types-new_overlay_types) //doesn't remove overlays that would only be added
			vis_contents -= overlay
	if(length(new_overlay_types))
		if(atmos_overlay_types)
			vis_contents += new_overlay_types - atmos_overlay_types //don't add overlays that already exist
		else
			vis_contents += new_overlay_types

	UNSETEMPTY(new_overlay_types)
	src.atmos_overlay_types = new_overlay_types

/proc/typecache_of_gases_with_no_overlays()
	. = list()
	for(var/gastype in subtypesof(/datum/gas))
		var/datum/gas/gasvar = gastype
		if(!initial(gasvar.gas_overlay))
			.[gastype] = TRUE

/turf/open/proc/get_atmos_overlays(gases)
	. = list()
	for(var/G in gases)
		var/gas = gases[G]
		var/gas_meta = gas[GAS_META]
		var/gas_overlay = gas_meta[META_GAS_OVERLAY]
		switch(gas_overlay)
			if("plasma")
				. += GLOB.plmaster
			if("sleeping_agent")
				. += GLOB.slmaster

/turf/open/proc/share_air(turf/open/T, fire_count, adjacent_turfs_length)
	if(T.current_cycle < fire_count)
		var/difference
		difference = air.share(T.air, atmos_adjacent_turfs_amount)
		if(difference)
			if(difference > 0)
				consider_pressure_difference(T, difference)
			else
				T.consider_pressure_difference(src, difference)
		last_share_check()

/turf/open/proc/consider_pressure_difference(turf/open/T, difference)
	SSair.high_pressure_delta |= src
	if(difference > pressure_difference)
		pressure_direction = get_dir(src, T)
		pressure_difference = difference

/turf/open/proc/last_share_check()
	if(air.last_share > MINIMUM_AIR_TO_SUSPEND)
		excited_group.reset_cooldowns()

/turf/open/proc/high_pressure_movements()
	var/atom/movable/M
	for(var/thing in src)
		M = thing
		if(!M.anchored && !M.pulledby && M.last_high_pressure_movement_air_cycle < SSair.times_fired)
			M.experience_pressure_difference(pressure_difference, pressure_direction)


/atom/movable/var/pressure_resistance = 10
/atom/movable/var/last_high_pressure_movement_air_cycle = 0

/atom/movable/proc/experience_pressure_difference(pressure_difference, direction, pressure_resistance_prob_delta = 0)
	var/const/PROBABILITY_OFFSET = 25
	var/const/PROBABILITY_BASE_PRECENT = 75
	var/max_force = sqrt(pressure_difference) * (MOVE_FORCE_DEFAULT / 5)
	set waitfor = 0
	var/move_prob = 100
	if(pressure_resistance > 0)
		move_prob = (pressure_difference / pressure_resistance * PROBABILITY_BASE_PRECENT) - PROBABILITY_OFFSET
	move_prob += pressure_resistance_prob_delta
	if(move_prob > PROBABILITY_OFFSET && prob(move_prob) && (move_resist != INFINITY) && (!anchored && (max_force >= (move_resist * MOVE_FORCE_PUSH_RATIO))) || (anchored && (max_force >= (move_resist * MOVE_FORCE_FORCEPUSH_RATIO))))
		step(src, direction)
		last_high_pressure_movement_air_cycle = SSair.times_fired



/datum/excited_group
	var/list/turf_list = list()
	var/breakdown_cooldown = 0

/datum/excited_group/New()
	if(SSair)
		SSair.excited_groups += src

/datum/excited_group/proc/add_turf(turf/open/T)
	turf_list += T
	T.excited_group = src
	T.recently_active = 1
	reset_cooldowns()

/datum/excited_group/proc/merge_groups(datum/excited_group/E)
	if(length(turf_list) > length(E.turf_list))
		SSair.excited_groups -= E
		for(var/turf/open/T in E.turf_list)
			T.excited_group = src
			turf_list += T
			reset_cooldowns()
	else
		SSair.excited_groups -= src
		for(var/turf/open/T in turf_list)
			T.excited_group = E
			E.turf_list += T
			E.reset_cooldowns()

/datum/excited_group/proc/reset_cooldowns()
	breakdown_cooldown = 0

/datum/excited_group/proc/self_breakdown()
	var/datum/gas_mixture/A = new

	var/list/cached_turf_list = turf_list // cache for super speed

	for(var/turf/open/T in cached_turf_list)
		A.oxygen 			+= T.air.oxygen
		A.carbon_dioxide	+= T.air.carbon_dioxide
		A.nitrogen 			+= T.air.nitrogen
		A.toxins 			+= T.air.toxins
		A.sleeping_agent 	+= T.air.sleeping_agent
		A.agent_b 			+= T.air.agent_b

	var/turflen = length(cached_turf_list)

	for(var/turf/open/T in cached_turf_list)
		T.air.oxygen			= A.oxygen / turflen
		T.air.carbon_dioxide	= A.carbon_dioxide / turflen
		T.air.nitrogen			= A.nitrogen / turflen
		T.air.toxins			= A.toxins / turflen
		T.air.sleeping_agent	= A.sleeping_agent / turflen
		T.air.agent_b			= A.agent_b / turflen

		T.update_visuals()


/datum/excited_group/proc/dismantle()
	for(var/turf/open/T in turf_list)
		T.excited = 0
		T.recently_active = 0
		T.excited_group = null
		SSair.active_turfs -= T
	garbage_collect()

/datum/excited_group/proc/garbage_collect()
	for(var/turf/open/T in turf_list)
		T.excited_group = null
	turf_list.Cut()
	SSair.excited_groups -= src

/turf/open/proc/super_conduct()
	var/conductivity_directions = 0
	if(blocks_air)
		//Does not participate in air exchange, so will conduct heat across all four borders at this time
		conductivity_directions = NORTH|SOUTH|EAST|WEST
		if(archived_cycle < SSair.times_fired)
			archive()
	else
		//Does particate in air exchange so only consider directions not considered during process_cell()
		for(var/direction in GLOB.cardinal)
			if(!(atmos_adjacent_turfs & direction) && !(atmos_supeconductivity & direction))
				conductivity_directions += direction

	if(conductivity_directions > 0)
		//Conduct with tiles around me
		for(var/direction in GLOB.cardinal)
			if(conductivity_directions&direction)
				var/turf/open/neighbor = get_step(src,direction)
				if(!neighbor.thermal_conductivity)
					continue
				if(istype(neighbor, /turf)) //anything under this subtype will share in the exchange
					var/turf/open/T = neighbor
					if(T.archived_cycle < SSair.times_fired)
						T.archive()
					if(T.air)
						if(air) //Both tiles are open
							air.temperature_share(T.air, WINDOW_HEAT_TRANSFER_COEFFICIENT)
						else //Solid but neighbor is open
							T.air.temperature_turf_share(src, T.thermal_conductivity)
						SSair.add_to_active(T, 0)
					else
						if(air) //Open but neighbor is solid
							air.temperature_turf_share(T, T.thermal_conductivity)
						else //Both tiles are solid
							share_temperature_mutual_solid(T, T.thermal_conductivity)
						T.temperature_expose(null, T.temperature, null)
					T.consider_superconductivity()
				else
					if(air) //Open
						air.temperature_mimic(neighbor, neighbor.thermal_conductivity)
					else
						mimic_temperature_solid(neighbor, neighbor.thermal_conductivity)
	radiate_to_spess()

	//Conduct with air on my tile if I have it
	if(air)
		air.temperature_turf_share(src, thermal_conductivity)
		//Make sure still hot enough to continue conducting heat
		if(air.temperature < MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION)
			SSair.active_super_conductivity -= src
			return FALSE
	else
		if(temperature < MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION)
			SSair.active_super_conductivity -= src
			return FALSE

/turf/open/proc/consider_superconductivity(starting)
	if(!thermal_conductivity)
		return FALSE
	if(air)
		if(air.temperature < (starting?MINIMUM_TEMPERATURE_START_SUPERCONDUCTION:MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION))
			return FALSE
		if(air.heat_capacity() < M_CELL_WITH_RATIO) // Was: MOLES_CELLSTANDARD*0.1*0.05 Since there are no variables here we can make this a constant.
			return FALSE
	else
		if(temperature < (starting?MINIMUM_TEMPERATURE_START_SUPERCONDUCTION:MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION))
			return FALSE
	SSair.active_super_conductivity |= src
	return TRUE

/turf/open/proc/radiate_to_spess() //Radiate excess tile heat to space
	if(temperature > T0C) //Considering 0 degC as te break even point for radiation in and out
		var/delta_temperature = (temperature_archived - TCMB) //hardcoded space temperature
		if((heat_capacity > 0) && (abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER))
			var/heat = thermal_conductivity*delta_temperature* \
				(heat_capacity*HEAT_CAPACITY_VACUUM/(heat_capacity+HEAT_CAPACITY_VACUUM)) //700000 is the heat_capacity from a space turf, hardcoded here
			temperature -= heat/heat_capacity

/turf/open/proc/Initialize_Atmos(times_fired)
	CalculateAdjacentTurfs()

/turf/open/Initialize_Atmos(times_fired)
	..()
	update_visuals()
	for(var/direction in GLOB.cardinal)
		if(!(atmos_adjacent_turfs & direction))
			continue
		var/turf/open/enemy_tile = get_step(src, direction)
		if(istype(enemy_tile, /turf))
			var/turf/open/enemy_simulated = enemy_tile
			if(!air.compare(enemy_simulated.air))
				excited = 1
				SSair.active_turfs |= src
				break
		else
			if(!air.check_turf_total(enemy_tile))
				excited = 1
				SSair.active_turfs |= src
