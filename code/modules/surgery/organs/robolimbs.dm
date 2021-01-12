GLOBAL_LIST_EMPTY(all_robolimbs)
GLOBAL_LIST_EMPTY(chargen_robolimbs)
GLOBAL_LIST_EMPTY(selectable_robolimbs)
GLOBAL_DATUM(basic_robolimb, /datum/robolimb)


#define model        0
#define brand        1
#define childless    2
/datum/robolimb
	var/company = "Unbranded"                            // Shown when selecting the limb.
	var/desc = "A generic unbranded robotic prosthesis." // Seen when examining a limb.
	var/icon = 'icons/mob/human_races/robotic.dmi'       // Icon base to draw from.
	var/model_name = ""					// Name of the model
	var/unavailable_at_chargen = FALSE	// If TRUE, not available at chargen.
	var/selectable = TRUE				// If set, is it available for selection on attack_self with a robo limb?
	var/is_monitor						// If set, limb is a monitor and should be getting monitor styles.
	var/has_subtypes = childless		// If null, object is a model. If 1, object is a brand (that serves as the default model) with child models. If 2, object is a brand that has no child models and thus also serves as the model..
	var/parts = list("chest", "groin", "head", "r_arm", "r_hand", "r_leg", "r_foot", "l_leg", "l_foot", "l_arm", "l_hand")	// Defines what parts said brand can replace on a body.

/* Bishop */
//Main
/datum/robolimb/bishop
	company = "Bishop Cybernetics"
	model_name = "The Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_main.dmi'
	has_subtypes = brand

/datum/robolimb/bishop/monitor
	model_name = "The Bishop Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_alt1.dmi'
	parts = list("head")
	is_monitor = TRUE
	has_subtypes = model


//Rook
/datum/robolimb/rook
	company = "Bishop Cybernetics"
	model_name = "The Rook"
	desc = "This limb has a polished metallic casing and a holographic face emitter."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_rook.dmi'
	has_subtypes = brand

/datum/robolimb/rook/monitor
	model_name = "The Rook Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_monitor.dmi'
	parts = list("head")
	is_monitor = TRUE
	selectable = FALSE
	has_subtypes = model

/* Hesphiastos */
//Main
/datum/robolimb/hesphiastos
	company = "Hesphiastos Industries"
	model_name = "Hesphiastos Industries"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_main.dmi'
	has_subtypes = brand

/datum/robolimb/hesphiastos/monitor
	model_name = "Hesphiastos Industries Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_monitor.dmi'
	parts = list("head")
	is_monitor = TRUE
	has_subtypes = model

//Titan
/datum/robolimb/titan
	company = "Hesphiastos Industries"
	model_name = "Hesphiastos Titan"
	desc = "This limb has a casing of an olive drab finish, providing a reinforced housing look."
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_titan.dmi'
	has_subtypes = brand

/datum/robolimb/titan/monitor
	model_name = "Hesphiastos Titan Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_alt1.dmi'
	parts = list("head")
	is_monitor = TRUE
	selectable = FALSE
	has_subtypes = model

/* Morpheus */
//Main
/datum/robolimb/morpheus
	company = "Morpheus Cyberkinetics"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_main.dmi'
	has_subtypes = brand

/datum/robolimb/morpheus/monitor
	model_name = "Morpheus Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_alt1.dmi'
	parts = list("head")
	is_monitor = TRUE
	unavailable_at_chargen = null
	has_subtypes = childless //Edge case. We want to be able to pick this one, and if we had it left as null for has_subtypes we'd be assuming it'll be chosen as a child model, and since the parent is unavailable at chargen, we wouldn't be able to see it in the list anyway. Now, we'll be able to select the Morpheus Ckt. Alt. head as a solo-model.

//Mantis
/datum/robolimb/mantis
	company = "Morpheus Cyberkinetics"
	model_name = "Morpheus Mantis"
	desc = "This limb has a casing of sleek black metal and innovative insectile design."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_mantis.dmi'
	has_subtypes = brand

/datum/robolimb/mantis/monitor
	model_name = "Morpheus Mantis Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_blitz.dmi'
	parts = list("head")
	is_monitor = TRUE
	selectable = FALSE
	has_subtypes = model

/* Ward Takahashi */
//Main
/datum/robolimb/wardtakahashi
	company = "Ward-Takahashi"
	desc = "This limb features sleek black and white polymers."
	model_name = "Ward-Takahashi"
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	has_subtypes = brand

/datum/robolimb/wardtakahashi/monitor
	model_name = "Ward-Takahashi Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_monitor.dmi'
	parts = list("head")
	is_monitor = TRUE
	has_subtypes = model

//Economy
/datum/robolimb/wardeconomy
	company = "Ward-Takahashi"
	model_name = "Ward-Takahashi Efficiency"
	desc = "A simple robotic limb with retro design. Seems rather stiff."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	has_subtypes = brand

/datum/robolimb/wardeconomy/monitor
	model_name = "Ward-Takahashi Efficiency Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_alt1.dmi'
	parts = list("head")
	is_monitor = TRUE
	selectable = FALSE
	has_subtypes = model

/* Xion */
//Main
/datum/robolimb/xion
	company = "Xion Manufacturing Group"
	desc = "This limb has a minimalist black and red casing."
	model_name = "Xion Manufacturing Group"
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_main.dmi'
	has_subtypes = brand

/datum/robolimb/xion/monitor
	model_name = "Xion Manufacturing Group Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_monitor.dmi'
	parts = list("head")
	is_monitor = TRUE
	has_subtypes = model

//Economy
/datum/robolimb/xioneconomy
	company = "Xion Manufacturing Group"
	desc = "This skeletal mechanical limb has a minimalist black and red casing."
	model_name = "Xion Economy"
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_econo.dmi'
	has_subtypes = brand

/datum/robolimb/xioneconomy/monitor
	model_name = "Xion Economy Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_alt1.dmi'
	parts = list("head")
	is_monitor = TRUE
	selectable = FALSE
	has_subtypes = model

/* Shellguard */
//Main
/datum/robolimb/shellguard
	company = "Shellguard Munitions"
	desc = "This limb features exposed robust steel and paint to match Shellguards motifs"
	model_name = "Shellguard Munitions Standard Series"
	icon = 'icons/mob/human_races/cyberlimbs/shellguard/shellguard_main.dmi'
	has_subtypes = brand

/datum/robolimb/shellguard/monitor
	model_name = "Shellguard Munitions Standard Series Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/shellguard/shellguard_monitor.dmi'
	parts = list("head")
	is_monitor = TRUE
	has_subtypes = model

//Elite
/datum/robolimb/shellguard/alt1
	company = "Shellguard Munitions"
	model_name= "Shellguard Munitions Elite Series Monitor"
	icon = 'icons/mob/human_races/cyberlimbs/shellguard/shellguard_alt1.dmi'
	parts = list("head")
	is_monitor = TRUE
	has_subtypes = model

/* Zenghu */
//Zenghu - Main
/datum/robolimb/zenghu
	company = "Zeng-Hu Pharmaceuticals"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	model_name = "Zeng-Hu Pharmaceuticals"
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_main.dmi'
	has_subtypes = childless

//Zenghu - Spirit
/datum/robolimb/spirit
	company = "Zeng-Hu Pharmaceuticals"
	desc = "This limb has a sleek black and white polymer finish."
	model_name = "Zeng-Hu Spirit"
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_spirit.dmi'
	has_subtypes = childless
