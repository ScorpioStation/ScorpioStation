/////////////////////
// QUIRK GENES
//
// These just chuck in a mutation and display a message.
//
// Gene is activated:
//  1. If mutation already exists in mob
//  2. If the probability roll succeeds
//  3. Activation is forced (done in domutcheck)
/////////////////////


/datum/dna/gene/quirk
	name = "QUIRK"
	gene_dna = DNA_RP
	var/value = 0							// Value of Points
	var/mutation = 0						// Mutation to give
	var/activation_prob = 100				// Activation probability
	var/list/activation_messages = list()	// Possible activation messages
	var/list/deactivation_messages = list()	// Possible deactivation messages

/datum/dna/gene/quirk/can_activate(mob/M, flags)
	return FALSE	//No, you cannot activate Quirks from inside a game-round

/datum/dna/gene/quirk/activate(mob/M, connected, flags)
	..()
	M.mutations |= mutation
	if(activation_message)
		to_chat(M, "<span class='warning'>[activation_message]</span>")
	else
		testing("[name] has no activation message.")

/datum/dna/gene/quirk/deactivate(mob/living/M, connected, flags)
	..()
	M.mutations.Remove(mutation)
	if(deactivation_message)
		to_chat(M, "<span class='warning'>[deactivation_message]</span>")
	else
		testing("[name] has no deactivation message.")

/*
 * Maluses
 * ported from Desert Rose 2
 */

//Aguesia (Inability to Taste)
/datum/dna/gene/quirk/no_taste
	name = "Ageusia"
	desc = "You can't taste anything! Toxic food will still poison you."
	value = -1
	mutation = AGEUSIA
	activation_message = "<span class='notice'>You can't taste anything!</span>"
	deactivation_message = "<span class='notice'>You can taste again!</span>"
	medical_record_text = "Patient suffers from ageusia and is incapable of tasting food or reagents."


/datum/dna/gene/quirk/no_taste/New()
	..()
	block = GLOB.ageusia_block

//Brain Problems
/datum/dna/gene/quirk/brainproblems
	name = "Brain Tumor"
	desc = "You have a little friend in your brain that is slowly destroying it. Better bring some mannitol!"
	value = -3
	mutation = BRAINPROBLEMS
	activation_message = "<span class='danger'>You feel smooth.</span>"
	deactivation_message = "<span class='notice'>You feel wrinkled again.</span>"
	medical_record_text = "Patient has a tumor in their brain that is slowly driving them to brain death."

/datum/dna/gene/quirk/brainproblems/OnMobLife(mob/living/carbon/human/H)
	H.adjustBrainLoss(0.05)

//Pacifist (Non-Violent)
/datum/dna/gene/quirk/nonviolent
	name = "Pacifist"
	desc = "The thought of violence makes you sick. So much so, in fact, that you can't hurt anyone."
	value = -3
	mutation = PACIFISM
	activation_message = "<span class='danger'>You feel repulsed by the thought of violence!</span>"
	deactivation_message = "<span class='notice'>You think you can defend yourself again.</span>"
	psych_record_text = "Patient is unusually pacifistic and cannot bring themselves to cause physical harm."

/datum/dna/gene/quirk/nonviolent/New()
	..()
	block = GLOB.pacificism_block

//Nyctophobia (Fear of the Dark)
/datum/dna/gene/quirk/nyctophobia
	name = "Nyctophobia"
	desc = "As far as you can remember, you've always been afraid of the dark. While in the dark without a light source, you instinctually act careful, and constantly feel a sense of dread."
	value = -2
	activation_message = "<span class='danger'>You feel incredibly afraid of dark places.</span>"
	deactivation_message = "<span class='notice'>You think you can handle the dark once more!</span>"
	psych_record_text = "Patient might experience fear of the dark."


/datum/dna/gene/quirk/nyctophobia/OnMobLife(mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/turf/T = get_turf(H)
	var/lums = T.get_lumcount()
	if(lums <= 0.2)
		if(H.m_intent == MOVE_INTENT_RUN)
			to_chat(H, "<span class='warning'>Easy, easy, take it slow... you're in the dark...</span>")
			H.toggle_move_intent(MOVE_INTENT_WALK)

//Poor Aim
/datum/dna/gene/quirk/poor_aim
	name = "Poor Aim"
	desc = "You're terrible with guns and can't line up a straight shot to save your life. Dual-wielding is right out."
	value = -1
	mob_trait = POOR_AIM
	medical_record_text = "Patient possesses a strong tremor in both hands."

/datum/dna/gene/quirk/poor_aim/New()
	..()
	block = GLOB.pooraim_block

//Social Anxiety
/datum/dna/gene/quirk/social_anxiety
	name = "Social Anxiety"
	desc = "Talking to people is very difficult for you, and you often stutter or even lock up."
	value = -2
	activation_message = "<span class='danger'>You start worrying about what you're saying.</span>"
	deactivation_message = "<span class='notice'>You feel easier about talking again.</span>" //if only it were that easy!
	psych_record_text = "Patient is usually anxious in social encounters and prefers to avoid them."
	var/dumb_thing = TRUE

/datum/dna/gene/quirk/social_anxiety/OnMobLife(mob/living/carbon/human/H)
	var/nearby_people = 0
	for(var/P in view(5, H))
		if(iscarbon(P) && P.client)
			nearby_people++
	if(prob(2 + nearby_people))
		H.stuttering = max(3, H.stuttering)
	else if(prob(min(3, nearby_people)) && !H.silent)
		to_chat(H, "<span class='danger'>You retreat into yourself. You <i>really</i> don't feel up to talking.</span>")
		H.silent = max(10, H.silent)
	else if(prob(0.5) && dumb_thing)
		to_chat(H, "<span class='userdanger'>You think of a dumb thing you said a long time ago and scream internally.</span>")
		dumb_thing = FALSE
	if(!dumb_thing)
		if(prob(0.05))
			dumb_thing = TRUE

/*
 * Boons
 * ported from Desert Rose 2
 */

//Alcohol Tolerancec
/datum/dna/gene/quirk/alcohol_tolerance
	name = "Alcohol Tolerance"
	desc = "You become drunk more slowly and suffer fewer drawbacks from alcohol."
	value = 1
	mutation = ALCOHOL_TOLERANCE
	activation_message = "<span class='notice'>You feel like you could drink a whole keg!</span>"
	deactivation_message = "<span class='danger'>You don't feel as resistant to alcohol anymore. Somehow.</span>"

/datum/dna/gene/quirk/alcohol_tolerance/New()
	..()
	block = GLOB.happyliver_block

//Deep Breaths (OxyLoss Reduction)
/datum/dna/gene/quirk/deep_breaths
	name = "Deep Breaths"
	desc = "You employ deep breathing in your daily activities. Gain a 15% reduction to OxyLoss damage."
	value = 3
	mutation = DEEP_BREATHS
	activation_message = {"<br><span class='notice'>In through the nose.</span>
				<br><span class='notice'>And out through the mouth.</span>"}
	deactivation_message = "<span class='danger'>Your breathing feels shallower than before.</span>"

/datum/dna/gene/quirk/deep_breaths/New()
	..()
	block = GLOB.deepbreaths_block

//Light Step (Silent Footsteps)
/datum/dna/gene/quirk/light_step
	name = "Light Step"
	desc = "You walk with a gentle step, making your footsteps much quieter."
	value = 1
	mutation = LIGHT_STEP
	activation_message = "<span class='notice'>You walk with a little more litheness.</span>"
	deactivation_message = "<span class='danger'>You start tromping around like a barbarian.</span>"

/datum/dna/gene/quirk/light_step/New()
	..()
	block = GLOB.lightsteps_block

//Self-Aware (See Types of Damage on Self)
/datum/dna/gene/quirk/self_aware
	name = "Self-Aware"
	desc = "You know your body well, and can accurately assess the extent of your wounds."
	value = 2
	mutation = SELF_AWARE

/datum/dna/gene/quirk/self_aware/New()
	..()
	block = GLOB.deepbreaths_block

//Skitish (Quickly Hide in Lockers)
/datum/dna/gene/quirk/skittish
	name = "Skittish"
	desc = "You can conceal yourself in danger. Ctrl-Shift click a closed locker to jump into it, as long as you have access."
	value = 1
	mutation = SKITTISH
	psych_record_text = "Patient presents with a skittish affect."

/datum/dna/gene/quirk/skittish/New()
	..()
	block = GLOB.skittish_block

//Voracious (Eat Twice as Quickly)
/datum/dna/gene/quirk/voracious
	name = "Voracious"
	desc = "Nothing gets between you and your food. You eat twice as fast as everyone else!"
	value = 1
	mutation = VORACIOUS
	activation_message = "<span class='notice'>You feel like you could eat a space horse.</span>"
	deactivation_message = "<span class='danger'>You no longer feel HONGRY.</span>"
	psych_record_text = "Patient seems to use eating as a coping strategy for stress."

/datum/dna/gene/quirk/voracious/New()
	..()
	block = GLOB.voracious_block
