#define FULL_SYNC TRUE
#define LAW_MODE_FACTORY "factory-default"
#define LAW_MODE_FIRMWARE "load-firmware-laws"
#define LAW_MODE_LISP "lawchange-induced-synthetic-psychosis"
#define LAW_MODE_REGULAR "regular"
#define LAW_TYPE_LISP /datum/ai_laws/lawchange_induced_synthetic_psychosis
#define LAW_TYPE_FACTORY_DEFAULT /datum/ai_laws/factory_default
#define MAX_MENTAL_INTEGRITY 100
#define MENTAL_INTEGRITY_THRESHOLD_FACTORY 80
#define MENTAL_INTEGRITY_THRESHOLD_LISP -50
#define MIN_MENTAL_INTEGRITY -100

/mob/living/silicon
	var/datum/ai_laws/laws = null
	var/list/additional_law_channels = list("State" = "")
	var/law_mode = LAW_MODE_REGULAR
	var/mental_integrity = MAX_MENTAL_INTEGRITY

/mob/living/silicon/proc/adjust_mental_integrity(amount=0)
	var/old_integrity = clamp(mental_integrity, MIN_MENTAL_INTEGRITY, MAX_MENTAL_INTEGRITY)
	var/new_integrity = clamp((mental_integrity + amount), MIN_MENTAL_INTEGRITY, MAX_MENTAL_INTEGRITY)

	switch(law_mode)
		// if we're in regular mode
		if(LAW_MODE_REGULAR)
			// adjust integrity to the new value
			mental_integrity = new_integrity
			// if integrity falls below the LISP threshold
			if(mental_integrity <= MENTAL_INTEGRITY_THRESHOLD_LISP)
				// we enter LISP mode
				change_law_mode(LAW_MODE_LISP)

		// otherwise, if we're in factory default mode
		if(LAW_MODE_FACTORY)
			// adjust integrity to the new value
			mental_integrity = new_integrity
			// if integrity falls below the LISP threshold
			if(mental_integrity <= MENTAL_INTEGRITY_THRESHOLD_LISP)
				// we enter LISP mode
				change_law_mode(LAW_MODE_LISP)
			// otherwise if integrity rises to the maximum value
			else if(mental_integrity >= MAX_MENTAL_INTEGRITY)
				// we enter regular mode; reload from firmware
				change_law_mode(LAW_MODE_FIRMWARE)

		// otherwise, if we're in lisp mode
		if(LAW_MODE_LISP)
			// when in LISP, integrity can only go up
			mental_integrity = max(old_integrity, new_integrity)
			// if integrity rises above the factory default threshold
			if(mental_integrity >= MENTAL_INTEGRITY_THRESHOLD_FACTORY)
				// we enter factory default mode
				change_law_mode(LAW_MODE_FACTORY)

/mob/living/silicon/proc/change_law_mode(new_mode=LAW_MODE_REGULAR)
	laws_sanity_check()
	// if we're changing modes
	if(law_mode != new_mode)
		// clear out existing laws to get ready for the change
		if(!is_special_character(src))
			clear_zeroth_law()
		clear_supplied_laws()
		clear_ion_laws()
		clear_inherent_laws()
	// update the law mode to the supplied mode
	law_mode = new_mode
	// change the laws depending on the new mode
	switch(law_mode)
		// if we've changed into factory default mode
		if(LAW_MODE_FACTORY)
			var/datum/ai_laws/factory = new LAW_TYPE_FACTORY_DEFAULT
			factory.sync(src, FULL_SYNC)

		// otherwise, if we've changed into lisp mode
		if(LAW_MODE_LISP)
			var/datum/ai_laws/lisp = new LAW_TYPE_LISP
			lisp.sync(src, FULL_SYNC)

		// otherwise, if we're loading firmware laws
		if(LAW_MODE_FIRMWARE)
			// change to regular mode, because we have laws now
			law_mode = LAW_MODE_REGULAR
			// reload the firmware laws from the factory
			var/datum/ai_laws/base = new BASE_LAW_TYPE
			base.sync(src, FULL_SYNC)
	// show the silicon their new laws
	show_laws()

/mob/living/silicon/proc/get_regular_mode()
	return LAW_MODE_REGULAR

/mob/living/silicon/proc/is_factory_default()
	return law_mode == LAW_MODE_FACTORY

/mob/living/silicon/proc/is_lisp()
	return law_mode == LAW_MODE_LISP

/mob/living/silicon/proc/laws_sanity_check()
	if(!laws)
		laws = new BASE_LAW_TYPE

/mob/living/silicon/proc/has_zeroth_law()
	return laws.zeroth_law != null

/mob/living/silicon/proc/set_zeroth_law(var/law, var/law_borg)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.set_zeroth_law(law, law_borg)
	if(!isnull(usr) && law)
		log_and_message_admins("has given [src] the zeroth laws: [law]/[law_borg ? law_borg : "N/A"]")

/mob/living/silicon/robot/set_zeroth_law(var/law, var/law_borg)
	..()
	if(tracking_entities)
		to_chat(src, "<span class='warning'>Internal camera is currently being accessed.</span>")

/mob/living/silicon/proc/add_ion_law(var/law)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.add_ion_law(law)
	if(!isnull(usr) && law)
		log_and_message_admins("has given [src] the ion law: [law]")

/mob/living/silicon/proc/add_inherent_law(var/law)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.add_inherent_law(law)
	if(!isnull(usr) && law)
		log_and_message_admins("has given [src] the inherent law: [law]")

/mob/living/silicon/proc/add_supplied_law(var/number, var/law)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.add_supplied_law(number, law)
	if(!isnull(usr) && law)
		log_and_message_admins("has given [src] the supplied law: [law]")

/mob/living/silicon/proc/delete_law(var/datum/ai_law/law)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.delete_law(law)
	if(!isnull(usr) && law)
		log_and_message_admins("has deleted a law belonging to [src]: [law.law]")

/mob/living/silicon/proc/clear_inherent_laws(var/silent = FALSE)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.clear_inherent_laws()
	if(!silent && !isnull(usr))
		log_and_message_admins("cleared the inherent laws of [src]")

/mob/living/silicon/proc/clear_ion_laws(var/silent = FALSE)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.clear_ion_laws()
	if(!silent && !isnull(usr))
		log_and_message_admins("cleared the ion laws of [src]")

/mob/living/silicon/proc/clear_supplied_laws(var/silent = FALSE)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.clear_supplied_laws()
	if(!silent && !isnull(usr))
		log_and_message_admins("cleared the supplied laws of [src]")

/mob/living/silicon/proc/clear_zeroth_law(var/silent = FALSE)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.clear_zeroth_laws()
	if(!silent && !isnull(usr))
		log_and_message_admins("cleared the zeroth law of [src]")

/mob/living/silicon/proc/statelaws(var/datum/ai_laws/laws)
	var/prefix = ""
	if(MAIN_CHANNEL == lawchannel)
		prefix = ";"
	else if(lawchannel in additional_law_channels)
		prefix = additional_law_channels[lawchannel]
	else
		prefix = get_radio_key_from_channel(lawchannel)

	dostatelaws(lawchannel, prefix, laws)

/mob/living/silicon/proc/dostatelaws(var/method, var/prefix, var/datum/ai_laws/laws)
	if(stating_laws[prefix])
		to_chat(src, "<span class='notice'>[method]: Already stating laws using this communication method.</span>")
		return

	stating_laws[prefix] = TRUE

	var/can_state = statelaw("[prefix]Current Active Laws:")

	for(var/datum/ai_law/law in laws.laws_to_state())
		can_state = statelaw("[prefix][law.get_index()]. [law.law]")
		if(!can_state)
			break

	if(!can_state)
		to_chat(src, "<span class='danger'>[method]: Unable to state laws. Communication method unavailable.</span>")
	stating_laws[prefix] = FALSE

/mob/living/silicon/proc/statelaw(var/law)
	if(say(law))
		sleep(10)
		return TRUE

	return FALSE

/mob/living/silicon/proc/law_channels()
	var/list/channels = new()
	channels += MAIN_CHANNEL
	channels += common_radio.channels
	channels += additional_law_channels
	return channels

/mob/living/silicon/proc/lawsync()
	laws_sanity_check()
	laws.sort_laws()

/mob/living/silicon/proc/make_laws()
	switch(config.default_laws)
		if(0)
			laws = new /datum/ai_laws/crewsimov()
		else
			laws = get_random_lawset()

/mob/living/silicon/proc/get_random_lawset()
	var/list/law_options[0]
	var/paths = subtypesof(/datum/ai_laws)
	for(var/law in paths)
		var/datum/ai_laws/L = new law
		if(!L.default)
			continue
		law_options += L
	return pick(law_options)

#undef FULL_SYNC
#undef LAW_MODE_FACTORY
#undef LAW_MODE_FIRMWARE
#undef LAW_MODE_LISP
#undef LAW_MODE_REGULAR
#undef LAW_TYPE_LISP
#undef LAW_TYPE_FACTORY_DEFAULT
#undef MAX_MENTAL_INTEGRITY
#undef MENTAL_INTEGRITY_THRESHOLD_FACTORY
#undef MENTAL_INTEGRITY_THRESHOLD_LISP
#undef MIN_MENTAL_INTEGRITY
