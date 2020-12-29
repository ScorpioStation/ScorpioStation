/////////////////////
// DISABILITY GENES
//
// These activate either a mutation, disability
//
// Gene is always activated.
/////////////////////

#define string2charlist(string) (splittext(string, regex("(\\x0A|.)")) - splittext(string, ""))

/datum/dna/gene/disability
	name = "DISABILITY"
	gene_dna = DNA_SE					// Most of these Disabilities are on DNA_SE
	var/mutation = 0					// Mutation to give (or 0)
	var/activation_message = ""			// Activation message
	var/deactivation_message = ""		// Yay, you're no longer growing 3 arms
	var/curable	= TRUE					// Can this Disability be cured?

/datum/dna/gene/disability/can_activate(mob/M, flags)
	return TRUE // Always set!

/datum/dna/gene/disability/activate(mob/living/M, connected, flags)
	..()
	M.mutations |= mutation
	if(activation_message)
		to_chat(M, "<span class='warning'>[activation_message]</span>")
	else
		testing("[name] has no activation message.")

/datum/dna/gene/disability/deactivate(mob/living/M, connected, flags)
	..()
	M.mutations.Remove(mutation)
	if(deactivation_message)
		to_chat(M, "<span class='warning'>[deactivation_message]</span>")
	else
		testing("[name] has no deactivation message.")

/*
 Preference Disabilities
*/

//Clumsy
/datum/dna/gene/disability/clumsy
	name = "Clumsiness"
	activation_message = "You feel lightheaded."
	deactivation_message = "You regain some control of your movements"
	instability = -GENE_INSTABILITY_MINOR
	mutation = CLUMSY

/datum/dna/gene/disability/clumsy/New()
	..()
	block = GLOB.clumsyblock

//Blindness, Blind
/datum/dna/gene/disability/blindness
	name = "Blindness"
	activation_message = "You can't seem to see anything."
	deactivation_message = "You can see now, in case you didn't notice..."
	instability = -GENE_INSTABILITY_MAJOR
	mutation = BLINDNESS

/datum/dna/gene/disability/blindness/New()
	..()
	block = GLOB.blindblock


/datum/dna/gene/disability/blindness/activate(mob/M, connected, flags)
	..()
	M.update_blind_effects()

/datum/dna/gene/disability/blindness/deactivate(mob/M, connected, flags)
	..()
	M.update_blind_effects()

//Colourblindness
/datum/dna/gene/disability/colourblindness
	name = "Colourblindness"
	activation_message = "You feel a peculiar prickling in your eyes while your perception of colour changes."
	deactivation_message ="Your eyes tingle unsettlingly, though everything seems to become alot more colourful."
	instability = -GENE_INSTABILITY_MODERATE
	mutation = COLOURBLIND

/datum/dna/gene/disability/colourblindness/New()
	..()
	block = GLOB.colourblindblock


/datum/dna/gene/disability/colourblindness/activate(mob/M, connected, flags)
	..()
	M.update_client_colour() //Handle the activation of the colourblindness on the mob.
	M.update_icons() //Apply eyeshine as needed.

/datum/dna/gene/disability/colourblindness/deactivate(mob/M, connected, flags)
	..()
	M.update_client_colour() //Handle the deactivation of the colourblindness on the mob.
	M.update_icons() //Remove eyeshine as needed.

//Deafness, Deaf
/datum/dna/gene/disability/deaf
	name = "Deafness"
	activation_message="It's kinda quiet."
	deactivation_message ="You can hear again!"
	instability = -GENE_INSTABILITY_MAJOR
	mutation = DEAF

/datum/dna/gene/disability/deaf/New()
	..()
	block = GLOB.deafblock


/datum/dna/gene/disability/deaf/activate(mob/M, connected, flags)
	..()
	M.MinimumDeafTicks(1)

//Nearsighted, Nearsightedness
/datum/dna/gene/disability/nearsighted
	name = "Nearsightedness"
	activation_message="Your eyes feel weird..."
	deactivation_message ="You can see clearly now"
	instability = -GENE_INSTABILITY_MODERATE
	mutation = NEARSIGHTED

/datum/dna/gene/disability/nearsighted/New()
	..()
	block = GLOB.glassesblock

/datum/dna/gene/disability/nearsighted/activate(mob/living/M, connected, flags)
	..()
	M.update_nearsighted_effects()

/datum/dna/gene/disability/nearsighted/deactivate(mob/living/M, connected, flags)
	..()
	M.update_nearsighted_effects()


//Obesity, Fat
/datum/dna/gene/disability/fat
	name = "Obesity"
	desc = "Greatly slows the subject's metabolism, enabling greater buildup of lipid tissue."
	activation_message = "You feel blubbery and lethargic!"
	deactivation_message = "You feel fit!"
	instability = -GENE_INSTABILITY_MINOR
	mutation = OBESITY

/datum/dna/gene/disability/fat/New()
	..()
	block = GLOB.fatblock

/*
 Language
*/

//Lisp
/datum/dna/gene/disability/lisp
	name = "Lisp"
	desc = "I wonder wath thith doeth."
	activation_message = "Thomething doethn't feel right."
	deactivation_message = "You now feel able to pronounce consonants."
	mutation = LISP

/datum/dna/gene/disability/lisp/New()
	..()
	block = GLOB.lispblock

/datum/dna/gene/disability/lisp/OnSay(mob/M, message)
	return replacetext(message,"s","th")

//Scorpio RP Stutter
/datum/dna/gene/disability/rpstutter
	name = "RPSTUTTER"
	activation_message = ""
	deactivation_message = ""
	mutation = RPSTUTTER
	gene_dna = DNA_RP

/datum/dna/gene/disability/rpstutter/New()
	..()
	block = GLOB.rp_stutterblock

/datum/dna/gene/disability/rpstutter/OnMobLife(mob/living/carbon/human/H)
	if(prob(10))
		H.Stuttering(10)

//Nervousness, Nervous, Stutter
/datum/dna/gene/disability/nervousness
	name = "Nervousness"
	activation_message="You feel nervous."
	deactivation_message ="You feel much calmer."
	mutation = NERVOUS

/datum/dna/gene/disability/nervousness/New()
	..()
	block = GLOB.nervousblock

/datum/dna/gene/disability/nervousness/OnMobLife(mob/living/carbon/human/H)
	if(prob(10))
		H.Stuttering(10)

//Mute
/datum/dna/gene/disability/mute
	name = "Mute"
	desc = "Completely shuts down the speech center of the subject's brain."
	activation_message   = "You feel unable to express yourself at all."
	deactivation_message = "You feel able to speak freely again."
	instability = -GENE_INSTABILITY_MODERATE
	mutation = MUTE
	curable = TRUE

/datum/dna/gene/disability/mute/New()
	..()
	block = GLOB.muteblock


/datum/dna/gene/disability/mute/OnSay(mob/M, message)
	return ""

//Chav
/datum/dna/gene/disability/speech/chav
	name = "Chav"
	desc = "Forces the language center of the subject's brain to construct sentences in a more rudimentary manner."
	activation_message = "Ye feel like a reet prat like, innit?"
	deactivation_message = "You no longer feel like being rude and sassy."
	mutation = CHAV

/datum/dna/gene/disability/speech/chav/New()
	..()
	block = GLOB.chavblock

/datum/dna/gene/disability/speech/chav/OnSay(mob/M, message)
	// THIS ENTIRE THING BEGS FOR REGEX
	message = replacetext(message,"dick","prat")
	message = replacetext(message,"comdom","knob'ead")
	message = replacetext(message,"looking at","gawpin' at")
	message = replacetext(message,"great","bangin'")
	message = replacetext(message,"man","mate")
	message = replacetext(message,"friend",pick("mate","bruv","bledrin"))
	message = replacetext(message,"what","wot")
	message = replacetext(message,"drink","wet")
	message = replacetext(message,"get","giz")
	message = replacetext(message,"what","wot")
	message = replacetext(message,"no thanks","wuddent fukken do one")
	message = replacetext(message,"i don't know","wot mate")
	message = replacetext(message,"no","naw")
	message = replacetext(message,"robust","chin")
	message = replacetext(message," hi ","how what how")
	message = replacetext(message,"hello","sup bruv")
	message = replacetext(message,"kill","bang")
	message = replacetext(message,"murder","bang")
	message = replacetext(message,"windows","windies")
	message = replacetext(message,"window","windy")
	message = replacetext(message,"break","do")
	message = replacetext(message,"your","yer")
	message = replacetext(message,"security","coppers")
	return message

//Swedish
/datum/dna/gene/disability/speech/swedish
	name = "Swedish"
	desc = "Forces the language center of the subject's brain to construct sentences in a vaguely norse manner."
	activation_message = "You feel Swedish, however that works."
	deactivation_message = "The feeling of Swedishness passes."
	mutation = SWEDISH

/datum/dna/gene/disability/speech/swedish/New()
	..()
	block = GLOB.swedeblock

/datum/dna/gene/disability/speech/swedish/OnSay(mob/M, message)
	// svedish
	message = replacetextEx(message,"W","V")
	message = replacetextEx(message,"w","v")
	message = replacetextEx(message,"J","Y")
	message = replacetextEx(message,"j","y")
	message = replacetextEx(message,"A",pick("Å","Ä","Æ","A"))
	message = replacetextEx(message,"a",pick("å","ä","æ","a"))
	message = replacetextEx(message,"BO","BJO")
	message = replacetextEx(message,"Bo","Bjo")
	message = replacetextEx(message,"bo","bjo")
	message = replacetextEx(message,"O",pick("Ö","Ø","O"))
	message = replacetextEx(message,"o",pick("ö","ø","o"))
	if(prob(30) && !M.is_muzzled())
		message += " Bork[pick("",", bork",", bork, bork")]!"
	return message

//Wingdings
/datum/dna/gene/disability/wingdings
	name = "Grey Speech"
	desc = "Garbles the subject's voice into an incomprehensible speech."
	activation_message = "<span class='wingdings'>Your vocal cords feel alien.</span>"
	deactivation_message = "Your vocal cords no longer feel alien."
	instability = -GENE_INSTABILITY_MINOR
	mutation = WINGDINGS

/datum/dna/gene/disability/wingdings/New()
	..()
	block = GLOB.wingdingsblock

/datum/dna/gene/disability/wingdings/OnSay(mob/M, message)
	var/garbled_message = ""
	for(var/i in 1 to length(message))
		if(message[i] in GLOB.alphabet_uppercase)
			garbled_message += pick(GLOB.alphabet_uppercase)
		else if(message[i] in GLOB.alphabet)
			garbled_message += pick(GLOB.alphabet)
		else
			garbled_message += message[i]
	message = garbled_message
	return message

/*
 Mutation-Only Disabilities
*/
/datum/dna/gene/disability/comic
	name = "Comic"
	desc = "This will only bring death and destruction."
	activation_message = "<span class='sans'>Uh oh!</span>"
	deactivation_message = "Well thank god that's over with."
	mutation = COMIC

/datum/dna/gene/disability/comic/New()
	..()
	block = GLOB.comicblock

//Hallucinate
/datum/dna/gene/disability/hallucinate
	name = "Hallucinate"
	activation_message = "Your mind says 'Hello'."
	deactivation_message = "Sanity returns. Or does it?"
	instability = -GENE_INSTABILITY_MODERATE
	mutation = HALLUCINATE

/datum/dna/gene/disability/hallucinate/New()
	..()
	block = GLOB.hallucinationblock

/datum/dna/gene/disability/hallucinate/OnMobLife(mob/living/carbon/human/H)
	if(prob(1))
		H.AdjustHallucinate(45)

//Epilepsy
/datum/dna/gene/disability/epilepsy
	name = "Epilepsy"
	activation_message = "You get a headache."
	deactivation_message = "Your headache is gone, at last."
	instability = -GENE_INSTABILITY_MODERATE
	mutation = EPILEPSY

/datum/dna/gene/disability/epilepsy/New()
	..()
	block = GLOB.epilepsyblock

/datum/dna/gene/disability/epilepsy/OnMobLife(mob/living/carbon/human/H)
	if((prob(1) && H.paralysis < 1))
		H.visible_message("<span class='danger'>[H] starts having a seizure!</span>","<span class='alert'>You have a seizure!</span>")
		H.Paralyse(10)
		H.Jitter(1000)
//Cough
/datum/dna/gene/disability/cough
	name = "Coughing"
	activation_message = "You start coughing."
	deactivation_message = "Your throat stops aching."
	instability = -GENE_INSTABILITY_MINOR
	mutation = COUGHING

/datum/dna/gene/disability/cough/New()
	..()
	block = GLOB.coughblock

/datum/dna/gene/disability/cough/OnMobLife(mob/living/carbon/human/H)
	if((prob(5) && H.paralysis <= 1))
		H.drop_item()
		H.emote("cough")
//Tourettes
/datum/dna/gene/disability/tourettes
	name = "Tourettes"
	activation_message = "You twitch."
	deactivation_message = "Your mouth tastes like soap."
	instability = -GENE_INSTABILITY_MODERATE
	mutation = TOURETTES

/datum/dna/gene/disability/tourettes/New()
	..()
	block = GLOB.twitchblock

/datum/dna/gene/disability/tourettes/OnMobLife(mob/living/carbon/human/H)
	if((prob(10) && H.paralysis <= 1))
		H.Stun(10)
		switch(rand(1, 3))
			if(1)
				H.emote("twitch")
			if(2 to 3)
				H.say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK ME SIDEWAYS", "VULVA VIBRATING A VENEZULEAN VUVUZELA", "PREHENSILE PENISES", "MOTHERFUCKER", "TITS")]")
		var/x_offset_old = H.pixel_x
		var/y_offset_old = H.pixel_y
		var/x_offset = H.pixel_x + rand(-2, 2)
		var/y_offset = H.pixel_y + rand(-1, 1)
		animate(H, pixel_x = x_offset, pixel_y = y_offset, time = 1)
		animate(H, pixel_x = x_offset_old, pixel_y = y_offset_old, time = 1)



#undef string2charlist
