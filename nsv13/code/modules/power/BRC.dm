/* Drive focuses on using the unknown nature of bluespace to provide power for the ship, siphoning from this region in hardly stable ways.*/


//Gas Interactions - Optional
//Rate of damage delt to probe by being missaligned, Fights Probe repair
#define NO_MOD 1
#define LOW_ABERRATIONS 0.5
#define HIGH_ABERRATIONS 2
#define RISKY_ABERRATIONS 4

//Rate of probe repair or damage based on gas; or lack there of. If this fails its a bad day for engineering
#define PROBE_DETRIMENTAL -1
#define PROBE_NEUTRAL 0
#define PROBE_REPAIR 0.25

//How real does bluespace feel? if this fails its a bad day for everyone on the boat
#define PLANE_DETRIMENTAL -1
#define PLANE_NEUTRAL 0
#define PLANE_STABALIZING 0.25

//WE BROKE IT CAP!
#define PLANE_TORN -10

//perhaps one day more probes as an upgrade
#define MAX_PROBES 1

 /////Compressor/////

/obj/machinery/atmospherics/components/unary/brc
	name = "\improper Bluespace Reality Compressor" //Did you really need that spare reality?
	desc = "Why dusk why"
	icon = 'nsv13/icons/obj/custom_crates.dmi'
	icon_state = "large_cargo_crate"
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	light_color = LIGHT_COLOR_BLUEGREEN
	dir = 8
	var/active = FALSE //its a probe, its either in bluespace or not. we can delay deactivation to simulate withdrawing
	var/deactivation_delay = 300 SECONDS //5 Minutes to withdraw the probe
	var/list/gas_records = list() //ohgod...tgui time TODO
	var/list/probes = list() //ordinarily we have one probe.. maybe a future upgrade to add a second probe?
	var/plane_stability = 10000 //How fucked did we make the region of bluespace this drive touches?
	var/max_plane_stability = 10000 //How stable can we make the unstable?
	var/stability_gas_modifier = 1 //How well does the gas modify the region?
	//var/probe_integrity = 100 //The HEALTH of the probe into bluespace, Lose this, lose your drive until a new one can be purchased
	//var/max_probe_integrity = 200 //engineering can reinforce this. How? not sure yet... likely gasses
	var/repair_gas_modifier = 0 //want to fix it? do atmos wrench man.
	var/aberrations = 0 //This directly impacts the plane, like cavitation effects a propeller
	var/obj/item/radio/radio //So we can speak to engineers
	var/radio_key = /obj/item/encryptionkey/headset_eng
	var/engineering_channel = "Engineering"
	var/can_alert = TRUE //can I alert yet?
	var/alert_cooldown = 20 SECONDS //Seems wise, direct rip from SD
	var/last_power_produced = 0 //UI tracking purposes
	var/radiation_modifier = 2 //You are fucking with bluespace it's SPICY
	var/reactor_id = null
	var/installing = FALSE
	var/eject = FALSE //for ejecting the plane probe
	var/eject_timer = 180 SECONDS //Faster than withdrawing.. but not by much. But hey! you do not explode when it was about to break!


////// Compressor Interactions //////

/obj/machinery/atmospherics/components/unary/brc/attackby(obj/item/I, mob/living/carbon/user, params)
	if(istype(I, /obj/item/brc/probe))
		if(installing) //someone already on it?
			to_chat(user, "<span class='notice'> Someone is already working on the probe!</span>")
			return
		if(!active)//how will you deploy a probe when the systems active?
			if(plane_stability <= PLANE_TORN) //Did we fuck it up past the point of recovery?
				to_chat(user, "<span class='danger'> LOCAL BLUESPACE IS BROKEN PAST ALL REASONING, YOU HAVE BIGGER ISSUES!</span>")
				return
			if(probes.len >= MAX_PROBES) //Is there a probe already there even if its broken?
				to_chat(user, "<span class='notice'> You can't seem to find any free probe receptacles.</span>")
				return
			else //yoo theres a opening for a probe, slot it in!
				to_chat(user, "<span class='notice'You begin to slot the probe into the available receptacle.")
				probes += I
				I.forceMove(src)
				update_icon()
				//handle_probe_integrity() //TODO
				return
	if(I.tool_behaviour == TOOL_MULTITOOL)
		if(!multitool_check_buffer(user, I))
			return
		var/obj/item/multitool/M = I
		M.buffer = src
		playsound(src, 'sound/items/flashlight_on.ogg', 100, TRUE)
		to_chat(user, "<span class='notice'>Buffer loaded</span>")

//TODO add repair steps after probe kaboom... also add probe kaboom

	/////PROCESS/////
//nothing here but us chickens. TODO


   /////Procs/////

/obj/machinery/atmospherics/components/unary/brc/proc/send_alert(message="This is a test message.", override=FALSE)
	if(!message)
		return
	if(can_alert || override)
		can_alert = FALSE
		radio.talk_into(src, message, engineering_channel)
		addtimer(VARSET_CALLBACK(src, can_alert, TRUE), alert_cooldown)

/obj/machinery/atmospherics/components/unary/brc/Initialize(mapload)
	.=..()
	radio = new(src)
	radio.keyslot = new radio_key
	radio.listening = 0
	radio.recalculateChannels()
	gas_records["constricted_plasma"] = list()
	gas_records["plasma"] = list()
	gas_records["tritium"] = list()
	gas_records["o2"] = list()
	gas_records["n2"] = list()
	gas_records["co2"] = list()
	gas_records["water_vapour"] = list()
	gas_records["nob"] = list()
	gas_records["n2o"] = list()
	gas_records["no2"] = list()
	gas_records["bz"] = list()
	gas_records["stim"] = list()
	gas_records["pluoxium"] = list()
	gas_records["nucleium"] = list()

 ///// Console stuff /////

/obj/machinery/computer/ship/brc_console
	name = "BRC Probe control console"
	desc = "A cutting edge console that is linked to the Bluespace Reality Compressor for the purposes of controlling the attached probe."
	icon_screen = "reactor_control"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/computer/brc_console
	var/obj/machinery/atmospherics/components/unary/brc/compressor
	var/reactor_id = null //var for mappers to link machine to console

/obj/machinery/computer/ship/brc_console/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		if(!multitool_check_buffer(user, I))
			return
		var/obj/item/multitool/M = I
		compressor = M.buffer
		M.buffer = null
		playsound(src, 'sound/items/flashlight_on.ogg', 100, TRUE)
		to_chat(user, "<span class='notice'>Buffer transfered</span>")
/obj/machinery/computer/ship/brc_console/attack_hand(mob/user)
	if(!compressor)
		playsound(src, 'nsv13/sound/effects/computer/error.ogg')
		to_chat(user, "<span class='warning'>Not presently linked to a compressor</span>")
		return

	ui_interact(user)

/obj/machinery/computer/ship/brc_console/attack_robot(mob/user)
	if(!compressor)
		playsound(src, 'nsv13/sound/effects/computer/error.ogg')
		to_chat(user, "<span class='warning'>Not presently linked to a compressor</span>")
		return

	ui_interact(user)

/obj/machinery/computer/ship/brc_console/attack_ghost(mob/user)
	if(!compressor)
		to_chat(user, "<span class='warning'>Not presently linked to a compressor</span>")
		return

	.=..()
/obj/machinery/computer/ship/brc_console/Initialize(mapload)
	.=..()
	new /obj/item/book/manual/wiki/stormdrive(get_turf(src))
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/ship/brc_console/LateInitialize()
	if(reactor_id) //mapper sets the ID
		for(var/obj/machinery/atmospherics/components/unary/brc/brc in GLOB.machines)
			if(brc.reactor_id == reactor_id)
				compressor = brc
/*
/obj/machinery/computer/ship/brc_console/ui_act(action, params, datum/tgui/ui)
	if(..())
		return
	if(!compressor)
		return
	switch(action)
		if("eject")//YEET IT INTO BLUESPACE BEFORE IT EXPLODES
			//uh....add ejection
		if("align")
			var/align = text2num(params["adjust"]) //Point it at the alignment!
			//add alignment
		if("toggle_active")
			//either insert or retract slowly
		if("toggle_gas")
			//do we want to start eating gas modifications? make this take an age to open or close so engineering cannot game it in a cheesy way
*/
/*/obj/machinery/computer/ship/brc_console/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CompressorConsole")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/computer/ship/brc_console/ui_data(mob/user)
	var/list/data = list()
	//Soon
*/

//TODO TGUI Interactions.... and TGUI

 ///// techweb and board stuff /////
/datum/design/board/brc_console
	name = "Computer Design (Bluespace Reality Compressor Control Console)"
	desc = "Allows for the construction of the console boards used in building a replacement Bluespace reality compressor console."
	id = "brc_c_c"
	build_path = /obj/item/circuitboard/computer/brc_console
	category = list("Computer Boards")
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/obj/item/circuitboard/computer/brc_console
	name = "Bluespace Reality Compressor Console (Computer Board)"
	build_path = /obj/machinery/computer/ship/brc_console
/datum/techweb_node/brc_console
	id = "brc_cc"
	display_name = "Masonic Bluespace Compressor Console"
	description = "Masonic Systems latest itteration of the compressor control console (automated control mode not purchased)."
	prereq_ids = list("adv_engi", "adv_power")
	design_ids = list("brc_c_c") //maybe allow them to build a shitty probe in the future...area
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 3000

 ///// Torn bluespace stuff /////
/datum/weather/torn_bluespace
	name = "torn bluespace" //Spawn unlimited lifetime anomalies that spawn hostile mobs. Make reality bubble. be spooky endtimes
	desc = "Realities are competing in local space... you should evacuate."
	telegraph_duration = 180
	telegraph_message = "<span class='boldwarning'>Space distorts around you, Reality is tearing at the seams.</span>"
	weather_message = "<span class='userdanger'><i>Your skin feels like it's burning and freezing all at once, your grip upon reality weakens!</i></span>"
	weather_overlay = "light_ash" //replace
	weather_overlay = "light_snow" //replace #add bubbles.... somehow
	weather_duration_lower = 1800 //this is round ending lets make it feel round ending
	weather_duration_upper = 7200 //this is round ending lets make it feel round ending
	weather_color = "blue"
	telegraph_sound = null //lets get a ripping sound eventually
	weather_sound = 'nsv13/sound/effects/ship/reactor/falloutwind.ogg' //add boiling sound here
	end_duration = 100
	area_type = /area
	protected_areas = list(/area/maintenance, /area/storage/emergency/starboard, /area/storage/emergency/port, /area/shuttle)
	target_trait = ZTRAIT_STATION
	end_message = "<span class='notice'Reality seems to recover... if only slightly."
	immunity_type = "fire" //might...not...work.. check later

/datum/weather/torn_bluespace/weather_act(mob/living/L)
	L.adjustFireLoss(0.1) //This WILL add up and maybe kill you
	L.adjustOxyLoss(0.1) //enough to make the healthbar wiggle, not enough to kill

/datum/weather/torn_bluespace/telegraph()
	..()
	status_alarm(TRUE)

/datum/weather/torn_bluespace/proc/status_alarm(active)
	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)
	if(!frequency)
		return
	var/datum/signal/signal =new
	if(active)
		signal.data["command"] = "alert"
		signal.data["picture_state"] = "radiation"
	else
		signal.data["command"] = "shuttle"
	var/atom/movable/virtualspeaker/virt = new(null)
	frequency.post_signal(virt, signal)

/datum/weather/torn_bluespace/end()
	if(..())
		return
	status_alarm(FALSE)
 ///// Probe stuff /////


//Probes cannot be built, the must be purchased through cargo... probably via map override
/obj/item/brc
	name = "\improper Bluespace record crasher" //how did you even get this? (it was being made anyway, might as well properly define it)
	desc = "A strange item, You feel you really shouldn't have this... and should likely call the closest bluespace tech!"
	icon = 'nsv13/icons/obj/custom_crates.dmi'
	icon_state = "large_carg_crate"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/brc/probe
	name = "\improper Bluespace Probe"
	desc = "A complex device that is used in conjunction with a bluespace reality compressor."
	icon = 'nsv13/icons/obj/custom_crates.dmi'
	icon_state = "large_cargo_crate"
	w_class = WEIGHT_CLASS_BULKY
	var/probe_integrity = 100
	var/max_probe_integrity = 200

/obj/item/brc/probe/broken
	name = "\improper Broken Bluespace Probe"
	desc = "A once complex device that was used in conjunction with a bluespace reality compressor... This one is broken past repair."
	icon = 'nsv13/icons/obj/custom_crates.dmi'
	icon_state = "large_cargo_crate"
	w_class = WEIGHT_CLASS_BULKY
	probe_integrity = 0
	max_probe_integrity = 0


//TODO Undefines
