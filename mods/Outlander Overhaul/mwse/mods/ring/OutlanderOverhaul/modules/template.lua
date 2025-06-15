--[[
    Ctrl+H: Replace thisskilllc (lowercase skill name)
                    and THISMODULENAME (all caps module name) 
                    and thisskillUc (uppercase skill name)
]]

--#region Common

local common = require("ring.OutlanderOverhaul.common")
if not common then return end
local log = common.log
local i18n = common.i18n

--#endregion

--#region Requirements

local interop = require("ring.OutlanderOverhaul.interop")
local lib = require("ring.lib.main")
local config = require("ring.OutlanderOverhaul.config").modules.alchemy

if (not interop) or (not lib) or (not config) then return false end
if not config.enabled then log:debug("THISMODULENAME: module disabled!") return false end

--#endregion

--#region Variables

    local skill = tes3.getSkill(tes3.skill.thisskilllc)

    local skillName = tes3.findGMST(tes3.gmst.sSkillthisskillUc).value

    local perks = {
        {
            id = "thisskilllcApprentice",
            name = skillName..": "..i18n("apprentice"),
            description = i18n("descriptions.thisskilllc.apprentice"),
            isUnique = true,
            skillReq = { thisskilllc = config.apprenticeRequirement}
        },
        {
            id = "thisskilllcJourneyman",
            name = skillName..": "..i18n("journeyman"),
            description = i18n("descriptions.thisskilllc.journeyman"),
            isUnique = true,
            skillReq = { thisskilllc = config.journeymanRequirement}
        },
        {
            id = "thisskilllcExpert",
            name = skillName..": "..i18n("expert"),
            description = i18n("descriptions.thisskilllc.expert"),
            isUnique = true,
            skillReq = { thisskilllc = config.expertRequirement}
        },
        {
            id = "thisskilllcMaster",
            name = skillName..": "..i18n("master"),
            description = i18n("descriptions.thisskilllc.master"),
            isUnique = true,
            skillReq = { thisskilllc = config.masterRequirement}
        }
    }

--#endregion

--#region Functions

local function refreshCallback() log:trace("THISMODULENAME: refreshCallback()")

end

local function onInitialized() log:trace("THISMODULENAME: onInitialized()")
    interop.newModule({
        skill = skill,
        perks = perks,
        refreshCallback = refreshCallback
    })
end

--#endregion

--#region Events

event.register(tes3.event.initialized, onInitialized)

--#endregion