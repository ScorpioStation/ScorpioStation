/turf/open/floor/plating
	name = "plating"
	icon_state = "plating"
	icon = 'icons/turf/floors/plating.dmi'
	intact = FALSE
	floor_tile = null
	broken_states = list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5")
	burnt_states = list("floorscorched1", "floorscorched2")
	indestructible_turf = FALSE		//Establish as not indestructible_turf

	footstep_sounds = list(
	"human" = list('sound/effects/footstep/plating_human.ogg'),
	"xeno"  = list('sound/effects/footstep/plating_xeno.ogg')
	)

	var/unfastened = FALSE

/turf/open/floor/plating/Initialize(mapload)
	. = ..()
	icon_plating = icon_state
	update_icon()

/turf/open/floor/plating/damaged/Initialize(mapload)
	. = ..()
	break_tile()

/turf/open/floor/plating/burnt/Initialize(mapload)
	. = ..()
	burn_tile()

/turf/open/floor/plating/update_icon()
	if(!..())
		return
	if(!broken && !burnt)
		icon_state = icon_plating //Because asteroids are 'platings' too.

/turf/open/floor/plating/examine(mob/user)
	. = ..()
	if(unfastened)
		. += "<span class='warning'>It has been unfastened.</span>"

/turf/open/floor/plating/attackby(obj/item/C, mob/user, params)
	if(..())
		return TRUE
	if(istype(C, /obj/item/stack/rods))
		if(broken || burnt)
			to_chat(user, "<span class='warning'>Repair the plating first!</span>")
			return TRUE
		var/obj/item/stack/rods/R = C
		if(R.get_amount() < 2)
			to_chat(user, "<span class='warning'>You need two rods to make a reinforced floor!</span>")
			return TRUE
		else
			to_chat(user, "<span class='notice'>You begin reinforcing the floor...</span>")
			if(do_after(user, 30 * C.toolspeed, target = src))
				if(R.get_amount() >= 2 && !istype(src, /turf/open/floor/engine))
					ChangeTurf(/turf/open/floor/engine)
					playsound(src, C.usesound, 80, 1)
					R.use(2)
					to_chat(user, "<span class='notice'>You reinforce the floor.</span>")
				return TRUE

	else if(istype(C, /obj/item/stack/tile))
		if(!broken && !burnt)
			var/obj/item/stack/tile/W = C
			if(!W.use(1))
				return
			ChangeTurf(W.turf_type)
			playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
		else
			to_chat(user, "<span class='warning'>This section is too damaged to support a tile! Use a welder to fix the damage.</span>")
		return TRUE

/turf/open/floor/plating/screwdriver_act(mob/user, obj/item/I)
	. = TRUE
	if(!I.tool_use_check(user, 0))
		return
	to_chat(user, "<span class='notice'>You start [unfastened ? "fastening" : "unfastening"] [src].</span>")
	. = TRUE
	if(!I.use_tool(src, user, 20, volume = I.tool_volume))
		return
	to_chat(user, "<span class='notice'>You [unfastened ? "fasten" : "unfasten"] [src].</span>")
	unfastened = !unfastened

/turf/open/floor/plating/welder_act(mob/user, obj/item/I)
	if(!broken && !burnt && !unfastened)
		return
	. = TRUE
	if(!I.tool_use_check(user, 0))
		return
	if(unfastened)
		to_chat(user, "<span class='warning'>You start removing [src], exposing space after you're done!</span>")
		if(!I.use_tool(src, user, 50, volume = I.tool_volume * 2)) //extra loud to let people know something's going down
			return
		new /obj/item/stack/tile/plasteel(get_turf(src))
		remove_plating(user)	// Heh heh heh.
		return
	if(I.use_tool(src, user, volume = I.tool_volume)) //If we got this far, something needs fixing
		to_chat(user, "<span class='notice'>You fix some dents on the broken plating.</span>")
		overlays -= current_overlay
		current_overlay = null
		burnt = FALSE
		broken = FALSE
		update_icon()

/turf/open/floor/plating/remove_plating(mob/user)
	if(baseturf == /turf/open/space)
		ReplaceWithLattice()
	else
		TerraformTurf(baseturf)

//Airless Plating
/turf/open/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/open/floor/plating/airless/Initialize(mapload)
	. = ..()
	name = "plating"

//Iron Sand
/turf/open/floor/plating/ironsand
	name = "Iron Sand"
	icon = 'icons/turf/floors/ironsand.dmi'
	icon_state = "ironsand1"

/turf/open/floor/plating/ironsand/Initialize(mapload)
	. = ..()
	icon_state = "ironsand[rand(1,15)]"

/turf/open/floor/plating/ironsand/remove_plating()
	return

//Metal Foam
/turf/open/floor/plating/metalfoam
	name = "foamed metal plating"
	icon_state = "metalfoam"
	var/metal = MFOAM_ALUMINUM

/turf/open/floor/plating/metalfoam/iron
	icon_state = "ironfoam"
	metal = MFOAM_IRON

/turf/open/floor/plating/metalfoam/update_icon()
	switch(metal)
		if(MFOAM_ALUMINUM)
			icon_state = "metalfoam"
		if(MFOAM_IRON)
			icon_state = "ironfoam"

/turf/open/floor/plating/metalfoam/attackby(var/obj/item/C, mob/user, params)
	if(..())
		return TRUE
	if(istype(C) && C.force)
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		var/smash_prob = max(0, C.force*17 - metal*25) // A crowbar will have a 60% chance of a breakthrough on alum, 35% on iron
		if(prob(smash_prob))
			// YAR BE CAUSIN A HULL BREACH
			visible_message("<span class='danger'>[user] smashes through \the [src] with \the [C]!</span>")
			smash()
		else
			visible_message("<span class='warning'>[user]'s [C.name] bounces against \the [src]!</span>")

/turf/open/floor/plating/metalfoam/attack_animal(mob/living/simple_animal/M)
	M.do_attack_animation(src)
	if(M.melee_damage_upper == 0)
		M.visible_message("<span class='notice'>[M] nudges \the [src].</span>")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		M.visible_message("<span class='danger'>\The [M] [M.attacktext] [src]!</span>")
		smash(src)

/turf/open/floor/plating/metalfoam/attack_alien(mob/living/carbon/alien/humanoid/M)
	M.visible_message("<span class='danger'>[M] tears apart \the [src]!</span>")
	smash(src)

/turf/open/floor/plating/metalfoam/burn_tile()
	smash()

/turf/open/floor/plating/metalfoam/proc/smash()
	ChangeTurf(baseturf)

//Abductor Plating
/turf/open/floor/plating/abductor
	name = "alien floor"
	icon_state = "alienpod1"

/turf/open/floor/plating/abductor/Initialize(mapload)
	. = ..()
	icon_state = "alienpod[rand(1,9)]"

//Snow Plating - 'unsimulated' snow plating was not used
/turf/open/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	temperature = T0C

/turf/open/floor/plating/snow/concrete	// Is this even used?
	name = "concrete"
	icon = 'icons/turf/floors.dmi'
	icon_state = "concrete"

//Ice Plating
/turf/open/floor/plating/ice
	name = "ice sheet"
	desc = "A sheet of solid ice. Looks slippery."
	icon = 'icons/turf/floors/ice_turfs.dmi'
	icon_state = "unsmooth"
	oxygen = 22
	nitrogen = 82
	temperature = 180
	baseturf = /turf/open/floor/plating/ice
	slowdown = TRUE
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/plating/ice/smooth, /turf/open/floor/plating/ice)

/turf/open/floor/plating/ice/Initialize(mapload)
	. = ..()
	MakeSlippery(TURF_WET_PERMAFROST, INFINITY)

/turf/open/floor/plating/ice/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/ice/smooth
	icon_state = "smooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/plating/ice/smooth, /turf/open/floor/plating/ice)
