// webhook.dm
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

// a datum to assist with Scorpio Hosting System webhook integrations

/datum/hosting/webhook
	var/headers     // headers sent in POST request to the Scorpio Hosting System
	var/webhook_url // URL of the Scorpio Hosing System webhook

/datum/hosting/webhook/New(url)
	// initialize the headers we'll send to the Scorpio Hosting System webhook
	headers = json_encode(list(
		"Authorization" = "Bearer [config.scorpio_hosting_token]",
		"Content-Type" = "application/json"
	))
	// initialize the URL we'll use for the Scorpio Hosting System webhook
	webhook_url = url

/datum/hosting/webhook/proc/next_map(map="")
	// if we weren't configured with a webhook URL, just bail out
	if(!webhook_url)
		return
	// otherwise, prepare the message body to be sent to the webhook
	var/body_obj = list("map" = map)
	var/body = json_encode(body_obj)
	// call the webhook async, because this is a best effort action
	var/message_url = webhook_url + "/next-map"
	rustg_http_request_async(RUSTG_HTTP_METHOD_POST, message_url, body, headers)

/datum/hosting/webhook/proc/next_tag(tag="")
	// if we weren't configured with a webhook URL, just bail out
	if(!webhook_url)
		return
	// otherwise, prepare the message body to be sent to the webhook
	var/body_obj = list("tag" = tag)
	var/body = json_encode(body_obj)
	// call the webhook async, because this is a best effort action
	var/message_url = webhook_url + "/next-tag"
	rustg_http_request_async(RUSTG_HTTP_METHOD_POST, message_url, body, headers)

/datum/hosting/webhook/proc/round_end()
	// if we weren't configured with a webhook URL, just bail out
	if(!webhook_url)
		return
	// call the webhook async, because this is a best effort action
	var/message_url = webhook_url + "/round-end"
	rustg_http_request_async(RUSTG_HTTP_METHOD_POST, message_url, "{}", headers)

/datum/hosting/webhook/proc/round_start()
	// if we weren't configured with a webhook URL, just bail out
	if(!webhook_url)
		return
	// call the webhook async, because this is a best effort action
	var/message_url = webhook_url + "/round-start"
	rustg_http_request_async(RUSTG_HTTP_METHOD_POST, message_url, "{}", headers)

//------------------------------------------------------------------------------
// end of webhook.dm
