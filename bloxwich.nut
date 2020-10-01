
yes <- false

OnPostSpawn <- function()
{
	yes <- false
}

OnPlayerChat <- function(data)
{
	if (!yes && data.text == "bloxwich")
	{
		yes <- true
		ScriptPrintMessageChatAll("ding!")
		EntFire("secret_xxx_gay_furry_club", "unlock")
	}
}
