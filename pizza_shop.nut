
SendToConsole("mp_autokick 0")
SendToConsole("mp_respawn_on_death_t 1")
SendToConsole("mp_respawn_on_death_ct 1")
SendToConsole("mp_solid_teammates 0")
SendToConsole("mp_roundtime 12")
SendToConsole("mp_default_team_winner_no_objective 3")

::T <- 2
::CT <- 3

::MessageT <- function(txt)
{
	ScriptPrintMessageChatTeam(T, txt)
}

::MessageCT <- function(txt)
{
	ScriptPrintMessageChatTeam(CT, txt)
}

::MessageAll <- function(txt)
{
	ScriptPrintMessageChatAll(txt)
}

::GiveWeapon <- function(ply, weapon, ammo = 99999, everybody = false)
{
	local equip = Entities.CreateByClassname("game_player_equip")
	equip.__KeyValueFromInt("spawnflags", 5)
	equip.__KeyValueFromInt(weapon, ammo)
	EntFireByHandle(equip, everybody ? "TriggerForAllPlayers" : "Use", "", 0.0, ply, null)
	equip.Destroy()
}

::GiveKnife <- function(ply, knife)
{
	GiveWeapon(ply, knife)
	EntFire("weapon_knife", "addoutput", "classname weapon_knifegg")
	local ent = null
	while (ent = Entities.FindByClassname(null, "weapon_knife"))
	{
		if (ent.GetOwner() == null)
		{
			ent.Destroy()
		}
	}
}

::GiveBayonet <- function(ply) {GiveKnife(ply, "weapon_bayonet")}
::GiveM9 <- function(ply) {GiveKnife(ply, "weapon_knife_m9_bayonet")}
::GiveGrenade <- function(ply) {GiveWeapon(ply, "weapon_hegrenade")}
::GiveFlashbang <- function(ply) {GiveWeapon(ply, "weapon_flashbang")}
::GiveAK <- function(ply) {GiveWeapon(ply, "weapon_ak47")}
::GiveMP9 <- function(ply) {GiveWeapon(ply, "weapon_mp9")}
::GiveDualies <- function(ply) {GiveWeapon(ply, "weapon_elite")}
::GiveP250 <- function(ply) {GiveWeapon(ply, "weapon_p250")}
::GiveNegev <- function(ply) {GiveWeapon(ply, "weapon_negev")}
::GiveP90 <- function(ply) {GiveWeapon(ply, "weapon_p90")}
::GiveDeagle <- function(ply) {GiveWeapon(ply, "weapon_deagle")}
::GiveNova <- function(ply) {GiveWeapon(ply, "weapon_nova")}
::GiveSmoke <- function(ply) {GiveWeapon(ply, "weapon_smokegrenade")}

::FireCannon <- function()
{
	local pick = RandomInt(1, 6)
	EntFire("mortar_sound" + pick, "playsound")
	EntFire("mortar_explode" + pick, "explode", "", 1.85)
}

::SuperCannon <- function()
{
	EntFire("cannon_button", "addoutput", "speed 999")
	EntFire("cannon_button", "addoutput", "wait 0")
}

::ResetGlobalVars <- function()
{
	::RUBBISH_COLLECTED <- 0
	::WHEAT_COLLECTED <- 0
	::DOUGH_TIER <- -1
	::NEEDED_SAUCE <- -1
	::CHEESE_PROGRESS <- 0
}
ResetGlobalVars()

::PhoneRing <- function()
{
	EntFire("phone_ring", "playsound")
	EntFire("phone_button", "unlock")
}

::BeginRubbish <- function()
{
	MessageT("Alright folks, let's get to work.")
	MessageT("This joint is filthy, clean up all this rubbish.")
	MessageCT("Those low-lifes are trying to make a pizza.")
	MessageCT("We need to stop them by any means necessary.")
}

::CollectRubbish <- function()
{
	::RUBBISH_COLLECTED++
	MessageT("Rubbish collected: " + RUBBISH_COLLECTED + "/20")
	if (RUBBISH_COLLECTED > 19)
	{
		MessageT("Looks great! Now we need to start that pizza.")
		MessageT("Go harvest some wheat for the dough!")
		MessageCT("Stop them from harvesting the wheat!")
		EntFire("wheat_template", "forcespawn")
	}
}

::StripWeapons <- function(ply)
{
	local strip = Entities.CreateByClassname("player_weaponstrip")
	EntFireByHandle(strip, "Strip", "", 0.0, ply, null)
	strip.Destroy()
}

::WheatHit <- function(plant)
{
	EntFireByHandle(plant, "Break", "", 0.0, null, null)
	::WHEAT_COLLECTED++
	if (WHEAT_COLLECTED > 29)
	{
		MessageT("Wheat harvested! :]")
		MessageT("Now knead that dough!")
		MessageT("WEAPON UNLOCK: Dual Elites")
		MessageCT("They got the wheat...")
		MessageCT("Don't let them knead the dough!")
		MessageCT("WEAPON UNLOCK: P250")
		MessageAll("GUN STORE UNLOCKS: DEAGLE + NOVA")
		EntFire("equip_template1", "forcespawn")
		EntFire("equip_model1", "addoutput", "renderamt 255")
		::DOUGH_TIER <- 0
		ShowDoughMound()
	}
}

::AnnounceSauce_Workaround <- function()
{
	::NEEDED_SAUCE <- RandomInt(7, 11)
	MessageT("The dough is ready for sauce, hop in that grinder!")
	MessageCT("They're making sauce, don't let them grind it!")
}

::RollPin <- function()
{
	if (DOUGH_TIER < 0)
	{
		return
	}
	if (RandomInt(1, 4) == 1)
	{
		::DOUGH_TIER++
		ShowDoughMound(DOUGH_TIER)
		if (DOUGH_TIER > 2)
		{
			::DOUGH_TIER <- -1
			EntFire("dough_mound*", "disable", "", 2)
			EntFire("script", "RunScriptCode", "AnnounceSauce_Workaround()", 2)
			EntFire("prep_stage*", "disable", "", 2)
			EntFire("prep_stage0", "enable", "", 2)
		}
	}
}

::GrindSauce <- function()
{
	if (NEEDED_SAUCE == -1)
	{
		return
	}
	::NEEDED_SAUCE--
	if (NEEDED_SAUCE < 1)
	{
		::NEEDED_SAUCE <- -1
		ShowPrepStage(1)
		MessageT("Y'all got the sauce, we need some cheese!")
		MessageCT("They ground the sauce, protect the cheese!")
		EntFire("cheese_gate", "kill")
		EntFire("cheese_timer", "enable")
		MessageT("WEAPON UNLOCK: AK-47")
		MessageCT("WEAPON UNLOCK: MP9")
		MessageAll("GUN STORE UNLOCKS: NEGEV + P90")
		EntFire("equip_template2", "forcespawn")
		EntFire("equip_model2", "addoutput", "renderamt 255")
	}
}

::CheeseThink <- function()
{
	local cheese_pos = Entities.FindByName(null, "cheese").GetOrigin()
	local cappers = 0
	local ply = null
	while (ply = Entities.FindByClassnameWithin(ply, "player", cheese_pos, 80))
	{
		if (ply.GetTeam() == T)
		{
			EntFire("cheese_hint", "showmessage", "", 0.0, ply)
			cappers++
		}
	}
	if (cappers == 0)
	{
		cappers = -1
	}
	::CHEESE_PROGRESS += cappers
	if (CHEESE_PROGRESS > 30)
	{
		EntFire("cheese_timer", "disable")
		MessageT("Good job getting that cheese, now cook that sucker!")
		MessageCT("They got the cheese, stop them from cooking!")
		EntFire("cheese", "kill")
		ShowPrepStage(2)
		EntFire("prep_stage*", "disable", "", 2)
		EntFire("oven_breakable_template", "forcespawn", "", 2)
		EntFire("oven_pizza_raw", "enable", "", 2)
	}
}

::CollectCheese <- function()
{
	MessageT("Good job getting that cheese, now cook that sucker!")
	MessageCT("They got the cheese, stop them from cooking!")
	EntFire("cheese", "kill")
	ShowPrepStage(2)
	EntFire("prep_stage*", "disable", "", 2)
	EntFire("oven_breakable_template", "forcespawn", "", 2)
	EntFire("oven_pizza_raw", "enable", "", 2)
}

OvenProgressT <- [
	"The pizza is cooking! :>",
	"It's almost done, keep going! :3",
	"Pizza's done! UwU"
]

OvenProgressCT <- [
	"They turned on the oven!",
	"Dammit, the pizza's cooking!",
	"They cooked the pizza!"
]

::OvenProgress <- function(lvl)
{
	MessageT(OvenProgressT[lvl])
	MessageCT(OvenProgressCT[lvl])
	switch (lvl)
	{
		case 0:
			EntFire("oven_smallfire", "StartFire", "0")
			EntFire("oven_sound", "PlaySound")
			break;

		case 1:
			EntFire("oven_smallfire", "Extinguish", "0")
			EntFire("oven_bigfire", "StartFire", "0")
			EntFire("oven_sound", "PlaySound")
			break;

		case 2:
			EntFire("oven_bigfire", "Extinguish", "0")
			EntFire("oven_extinguishsound", "PlaySound")
			EntFire("oven_pizza_raw", "disable")
			EntFire("oven_pizza_ready", "enable")
			EntFire("oven_pizza_ready", "disable", "", 2)
			EntFire("pizza_deliver_trigger", "enable", "", 2)
			MessageT("Now all we have to do is deliver it.")
			MessageT("Don't let up now, we're so close!")
			MessageCT("Stop them from delivering it!")
			MessageCT("This is our last chance, give 'em all you got!")
			break;
	}
}

::ShowDoughMound <- function(tier = 0)
{
	EntFire("dough_mound*", "disable")
	EntFire("dough_mound" + tier, "enable")
}

::ShowPrepStage <- function(tier = 0)
{
	EntFire("prep_stage*", "disable")
	EntFire("prep_stage" + tier, "enable")
}

OnPostSpawn <- function()
{
	EntFire("func_brush", "disable")
	ScriptPrintMessageChatAll("Welcome to the Pizza Shop!")
	ResetGlobalVars()
}
