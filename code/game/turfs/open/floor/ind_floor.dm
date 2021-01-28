/turf/open/ind_floor	// Indestructible Floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"
	indesctructible_turf = TRUE

//Grass
/turf/open/ind_floor/grass
	name = "grass patch"
	icon_state = "grass1"

/turf/open/ind_floor/grass/Initialize(mapload)
	. = ..()
	icon_state = "grass[rand(1,4)]"

//Snow
/turf/open/ind_floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

//Abductor
/turf/open/ind_floor/abductor
	name = "alien floor"
	icon_state = "alienpod1"

/turf/open/ind_floor/abductor/Initialize(mapload)
	. = ..()
	icon_state = "alienpod[rand(1,9)]"

//Vox
/turf/open/ind_floor/vox
	icon_state = "dark"
	nitrogen = 100
	oxygen = 0

//Carpet
/turf/open/ind_floor/carpet
	name = "Carpet"
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet"
	smooth = SMOOTH_TRUE
	canSmoothWith = null

	footstep_sounds = list(
		"human" = list('sound/effects/footstep/carpet_human.ogg'),
		"xeno"  = list('sound/effects/footstep/carpet_xeno.ogg')
	)

//Wood
/turf/open/ind_floor/wood
	icon_state = "wood"

	footstep_sounds = list(
		"human" = list('sound/effects/footstep/wood_all.ogg'), //@RonaldVanWonderen of Freesound.org
		"xeno"  = list('sound/effects/footstep/wood_all.ogg')  //@RonaldVanWonderen of Freesound.org
	)


/turf/open/ind_floor/blob_act(obj/structure/blob/B)
	return

/turf/open/ind_floor/narsie_act()
	return

/turf/open/ind_floor/attackby(obj/item/I, mob/user, params)
	return

/turf/open/ind_floor/attack_hand(mob/user)
	return

/turf/open/ind_floor/attack_hulk(mob/user, does_attack_animation = FALSE)
	return

/turf/open/ind_floor/attack_animal(mob/living/simple_animal/M)
	return

/turf/open/ind_floor/mech_melee_attack(obj/mecha/M)
	return

/turf/open/ind_floor/necropolis
	name = "necropolis floor"
	desc = "It's regarding you suspiciously."
	icon = 'icons/turf/floors.dmi'
	icon_state = "necro1"
	baseturf = /turf/open/ind_floor/necropolis
	oxygen = 14
	nitrogen = 23
	temperature = 300
	planetary_atmos = TRUE

/turf/open/ind_floor/necropolis/Initialize(mapload)
	. = ..()
	if(prob(12))
		icon_state = "necro[rand(2,3)]"

/turf/open/ind_floor/necropolis/air
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

/turf/open/ind_floor/hierophant
	name = "floor"
	icon = 'icons/turf/floors/hierophant_floor.dmi'
	icon_state = "floor"
	oxygen = 14
	nitrogen = 23
	temperature = 300
	planetary_atmos = TRUE
	smooth = SMOOTH_TRUE

/turf/open/ind_floor/hierophant/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE

/turf/open/ind_floor/hierophant/two

//aaaah why does this file exist? ;-;

