// upstream_shim.dm
// Copyright 2020 Patrick Meade
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//------------------------------------------------------------------------------

// from: code/game/jobs/job/supervisor.dm
/datum/job/nanotrasenrep
	// this is a shim, so prevent it from showing up where it ought not
	department_flag = JOB_CENTCOM
	flag = JOB_CENTCOM
	hidden_from_job_prefs = TRUE
	admin_only = TRUE

// from: code/game/objects/items/weapons/AI_modules.dm
/obj/item/aiModule/nanotrasen

// from: code/game/objects/items/weapons/lighters.dm
/obj/item/lighter/zippo/nt_rep

// from: code/modules/paperwork/paper.dm
/obj/item/paper/ntrep

// from: code/modules/paperwork/paperbin.dm
/obj/item/paper_bin/nanotrasen

// from: code/game/jobs/job/medical.dm
/obj/item/radio/headset/headset_medsci

// from: code/game/objects/items/devices/radio/headset.dm
/obj/item/radio/headset/heads/ntrep

// from: code/game/machinery/computer/HolodeckControl.dm
/obj/structure/chair/stool/holostool

// from: code/game/objects/structures/crates_lockers/closets/secure/security.dm
/obj/structure/closet/secure_closet/ntrep

// from: code/game/objects/effects/decals/contraband.dm:
/obj/structure/sign/poster/official/nanotrasen_logo

// from: code/game/machinery/computer/HolodeckControl.dm
/turf/simulated/floor/holofloor/space

//------------------------------------------------------------------------------
// upstream_shim.dm
