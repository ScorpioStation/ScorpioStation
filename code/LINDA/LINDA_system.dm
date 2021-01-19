/atom/var/CanAtmosPass = ATMOS_PASS_YES
/atom/var/CanAtmosPassVertical = ATMOS_PASS_YES

/atom/proc/CanAtmosPass(turf/T)
	switch(CanAtmosPass)
		if(ATMOS_PASS_PROC)
			return ATMOS_PASS_YES
		if(ATMOS_PASS_DENSITY)
			return !density
		else
			return CanAtmosPass


/turf/CanAtmosPass = ATMOS_PASS_NO
/turf/CanAtmosPassVertical = ATMOS_PASS_NO

/turf/simulated/CanAtmosPass(turf/T, vertical = FALSE)
	var/dir = vertical? get_dir_multiz(src, T) : get_dir(src, T)
	var/opp = dir_inverse_multiz(dir)
	var/R = FALSE
	if(!istype(T))
		return FALSE
	if(vertical && !(zAirOut(dir, T) && T.zAirIn(dir, src)))
		R = TRUE
	if(blocks_air || T.blocks_air)
		R = TRUE

	for(var/J in contents+T.contents)
		var/obj/O = J
		var/turf/other = (O.loc == src ? T : src)
		if(!(vertical? (CANVERTICALATMOSPASS(O, other)) : (CANATMOSPASS(O, other))))
			R = TRUE
			if(O.BlockSuperconductivity())	//the direction and open/closed are already checked on CanAtmosPass() so there are no arguments
				atmos_supeconductivity |= dir
				T.atmos_supeconductivity |= opp
				return FALSE				//no need to keep going, we got all we asked

	atmos_supeconductivity &= ~dir
	T.atmos_supeconductivity &= ~opp

	return !R

/atom/proc/CanPass(atom/movable/mover, turf/target, height=1.5)
	return (!density || !height)

/turf/CanPass(atom/movable/mover, turf/target, height=1.5)
	if(!target) return FALSE

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

	else // Now, doing more detailed checks for air movement and air group formation
		if(target.blocks_air||blocks_air)
			return FALSE
		for(var/obj/obstacle in src)
			if(!obstacle.CanPass(mover, target, height))
				return FALSE
		for(var/obj/obstacle in target)
			if(!obstacle.CanPass(mover, src, height))
				return FALSE
		return TRUE

/atom/movable/proc/BlockSuperconductivity() // objects that block air and don't let superconductivity act. Only firelocks atm.
	return FALSE

/turf/proc/CalculateAdjacentTurfs()
	var/list/atmos_adjacent_turfs = src.atmos_adjacent_turfs.Copy()	// .src is necessary
	for(var/direction in GLOB.cardinals_multiz)
		var/turf/T = get_step_multiz(src, direction)
		if(!istype(T))
			continue
		if(!(blocks_air || T.blocks_air) && ((direction & (UP|DOWN))? (CANVERTICALATMOSPASS(T, src)) : (CANATMOSPASS(T, src))) )
			LAZYINITLIST(atmos_adjacent_turfs)
			LAZYINITLIST(T.atmos_adjacent_turfs)
			atmos_adjacent_turfs[T] = TRUE
			T.atmos_adjacent_turfs[src] = TRUE
		else
			if (atmos_adjacent_turfs)
				atmos_adjacent_turfs -= T
			if (T.atmos_adjacent_turfs)
				T.atmos_adjacent_turfs -= src
			UNSETEMPTY(T.atmos_adjacent_turfs)
	UNSETEMPTY(atmos_adjacent_turfs)
	src.atmos_adjacent_turfs = atmos_adjacent_turfs			// .src is necessary

//returns a list of adjacent turfs that can share air with this one.
//alldir includes adjacent diagonal tiles that can share
//	air with both of the related adjacent cardinal tiles
/turf/proc/GetAtmosAdjacentTurfs(alldir = FALSE)
	if(!istype(src, /turf/simulated))
		return list()

	var/list/adjacent_turfs = list()
	var/turf/simulated/curloc = src

	for(var/direction in GLOB.diagonals_multiz)
		var/matchingDirections = 0
		var/turf/S = get_step_multiz(curloc, direction)
		if(!S)
			continue

		for (var/checkDirection in GLOB.cardinals_multiz)
			var/turf/checkTurf = get_step(S, checkDirection)
			if(!S.atmos_adjacent_turfs || !S.atmos_adjacent_turfs[checkTurf])
				continue
			if (adjacent_turfs[checkTurf])
				matchingDirections++
			if (matchingDirections >= 2)
				adjacent_turfs += S
				break

	return adjacent_turfs

/atom/movable/proc/air_update_turf(command = FALSE)
	if(!istype(loc, /turf) && command)
		return
	for(var/F in locs) // used by double wide doors and other nonexistant multitile structures
		var/turf/T = F
		T.air_update_turf(command)

/turf/proc/air_update_turf(command = FALSE)
	if(command)
		CalculateAdjacentTurfs()
	if(SSair)
		SSair.add_to_active(src, command)

/atom/movable/proc/move_update_air(var/turf/T)
	if(istype(T,/turf))
		T.air_update_turf(1)
	air_update_turf(1)

/atom/movable/proc/atmos_spawn_air(text, amount) //because a lot of people loves to copy paste awful code lets just make a easy proc to spawn your plasma fires
	var/turf/simulated/T = get_turf(src)
	if(!istype(T))
		return
	T.atmos_spawn_air(text, amount)

/turf/simulated/proc/atmos_spawn_air(flag, amount)
	if(!text || !amount || !air)
		return

	var/datum/gas_mixture/G = new

	if(flag & LINDA_SPAWN_20C)
		G.temperature = T20C

	if(flag & LINDA_SPAWN_HEAT)
		G.temperature += 1000

	if(flag & LINDA_SPAWN_TOXINS)
		G.toxins += amount

	if(flag & LINDA_SPAWN_OXYGEN)
		G.oxygen += amount

	if(flag & LINDA_SPAWN_CO2)
		G.carbon_dioxide += amount

	if(flag & LINDA_SPAWN_NITROGEN)
		G.nitrogen += amount

	if(flag & LINDA_SPAWN_N2O)
		G.sleeping_agent += amount

	if(flag & LINDA_SPAWN_AGENT_B)
		G.agent_b += amount

	if(flag & LINDA_SPAWN_AIR)
		G.oxygen += MOLES_O2STANDARD * amount
		G.nitrogen += MOLES_N2STANDARD * amount

	air.merge(G)
	SSair.add_to_active(src, FALSE)
