
local snd = "spatial_test.wav"

//local world = Entities.First()
//world.PrecacheSoundScript(snd)

local players = []
local ent = null
while (ent = Entities.Next(ent))
{
	if (ent.GetClassname() == "player" && ent.GetHealth() > 0)
	{
		ent.StopSound(snd)
		players.push(ent)
	}
}

if (players.len() > 0)
{
	local player = players[RandomInt(0, players.len() - 1)]
	player.PrecacheSoundScript(snd)
	player.EmitSound(snd)
	printl("playing from " + player)
}
