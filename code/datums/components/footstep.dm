///Footstep component. Plays footsteps at parents location when it is appropriate.
/datum/component/footstep
	///How many steps the parent has taken since the last time a footstep was played.
	var/steps = 0
	///volume determines the extra volume of the footstep. This is multiplied by the base volume, should there be one.
	var/volume
	///e_range stands for extra range - aka how far the sound can be heard. This is added to the base value and ignored if there isn't a base value.
	var/e_range
	///footstep_type is a define which determines what kind of sounds should get chosen.
	var/footstep_type
	///This can be a list OR a soundfile OR null. Determines whatever sound gets played.
	var/footstep_sounds

/datum/component/footstep/Initialize(footstep_type_ = FOOTSTEP_MOB_BAREFOOT, volume_ = 1, e_range_ = 1)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	volume = volume_
	e_range = e_range_
	footstep_type = footstep_type_
	switch(footstep_type)
		if(FOOTSTEP_MOB_HUMAN)
			if(!ishuman(parent))
				return COMPONENT_INCOMPATIBLE
			RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), .proc/play_mobstep)
			return
		if(FOOTSTEP_MOB_CLAW)
			footstep_sounds = GLOB.clawfootstep
		if(FOOTSTEP_MOB_BAREFOOT)
			footstep_sounds = GLOB.barefootstep
		if(FOOTSTEP_MOB_HEAVY)
			footstep_sounds = GLOB.heavyfootstep
		if(FOOTSTEP_MOB_SHOE)
			footstep_sounds = GLOB.footstep
		if(FOOTSTEP_MOB_SLIME)
			footstep_sounds = 'sound/effects/footstep/slime1.ogg'
	RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), .proc/play_simplestep) //Note that this doesn't get called for humans.

///Prepares a footstep. Determines if it should get played. Returns the turf it should get played on. Note that it is always a /turf/open
/datum/component/footstep/proc/prepare_step()
	var/turf/T = get_turf(parent)
	if(!istype(T))
		return
	steps++
	if(steps >= 6)
		steps = 0
	if((steps % 2) == 1)
		return
	if(steps != 0 && !has_gravity(get_area(T)))// don't need to step as often when you hop around
		return
	return T

/datum/component/footstep/proc/play_simplestep()
	SIGNAL_HANDLER
	var/turf/T = prepare_step()
	if(!T)
		return
	if(isfile(footstep_sounds) || istext(footstep_sounds))
		playsound(T, footstep_sounds, volume)
		return
	var/turf_footstep
	switch(footstep_type)
		if(FOOTSTEP_MOB_CLAW)
			turf_footstep = T.clawfootstep
		if(FOOTSTEP_MOB_BAREFOOT)
			turf_footstep = T.barefootstep
		if(FOOTSTEP_MOB_HEAVY)
			turf_footstep = T.heavyfootstep
		if(FOOTSTEP_MOB_SHOE)
			turf_footstep = T.footstep
	if(!turf_footstep)
		return
	playsound(T, pick(footstep_sounds[turf_footstep][1]), (footstep_sounds[turf_footstep][2] * volume), TRUE, footstep_sounds[turf_footstep][3] + e_range)

/datum/component/footstep/proc/play_mobstep()
	SIGNAL_HANDLER
	var/turf/T = prepare_step()
	if(!T || isspaceturf(T))
		return
	var/mob/living/carbon/human/H = parent
	if(H.dna.species.silent_steps)
		return
	var/feetCover = (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)) || (H.w_uniform && (H.w_uniform.body_parts_covered & FEET))
	if(H.shoes || feetCover) //are we wearing shoes
		if(istype(H.shoes, /obj/item/clothing/shoes))
			var/obj/item/clothing/shoes/S = H.shoes
			if(S.silence_steps)
				return
			if(S.shoe_sound)
				playsound(T, S.shoe_sound, T.shoe_running_volume, 1)
		playsound(T, pick(GLOB.footstep[T.footstep][1]),
			GLOB.footstep[T.footstep][2] * volume,
			TRUE,
			GLOB.footstep[T.footstep][3] + e_range)
	else
		playsound(T, pick(GLOB.barefootstep[T.barefootstep][1]),
			GLOB.barefootstep[T.barefootstep][2] * volume,
			TRUE,
			GLOB.barefootstep[T.barefootstep][3] + e_range)
