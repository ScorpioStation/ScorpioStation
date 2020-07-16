/datum/job/civilian
	title = "Civilian"
	flag = JOB_CIVILIAN
	department_flag = JOBCAT_SUPPORT
	total_positions = -1
	spawn_positions = -1
	supervisors = "the head of personnel"
	department_head = list("Head of Personnel")
	selection_color = "#dddddd"
	department_access = list() // see /datum/job/assistant/get_access()
	access = list()            // see /datum/job/assistant/get_access()
	minimal_access = list()    // see /datum/job/assistant/get_access()
	alt_titles = list("Assistant", "Businessman", "Tourist", "Trader")
	outfit = /datum/outfit/job/assistant

/datum/job/civilian/get_access()
	if(config.assistant_maint)
		return list(ACCESS_MAINT_TUNNELS)
	else
		return list()

/datum/outfit/job/assistant
	name = "Civilian"
	jobtype = /datum/job/civilian

	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/black

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(config.grey_assistants)
		uniform = /obj/item/clothing/under/color/grey
