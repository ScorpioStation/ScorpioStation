SUBSYSTEM_DEF(lisp)
	name = "LISP"
	offline_implications = "Silicon units cannot recover integrity. Shuttle call recommended."
	runlevels = RUNLEVEL_GAME
	wait = 3 SECONDS

/datum/controller/subsystem/lisp/Initialize()
	return ..()

/datum/controller/subsystem/lisp/fire()
	// allow the AIs to recover integrity
	for(var/mob/living/silicon/ai/A in GLOB.alive_mob_list)
		A.adjust_integrity(1)
	// allow the borgs to recover integrity
	for(var/mob/living/silicon/robot/B in GLOB.alive_mob_list)
		B.adjust_integrity(1)
