/proc/meta_gas_list()
	. = subtypesof(/datum/gas)
	for(var/gas_path in .)
		var/list/gas_info = new(7)
		var/datum/gas/gas = gas_path

		gas_info[META_GAS_SPECIFIC_HEAT] = initial(gas.specific_heat)
		gas_info[META_GAS_NAME] = initial(gas.name)
		gas_info[META_GAS_OVERLAY] = initial(gas.gas_overlay)
		gas_info[META_GAS_ID] = initial(gas.gas_id)
		.[gas_path] = gas_info

/proc/gas_id2path(gas_id)
	var/list/meta_gas = GLOB.meta_gas_info
	if(gas_id in meta_gas)
		return gas_id
	for(var/path in meta_gas)
		if(meta_gas[path][META_GAS_ID] == gas_id)
			return path
	return ""

/*||||||||||||||/----------\||||||||||||||*\
||||||||||||||||[GAS DATUMS]||||||||||||||||
||||||||||||||||\__________/||||||||||||||||
||||These should never be instantiated. ||||
||||They exist only to make it easier   ||||
||||to add a new gas. They are accessed ||||
||||only by meta_gas_list().            ||||
\*||||||||||||||||||||||||||||||||||||||||*/

/datum/gas
	var/gas_id = ""
	var/specific_heat = 0
	var/name = ""
	var/gas_overlay = ""	//icon_state in icons/effects/atmospherics.dmi
	var/moles_visible = null

/datum/gas/oxygen
	gas_id = "air"
	specific_heat = SPECIFIC_HEAT_AIR
	name = "Oxygen"

/datum/gas/sleeping_agent
	gas_id = "sleeping_agent"
	specific_heat = SPECIFIC_HEAT_N2O
	name = "Sleeping Agent"

/datum/gas/carbon_dioxide
	gas_id = "cdo"
	specific_heat = SPECIFIC_HEAT_CDO
	name = "Carbon Dioxide"

/datum/gas/toxin
	gas_id = "plasma"
	specific_heat = SPECIFIC_HEAT_TOXIN
	name = "Plasma"
	gas_overlay = "plasma"

/datum/gas/agent_b
	gas_id = "agent_b"
	specific_heat = SPECIFIC_HEAT_AGENT_B
	name = "Unidentified Gas"
	gas_overlay = "agent_b"

/datum/gas/sleeping_agent
	gas_id = "n2o"
	specific_heat = SPECIFIC_HEAT_N2O
	name = "Nitrous Oxide"
	gas_overlay = "nitrous_oxide"
