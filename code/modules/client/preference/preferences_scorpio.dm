// preferences_scorpio.dm
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

/// list of /datum/preferences character vars to be saved to the database
GLOBAL_LIST_INIT(saved_character_attributes, list(
	"age",
	"alt_head",                     // alt_head_name
	"alternate_option",
	"ark_soft_relation",
	"autohiss_mode",                // autohiss
	"b_type",
	"backbag",
	"be_random_name",               // name_is_always_random
	"body_accessory",
	"disabilities",
	"e_colour",                     // eye_colour
	"f_colour",                     // facial_hair_colour
	"f_sec_colour",                 // secondary_facial_hair_colour
	"f_style",                      // facial_style_name
	"flavor_text",
	"gen_record",
	"h_colour",                     // hair_colour
	"h_sec_colour",                 // secondary_hair_colour
	"h_style",                      // hair_style_name
	"ha_style",                     // head_accessory_style_name
	"hacc_colour",                  // head_accessory_colour
	"job_engsec_high",
	"job_engsec_low",
	"job_engsec_med",
	"job_karma_high",
	"job_karma_low",
	"job_karma_med",
	"job_medsci_high",
	"job_medsci_low",
	"job_medsci_med",
	"job_support_high",
	"job_support_low",
	"job_support_med",
	"language",
	"loadout_gear",                 // gear
	"m_colours",                    // marking_colours
	"m_styles",                     // marking_styles
	"med_record",
	"metadata",                     // OOC_Notes
	"organ_data",
	"player_alt_titles",
	"rlimb_data",
	"s_colour",                     // skin_colour
	"s_tone",                       // skin_tone
	"sec_record",
	"socks",
	"species",
	"speciesprefs",
	"undershirt",
	"underwear",
	"gender",                       // DEPENDS ON: species
	"real_name"))                   // DEPENDS ON: gender, species

/// list of /datum/preferences preference vars to be saved to the database
GLOBAL_LIST_INIT(saved_preferences, list(
	"atklog",
	"be_special",                   // be_role
	"chat_on_map",
	"clientfps",
	"default_slot",
	"max_chat_length",
	"ooccolor",
	"parallax",
	"see_chat_non_mob",
	"sound",
	"toggles",
	"toggles2",                     // toggles_2
	"UI_style",
	"UI_style_alpha",
	"UI_style_color",
	"volume"))

/**
  * Delete a character from a slot in the database.
  *
  * Removes the character in the default_slot from the database. This proc
  * removes all of the character attributes tied to the character record.
  * It then removes the character record from the database. The flag saved
  * is updated to indicate the character attributes in the preferences datum
  * no longer correspond to a saved record in the database.
  *
  * Arguments:
  * * C - client object for which to delete the default_slot character
  *
  * Returns:
  * * TRUE - If the character slot was removed from the database
  * * FALSE - If some error prevented the character slot from being deleted
  */
/datum/preferences/proc/clear_character_slot(client/C)
	// ensure we have a valid client reference
	if(!C)
		log_and_message_admins("clear_character_slot: C == null")
		return FALSE
	// ensure the client has a valid canonical key (ckey)
	if(!C.ckey)
		log_and_message_admins("clear_character_slot: C.ckey == null")
		return FALSE

	// load up the character's record from the database
	var/DBQuery/query1 = GLOB.dbcon.NewQuery("SELECT id FROM [format_table_name("characters")] WHERE ckey='[C.ckey]' and slot=[default_slot]")
	if(!query1.Execute())
		var/err = query1.ErrorMsg()
		log_game("clear_character_slot: SQL ERROR characters: [err]")
		message_admins("clear_character_slot: SQL ERROR characters: [err]")
		return FALSE

	// find the character's id
	var/character_id = 0
	while(query1.NextRow())
		character_id = text2num(query1.item[1])
	// bail if we didn't find the character's id
	if(!character_id)
		log_and_message_admins("clear_character_slot: ckey == '[C.ckey]' and slot == '[default_slot]', character_id == 0")
		return FALSE

	// delete all of the character's attributes from the database
	var/DBQuery/query2 = GLOB.dbcon.NewQuery("DELETE FROM [format_table_name("character_attributes")] WHERE character_id=[character_id]")
	if(!query2.Execute())
		var/err = query2.ErrorMsg()
		log_game("clear_character_slot: SQL ERROR character_attributes DELETE: [err]")
		message_admins("clear_character_slot: SQL ERROR character_attributes DELETE: [err]")
		return FALSE

	// delete the row from table characters
	var/DBQuery/query3 = GLOB.dbcon.NewQuery("DELETE FROM [format_table_name("characters")] WHERE character_id=[character_id]")
	if(!query3.Execute())
		var/err = query3.ErrorMsg()
		log_game("clear_character_slot: SQL ERROR characters DELETE: [err]")
		message_admins("clear_character_slot: SQL ERROR characters DELETE: [err]")
		return FALSE

	// the character in the datum is no longer in the database
	saved = FALSE

	// tell the caller we successfully cleared the character slot
	return TRUE

/**
  * Load the specified character slot from the database.
  *
  * Loads the specified character slot from the database into the character
  * attribute vars of the preferences datum. The slot may be any valid slot
  * and will default to default_slot if not specified. While loading the
  * character, the default_slot is updated to the slot provided to this
  * function; if you load Slot 5, you are now 'using' Slot 5.
  *
  * Character attributes are loaded on a best-effort basis. Whatever is in
  * the database is checked against having a variable to put it into, and
  * a sanitization function to call. If either of these are lacking, the
  * value is simply skipped. We only process the values provided by the
  * database, and make no attempt to find "missing" values from the canonical
  * list of character attributes.
  *
  * Arguments:
  * * C - client object for which to load a character
  * * slot - the character slot to load (uses default_slot if not specified)
  *
  * Returns:
  * * TRUE - If the character was successfully loaded from the database
  * * FALSE - If some error prevented the character from being loaded
  */
/datum/preferences/proc/load_character(client/C, slot)
	// ensure we have a valid client reference
	if(!C)
		log_and_message_admins("load_character: C == null")
		return FALSE
	// ensure the client has a valid canonical key (ckey)
	if(!C.ckey)
		log_and_message_admins("load_character: C.ckey == null")
		return FALSE

	// ensure we have a proper value for slot
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, max_save_slots, initial(default_slot))

	// flag: the character has not been loaded from the database
	saved = FALSE

	// load up the player's record from the database
	var/DBQuery/query1 = GLOB.dbcon.NewQuery("SELECT id FROM [format_table_name("player")] WHERE ckey='[C.ckey]'")
	if(!query1.Execute())
		var/err = query1.ErrorMsg()
		log_game("load_character: SQL ERROR player: [err]")
		message_admins("load_character: SQL ERROR player: [err]")
		return FALSE

	// find the player's id
	var/player_id = 0
	while(query1.NextRow())
		player_id = text2num(query1.item[1])
	// bail if we didn't find the player's id
	if(!player_id)
		log_and_message_admins("load_character: ckey == '[C.ckey]', player_id == 0")
		return FALSE

	// if the slot we were provided isn't our current default slot
	if(slot != default_slot)
		// switch our default slot to the one provided
		default_slot = slot
		// update the default_slot preference in the database
		var/DBQuery/query2 = GLOB.dbcon.NewQuery("UPDATE [format_table_name("player_preferences")] SET pref_val='[default_slot]' WHERE player_id=[player_id] and pref_key='default_slot'")
		if(!query2.Execute())
			var/err = query2.ErrorMsg()
			log_game("load_character: SQL ERROR player_preferences UPDATE: [err]")
			message_admins("load_character: SQL ERROR player_preferences UPDATE: [err]")

	// load up the character's record from the database
	var/DBQuery/query3 = GLOB.dbcon.NewQuery("SELECT id FROM [format_table_name("characters")] WHERE ckey='[C.ckey]' and slot=[default_slot]")
	if(!query3.Execute())
		var/err = query3.ErrorMsg()
		log_game("load_character: SQL ERROR characters: [err]")
		message_admins("load_character: SQL ERROR characters: [err]")
		return FALSE

	// find the character's id
	var/character_id = 0
	while(query3.NextRow())
		character_id = text2num(query3.item[1])
	// bail if we didn't find the character's id
	if(!character_id)
		log_and_message_admins("load_character: ckey == '[C.ckey]' and slot == '[default_slot]', character_id == 0")
		return FALSE

	// load up the character's attributes from the database
	var/DBQuery/query4 = GLOB.dbcon.NewQuery("SELECT attr_key, attr_val FROM [format_table_name("character_attributes")] WHERE character_id=[character_id]")
	if(!query4.Execute())
		var/err = query4.ErrorMsg()
		log_game("load_character: SQL ERROR character_attributes: [err]")
		message_admins("load_character: SQL ERROR character_attributes: [err]")
		return FALSE

	// load the character's attributes into the preferences datum
	while(query4.NextRow())
		// read the values provided by the database
		var/attr_key = query4.item[1]
		var/attr_val = query4.item[2]
		// if we can't find that preference variable in the datum
		if(!vars.Find(attr_key))
			log_and_message_admins("load_character: Attribute Not Found: attr_key == '[attr_key]'")
			continue
		// if we don't have a proc to sanitize the value from the database
		if(!hascall(src, "from_sql_[attr_key]"))
			log_and_message_admins("load_character: Load Sanitize Not Found: attr_key == 'from_sql_[attr_key]'")
			continue
		// load the sanitized database value into the preference variable
		vars[attr_key] = call(src, "from_sql_[attr_key]")(attr_val)
		// update the flag to indicate these character attribute values came from the database
		saved = TRUE

	// tell the caller that we successfully loaded the character
	return TRUE

/**
  * Load the player's server wide preferences from the database.
  *
  * load_preferences populates the vars listed in saved_preferences by querying
  * the database for their values.
  *
  * Player preferences are loaded on a best-effort basis. Whatever is in
  * the database is checked against having a variable to put it into, and
  * a sanitization function to call. If either of these are lacking, the
  * value is simply skipped. We only process the values provided by the
  * database, and make no attempt to find "missing" values from the canonical
  * list of player preferences.
  *
  * Arguments:
  * * C - client object for which to load preferences
  *
  * Returns:
  * * TRUE - If saved preferences were loaded without error
  * * FALSE - If some error prevented saved preferences from loading
  */
/datum/preferences/proc/load_preferences(client/C)
	// ensure we have a valid client reference
	if(!C)
		log_and_message_admins("load_preferences: C == null")
		return FALSE
	// ensure the client has a valid canonical key (ckey)
	if(!C.ckey)
		log_and_message_admins("load_preferences: C.ckey == null")
		return FALSE

	// load up the player's record from the database
	var/DBQuery/query1 = GLOB.dbcon.NewQuery("SELECT id FROM [format_table_name("player")] WHERE ckey='[C.ckey]'")
	if(!query1.Execute())
		var/err = query1.ErrorMsg()
		log_game("load_preferences: SQL ERROR player: [err]")
		message_admins("load_preferences: SQL ERROR player: [err]")
		return FALSE

	// find the player's id
	var/player_id = 0
	while(query1.NextRow())
		player_id = text2num(query1.item[1])
	// bail if we didn't find the player's id
	if(!player_id)
		log_and_message_admins("load_preferences: ckey == '[C.ckey]', player_id == 0")
		return FALSE

	// load up the player's preferences from the database
	var/DBQuery/query2 = GLOB.dbcon.NewQuery("SELECT pref_key, pref_val FROM [format_table_name("player_preferences")] WHERE player_id=[player_id]")
	if(!query2.Execute())
		var/err = query2.ErrorMsg()
		log_game("load_preferences: SQL ERROR player_preferences: [err]")
		message_admins("load_preferences: SQL ERROR player_preferences: [err]")
		return FALSE

	// load the player's preferences into the object
	while(query2.NextRow())
		// read the values provided by the database
		var/pref_key = query2.item[1]
		var/pref_val = query2.item[2]
		// if we can't find that preference variable in the datum
		if(!vars.Find(pref_key))
			log_and_message_admins("load_preferences: Preference Not Found: pref_key == '[pref_key]'")
			continue
		// if we don't have a proc to sanitize the value from the database
		if(!hascall(src, "from_sql_[pref_key]"))
			log_and_message_admins("load_preferences: Load Sanitize Not Found: pref_key == 'from_sql_[pref_key]'")
			continue
		// load the sanitized database value into the preference variable
		vars[pref_key] = call(src, "from_sql_[pref_key]")(pref_val)

	// tell the caller that we successfully loaded preferences
	return TRUE

/**
  * Read things from table player that we don't save (but others do).
  *
  * load_pseudo_preferences loads values from table player and populates them
  * into the preferences datum. These are pseudo preferences because the values
  * come from table player, not table player_preferences. They are also pseudo
  * preferences because our code does not save them back to the database.
  *
  * The login code relied on load_preferences to populate some values when a
  * client would log in to play the game. load_pseudo_preferences is the
  * replacement for that populate-on-login functionality.
  *
  * Arguments:
  * * C - client object for which to load pseudo preferences
  *
  * Returns:
  * * TRUE - If pseudo preferences were loaded without error
  * * FALSE - If some error prevented pseudo preferences from loading
  */
/datum/preferences/proc/load_pseudo_preferences(client/C)
	// ensure we have a valid client reference
	if(!C)
		log_and_message_admins("load_pseudo_preferences: C == null")
		return FALSE
	// ensure the client has a valid canonical key (ckey)
	if(!C.ckey)
		log_and_message_admins("load_pseudo_preferences: C.ckey == null")
		return FALSE

	// load pseudo preferences from the database
	var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT antag_raffle_tickets, exp, fuid, lastchangelog FROM [format_table_name("player")] WHERE ckey='[C.ckey]'")
	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("load_pseudo_preferences: SQL ERROR player: [err]")
		message_admins("load_pseudo_preferences: SQL ERROR player: [err]")
		return FALSE

	// load the database values into the preferences datum
	while(query.NextRow())
		antag_raffle_tickets = text2num(query.item[1])
		exp = query.item[2]
		fuid = text2num(query.item[3])
		lastchangelog = query.item[4]

	// sanitize any wierdness that came out of the database
	antag_raffle_tickets = sanitize_integer(antag_raffle_tickets, 0, 1000000, initial(antag_raffle_tickets))
	exp	= sanitize_text(exp, initial(exp))
	fuid = sanitize_integer(fuid, 0, 10000000, initial(fuid))
	lastchangelog = sanitize_text(lastchangelog, initial(lastchangelog))

	// tell the caller that we successfully loaded the pseudo preferences
	return TRUE

/**
  * Load a character from a random valid slot.
  *
  * load_random_character_slot does what it says on the tin; it calls the
  * load_character function for a random character slot. The slots are first
  * loaded from the database, and a random slot is chosen for loading.
  *
  * If there are no valid character slots in the database, this will call
  * load_character with the default slot and end up generating a new unsaved
  * character in the preferences datum.
  *
  * Arguments:
  * * C - client object for which to load a random character
  *
  * Returns:
  * * TRUE - If the character was loaded successfully from the database
  * * FALSE - If some error prevented the character from being loaded
  */
/datum/preferences/proc/load_random_character_slot(client/C)
	// ensure we have a valid client reference
	if(!C)
		log_and_message_admins("load_random_character_slot: C == null")
		return FALSE
	// ensure the client has a valid canonical key (ckey)
	if(!C.ckey)
		log_and_message_admins("load_random_character_slot: C.ckey == null")
		return FALSE

	// load all the player's active character slots
	var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT slot FROM [format_table_name("characters")] WHERE ckey='[C.ckey]' ORDER BY slot")
	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("load_random_character_slot: SQL ERROR characters: [err]")
		message_admins("load_random_character_slot: SQL ERROR characters: [err]")
		return FALSE

	// convert the query rows into a list of valid slots
	var/list/save_slots = list()
	while(query.NextRow())
		save_slots += text2num(query.item[1])

	// if we got some valid save slots from the database
	if(save_slots.len)
		return load_character(C, pick(save_slots))

	// if we didn't get any valid slots, just load the default
	return load_character(C)

/**
  * Save the player's current character to the database.
  *
  * save_character attempts to save all the vars listed in
  * saved_character_attributes by querying the database to store their values.
  *
  * Arguments:
  * * C - client object for which to save the character
  *
  * Returns:
  * * TRUE - If the character was saved successfully from the database
  * * FALSE - If some error prevented the character from being saved
  */
/datum/preferences/proc/save_character(client/C)
	// ensure we have a valid client reference
	if(!C)
		log_and_message_admins("save_character: C == null")
		return FALSE
	// ensure the client has a valid canonical key (ckey)
	if(!C.ckey)
		log_and_message_admins("save_character: C.ckey == null")
		return FALSE

	// ensure we have a proper value for default_slot
	default_slot = sanitize_integer(default_slot, 1, max_save_slots, initial(default_slot))

	// load up the character's record from the database
	var/DBQuery/query1 = GLOB.dbcon.NewQuery("SELECT id FROM [format_table_name("characters")] WHERE ckey='[C.ckey]' and slot=[default_slot]")
	if(!query1.Execute())
		var/err = query1.ErrorMsg()
		log_game("save_character: SQL ERROR characters: [err]")
		message_admins("save_character: SQL ERROR characters: [err]")
		return FALSE

	// find the character's id
	var/character_id = 0
	while(query1.NextRow())
		character_id = text2num(query1.item[1])

	// if we didn't get the character's id
	if(!character_id)
		// then the record doesn't exist and it needs to be created
		var/DBQuery/query2 = GLOB.dbcon.NewQuery("INSERT INTO [format_table_name("characters")] (ckey, slot) VALUES ('[C.ckey]', [default_slot])")
		if(!query2.Execute())
			var/err = query2.ErrorMsg()
			log_game("save_character: SQL ERROR characters INSERT: [err]")
			message_admins("save_character: SQL ERROR characters INSERT: [err]")
			return FALSE

		// load up the character's record from the database
		var/DBQuery/query3 = GLOB.dbcon.NewQuery("SELECT id FROM [format_table_name("characters")] WHERE ckey='[C.ckey]' and slot=[default_slot]")
		if(!query3.Execute())
			var/err = query3.ErrorMsg()
			log_game("save_character: SQL ERROR characters SELECT: [err]")
			message_admins("save_character: SQL ERROR characters SELECT: [err]")
			return FALSE

		// find the character's id
		while(query3.NextRow())
			character_id = text2num(query3.item[1])
		// bail if we didn't find the character's id
		if(!character_id)
			log_and_message_admins("save_character: ckey == '[C.ckey]' and slot == '[default_slot]', character_id == 0")
			return FALSE

	// delete all of the character's attributes from the database
	var/DBQuery/query4 = GLOB.dbcon.NewQuery("DELETE FROM [format_table_name("character_attributes")] WHERE character_id=[character_id]")
	if(!query4.Execute())
		var/err = query4.ErrorMsg()
		log_game("save_character: SQL ERROR character_attributes DELETE: [err]")
		message_admins("save_character: SQL ERROR character_attributes DELETE: [err]")
		return FALSE

	// save the character's attributes to the database
	for(var/save_me in GLOB.saved_character_attributes)
		// if we can't find that preference variable in the datum
		if(!vars.Find(save_me))
			log_and_message_admins("save_character: Attribute Not Found: save_me == '[save_me]'")
			continue
		// if we don't have a proc to sanitize the value for the database
		if(!hascall(src, "to_sql_[save_me]"))
			log_and_message_admins("save_character: Save Sanitize Not Found: save_me == 'to_sql_[save_me]'")
			continue
		// save the sanitized preference value to the database
		var/attr_val = call(src, "to_sql_[save_me]")(vars[save_me])
		var/DBQuery/query5 = GLOB.dbcon.NewQuery("INSERT INTO [format_table_name("character_attributes")] (character_id, attr_key, attr_val) VALUES ([character_id], '[save_me]', '[attr_val]')")
		if(!query5.Execute())
			var/err = query5.ErrorMsg()
			log_game("save_character: SQL ERROR character_attributes INSERT: [err]")
			message_admins("save_character: SQL ERROR character_attributes INSERT: [err]")
			continue

	// update the flag to indicate the character attributes in the preferences
	// datum now correspond to a record that is saved in the database
	saved = TRUE

	// tell the caller that we successfully saved the character
	return TRUE

/**
  * Save the player's server wide preferences to the database.
  *
  * save_preferences attempts to save all the vars listed in saved_preferences
  * by querying the database to store their values.
  *
  * Arguments:
  * * C - client object for which to save preferences
  *
  * Returns:
  * * TRUE - If saved preferences were saved without error
  * * FALSE - If some error prevented some saved preferences from saving
  */
/datum/preferences/proc/save_preferences(client/C)
	// ensure we have a valid client reference
	if(!C)
		log_and_message_admins("save_preferences: C == null")
		return FALSE
	// ensure the client has a valid canonical key (ckey)
	if(!C.ckey)
		log_and_message_admins("save_preferences: C.ckey == null")
		return FALSE

	// load up the player's record from the database
	var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT id FROM [format_table_name("player")] WHERE ckey='[C.ckey]'")
	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("save_preferences: SQL ERROR player: [err]")
		message_admins("save_preferences: SQL ERROR player: [err]")
		return FALSE

	// find the player's id
	var/player_id = 0
	while(query.NextRow())
		player_id = text2num(query.item[1])
	// bail if we didn't find the player's id
	if(!player_id)
		log_and_message_admins("save_preferences: ckey == '[C.ckey]', player_id == 0")
		return FALSE

	// delete all of the player's preferences from the database
	var/DBQuery/query2 = GLOB.dbcon.NewQuery("DELETE FROM [format_table_name("player_preferences")] WHERE player_id=[player_id]")
	if(!query2.Execute())
		var/err = query2.ErrorMsg()
		log_game("save_preferences: SQL ERROR player_preferences DELETE: [err]")
		message_admins("save_preferences: SQL ERROR player_preferences DELETE: [err]")
		return FALSE

	// save the player's preferences to the database
	var/no_errors = TRUE
	for(var/save_me in GLOB.saved_preferences)
		// if we can't find that preference variable in the datum
		if(!vars.Find(save_me))
			log_and_message_admins("save_preferences: Preference Not Found: save_me == '[save_me]'")
			no_errors = FALSE
			continue
		// if we don't have a proc to sanitize the value for the database
		if(!hascall(src, "to_sql_[save_me]"))
			log_and_message_admins("save_preferences: Save Sanitize Not Found: save_me == 'to_sql_[save_me]'")
			no_errors = FALSE
			continue
		// save the sanitized preference value to the database
		var/pref_val = call(src, "to_sql_[save_me]")(vars[save_me])
		var/DBQuery/query3 = GLOB.dbcon.NewQuery("INSERT INTO [format_table_name("player_preferences")] (player_id, pref_key, pref_val) VALUES ([player_id], '[save_me]', '[pref_val]')")
		if(!query3.Execute())
			var/err = query3.ErrorMsg()
			log_game("save_preferences: SQL ERROR player_preferences INSERT: [err]")
			message_admins("save_preferences: SQL ERROR player_preferences INSERT: [err]")
			no_errors = FALSE
			continue

 	// tell the caller if we successfully saved all the preferences
	return no_errors

//------------------------------------------------------------------------------

/datum/preferences/proc/from_sql_atklog(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, 100, initial(atklog))

/datum/preferences/proc/from_sql_be_special(var/pref_val)
	// convert the param string into a list of roles
	var/role_list = params2list(pref_val)
	// remove any special roles that don't exist
	for(var/role in role_list)
		if(!(role in GLOB.special_roles))
			role_list -= role
	// return the filtered role list to the caller
	return role_list

/datum/preferences/proc/from_sql_chat_on_map(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, 1, initial(chat_on_map))

/datum/preferences/proc/from_sql_clientfps(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, 1000, initial(clientfps))

/datum/preferences/proc/from_sql_default_slot(var/pref_val)
	return sanitize_integer(text2num(pref_val), 1, max_save_slots, initial(default_slot))

/datum/preferences/proc/from_sql_lastchangelog(var/pref_val)
	return sanitize_text(pref_val, initial(lastchangelog))

/datum/preferences/proc/from_sql_max_chat_length(var/pref_val)
	return sanitize_integer(text2num(pref_val), 1, CHAT_MESSAGE_MAX_LENGTH, initial(max_chat_length))

/datum/preferences/proc/from_sql_ooccolor(var/pref_val)
	return sanitize_hexcolor(pref_val, initial(ooccolor))

/datum/preferences/proc/from_sql_parallax(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, 16, initial(parallax))

/datum/preferences/proc/from_sql_see_chat_non_mob(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, 1, initial(see_chat_non_mob))

/datum/preferences/proc/from_sql_sound(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, 65535, initial(sound))

/datum/preferences/proc/from_sql_toggles(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, TOGGLES_TOTAL, initial(toggles))

/datum/preferences/proc/from_sql_toggles2(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, TOGGLES_2_TOTAL, initial(toggles2))

/datum/preferences/proc/from_sql_UI_style(var/pref_val)
	return sanitize_inlist(pref_val, list("White", "Midnight"), initial(UI_style))

/datum/preferences/proc/from_sql_UI_style_alpha(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, 255, initial(UI_style_alpha))

/datum/preferences/proc/from_sql_UI_style_color(var/pref_val)
	return sanitize_hexcolor(pref_val, initial(UI_style_color))

/datum/preferences/proc/from_sql_volume(var/pref_val)
	return sanitize_integer(text2num(pref_val), 0, 100, initial(volume))

//------------------------------------------------------------------------------

/datum/preferences/proc/to_sql_atklog(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, 100, initial(atklog))
	return "[pref_val]"

/datum/preferences/proc/to_sql_be_special(var/pref_val)
	// remove any special roles that don't exist
	for(var/role in pref_val)
		if(!(role in GLOB.special_roles))
			pref_val -= role
	// convert the list to a param string
	return list2params(pref_val)

/datum/preferences/proc/to_sql_chat_on_map(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, 1, initial(chat_on_map))
	return "[pref_val]"

/datum/preferences/proc/to_sql_clientfps(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, 1000, initial(clientfps))
	return "[pref_val]"

/datum/preferences/proc/to_sql_default_slot(var/pref_val)
	pref_val = sanitize_integer(pref_val, 1, max_save_slots, initial(default_slot))
	return "[pref_val]"

/datum/preferences/proc/to_sql_lastchangelog(var/pref_val)
	pref_val = sanitize_text(pref_val, initial(lastchangelog))
	return pref_val

/datum/preferences/proc/to_sql_max_chat_length(var/pref_val)
	pref_val = sanitize_integer(pref_val, 1, CHAT_MESSAGE_MAX_LENGTH, initial(max_chat_length))
	return "[pref_val]"

/datum/preferences/proc/to_sql_ooccolor(var/pref_val)
	pref_val = sanitize_hexcolor(pref_val, initial(ooccolor))
	return pref_val

/datum/preferences/proc/to_sql_parallax(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, 16, initial(parallax))
	return "[pref_val]"

/datum/preferences/proc/to_sql_see_chat_non_mob(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, 1, initial(see_chat_non_mob))
	return "[pref_val]"

/datum/preferences/proc/to_sql_sound(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, 65535, initial(sound))
	return "[pref_val]"

/datum/preferences/proc/to_sql_toggles(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, TOGGLES_TOTAL, initial(toggles))
	return "[num2text(pref_val, CEILING(log(10, (TOGGLES_TOTAL)), 1))]"

/datum/preferences/proc/to_sql_toggles2(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, TOGGLES_2_TOTAL, initial(toggles2))
	return "[num2text(pref_val, CEILING(log(10, (TOGGLES_2_TOTAL)), 1))]"

/datum/preferences/proc/to_sql_UI_style(var/pref_val)
	pref_val = sanitize_inlist(pref_val, list("White", "Midnight"), initial(UI_style))
	return pref_val

/datum/preferences/proc/to_sql_UI_style_alpha(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, 255, initial(UI_style_alpha))
	return "[pref_val]"

/datum/preferences/proc/to_sql_UI_style_color(var/pref_val)
	pref_val = sanitize_hexcolor(pref_val, initial(UI_style_color))
	return pref_val

/datum/preferences/proc/to_sql_volume(var/pref_val)
	pref_val = sanitize_integer(pref_val, 0, 100, initial(volume))
	return "[pref_val]"

//------------------------------------------------------------------------------

/datum/preferences/proc/from_sql_age(var/attr_val)
	return sanitize_integer(text2num(attr_val), AGE_MIN, AGE_MAX, initial(age))

/datum/preferences/proc/from_sql_alt_head(var/attr_val)
	return sanitize_inlist(attr_val, GLOB.alt_heads_list, initial(alt_head))

/datum/preferences/proc/from_sql_alternate_option(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 2, initial(alternate_option))

/datum/preferences/proc/from_sql_ark_soft_relation(var/attr_val)
	return sanitize_inlist(attr_val, GLOB.company_relations, initial(ark_soft_relation))

/datum/preferences/proc/from_sql_autohiss_mode(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 2, initial(autohiss_mode))

/datum/preferences/proc/from_sql_b_type(var/attr_val)
	return sanitize_inlist(attr_val, GLOB.blood_types, initial(b_type))

/datum/preferences/proc/from_sql_backbag(var/attr_val)
	return sanitize_inlist(attr_val, GLOB.backbaglist, initial(backbag))

/datum/preferences/proc/from_sql_be_random_name(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 1, initial(be_random_name))

/datum/preferences/proc/from_sql_body_accessory(var/attr_val)
	return sanitize_inlist(attr_val, GLOB.body_accessory_by_name, null)

/datum/preferences/proc/from_sql_disabilities(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(disabilities))

/datum/preferences/proc/from_sql_e_colour(var/attr_val)
	return sanitize_hexcolor(attr_val, initial(e_colour))

/datum/preferences/proc/from_sql_f_colour(var/attr_val)
	return sanitize_hexcolor(attr_val, initial(f_colour))

/datum/preferences/proc/from_sql_f_sec_colour(var/attr_val)
	return sanitize_hexcolor(attr_val, initial(f_sec_colour))

/datum/preferences/proc/from_sql_f_style(var/attr_val)
	return sanitize_inlist(attr_val, GLOB.facial_hair_styles_list, initial(f_style))

/datum/preferences/proc/from_sql_flavor_text(var/attr_val)
	return sanitize_text(attr_val, initial(flavor_text))

/datum/preferences/proc/from_sql_gen_record(var/attr_val)
	return sanitize_text(attr_val, initial(gen_record))

/datum/preferences/proc/from_sql_gender(var/attr_val)
	var/datum/species/SP = GLOB.all_species[species]
	return sanitize_gender(attr_val, FALSE, !SP.has_gender)

/datum/preferences/proc/from_sql_h_colour(var/attr_val)
	return sanitize_hexcolor(attr_val, initial(h_colour))

/datum/preferences/proc/from_sql_h_sec_colour(var/attr_val)
	return sanitize_hexcolor(attr_val, initial(h_sec_colour))

/datum/preferences/proc/from_sql_h_style(var/attr_val)
	return sanitize_inlist(attr_val, GLOB.hair_styles_public_list, initial(h_style))

/datum/preferences/proc/from_sql_ha_style(var/attr_val)
	return sanitize_inlist(attr_val, GLOB.head_accessory_styles_list, initial(ha_style))

/datum/preferences/proc/from_sql_hacc_colour(var/attr_val)
	return sanitize_hexcolor(attr_val, initial(hacc_colour))

/datum/preferences/proc/from_sql_job_engsec_high(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_engsec_high))

/datum/preferences/proc/from_sql_job_engsec_low(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_engsec_low))

/datum/preferences/proc/from_sql_job_engsec_med(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_engsec_med))

/datum/preferences/proc/from_sql_job_karma_high(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_karma_high))

/datum/preferences/proc/from_sql_job_karma_low(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_karma_low))

/datum/preferences/proc/from_sql_job_karma_med(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_karma_med))

/datum/preferences/proc/from_sql_job_medsci_high(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_medsci_high))

/datum/preferences/proc/from_sql_job_medsci_low(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_medsci_low))

/datum/preferences/proc/from_sql_job_medsci_med(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_medsci_med))

/datum/preferences/proc/from_sql_job_support_high(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_support_high))

/datum/preferences/proc/from_sql_job_support_low(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_support_low))

/datum/preferences/proc/from_sql_job_support_med(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 65535, initial(job_support_med))

/datum/preferences/proc/from_sql_language(var/attr_val)
	return sanitize_text(attr_val, initial(language))

/datum/preferences/proc/from_sql_loadout_gear(var/attr_val)
	var/attr_list = params2list(attr_val)
	return attr_list

/datum/preferences/proc/from_sql_m_colours(var/attr_val)
	var/attr_list = params2list(attr_val)
	for(var/marking_location in attr_list)
		attr_list[marking_location] = sanitize_hexcolor(attr_list[marking_location], DEFAULT_MARKING_COLOURS[marking_location])
	return attr_list

/datum/preferences/proc/from_sql_m_styles(var/attr_val)
	var/attr_list = params2list(attr_val)
	for(var/marking_location in attr_list)
		attr_list[marking_location] = sanitize_inlist(attr_list[marking_location], GLOB.marking_styles_list, DEFAULT_MARKING_STYLES[marking_location])
	return attr_list

/datum/preferences/proc/from_sql_med_record(var/attr_val)
	return sanitize_text(attr_val, initial(med_record))

/datum/preferences/proc/from_sql_metadata(var/attr_val)
	return sanitize_text(attr_val, initial(metadata))

/datum/preferences/proc/from_sql_organ_data(var/attr_val)
	var/attr_list = params2list(attr_val)
	return attr_list

/datum/preferences/proc/from_sql_player_alt_titles(var/attr_val)
	var/attr_list = params2list(attr_val)
	return attr_list

/datum/preferences/proc/from_sql_real_name(var/attr_val)
	return sanitize_text(reject_bad_name(attr_val, 1), random_name(gender, species))

/datum/preferences/proc/from_sql_rlimb_data(var/attr_val)
	var/attr_list = params2list(attr_val)
	return attr_list

/datum/preferences/proc/from_sql_s_colour(var/attr_val)
	return sanitize_hexcolor(attr_val, initial(s_colour))

/datum/preferences/proc/from_sql_s_tone(var/attr_val)
	return sanitize_integer(text2num(attr_val), -185, 34, initial(s_tone))

/datum/preferences/proc/from_sql_sec_record(var/attr_val)
	return sanitize_text(attr_val, initial(sec_record))

/datum/preferences/proc/from_sql_socks(var/attr_val)
	return sanitize_text(attr_val, initial(socks))

/datum/preferences/proc/from_sql_species(var/attr_val)
	return sanitize_text(attr_val, initial(species))

/datum/preferences/proc/from_sql_speciesprefs(var/attr_val)
	return sanitize_integer(text2num(attr_val), 0, 1, initial(speciesprefs))

/datum/preferences/proc/from_sql_undershirt(var/attr_val)
	return sanitize_text(attr_val, initial(undershirt))

/datum/preferences/proc/from_sql_underwear(var/attr_val)
	return sanitize_text(attr_val, initial(underwear))

//------------------------------------------------------------------------------

/datum/preferences/proc/to_sql_age(var/attr_val)
	attr_val = sanitize_integer(attr_val, AGE_MIN, AGE_MAX, initial(age))
	return "[attr_val]"

/datum/preferences/proc/to_sql_alt_head(var/attr_val)
	attr_val = sanitize_inlist(attr_val, GLOB.alt_heads_list, initial(alt_head))
	return attr_val

/datum/preferences/proc/to_sql_alternate_option(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 2, initial(alternate_option))
	return "[attr_val]"

/datum/preferences/proc/to_sql_ark_soft_relation(var/attr_val)
	attr_val = sanitize_inlist(attr_val, GLOB.company_relations, initial(ark_soft_relation))
	return attr_val

/datum/preferences/proc/to_sql_autohiss_mode(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 2, initial(autohiss_mode))
	return "[attr_val]"

/datum/preferences/proc/to_sql_b_type(var/attr_val)
	attr_val = sanitize_inlist(attr_val, GLOB.blood_types, initial(b_type))
	return attr_val

/datum/preferences/proc/to_sql_backbag(var/attr_val)
	attr_val = sanitize_inlist(attr_val, GLOB.backbaglist, initial(backbag))
	return attr_val

/datum/preferences/proc/to_sql_be_random_name(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 1, initial(be_random_name))
	return "[attr_val]"

/datum/preferences/proc/to_sql_body_accessory(var/attr_val)
	attr_val = sanitize_inlist(attr_val, GLOB.body_accessory_by_name, "None")
	return attr_val

/datum/preferences/proc/to_sql_disabilities(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(disabilities))
	return "[attr_val]"

/datum/preferences/proc/to_sql_e_colour(var/attr_val)
	attr_val = sanitize_hexcolor(attr_val, initial(e_colour))
	return attr_val

/datum/preferences/proc/to_sql_f_colour(var/attr_val)
	attr_val = sanitize_hexcolor(attr_val, initial(f_colour))
	return attr_val

/datum/preferences/proc/to_sql_f_sec_colour(var/attr_val)
	attr_val = sanitize_hexcolor(attr_val, initial(f_sec_colour))
	return attr_val

/datum/preferences/proc/to_sql_f_style(var/attr_val)
	attr_val = sanitize_inlist(attr_val, GLOB.facial_hair_styles_list, initial(f_style))
	return attr_val

/datum/preferences/proc/to_sql_flavor_text(var/attr_val)
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_gen_record(var/attr_val)
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_gender(var/attr_val)
	var/datum/species/SP = GLOB.all_species[species]
	attr_val = sanitize_gender(attr_val, FALSE, !SP.has_gender)
	return attr_val

/datum/preferences/proc/to_sql_h_colour(var/attr_val)
	attr_val = sanitize_hexcolor(attr_val, initial(h_colour))
	return attr_val

/datum/preferences/proc/to_sql_h_sec_colour(var/attr_val)
	attr_val = sanitize_hexcolor(attr_val, initial(h_sec_colour))
	return attr_val

/datum/preferences/proc/to_sql_h_style(var/attr_val)
	attr_val = sanitize_inlist(attr_val, GLOB.hair_styles_public_list, initial(h_style))
	return attr_val

/datum/preferences/proc/to_sql_ha_style(var/attr_val)
	attr_val = sanitize_inlist(attr_val, GLOB.head_accessory_styles_list, initial(ha_style))
	return attr_val

/datum/preferences/proc/to_sql_hacc_colour(var/attr_val)
	attr_val = sanitize_hexcolor(attr_val, initial(hacc_colour))
	return attr_val

/datum/preferences/proc/to_sql_job_engsec_high(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_engsec_high))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_engsec_low(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_engsec_low))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_engsec_med(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_engsec_med))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_karma_high(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_karma_high))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_karma_low(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_karma_low))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_karma_med(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_karma_med))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_medsci_high(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_medsci_high))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_medsci_low(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_medsci_low))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_medsci_med(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_medsci_med))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_support_high(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_support_high))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_support_low(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_support_low))
	return "[attr_val]"

/datum/preferences/proc/to_sql_job_support_med(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 65535, initial(job_support_med))
	return "[attr_val]"

/datum/preferences/proc/to_sql_language(var/attr_val)
	attr_val = sanitize_text(attr_val, initial(language))
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_loadout_gear(var/attr_val)
	attr_val = list2params(attr_val)
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_m_colours(var/attr_val)
	for(var/marking_location in attr_val)
		attr_val[marking_location] = sanitize_hexcolor(attr_val[marking_location], DEFAULT_MARKING_COLOURS[marking_location])
	attr_val = list2params(attr_val)
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_m_styles(var/attr_val)
	for(var/marking_location in attr_val)
		attr_val[marking_location] = sanitize_inlist(attr_val[marking_location], GLOB.marking_styles_list, DEFAULT_MARKING_STYLES[marking_location])
	attr_val = list2params(attr_val)
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_med_record(var/attr_val)
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_metadata(var/attr_val)
	attr_val = sanitize_text(attr_val, initial(metadata))
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_organ_data(var/attr_val)
	attr_val = list2params(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_player_alt_titles(var/attr_val)
	attr_val = list2params(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_real_name(var/attr_val)
	attr_val = reject_bad_name(attr_val, 1)
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_rlimb_data(var/attr_val)
	attr_val = list2params(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_s_colour(var/attr_val)
	attr_val = sanitize_hexcolor(attr_val, initial(s_colour))
	return attr_val

/datum/preferences/proc/to_sql_s_tone(var/attr_val)
	attr_val = sanitize_integer(attr_val, -185, 34, initial(s_tone))
	return "[attr_val]"

/datum/preferences/proc/to_sql_sec_record(var/attr_val)
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_socks(var/attr_val)
	attr_val = sanitize_text(attr_val, initial(socks))
	return attr_val

/datum/preferences/proc/to_sql_species(var/attr_val)
	attr_val = sanitize_text(attr_val, initial(species))
	attr_val = sanitizeSQL(attr_val)
	return attr_val

/datum/preferences/proc/to_sql_speciesprefs(var/attr_val)
	attr_val = sanitize_integer(attr_val, 0, 1, initial(speciesprefs))
	return "[attr_val]"

/datum/preferences/proc/to_sql_undershirt(var/attr_val)
	attr_val = sanitize_text(attr_val, initial(undershirt))
	return attr_val

/datum/preferences/proc/to_sql_underwear(var/attr_val)
	attr_val = sanitize_text(attr_val, initial(underwear))
	return attr_val

//------------------------------------------------------------------------------
// end of preferences_scorpio.dm
