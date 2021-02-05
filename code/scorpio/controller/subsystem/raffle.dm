// raffle.dm
// Copyright 2021 Patrick Meade.
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

#define ANNOUNCE_TICKETS_AWARDED FALSE

SUBSYSTEM_DEF(raffle)
	name = "Raffle"
	init_order = INIT_ORDER_JOBS
	wait = 5 MINUTES
	runlevels = RUNLEVEL_GAME
	offline_implications = "Raffle tickets will no longer be awarded. No immediate action is needed."

/datum/controller/subsystem/raffle/Initialize()
	return ..()

/datum/controller/subsystem/raffle/fire()
	// if there is no database, we can't award any tickets
	if(!SSdbcore.IsConnected())
		return
	// award the tickets earned by the connected clients
	var/num_awarded = round(wait/(1 MINUTES), 1)
	award_raffle_tickets(num_awarded, ANNOUNCE_TICKETS_AWARDED)

/datum/controller/subsystem/raffle/proc/award_raffle_tickets(num_awarded = 0, announce = FALSE)
	// for each client connected to the game
	for(var/client/L in GLOB.clients)
		// if you're AFK, no ticket for you!
		if(L.inactivity >= (5 MINUTES))
			continue
		// otherwise, award those tickets
		update_raffle_client(L, num_awarded, announce)
		CHECK_TICK

/datum/controller/subsystem/raffle/proc/update_raffle_client(client/L, num_awarded = 0, announce = FALSE)
	// bail if no client, no ckey, or no preferences
	if(!L || !L.ckey || !L.prefs)
		return
	// determine if the person is playing a role in the round
	var/myrole = null
	if(L.mob.mind)
		if(L.mob.mind.playtime_role)
			myrole = L.mob.mind.playtime_role
		else if(L.mob.mind.assigned_role)
			myrole = L.mob.mind.assigned_role
	// determine how many raffle tickets to award
	var/added_raffle_tickets = 0
	if(L.mob.stat == CONSCIOUS && myrole)
		added_raffle_tickets += num_awarded
	else
		added_raffle_tickets += 1
	// reduce the award by inactivity levels (minimum 0)
	var/inactive_for = round(L.inactivity / (1 MINUTES), 1)
	added_raffle_tickets -= inactive_for
	added_raffle_tickets = max(0, added_raffle_tickets)
	// bail if we aren't awarding any tickets
	if(!added_raffle_tickets)
		return
	// if we're announcing changes, tell them how many tickets they got
	if(announce)
		to_chat(L.mob, "<span class='notice'>You got [added_raffle_tickets] antag raffle tickets!")
	// award the tickets and update the database
	L.prefs.antag_raffle_tickets += added_raffle_tickets
	var/datum/db_query/update_query_raffle_tickets = SSdbcore.NewQuery({"
		UPDATE [format_table_name("player")]
		SET antag_raffle_tickets=:antag_raffle_tickets, lastseen=NOW() WHERE ckey=:ckey"},
		list(
			"antag_raffle_tickets" = L.prefs.antag_raffle_tickets,
			"ckey" = L.ckey
		)
	)
	update_query_raffle_tickets.warn_execute()
	qdel(update_query_raffle_tickets)

#undef ANNOUNCE_TICKETS_AWARDED

//------------------------------------------------------------------------------
// end of raffle.dm
