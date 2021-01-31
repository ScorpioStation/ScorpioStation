/turf/closed/ind_wall	// Indestrucible Walls
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	density = TRUE
	explosion_block = 2
	indestructible_turf = TRUE	//Establish as indestructible_turf

//Turf Closed ind_wall overrides
/turf/closed/ind_wall/dismantle_wall(devastated = FALSE, explode = FALSE)
	return

/turf/closed/ind_wall/ex_act(severity)
	return

/turf/closed/ind_wall/blob_act(obj/structure/blob/B)
	return

/turf/closed/ind_wall/rpd_act(mob/user, obj/item/rpd/our_rpd)
	to_chat("<span class='notice'>For some reason you cannot determine, the drill bit on your [our_rpd] fails to penetrate [src].</span>")
	return

/turf/closed/ind_wall/mech_melee_attack(obj/mecha/M)
	return

/turf/closed/ind_wall/burn_down()
	return

/turf/closed/ind_wall/attack_animal(mob/living/simple_animal/M)
	return

/turf/closed/ind_wall/attack_hulk(mob/user, does_attack_animation = FALSE)
	return

/turf/closed/ind_wall/attack_hand(mob/user)
	to_chat(user, "<span class='notice'>You push the wall but nothing happens!</span>")
	playsound(src, 'sound/weapons/genhit.ogg', 25, 1)
	add_fingerprint(user)
	return ..()

/turf/closed/ind_wall/attackby(obj/item/I, mob/user, params)
	return

/turf/closed/ind_wall/welder_act(mob/user, obj/item/I)
	return

/turf/closed/ind_wall/singularity_pull(S, current_size)
	return

/turf/closed/ind_wall/narsie_act()
	return

/turf/closed/ind_wall/acid_act(acidpwr, acid_volume)
	return

/turf/closed/ind_wall/acid_melt()
	return

/turf/closed/ind_wall/swarmer_act()
	return FALSE
/turf/closed/ind_wall/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = FALSE

/turf/closed/ind_wall/fakedoor
	name = "Centcom Access"
	icon = 'icons/obj/doors/airlocks/centcom/centcom.dmi'
	icon_state = "closed"

/turf/closed/ind_wall/splashscreen
	name = "Space Station 13"
	icon = 'icons/blank.png'
	icon_state = ""
	layer = FLY_LAYER

/turf/closed/ind_wall/r_wall
	icon_state = "r_wall"

/turf/closed/ind_wall/metal
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"
	smooth = SMOOTH_TRUE

/turf/closed/ind_wall/abductor
	icon_state = "alien1"
	explosion_block = 50

/turf/closed/ind_wall/necropolis
	name = "necropolis wall"
	desc = "A seemingly impenetrable wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "necro"
	explosion_block = 50
	baseturf = /turf/closed/ind_wall/necropolis

/turf/closed/ind_wall/boss
	name = "necropolis wall"
	desc = "A thick, seemingly indestructible stone wall."
	icon = 'icons/turf/walls/boss_wall.dmi'
	icon_state = "wall"
	canSmoothWith = list(/turf/closed/ind_wall/boss, /turf/closed/ind_wall/boss/see_through)
	explosion_block = 50
	baseturf = /turf/open/floor/plating/asteroid/basalt
	smooth = SMOOTH_TRUE

/turf/closed/ind_wall/boss/see_through
	opacity = FALSE

/turf/closed/ind_wall/hierophant
	name = "wall"
	desc = "A wall made out of a strange metal. The squares on it pulse in a predictable pattern."
	icon = 'icons/turf/walls/hierophant_wall.dmi'
	icon_state = "wall"
	smooth = SMOOTH_TRUE

/turf/closed/ind_wall/uranium
	icon = 'icons/turf/walls/uranium_wall.dmi'
	icon_state = "uranium"
