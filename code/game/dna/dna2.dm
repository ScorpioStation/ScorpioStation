/**
* DNA 2: The Spaghetti Strikes Back
*
* @author N3X15 <nexisentertainment@gmail.com>
*/


// Used to determine what each block means (admin hax and species stuff on /vg/, mostly)
GLOBAL_LIST_INIT(dna_activity_bounds, new(DNA_SE_LENGTH))

GLOBAL_LIST_INIT(assigned_SE_blocks, new(DNA_SE_LENGTH))	// Used to determine what each block means (admin hax and species stuff on /vg/, mostly)
GLOBAL_LIST_INIT(randomized_SE_blocks, new(DNA_SE_LENGTH))	//List of SE gene blocks randomly-assigned per game-round via 'setupgame.dm'

GLOBAL_LIST_EMPTY(struc_enzy_genes)		//Structural Enzyme Genes
GLOBAL_LIST_EMPTY(roleplay_genes)		//Roleplaying Preferences Genes
GLOBAL_LIST_EMPTY(all_dna_genes)		//All Genes

GLOBAL_LIST_EMPTY(good_blocks)
GLOBAL_LIST_EMPTY(bad_blocks)

/datum/dna
	// READ-ONLY, GETS OVERWRITTEN
	// DO NOT FUCK WITH THESE OR BYOND WILL EAT YOUR FACE
	var/uni_identity = "" // Encoded UI
	var/struc_enzymes = "" // Encoded SE
	var/roleplay_prefs = "" //Encoded RP
	var/unique_enzymes = "" // MD5 of player name

	// Original Encoded SE, for use with Ryetalin
	var/struc_enzymes_original = "" // Encoded SE
	var/list/SE_original[DNA_SE_LENGTH]

	// Internal dirtiness checks
	var/dirtyUI = FALSE
	var/dirtySE = FALSE
	var/dirtyRP = FALSE

	// Okay to read, but you're an idiot if you do.
	// BLOCK = VALUE
	var/list/SE[DNA_SE_LENGTH]
	var/list/UI[DNA_UI_LENGTH]
	var/list/RP[DNA_RP_LENGTH]

	// From old dna.
	var/blood_type = "A+"				// Should probably change to an integer => string map but I'm lazy. //Voxxy thinks is fine for now, past commenter, but maybe can help you?
	var/real_name						// Stores the real name of the person who originally got this dna datum. Used primarily for changelings.

	//Disabilities
	var/list/incur_blocks = list()		//List of incurable Disability blocks
	var/list/stutter_langs = list()		//List of Languages a character is set to trigger an RP Stutter on

	var/datum/species/species = new /datum/species/human //The type of mutant race the player is if applicable (i.e. potato-man)
	var/list/default_blocks = list() //list of all blocks toggled at roundstart

// Make a copy of this strand.
// USE THIS WHEN COPYING STUFF OR YOU'LL GET CORRUPTION!
/datum/dna/proc/Clone()
	var/datum/dna/new_dna = new()
	new_dna.unique_enzymes = unique_enzymes
	new_dna.struc_enzymes_original = struc_enzymes_original // will make clone's SE the same as the original, do we want this?
	new_dna.blood_type = blood_type
	new_dna.real_name = real_name
	new_dna.species = new species.type
	for(var/b=1;b<=DNA_SE_LENGTH;b++) //Should DNA_RP be involved in here somewhere? Iunno!
		new_dna.SE[b]=SE[b]
		if(b<=DNA_UI_LENGTH)
			new_dna.UI[b]=UI[b]
	new_dna.UpdateDNA(DNA_ALL)
	return new_dna

///////////////////////////////////////
// UPDATE and RESET types of DNA
///////////////////////////////////////

/datum/dna/proc/ResetDNA(dna_type, defer = FALSE)
	ASSERT(dna_type >= 0)
	ASSERT(dna_type <= 3)
	switch(dna_type)
		if(DNA_UI)					// Create a random UI
			for(var/i =1, i <= DNA_UI_LENGTH, i++)
				if(i == DNA_UI_SKIN_TONE)
					SetDNAValueRange(DNA_UI_SKIN_TONE, rand(1, 220), 220, DNA_UI, TRUE) // Otherwise, it gets fucked
				else
					UI[i] = rand(0, 4095)
			if(!defer)
				UpdateDNA(DNA_UI)
		if(DNA_SE)				// "Zeroes out" all of the SE Blocks
			for(var/i = 1, i <= DNA_SE_LENGTH, i++)
				SetDNAValue(i, rand(1, 1024), TRUE, DNA_SE)
			UpdateDNA(DNA_SE)
		if(DNA_RP)
			for(var/i = 1, i <= DNA_RP_LENGTH, i++)
				SetDNAValue(i, rand(1, 1024), TRUE, DNA_RP)
			UpdateDNA(DNA_RP)
		if(DNA_ALL) //Recurse! Reeeecccuuuuurrrrsssseeee! AHAHAHAHAHAHAHAHA!
			ResetDNA(DNA_UI)
			ResetDNA(DNA_SE)
			ResetDNA(DNA_RP)

/datum/dna/proc/UpdateDNA(dna_type)
	ASSERT(dna_type >= 0)
	ASSERT(dna_type <= 3)
	switch(dna_type)
		if(DNA_UI)
			uni_identity = ""
			for(var/block in UI)
				uni_identity += EncodeDNABlock(block)
			dirtyUI = FALSE
		if(DNA_SE)
			struc_enzymes = ""
			for(var/block in SE)
				struc_enzymes += EncodeDNABlock(block)
			dirtySE = FALSE
		if(DNA_RP)
			roleplay_prefs = ""
			for(var/block in RP)
				roleplay_prefs += EncodeDNABlock(block)
			dirtyRP = FALSE
		if(DNA_ALL) //Heck you again!
			UpdateDNA(DNA_UI)
			UpdateDNA(DNA_SE)
			UpdateDNA(DNA_RP)


/datum/dna/proc/ResetDNAFrom(mob/living/carbon/human/character, dna_type)
	if(dna_type != DNA_UI)
		return
	ResetDNA(DNA_UI, TRUE)		// INITIALIZE!
	var/obj/item/organ/external/head/H = character.get_organ("head")	// Hair // FIXME:  Species-specific defaults pls
	var/obj/item/organ/internal/eyes/eyes_organ = character.get_int_organ(/obj/item/organ/internal/eyes)

	/*// Body Accessory
	if(!character.body_accessory)
		character.body_accessory = null
	var/bodyacc	= character.body_accessory*/

	// Markings
	if(!character.m_styles)
		character.m_styles = DEFAULT_MARKING_STYLES

	var/head_marks	= GLOB.marking_styles_list.Find(character.m_styles["head"])
	var/body_marks	= GLOB.marking_styles_list.Find(character.m_styles["body"])
	var/tail_marks	= GLOB.marking_styles_list.Find(character.m_styles["tail"])

	head_traits_to_dna(H)
	eye_color_to_dna(eyes_organ)

	SetDNAValueRange(DNA_UI_SKIN_R,		color2R(character.skin_colour),			255,	DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_SKIN_G,		color2G(character.skin_colour),			255,	DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_SKIN_B,		color2B(character.skin_colour),			255,	DNA_UI,	TRUE)

	SetDNAValueRange(DNA_UI_HEAD_MARK_R,	color2R(character.m_colours["head"]),	255,	DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_HEAD_MARK_G,	color2G(character.m_colours["head"]),	255,	DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_HEAD_MARK_B,	color2B(character.m_colours["head"]),	255,	DNA_UI,	TRUE)

	SetDNAValueRange(DNA_UI_BODY_MARK_R,	color2R(character.m_colours["body"]),	255,	DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_BODY_MARK_G,	color2G(character.m_colours["body"]),	255,	DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_BODY_MARK_B,	color2B(character.m_colours["body"]),	255,	DNA_UI,	TRUE)

	SetDNAValueRange(DNA_UI_TAIL_MARK_R,	color2R(character.m_colours["tail"]),	255,	DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_TAIL_MARK_G,	color2G(character.m_colours["tail"]),	255,	DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_TAIL_MARK_B,	color2B(character.m_colours["tail"]),	255,	DNA_UI,	TRUE)

	SetDNAValueRange(DNA_UI_SKIN_TONE,	35-character.s_tone,	220,	DNA_UI,	TRUE) // Value can be negative.

	/*SetDNAValueRange(DNA_UI_BACC_STYLE,	bodyacc,	GLOB.facial_hair_styles_list.len,	DNA_UI,	TRUE)*/
	SetDNAValueRange(DNA_UI_HEAD_MARK_STYLE,	head_marks,		GLOB.marking_styles_list.len,		DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_BODY_MARK_STYLE,	body_marks,		GLOB.marking_styles_list.len,		DNA_UI,	TRUE)
	SetDNAValueRange(DNA_UI_TAIL_MARK_STYLE,	tail_marks,		GLOB.marking_styles_list.len,		DNA_UI,	TRUE)

	//Set the Gender
	switch(character.gender)
		if(FEMALE)
			SetDNATriState(DNA_UI_GENDER, DNA_GENDER_FEMALE, DNA_UI, TRUE)
		if(MALE)
			SetDNATriState(DNA_UI_GENDER, DNA_GENDER_MALE, DNA_UI, TRUE)
		if(PLURAL)
			SetDNATriState(DNA_UI_GENDER, DNA_GENDER_PLURAL, DNA_UI, TRUE)


	UpdateDNA(DNA_UI)


/datum/dna/proc/ValidCheck(block, dna_type)
	if(block <= 0 || dna_type < 0 || dna_type > 2 || dna_type == null)
		return FALSE
	else
		return TRUE

///////////////////////////////////////
// SET and GET values for DNA blocks
///////////////////////////////////////

// Set a DNA block's raw value.
/datum/dna/proc/SetDNAValue(block, value, dna_type, defer = FALSE)
	if(!ValidCheck(block, dna_type))
		return
	ASSERT(value > 0)
	ASSERT(value <= 4095)
	switch(dna_type)
		if(DNA_UI)
			UI[block] = value
			dirtyUI = TRUE
		if(DNA_SE)
			SE[block] = value
			dirtySE = TRUE
		if(DNA_RP)
			RP[block] = value
			dirtyRP = TRUE
	if(!defer)
		UpdateDNA(dna_type)

// Get a DNA block's raw value.
/datum/dna/proc/GetDNAValue(block, dna_type)
	if(!ValidCheck(block, dna_type))
		return FALSE
	switch(dna_type)
		if(DNA_UI)
			return UI[block]
		if(DNA_SE)
			return SE[block]
		if(DNA_RP)
			return RP[block]

// Set a DNA block's value, given a value and a max possible value
/datum/dna/proc/SetDNAValueRange(block, value, maxvalue, dna_type, defer = FALSE)
	if(!ValidCheck(block, dna_type) || !value)
		return
	ASSERT(maxvalue <= 4095)
	var/range = (4095 / maxvalue)
	switch(dna_type)
		if(DNA_UI)			// Used in hair and facial styles (value being the index and maxvalue being the len of the hairstyle list)
			if(value == 0)
				value = 1
			SetDNAValue(block, round(value * range), DNA_UI, defer)
		if(DNA_SE)		// Might be used for species?
			SetDNAValue(block, round(value * range) - rand(1, range - 1), DNA_SE)
		if(DNA_RP)
			SetDNAValue(block, round(value * range), DNA_RP)

// Getter version of above.
/datum/dna/proc/GetDNAValueRange(block, maxvalue, dna_type)
	if(!ValidCheck(block, dna_type))
		return FALSE
	var/value = GetDNAValue(block, dna_type)
	return round(1 + (value / 4096) * maxvalue)

/*
 * STATE BLOCKS
 * These procs set and get values for both binary and trinary DNA-stated blocks.else
 */

// Set UI gene "on" (TRUE) or "off" (FALSE)
/datum/dna/proc/SetDNAState(block, on, dna_type, defer = FALSE)
	if(!ValidCheck(block,dna_type))
		return
	var/val
	switch(dna_type)
		if(DNA_UI)
			if(on)		//Are we setting the state of this block to "on" (TRUE)?
				val = rand(2050, 4095)
			else		//Or to "off" (FALSE)?
				val = rand(1, 2049)
		if(DNA_SE)
			var/list/BOUNDS=GetDNABounds(block)
			if(on)
				val = rand(BOUNDS[DNA_ON_LOWERBOUND], BOUNDS[DNA_ON_UPPERBOUND])
			else
				val = rand(1, BOUNDS[DNA_OFF_UPPERBOUND])
		if(DNA_RP)
			val = on		// DNA_RP is simple, okay? "on" is on and "off" is off!
	SetDNAValue(block, val, dna_type, defer)

// Is the block "on" (TRUE) or "off" (FALSE)?
/datum/dna/proc/GetDNAState(block, dna_type)
	if(!ValidCheck(block,dna_type))
		return
	switch(dna_type)
		if(DNA_UI)			// For UI, this is simply a check of if the value is > 2050.
			return UI[block] > 2050
		if(DNA_SE)		//(Un-assigned genes are always off.)
			var/list/BOUNDS = GetDNABounds(block)
			var/value = GetDNAValue(block, DNA_SE)
			return (value >= BOUNDS[DNA_ON_LOWERBOUND])
		if(DNA_RP)			//Look, it's simple!
			return RP[block] > 0

// Set Trinary DNA Block State
/datum/dna/proc/SetDNATriState(block, value, dna_type, defer = FALSE)
	if(!ValidCheck(block, dna_type))
		return
	ASSERT(value >= 0)
	ASSERT(value <= 2)
	var/val
	switch(value)
		if(0)
			val = rand(1, 1395)
		if(1)
			val = rand(1396, 2760)
		if(2)
			val = rand(2761, 4095)
	SetDNAValue(block, val, dna_type, defer)

//Get TriState Block State
/datum/dna/proc/GetDNATriState(block, dna_type)
	if(!ValidCheck(block, dna_type))
		return
	var/val = GetDNAValue(block, dna_type)
	switch(val)
		if(1 to 1395)
			return 0
		if(1396 to 2760)
			return 1
		if(2761 to 4095)
			return 2

/////////////////////////////////////////
// ENCODE and SET-GET sub-blocks of DNA
/////////////////////////////////////////

// Hex-Encode a DNA block - wait which block? oh, that's in the code below, because that makes sense. Sure, why not!
/proc/EncodeDNABlock(value)
	return add_zero2(num2hex(value, 1), 3)

// Get a hex-encoded DNA block.
/datum/dna/proc/GetDNABlock(block, dna_type)
	if(!ValidCheck(block, dna_type))
		return
	return EncodeDNABlock(GetDNAValue(block, dna_type))

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetDNAValue().
// Used in DNA modifiers.
/datum/dna/proc/SetDNABlock(block, value, dna_type, defer = FALSE)
	if(!ValidCheck(block, dna_type))
		return
	return SetDNAValue(block, hex2num(value), dna_type, defer)

// Get a sub-block from a block.
/datum/dna/proc/GetDNASubBlock(block, subBlock, dna_type)
	if(!ValidCheck(block, dna_type))
		return
	return copytext(GetDNABlock(block, dna_type), subBlock, subBlock + 1)

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetDNAValue().
// Used in DNA modifiers.
/datum/dna/proc/SetDNASubBlock(block, subBlock, newSubBlock, dna_type, defer = FALSE)
	if(!ValidCheck(block, dna_type))
		return
	var/oldBlock = GetDNABlock(block, dna_type)
	var/newBlock = ""
	for(var/i = 1, i <= length(oldBlock), i++)
		if(i==subBlock)
			newBlock += newSubBlock
		else
			newBlock += copytext(oldBlock, i, i + 1)
	SetDNABlock(block, newBlock, dna_type, defer)


///////////////////////////////////////
// OTHER procs for DNA fuctionality
///////////////////////////////////////

// BACK-COMPAT!
//  Just checks our character has all the crap it needs.
/datum/dna/proc/check_integrity(mob/living/carbon/human/character)
	if(character)
		if(UI.len != DNA_UI_LENGTH)
			ResetDNAFrom(character, DNA_UI)

		if(length(struc_enzymes)!= 3 * DNA_SE_LENGTH)
			ResetDNA(DNA_SE)

		if(length(unique_enzymes) != 32)
			unique_enzymes = md5(character.real_name)
	else
		if(length(uni_identity) != 3 * DNA_UI_LENGTH)
			uni_identity = "00600200A00E0110148FC01300B0095BD7FD3F4"
		if(length(struc_enzymes)!= 3 * DNA_SE_LENGTH)
			struc_enzymes = "43359156756131E13763334D1C369012032164D4FE4CD61544B6C03F251B6C60A42821D26BA3B0FD6"

// BACK-COMPAT!
//  Initial DNA setup.  I'm kind of wondering why the hell this doesn't just call the above.
//    ready_dna is (hopefully) only used on mob creation, and sets the struc_enzymes_original and SE_original only once - Bone White

/datum/dna/proc/ready_dna(mob/living/carbon/human/character, flatten_SE = 1)
	ResetDNAFrom(character, DNA_UI)
	if(flatten_SE)
		ResetDNA(DNA_SE)
	struc_enzymes_original = struc_enzymes // sets the original struc_enzymes when ready_dna is called
	SE_original = SE.Copy()
	unique_enzymes = md5(character.real_name)
	GLOB.reg_dna[unique_enzymes] = character.real_name

// Hmm, I wonder how to go about this without a huge convention break
/datum/dna/serialize()
	var/data = list()
	data["UE"] = unique_enzymes
	data["SE"] = SE.Copy() // This is probably too lazy for my own good
	data["UI"] = UI.Copy()
	data["species"] = species.type
	// Because old DNA coders were insane or something
	data["blood_type"] = blood_type
	data["real_name"] = real_name
	return data

/datum/dna/deserialize(data)
	unique_enzymes = data["UE"]
	// The de-serializer is unlikely to tamper with the lists
	SE = data["SE"]
	UI = data["UI"]
	UpdateDNA(DNA_ALL)
	var/datum/species/S = data["species"]
	species = new S
	blood_type = data["blood_type"]
	real_name = data["real_name"]

/datum/dna/proc/transfer_identity(mob/living/carbon/human/destination)
	if(!istype(destination))
		return

	// We manually set the species to ensure all proper species change procs are called.
	destination.set_species(species.type, retain_damage = TRUE)
	var/datum/dna/new_dna = Clone()
	new_dna.species = destination.dna.species
	destination.dna = new_dna
	destination.dna.species.handle_dna(destination) // Handle DNA has to be re-called as the DNA was changed.

	destination.UpdateAppearance()
	domutcheck(destination, null, MUTCHK_FORCED)
