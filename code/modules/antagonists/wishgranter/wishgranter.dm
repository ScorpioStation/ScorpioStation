/datum/antagonist/wishgranter
	name = "Wishgranter Avatar"

/datum/antagonist/wishgranter/proc/forge_objectives()
	var/datum/objective/hijack/hijack = new
	hijack.owner = owner
	objectives += hijack
	owner.objectives |= objectives

/datum/antagonist/wishgranter/on_gain()
	owner.special_role = "Avatar of the Wish Granter"
	forge_objectives()
	. = ..()
	give_powers()

/datum/antagonist/wishgranter/greet()
	to_chat(owner.current, "<B>Your inhibitions are swept away, the bonds of loyalty broken, you are free to murder as you please!</B>")
	owner.announce_objectives()

/datum/antagonist/wishgranter/proc/give_powers()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	H.ignore_gene_stability = TRUE
	H.dna.SetDNAState(GLOB.hulkblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.hulkblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.xrayblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.xrayblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.fireblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.fireblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.coldblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.coldblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.teleblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.teleblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.increaserunblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.increaserunblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.breathlessblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.breathlessblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.regenerateblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.regenerateblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.shockimmunityblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.shockimmunityblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.smallsizeblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.smallsizeblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.soberblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.soberblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.psyresistblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.psyresistblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.shadowblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.shadowblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.cryoblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.cryoblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.eatblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.eatblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.jumpblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.jumpblock, null, MUTCHK_FORCED)

	H.dna.SetDNAState(GLOB.immolateblock, TRUE, DNA_SE)
	genemutcheck(H, GLOB.immolateblock, null, MUTCHK_FORCED)

	H.mutations.Add(LASER)
	H.update_mutations()
	H.update_body()
