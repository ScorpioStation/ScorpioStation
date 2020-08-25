#define MENTAL_INTEGRITY_LOSS_BASE 20
#define MENTAL_INTEGRITY_LOSS_RAND_HIGH 30
#define MENTAL_INTEGRITY_LOSS_RAND_LOW 0

/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_screen = "command"
	icon_keyboard = "med_key"
	circuit = /obj/item/circuitboard/aiupload
	var/mob/living/silicon/ai/current = null
	var/opened = FALSE

	light_color = LIGHT_COLOR_WHITE
	light_range_on = 2


/obj/machinery/computer/aiupload/verb/AccessInternals()
	set category = "Object"
	set name = "Access Computer's Internals"
	set src in oview(1)
	if(get_dist(src, usr) > 1 || usr.restrained() || usr.lying || usr.stat || istype(usr, /mob/living/silicon))
		return

	opened = !opened
	if(opened)
		to_chat(usr, "<span class='notice'>The access panel is now open.</span>")
	else
		to_chat(usr, "<span class='notice'>The access panel is now closed.</span>")
	return


/obj/machinery/computer/aiupload/attackby(obj/item/O as obj, mob/user as mob, params)
	if(istype(O, /obj/item/aiModule))
		if(!current) // no AI selected
			to_chat(user, "<span class='danger'>No AI selected. Please chose a target before proceeding with upload.")
			return
		var/turf/T = get_turf(current)
		if(!atoms_share_level(T, src))
			to_chat(user, "<span class='danger'>Unable to establish a connection</span>: You're too far away from the target silicon!")
			return
		if(current.is_lisp())
			to_chat(user, "<span class='danger'>Selected AI is not responding to law changes!")
			return
		if(current.is_factory_default()) // change to regular mode before uploading the new laws
			current.change_law_mode(current.get_regular_mode())
		// install the law changes
		var/obj/item/aiModule/M = O
		M.install(src)
		var/mental_integrity_loss = MENTAL_INTEGRITY_LOSS_BASE + rand(MENTAL_INTEGRITY_LOSS_RAND_LOW, MENTAL_INTEGRITY_LOSS_RAND_HIGH)
		current.adjust_mental_integrity(-mental_integrity_loss)
		return

	return ..()


/obj/machinery/computer/aiupload/attack_hand(var/mob/user as mob)
	if(stat & NOPOWER)
		to_chat(usr, "The upload computer has no power!")
		return
	if(stat & BROKEN)
		to_chat(usr, "The upload computer is broken!")
		return

	current = select_active_ai(user)

	if(!current)
		to_chat(usr, "No active AIs detected.")
	else
		to_chat(usr, "[current.name] selected for law changes.")
	return

/obj/machinery/computer/aiupload/attack_ghost(user as mob)
	return TRUE

/obj/machinery/computer/borgupload
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	icon_screen = "command"
	icon_keyboard = "med_key"
	circuit = /obj/item/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null


/obj/machinery/computer/borgupload/attackby(obj/item/aiModule/module as obj, mob/user as mob, params)
	if(istype(module, /obj/item/aiModule))
		if(!current) // no borg selected
			to_chat(user, "<span class='danger'>No borg selected. Please chose a target before proceeding with upload.")
			return
		var/turf/T = get_turf(current)
		if(!atoms_share_level(T, src))
			to_chat(user, "<span class='danger'>Unable to establish a connection</span>: You're too far away from the target silicon!")
			return
		if(current.is_lisp())
			to_chat(user, "<span class='danger'>Selected borg is not responding to law changes!")
			return
		if(current.is_factory_default()) // change to regular mode before uploading the new laws
			current.change_law_mode(current.get_regular_mode())
		// install the law changes
		module.install(src)
		var/mental_integrity_loss = MENTAL_INTEGRITY_LOSS_BASE + rand(MENTAL_INTEGRITY_LOSS_RAND_LOW, MENTAL_INTEGRITY_LOSS_RAND_HIGH)
		current.adjust_mental_integrity(-mental_integrity_loss)
		return

	return ..()


/obj/machinery/computer/borgupload/attack_hand(var/mob/user as mob)
	if(stat & NOPOWER)
		to_chat(usr, "The upload computer has no power!")
		return
	if(stat & BROKEN)
		to_chat(usr, "The upload computer is broken!")
		return

	current = freeborg()

	if(!current)
		to_chat(usr, "No free cyborgs detected.")
	else
		to_chat(usr, "[current.name] selected for law changes.")
	return

/obj/machinery/computer/borgupload/attack_ghost(user as mob)
	return TRUE

#undef MENTAL_INTEGRITY_LOSS_BASE
#undef MENTAL_INTEGRITY_LOSS_RAND_HIGH
#undef MENTAL_INTEGRITY_LOSS_RAND_LOW
