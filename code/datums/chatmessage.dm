/// How long the chat message's spawn-in animation will occur for
#define CHAT_MESSAGE_SPAWN_TIME		0.2 SECONDS
/// How long the chat message will exist prior to any exponential decay
#define CHAT_MESSAGE_LIFESPAN		5 SECONDS
/// How long the chat message's end of life fading animation will occur for
#define CHAT_MESSAGE_EOL_FADE		0.7 SECONDS
/// Factor of how much the message index (number of messages) will account to exponential decay
#define CHAT_MESSAGE_EXP_DECAY		0.7
/// Factor of how much height will account to exponential decay
#define CHAT_MESSAGE_HEIGHT_DECAY	0.9
/// Approximate height in pixels of an 'average' line, used for height decay
#define CHAT_MESSAGE_APPROX_LHEIGHT	11
/// Max width of chat message in pixels
#define CHAT_MESSAGE_WIDTH			96
/// Max length of chat message in characters
#define CHAT_MESSAGE_MAX_LENGTH		110
/// Maximum precision of float before rounding errors occur (in this context)
#define CHAT_LAYER_Z_STEP			0.0001
/// The number of z-layer 'slices' usable by the chat message layering
#define CHAT_LAYER_MAX_Z			(CHAT_LAYER_MAX - CHAT_LAYER) / CHAT_LAYER_Z_STEP
/// Macro from Lummox used to get height from a MeasureText proc
#define WXH_TO_HEIGHT(x)			text2num(copytext(x, findtextEx(x, "x") + 1))

/**
  * # Chat Message Overlay
  *
  * Datum for generating a message overlay on the map
  */
/datum/chatmessage
	/// The visual element of the chat messsage
	var/image/message
	/// The location in which the message is appearing
	var/atom/message_loc
	/// The client who heard this message
	var/client/owned_by
	/// Contains the scheduled destruction time, used for scheduling EOL
	var/scheduled_destruction
	/// Contains the time that the EOL for the message will be complete, used for qdel scheduling
	var/eol_complete
	/// Contains the approximate amount of lines for height decay
	var/approx_lines
	/// Contains the reference to the next chatmessage in the bucket, used by runechat subsystem
	var/static/current_z_idx = 0
	/// Contains the reference to the next chatmessage in the bucket, used by runechat subsystem
	var/datum/chatmessage/next
	/// Contains the reference to the previous chatmessage in the bucket, used by runechat subsystem
	var/datum/chatmessage/prev

/**
  * Constructs a chat message overlay
  *
  * Arguments:
  * * text - The text content of the overlay
  * * target - The target atom to display the overlay at
  * * owner - The mob that owns this overlay, only this mob will be able to view it
  * * radio_freq - Radio frequency color to use
  * * italics - Should we use italics or not
  * * lifespan - The lifespan of the message in deciseconds
  */
/datum/chatmessage/New(text, atom/target, mob/owner, radio_freq, italics, size, lifespan = CHAT_MESSAGE_LIFESPAN)
	. = ..()
	if (!istype(target))
		CRASH("Invalid target given for chatmessage")
	if(QDELETED(owner) || !istype(owner) || !owner.client)
		stack_trace("/datum/chatmessage created with [isnull(owner) ? "null" : "invalid"] mob owner")
		qdel(src)
		return
	INVOKE_ASYNC(src, .proc/generate_image, text, target, owner, radio_freq, lifespan, italics, size)

/datum/chatmessage/Destroy()
	if (owned_by)
		if (owned_by.seen_messages)
			LAZYREMOVEASSOC(owned_by.seen_messages, message_loc, src)
		owned_by.images.Remove(message)
	owned_by = null
	message_loc = null
	message = null
	leave_subsystem()
	return ..()

/**
  * Calls qdel on the chatmessage when its parent is deleted, used to register qdel signal
  */
/datum/chatmessage/proc/on_parent_qdel()
	qdel(src)

/**
  * Generates a chat message image representation
  *
  * Arguments:
  * * text - The text content of the overlay
  * * target - The target atom to display the overlay at
  * * owner - The mob that owns this overlay, only this mob will be able to view it
  * * radio_speech - Fancy shmancy radio icon represents that we use radio
  * * lifespan - The lifespan of the message in deciseconds
  * * italics - Just copy and paste, sir
  */
/datum/chatmessage/proc/generate_image(text, atom/target, mob/owner, radio_freq, lifespan, italics, size)
	// Register client who owns this message
	owned_by = owner.client
	RegisterSignal(owned_by, COMSIG_PARENT_QDELETING, .proc/on_parent_qdel)

	// Clip message
	var/maxlen = owned_by.prefs.max_chat_length
	var/datum/html/split_holder/s = split_html(text)
	if (length_char(s.inner_text) > maxlen)
		var/chattext = copytext_char(s.inner_text, 1, maxlen + 1) + "..."
		text = jointext(s.opening, "") + chattext + jointext(s.closing, "")


	// Get rid of any URL schemes that might cause BYOND to automatically wrap something in an anchor tag
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	text = replacetext(text, url_scheme, "")

	// Reject whitespace
	var/static/regex/whitespace = new(@"^\s*$")
	if (whitespace.Find(text))
		qdel(src)
		return

	// Append radio icon
	if (radio_freq)
		var/icon/r_icon = new('icons/effects/chat_icons.dmi', icon_state = "radio")
		r_icon.SwapColor("#ffffff", colorize_radio_freq(radio_freq))
		text = "\icon[r_icon]&nbsp;" + text


	// Approximate text height
	var/static/regex/html_metachars = new(@"&[A-Za-z]{1,7};", "g")
	var/complete_text = "<span class='center maptext[italics ? "" : " italics"] [size ? "" : " [size]"]' style='color: [target.chat_color]'>[text]</span>"
	var/mheight = WXH_TO_HEIGHT(owned_by.MeasureText(complete_text, null, CHAT_MESSAGE_WIDTH))
	approx_lines = max(1, mheight / CHAT_MESSAGE_APPROX_LHEIGHT)

	// Translate any existing messages upwards, apply exponential decay factors to timers
	message_loc = target
	if (owned_by.seen_messages)
		var/idx = 1
		var/combined_height = approx_lines
		for(var/msg in owned_by.seen_messages[message_loc])
			var/datum/chatmessage/m = msg
			animate(m.message, pixel_y = m.message.pixel_y + mheight, time = CHAT_MESSAGE_SPAWN_TIME)
			combined_height += m.approx_lines
			var/sched_remaining = m.scheduled_destruction - world.time
			if (!m.eol_complete)
				var/remaining_time = (sched_remaining) * (CHAT_MESSAGE_EXP_DECAY ** idx++) * (CHAT_MESSAGE_HEIGHT_DECAY ** combined_height)
				m.enter_subsystem(world.time + remaining_time) // push updated time to runechat SS

	// Reset z index if relevant
	if (current_z_idx >= CHAT_LAYER_MAX_Z)
		current_z_idx = 0

	// Build message image
	message = image(loc = message_loc, layer = CHAT_LAYER + CHAT_LAYER_Z_STEP * current_z_idx++)
	message.plane = GAME_PLANE
	message.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	message.alpha = 0
	message.pixel_y = owner.bound_height * 0.95
	message.maptext_width = CHAT_MESSAGE_WIDTH
	message.maptext_height = mheight
	message.maptext_x = (CHAT_MESSAGE_WIDTH - owner.bound_width) * -0.5
	message.maptext = complete_text

	// View the message
	LAZYADDASSOC(owned_by.seen_messages, message_loc, src)
	owned_by.images |= message
	animate(message, alpha = 255, time = CHAT_MESSAGE_SPAWN_TIME)

	// Prepare for destruction
	scheduled_destruction = world.time + (lifespan - CHAT_MESSAGE_EOL_FADE)
	enter_subsystem()


/**
  * Applies final animations to overlay CHAT_MESSAGE_EOL_FADE deciseconds prior to message deletion
  */
/datum/chatmessage/proc/end_of_life(fadetime = CHAT_MESSAGE_EOL_FADE)
	eol_complete = scheduled_destruction + fadetime
	animate(message, alpha = 0, time = fadetime, flags = ANIMATION_PARALLEL)
	enter_subsystem(eol_complete) // re-enter the runechat SS with the EOL completion time to QDEL self


/**
  * Creates a message overlay at a defined location for a given speaker
  *
  * Arguments:
  * * speaker - The atom who is saying this message
  * * raw_message - The text content of the message
  * * italics - Vacuum and other things
  * * radio_freq - What frequency was used, if any. This is for tinting the radio icon
  */
/mob/proc/create_chat_message(atom/movable/speaker, raw_message, radio_freq, italics, size)

	if(((speaker == src) || (!isturf(speaker.loc)) || (isobserver(src))) && radio_freq && !(size == "big"))
		return

	// Display visual above source
	new /datum/chatmessage(raw_message, speaker, src, radio_freq, italics, size)



/datum/chatmessage/proc/colorize_radio_freq(freq)
	// Handle all syndicate channels (Traitors + Nukeops are on different frequencies)
	if(freq in SSradio.ANTAG_FREQS)
		return "#993F40"

	// Handle all CC channels (ERT and deathsquad use different frequencies3)
	if(freq in SSradio.CENT_FREQS)
		return "#5C5C7C"

	switch(freq)
		if(COMM_FREQ)
			return "#526aff"
		if(AI_FREQ)
			return "#B800B1"
		if(SEC_FREQ)
			return "#CF0000"
		if(ENG_FREQ)
			return "#A66300"
		if(SCI_FREQ)
			return "#993399"
		if(MED_FREQ)
			return "#009190"
		if(SUP_FREQ)
			return "#9F8545"
		if(SRV_FREQ)
			return "#80A000"
		else
			return "#408010"
