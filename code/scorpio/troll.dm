// troll.dm
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

GLOBAL_LIST_EMPTY(gamer_words)

/proc/add_gamer_words(config_value)
	GLOB.gamer_words += splittext(config_value, ",")

/proc/ban_and_kick_troll(context, message, word, mob_name, client/ban_me)
	ban_troll(context, message, word, mob_name, ban_me)
	kick_troll(ban_me)

/proc/ban_troll(context, message, word, mob_name, client/ban_me)
	// we can't ban if we don't have a database
	if(!SSdbcore.IsConnected())
		log_and_message_admins("Database connection failure when attempting to ban troll [ban_me].")
		return FALSE

	// build up all the things we need to record the ban
	var/serverip = "[world.internet_address]:[world.port]"
	var/bantype_str = "PERMABAN"
	var/reason = "[ban_me] / ([mob_name]) used gamer word '[word]' in [context] message '[message]'"
	var/job = ""
	var/duration = -1 // PERMABAN
	var/rounds = 0
	var/ckey = "[ban_me.ckey]"
	var/computerid = "[ban_me.computer_id]"
	var/ip = "[ban_me.address]"
	var/a_ckey = "Automated_Gamer_Word_Ban_System"
	var/a_computerid = 0x7f000001
	var/a_ip = "127.0.0.1"
	var/who = english_list(GLOB.clients)
	var/adminwho = english_list(GLOB.admins)

	// add the ban to the database
	var/datum/db_query/query_insert = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("ban")] (`id`,`bantime`,`serverip`,`bantype`,`reason`,`job`,`duration`,`rounds`,`expiration_time`,`ckey`,`computerid`,`ip`,`a_ckey`,`a_computerid`,`a_ip`,`who`,`adminwho`,`edits`,`unbanned`,`unbanned_datetime`,`unbanned_ckey`,`unbanned_computerid`,`unbanned_ip`)
		VALUES (null, Now(), :serverip, :bantype_str, :reason, :job, :duration, :rounds, Now() + INTERVAL :duration MINUTE, :ckey, :computerid, :ip, :a_ckey, :a_computerid, :a_ip, :who, :adminwho, '', null, null, null, null, null)
	"}, list(
		// get ready for parameters
		"serverip" = serverip,
		"bantype_str" = bantype_str,
		"reason" = reason,
		"job" = job,
		"duration" = (duration ? "[duration]" : "0"), // strings are important here
		"rounds" = (rounds ? "[rounds]" : "0"), // and here
		"ckey" = ckey,
		"computerid" = computerid,
		"ip" = ip,
		"a_ckey" = a_ckey,
		"a_computerid" = a_computerid,
		"a_ip" = a_ip,
		"who" = who,
		"adminwho" = adminwho
	))
	if(!query_insert.warn_execute())
		qdel(query_insert)
		return FALSE
	qdel(query_insert)
	log_and_message_admins("[a_ckey] has added a [bantype_str] for [ckey] with the reason: \"[reason]\" to the ban database.")

	// tell Discord why we banned the mob
	var/datum/discord/webhook/cryo = new(config.discord_webhook_cryo_url)
	cryo.post_message("[mob_name] used a gamer word.")

	// tell the caller we banned the mob
	return TRUE

/proc/check_for_troll(context, message, ban_me)
	// ensure we've got gamer words
	if(isemptylist(GLOB.gamer_words))
		return FALSE
	// ensure we've got a message
	if(!istext(message))
		return FALSE
	// ensure we've got a client or mob
	var/mob_name = "Unknown Gamer"
	var/client/ban_client = null
	if(istype(ban_me, /mob))
		var/mob/M = ban_me
		mob_name = "[M]"
		ban_client = M.client
	if(istype(ban_me, /client))
		ban_client = ban_me
	if(!ban_client)
		return FALSE
	// remove spaces and symbols from the message
	var/regex/spaces = new(@"[\s]+", "ig")
	var/regex/symbols = new(@"[\L]+", "ig")
	var/check_me = spaces.Replace(message, "")
	check_me = symbols.Replace(check_me, "")
	// check the message for gamer words
	for(var/word in GLOB.gamer_words)
		if(findtext_char(check_me, word) > 0)
			// tell the caller we kickban'd a troll
			ban_and_kick_troll(context, message, word, mob_name, ban_client)
			return TRUE
	// nope, no gamer words found
	return FALSE

/proc/kick_troll(client/C)
	spawn(1)
		qdel(C)

//------------------------------------------------------------------------------
// end of troll.dm
