//This is so damaged or burnt tiles or platings don't get remembered as the default tile
GLOBAL_LIST_INIT(icons_to_ignore_at_floor_init, list("damaged1","damaged2","damaged3","damaged4",
				"damaged5","panelscorched","floorscorched1","floorscorched2","platingdmg1","platingdmg2",
				"platingdmg3","plating","light_on","light_on_flicker1","light_on_flicker2",
				"warnplate", "warnplatecorner","metalfoam", "ironfoam",
				"light_on_clicker3","light_on_clicker4","light_on_clicker5","light_broken",
				"light_on_broken","light_off","wall_thermite","grass1","grass2","grass3","grass4",
				"asteroid","asteroid_dug",
				"asteroid0","asteroid1","asteroid2","asteroid3","asteroid4",
				"asteroid5","asteroid6","asteroid7","asteroid8","asteroid9","asteroid10","asteroid11","asteroid12",
				"oldburning","light-on-r","light-on-y","light-on-g","light-on-b", "wood", "wood-broken", "carpet",
				"carpetcorner", "carpetside", "carpet", "ironsand1", "ironsand2", "ironsand3", "ironsand4", "ironsand5",
				"ironsand6", "ironsand7", "ironsand8", "ironsand9", "ironsand10", "ironsand11",
				"ironsand12", "ironsand13", "ironsand14", "ironsand15"))

/turf/open/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "dont_use_this_floor"
	plane = FLOOR_PLANE
	thermal_conductivity = 0.040
	heat_capacity = 10000
	indestructible_turf = FALSE		//Establish as not indestructible_turf
	var/icon_regular_floor = "floor" //used to remember what icon the tile should have by default
	var/icon_plating = "plating"
	var/lava = FALSE
	var/broken = FALSE
	var/burnt = FALSE
	var/current_overlay = null
	var/floor_tile = null //tile that this floor drops
	var/list/broken_states = list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5")
	var/list/burnt_states = list("floorscorched1", "floorscorched2")
	var/list/prying_tool_list = list(TOOL_CROWBAR) //What tool/s can we use to pry up the tile?


	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/open/floor/Initialize(mapload)
	. = ..()
	if(icon_state in GLOB.icons_to_ignore_at_floor_init) //so damaged/burned tiles or plating icons aren't saved as the default
		icon_regular_floor = "floor"
	else
		icon_regular_floor = icon_state

//turf/open/floor/CanPass(atom/movable/mover, turf/target, height=0)
//	if((istype(mover, /obj/machinery/vehicle) && !(burnt)))
//		if(!( locate(/obj/machinery/mass_driver, src) ))
//			return FALSE
//	return ..()

/turf/open/floor/ex_act(severity)
	if(is_shielded())
		return
	switch(severity)
		if(1.0)
			ChangeTurf(baseturf)
		if(2.0)
			switch(pick(1,2;75,3))
				if(1)
					spawn(0)
						ReplaceWithLattice()
						if(prob(33)) new /obj/item/stack/sheet/metal(src)
				if(2)
					ChangeTurf(baseturf)
				if(3)
					if(prob(80))
						break_tile_to_plating()
					else
						break_tile()
					hotspot_expose(1000,CELL_VOLUME)
					if(prob(33)) new /obj/item/stack/sheet/metal(src)
		if(3.0)
			if(prob(50))
				break_tile()
				hotspot_expose(1000,CELL_VOLUME)
	return

/turf/open/floor/burn_down()
	ex_act(2)

/turf/open/floor/is_shielded()
	for(var/obj/structure/A in contents)
		if(A.level == 3)
			return TRUE

/turf/open/floor/blob_act(obj/structure/blob/B)
	return

/turf/open/floor/proc/update_icon()
	update_visuals()
	overlays -= current_overlay
	if(current_overlay)
		overlays.Add(current_overlay)
	return TRUE

/turf/open/floor/proc/break_tile_to_plating()
	var/turf/open/floor/plating/T = make_plating()
	T.break_tile()

/turf/open/floor/break_tile()
	if(broken)
		return
	current_overlay = pick(broken_states)
	broken = TRUE
	update_icon()

/turf/open/floor/burn_tile()
	if(burnt)
		return
	current_overlay = pick(burnt_states)
	burnt = TRUE
	update_icon()

/turf/open/floor/proc/make_plating()
	return ChangeTurf(/turf/open/floor/plating)

/turf/open/floor/ChangeTurf(turf/open/floor/T, defer_change = FALSE, keep_icon = TRUE, ignore_air = FALSE)
	if(!istype(src, /turf/open/floor))
		return ..() //fucking turfs switch the fucking src of the fucking running procs
	if(!ispath(T, /turf/open/floor))
		return ..()

	var/old_icon = icon_regular_floor
	var/old_plating = icon_plating
	var/old_dir = dir

	var/turf/open/floor/W = ..()

	if(keep_icon)
		W.icon_regular_floor = old_icon
		W.icon_plating = old_plating
		W.dir = old_dir

	W.update_icon()
	return W

/turf/open/floor/attackby(obj/item/C, mob/user params)
	if(!C || !user)
		return TRUE
	if(..())
		return TRUE
	if(intact && istype(C, /obj/item/stack/tile))
		try_replace_tile(C, user, params)
	if(istype(C, /obj/item/pipe))
		var/obj/item/pipe/P = C
		if(P.pipe_type != -1) // ANY PIPE
			user.visible_message( \
				"[user] starts sliding [P] along \the [src].", \
				"<span class='notice'>You slide [P] along \the [src].</span>", \
				"You hear the scrape of metal against something.")
			user.drop_item()

			if(P.is_bent_pipe())  // bent pipe rotation fix see construction.dm
				P.dir = 5
				if(user.dir == 1)
					P.dir = 6
				else if(user.dir == 2)
					P.dir = 9
				else if(user.dir == 4)
					P.dir = 10
			else
				P.setDir(user.dir)
			P.x = src.x
			P.y = src.y
			P.z = src.z
			P.forceMove(src)
			return TRUE
	return FALSE

/turf/open/floor/crowbar_act(mob/user, obj/item/I)
	if(!intact)
		return
	. = TRUE
	if(!I.use_tool(src, user, 0, volume = I.tool_volume))
		return
	pry_tile(I, user, TRUE)

/turf/open/floor/proc/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	if(T.turf_type == type)
		return
	var/obj/item/thing = user.get_inactive_hand()
	if(!thing || !prying_tool_list.Find(thing.tool_behaviour))
		return
	var/turf/open/floor/plating/P = pry_tile(thing, user, TRUE)
	if(!istype(P))
		return
	P.attackby(T, user, params)

/turf/open/floor/proc/pry_tile(obj/item/C, mob/user, silent = FALSE)
	if(!silent)
		playsound(src, C.usesound, 80, 1)
	return remove_tile(user, silent)

/turf/open/floor/proc/remove_tile(mob/user, silent = FALSE, make_tile = TRUE)
	if(broken || burnt)
		broken = 0
		burnt = 0
		current_overlay = null
		if(user && !silent)
			to_chat(user, "<span class='danger'>You remove the broken plating.</span>")
	else
		if(user && !silent)
			to_chat(user, "<span class='danger'>You remove the floor tile.</span>")
		if(floor_tile && make_tile)
			new floor_tile(src)
	return make_plating()

/turf/open/floor/singularity_pull(S, current_size)
	..()
	if(current_size == STAGE_THREE)
		if(prob(30))
			if(floor_tile)
				new floor_tile(src)
				make_plating()
	else if(current_size == STAGE_FOUR)
		if(prob(50))
			if(floor_tile)
				new floor_tile(src)
				make_plating()
	else if(current_size >= STAGE_FIVE)
		if(floor_tile)
			if(prob(70))
				new floor_tile(src)
				make_plating()
		else if(prob(50))
			ReplaceWithLattice()

/turf/open/floor/narsie_act()
	if(prob(20))
		ChangeTurf(/turf/open/floor/engine/cult)

/turf/open/floor/ratvar_act(force, ignore_mobs)
	. = ..()
	if(.)
		ChangeTurf(/turf/open/floor/clockwork)

/turf/open/floor/acid_melt()
	ChangeTurf(baseturf)

/turf/open/floor/can_have_cabling()
	return !burnt && !broken


/* Engine Floors */
/turf/open/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	var/insulated
	heat_capacity = 325000
	floor_tile = /obj/item/stack/rods

/turf/open/floor/engine/break_tile()
	return //unbreakable

/turf/open/floor/engine/burn_tile()
	return //unburnable

/turf/open/floor/engine/make_plating(force = 0)
	if(force)
		..()
	return //unplateable

/turf/open/floor/engine/attack_hand(mob/user)
	user.Move_Pulled(src)

/turf/open/floor/engine/pry_tile(obj/item/C, mob/user, silent = FALSE)
	return

/turf/open/floor/engine/acid_act(acidpwr, acid_volume)
	acidpwr = min(acidpwr, 50) //we reduce the power so reinf floor never get melted.
	. = ..()

/turf/open/floor/engine/attackby(obj/item/C, mob/user, params)
	if(!C || !user)
		return
	if(istype(C, /obj/item/wrench))
		to_chat(user, "<span class='notice'>You begin removing rods...</span>")
		playsound(src, C.usesound, 80, 1)
		if(do_after(user, 30 * C.toolspeed, target = src))
			if(!istype(src, /turf/open/floor/engine))
				return
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/open/floor/plating)
			return

	if(istype(C, /obj/item/stack/sheet/plasteel) && !insulated) //Insulating the floor
		to_chat(user, "<span class='notice'>You begin insulating [src]...</span>")
		if(do_after(user, 40, target = src) && !insulated) //You finish insulating the insulated insulated insulated insulated insulated insulated insulated insulated vacuum floor
			to_chat(user, "<span class='notice'>You finish insulating [src].</span>")
			var/obj/item/stack/sheet/plasteel/W = C
			W.use(1)
			thermal_conductivity = 0
			insulated = TRUE
			name = "insulated " + name
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

/turf/open/floor/engine/cult/narsie_act()
	return

/turf/open/floor/engine/cult/ratvar_act()
	. = ..()
	if(istype(src, /turf/open/floor/engine/cult)) //if we haven't changed type
		var/previouscolor = color
		color = "#FAE48C"
		animate(src, color = previouscolor, time = 8)


/turf/open/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"

/turf/open/floor/engine/cult/Initialize(mapload)
	. = ..()
	if(SSticker.mode)//only do this if the round is going..otherwise..fucking asteroid..
		icon_state = SSticker.cultdat.cult_floor_icon_state


//air filled floors; used in atmos pressure chambers

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


/turf/open/floor/engine/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		if(floor_tile)
			if(prob(30))
				new floor_tile(src)
				make_plating()
		else if(prob(30))
			ReplaceWithLattice()

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

/* End Engine Floors */

//Snow
/turf/open/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
