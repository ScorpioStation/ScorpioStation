/obj/structure/carving
	name = "statue"
	desc = "Placeholder. Yell at Firecage if you SOMEHOW see this."
	icon = 'icons/obj/statue.dmi'
	icon_state = ""
	density = 1
	anchored = 0
	max_integrity = 100
	var/oreAmount = 5
	var/material_drop_type = /obj/item/stack/sheet/metal
	var/material = "metal"
	var/last_event = 0
	var/active = null
	var/spam_flag = 0

/obj/structure/carving/New(loc, var/param_color = null)
	..()
	switch(material)
		if("uranium")
			max_integrity = 300
			light_range = 2
			material_drop_type = /obj/item/stack/sheet/mineral/uranium
		if("plasma")
			max_integrity = 200
			material_drop_type = /obj/item/stack/sheet/mineral/plasma
		if("gold")
			max_integrity = 300
			material_drop_type = /obj/item/stack/sheet/mineral/gold
		if("silver")
			max_integrity = 300
			material_drop_type = /obj/item/stack/sheet/mineral/silver
		if("diamond")
			max_integrity = 1000
			material_drop_type = /obj/item/stack/sheet/mineral/diamond
		if("bananium")
			max_integrity = 300
			material_drop_type = /obj/item/stack/sheet/mineral/bananium
		if("sandsone")
			max_integrity = 50
			material_drop_type = /obj/item/stack/sheet/mineral/sandstone
		if("tranquillite")
			max_integrity = 300
			material_drop_type = /obj/item/stack/sheet/mineral/tranquillite
	obj_integrety = max_integrity

/obj/structure/carving/attackby(obj/item/W, mob/living/user, params)
	add_fingerprint(user)
	switch(material)
		if("uranium")
			radiate()
		if("plasma")
			if(is_hot(W) > 300)//If the temperature of the object is over 300, then ignite
				message_admins("[key_name_admin(user)] ignited a plasma statue at [COORD(loc)]")
				log_game("[key_name(user)] ignited plasma a statue at [COORD(loc)]")
				investigate_log("[key_name(user)] ignited a plasma statue at [COORD(loc)]", "atmos")
				ignite(is_hot(W))
				return
		if("bananium")
			honk()
	if(!(flags & NODECONSTRUCT))
		if(default_unfasten_wrench(user, W))
			return
		if(istype(W, /obj/item/gun/energy/plasmacutter))
			playsound(src, W.usesound, 100, 1)
			user.visible_message("[user] is slicing apart the [name]...", \
								 "<span class='notice'>You are slicing apart the [name]...</span>")
			if(do_after(user, 40 * W.toolspeed, target = src))
				if(!loc)
					return
				user.visible_message("[user] slices apart the [name].", \
									 "<span class='notice'>You slice apart the [name].</span>")
				deconstruct(TRUE)
			return
	return ..()

/obj/structure/carving/bullet_act(obj/item/projectile/P)
	if(material == "plasma")
		if(!QDELETED(src)) //wasn't deleted by the projectile's effects.
			if(!P.nodamage && ((P.damage_type == BURN) || (P.damage_type == BRUTE)))
				if(P.firer)
					message_admins("[key_name_admin(P.firer)] ignited a plasma statue with [P.name] at [COORD(loc)]")
					log_game("[key_name(P.firer)] ignited a plasma statue with [P.name] at [COORD(loc)]")
					investigate_log("[key_name(P.firer)] ignited a plasma statue with [P.name] at [COORD(loc)]", "atmos")
				else
					message_admins("A plasma statue was ignited with [P.name] at [COORD(loc)]. No known firer.")
					log_game("A plasma statue was ignited with [P.name] at [COORD(loc)]. No known firer.")
				PlasmaBurn()
	..()

/obj/structure/carving/welder_act(mob/user, obj/item/I)
	if(material == "plasma")
		. = TRUE
		if(!I.use_tool(src, user, volume = I.tool_volume))
			return
		user.visible_message("<span class='danger'>[user] sets [src] on fire!</span>",\
							"<span class='danger'>[src] disintegrates into a cloud of plasma!</span>",\
							"<span class='warning'>You hear a 'whoompf' and a roar.</span>")
		message_admins("[key_name_admin(user)] ignited a plasma statue at [COORD(loc)]")
		log_game("[key_name(user)] ignited plasma a statue at [COORD(loc)]")
		investigate_log("[key_name(user)] ignited a plasma statue at [COORD(loc)]", "atmos")
		ignite(2500)

/obj/structure/carving/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(material == "plasma")
		if(exposed_temperature > 300)
			PlasmaBurn(exposed_temperature)

/obj/structure/carving/welder_act(mob/user, obj/item/I)
	if(anchored)
		return
	. = TRUE
	if(!I.tool_use_check(user, 0))
		return
	WELDER_ATTEMPT_SLICING_MESSAGE
	if(I.use_tool(src, user, 40, volume = I.tool_volume))
		WELDER_SLICING_SUCCESS_MESSAGE
		deconstruct(TRUE)


/obj/structure/carving/attack_hand(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)
	user.visible_message("[user] rubs some dust off from the [name]'s surface.", \
						 "<span class='notice'>You rub some dust off from the [name]'s surface.</span>")
	switch(material)
		if("uranium")
			radiate()
		if("bananium")
			honk()

/obj/structure/carving/Bumped(atom/user)
	switch(material)
		if("uranium")
			radiate()
		if("bananium")
			honk()
	..()

/obj/structure/carving/CanAtmosPass()
	return !density

/obj/structure/carving/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		if(material_drop_type)
			var/drop_amt = oreAmount
			if(!disassembled)
				drop_amt -= 2
			if(drop_amt > 0)
				new material_drop_type(get_turf(src), drop_amt)
	qdel(src)

/obj/structure/carving/proc/radiate()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/L in range(3,src))
				L.apply_effect(12,IRRADIATE,0)
			last_event = world.time
			active = null

/obj/structure/carving/proc/PlasmaBurn()
	atmos_spawn_air(LINDA_SPAWN_HEAT | LINDA_SPAWN_TOXINS, 160)
	deconstruct(FALSE)

/obj/structure/carving/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn()

/obj/structure/carving/proc/honk()
	if(!spam_flag)
		spam_flag = 1
		playsound(loc, 'sound/items/bikehorn.ogg', 50, 1)
		spawn(20)
			spam_flag = 0

/obj/structure/carving/block
	desc = "A huge block of material."

/obj/structure/carving/statue
	var/icon/generated_icon

/obj/structure/carving/block/uranium
	name = "uranium block"
	material = "uranium"

/obj/structure/carving/statue/uranium/nuke
	name = "statue of a nuclear fission explosive"
	desc = "This is a grand statue of a Nuclear Explosive. It has a sickening green colour."
	icon_state = "nuke"
	material = "uranium"

/obj/structure/carving/statue/uranium/eng
	name = "statue of an engineer"
	desc = "This statue has a sickening green colour."
	icon_state = "eng"
	material = "uranium"

/obj/structure/carving/block/plasma
	name = "plasma block"
	material = "plasma"

/obj/structure/carving/statue/plasma/scientist
	name = "statue of a scientist"
	desc = "This statue is suitably made from plasma."
	icon_state = "sci"
	material = "plasma"

/obj/structure/carving/statue/plasma/xeno
	name = "statue of a xenomorph"
	desc = "This statue is suitably made from plasma."
	icon_state = "xeno"
	material = "plasma"

/obj/structure/carving/block/gold
	name = "gold block"
	material = "gold"

/obj/structure/carving/statue/gold
	desc = "This is a highly valuable statue made from gold."
	material = "gold"

/obj/structure/carving/statue/gold/hos
	name = "statue of the head of security"
	icon_state = "hos"

/obj/structure/carving/statue/gold/hop
	name = "statue of the head of personnel"
	icon_state = "hop"

/obj/structure/carving/statue/gold/cmo
	name = "statue of the chief medical officer"
	icon_state = "cmo"

/obj/structure/carving/statue/gold/ce
	name = "statue of the chief engineer"
	icon_state = "ce"

/obj/structure/carving/statue/gold/rd
	name = "statue of the research director"
	icon_state = "rd"

/obj/structure/carving/block/silver
	name = "silver block"
	material = "silver"

/obj/structure/carving/statue/silver/
	desc = "This is a valuable statue made from silver."
	material = "silver"

/obj/structure/carving/statue/silver/md
	name = "statue of a medical doctor"
	icon_state = "md"

/obj/structure/carving/statue/silver/janitor
	name = "statue of a janitor"
	icon_state = "jani"

/obj/structure/carving/statue/silver/sec
	name = "statue of a security officer"
	icon_state = "sec"

/obj/structure/carving/statue/silver/secborg
	name = "statue of a security cyborg"
	icon_state = "secborg"

/obj/structure/carving/statue/silver/medborg
	name = "statue of a medical cyborg"
	icon_state = "medborg"

/obj/structure/carving/block/diamond
	name = "diamond block"
	icon_state = "block_diamond"
	material = "diamond"

/obj/structure/carving/statue/diamond
	desc = "This is a very expensive diamond statue."
	material = "diamond"

/obj/structure/carving/statue/diamond/captain
	name = "statue of THE captain"
	icon_state = "cap"

/obj/structure/carving/statue/diamond/ai1
	name = "statue of the AI hologram"
	icon_state = "ai1"

/obj/structure/carving/statue/diamond/ai2
	name = "statue of the AI core"
	icon_state = "ai2"

/obj/structure/carving/block/bananium
	name = "bananium block"
	material = "bananium"

/obj/structure/carving/statue/bananium
	desc = "A bananium statue with a small engraving:'HOOOOOOONK'."
	material = "bananium"

/obj/structure/carving/statue/bananium/clown
	name = "statue of a clown"
	icon_state = "clown"

/obj/structure/carving/block/sandstone
	name = "sandstone block"
	material = "sandstone"

/obj/structure/carving/statue/sandstone
	material = "sandstone"

/obj/structure/carving/statue/sandstone/assistant
	name = "statue of an assistant"
	desc = "A cheap statue of sandstone for a greyshirt."
	icon_state = "assist"

/obj/structure/carving/statue/sandstone/venus //call me when we add marble i guess
	name = "statue of a pure maiden"
	desc = "An ancient marble statue. The subject is depicted with a floor-length braid and is wielding a toolbox. By Jove, it's easily the most gorgeous depiction of a woman you've ever seen. The artist must truly be a master of his craft. Shame about the broken arm, though."
	icon = 'icons/obj/statuelarge.dmi'
	icon_state = "venus"

/obj/structure/carving/block/tranquillite
	name = "tranquilite block"
	material = "tranquillite"

/obj/structure/carving/statue/tranquillite/mime
	name = "statue of a mime"
	desc = "..."
	icon_state = "mime"
	material = "tranquillite"

/obj/structure/carving/statue/tranquillite/mime/AltClick(mob/user)//has 4 dirs
	if(user.incapacitated())
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return
	if(!Adjacent(user))
		return
	if(anchored)
		to_chat(user, "It is fastened to the floor!")
		return
	setDir(turn(dir, 90))


////////////////////////////////

/obj/structure/snowman
	name = "snowman"
	desc = "Seems someone made a snowman here."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "snowman"
	anchored = TRUE
	density = TRUE
	max_integrity = 50

/obj/structure/snowman/built
	desc = "Just like the ones you remember from childhood!"

/obj/structure/snowman/built/Destroy()
	new /obj/item/reagent_containers/food/snacks/grown/carrot(drop_location())
	new /obj/item/grown/log(drop_location())
	new /obj/item/grown/log(drop_location())
	return ..()

/obj/structure/snowman/built/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/snowball) && obj_integrity < max_integrity)
		to_chat(user, "<span class='notice'>You patch some of the damage on [src] with [I].</span>")
		obj_integrity = max_integrity
		qdel(I)
	else
		return ..()

/obj/structure/snowman/built/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume, global_overlay = TRUE)
	..()
	qdel(src)


////////////////////////////////

/obj/item/chisel
	name = "chisel"
	desc = "A carving tool."
	icon = 'icons/obj/statue.dmi'
	icon_state = "chisel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	materials = list(MAT_METAL=75)
	attack_verb = list("stabbed")
	hitsound = 'sound/weapons/bladeslice.ogg'
	usesound = 'sound/items/gavel.ogg'
	var/tool_speed = 100
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 30)


/obj/item/chisel/afterattack(atom/target, mob/living/carbon/user)
	if(istype(target,/obj/structure/carving/block))
		var/obj/structure/carving/C = target
		var/list/availablestatues = typesof(text2path("/obj/structure/carving/statue/[C.material]"))
		availablestatues -= text2path("/obj/structure/carving/statue/[C.material]")
		var/list/finallist = list()
		for(var/S2 in availablestatues)
			var/obj/structure/carving/statue/S = new S2
			finallist += S
		for(var/mob/living/L in oview(7,user))
			finallist += L
		var/chosenstatue = input(user, "What do you want to carve?", "Carving") as null|anything in finallist
		if(chosenstatue)
			user.visible_message("<span class='notice'>[user] starts to carve [C].</span>", "<span class='notice'>You start carving [C].</span>", "<span class='hear'>You hear a chipping sound.</span>")
			playsound(loc, 'sound/items/gavel.ogg', 50, TRUE, -1)
			if(do_after(user, tool_speed, target = C))
				playsound(loc, 'sound/items/gavel.ogg', 50, TRUE, -1)
				if(istype(chosenstatue,/obj/structure/carving/statue))
					var/obj/structure/carving/statue/finalstatue = chosenstatue
					new finalstatue.type(C.loc)
					qdel(C)
					user.visible_message("<span class='notice'>[user] finishes carving [finalstatue].</span>", "<span class='notice'>You finish carving [finalstatue].</span>")
				else if(istype(chosenstatue,/mob/living))
					var/mob/living/mobstatue = chosenstatue
					var/path = text2path("/obj/structure/carving/statue/[C.material]")
					var/obj/structure/carving/statue/finalstatue = new path(C.loc)
					finalstatue.generated_icon = getFlatIcon(mobstatue)
					var/mutable_appearance/detail = mutable_appearance(finalstatue.generated_icon)
					finalstatue.add_overlay(detail)
					finalstatue.name = "[C.material] statue of [chosenstatue]"
					qdel(C)
					user.visible_message("<span class='notice'>[user] finishes carving [finalstatue].</span>", "<span class='notice'>You finish carving [finalstatue].</span>")
	else
		return ..()