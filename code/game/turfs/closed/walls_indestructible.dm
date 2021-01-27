/turf/closed/wall/indestructible

/turf/closed/wall/indestructible/dismantle_wall(devastated = 0, explode = 0)
	return

/turf/closed/wall/indestructible/take_damage(dam)
	return

/turf/closed/wall/indestructible/welder_act()
	return

/turf/closed/wall/indestructible/ex_act(severity)
	return

/turf/closed/wall/indestructible/blob_act(obj/structure/blob/B)
	return

/turf/closed/wall/indestructible/singularity_act()
	return

/turf/closed/wall/indestructible/singularity_pull(S, current_size)
	return

/turf/closed/wall/indestructible/narsie_act()
	return

/turf/closed/wall/indestructible/ratvar_act(force, ignore_mobs)
	return

/turf/closed/wall/indestructible/burn_down()
	return

/turf/closed/wall/indestructible/attackby(obj/item/I, mob/user, params)
	return

/turf/closed/wall/indestructible/attack_hand(mob/user)
	return

/turf/closed/wall/indestructible/attack_hulk(mob/user, does_attack_animation = FALSE)
	return

/turf/closed/wall/indestructible/attack_animal(mob/living/simple_animal/M)
	return

/turf/closed/wall/indestructible/mech_melee_attack(obj/mecha/M)
	return

/turf/closed/wall/indestructible/necropolis
	name = "necropolis wall"
	desc = "A seemingly impenetrable wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "necro"
	explosion_block = 50
	baseturf = /turf/closed/wall/indestructible/necropolis

/turf/closed/wall/indestructible/boss
	name = "necropolis wall"
	desc = "A thick, seemingly indestructible stone wall."
	icon = 'icons/turf/walls/boss_wall.dmi'
	icon_state = "wall"
	canSmoothWith = list(/turf/closed/wall/indestructible/boss, /turf/closed/wall/indestructible/boss/see_through)
	explosion_block = 50
	baseturf = /turf/open/floor/plating/asteroid/basalt
	smooth = SMOOTH_TRUE

/turf/closed/wall/indestructible/boss/see_through
	opacity = FALSE

/turf/closed/wall/indestructible/hierophant
	name = "wall"
	desc = "A wall made out of a strange metal. The squares on it pulse in a predictable pattern."
	icon = 'icons/turf/walls/hierophant_wall.dmi'
	icon_state = "wall"
	smooth = SMOOTH_TRUE

/turf/closed/wall/indestructible/uranium
	icon = 'icons/turf/walls/uranium_wall.dmi'
	icon_state = "uranium"
