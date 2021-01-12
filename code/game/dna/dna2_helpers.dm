/////////////////////////////
// Helpers for DNA2
/////////////////////////////

// Pads 0s to t until length == u
/proc/add_zero2(t, u)
	var/temp1
	while(length(t) < u)
		t = "0[t]"
	temp1 = t
	if(length(t) > u)
		temp1 = copytext(t, 2, u + 1)
	return temp1

// DNA Gene activation boundaries, see dna2.dm.
// Returns a list object with 4 numbers.
/proc/GetDNABounds(block)
	var/list/BOUNDS = GLOB.dna_activity_bounds[block]
	if(!istype(BOUNDS))
		return DNA_DEFAULT_BOUNDS
	return BOUNDS

// Give Random Bad Mutation to M
/proc/randmutb(mob/living/M)
	if(!M || !M.dna)
		return
	M.dna.check_integrity()
	var/block = pick(GLOB.bad_blocks)
	M.dna.SetDNAState(block, TRUE, DNA_SE)

// Give Random Good Mutation to M
/proc/randmutg(mob/living/M)
	if(!M || !M.dna)
		return
	M.dna.check_integrity()
	var/block = pick(GLOB.good_blocks)
	M.dna.SetDNAState(block, TRUE, DNA_SE)

// Random Appearance Mutation
/proc/randmuti(mob/living/M)
	if(!M || !M.dna)
		return
	M.dna.check_integrity()
	M.dna.SetDNAValue(rand(1, DNA_UI_LENGTH), rand(1, 4095), DNA_UI)

// Scramble UI or SE.
/proc/scramble(UI, mob/M, prob)
	if(!M || !M.dna)
		return
	M.dna.check_integrity()
	if(UI)
		for(var/i = 1, i <= DNA_UI_LENGTH - 1, i++)
			if(prob(prob))
				M.dna.SetDNAValue(i, rand(1, 4095), DNA_UI, TRUE)
		M.dna.UpdateDNA(DNA_UI)
		M.UpdateAppearance()

	else
		for(var/i = 1, i <= DNA_SE_LENGTH - 1, i++)
			if(prob(prob))
				M.dna.SetDNAValue(i, rand(1, 4095), DNA_SE, TRUE)
		M.dna.UpdateDNA(DNA_SE)
		domutcheck(M, null)

// I haven't yet figured out what the fuck this is supposed to do.
/proc/miniscramble(input, rs, rd)
	var/output
	output = null
	if(input == "C" || input == "D" || input == "E" || input == "F")
		output = pick(prob((rs*10));"4",prob((rs*10));"5",prob((rs*10));"6",prob((rs*10));"7",prob((rs*5)+(rd));"0",prob((rs*5)+(rd));"1",prob((rs*10)-(rd));"2",prob((rs*10)-(rd));"3")
	if(input == "8" || input == "9" || input == "A" || input == "B")
		output = pick(prob((rs*10));"4",prob((rs*10));"5",prob((rs*10));"A",prob((rs*10));"B",prob((rs*5)+(rd));"C",prob((rs*5)+(rd));"D",prob((rs*5)+(rd));"2",prob((rs*5)+(rd));"3")
	if(input == "4" || input == "5" || input == "6" || input == "7")
		output = pick(prob((rs*10));"4",prob((rs*10));"5",prob((rs*10));"A",prob((rs*10));"B",prob((rs*5)+(rd));"C",prob((rs*5)+(rd));"D",prob((rs*5)+(rd));"2",prob((rs*5)+(rd));"3")
	if(input == "0" || input == "1" || input == "2" || input == "3")
		output = pick(prob((rs*10));"8",prob((rs*10));"9",prob((rs*10));"A",prob((rs*10));"B",prob((rs*10)-(rd));"C",prob((rs*10)-(rd));"D",prob((rs*5)+(rd));"E",prob((rs*5)+(rd));"F")
	if(!output) output = "5"
	return output

// HELLO I MAKE BELL CURVES AROUND YOUR DESIRED TARGET
// So a shitty way of replacing gaussian noise.
// input: YOUR TARGET
// rs: RAD STRENGTH
// rd: DURATION
/proc/miniscrambletarget(input, rs, rd)
	var/output = null
	switch(input)
		if("0")
			output = pick(prob((rs*10)+(rd));"0",prob((rs*10)+(rd));"1",prob((rs*10));"2",prob((rs*10)-(rd));"3")
		if("1")
			output = pick(prob((rs*10)+(rd));"0",prob((rs*10)+(rd));"1",prob((rs*10)+(rd));"2",prob((rs*10));"3",prob((rs*10)-(rd));"4")
		if("2")
			output = pick(prob((rs*10));"0",prob((rs*10)+(rd));"1",prob((rs*10)+(rd));"2",prob((rs*10)+(rd));"3",prob((rs*10));"4",prob((rs*10)-(rd));"5")
		if("3")
			output = pick(prob((rs*10)-(rd));"0",prob((rs*10));"1",prob((rs*10)+(rd));"2",prob((rs*10)+(rd));"3",prob((rs*10)+(rd));"4",prob((rs*10));"5",prob((rs*10)-(rd));"6")
		if("4")
			output = pick(prob((rs*10)-(rd));"1",prob((rs*10));"2",prob((rs*10)+(rd));"3",prob((rs*10)+(rd));"4",prob((rs*10)+(rd));"5",prob((rs*10));"6",prob((rs*10)-(rd));"7")
		if("5")
			output = pick(prob((rs*10)-(rd));"2",prob((rs*10));"3",prob((rs*10)+(rd));"4",prob((rs*10)+(rd));"5",prob((rs*10)+(rd));"6",prob((rs*10));"7",prob((rs*10)-(rd));"8")
		if("6")
			output = pick(prob((rs*10)-(rd));"3",prob((rs*10));"4",prob((rs*10)+(rd));"5",prob((rs*10)+(rd));"6",prob((rs*10)+(rd));"7",prob((rs*10));"8",prob((rs*10)-(rd));"9")
		if("7")
			output = pick(prob((rs*10)-(rd));"4",prob((rs*10));"5",prob((rs*10)+(rd));"6",prob((rs*10)+(rd));"7",prob((rs*10)+(rd));"8",prob((rs*10));"9",prob((rs*10)-(rd));"A")
		if("8")
			output = pick(prob((rs*10)-(rd));"5",prob((rs*10));"6",prob((rs*10)+(rd));"7",prob((rs*10)+(rd));"8",prob((rs*10)+(rd));"9",prob((rs*10));"A",prob((rs*10)-(rd));"B")
		if("9")
			output = pick(prob((rs*10)-(rd));"6",prob((rs*10));"7",prob((rs*10)+(rd));"8",prob((rs*10)+(rd));"9",prob((rs*10)+(rd));"A",prob((rs*10));"B",prob((rs*10)-(rd));"C")
		if("10")//A
			output = pick(prob((rs*10)-(rd));"7",prob((rs*10));"8",prob((rs*10)+(rd));"9",prob((rs*10)+(rd));"A",prob((rs*10)+(rd));"B",prob((rs*10));"C",prob((rs*10)-(rd));"D")
		if("11")//B
			output = pick(prob((rs*10)-(rd));"8",prob((rs*10));"9",prob((rs*10)+(rd));"A",prob((rs*10)+(rd));"B",prob((rs*10)+(rd));"C",prob((rs*10));"D",prob((rs*10)-(rd));"E")
		if("12")//C
			output = pick(prob((rs*10)-(rd));"9",prob((rs*10));"A",prob((rs*10)+(rd));"B",prob((rs*10)+(rd));"C",prob((rs*10)+(rd));"D",prob((rs*10));"E",prob((rs*10)-(rd));"F")
		if("13")//D
			output = pick(prob((rs*10)-(rd));"A",prob((rs*10));"B",prob((rs*10)+(rd));"C",prob((rs*10)+(rd));"D",prob((rs*10)+(rd));"E",prob((rs*10));"F")
		if("14")//E
			output = pick(prob((rs*10)-(rd));"B",prob((rs*10));"C",prob((rs*10)+(rd));"D",prob((rs*10)+(rd));"E",prob((rs*10)+(rd));"F")
		if("15")//F
			output = pick(prob((rs*10)-(rd));"C",prob((rs*10));"D",prob((rs*10)+(rd));"E",prob((rs*10)+(rd));"F")

	if(!input || !output) //How did this happen?
		output = "8"

	return output

// /proc/updateappearance has changed behavior, so it's been removed
// Use mob.UpdateAppearance() instead.

// Simpler. Don't specify UI in order for the mob to use its own.
/mob/proc/UpdateAppearance(list/UI = null)
	if(istype(src, /mob/living/carbon/human)) // WHY?!
		if(UI != null)
			dna.UI = UI
			dna.UpdateDNA(DNA_UI)
		dna.check_integrity()
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/external/head/head_organ = H.get_organ("head")
		var/obj/item/organ/internal/eyes/eye_organ = H.get_int_organ(/obj/item/organ/internal/eyes)
		if(istype(head_organ))
			dna.write_head_attributes(head_organ)
		if(istype(eye_organ))
			dna.write_eyes_attributes(eye_organ)
		H.update_eyes()

		H.skin_colour = rgb(dna.GetDNAValueRange(DNA_UI_SKIN_R, 255, DNA_UI), dna.GetDNAValueRange(DNA_UI_SKIN_G, 255, DNA_UI), dna.GetDNAValueRange(DNA_UI_SKIN_B, 255, DNA_UI))

		H.m_colours["head"] = rgb(dna.GetDNAValueRange(DNA_UI_HEAD_MARK_R, 255, DNA_UI), dna.GetDNAValueRange(DNA_UI_HEAD_MARK_G, 255, DNA_UI), dna.GetDNAValueRange(DNA_UI_HEAD_MARK_B, 255, DNA_UI))
		H.m_colours["body"] = rgb(dna.GetDNAValueRange(DNA_UI_BODY_MARK_R, 255, DNA_UI), dna.GetDNAValueRange(DNA_UI_BODY_MARK_G, 255, DNA_UI), dna.GetDNAValueRange(DNA_UI_BODY_MARK_B, 255, DNA_UI))
		H.m_colours["tail"] = rgb(dna.GetDNAValueRange(DNA_UI_TAIL_MARK_R, 255, DNA_UI), dna.GetDNAValueRange(DNA_UI_TAIL_MARK_G, 255, DNA_UI), dna.GetDNAValueRange(DNA_UI_TAIL_MARK_B, 255, DNA_UI))

		H.s_tone   = 35 - dna.GetDNAValueRange(DNA_UI_SKIN_TONE, 220, DNA_UI) // Value can be negative.

		switch(dna.GetDNATriState(DNA_UI_GENDER, DNA_UI))
			if(DNA_GENDER_FEMALE)
				H.change_gender(FEMALE, FALSE)
			if(DNA_GENDER_MALE)
				H.change_gender(MALE, FALSE)
			if(DNA_GENDER_PLURAL)
				H.change_gender(PLURAL, FALSE)

		//Head Markings
		var/head_marks = dna.GetDNAValueRange(DNA_UI_HEAD_MARK_STYLE, GLOB.marking_styles_list.len, DNA_UI)
		if((head_marks > 0) && (head_marks <= GLOB.marking_styles_list.len))
			H.m_styles["head"] = GLOB.marking_styles_list[head_marks]
		//Body Markings
		var/body_marks = dna.GetDNAValueRange(DNA_UI_BODY_MARK_STYLE, GLOB.marking_styles_list.len, DNA_UI)
		if((body_marks > 0) && (body_marks <= GLOB.marking_styles_list.len))
			H.m_styles["body"] = GLOB.marking_styles_list[body_marks]
		//Tail Markings
		var/tail_marks = dna.GetDNAValueRange(DNA_UI_TAIL_MARK_STYLE, GLOB.marking_styles_list.len, DNA_UI)
		if((tail_marks > 0) && (tail_marks <= GLOB.marking_styles_list.len))
			H.m_styles["tail"] = GLOB.marking_styles_list[tail_marks]

		H.regenerate_icons()

		return TRUE
	else
		return FALSE

/*
	ORGAN WRITING PROCS
*/


// I'm putting this here because nothing outside the DNA module should ever have
// to directly mess with the guts of DNA code

// This proc applies the DNA's information to the given head
/datum/dna/proc/write_head_attributes(obj/item/organ/external/head/head_organ)

	//Hair
	var/hair = GetDNAValueRange(DNA_UI_HAIR_STYLE, GLOB.hair_styles_full_list.len, DNA_UI)
	if((hair > 0) && (hair <= GLOB.hair_styles_full_list.len))
		head_organ.h_style = GLOB.hair_styles_full_list[hair]

	head_organ.hair_colour = rgb(head_organ.dna.GetDNAValueRange(DNA_UI_HAIR_R, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_HAIR_G, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_HAIR_B, 255, DNA_UI))
	head_organ.sec_hair_colour = rgb(head_organ.dna.GetDNAValueRange(DNA_UI_HAIR2_R, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_HAIR2_G, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_HAIR2_B, 255, DNA_UI))

	//Facial Hair
	var/beard = GetDNAValueRange(DNA_UI_BEARD_STYLE, GLOB.facial_hair_styles_list.len, DNA_UI)
	if((beard > 0) && (beard <= GLOB.facial_hair_styles_list.len))
		head_organ.f_style = GLOB.facial_hair_styles_list[beard]

	head_organ.facial_colour = rgb(head_organ.dna.GetDNAValueRange(DNA_UI_BEARD_R, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_BEARD_G, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_BEARD_B, 255, DNA_UI))
	head_organ.sec_facial_colour = rgb(head_organ.dna.GetDNAValueRange(DNA_UI_BEARD2_R, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_BEARD2_G, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_BEARD2_B, 255, DNA_UI))

	//Head Accessories
	var/headacc = GetDNAValueRange(DNA_UI_HACC_STYLE, GLOB.head_accessory_styles_list.len, DNA_UI)
	if((headacc > 0) && (headacc <= GLOB.head_accessory_styles_list.len))
		head_organ.ha_style = GLOB.head_accessory_styles_list[headacc]

	head_organ.headacc_colour = rgb(head_organ.dna.GetDNAValueRange(DNA_UI_HACC_R, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_HACC_G, 255, DNA_UI), head_organ.dna.GetDNAValueRange(DNA_UI_HACC_B, 255, DNA_UI))

// This proc gives the DNA info for eye color to the given eyes
/datum/dna/proc/write_eyes_attributes(obj/item/organ/internal/eyes/eyes_organ)
	eyes_organ.eye_colour = rgb(eyes_organ.dna.GetDNAValueRange(DNA_UI_EYES_R, 255, DNA_UI), eyes_organ.dna.GetDNAValueRange(DNA_UI_EYES_G, 255, DNA_UI), eyes_organ.dna.GetDNAValueRange(DNA_UI_EYES_B, 255, DNA_UI))

/*
	TRAIT CHANGING PROCS
*/
/datum/dna/proc/eye_color_to_dna(obj/item/organ/internal/eyes/eyes_organ)
	if(!eyes_organ)
		// In absence of eyes, possibly randomize the eye color DNA?
		return

	SetDNAValueRange(DNA_UI_EYES_R,	color2R(eyes_organ.eye_colour),	255, DNA_UI, TRUE)
	SetDNAValueRange(DNA_UI_EYES_G,	color2G(eyes_organ.eye_colour),	255, DNA_UI, TRUE)
	SetDNAValueRange(DNA_UI_EYES_B,	color2B(eyes_organ.eye_colour),	255, DNA_UI, TRUE)

/datum/dna/proc/head_traits_to_dna(obj/item/organ/external/head/head_organ)
	if(!head_organ)
		log_runtime(EXCEPTION("Attempting to reset DNA from a missing head!"), src)
		return
	if(!head_organ.h_style)
		head_organ.h_style = "Skinhead"
	var/hair = GLOB.hair_styles_full_list.Find(head_organ.h_style)

	// Facial Hair
	if(!head_organ.f_style)
		head_organ.f_style = "Shaved"
	var/beard	= GLOB.facial_hair_styles_list.Find(head_organ.f_style)

	// Head Accessory
	if(!head_organ.ha_style)
		head_organ.ha_style = "None"
	var/headacc	= GLOB.head_accessory_styles_list.Find(head_organ.ha_style)

	SetDNAValueRange(DNA_UI_HAIR_R,		color2R(head_organ.hair_colour),		255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_HAIR_G,		color2G(head_organ.hair_colour),		255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_HAIR_B,		color2B(head_organ.hair_colour),		255,	 DNA_UI,	TRUE)

	SetDNAValueRange(DNA_UI_HAIR2_R,		color2R(head_organ.sec_hair_colour),	255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_HAIR2_G,		color2G(head_organ.sec_hair_colour),	255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_HAIR2_B,		color2B(head_organ.sec_hair_colour),	255,	 DNA_UI,	TRUE)

	SetDNAValueRange(DNA_UI_BEARD_R,		color2R(head_organ.facial_colour),		255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_BEARD_G,		color2G(head_organ.facial_colour),		255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_BEARD_B,		color2B(head_organ.facial_colour),		255,	 DNA_UI,	TRUE)

	SetDNAValueRange(DNA_UI_BEARD2_R,	color2R(head_organ.sec_facial_colour),	255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_BEARD2_G,	color2G(head_organ.sec_facial_colour),	255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_BEARD2_B,	color2B(head_organ.sec_facial_colour),	255,	 DNA_UI,	TRUE)

	SetDNAValueRange(DNA_UI_HACC_R,		color2R(head_organ.headacc_colour),		255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_HACC_G,		color2G(head_organ.headacc_colour),		255,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_HACC_B,		color2B(head_organ.headacc_colour),		255,	 DNA_UI,	TRUE)

	SetDNAValueRange(DNA_UI_HAIR_STYLE,	hair,		GLOB.hair_styles_full_list.len,		 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_BEARD_STYLE,	beard,		GLOB.facial_hair_styles_list.len,	 DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_HACC_STYLE,	headacc,	GLOB.head_accessory_styles_list.len, DNA_UI,	TRUE)
