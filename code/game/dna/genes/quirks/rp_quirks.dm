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
