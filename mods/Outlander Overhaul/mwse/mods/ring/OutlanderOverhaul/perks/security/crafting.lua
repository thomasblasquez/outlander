-- Load Crafting Framework
local CraftingFramework = include("CraftingFramework")
if not CraftingFramework then return false end

-- Load traps
local deadfallTrap = require("ring.Outlander.securityOverhaul.traps.deadFall")

-- Load tools
local tools = require("ring.Outlander.securityOverhaul.tools")

-- Register Probe as a crafting tool
CraftingFramework.Tool:new{
    id = "probe",
    name = "Probe",
    requirement = function (stack)
        return stack.object.objectType == tes3.objectType.probe
    end
}

-- Build trap recipe list
local recipes = {}
table.insert(recipes, deadfallTrap.recipe)
CraftingFramework.MenuActivator:new{
    id = "OP:ActivateTrapCraftingMenu",
    type = "event",
    name = "Traps",
    recipes = recipes
}

-- Add Bushcraft recipes
-- Chisel menu
local chiselRecipes
for _, recipe in tools.recipes do
    table.insert(chiselRecipes, recipe)
end

event.register("Ashfall:EquipChisel:Registered", function (e)
    e.menuActivator(chiselRecipes)
    return true
end)