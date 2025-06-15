local perkSystem = require("KBLib.PerkSystem.perkSystem")
local config = require("ring.Outlander.outlanderPerks.config").security
local public = {}

---@type CraftingFramework.Recipe.data[]
public.recipes = {
    -- Stone tools (Novice)
    {
        id = "OP_stone_lockpick",
        craftableId = "OP_stone_lockpick",
        description = "A lockpick carved from stone. Not particularly good, but enough for simple locks.",
        materials = {
            {
                material = "stone",
                count = 1
            }
        },
        toolRequirements = {
            {
                tool = "chisel",
                equipped = false,
                conditionPerUse = 1
            }
        },
        category = "Tools",
        soundId = "carve"
    }
}

return public