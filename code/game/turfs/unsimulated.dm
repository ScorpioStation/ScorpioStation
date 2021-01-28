/turf/unsimulated
	intact = TRUE
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/open/locked/floor/plating/vox
	icon_state = "plating"
	name = "plating"
	nitrogen = 100
	oxygen = 0



/turf/open/floor/plating/staticairless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/open/floor/plating/staticairless/Initialize(mapload)
	. = ..()
	name = "plating"

