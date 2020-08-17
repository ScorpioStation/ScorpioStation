#define FILE_CENSUS_BOT_CONFIG_JSON "data/census_bot_config.json"
#define RUSTG_HTTP_METHOD_POST "post"
#define rustg_http_request_async(method, url, body, headers) call(RUST_G, "http_request_async")(method, url, body, headers)

SUBSYSTEM_DEF(census)
	init_order = (INIT_ORDER_CHAT + 1)  // give people lots of time to connect
	name = "Census"
	offline_implications = "Census Bot will not report census levels to Discord. No immediate action is needed."
	wait = 300 SECONDS

	var/headers = list()            // headers sent in POST request to Discord
	var/last_pop = 0                // highest population level yet observed
	var/list/pop_role_ids = list()  // Discord Role IDs to notify for population levels
	var/round_start_role_id = null  // Role ID to notify for Round Start
	var/webhook_url = null          // URL of the Discord webhook

/datum/controller/subsystem/census/Initialize()
	// set the flag so that Travis CI can be happy
	initialized = TRUE

	// initialize the headers we'll send to the Discord webhook
	headers = json_encode(list("Content-Type" = "application/json"))

	// read the current population of the server
	last_pop = length(GLOB.clients)

	// read the Census Bot configuration from the JSON file
	var/json_file = file(FILE_CENSUS_BOT_CONFIG_JSON)

	// if the file doesn't exist, complain and bail
	if(!fexists(json_file))
		log_and_message_admins("[name] subsystem unable to load data from [FILE_CENSUS_BOT_CONFIG_JSON]")
		return

	// decode the JSON data, if it doesn't make sense, complain and bail
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		log_and_message_admins("[name] subsystem unable to decode JSON from [FILE_CENSUS_BOT_CONFIG_JSON]")
		return

	// load up our configuration variables with the JSON provided data
	pop_role_ids = json["pop_role_ids"]
	round_start_role_id = json["round_start_role_id"]
	webhook_url = json["webhook_url"]

	// if we've got a round start role, announce round start with the current server population
	if(round_start_role_id)
		post_discord("<[round_start_role_id]> A new round is starting; [last_pop] players reconnected when the server restarted.")

	// finish up successful initialization by returning whatever our parent returns
	return ..()

/datum/controller/subsystem/census/fire()
	log_and_message_admins("DEBUG: [name] subsystem: Firing at [round(world.time/10)]s into the round")

	// determine the current server population
	var/next_pop = length(GLOB.clients)
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
		post_discord(message)

	// return successful completion of subsystem
	return TRUE

/datum/controller/subsystem/census/proc/post_discord(message="")
	// if we weren't configured with a webhook, just bail out
	if(!webhook_url)
		return

	// otherwise, prepare the message body to be sent to the webhook
	var/body_obj = list("content" = message)
	var/body = json_encode(body_obj)

	// call the webhook async, because this is a best effort notification
	log_and_message_admins("DEBUG: [name] subsystem: Calling Discord webhook: [RUSTG_HTTP_METHOD_POST] http://discord.com/webhook [body] [headers]")
	rustg_http_request_async(RUSTG_HTTP_METHOD_POST, webhook_url, body, headers)
