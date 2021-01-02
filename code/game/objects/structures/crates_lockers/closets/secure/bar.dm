/obj/structure/closet/secure_closet/bar
	name = "Booze cabinet"
	req_access = list(ACCESS_BAR)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"
	resistance_flags = FLAMMABLE
	max_integrity = 70

/obj/structure/closet/secure_closet/bar/populate_contents()
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)
	new /obj/item/reagent_containers/food/drinks/cans/beer(src)

/obj/structure/closet/secure_closet/bar/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened


/obj/structure/closet/secure_closet/bouncer
	name = "bouncer's locker"
	req_access = list(ACCESS_BAR)
	icon_state = "secure1"
	icon_broken = "securebroken"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_off    = "secureoff"
	icon_opened = "secureopen"


/obj/structure/closet/secure_closet/bouncer/New()
	..()
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/under/fluff/elishirt(src)
	new /obj/item/clothing/accessory/black(src)
	new /obj/item/radio/headset/headset_service(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/lighter/zippo(src)
	new /obj/item/clothing/suit/armor/vest/old(src)
	new /obj/item/restraints/handcuffs/cable/zipties(src)
	new /obj/item/melee/classic_baton/telescopic(src)
	new /obj/item/flash(src)
