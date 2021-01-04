var/list/fusion_reactions

/obj/effect/decal/fusion_reaction
	var/p_react = "" // Primary reactant.
	var/s_react = "" // Secondary reactant.
	var/minimum_energy_level = 1
	var/energy_consumption = 0
	var/energy_production = 0
	var/radiation = 0
	var/instability = 0
	var/list/products = list()
	var/minimum_reaction_temperature = 100
	var/priority = 100

/obj/effect/decal/fusion_reaction/proc/handle_reaction_special(var/obj/effect/fusion_em_field/holder)
	return 0

proc/get_fusion_reaction(var/p_react, var/s_react, var/m_energy)
	if(!fusion_reactions)
		fusion_reactions = list()
		for(var/rtype in typesof(/obj/effect/decal/fusion_reaction) - /obj/effect/decal/fusion_reaction)
			var/obj/effect/decal/fusion_reaction/cur_reaction = new rtype()
			if(!fusion_reactions[cur_reaction.p_react])
				fusion_reactions[cur_reaction.p_react] = list()
			fusion_reactions[cur_reaction.p_react][cur_reaction.s_react] = cur_reaction
			if(!fusion_reactions[cur_reaction.s_react])
				fusion_reactions[cur_reaction.s_react] = list()
			fusion_reactions[cur_reaction.s_react][cur_reaction.p_react] = cur_reaction

	if(fusion_reactions.Find(p_react))
		var/list/secondary_reactions = fusion_reactions[p_react]
		if(secondary_reactions.Find(s_react))
			return fusion_reactions[p_react][s_react]

// Material fuels
//  deuterium
//  tritium
//  phoron
//  supermatter

// Gaseous/reagent fuels
//  hydrogen
//  helium
//  lithium
//  boron

// Basic power production reactions.
// This is not necessarily realistic, but it makes a basic failure more spectacular.
/obj/effect/decal/fusion_reaction/hydrogen_hydrogen
	p_react = GAS_HYDROGEN
	s_react = GAS_HYDROGEN
	energy_consumption = 1
	energy_production = 2
	products = list(GAS_HELIUM = 1)
	priority = 10

/obj/effect/decal/fusion_reaction/deuterium_deuterium
	p_react = GAS_DEUTERIUM
	s_react = GAS_DEUTERIUM
	energy_consumption = 1
	energy_production = 2
	priority = 0

// Advanced production reactions (todo)
/obj/effect/decal/fusion_reaction/deuterium_helium
	p_react = GAS_DEUTERIUM
	s_react = GAS_HELIUM
	energy_consumption = 1
	energy_production = 5
	radiation = 2

/obj/effect/decal/fusion_reaction/deuterium_tritium
	p_react = GAS_DEUTERIUM
	s_react = GAS_TRITIUM
	energy_consumption = 1
	energy_production = 1
	products = list(GAS_HELIUM = 1)
	instability = 0.5
	radiation = 3

/obj/effect/decal/fusion_reaction/deuterium_lithium
	p_react = GAS_DEUTERIUM
	s_react = "lithium"
	energy_consumption = 2
	energy_production = 0
	radiation = 3
	products = list(GAS_TRITIUM = 1)
	instability = 1

// Unideal/material production reactions
/obj/effect/decal/fusion_reaction/oxygen_oxygen
	p_react = GAS_OXYGEN
	s_react = GAS_OXYGEN
	energy_consumption = 10
	energy_production = 0
	instability = 5
	radiation = 5
	products = list("silicon"= 1)

/obj/effect/decal/fusion_reaction/iron_iron
	p_react = "iron"
	s_react = "iron"
	products = list("silver" = 10, "gold" = 10, "platinum" = 10) // Not realistic but w/e
	energy_consumption = 10
	energy_production = 0
	instability = 2
	minimum_reaction_temperature = 10000

/obj/effect/decal/fusion_reaction/phoron_hydrogen
	p_react = GAS_HYDROGEN
	s_react = GAS_PHORON
	energy_consumption = 10
	energy_production = 0
	instability = 5
	products = list("mhydrogen" = 1)
	minimum_reaction_temperature = 8000

// VERY UNIDEAL REACTIONS.
/obj/effect/decal/fusion_reaction/phoron_supermatter
	p_react = "supermatter"
	s_react = GAS_PHORON
	energy_consumption = 0
	energy_production = 5
	radiation = 40
	instability = 20

/obj/effect/decal/fusion_reaction/phoron_supermatter/handle_reaction_special(var/obj/effect/fusion_em_field/holder)
	// wormhole_event(GetConnectedZlevels(holder))
	// var/turf/origin = get_turf(holder)
	// holder.Rupture()
	// qdel(holder)
	// var/radiation_level = rand(100, 200)
	// // Copied from the SM for proof of concept. //Not any more --Cirra //Use the whole z proc --Leshana
	// SSradiation.z_radiate(locate(1, 1, holder.z), radiation_level, 1)

	// for(var/M in GLOB.living_mob_list_)
	// 	var/mob/living/mob = M
	// 	var/turf/T = get_turf(mob)
	// 	if(T && (holder.z == T.z))
	// 		if(ishuman(mob))
	// 			var/mob/living/carbon/human/H = mob
	// 			H.hallucination(rand(100,150), 51)

	// for(var/thing in range(world.view, origin))
	// 	var/obj/machinery/fusion_fuel_injector/I = thing
	// 	if(I.cur_assembly && I.cur_assembly.fuel_type == MATERIAL_SUPERMATTER)
	// 		explosion(get_turf(I), 1, 2, 3)
	// 		spawn(5)
	// 			if(I && I.loc)
	// 				qdel(I)

	// sleep(5)
	// explosion(origin, 1, 2, 5)

	return 1


// High end reactions.
/obj/effect/decal/fusion_reaction/boron_hydrogen
	p_react = "boron"
	s_react = GAS_HYDROGEN
	minimum_energy_level = FUSION_HEAT_CAP * 0.5
	energy_consumption = 3
	energy_production = 15
	radiation = 3
	instability = 3
