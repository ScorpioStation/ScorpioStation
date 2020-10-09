// abandoned.dm
// Copyright 2020 Patrick Meade
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//------------------------------------------------------------------------------

/datum/game_mode
	var/mob/claimed_the_prize = null
	var/obj/structure/closet/hiding_place = null
	var/obj/item/stack/spacecash/c1000000/money = null

/datum/game_mode/abandoned
	name = "Abandoned Station"
	config_tag = "abandoned-station"
	required_players = 0
	required_enemies = 0
	recommended_enemies = 0
	votable = 0

/datum/game_mode/abandoned/announce()
	to_chat(world, "<B>The current game mode is - Abandoned Station!</B>")
	to_chat(world, "<B>Rumors of a vast sum of cash left behind have drawn you to the [station_name()].</B>")
	to_chat(world, "Search the lockers on the station to find the prize, and return to the arrivals shuttle.")
	to_chat(world, "<B>Beware!</B> Other treasure hunters are also after the prize and may be hostile!")
	to_chat(world, "Other dangers may also lurk on the Abandoned Station...")

/datum/game_mode/abandoned/can_start()
	return ..()

/datum/game_mode/abandoned/pre_setup()
	// pick a random closet
	hiding_place = pick(get_station_closets())
	// create a stack of 1,000,000 credits
	money = new()
	// put the money in the closet
	hiding_place.contents += money
	// log and message the name and location of the closet containing the money
	log_and_message_admins("[hiding_place] at ([hiding_place.x],[hiding_place.y],[hiding_place.z]) contains the cash!")
	// tell the caller we successfully completed pre-setup
	return TRUE

/datum/game_mode/abandoned/post_setup()
	return ..()

/datum/game_mode/abandoned/proc/get_station_closets()
	var/list/obj/structure/closet/L = list()
	for(var/obj/structure/closet/i in GLOB.closets)
		if(is_station_level(i.z))
			L += i
	return L

/datum/game_mode/abandoned/declare_completion()
	// announce if somebody won or not
	if(claimed_the_prize)
		to_chat(world, "[claimed_the_prize] has escaped the abandoned station with the cash!")
	else
		to_chat(world, "Nobody recovered the cash from the abandoned station!")
	// allow our parent to complete processing
	return ..()

/datum/game_mode/proc/auto_declare_completion_abandoned()
	return TRUE

/datum/game_mode/abandoned/check_finished()
	// for each player in the game
	for(var/mob/P in GLOB.player_list)
		// if the player is standing on the arrivals and escape shuttle
		var/on_shuttle = FALSE
		on_shuttle |= istype(get_area(P), /area/shuttle/arrival/station)
		on_shuttle |= istype(get_area(P), /area/shuttle/escape)
		if(on_shuttle)
			// get all the items the player has
			var/list/all_items = P.GetAllContents()
			// for each item the player has
			for(var/I in all_items)
				// if it's the money
				if(I == money)
					// the player has won and the round is finished
					claimed_the_prize = P
					return TRUE
	// otherwise, let's see if our parent thinks the round is finished
	return ..()

/datum/game_mode/abandoned/latespawn(mob/M)
	..()
	if(SSshuttle.emergency.mode >= SHUTTLE_ESCAPE)
		return

	// if this is an artifical intelligence
	if(isAI(M))
		var/datum/objective/abandoned/protectstation/O = new
		M.mind.objectives += O
		var/datum/antagonist/traitor/malf_ai = new
		M.mind.add_antag_datum(malf_ai)
	// otherwise this is a treasure hunter
	else
		var/datum/objective/abandoned/treasurehunt/O = new
		M.mind.objectives += O

	// tell the late-joiner about their objectives
	M.mind.announce_objectives()

//------------------------------------------------------------------------------
// end of abandoned.dm
