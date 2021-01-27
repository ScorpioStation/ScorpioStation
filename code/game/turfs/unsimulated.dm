/turf/unsimulated
	intact = TRUE
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/unsimulated/floor/plating/vox
	icon_state = "plating"
	name = "plating"
	nitrogen = 100
	oxygen = 0

/turf/unsimulated/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	temperature = T0C

/turf/unsimulated/floor/plating/snow/concrete
	name = "concrete"
	icon = 'icons/turf/floors.dmi'
	icon_state = "concrete"

/turf/unsimulated/floor/plating/snow/ex_act(severity)
	return

/turf/unsimulated/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/unsimulated/floor/plating/airless/Initialize(mapload)
	. = ..()
	name = "plating"

