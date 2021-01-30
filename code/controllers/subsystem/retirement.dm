// retirement.dm
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

SUBSYSTEM_DEF(retirement)
	flags = SS_NO_FIRE            // no need to fire this after initialization
	init_order = INIT_ORDER_LAST  // messages are more visible at the end
	name = "Retirement"

/datum/controller/subsystem/retirement/Initialize()
	// if we don't have a database, just bail
	if(!SSdbcore.IsConnected())
		return ..()

	// ask the database about our staff
	var/datum/db_query/query = SSdbcore.NewQuery({"
		SELECT
			a.ckey,
			a.rank,
			p.lastseen,
			DATEDIFF(NOW(), p.lastseen) AS days_ago
		FROM [format_table_name("admin")] AS a
		INNER JOIN [format_table_name("player")] AS p
			ON p.ckey = a.ckey
		WHERE a.rank <> 'Removed'
		ORDER BY days_ago DESC"})

	// if the query didn't work, better luck next time
	if(!query.warn_execute())
		qdel(query)
		return ..()

	// while we still have rows to process
	while(query.NextRow())
		// read the row values into variables
		var/ckey = query.item[1]
		var/rank = query.item[2]
		var/lastseen = query.item[3]
		var/days_ago = text2num(query.item[4])

		// if we're into active staff members, just stop processing rows
		if(days_ago < config.staff_retirement_warning_days)
			break

		// if this person has been gone longer than the critical threshold
		if(days_ago >= config.staff_retirement_critical_days)
			log_and_message_admins("Staff member [ckey] ([rank]) was last seen on [lastseen] ([days_ago] days ago), retirement is recommended.")
			continue

		// if this person has been gone longer than the warning threshold
		if(days_ago >= config.staff_retirement_warning_days)
			log_and_message_admins("Staff member [ckey] ([rank]) was last seen on [lastseen] ([days_ago] days ago), reaching out to them is recommended.")

	// all done with the query results
	qdel(query)

	// finish up successful initialization by returning whatever our parent returns
	return ..()

//------------------------------------------------------------------------------
// end of retirement.dm
