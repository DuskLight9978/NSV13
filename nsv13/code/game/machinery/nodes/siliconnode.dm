/obj/machinery/siliconnode
	name = "node"
	desc = "An advanced computer sprawling with wires traveling under the plating."
	density = FALSE
	icon = 'icons/obj/node.dmi'
	icon_state = "base"
	verb_say = "beeps"
	idle_power_usage = 750
	circuit = null
	var/online = TRUE
	var/node_type = NODE_DEFAULT

/obj/machinery/siliconnode/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui) //TODO Investigate AI only clauses for node selection
		ui = new(user, src, "SiliconNode")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/siliconnode/ui_data(mob/user)
	var/list/data = list()
	data["online"] = online ? TRUE : FALSE
	data["canUpgrade"] = node_type > NODE_DEFAULT ? TRUE : FALSE
	return data

/obj/machinery/siliconnode/ui_act(action, params)
	. = ..()
	switch(action)
		if("Toggle power")
			to_chat(usr, "You [online ? "deactivate" : "activate"] \the [src]")
			online = !online
//TODO Make AI only, preferably owner AI

		if("Node selection")
			switch(params)
				if(NODE_CPU)
					name = "\improper CPU node"
					desc = "An advanced computer sprawling with wires traveling under the plating. This one has a <i>CPU</i> in it!"
					icon_state = "base" //TODO CPU Sprite
					node_type = NODE_CPU
				if(NODE_RAM)
					name = "\improper RAM node"
					desc = "An advanced computer sprawling with wires traveling under the plating. This one has <i>extra RAM</i> in it!"
					icon_state = "base" //TODO RAM Sprite
					node_type = NODE_RAM
				if(NODE_FIREWALL)
					name = "firewall node"
					desc = "An advanced computer sprawling with wires traveling under the plating. This one has a <i>lighter</i> in it!"
					icon_state = "base" //TODO FIREWALL Sprite
					node_type = NODE_FIREWALL
				if(NODE_BASTION)
					name = "bastion node"
					desc = "An advanced computer sprawling with wires traveling under the plating. This one has a <i>silicon card</i> saudered in it!"
					icon_state ="base" //TODO BASTION Sprite
					node_type = NODE_BASTION

/obj/machinery/siliconnode/cpunode
	name = "\improper CPU node"
	desc = "An advanced computer sprawling with wires traveling under the plating. This one has a <i>CPU</i> in it!"
	density = FALSE
	icon = 'icons/obj/node.dmi'
	icon_state = "base"
	verb_say = "beeps"
	idle_power_usage = 1000
	circuit = null
	node_type = NODE_CPU

/obj/machinery/siliconnode/ramnode
	name = "\improper RAM node"
	desc = "An advanced computer sprawling with wires traveling under the plating. This one has <i>extra RAM</i> in it!"
	density = FALSE
	icon = 'icons/obj/node.dmi'
	icon_state = "base"
	verb_say = "beeps"
	idle_power_usage = 1000
	circuit = null
	node_type = NODE_RAM

/obj/machinery/siliconnode/firewallnode
	name = "firewall node"
	desc = "An advanced computer sprawling with wires traveling under the plating. This one has a <i>lighter</i> in it!"
	density = FALSE
	icon = 'icons/obj/node.dmi'
	icon_state = "base"
	verb_say = "beeps"
	idle_power_usage = 1250
	circuit = null
	node_type = NODE_FIREWALL

/obj/machinery/siliconnode/bastionnode
	name = "bastion node"
	desc = "An advanced computer sprawling with wires traveling under the plating. This one has a <i>silicon card</i> saudered in it!"
	density = FALSE
	icon = 'icons/obj/node.dmi'
	icon_state = "base"
	verb_say = "beeps"
	idle_power_usage = 1250
	circuit = null
	node_type = NODE_BASTION
