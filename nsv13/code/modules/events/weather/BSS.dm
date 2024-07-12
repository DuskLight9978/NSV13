/datum/round_event_control/portal_storm_brc
	name = "Portal Storm: BRC(VERY DANGEROUS)"
	typepath = /datum/round_event/portal_storm/brc
	weight = 0
	min_players = 999
	earliest_start = 4 HOURS

/datum/round_event/portal_storm/brc
	 boss_types = list()
	 hostile_types = list(/mob/living/simple_animal/hostile/syndicate/melee/space/stormtrooper = 2,\
						/mob/living/simple_animal/hostile/syndicate/ranged/space = 2)

/datum/round_event/portal_storm/brc/announce(fake)
	set waitfor = 0
	sound_to_playing_players('sound/magic/lightning_chargeup.ogg')
	sleep(80)
	priority_announce("Massive bluespace anomaly detected en route to [station_name()]. Brace for impact.", sound = SSstation.announcer.get_rand_alert_sound())
	sleep(20)
	sound_to_playing_players('sound/magic/lightningbolt.ogg')
