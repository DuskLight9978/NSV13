/proc/WEAKREF(datum/input)
	if(istype(input) && !QDELETED(input))
		if(istype(input, /datum/weakref))
			return input

		if(!input.weak_reference)
			input.weak_reference = new /datum/weakref(input)
		return input.weak_reference

/datum/proc/create_weakref()		//Forced creation for admin proccalls
	return WEAKREF(src)

/datum/weakref
	var/reference

/datum/weakref/New(datum/thing)
	reference = REF(thing)

/datum/weakref/Destroy(force)
	var/datum/target = resolve()
	qdel(target)
	if(!force)
		return QDEL_HINT_LETMELIVE	//Let BYOND autoGC thiswhen nothing is using it anymore.
	target?.weak_reference = null
	return ..()

/datum/weakref/proc/resolve()
	var/datum/D = locate(reference)
	return (!QDELETED(D) && D.weak_reference == src) ? D : null

/datum/weakref/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_WEAKREF_RESOLVE, "Go to reference")

/datum/weakref/vv_do_topic(list/href_list)
	. = ..()

	if(!.)
		return

	if(href_list[VV_HK_WEAKREF_RESOLVE])
		if(!check_rights(NONE))
			return
		var/datum/R = resolve()
		if(R)
			usr.client.debug_variables(R)
