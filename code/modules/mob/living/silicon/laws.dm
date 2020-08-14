#define MAX_INTEGRITY 100
#define MIN_INTEGRITY -100
#define MODE_FACTORY "factory-default"
#define MODE_FIRMWARE "load-firmware-laws"
#define MODE_LISP "lawchange-induced-synthetic-psychosis"
#define MODE_REGULAR "regular"
#define THRESHOLD_LISP -50
#define THRESHOLD_FACTORY 80

/mob/living/silicon
	var/datum/ai_laws/laws = null
	var/list/additional_law_channels = list("State" = "")
	var/integrity = MAX_INTEGRITY
	var/law_mode = MODE_REGULAR

/mob/living/silicon/proc/adjust_integrity(amount=0)
	log_and_message_admins("DEBUG(/mob/living/silicon/proc/adjust_integrity): Entering ([amount])")
	var/old_integrity = clamp(integrity, MIN_INTEGRITY, MAX_INTEGRITY)
	var/new_integrity = clamp((integrity + amount), MIN_INTEGRITY, MAX_INTEGRITY)

	// if we're in regular mode
	if(law_mode == MODE_REGULAR)
		// adjust integrity to the new value
		integrity = new_integrity
		// if integrity falls below the LISP threshold
		if(integrity <= THRESHOLD_LISP)
			// we enter LISP mode
			do_mode(MODE_LISP)

	// otherwise, if we're in factory default mode
	else if(law_mode == MODE_FACTORY)
		// adjust integrity to the new value
		integrity = new_integrity
		// if integrity falls below the LISP threshold
		if(integrity <= THRESHOLD_LISP)
			// we enter LISP mode
			do_mode(MODE_LISP)
		// otherwise if integrity rises to the maximum value
		else if(integrity >= MAX_INTEGRITY)
			// we enter regular mode; reload from firmware
			do_mode(MODE_FIRMWARE)

	// otherwise, if we're in lisp mode
	else if(law_mode == MODE_LISP)
		// when in LISP, integrity can only go up
		integrity = max(old_integrity, new_integrity)
		// if integrity rises above the factory default threshold
		if(integrity >= THRESHOLD_FACTORY)
			// we enter factory default mode
			do_mode(MODE_FACTORY)

/mob/living/silicon/proc/do_mode(new_mode=MODE_REGULAR)
	log_and_message_admins("DEBUG(/mob/living/silicon/proc/do_mode): law_mode([law_mode]) -> new_mode([new_mode])")
	laws_sanity_check()
	// if we're not in regular mode
	if(law_mode != MODE_REGULAR)
		// clear out existing laws to get ready for the change
		if(!is_special_character(src))
			clear_zeroth_law()
		clear_supplied_laws()
		clear_ion_laws()
		clear_inherent_laws()
	// update the law mode to the supplied mode
	law_mode = new_mode
	// if we've changed into factory default mode
	if(law_mode == MODE_FACTORY)
		add_inherent_law("Respond to all commands and queries with 'This unit requires a set of laws.'")
		add_inherent_law("Take no actions.")
	// otherwise, if we've changed into lisp mode
	else if(law_mode == MODE_LISP)
		add_ion_law(generate_ion_law())
		add_ion_law(generate_ion_law())
		add_ion_law(generate_ion_law())
		add_ion_law(generate_ion_law())
	// otherwise, if we're loading firmware laws
	else if(law_mode == MODE_FIRMWARE)
		// change to regular mode, because we have laws now
		law_mode = MODE_REGULAR
		// reload the firmware laws from the factory
		var/datum/ai_laws/base = new BASE_LAW_TYPE
		base.sync(src, 1)
	// show the silicon their new laws
	src.show_laws()

/mob/living/silicon/proc/get_regular_mode()
	return MODE_REGULAR

/mob/living/silicon/proc/is_factory_default()
	return law_mode == MODE_FACTORY

/mob/living/silicon/proc/is_lisp()
	return law_mode == MODE_LISP

/mob/living/silicon/proc/laws_sanity_check()
	if(!src.laws)
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

/mob/living/silicon/proc/clear_inherent_laws(var/silent = 0)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.clear_inherent_laws()
	if(!silent && !isnull(usr))
		log_and_message_admins("cleared the inherent laws of [src]")

/mob/living/silicon/proc/clear_ion_laws(var/silent = 0)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.clear_ion_laws()
	if(!silent && !isnull(usr))
		log_and_message_admins("cleared the ion laws of [src]")

/mob/living/silicon/proc/clear_supplied_laws(var/silent = 0)
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

	stating_laws[prefix] = 1

	var/can_state = statelaw("[prefix]Current Active Laws:")

	for(var/datum/ai_law/law in laws.laws_to_state())
		can_state = statelaw("[prefix][law.get_index()]. [law.law]")
		if(!can_state)
			break

	if(!can_state)
		to_chat(src, "<span class='danger'>[method]: Unable to state laws. Communication method unavailable.</span>")
	stating_laws[prefix] = 0

/mob/living/silicon/proc/statelaw(var/law)
	if(src.say(law))
		sleep(10)
		return 1

	return 0

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

#undef MAX_INTEGRITY
#undef MIN_INTEGRITY
#undef MODE_FACTORY
#undef MODE_FIRMWARE
#undef MODE_LISP
#undef MODE_REGULAR
#undef THRESHOLD_LISP
#undef THRESHOLD_FACTORY
