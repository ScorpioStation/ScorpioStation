/obj/machinery/computer/fusion
	icon_keyboard = "power_key"
	icon_screen = "rust_screen"
	light_color = COLOR_ORANGE
	idle_power_usage = 250
	active_power_usage = 500
	var/ui_template
	var/initial_id_tag

/obj/machinery/computer/fusion/Initialize()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.set_tag(null, initial_id_tag)
	. = ..()

/obj/machinery/computer/fusion/proc/get_local_network()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	return fusion.get_local_network()

/obj/machinery/computer/fusion/attackby(var/obj/item/thing, var/mob/user)
	if(isMultitool(thing))
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.get_new_tag(user)
		return
	else
		return ..()

/obj/machinery/computer/fusion/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/fusion/proc/build_ui_data()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/data = list()
	data["id"] = lan ? lan.id_tag : "unset"
	data["name"] = name
	. = data

/obj/machinery/computer/fusion/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(ui_template)
		var/list/data = build_ui_data()
		ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, ui_template, name, 400, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)
/*
 * Core Control Console
 */

/obj/machinery/computer/fusion/core_control
	name = "\improper R-UST Mk. 8 core control"
	ui_template = "fusion_core_control.tmpl"

/obj/machinery/computer/fusion/core_control/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	if(href_list["toggle_active"] || href_list["str"])
		var/obj/machinery/power_machine/fusion_core/C = locate(href_list["machine"])
		if(!istype(C))
			return TOPIC_NOACTION

		var/datum/local_network/lan = get_local_network()
		if(!lan || !lan.is_connected(C))
			return TOPIC_NOACTION

		if(!C.check_core_status())
			return TOPIC_NOACTION

		if(href_list["toggle_active"])
			if(!C.Startup()) //Startup() whilst the device is active will return null.
				if(!C.owned_field.is_shutdown_safe())
					if(alert(user, "Shutting down this fusion core without proper safety procedures will cause serious damage, do you wish to continue?", "Shut Down?", "Yes", "No") == "No")
						return TOPIC_NOACTION
				C.Shutdown()
			return TOPIC_REFRESH

		if(href_list["str"] && C)
			var/val = text2num(href_list["str"])
			if(!val) //Value is 0, which is manual entering.
				C.set_strength(input("Enter the new field power density (W.m^-3)", "Fusion Control", C.field_strength) as num)
			else
				C.set_strength(C.field_strength + val)
			return TOPIC_REFRESH

/obj/machinery/computer/fusion/core_control/build_ui_data()
	. = ..()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/cores = list()
	if(lan)
		var/list/fusion_cores = lan.get_devices(/obj/machinery/power_machine/fusion_core)
		for(var/i in 1 to LAZYLEN(fusion_cores))
			var/list/core = list()
			var/obj/machinery/power_machine/fusion_core/C = fusion_cores[i]
			core["id"] =          "#[i]"
			core["ref"] =         "\ref[C]"
			core["field"] =       !isnull(C.owned_field)
			core["power"] =       "[C.field_strength/10.0] tesla"
			core["size"] =        C.owned_field ? "[C.owned_field.size] meter\s" : "Field offline."
			core["instability"] = C.owned_field ? "[C.owned_field.percent_unstable * 100]%" : "Field offline."
			core["temperature"] = C.owned_field ? "[C.owned_field.plasma_temperature + 295]K" : "Field offline."
			core["powerstatus"] = "[C.avail()]/[C.active_power_usage] W"
			var/fuel_string = "<table width = '100%'>"
			if(C.owned_field && LAZYLEN(C.owned_field.reactants))
				for(var/reactant in C.owned_field.reactants)
					fuel_string += "<tr><td>[reactant]</td><td>[C.owned_field.reactants[reactant]]</td></tr>"
			else
				fuel_string += "<tr><td colspan = 2>Nothing.</td></tr>"
			fuel_string += "</table>"
			core["fuel"] = fuel_string

			cores += list(core)
	.["cores"] = cores

/*
 * Gyrotron Control Console
 */
/obj/machinery/computer/fusion/gyrotron
	name = "gyrotron control console"
	icon_keyboard = "med_key"
	icon_screen = "gyrotron_screen"
	light_color = COLOR_BLUE
	ui_template = "fusion_gyrotron_control.tmpl"

/obj/machinery/computer/fusion/gyrotron/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)

	if(href_list["modifypower"] || href_list["modifyrate"] || href_list["toggle"])

		var/obj/machinery/power_machine/emitter/gyrotron/G = locate(href_list["machine"])
		if(!istype(G))
			return TOPIC_NOACTION

		var/datum/local_network/lan = get_local_network()
		var/list/gyrotrons = lan.get_devices(/obj/machinery/power_machine/emitter/gyrotron)
		if(!lan || !gyrotrons || !gyrotrons[G])
			return TOPIC_NOACTION

		if(href_list["modifypower"])
			var/new_val = input("Enter new emission power level (1 - 50)", "Modifying power level", G.mega_energy) as num
			if(!istype(G))
				return TOPIC_NOACTION
			if(!new_val)
				to_chat(user, SPAN_WARNING("That's not a valid number."))
				return TOPIC_NOACTION
			G.mega_energy = Clamp(new_val, 1, 50)
			G.change_power_consumption(G.mega_energy * 1500, POWER_USE_ACTIVE)
			return TOPIC_REFRESH

		if(href_list["modifyrate"])
			var/new_val = input("Enter new emission delay between 2 and 10 seconds.", "Modifying emission rate", G.rate) as num
			if(!istype(G))
				return TOPIC_NOACTION
			if(!new_val)
				to_chat(user, SPAN_WARNING("That's not a valid number."))
				return TOPIC_NOACTION
			G.rate = Clamp(new_val, 2, 10)
			return TOPIC_REFRESH

		if(href_list["toggle"])
			G.activate(user)
			return TOPIC_REFRESH

/obj/machinery/computer/fusion/gyrotron/build_ui_data()
	. = ..()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/gyrotrons = list()
	if(lan && gyrotrons)
		var/list/lan_gyrotrons = lan.get_devices(/obj/machinery/power_machine/emitter/gyrotron)
		for(var/i in 1 to LAZYLEN(lan_gyrotrons))
			var/list/gyrotron = list()
			var/obj/machinery/power_machine/emitter/gyrotron/G = lan_gyrotrons[i]
			gyrotron["id"] =        "#[i]"
			gyrotron["ref"] =       "\ref[G]"
			gyrotron["active"] =    G.active
			gyrotron["firedelay"] = G.rate
			gyrotron["energy"] = G.mega_energy
			gyrotrons += list(gyrotron)
	.["gyrotrons"] = gyrotrons

/*
 * Fuel Injector Control Console
 */
/obj/machinery/computer/fusion/fuel_control
	name = "fuel injection control computer"
	icon_keyboard = "rd_key"
	icon_screen = "fuel_screen"
	ui_template = "fusion_injector_control.tmpl"

/obj/machinery/computer/fusion/fuel_control/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	var/datum/local_network/lan = get_local_network()
	var/list/fuel_injectors = lan.get_devices(/obj/machinery/fusion_fuel_injector)

	if(href_list["global_toggle"])
		if(!lan || !fuel_injectors)
			return TOPIC_NOACTION
		for(var/thing in fuel_injectors)	//Paracode uses typeless loops
			var/obj/machinery/fusion_fuel_injector/F = thing
			if(F.injecting)
				F.StopInjecting()
			else
				F.BeginInjecting()
		return TOPIC_REFRESH

	if(href_list["toggle_injecting"] || href_list["injection_rate"])
		var/obj/machinery/fusion_fuel_injector/I = locate((href_list["toggle_injecting"] || href_list["machine"]))
		if(!istype(I) || !lan || !fuel_injectors || !fuel_injectors[I])
			return TOPIC_NOACTION

		if(href_list["toggle_injecting"])
			if(I.injecting)
				I.StopInjecting()
			else
				I.BeginInjecting()

		else if(href_list["injection_rate"])
			var/new_injection_rate = input("Enter a new injection rate between 0 and 100", "Modifying injection rate", I.injection_rate) as num
			if(!istype(I))
				return TOPIC_NOACTION
			if(!new_injection_rate)
				to_chat(user, SPAN_WARNING("That's not a valid injection rate."))
				return TOPIC_NOACTION
			I.injection_rate = Clamp(new_injection_rate, 0, 100) / 100
		return TOPIC_REFRESH

/obj/machinery/computer/fusion/fuel_control/build_ui_data()
	. = ..()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/injectors = list()
	if(lan)
		var/list/fuel_injectors = lan.get_devices(/obj/machinery/fusion_fuel_injector)
		for(var/i in 1 to LAZYLEN(fuel_injectors))
			var/list/injector = list()
			var/obj/machinery/fusion_fuel_injector/I = fuel_injectors[i]
			injector["id"] =       "#[i]"
			injector["ref"] =       "\ref[I]"
			injector["injecting"] =  I.injecting
			injector["fueltype"] =  "[I.cur_assembly ? I.cur_assembly.fuel_type : "No Fuel Inserted"]"
			injector["depletion"] = "[I.cur_assembly ? (I.cur_assembly.percent_depleted * 100) : 100]%"
			injector["injection_rate"] = "[I.injection_rate * 100]%"
			injectors += list(injector)
	.["injectors"] = injectors
