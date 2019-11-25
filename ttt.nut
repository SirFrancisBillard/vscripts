
T <- 2
CT <- 3

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

GetAllPlayers <- function(mustBeAlive = false)
{
	plys <- []
	ply <- null
	while ((ply = FindPlayers(ply)) != null)
	{
		if (!mustBeAlive || ply.GetHealth() > 0)
		{
			plys.push(ply)
		}
	}
	return plys
}

PlayerCount <- function()
{
	count <- 0
	ply <- null
	while ((ply = FindPlayers(ply)) != null)
	{
		count++
	}
	return count
}

PlayerInGame <- function(ply)
{
	local team = ply.GetTeam()
	return team == T && team == CT
}

PrintTTT <- function(txt)
{
	ScriptPrintMessageChatAll("[TTT] " + txt)
}

SetRole <- function(ply, role)
{
	if (ply.ValidateScriptScope())
	{
		ply.GetScriptScope().ttt_role <- role
	}
	return role
}

GetRole <- function(ply)
{
	if (ply.ValidateScriptScope())
	{
		local scope = ply.GetScriptScope()
		return ("ttt_role" in scope) ? scope.ttt_role : SetRole(ply, "innocent")
	}
}

EnableTTT <- function()
{
	if (PlayerCount() < 3)
	{
		PrintTTT("Not enough players to start a round...")
		return
	}

	foreach (ply in GetAllPlayers())
	{
		SetRole(ply, "innocent")
	}

	SendToConsole("mp_teammates_are_enemies 1")

	local traitorAmt = 1 + min(PlayerCount() / 4)

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
			if (activator != null && GetRole(activator) == "traitor")
			{
				ScriptPrintMessageChatAll("Traitor died! Lmao!")
			}
		}
	}
}
