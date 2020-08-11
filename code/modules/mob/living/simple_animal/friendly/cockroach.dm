/mob/living/simple_animal/cockroach
	name = "cockroach"
	desc = "This station is just crawling with bugs."
	icon_state = "cockroach"
	icon_dead = "cockroach_dead"
	icon_living = "cockroach"
	health = 1
	maxHealth = 1
	turns_per_move = 5
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 270
	maxbodytemp = INFINITY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	gold_core_spawnable = FRIENDLY_SPAWN
	loot = list(/obj/effect/decal/cleanable/insectguts)
	holder_type = /obj/item/holder/cockroach
	childtype = list(/mob/living/simple_animal/cockroach/baby)
	animal_species = /mob/living/simple_animal/cockroach
	/// The probability that walking over the cockroach will squish and kill it.
	var/squish_chance = 50
	/// The next time the roach is allowed to hiss, measured with world.time.
	var/next_hiss
	/// A list of available hiss sounds cockroaches can make.
	var/list/hiss_sounds = list(
		'sound/creatures/roach_hiss1.ogg',
		'sound/creatures/roach_hiss2.ogg',
		'sound/creatures/roach_hiss3.ogg'
	)

/mob/living/simple_animal/cockroach/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_CROSSED, .proc/RoachCrossed)

/mob/living/simple_animal/cockroach/death()
	. = ..()
	// No point in having dead roaches care about if someone walks over them
	UnregisterSignal(src, COMSIG_MOVABLE_CROSSED)

/mob/living/simple_animal/cockroach/revive()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_CROSSED, .proc/RoachCrossed)

/mob/living/simple_animal/cockroach/Life()
	. = ..()
	if(gender == FEMALE)
		make_babies(FALSE) // Roaches don't care if someone is watching

// Allow humans on help intent to pick up the cockroaches, and handles hissing
/mob/living/simple_animal/cockroach/attack_hand(mob/living/carbon/human/H)
	do_hiss()
	if(H.a_intent == INTENT_HELP)
		get_scooped(H)
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	else if(H.a_intent == INTENT_DISARM)
		visible_message("<span class='notice'>[H] pokes [src].</span>", "<span class='notice'>You poke [src].</span>")
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	else
		return ..()

/mob/living/simple_animal/cockroach/proc/do_hiss(cooldown = 20 SECONDS)
	if(stat != CONSCIOUS || world.time < next_hiss)
		return
	custom_emote(2, "hisses.") // Hisssss!
	playsound(src, pick(hiss_sounds), 20, TRUE)
	next_hiss = world.time + cooldown

/mob/living/simple_animal/cockroach/attackby(obj/item/O, mob/living/user)
	if(pre_mutate_checks(O, user))
		addtimer(CALLBACK(src, .proc/mutate), 5 SECONDS)
		to_chat(user, "<span class='warning'>[src] starts to squirm and twitch!</span>")
	return ..()

/mob/living/simple_animal/cockroach/proc/pre_mutate_checks(obj/item/O, mob/living/user)
	if(!istype(O, /obj/item/reagent_containers/glass) || stat == DEAD)
		return FALSE
	var/obj/item/reagent_containers/glass/container = O
	if(container.reagents.has_reagent("mutagen") && user.a_intent == INTENT_HARM)
		return TRUE

/mob/living/simple_animal/cockroach/proc/mutate()
	new /mob/living/simple_animal/hostile/retaliate/mutant_cockroach(loc)
	visible_message("<span class='warning'>[src] suddently mutates into a massive cockroach!</span>")
	qdel(src)

/mob/living/simple_animal/cockroach/can_die()
	return ..() && !SSticker.cinematic //If the nuke is going off, then cockroaches are invincible. Keeps the nuke from killing them, cause cockroaches are immune to nukes.

/mob/living/simple_animal/cockroach/proc/RoachCrossed(datum/source, atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.mob_size > MOB_SIZE_SMALL)
			if(prob(squish_chance))
				L.visible_message("<span class='notice'>\The [L] squashed \the [name].</span>", "<span class='notice'>You squashed \the [name].</span>")
				death()
			else
				visible_message("<span class='notice'>\The [name] avoids getting crushed.</span>")
	else if(istype(AM, /obj/structure))
		visible_message("<span class='notice'>As \the [AM] moved over \the [name], it was crushed.</span>")
		death()

/mob/living/simple_animal/cockroach/ex_act() //Explosions are a terrible way to handle a cockroach.
	return

/mob/living/simple_animal/cockroach/baby
	name = "baby cockroach"
	desc = "It's a newly born cockroach. It's sort of cute."
	icon_state = "cockroach_baby"
	icon_living = "cockroach_baby"
	gold_core_spawnable = NO_SPAWN
	del_on_death = TRUE
	holder_type = /obj/item/holder/cockroach/baby
	animal_species = /mob/living/simple_animal/cockroach/baby
	adult_mob_type = /mob/living/simple_animal/cockroach
	childtype = null
	growth_time = 3 MINUTES

/mob/living/simple_animal/cockroach/baby/do_hiss()
	return // Too young to hiss.

/mob/living/simple_animal/cockroach/baby/make_babies()
	return // Self explanatory.

/mob/living/simple_animal/cockroach/baby/pre_mutate_checks(obj/item/O, mob/living/user)
	if(..()) // Baby roaches are too weak to withstand mutagen, and they will die if you pour it on them.
		to_chat(user, "<span class='warning'>[src] shrivels up and dies as you pour the mutagen over it!</span>")
		qdel(src)
