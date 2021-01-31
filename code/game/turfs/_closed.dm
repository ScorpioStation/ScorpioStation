/turf/closed
	layer = CLOSED_TURF_LAYER
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE

/turf/closed/ChangeTurf(path, defer_change = FALSE, keep_icon = TRUE, ignore_air = FALSE)
	. = ..()
	queue_smooth_neighbors(src)

/turf/closed/AfterChange(ignore_air = FALSE, keep_cabling = FALSE)
	. = ..()
	SSair.high_pressure_delta -= src

/turf/closed/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE

/turf/closed/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover) && (mover.pass_flags & PASSCLOSEDTURF))
		return TRUE
