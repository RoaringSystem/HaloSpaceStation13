var/global/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
// TODO: Update to new antagonist system.
	"traitor" = IS_MODE_COMPILED("traitor"),                // 0
	"mkII spartan" = 1,                                     // 1
	"ODST Trooper" = 1,                                     // 2
	"AI" = 1,                                               // 3
	"malf AI" = IS_MODE_COMPILED("malfunction"),            // 4
	"insurrectionist" = IS_MODE_COMPILED("insurrection"),   // 5
	"ONI operative" = 1                                     // 6
)

/datum/category_item/player_setup_item/antagonism/candidacy
	name = "Candidacy"
	sort_order = 2

/datum/category_item/player_setup_item/antagonism/candidacy/load_character(var/savefile/S)
	S["be_special"]	>> pref.be_special

/datum/category_item/player_setup_item/antagonism/candidacy/save_character(var/savefile/S)
	S["be_special"]	<< pref.be_special

/datum/category_item/player_setup_item/antagonism/candidacy/sanitize_character()
	pref.be_special	= sanitize_integer(pref.be_special, 0, 65535, initial(pref.be_special))

/datum/category_item/player_setup_item/antagonism/candidacy/content(var/mob/user)
	if(jobban_isbanned(user, "Syndicate"))
		. += "<b>You are banned from antagonist roles.</b>"
		pref.be_special = 0
	else
		var/n = 0
		for (var/i in special_roles)
			if(special_roles[i]) //if mode is available on the server
				if(jobban_isbanned(user, i) || (i == "positronic brain" && jobban_isbanned(user, "AI") && jobban_isbanned(user, "Cyborg")) || (i == "pAI candidate" && jobban_isbanned(user, "pAI")))
					. += "<b>Be [i]:</b> <font color=red><b> \[BANNED]</b></font><br>"
				else
					. += "<b>Be [i]:</b> <a href='?src=\ref[src];be_special=[n]'><b>[pref.be_special&(1<<n) ? "Yes" : "No"]</b></a><br>"
			n++

/datum/category_item/player_setup_item/antagonism/candidacy/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["be_special"])
		var/num = text2num(href_list["be_special"])
		pref.be_special ^= (1<<num)
		return TOPIC_REFRESH

	return ..()
