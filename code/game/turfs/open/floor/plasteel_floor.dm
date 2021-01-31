/turf/open/floor/plasteel
	icon_state = "floor"
	floor_tile = /obj/item/stack/tile/plasteel
	broken_states = list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5")
	burnt_states = list("floorscorched1", "floorscorched2")

/turf/open/floor/plasteel/update_icon()
	if(!..())
		return FALSE
	if(!broken && !burnt)
		icon_state = icon_regular_floor

/turf/open/floor/plasteel/airless
	name = "airless floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/open/floor/plasteel/airless/Initialize(mapload)
	. = ..()
	name = "floor"

/turf/open/floor/plasteel/airless/bombtest // For bomb testing range

/turf/open/floor/plasteel/airless/bombtest/ex_act(severity)	//Sure. Why not. Why not.
	return

/turf/open/floor/plasteel/goonplaque
	icon_state = "plaque"
	name = "Commemorative Plaque"
	desc = "\"This is a plaque in honour of our comrades on the G4407 Stations. Hopefully TG4407 model can live up to your fame and fortune.\" Scratched in beneath that is a crude image of a meteor and a spaceman. The spaceman is laughing. The meteor is exploding."

//TODO: Make subtypes for all normal turf icons
/turf/open/floor/plasteel/freezer
	icon_state = "freezerfloor"
/turf/open/floor/plasteel/grimy
	icon_state = "grimy"

/turf/open/floor/plasteel/dark
	icon_state = "darkfull"

/turf/open/floor/plasteel/dark/telecomms
	nitrogen = 100
	oxygen = 0
	temperature = 80

/turf/open/floor/plasteel/white
	icon_state = "white"
/turf/open/floor/plasteel/white/side
	icon_state = "whitehall"
/turf/open/floor/plasteel/white/corner
	icon_state = "whitecorner"

/turf/open/floor/plasteel/stairs
	icon_state = "stairs"
/turf/open/floor/plasteel/stairs/left
	icon_state = "stairs-l"
/turf/open/floor/plasteel/stairs/medium
	icon_state = "stairs-m"
/turf/open/floor/plasteel/stairs/right
	icon_state = "stairs-r"
/turf/open/floor/plasteel/stairs/old
	icon_state = "stairs-old"
