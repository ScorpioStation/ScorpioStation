/proc/getAssignedBlock(var/name, var/list/blocksLeft, var/activity_bounds=DNA_DEFAULT_BOUNDS, var/good = FALSE)
	if(blocksLeft.len == 0)
		warning("[name]: No more blocks left to assign!")
		return FALSE
	var/assigned = pick(blocksLeft)
	blocksLeft.Remove(assigned)
	if(good)
		GLOB.good_blocks += assigned
	else
		GLOB.bad_blocks += assigned
	GLOB.assigned_SE_blocks[assigned] = name
	GLOB.dna_activity_bounds[assigned] = activity_bounds
	//Debug message_admins("[name] assigned to block #[assigned].")
//	testing("[name] assigned to block #[assigned].")
	return assigned

/proc/setupgenetics()

	if(prob(50))
		GLOB.blockadd = rand(-300, 300)
	if(prob(75))
		GLOB.diffmut = rand(0, 20)


//Thanks to nexis for the fancy code
// BITCH I AIN'T DONE YET

	// SE blocks to assign.
	var/list/numsToAssign = new()
	for(var/i = 1; i < DNA_SE_LENGTH ; i++)
		numsToAssign += i

	// Disabilities
	GLOB.glassesblock       = getAssignedBlock("GLASSES",       numsToAssign)
	GLOB.colourblindblock   = getAssignedBlock("COLOURBLIND",   numsToAssign)
	GLOB.blindblock         = getAssignedBlock("BLINDNESS",     numsToAssign)
	GLOB.deafblock          = getAssignedBlock("DEAF",          numsToAssign)
	GLOB.muteblock          = getAssignedBlock("MUTE",          numsToAssign)
	GLOB.fatblock           = getAssignedBlock("FAT",           numsToAssign)
	GLOB.swedeblock         = getAssignedBlock("SWEDE",         numsToAssign)
	GLOB.chavblock          = getAssignedBlock("CHAV",          numsToAssign)
	GLOB.lispblock          = getAssignedBlock("LISP",          numsToAssign)
	GLOB.clumsyblock        = getAssignedBlock("CLUMSY",        numsToAssign)

	// Standard muts
	GLOB.hulkblock          = getAssignedBlock("HULK",          numsToAssign, DNA_HARD_BOUNDS, good = TRUE)
	GLOB.teleblock          = getAssignedBlock("TELE",          numsToAssign, DNA_HARD_BOUNDS, good = TRUE)
	GLOB.fireblock          = getAssignedBlock("FIRE",          numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)
	GLOB.xrayblock          = getAssignedBlock("XRAY",          numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)
	GLOB.fakeblock          = getAssignedBlock("FAKE",          numsToAssign)
	GLOB.coughblock         = getAssignedBlock("COUGH",         numsToAssign)
	GLOB.epilepsyblock      = getAssignedBlock("EPILEPSY",      numsToAssign)
	GLOB.twitchblock        = getAssignedBlock("TWITCH",        numsToAssign)
	GLOB.nervousblock       = getAssignedBlock("NERVOUS",       numsToAssign)
	GLOB.wingdingsblock     = getAssignedBlock("WINGDINGS",     numsToAssign)

	// Bay muts
	GLOB.breathlessblock    = getAssignedBlock("BREATHLESS",    numsToAssign, DNA_HARD_BOUNDS, good = TRUE)
	GLOB.remoteviewblock    = getAssignedBlock("REMOTEVIEW",    numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)
	GLOB.regenerateblock    = getAssignedBlock("REGENERATE",    numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)
	GLOB.increaserunblock   = getAssignedBlock("INCREASERUN",   numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)
	GLOB.remotetalkblock    = getAssignedBlock("REMOTETALK",    numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)
	GLOB.morphblock         = getAssignedBlock("MORPH",         numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)
	GLOB.coldblock          = getAssignedBlock("COLD",          numsToAssign, good = TRUE)
	GLOB.hallucinationblock = getAssignedBlock("HALLUCINATION", numsToAssign)
	GLOB.noprintsblock      = getAssignedBlock("NOPRINTS",      numsToAssign, DNA_HARD_BOUNDS, good = TRUE)
	GLOB.shockimmunityblock = getAssignedBlock("SHOCKIMMUNITY", numsToAssign, good = TRUE)
	GLOB.smallsizeblock     = getAssignedBlock("SMALLSIZE",     numsToAssign, DNA_HARD_BOUNDS, good = TRUE)

	//
	// Goon muts
	/////////////////////////////////////////////

	// Disabilities
	GLOB.radblock       = getAssignedBlock("RAD",        numsToAssign)
	GLOB.scrambleblock  = getAssignedBlock("SCRAMBLE",   numsToAssign)
	GLOB.strongblock    = getAssignedBlock("STRONG",     numsToAssign, good = TRUE)
	GLOB.hornsblock     = getAssignedBlock("HORNS",      numsToAssign)
	GLOB.comicblock     = getAssignedBlock("COMIC",      numsToAssign)

	// Powers
	GLOB.soberblock     = getAssignedBlock("SOBER",      numsToAssign, good = TRUE)
	GLOB.psyresistblock = getAssignedBlock("PSYRESIST",  numsToAssign, DNA_HARD_BOUNDS, good = TRUE)
	GLOB.shadowblock    = getAssignedBlock("SHADOW",     numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)
	GLOB.chameleonblock = getAssignedBlock("CHAMELEON",  numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)
	GLOB.cryoblock      = getAssignedBlock("CRYO",       numsToAssign, DNA_HARD_BOUNDS, good = TRUE)
	GLOB.eatblock       = getAssignedBlock("EAT",        numsToAssign, DNA_HARD_BOUNDS, good = TRUE)
	GLOB.jumpblock      = getAssignedBlock("JUMP",       numsToAssign, DNA_HARD_BOUNDS, good = TRUE)
	GLOB.immolateblock  = getAssignedBlock("IMMOLATE",   numsToAssign)
	GLOB.empathblock    = getAssignedBlock("EMPATH",     numsToAssign, DNA_HARD_BOUNDS, good = TRUE)
	GLOB.polymorphblock = getAssignedBlock("POLYMORPH",  numsToAssign, DNA_HARDER_BOUNDS, good = TRUE)

	//
	// /vg/ Blocks
	/////////////////////////////////////////////

	// Disabilities
	GLOB.loudblock      = getAssignedBlock("LOUD",       numsToAssign)
	GLOB.dizzyblock     = getAssignedBlock("DIZZY",      numsToAssign)


	//
	// Static Blocks
	/////////////////////////////////////////////.

	// Monkeyblock is always last.
	GLOB.monkeyblock = DNA_SE_LENGTH

	//Scorpio RP Genes to assign
	GLOB.rp_stutterblock = 1	//The position of the rp_stutterblock in the DNA_RP list is 1!

	// And the genes that actually do the work. (domutcheck improvements)
	var/list/blocks_assigned[DNA_SE_LENGTH]
	for(var/gene_type in typesof(/datum/dna/gene))
		var/datum/dna/gene/G = new gene_type
		if(G.block)	//Ultimately, this checks to see if it's a gene used in Structural Enzymes or in Roleplaying Preferences since no other Genes should have Blocks. Please don't give blocks to other Genes.
			if(G.block in blocks_assigned)
				warning("DNA2: Gene [G.name] trying to use already-assigned block [G.block] (used by [english_list(blocks_assigned[G.block])])")
			if(G.gene_dna == DNA_SE)	//Now we're thinking with DNA Type!
				GLOB.struc_enzy_genes.Add(G)
				var/list/assignedToBlock[0]
				if(blocks_assigned[G.block])
					assignedToBlock = blocks_assigned[G.block]
				assignedToBlock.Add(G.name)
				blocks_assigned[G.block] = assignedToBlock
			else if(G.gene_dna == DNA_RP)
				GLOB.roleplay_genes.Add(G)
			GLOB.all_dna_genes.Add(G)

	// I WILL HAVE A LIST OF GENES THAT MATCHES THE RANDOMIZED BLOCKS GODDAMNIT!
	for(var/block=1 ; block <= DNA_SE_LENGTH ; block++)
		var/name = GLOB.assigned_SE_blocks[block]
		for(var/datum/dna/gene/gene in GLOB.struc_enzy_genes)
			if(gene.name == name || gene.block == block)
				if(gene.block in GLOB.randomized_SE_blocks)
					warning("DNA2: Gene [gene.name] trying to add to already assigned gene block list (used by [english_list(GLOB.randomized_SE_blocks[block])])")
				GLOB.randomized_SE_blocks[block] = gene


/proc/setupcult()
	var/static/datum/cult_info/picked_cult // Only needs to get picked once

	if(picked_cult)
		return picked_cult

	var/random_cult = pick(typesof(/datum/cult_info))
	picked_cult = new random_cult()

	if(!picked_cult)
		log_runtime(EXCEPTION("Cult datum creation failed"))
	//todo:add adminonly datum var, check for said var here...
	return picked_cult
