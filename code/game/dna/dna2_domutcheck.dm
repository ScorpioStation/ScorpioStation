// (Re-)Apply mutations.
// TODO: Turn into a /mob proc, change inj to a bitflag for various forms of differing behavior.
// M: Mob to mess with
// connected: Machine we're in, type unchecked so I doubt it's used beyond monkeying
// flags: See below, bitfield.
/proc/domutcheck(mob/living/M, connected = null, flags = 0)
	if(!M || !M.dna)
		return
	for(var/thing in GLOB.all_dna_genes)
		var/datum/dna/gene/G = thing
		if(!G.block)
			continue
		var/dna_type = G.gene_dna
		domutation(G, M, connected, flags, dna_type)

// Use this to force a mut check on a single gene!
/proc/genemutcheck(mob/living/M, block, connected = null, flags = 0)
	if(ishuman(M)) // Would've done this via species instead of type, but the basic mob doesn't have a species, go figure.
		var/mob/living/carbon/human/H = M
		if(NO_DNA in H.dna.species.species_traits)
			return
	if(!M || block < 0)
		return
	var/datum/dna/gene/gene = GLOB.randomized_SE_blocks[block]
	domutation(gene, M, connected, flags)

/proc/domutation(datum/dna/gene/gene, mob/living/M, connected = null, flags = 0, dna_type = DNA_SE)
	if(!gene || !istype(gene))
		return FALSE

	var/gene_active		// Current state
	if(dna_type == DNA_SE)
		gene_active = M.dna.GetDNAState(gene.block, DNA_SE)
	else if(dna_type == DNA_RP)
		gene_active = M.dna.GetDNAState(gene.block, DNA_RP)

	// Sanity checks, don't skip.
	if(!gene.can_activate(M,flags) && gene_active)
		//testing("[M] - Failed to activate [gene.name] (can_activate fail).")
		return FALSE

	var/defaultgenes // Do not mutate inherent species abilities
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		defaultgenes = H.dna.species.default_genes

		if((gene in defaultgenes) && gene_active)
			return

	var/gene_prior_status = (gene.type in M.active_genes)		// Prior state
	var/changed = gene_active != gene_prior_status

	// If gene state has changed:
	if(changed)
		// Gene active (or ALWAYS ACTIVATE)
		if(gene_active)
			//testing("[gene.name] activated!")
			gene.activate(M,connected,flags)
			if(M)
				M.active_genes |= gene.type
		// If Gene is NOT active:
		else
			//testing("[gene.name] deactivated!")
			gene.deactivate(M,connected,flags)
			if(M)
				M.active_genes -= gene.type
