
T <- 2
CT <- 3
VIP_MODEL <- "models/banana_haha.mdl"

FindPlayers <- function(current, team = 0)
{
	ply <- null
	while ((ply = Entities.FindByClassname("*", current)) != null)
	{
		local cls = ply.GetClassname()
		if (cls == "player" || cls == "bot" && (team == 0 || ply.GetTeam() == team))
		{
			break
		}
	}
	return ply
}

EnableVIP <- function(team)
{
	PrecacheModel(VIP_MODEL)
	VIP <- FindPlayers(team)
	VIP.SetModel(VIP_MODEL)
	VIP.__KeyValueFromString("targetname", "vip")

	ent <- null
	while ((ent = Entities.FindByName("game_playerdie", ent)) != null)
	{
		ent.Destroy()
	}

	event <- Entities.CreateByClassname("trigger_brush")
	event.__KeyValueFromString("targetname", "game_playerdie")
	if (event.ValidateScriptScope())
	{
		event.GetScriptScope().OnUse <- function()
		{
			if (activator != null && activator.GetName() == "vip")
			{
				activator.__KeyValueFromString("targetname", "not_vip_LUL")
				ScriptPrintMessageChatAll("VIP died lul")
			}
		}
	}
}
