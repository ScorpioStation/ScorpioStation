/*
 * Root Vegetables
 */

// Carrot
/obj/item/seeds/carrot
	name = "pack of carrot seeds"
	desc = "These seeds grow into carrots."
	icon_state = "seed-carrot"
	species = "carrot"
	plantname = "Carrots"
	product = /obj/item/reagent_containers/food/snacks/grown/carrot
	maturation = 10
	production = 1
	yield = 5
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	mutatelist = list(/obj/item/seeds/carrot/parsnip)
	reagents_add = list("oculine" = 0.25, "vitamin" = 0.04, "plantmatter" = 0.05)

/obj/item/reagent_containers/food/snacks/grown/carrot
	seed = /obj/item/seeds/carrot
	name = "carrot"
	desc = "It's good for the eyes!"
	icon_state = "carrot"
	filling_color = "#FFA500"
	bitesize_mod = 2
	tastes = list("carrot" = 1)
	wine_power = 0.3

/obj/item/reagent_containers/food/snacks/grown/carrot/wedges
	name = "carrot wedges"
	desc = "Slices of neatly cut carrot."
	icon_state = "carrot_wedges"
	filling_color = "#FFA500"
	bitesize_mod = 2

/obj/item/reagent_containers/food/snacks/grown/carrot/attackby(obj/item/I, mob/user, params)
	if(is_sharp(I))
		to_chat(user, "<span class='notice'>You sharpen the carrot into a shiv with [I].</span>")
		var/obj/item/kitchen/knife/carrotshiv/Shiv = new /obj/item/kitchen/knife/carrotshiv
		if(!remove_item_from_storage(user))
			user.unEquip(src)
		user.put_in_hands(Shiv)
		qdel(src)
	else
		return ..()


// Parsnip
/obj/item/seeds/carrot/parsnip
	name = "pack of parsnip seeds"
	desc = "These seeds grow into parsnips."
	icon_state = "seed-parsnip"
	species = "parsnip"
	plantname = "Parsnip"
	product = /obj/item/reagent_containers/food/snacks/grown/parsnip
	icon_dead = "carrot-dead"
	mutatelist = list()
	reagents_add = list("vitamin" = 0.05, "plantmatter" = 0.05)

/obj/item/reagent_containers/food/snacks/grown/parsnip
	seed = /obj/item/seeds/carrot/parsnip
	name = "parsnip"
	desc = "Closely related to carrots."
	icon_state = "parsnip"
	bitesize_mod = 2
	tastes = list("parsnip" = 1)
	wine_power = 0.35


// White-Beet
/obj/item/seeds/whitebeet
	name = "pack of white beet seeds"
	desc = "These seeds grow into sugary beet producing plants."
	icon_state = "seed-whitebeet"
	species = "whitebeet"
	plantname = "White Beet Plants"
	product = /obj/item/reagent_containers/food/snacks/grown/whitebeet
	lifespan = 60
	endurance = 50
	yield = 6
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_dead = "whitebeet-dead"
	mutatelist = list(/obj/item/seeds/redbeet)
	reagents_add = list("vitamin" = 0.04, "sugar" = 0.2, "plantmatter" = 0.05)

/obj/item/reagent_containers/food/snacks/grown/whitebeet
	seed = /obj/item/seeds/whitebeet
	name = "white beet"
	desc = "You can't beat white beet."
	icon_state = "whitebeet"
	filling_color = "#F4A460"
	bitesize_mod = 2
	tastes = list("white beet" = 1)
	wine_power = 0.4

// Red Beet
/obj/item/seeds/redbeet
	name = "pack of redbeet seeds"
	desc = "These seeds grow into red beet producing plants."
	icon_state = "seed-redbeet"
	species = "redbeet"
	plantname = "Red Beet Plants"
	product = /obj/item/reagent_containers/food/snacks/grown/redbeet
	lifespan = 60
	endurance = 50
	yield = 6
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_dead = "whitebeet-dead"
	genes = list(/datum/plant_gene/trait/maxchem)
	reagents_add = list("vitamin" = 0.05, "plantmatter" = 0.05)

/obj/item/reagent_containers/food/snacks/grown/redbeet
	seed = /obj/item/seeds/redbeet
	name = "red beet"
	desc = "You can't beat red beet."
	icon_state = "redbeet"
	tastes = list("red beet" = 1)
	bitesize_mod = 2
	wine_power = 0.6

/*
 * Corn
 */
// Corn
/obj/item/seeds/corn
	name = "pack of corn seeds"
	desc = "I don't mean to sound corny..."
	icon_state = "seed-corn"
	species = "corn"
	plantname = "Corn Stalks"
	product = /obj/item/reagent_containers/food/snacks/grown/corn
	maturation = 8
	potency = 20
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "corn-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "corn-dead" // Same for the dead icon
	mutatelist = list(/obj/item/seeds/corn/snapcorn)
	reagents_add = list("cornoil" = 0.2, "vitamin" = 0.04, "plantmatter" = 0.1)

/obj/item/reagent_containers/food/snacks/grown/corn
	seed = /obj/item/seeds/corn
	name = "ear of corn"
	desc = "Needs some butter!"
	icon_state = "corn"
	cooked_type = /obj/item/reagent_containers/food/snacks/popcorn
	filling_color = "#FFFF00"
	trash = /obj/item/grown/corncob
	bitesize_mod = 2
	tastes = list("corn" = 1)
	distill_reagent = "whiskey"
	wine_power = 0.4

/obj/item/grown/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon_state = "corncob"
	item_state = "corncob"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7

/obj/item/grown/corncob/attackby(obj/item/grown/W, mob/user, params)
	if(is_sharp(W))
		to_chat(user, "<span class='notice'>You use [W] to fashion a pipe out of the corn cob!</span>")
		new /obj/item/clothing/mask/cigarette/pipe/cobpipe (user.loc)
		user.unEquip(src)
		qdel(src)
		return
	else
		return ..()

// Snapcorn
/obj/item/seeds/corn/snapcorn
	name = "pack of snapcorn seeds"
	desc = "Oh snap!"
	icon_state = "seed-snapcorn"
	species = "snapcorn"
	plantname = "Snapcorn Stalks"
	product = /obj/item/grown/snapcorn
	mutatelist = list()
	rarity = 10

/obj/item/grown/snapcorn
	seed = /obj/item/seeds/corn/snapcorn
	name = "snap corn"
	desc = "A cob with snap pops."
	icon_state = "snapcorn"
	item_state = "corncob"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/snap_pops = 1

/obj/item/grown/snapcorn/add_juice()
	..()
	snap_pops = max(round(seed.potency/8), 1)

/obj/item/grown/snapcorn/attack_self(mob/user)
	..()
	to_chat(user, "<span class='notice'>You pick a snap pop from the cob.</span>")
	var/obj/item/toy/snappop/S = new /obj/item/toy/snappop(user.loc)
	if(ishuman(user))
		user.put_in_hands(S)
	snap_pops -= 1
	if(!snap_pops)
		new /obj/item/grown/corncob(user.loc)
		qdel(src)

/*
 * Garlic
 */
/obj/item/seeds/garlic
	name = "pack of garlic seeds"
	desc = "A packet of extremely pungent seeds."
	icon_state = "seed-garlic"
	species = "garlic"
	plantname = "Garlic Sprouts"
	product = /obj/item/reagent_containers/food/snacks/grown/garlic
	yield = 6
	potency = 25
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	reagents_add = list("garlic" = 0.15, "plantmatter" = 0.1)

/obj/item/reagent_containers/food/snacks/grown/garlic
	seed = /obj/item/seeds/garlic
	name = "garlic"
	desc = "Delicious, but with a potentially overwhelming odor."
	icon_state = "garlic"
	filling_color = "#C0C9A0"
	bitesize_mod = 2
	tastes = list("garlic" = 1)
	wine_power = 0.1

/*
 * Onions
 */
/obj/item/seeds/onion
	name = "pack of onion seeds"
	desc = "These seeds grow into onions."
	icon_state = "seed-onion"
	species = "onion"
	plantname = "Onion Sprouts"
	product = /obj/item/reagent_containers/food/snacks/grown/onion
	lifespan = 20
	maturation = 3
	production = 4
	yield = 6
	endurance = 25
	growthstages = 3
	weed_chance = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	reagents_add = list("vitamin" = 0.04, "plantmatter" = 0.1)
	mutatelist = list(/obj/item/seeds/onion/red)

/obj/item/reagent_containers/food/snacks/grown/onion
	seed = /obj/item/seeds/onion
	name = "onion"
	desc = "Nothing to cry over."
	icon_state = "onion"
	filling_color = "#C0C9A0"
	bitesize_mod = 2
	slice_path = /obj/item/reagent_containers/food/snacks/onion_slice
	tastes = list("onion" = 1, "pungentness" = 1)
	slices_num = 2
	wine_power = 0.3
	wine_flavor = "pungentness"

/obj/item/seeds/onion/red
	name = "pack of red onion seeds"
	desc = "For growing exceptionally potent onions."
	icon_state = "seed-onionred"
	species = "onion_red"
	plantname = "Red Onion Sprouts"
	weed_chance = 1
	product = /obj/item/reagent_containers/food/snacks/grown/onion/red
	reagents_add = list("vitamin" = 0.04, "plantmatter" = 0.1, "onionjuice" = 0.05)

/obj/item/reagent_containers/food/snacks/grown/onion/red
	seed = /obj/item/seeds/onion/red
	name = "red onion"
	desc = "Purple despite the name."
	icon_state = "onion_red"
	filling_color = "#C29ACF"
	slice_path = /obj/item/reagent_containers/food/snacks/onion_slice/red
	tastes = list("red onion" = 1, "pungentness" = 3)
	wine_power = 0.6
	wine_flavor = "powerful pungentness"

/obj/item/reagent_containers/food/snacks/onion_slice
	name = "onion slices"
	desc = "Rings, not for wearing."
	icon_state = "onionslice"
	list_reagents = list("plantmatter" = 5, "vitamin" = 2)
	filling_color = "#C0C9A0"
	tastes = list("onion" = 1, "pungentness" = 1)
	gender = PLURAL
	cooked_type = /obj/item/reagent_containers/food/snacks/onionrings

/obj/item/reagent_containers/food/snacks/onion_slice/red
	name = "red onion slices"
	desc = "They shine like exceptionally low quality amethyst."
	icon_state = "onionslice_red"
	filling_color = "#C29ACF"
	tastes = list("red onion" = 1, "pungentness" = 3)
	list_reagents = list("plantmatter" = 5, "vitamin" = 2, "onionjuice" = 2.5)

/*
 * Potatoes
 */
// Potato
/obj/item/seeds/potato
	name = "pack of potato seeds"
	desc = "Boil 'em! Mash 'em! Stick 'em in a stew!"
	icon_state = "seed-potato"
	species = "potato"
	plantname = "Potato Plants"
	product = /obj/item/reagent_containers/food/snacks/grown/potato
	lifespan = 30
	maturation = 10
	production = 1
	yield = 4
	growthstages = 4
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "potato-grow"
	icon_dead = "potato-dead"
	genes = list(/datum/plant_gene/trait/battery)
	mutatelist = list(/obj/item/seeds/potato/sweet)
	reagents_add = list("vitamin" = 0.04, "plantmatter" = 0.1)

/obj/item/reagent_containers/food/snacks/grown/potato
	seed = /obj/item/seeds/potato
	name = "potato"
	desc = "Boil 'em! Mash 'em! Stick 'em in a stew!"
	icon_state = "potato"
	filling_color = "#E9967A"
	tastes = list("potato" = 1)
	bitesize = 100
	distill_reagent = "vodka"


/obj/item/reagent_containers/food/snacks/grown/potato/wedges
	name = "potato wedges"
	desc = "Slices of neatly cut potato."
	icon_state = "potato_wedges"
	filling_color = "#E9967A"
	tastes = list("potato" = 1)
	bitesize = 100
	distill_reagent = "sbiten"


/obj/item/reagent_containers/food/snacks/grown/potato/attackby(obj/item/W, mob/user, params)
	if(is_sharp(W))
		to_chat(user, "<span class='notice'>You cut the potato into wedges with [W].</span>")
		var/obj/item/reagent_containers/food/snacks/grown/potato/wedges/Wedges = new /obj/item/reagent_containers/food/snacks/grown/potato/wedges
		if(!remove_item_from_storage(user))
			user.unEquip(src)
		user.put_in_hands(Wedges)
		qdel(src)
	else
		return ..()


// Sweet Potato
/obj/item/seeds/potato/sweet
	name = "pack of sweet potato seeds"
	desc = "These seeds grow into sweet potato plants."
	icon_state = "seed-sweetpotato"
	species = "sweetpotato"
	plantname = "Sweet Potato Plants"
	product = /obj/item/reagent_containers/food/snacks/grown/potato/sweet
	mutatelist = list()
	reagents_add = list("vitamin" = 0.1, "sugar" = 0.1, "plantmatter" = 0.1)

/obj/item/reagent_containers/food/snacks/grown/potato/sweet
	seed = /obj/item/seeds/potato/sweet
	name = "sweet potato"
	desc = "It's sweet."
	tastes = list("sweet potato" = 1)
	icon_state = "sweetpotato"
