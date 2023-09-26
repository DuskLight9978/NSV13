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
	var/upgraded = FALSE

/obj/machinery/siliconnode/cpunode
	name = "cpu node"
	desc = "An advanced computer sprawling with wires traveling under the plating. This one has a <i>CPU</i> in it!"
	density = FALSE
	icon = 'icons/obj/node.dmi'
	icon_state = "base"
	verb_say = "beeps"
	idle_power_usage = 1000
	circuit = null
	var/scpu = 500

/obj/machinery/siliconnode/ramnode
	name = "ram node"
	desc = "An advanced computer sprawling with wires traveling under the plating. This one has <i>extra RAM</i> in it!"
	density = FALSE
	icon = 'icons/obj/node.dmi'
	icon_state = "base"
	verb_say = "beeps"
	idle_power_usage = 1000
	circuit = null
	var/sram = 500

/obj/machinery/siliconnode/firewallnode
	name = "firewall node"
	desc = "An advanced computer sprawling with wires traveling under the plating. This one has a <i>lighter</i> in it!"
	density = FALSE
	icon = 'icons/obj/node.dmi'
	icon_state = "base"
	verb_say = "beeps"
	idle_power_usage = 1250
	circuit = null
	var/firewall = 100

/obj/machinery/siliconnode/bastionnode
	name = "bastion node"
	desc = "An advanced computer sprawling with wires traveling under the plating. This one has a <i>silicon card</i> saudered in it!"
	density = FALSE
	icon = 'icons/obj/node.dmi'
	icon_state = "base"
	verb_say = "beeps"
	idle_power_usage = 1250
	circuit = null
