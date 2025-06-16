--[[
"Throw stone" button for distractions
First attack from stealth is a guaranteed hit
Stealthing while out of sight of all combatants for 3 seconds ends combat
Bullet-time on a cooldown
]]
local perkSystem = require("KBLib.PerkSystem.perkSystem")
local interop = require("ring.Outlander.outlanderPerks.interop")
local config = require("ring.Outlander.outlanderPerks.config").sneak

if not config.enabled then return end

local function addModules()
    interop.newModule({
        skill = tes3.dataHandler.nonDynamicData.skills["sneak"],
        perks = {

        },
        refreshCallback = function ()
            
        end
    })
end

event.register("modConfigReady", function (e)
    addModules()
end)