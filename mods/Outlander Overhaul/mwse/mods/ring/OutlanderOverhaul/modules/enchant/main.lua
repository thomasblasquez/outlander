--[[
25: Item disenchanting
50: Transfer and combine enchantments
75: When all of your equipped armor and clothing are enchanted, gain spell reflect
100: Summon Trapped creatures. They are re-trapped when killed and hostile to everything, including you.
]]

local perkSystem = require("KBLib.PerkSystem.perkSystem")
local interop = require("ring.Outlander.outlanderPerks.interop")
local config = require("ring.Outlander.outlanderPerks.config").enchant

if not config.enabled then return end

local function addModules()
    interop.newModule({
        skill = tes3.dataHandler.nonDynamicData.skills["enchant"],
        perks = {
            {
                id = "enchantApprentice",
                name = "Enchant: Apprentice",
                description = "You are now an Apprentice in Enchanting. You can now disenchant items to add their spell effects to your spellbook.",
                isUnique = true,
                skillReq = { enchant = 25 }
            },
            {
                id = "enchantJourneyman",
                name = "Enchant: Journeyman",
                description = "You are now a Journeyman in Enchanting. You can now transfer and combine enchantments.",
                isUnique = true,
                skillReq = { enchant = 50 }
            },
            {
                id = "enchantExpert",
                name = "Enchant: Expert",
                description = "You are now an Expert in Enchanting. When all of your equipped armor and clothing are enchanted, gain spell reflect equal to your Enchant skill.",
                isUnique = true,
                skillReq = { enchant = 75 }
            },
            {
                id = "enchantMaster",
                name = "Enchant: Master",
                description = "You are now a Master in Enchant. You can now summon Trapped creatures. They are re-trapped when killed and hostile to everything, including you.",
                isUnique = true,
                skillReq = { enchant = 100 }
            }
        },
        refreshCallback = function ()
            
        end
    })
end

event.register(tes3.event.initialized, addModules)