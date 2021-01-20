/turf/open/floor/vault
	icon = 'icons/turf/floors.dmi'
	icon_state = "rockvault"
	smooth = SMOOTH_FALSE

/turf/simulated/wall/vault
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"
	smooth = SMOOTH_FALSE

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

/turf/open/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/open/floor/beach/pry_tile(obj/item/C, mob/user, silent = FALSE)
	return

/turf/open/floor/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/open/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/open/floor/beach/coastline_t
	name = "coastline"
	desc = "Tide's high tonight. Charge your batons."
	icon_state = "sandwater_t"

/turf/open/floor/beach/coastline_b
	name = "coastline"
	icon_state = "sandwater_b"

/turf/open/floor/beach/water // TODO - Refactor water so they share the same parent type - Or alternatively component something like that
	name = "water"
	icon_state = "water"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/obj/machinery/poolcontroller/linkedcontroller = null

/turf/open/floor/beach/water/Initialize(mapload)
	. = ..()
	var/image/overlay_image = image('icons/misc/beach.dmi', icon_state = "water5", layer = ABOVE_MOB_LAYER)
	overlay_image.plane = GAME_PLANE
	overlays += overlay_image

/turf/open/floor/beach/water/Entered(atom/movable/AM, atom/OldLoc)
	. = ..()
	if(!linkedcontroller)
		return
	if(ismob(AM))
		linkedcontroller.mobinpool += AM

/turf/open/floor/beach/water/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	if(!linkedcontroller)
		return
	if(ismob(AM))
		linkedcontroller.mobinpool -= AM

/turf/open/floor/beach/water/InitializedOn(atom/A)
	if(!linkedcontroller)
		return
	if(istype(A, /obj/effect/decal/cleanable)) // Better a typecheck than looping through thousands of turfs everyday
		linkedcontroller.decalinpool += A

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

/turf/open/floor/clockwork/ReplaceWithLattice()
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


/turf/open/floor/gym
	name = "wrestling mat"
	icon = 'icons/misc/wrestling_ring.dmi'
	icon_state = "ring_9"


/turf/open/floor/rubber
	name = "rubber floor"
	icon = 'icons/misc/wrestling_ring.dmi'
	icon_state = "rubber_carpet"
