/turf/open/floor/vault
	icon = 'icons/turf/floors.dmi'
	icon_state = "rockvault"
	smooth = SMOOTH_FALSE

/turf/open/floor/gym
	name = "wrestling mat"
	icon = 'icons/misc/wrestling_ring.dmi'
	icon_state = "ring_9"

/turf/open/floor/rubber
	name = "rubber floor"
	icon = 'icons/misc/wrestling_ring.dmi'
	icon_state = "rubber_carpet"

/turf/open/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
/turf/open/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/open/floor/bluegrid/telecomms
	nitrogen = 100
	oxygen = 0
	temperature = 80

/turf/open/floor/bluegrid/telecomms/server
	name = "server base"

/turf/open/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"

/turf/open/floor/greengrid/airless
	icon_state = "gcircuit"
	name = "airless floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/open/floor/greengrid/airless/Initialize(mapload)
	. = ..()
	name = "floor"

/turf/open/floor/redgrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "rcircuit"

/turf/open/floor/noslip
	name = "high-traction floor"
	icon_state = "noslip"
	floor_tile = /obj/item/stack/tile/noslip
	broken_states = list("noslip-damaged1","noslip-damaged2","noslip-damaged3")
	burnt_states = list("noslip-scorched1","noslip-scorched2")
	slowdown = -0.3

/turf/open/floor/noslip/MakeSlippery()
	return

/turf/open/floor/noslip/lavaland
	oxygen = 14
	nitrogen = 23
	temperature = 300
	planetary_atmos = TRUE

/turf/open/floor/lubed
	name = "slippery floor"
	icon_state = "floor"

/turf/open/floor/lubed/Initialize(mapload)
	. = ..()
	MakeSlippery(TURF_WET_LUBE, INFINITY)

/turf/open/floor/lubed/pry_tile(obj/item/C, mob/user, silent = FALSE) //I want to get off Mr Honk's Wild Ride
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		to_chat(H, "<span class='warning'>You lose your footing trying to pry off the tile!</span>")
		H.slip("the floor", 0, 5, tilesSlipped = 4, walkSafely = 0, slipAny = 1)
	return

/*
 * Clockwork Floors
 */

//Clockwork floor: Slowly heals toxin damage on nearby servants.
/turf/open/floor/clockwork
	name = "clockwork floor"
	desc = "Tightly-pressed brass tiles. They emit minute vibration."
	icon_state = "plating"
	baseturf = /turf/open/floor/clockwork
	var/dropped_brass
	var/uses_overlay = TRUE
	var/obj/effect/clockwork/overlay/floor/realappearence

/turf/open/floor/clockwork/Initialize(mapload)
	. = ..()
	if(uses_overlay)
		new /obj/effect/temp_visual/ratvar/floor(src)
		new /obj/effect/temp_visual/ratvar/beam(src)
		realappearence = new /obj/effect/clockwork/overlay/floor(src)
		realappearence.linked = src

/turf/open/floor/clockwork/Destroy()
	if(uses_overlay && realappearence)
		QDEL_NULL(realappearence)
	return ..()

/turf/open/floor/clockwork/ReplaceWithLattice(baseturf, lattice)
	. = ..()
	for(var/obj/structure/lattice/L in src)
		L.ratvar_act()

/turf/open/floor/clockwork/crowbar_act(mob/user, obj/item/I)
	. = TRUE
	if(!I.tool_use_check(user, 0))
		return
	user.visible_message("<span class='notice'>[user] begins slowly prying up [src]...</span>", "<span class='notice'>You begin painstakingly prying up [src]...</span>")
	if(!I.use_tool(src, user, 70, volume = I.tool_volume))
		return
	user.visible_message("<span class='notice'>[user] pries up [src]!</span>", "<span class='notice'>You pry up [src]!</span>")
	make_plating()

/turf/open/floor/clockwork/make_plating()
	if(!dropped_brass)
		new /obj/item/stack/tile/brass(src)
		dropped_brass = TRUE
	if(baseturf == type)
		return
	return ..()

/turf/open/floor/clockwork/narsie_act()
	..()
	if(istype(src, /turf/open/floor/clockwork)) //if we haven't changed type
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)
		addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 8)

/turf/open/floor/clockwork/reebe
	name = "cogplate"
	desc = "Warm brass plating. You can feel it gently vibrating, as if machinery is on the other side."
	icon_state = "reebe"
	baseturf = /turf/open/floor/clockwork/reebe
	uses_overlay = FALSE


/*
 * Engine Floors
 */

//Initial Engine Floor type
/turf/open/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	var/insulated
	heat_capacity = 325000
	floor_tile = /obj/item/stack/rods

//Engine Floor overrides
/turf/open/floor/engine/break_tile()
	return

/turf/open/floor/engine/burn_tile()
	return

/turf/open/floor/engine/make_plating(force = 0)
	if(force)
		..()
	return //unplateable // ??? then why bother with force?

/turf/open/floor/engine/pry_tile(obj/item/C, mob/user, silent = FALSE)
	return

/turf/open/floor/engine/acid_act(acidpwr, acid_volume)
	acidpwr = min(acidpwr, 50) //we reduce the power so reinf floor never get melted.
	. = ..()

/turf/open/floor/engine/attack_hand(mob/user)
	user.Move_Pulled(src)

/turf/open/floor/engine/attackby(obj/item/C, mob/user, params)
	if(!C || !user)
		return
	if(iswrench(C))	// Wrench_Act created
		return
	if(istype(C, /obj/item/stack/sheet/plasteel) && !insulated)	//Insulating the floor
		to_chat(user, "<span class='notice'>You begin insulating [src]...</span>")
		if(do_after(user, 40, target = src) && !insulated)	//You finish insulating the insulated vacuum floor
			to_chat(user, "<span class='notice'>You finish insulating [src].</span>")
			var/obj/item/stack/sheet/plasteel/W = C
			W.use(1)
			thermal_conductivity = 0
			insulated = TRUE
			name = "insulated " + name
			return
	else
		to_chat(user, "<span class='notice'>You begin insulating [src]...before realizing it has already been insulated.</span>")
		return

/turf/open/floor/engine/wrench_act(mob/user, obj/item/C)
	to_chat(user, "<span class='notice'>You begin removing rods...</span>")
	playsound(src, C.usesound, 80, 1)
	if(do_after(user, 30 * C.toolspeed, target = src))
		if(!istype(src, /turf/open/floor/engine))
			return
		new /obj/item/stack/rods(src, 2)
		ChangeTurf(/turf/open/floor/plating)
		return

/turf/open/floor/engine/ex_act(severity)
	switch(severity)
		if(1)
			ChangeTurf(baseturf)
		if(2)
			if(prob(50))
				ChangeTurf(baseturf)

/turf/open/floor/engine/blob_act(obj/structure/blob/B)
	if(prob(25))
		ChangeTurf(baseturf)


/turf/open/floor/engine/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		if(floor_tile)
			if(prob(30))
				new floor_tile(src)
				make_plating()
		else if(prob(30))
			ReplaceWithLattice(baseturf, /obj/structure/lattice)

//Other Engine Floor types
/turf/open/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/open/floor/engine/insulated
	name = "insulated reinforced floor"
	icon_state = "engine"
	insulated = TRUE
	thermal_conductivity = 0

/turf/open/floor/engine/insulated/vacuum
	name = "insulated vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0


///Engine Cult Floors
/turf/open/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"

/turf/open/floor/engine/cult/Initialize(mapload)
	. = ..()
	if(SSticker.mode)//only do this if the round is going..otherwise..fucking asteroid..
		icon_state = SSticker.cultdat.cult_floor_icon_state

/turf/open/floor/engine/cult/narsie_act()
	return

/turf/open/floor/engine/cult/ratvar_act()
	. = ..()
	if(istype(src, /turf/open/floor/engine/cult)) //if we haven't changed type
		var/previouscolor = color
		color = "#FAE48C"
		animate(src, color = previouscolor, time = 8)


///Gas-filled floor types; used in Atmos Pressure Chambers
/turf/open/floor/engine/n20
	name = "\improper N2O floor"
	sleeping_agent = 6000
	oxygen = 0
	nitrogen = 0
/turf/open/floor/engine/co2
	name = "\improper CO2 floor"
	carbon_dioxide = 50000
	oxygen = 0
	nitrogen = 0
/turf/open/floor/engine/plasma
	name = "plasma floor"
	toxins = 70000
	oxygen = 0
	nitrogen = 0
/turf/open/floor/engine/o2
	name = "\improper O2 floor"
	oxygen = 100000
	nitrogen = 0
/turf/open/floor/engine/n2
	name = "\improper N2 floor"
	nitrogen = 100000
	oxygen = 0
/turf/open/floor/engine/air
	name = "air floor"
	oxygen = 2644
	nitrogen = 10580

/* End Engine Floors */
