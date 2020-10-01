::GiveWeapon <- function(ply, weapon, ammo = 0)
{
	local equip = Entities.CreateByClassname("game_player_equip")
	equip.__KeyValueFromInt("spawnflags", 5)
	equip.__KeyValueFromInt(weapon, ammo)
	EntFireByHandle(equip, "Use", "", 0.0, ply, null)
	equip.Destroy()
}

::StripWeapons <- function(ply)
{
	local strip = Entities.CreateByClassname("player_weaponstrip")
	EntFireByHandle(strip, "Strip", "", 0.0, ply, null)
	strip.Destroy()
}

::FUCK <- function()
{
	fuckply <- null
	while ((fuckply = Entities.FindByClassname(fuckply, "player")) != null)
	{
		local cls = fuckply.GetClassname()
		if (cls == "player" || cls == "bot")
		{
			StripWeapons(fuckply)
			GiveWeapon(fuckply, "weapon_hammer")
		}
		EntFire("weapon_melee", "addoutput", "classname weapon_knifegg")
	}
}


printl("fuck")
