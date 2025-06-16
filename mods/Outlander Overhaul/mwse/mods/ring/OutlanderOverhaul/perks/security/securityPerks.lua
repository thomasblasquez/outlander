local interop = require("ring.Outlander.outlanderPerks.interop")
local config = require("ring.Outlander.outlanderPerks.config").security

if not config.enabled then return end

local function addModules()
    interop.newModule({
        skill = tes3.getSkill(tes3.skill.security),
        perks = {
            {
                id = "securityNovice",
                name = "Security: Novice",
                description = "You are a Novice in Security. You can unlock doors and containers with a Lockpick by equipping it, or disarm trapped ones with a probe. Lockpicks and probes can be bushcrafted, found, or purchased. You can also craft traps by using a probe without targeting a door or container. Security also determines your success when pickpocketing.",
                isUnique = true,
                skillReq = { security = 0 }
            },
            {
                id = "securityApprentice",
                name = "Security: Apprentice",
                description = "You are now an Apprentice in Security. You can now use a lockpick to lock an opened door or container. You also unlock the Tripwire trap and better recipes for crafting lockpicks/probes.",
                isUnique = true,
                skillReq = { security = config.apprenticeRequirement}
            },
            {
                id = "securityJourneyman",
                name = "Security: Journeyman",
                description = "You are now a Journeyman in Security. You can now trap an untrapped door by using a probe on it. You also unlock the Bear trap recipe, as well as even better recipes for crafting lockpicks/probes.",
                isUnique = true,
                skillReq = { security = config.journeymanRequirement }
            },
            {
                id = "securityExpert",
                name = "Security: Expert",
                description = "You are now an Expert in Security. Once per day, you will automatically succeed a failed Pickpocket check. You also unlock the Spikes trap, and even better recipes for crafting lockpicks/probes.",
                isUnique = true,
                skillReq = { security = config.expertRequirement }
            },
            {
                id = "securityMaster",
                name = "Security: Master",
                description = "You are now a Master in Security. You can now lockpick doors in plain view of anyone and never receive a bounty. You also unlock the recipe for landmines, as well as the best recipes for lockpicks/probes.",
                isUnique = true,
                skillReq = { security = config.masterRequirement }
            }
        },
        refreshCallback = function ()
            
        end
    })
end

event.register(tes3.event.initialized, function (e)
    addModules()
end)