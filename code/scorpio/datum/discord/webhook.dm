// webhook.dm
// a datum to assist with Discord Webhook integrations
//
// see: https://support.discord.com/hc/en-us/articles/228383668
// see: https://discord.com/developers/docs/resources/webhook

/datum/discord/webhook
    var/headers     // headers sent in POST request to Discord
    var/webhook_url // URL of the Discord webhook

/datum/discord/webhook/New(url)
    // initialize the headers we'll send to the Discord webhook
    headers = json_encode(list("Content-Type" = "application/json"))
    // initialize the URL we'll use for the Discord Webhook
    webhook_url = url

/datum/discord/webhook/proc/post_message(message="")
	// if we weren't configured with a webhook URL, just bail out
	if(!webhook_url)
		return
	// otherwise, prepare the message body to be sent to the webhook
	var/body_obj = list("content" = message)
	var/body = json_encode(body_obj)
	// call the webhook async, because this is a best effort action
	rustg_http_request_async(RUSTG_HTTP_METHOD_POST, webhook_url, body, headers)
