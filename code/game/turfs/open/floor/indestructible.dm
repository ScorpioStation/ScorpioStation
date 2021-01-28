/turf/open/floor/indestructible

/turf/open/floor/indestructible/ex_act(severity)
	return

/turf/open/floor/indestructible/blob_act(obj/structure/blob/B)
	return

/turf/open/floor/indestructible/singularity_act()
	return

/turf/open/floor/indestructible/singularity_pull(S, current_size)
	return

/turf/open/floor/indestructible/narsie_act()
	return

/turf/open/floor/indestructible/ratvar_act(force, ignore_mobs)
	return

/turf/open/floor/indestructible/burn_down()
	return

/turf/open/floor/indestructible/attackby(obj/item/I, mob/user, params)
	return

/turf/open/floor/indestructible/attack_hand(mob/user)
	return

/turf/open/floor/indestructible/attack_hulk(mob/user, does_attack_animation = FALSE)
	return

/turf/open/floor/indestructible/attack_animal(mob/living/simple_animal/M)
	return

/turf/open/floor/indestructible/mech_melee_attack(obj/mecha/M)
	return

/turf/open/floor/indestructible/necropolis
	name = "necropolis floor"
	desc = "It's regarding you suspiciously."
	icon = 'icons/turf/floors.dmi'
	icon_state = "necro1"
	baseturf = /turf/open/floor/indestructible/necropolis
	oxygen = 14
	nitrogen = 23
	temperature = 300
	planetary_atmos = TRUE

/turf/open/floor/indestructible/necropolis/Initialize(mapload)
	. = ..()
	if(prob(12))
		icon_state = "necro[rand(2,3)]"

/turf/open/floor/indestructible/necropolis/air
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T20C

/turf/open/floor/indestructible/boss //you put stone tiles on this and use it as a base
	name = "necropolis floor"
	icon = 'icons/turf/floors/boss_floors.dmi'
	icon_state = "boss"
	baseturf = /turf/open/floor/indestructible/boss
	oxygen = 14
	nitrogen = 23
	temperature = 300
	planetary_atmos = TRUE

/turf/open/floor/indestructible/boss/air
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T20C

/turf/open/floor/indestructible/hierophant
	name = "floor"
	icon = 'icons/turf/floors/hierophant_floor.dmi'
	icon_state = "floor"
	oxygen = 14
	nitrogen = 23
	temperature = 300
	planetary_atmos = TRUE
	smooth = SMOOTH_TRUE

/turf/open/floor/indestructible/hierophant/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE

/turf/open/floor/indestructible/hierophant/two

//aaaah why does this file exist? ;-;

