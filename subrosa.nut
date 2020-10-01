
IncludeScript("util")

OnPostSpawn <- function()
{
	local ent = null
	while (ent = Entities.FindByName(ent, "briefcase"))
	{
		if (ent.ValidateScriptScope())
		{
			ent.GetScriptScope().InputUse <- function()
			{
				EntFire("briefcase_holder_*", "addoutput", "targetname nobody")
				local name = "briefcase_holder_" + RandomInt(1, 9999)
				activator.__KeyValueFromString("targetname", name)
				EntFireHandle(self, "addoutput", "collisiongroup 2")
				EntFireHandle(self, "setparent", name)
				EntFireHandle(self, "setparentattachment", "grenade0")
			}
		}
	}
}

::FuckModels <- function()
{
	local vm = null
	while (vm = Entities.FindByClassname(vm, "weaponworldmodel"))
	{
		vm.SetModel("models/props_survival/cash/dufflebag.mdl")
	}
}
