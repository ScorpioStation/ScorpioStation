#define FILE_CENSUS_BOT_CONFIG_JSON "data/census_bot_config.json"

// {
//     "pop_role_ids": {
//         "@&7447----------8641":10,
//         "@&7447----------5428":15,
//         "@&7447----------2702":20,
//         "@&7447----------4406":25,
//         "@&7447----------2286":30
//     },
//     "round_start_role_id":"@&7447----------2979",
//     "webhook_url":"https://discord.com/api/webhooks/7444----------2082/dSGEPnnbswOciRg+4zk4iD78upMj1LcrNbB9lBdvB3M-rA5Ka1mmB6bKYUThV55AbLOJ"
// }
//
// pop_role_ids is an object
//     the keys are the discord role id with  @&  prepended
//     the values are the population levels that trigger a notification to that role
// round_start_role_id is a string; a discord role id with  @&  prepended
// webhook_url is a string; the URL of the Census Bot discord webhook

SUBSYSTEM_DEF(census)
	init_order = (INIT_ORDER_LAST + 1)              // give people lots of time to reconnect
	name = "Census"
	offline_implications = "Census Bot will not report census levels to Discord. No immediate action is needed."
	wait = 300 SECONDS

	var/last_pop = 0                                // highest population level yet observed
	var/list/pop_role_ids = list()                  // Discord Role IDs to notify for population levels
	var/round_start_role_id = null                  // Role ID to notify for Round Start
	var/datum/discord/webhook/census_bot = null     // Discord Webhook for notifications

/datum/controller/subsystem/census/Initialize()
	// read the current population of the server
	last_pop = length(GLOB.clients)

	// read the Census Bot configuration from the JSON file
	var/json_file = file(FILE_CENSUS_BOT_CONFIG_JSON)

	// if the file doesn't exist, complain and bail
	if(!fexists(json_file))
		log_and_message_admins("[name] subsystem unable to load data from [FILE_CENSUS_BOT_CONFIG_JSON]")
		return ..()

	// decode the JSON data, if it doesn't make sense, complain and bail
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		log_and_message_admins("[name] subsystem unable to decode JSON from [FILE_CENSUS_BOT_CONFIG_JSON]")
		return ..()

	// load up our configuration variables with the JSON provided data
	pop_role_ids = json["pop_role_ids"]
	round_start_role_id = json["round_start_role_id"]

	// create the census_bot webhook for notifications
	census_bot = new(json["webhook_url"])

	// if we've got a round start Discord role and there are enough people connected to play with
	if((round_start_role_id) && (last_pop >= config.census_bot_minimum))
		// announce round start with the current server population
		census_bot.post_message("<[round_start_role_id]> A new round is starting; [last_pop] players reconnected when the server restarted.")

	// finish up successful initialization by returning whatever our parent returns
	return ..()

/datum/controller/subsystem/census/fire()
	// determine the current server population
	var/next_pop = num_active_players()
	var/list/notify_us = list()

	// for each population role we have
	for(var/p in pop_role_ids)
		// determine the population level of that role
		var/pop = pop_role_ids[p]
		// if it's less than what we've seen before, then skip it
		if(pop <= last_pop)
			continue
		// if it's less than what we see now, keep it for notification
		if(pop <= next_pop)
			notify_us.Add(p)

	// update the peak population we've observed
	last_pop = max(last_pop, next_pop)

	// if we have notifications to make
	var/message = ""
	if(length(notify_us) > 0)
		// add in all the roles to be notified
		for(var/role_id in notify_us)
			message += "<[role_id]> "
		// include the current player count
		message += "There are [next_pop] players connected now."

	// if we constructed a message
	if(length(message) > 0)
		census_bot.post_message(message)

	// return successful completion of subsystem
	return TRUE

/datum/controller/subsystem/census/proc/num_active_players()
	// gently borrowed and re-purposed from code/modules/events/event_procs.dm
	var/players = 0
	for(var/mob/M in GLOB.player_list)
		if(!M.mind || !M.client || M.client.inactivity > (10 MINUTES))
			continue
		players++
	return players
