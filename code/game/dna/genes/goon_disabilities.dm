//////////////////
// DISABILITIES //
//////////////////

////////////////////////////////////////
// Totally Crippling
////////////////////////////////////////

////////////////////////////////////////
// Harmful to others as well as self
////////////////////////////////////////

/datum/dna/gene/disability/radioactive
	name = "Radioactive"
	desc = "The subject suffers from constant radiation sickness and causes the same on nearby organics."
	activation_message = "You feel a strange sickness permeate your whole body."
	deactivation_message = "You no longer feel awful and sick all over."
	instability = -GENE_INSTABILITY_MAJOR
	mutation = RADIOACTIVE

/datum/dna/gene/disability/radioactive/New()
	..()
	block = GLOB.radblock


/datum/dna/gene/disability/radioactive/can_activate(mob/M, flags)
	radiation_pulse(H, 20)

/datum/dna/gene/disability/radioactive/OnMobLife(mob/living/carbon/human/H)
	var/radiation_amount = abs(min(H.radiation - 20,0))
	H.apply_effect(radiation_amount, IRRADIATE)
	for(var/mob/living/L in range(1, H))
		if(L == H)
			continue
		to_chat(L, "<span class='danger'>You are enveloped by a soft green glow emanating from [H].</span>")
		L.apply_effect(5, IRRADIATE)

/datum/dna/gene/disability/radioactive/OnDrawUnderlays(mob/M, g)
	return "rads_s"

////////////////////////////////////////
// Other disabilities
////////////////////////////////////////

// WAS: /datum/bioEffect/unintelligable
/datum/dna/gene/disability/unintelligable
	name = "Unintelligable"
	desc = "Heavily corrupts the part of the brain responsible for forming spoken sentences."
	activation_message = "You can't seem to form any coherent thoughts!"
	deactivation_message = "Your mind feels more clear."
	instability = -GENE_INSTABILITY_MINOR
	mutation = SCRAMBLED

/datum/dna/gene/disability/unintelligable/New()
	..()
	block = GLOB.scrambleblock

/datum/dna/gene/disability/unintelligable/OnSay(mob/M, message)
	var/prefix = copytext(message,1,2)
	if(prefix == ";")
		message = copytext(message,2)
	else if(prefix in list(":","#"))
		prefix += copytext(message,2,3)
		message = copytext(message,3)
	else
		prefix=""

	var/list/words = splittext(message," ")
	var/list/rearranged = list()
	for(var/i=1;i<=words.len;i++)
		var/cword = pick(words)
		words.Remove(cword)
		var/suffix = copytext(cword,length(cword)-1,length(cword))
		while(length(cword)>0 && (suffix in list(".",",",";","!",":","?")))
			cword  = copytext(cword,1              ,length(cword)-1)
			suffix = copytext(cword,length(cword)-1,length(cword)  )
		if(length(cword))
			rearranged += cword
	return "[prefix][uppertext(jointext(rearranged," "))]!!"

//////////////////
// USELESS SHIT //
//////////////////

// WAS: /datum/bioEffect/strong
/datum/dna/gene/disability/strong
	// pretty sure this doesn't do jack shit, putting it here until it does
	name = "Strong"
	desc = "Enhances the subject's ability to build and retain heavy muscles."
	activation_message = "You feel buff!"
	deactivation_message = "You feel wimpy and weak."
	mutation = STRONG

/datum/dna/gene/disability/strong/New()
	..()
	block = GLOB.strongblock

/datum/dna/gene/disability/strong/activate(mob/M, connected, flags)
	..()
	M.resize = 1.25
	M.update_transform()
	if(M.move_resist == MOVE_FORCE_WEAK)
		M.move_resist = MOVE_FORCE_NORMAL
	else
		M.move_resist = MOVE_FORCE_STRONG

	if(M.pull_force == MOVE_FORCE_STRONG)
		M.pull_force = MOVE_FORCE_VERY_STRONG
	else if(M.pull_force == MOVE_FORCE_WEAK)
		M.pull_force = MOVE_FORCE_NORMAL
	else
		M.pull_force = MOVE_FORCE_STRONG

/datum/dna/gene/disability/strong/deactivate(mob/M, connected, flags)
	..()
	M.resize = 0.8
	M.update_transform()
	if(M.move_resist == MOVE_FORCE_NORMAL)
		M.move_resist = MOVE_FORCE_WEAK
	else
		M.move_resist = MOVE_FORCE_NORMAL

	if(M.pull_force == MOVE_FORCE_VERY_STRONG)
		M.pull_force = MOVE_FORCE_STRONG
	else if(M.pull_force == MOVE_FORCE_NORMAL)
		M.pull_force = MOVE_FORCE_WEAK
	else
		M.pull_force = MOVE_FORCE_NORMAL


// WAS: /datum/bioEffect/horns
/datum/dna/gene/disability/horns
	name = "Horns"
	desc = "Enables the growth of a compacted keratin formation on the subject's head."
	activation_message = "A pair of horns erupt from your head."
	deactivation_message = "Your horns crumble away into nothing."
	mutation = HORNS

/datum/dna/gene/disability/horns/New()
	..()
	block = GLOB.hornsblock

/datum/dna/gene/disability/horns/OnDrawUnderlays(mob/M, g)
	return "horns_s"
