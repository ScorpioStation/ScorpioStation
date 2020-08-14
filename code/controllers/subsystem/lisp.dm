SUBSYSTEM_DEF(lisp)
	name = "LISP"
	runlevels = RUNLEVEL_GAME
	offline_implications = "Silicon units cannot recover integrity. Shuttle call recommended."

	// keeps track of when to increase integrity
	var/next_increase = world.time

/datum/controller/subsystem/lisp/fire()
	log_and_message_admins("DEBUG(/datum/controller/subsystem/lisp/fire): Entering at [world.time]")
	// if it's time to increase silicon integrity again
	if(world.time > next_increase)
		log_and_message_admins("DEBUG(/datum/controller/subsystem/lisp/fire): world.time([world.time]) > next_increase([next_increase])")
		// allow the AIs to recover integrity
		for(var/mob/living/silicon/ai/A in GLOB.alive_mob_list)
			A.adjust_integrity(1)
		// allow the borgs to recover integrity
		for(var/mob/living/silicon/robot/B in GLOB.alive_mob_list)
			B.adjust_integrity(1)
		// set the next time we should recover integrity
		next_increase += (3 SECONDS)
