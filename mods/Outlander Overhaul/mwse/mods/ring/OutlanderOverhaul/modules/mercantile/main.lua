local interop = require("ring.Outlander.outlanderPerks.interop")
local config = require("ring.Outlander.outlanderPerks.config").mercantile

if not config.enabled then return end

local function newModules()
    interop.newModule({
        skill = tes3.getSkill(tes3.skill.mercantile),
        perks = {
            {
                    id = "mercantileApprentice",
                    name = "Mercantile: Apprentice",
                    description = "You are now an Apprentice in the art of the deal; Mercantile. You now know the base price and value/weight ratio of all items, and can get better prices with specialized merchants.",
                    isUnique = true,
                    skillReq = { mercantile = config.apprenticeRequirement}
            },
            {
                    id = "mercantileJourneyman",
                    name = "Mercantile: Journeyman",
                    description = "You are now a Journeyman in the art of the deal; Mercantile. You now know the regional prices of all items, allowing you to buy low and sell high.",
                    isUnique = true,
                    skillReq = { mercantile = config.journeymanRequirement}
            },
            {
                    id = "mercantileExpert",
                    name = "Mercantile: Expert",
                    description = "You are now an Expert in the art of the deal; Mercantile. You can now invest in merchants, increasing their available gold and item stock.",
                    isUnique = true,
                    skillReq = { mercantile = config.expertRequirement}
            },
            {
                    id = "mercantileMaster",
                    name = "Mercantile: Master",
                    description = "You are now a Master in the art of the deal; Mercantile. You may now barter with any NPC, and can even buy their equipped weapons or jewelry.",
                    isUnique = true,
                    skillReq = { mercantile = config.masterRequirement}
            }
        },
        refreshCallback = function ()
            
        end
    })
end

event.register(tes3.event.initialized, newModules)