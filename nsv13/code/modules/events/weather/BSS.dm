/datum/round_event_control/portal_storm_brc
	name = "Portal Storm: BRC(VERY DANGEROUS)"
	typepath = /datum/round_event/portal_storm/brc
	weight = -1 //bluespace doesnt randomly rip...
	min_players = 999 //this wont work when nsv 6.0 hits
	earliest_start = 4 HOURS //dubious at best

/datum/round_event/portal_storm/brc
	 boss_types = list(/mob/living/simple_animal/hostile/syndicate/melee/space/stormtrooper = 2) //make one big portal later
	 hostile_types = list(/mob/living/simple_animal/hostile/syndicate/melee/space/stormtrooper = 2,\
						/mob/living/simple_animal/hostile/syndicate/ranged/space = 2) //make portals and mobs

/datum/round_event/portal_storm/brc/announce(fake)
	set waitfor = 0
	sound_to_playing_players('sound/magic/lightning_chargeup.ogg') //replace with Riiiiip
	sleep(80)
	priority_announce("Massive bluespace tear was detected around [station_name()]. Brace for impact!", sound = SSstation.announcer.get_rand_alert_sound()) //Todo, enhance verbage
	sleep(20)
	sound_to_playing_players('sound/magic/lightningbolt.ogg')//hm... perhaps we keep this
