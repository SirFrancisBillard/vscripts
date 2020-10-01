
SendToConsoleServer("mp_autokick 0")
SendToConsoleServer("mp_solid_teammates 1")
SendToConsoleServer("mp_forcecamera 0")

::T <- 2
::CT <- 3

TeamRestricted <- {
	weapon_sawedoff = 2,
	weapon_rec9 = 2,
	weapon_mac10 = 2,
	weapon_glock = 2,
	weapon_ak47 = 2,
	weapon_m4a1 = 3,
	weapon_m4a1_silencer = 3,
	weapon_hkp2000 = 3,
	weapon_usp_silencer = 3,
	weapon_mag7 = 3,
	weapon_fiveseven = 3,
	weapon_mp9 = 3
}

::GiveWeapon <- function(ply, weapon, ammo = 99999, everybody = false)
{
	/*
	local original_team = false
	if (ply != null && weapon in TeamRestricted && ply.GetTeam() != TeamRestricted[weapon])
	{
		printl("changeing teamnm :)))")
		original_team = ply.GetTeam()
		ply.SetTeam(TeamRestricted[weapon])
	}
	*/
	local equip = Entities.CreateByClassname("game_player_equip")
	equip.__KeyValueFromInt("spawnflags", 5)
	equip.__KeyValueFromInt(weapon, ammo)
	EntFireByHandle(equip, everybody ? "TriggerForAllPlayers" : "Use", "", 0.0, ply, null)
	EntFireByHandle(equip, "kill", "", 0.1, null, null)
	/*
	if (original_team)
	{
		ply.SetTeam(original_team)
	}
	*/
}

// workaround to give skins for non-team weapons
::GiveEverybodyWeapon <- function(weapon, ammo)
{
	ply <- null
	while (ply = Entities.FindByClassname(ply, "*"))
	{
		local cls = ply.GetClassname()
		if (cls == "player" || cls == "bot")
		{
			GiveWeapon(ply, weapon, ammo)
		}
	}
}

::StripWeapons <- function(ply)
{
	local strip = Entities.CreateByClassname("player_weaponstrip")
	EntFireByHandle(strip, "Strip", "", 0.0, ply, null)
	strip.Destroy()
}

::HungerGamesWeps <- [
	"weapon_hegrenade",
	"weapon_flashbang",
	"weapon_ak47",
	"weapon_m4a1",
	"weapon_mac10",
	"weapon_bizon",
	"weapon_nova",
	"weapon_deagle",
	"weapon_p250",
	"weapon_tec9",
	"weapon_glock",
	"weapon_ssg08",
	"weapon_sg556",
	"weapon_famas",
	"weapon_xm1014",
	"weapon_elite",
	"weapon_taser",
	"weapon_scar20",
	"weapon_awp",
]

::CubeLoadouts <- [
	//{weps = [["item_assaultsuit", 1], ["weapon_ak47", 420], ["weapon_hegrenade", 1], ["weapon_knife_m9_bayonet", 1]]},
	{weps = [["weapon_revolver", 420], ["weapon_molotov", 1], ["weapon_fists", 1]]},
	{weps = [["item_assaultsuit", 1], ["weapon_deagle", 420], ["weapon_bumpmine", 420], ["weapon_knife_karambit", 1]]},
	{weps = [["item_assaultsuit", 1], ["weapon_ssg08", 420], ["weapon_knife_butterfly", 1]], start = function() {EntFire("lowgrav", "enable")}},
	{weps = [["item_assaultsuit", 1], ["weapon_p250", 420], ["weapon_shield", 1], ["weapon_knife_tactical", 1]]},
	{weps = [["item_assaultsuit", 1], ["weapon_nova", 420], ["weapon_bayonet", 1]], start = function() {EntFire("amosmoses", "playsound")}},
	//{weps = [["item_assaultsuit", 1], ["weapon_m4a1", 420], ["weapon_flashbang", 2], ["weapon_bayonet", 1]]},
	//{weps = [["item_assaultsuit", 1], ["weapon_mp5sd", 420], ["weapon_smokegrenade", 1], ["weapon_knife_stiletto", 1]]},
	{weps = [["item_heavyassaultsuit", 1], ["weapon_bizon", 420], ["weapon_breachcharge", 69], ["weapon_knife_survival_bowie", 1]]},
	{weps = [["weapon_hegrenade", 1], ["weapon_bayonet", 1]], infinite_ammo = true},
	{weps = [["weapon_cz75a", 420], ["weapon_tagrenade", 1], ["weapon_bayonet", 1]], infinite_ammo = true},
	{weps = [["weapon_elite", 420], ["weapon_knife_flip", 1]]},
	{weps = [["weapon_knife_m9_bayonet", 1]], buy_round = true, start = function() {
		ScriptPrintMessageChatAll("Buy round!")
	}},
	{weps = [["weapon_fists", 1]], start = function() {
		ScriptPrintMessageChatAll("Hunger games!")
		EntFire("hunger_template", "forcespawn")
		/*
		local entmaker = Entities.FindByClassname(null, "player")
		GiveWeapon(entmaker, "weapon_bizon")
		GiveWeapon(entmaker, "weapon_glock")
		for (local i = 0; i < 10 ; i++) {
			for (local j = 0; j < 10 ; j++) {
				if (RandomInt(1, 3) == 1)
				{
					local wep = HungerGamesWeps[RandomInt(0, HungerGamesWeps.len() - 1)]
					GiveWeapon(entmaker, wep)
					local wepent = Entities.FindByClassnameNearest(wep, entmaker.GetOrigin(), 200)
					wepent.SetOrigin(Vector(-1150 + (256 * i), -1150 + (256  * j), 256))
				}
			}
		}
		StripWeapons(entmaker)
		*/
	}},
	{weps = [["weapon_hammer", 1]]},
	{weps = [["item_assaultsuit", 1], ["weapon_awp", 420], ["weapon_knife_karambit", 1]]},
	{weps = [["item_assaultsuit", 1], ["weapon_negev", 420], ["weapon_knife_m9_bayonet", 1]]},
	{weps = [["item_assaultsuit", 1], ["weapon_p90", 420], ["weapon_decoy", 1], ["weapon_knife_gut", 1]]},
	{weps = [["weapon_usp_silencer", 420], ["weapon_fists", 1]], start = function() {
		EntFire("ge64music", "playsound")
		// EntFire("doors", "addoutput", "noise1 doors/doorstop1")
	}},
	{weps = [], team_based = true, start = function() {
		ScriptPrintMessageChatAll("Zombies VS. Humans")
		EntFire("vampintro", "playsound")
		local ply = null
		while (ply = Entities.Next(ply))
		{
			if (ply.GetClassname() == "player" && ply.GetHealth() > 0)
			{
				if (ply.GetTeam() == 2)
				{
					GiveWeapon(ply, "weapon_knife_push", 1)
					ply.SetMaxHealth(900)
					ply.SetHealth(900)
				}
				else if (ply.GetTeam() == 3)
				{
					GiveWeapon(ply, "weapon_awp", 999)
					GiveWeapon(ply, "item_assaultsuit", 1)
					GiveWeapon(ply, "weapon_bayonet", 1)
				}
			}
		}
	}},
	{weps = [], start = function() {
		ScriptPrintMessageChatAll("Murder")
		ScriptPrintMessageChatAll("One gun, one knife!")
		EntFire("thunderintro", "playsound")
		local living_players = []
		local ply = null
		while (ply = Entities.Next(ply))
		{
			if (ply.GetClassname() == "player" && ply.GetHealth() > 0)
			{
				living_players.push(ply)
			}
		}
		if (living_players.len() < 2)
			return
		local murderer = RandomInt(0, living_players.len() - 1)
		local gunner = murderer
		while (gunner == murderer)
			gunner = RandomInt(0, living_players.len() - 1)
		GiveWeapon(living_players[murderer], "weapon_knife_css")
		GiveWeapon(living_players[gunner], "weapon_deagle")
	}},
	{weps = [["item_assaultsuit", 1]], team_based = true, start = function() {
		local ply = null
		while (ply = Entities.Next(ply))
		{
			if (ply.GetClassname() == "player" && ply.GetHealth() > 0)
			{
				if (ply.GetTeam() == 2)
				{
					GiveWeapon(ply, "weapon_knife_css", 1)
					GiveWeapon(ply, "weapon_glock", 999)
					GiveWeapon(ply, "weapon_ak47", 999)
				}
				else if (ply.GetTeam() == 3)
				{
					GiveWeapon(ply, "weapon_knife_css", 1)
					GiveWeapon(ply, "weapon_usp_silencer", 999)
					GiveWeapon(ply, "weapon_m4a1", 999)
				}
			}
		}
	}},
]

::CubeLoadout <- function(round = -1)
{
	ply <- null
	while (ply = Entities.FindByClassname(ply, "*"))
	{
		local cls = ply.GetClassname()
		if (cls == "player" || cls == "bot")
		{
			StripWeapons(ply)
		}
	}
	if (round == -1 || round >= CubeLoadouts.len())
	{
		round = RandomInt(0, CubeLoadouts.len() - 1)
	}
	::CurrentRoundIndex <- round
	::CurrentRound <- CubeLoadouts[round]
	foreach (wep in CurrentRound.weps)
	{
		GiveWeapon(null, wep[0], wep[1], true)
	}
	if ("start" in CurrentRound)
		::CurrentRound.start()
	SendToConsoleServer("mp_teammates_are_enemies " + (("team_based" in CurrentRound) ? "0" : "1"))
	SendToConsoleServer("sv_infinite_ammo " + (("infinite_ammo" in CurrentRound) ? "1" : "0"))
	SendToConsoleServer("mp_buy_anywhere " + (("buy_round" in CurrentRound) ? "1" : "0"))
	EntFire("weapon_knife", "addoutput", "classname weapon_knifegg")
	EntFire("weapon_fists", "addoutput", "classname weapon_knifegg")
	EntFire("weapon_melee", "addoutput", "classname weapon_knifegg")
}

::WantSkip <- {}
::RoundStartTime <- 0

OnPostSpawn <- function()
{
	::WantSkip <- {}
	::RoundStartTime <- Time()
	EntFire("console", "command", "mp_autokick 0")
	EntFire("console", "command", "mp_forcecamera 0")
	EntFire("console", "command", "mp_solid_teammates 1")
	CubeLoadout()
	KillEvent <- Entities.CreateByClassname("trigger_brush")
	KillEvent.__KeyValueFromString("targetname", "game_playerkill")
	if (KillEvent.ValidateScriptScope())
	{
		KillEvent.ConnectOutput("OnUse", "OnKill")
		KillEvent.GetScriptScope().OnKill <- function()
		{
			GiveWeapon(activator, "weapon_healthshot")
			if ("on_kill" in CurrentRound)
				::CurrentRound.on_kill(activator)
		}
		
	}
	DeathEvent <- Entities.CreateByClassname("trigger_brush")
	DeathEvent.__KeyValueFromString("targetname", "game_playerdeath")
	if (DeathEvent.ValidateScriptScope())
	{
		DeathEvent.ConnectOutput("OnUse", "OnDeath")
		DeathEvent.GetScriptScope().OnDeath <- function()
		{
			if ("on_death" in CurrentRound)
				::CurrentRound.on_death(activator)
		}
		
	}
}

::RoundEnded <- function()
{
	if ("end" in CurrentRound)
		::CurrentRound.end()
}

::GiveDeagle <- function(ply)
	GiveWeapon(ply, "weapon_deagle")

::GetPlayerCount <- function()
{
	local count = 0
	local ply = null
	while (ply = Entities.FindByClassname(ply, "*"))
	{
		if (ply.GetClassname() == "player")
			count++
	}
	return count
}

::PlayerChat <- function(data)
{
	if (data.text == "skip")
	{
		if ((Time() - RoundStartTime) > 10)
		{
			ScriptPrintMessageChatAll("It's too late to re-roll this round!")
			return
		}
		local needed = ceil(GetPlayerCount() * 0.5)
		if (data.userid in WantSkip)
		{
			ScriptPrintMessageChatAll("You already voted to skip!")
		}
		else
		{
			::WantSkip[data.userid] <- true
			local cur = WantSkip.len()
			ScriptPrintMessageChatAll("Votes to re-roll this round: (" + cur + "/" + needed + ")")
			if (cur >= needed)
			{
				::WantSkip <- {}
				::RoundStartTime <- Time()
				local round = CurrentRoundIndex
				while (round == CurrentRoundIndex)
					round = RandomInt(0, CubeLoadouts.len() - 1)
				CubeLoadout(round)
				ScriptPrintMessageChatAll("A new loadout has been chosen!")
			}
		}
	}
}
