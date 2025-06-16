local interop = require("ring.Outlander.outlanderPerks.interop")
local config = require("ring.Outlander.outlanderPerks.config").speechcraft

if not config.enabled then return end

local function newModules()
        interop.newModule({
                skill = tes3.getSkill(tes3.skill.speechcraft),
                perks = {
                        {
                                id = "speechcraftApprentice",
                                name = "Speechcraft: Apprentice",
                                description = "You are now an Apprentice in Speechcraft. You can now see a character's Disposition towards you in the dialog menu. You also now have access to the Admire Persuasion option.",
                                isUnique = true,
                                skillReq = { speechcraft = config.apprenticeRequirement}
                        },
                        {
                                id = "speechcraftJourneyman",
                                name = "Speechcraft: Journeyman",
                                description = "You are now a Journeyman in Speechcraft. In addition to Disposition, you can now also see a character's Fight value in the dialog menu. You also now have access to the Intimidate, Taunt, and Admire options under Persuasion.",
                                isUnique = true,
                                skillReq = { speechcraft = config.journeymanRequirement}
                        },
                        {
                                id = "speechcraftExpert",
                                name = "Speechcraft: Expert",
                                description = "You are now an Expert in Speechcraft. You can see Disposition, Fight, and Alarm values in the dialog menu. Successful bribes now decrease a character's Alarm, making it less likely the will report a crime they see you commit.",
                                isUnique = true,
                                skillReq = { speechcraft = config.expertRequirement}
                        },
                        {
                                id = "speechcraftMaster",
                                name = "Speechcraft: Master",
                                description = "You are now a Master in Speechcraft. You can now start conversations with hostile characters.",
                                isUnique = true,
                                skillReq = { speechcraft = config.masterRequirement}
                        }
                },
                refreshCallback = function ()
                        
                end
        })
end

event.register(tes3.event.initialized, newModules)