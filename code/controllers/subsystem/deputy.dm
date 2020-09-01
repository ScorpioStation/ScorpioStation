SUBSYSTEM_DEF(deputy)
	name = "Deputy"
	offline_implications = "Deputy status of crew will no longer automatically update. No immediate action is needed."
	runlevels = RUNLEVEL_GAME
	wait = 5 MINUTES

/datum/controller/subsystem/deputy/Initialize()
	// if we aren't using the deputy subsystem, don't fire it
	if(!config.use_deputy_subsystem)
		flags |= SS_NO_FIRE

	// call parent initialization routine
	return ..()

/datum/controller/subsystem/deputy/fire()
	// determine how many active players and security people we have on station
	var/list/active_with_role = number_active_with_role()
	var/num_players = active_with_role["Any"]
	var/num_security = active_with_role["Security"]

	// if there are no players, there is nobody to deputize
	if(num_players < 1)
		return

	// determine if people should be deputized
	var/make_crew_deputy = FALSE

	// if the number of players falls below the deputy threshold
	if(num_players < config.deputy_below_playercount)
		make_crew_deputy = TRUE

	// if the security count falls below the deputy threshold
	var/sec_percent = PERCENT(num_security / num_players)
	if(sec_percent < config.deputy_below_sec_percent)
		make_crew_deputy = TRUE

	// update the deputy alert for connected clients
	for(var/mob/M in GLOB.player_list)
		if(make_crew_deputy)
			log_admin("[name] subsystem determined that crew are deputized.")
			M.throw_alert("deputy", /obj/screen/alert/deputized)
		else
			log_admin("[name] subsystem determined that crew are NOT deputized.")
			M.clear_alert("deputy")
