SUBSYSTEM_DEF(deputy)
	name = "Deputy"
	offline_implications = "Deputy status of crew will no longer automatically update. No immediate action is needed."
	runlevels = RUNLEVEL_GAME
	wait = 1 MINUTES

	var/last_deputized = FALSE

/datum/controller/subsystem/deputy/Initialize()
	// if we aren't using the deputy subsystem, don't fire it
	if(!config.use_deputy_subsystem)
		flags |= SS_NO_FIRE

	// call parent initialization routine
	return ..()

/datum/controller/subsystem/deputy/fire()
	// first determine how many active security people we have on station
	var/list/active_with_role = number_active_with_role()
	var/num_security = active_with_role["Security"]

	// next determine how many active players we have
	var/num_players = active_with_role["Any"]

	// if there are no players, there is nobody to deputize
	if(num_players < 1)
		return

	// determine if people should be deputized
	var/deputized = FALSE

	// if the number of players falls below the deputy threshold
	if(num_players < config.deputy_below_playercount)
		deputized = TRUE

	// if the security count falls below the deputy threshold
	var/sec_percent = PERCENT(num_security / num_players)
	if(sec_percent < config.deputy_below_sec_percent)
		deputized = TRUE

	// determine if the crew is changing status
	var/gain_deputy = (!last_deputized && deputized)
	var/lose_deputy = (last_deputized && !deputized)

	// for every player in the game
	for(var/mob/M in GLOB.player_list)
		// clear deputy status from any antags
		if(isAntag(M))
			M.clear_alert("deputy")
		// if people should be deputized
		if(deputized)
			// if they aren't an antag, deputize them
			if(!isAntag(M))
				M.throw_alert("deputy", /obj/screen/alert/deputized)
			// if they are an antag, and the crew has just been deputized, warn them!
			if(isAntag(M) && gain_deputy)
				to_chat(M, "<span class='danger'>The crew looks ready to deal out vigilante justice!</span>")
		// otherwise, if people should no longer be deputized
		else
			// remove their deputy status
			M.clear_alert("deputy")
			// if they are an antag, and the crew has calmed down, tell them
			if(isAntag(M) && lose_deputy)
				to_chat(M, "The crew relaxes and seems less likely to deal out vigilante justice.")

	// remember if we deputized or not, for next time
	last_deputized = deputized
