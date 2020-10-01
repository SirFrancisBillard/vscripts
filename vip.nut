
IncludeScript("util")

::VIP <- null
::VIP_MODEL <- "models/player/custom_player/legacy/tm_phoenix_variantf.mdl"

OnPostSpawn <- function()
{
	local terrorists = []
	local ply = null
	while (ply = Entities.Next(ply))
	{
		if (ply.GetClassname() == "player")
		{
			GiveWeapon(ply, "item_assaultsuit")
			if (ply.GetTeam() == 2)
			{
				terrorists.push(ply)
				GiveWeapons(ply, ["weapon_ak47", "weapon_glock", "weapon_knife_m9_bayonet"])
			}
			else
			{
				GiveWeapons(ply, ["weapon_m4a1", "weapon_p250", "weapon_bayonet"])
			}
		}
	}
	::VIP <- terrorists[RandomInt(0, terrorists.len() - 1)]
	SetModelSafe(VIP, VIP_MODEL)
	StripWeapons(VIP)
	GiveWeapons(VIP, ["item_assaultsuit", "weapon_usp_silencer", "weapon_knife_karambit"])
	MeleeFixup()
	ChatPrintAll(" " + LIME + GetPlayerName(VIP) + WHITE + " is the VIP.")
	HookToPlayerDeath(function(dead) {
		if (dead == VIP)
		{
			ChatPrintAll(" " + DARK_RED + "The VIP has been killed!")
			EntFire("round_end", "EndRound_CounterTerroristsWin", "7")
		}
	})
}
