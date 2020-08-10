
// Cockroach that will be created after someone uses unstable mutagen on a normal roach.
// There's a bit of copy and paste here from the normal cockroach, but its a necessary evil in order to have this be a /hostile/retaliate type mob.
/mob/living/simple_animal/hostile/retaliate/mutant_cockroach
	name = "mutated cockroach"
	desc = "An absolutely massive cockroach. It seems friendly."
	icon_state = "cockroach_mutant"
	icon_dead = "cockroach_mutant_dead"
	icon_living = "cockroach_mutant"
	health = 50
	maxHealth = 50
	melee_damage_lower = 5
	melee_damage_upper = 7
	mob_size = MOB_SIZE_SMALL
	obj_damage = null
	stop_automated_movement_when_pulled = TRUE
	environment_smash = null
	pass_flags = PASSTABLE // Can crawl under/over tables, but he's too big to fit through grilles or walk under other mobs now.
	density = TRUE
	can_collar = TRUE
	gold_core_spawnable = NO_SPAWN
	response_help = "pets"
	emote_taunt = list("hisses")
	taunt_chance = 50
	attack_sound = 'sound/weapons/bite.ogg'
	/// The next time the roach is allowed to hiss, measured with world.time.
	var/next_hiss
	/// A list of available hiss sounds the cockroache can make.
	var/list/hiss_sounds = list(
		'sound/creatures/roach_hiss1.ogg',
		'sound/creatures/roach_hiss2.ogg',
		'sound/creatures/roach_hiss3.ogg'
	)

// This is basically the same as the parent proc, but overriden because it needs some slight differences.
/mob/living/simple_animal/hostile/retaliate/mutant_cockroach/Aggro()
	vision_range = aggro_vision_range
	if(target && length(emote_taunt) && prob(taunt_chance))
		custom_emote(2, "[pick(emote_taunt)] at [target].")
		do_hiss(5 SECONDS, FALSE)
		taunt_chance = max(taunt_chance-7, 2)

 // When this roach is attacked, it wont't make all other mutant roaches in range attack.
/mob/living/simple_animal/hostile/retaliate/mutant_cockroach/Retaliate(rally_others)
	return ..(FALSE)

// Override just so the roach can use the bite attack effect.
/mob/living/simple_animal/hostile/retaliate/mutant_cockroach/do_attack_animation(atom/A, visual_effect_icon, used_item, no_effect)
	return ..(A, ATTACK_EFFECT_BITE)

/mob/living/simple_animal/hostile/retaliate/mutant_cockroach/attack_hand(mob/living/carbon/human/H)
	. = ..()
	do_hiss()

/mob/living/simple_animal/hostile/retaliate/mutant_cockroach/proc/do_hiss(cooldown = 20 SECONDS, do_emote = TRUE)
	if(stat != CONSCIOUS || world.time < next_hiss)
		return
	playsound(src, pick(hiss_sounds), 20, TRUE)
	next_hiss = world.time + cooldown
	if(do_emote)
		custom_emote(2, "hisses.")
