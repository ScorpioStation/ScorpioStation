/datum/species/wryn
	name = "Wryn"
	name_plural = "Wryn"
	icobase = 'icons/mob/human_races/r_wryn.dmi'
	deform = 'icons/mob/human_races/r_wryn.dmi'
	language = "Wryn Hivemind"
	tail = "wryntail"
	blurb = "The wryn (r-in, singular r-in) are a humanoid race that possess many bee-like features. Originating from Alveare they \
	have adapted extremely well to cold environments though have lost most of their muscles over generations.\
	In order to communicate and work with multi-species crew Wryn were forced to take on names. Wryn have tended towards using only \
	first names, these names are generally simplistic and easy to pronounce. Wryn have rarely had to communicate using their mouths, \
	so in order to integrate with the multi-species crew they have been taught broken sol?."

	cold_level_1 = 200 //Default 260 - Lower is better
	cold_level_2 = 150 //Default 200
	cold_level_3 = 115 //Default 120

	heat_level_1 = 320 //Default 360 - Higher is better
	heat_level_2 = 350 //Default 400
	heat_level_3 = 410 //Default 460 - Even Drask is 400

	body_temperature = 286

	has_organ = list(
		"heart" =    /obj/item/organ/internal/heart/wryn,
		"lungs" =    /obj/item/organ/internal/lungs/wryn,
		"kidneys" =  /obj/item/organ/internal/kidneys/wryn,
		"brain" =    /obj/item/organ/internal/brain/wryn,
		"appendix" = /obj/item/organ/internal/appendix,
		"eyes" =     /obj/item/organ/internal/eyes/wryn,	//3 darksight.
		"antennae" = /obj/item/organ/internal/wryn/hivenode
		)

	species_traits = list(HIVEMIND, IS_WHITELISTED, LIPS, NO_SCAN)
	clothing_flags = HAS_UNDERWEAR | HAS_UNDERSHIRT | HAS_SOCKS
	bodyflags = HAS_SKIN_COLOR | HAS_TAIL | HAS_WINGS
	dietflags = DIET_HERB		//bees feed off nectar, so bee people feed off plants too - okay, sure! :O

	reagent_tag = PROCESS_ORG
	base_color = "#704300"
	flesh_color = "#704300"
	blood_color = "#FFFF99"
	//Default styles for created mobs.
	default_hair = "Antennae"
	var/datum/action/innate/wryn_sting/wryn_sting = new /datum/action/innate/wryn_sting

/datum/species/wryn/on_species_gain(mob/living/carbon/human/H)
	..()
	wryn_sting = new
	wryn_sting.Grant(H)

/datum/species/wryn/on_species_loss(mob/living/carbon/human/H)
	..()
	if(wryn_sting)
		wryn_sting.Remove(H)

/* Wryn Sting Action Begin */
//Define the Sting Action
/datum/action/innate/wryn_sting
	name = "Wryn Sting"
	desc = "Readies Wryn Sting for stinging."
	button_icon_state = "wryn_sting_off"	//Default Button State
	check_flags = AB_CHECK_LYING | AB_CHECK_CONSCIOUS | AB_CHECK_STUNNED
	var/button_on = FALSE

//What happens when you click the Button?
/datum/action/innate/wryn_sting/Trigger()
	if(!..())
		return
	var/mob/living/carbon/user = owner
	if((user.restrained() && user.pulledby) || user.buckled) //Is your Wryn restrained, pulled, or buckled? No stinging!
		to_chat(user, "<span class='notice'>You need freedom of movement to sting someone!</span>")
		return
	if(istype(user.wear_suit, /obj/item/clothing/suit/space))	//Is your Wryn wearing a Hardsuit?
		to_chat(user, "<span class='notice'>You must remove your hardsuit your stinger.</span>")
		return
	if(user.getStaminaLoss() >= 55)	//Does your Wryn have enough Stamina to sting?
		to_chat(user, "<span class='notice'>You feel too tired to use your stinger at the moment.</span>")
		return
	else
		set_sting(user)

//Update the Button Icon
/datum/action/innate/wryn_sting/UpdateButtonIcon()
	if(button_on)
		button_icon_state = "wryn_sting_on"
		name = "Wryn Stinger \[READY\]"
		button.name = name
	else
		button_icon_state = "wryn_sting_off"
		name = "Wryn Stinger"
		button.name = name
	..()

//Select a Target with Middle Click or Alt-Click
/datum/action/innate/wryn_sting/proc/set_sting(mob/living/carbon/human/user)
	var/list/names = list()
	for(var/mob/living/carbon/human/M in orange(1))
		names += M
	if(!length(names))	//No one's around!
		return
	if(button_on == TRUE)
		unset_sting(user)
		return
	var/datum/middleClickOverride/callback_invoker/wrynclick_override
	button_on = TRUE
	UpdateButtonIcon()
	wrynclick_override = new /datum/middleClickOverride/callback_invoker(CALLBACK(src, .proc/sting_target))
	user.middleClickOverride = wrynclick_override
	to_chat(user, "<span class='notice'>You prepare to use your Wryn stinger. Use alt-click or middle mouse button on a target to sting them.</span>")
	return

/datum/action/innate/wryn_sting/proc/unset_sting(mob/living/carbon/human/user)
	to_chat(user, "<span class='notice'>You retract your Wryn stinger for now.</span>")
	button_on = FALSE
	UpdateButtonIcon()
	user.middleClickOverride = null

//What does the Wryn Sting do?
/datum/action/innate/wryn_sting/proc/sting_target(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!ishuman(target) || !(target in orange(1, user)))
		unset_sting(user)
		return
	else
		to_chat(user, "<span class='danger'>You sting [target] with your Wryn stinger!</span>")
		user.visible_message("<span class='danger'>[user] stings [target] with [user.p_their()] Wryn stinger! </span>")
		playsound(user.loc, 'sound/weapons/bladeslice.ogg', 50, 0)

		var/loss = rand(10, 25)

		var/uloss = min((55-user.getStaminaLoss()), loss)
		user.adjustStaminaLoss(uloss)	//Don't cause over 55 StaminaLoss to the user
		add_attack_logs(user, user, "Used Wryn Stinger on [target]: Lost [uloss] Stamina.")

		var/tloss = min((55-target.getStaminaLoss()), loss)
		target.adjustStaminaLoss(tloss)	//Don't cause over 55 StaminaLoss to the target
		add_attack_logs(user, target, "Stung by Wryn Stinger: Lost [tloss] Stamina.")

		if(target.restrained())	//Apply a little BURN damage if target is restrained
			if(prob(50))
				user.apply_damage(5, BURN, target)
				to_chat(target, "<span class='danger'>You feel a little burnt! Yowch!</span>")
				user.visible_message("<span class='danger'>[user] is looking a little burnt!</span>")
	unset_sting(user)
	return

/* Wryn Sting Action End */

/datum/species/wryn/handle_death(gibbed, mob/living/carbon/human/H)
	for(var/mob/living/carbon/C in GLOB.alive_mob_list)
		if(iswryn(C) &&  C.get_int_organ(/obj/item/organ/internal/wryn/hivenode))
			to_chat(C, "<span class='danger'><B>Your antennae tingle as you are overcome with pain...</B></span>")
