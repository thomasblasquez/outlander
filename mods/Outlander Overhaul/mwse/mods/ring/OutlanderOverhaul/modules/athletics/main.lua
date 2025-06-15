--#region Common

    local common = require("ring.OutlanderOverhaul.common")
    if not common then return false end
    local log = common.log

--#endregion

--#region Requirements

    local interop = require("ring.OutlanderOverhaul.interop")
    local perkSystem = require("KBLib.PerkSystem.perkSystem")
    local config = require("ring.OutlanderOverhaul.config").modules.athletics
    if not interop or not perkSystem or not config then
        log:error("ATHLETICS: Module disabled due to missing requirements!")
        return false
    end

--#endregion

--#region Variables

    local journeymanSpell
    local expertSpell
    local masterSpell
    local increaseSpeed = false
    local effectApplied = {}
    local waterWalked = false

--#endregion

--#region Functions
local function createSpells()
    journeymanSpell = tes3.createObject({
        id = "OP:AthleticsJourneyman",
        objectType = tes3.objectType.spell,
        name = "Athletics: Journeyman",
        castType = tes3.spellType.ability,
        effects = {
            {
                id = tes3.effect["jump"],
                min = 10,
                max = 10
            }
        }
    })
    expertSpell = tes3.createObject({
        id = "OP:AthleticsExpert",
        objectType = tes3.objectType.spell,
        name = "Athletics: Expert",
        castType = tes3.spellType.ability,
        effects = {
            {
                id = tes3.effect["fortifyAttack"],
                min = 10,
                max = 10
            }
        }
    })
    masterSpell = tes3.createObject({
        id = "OP:AthleticsMaster",
        objectType = tes3.objectType.spell,
        name = "Athletics: Master",
        castType = tes3.spellType.ability,
        effects = {
            {
                id = tes3.effect["waterWalking"],
                min = 10,
                max = 10,
                duration = 10
            }
        }
    })
end

local waterWalkTimer = timer.start{
    duration = 5,
    callback = function (e)
        if effectApplied.masterSpell then
            tes3.removeSpell({
                reference = tes3.mobilePlayer,
                spell = masterSpell
            })
            waterWalked = true
        end
    end
}
waterWalkTimer:pause()

local function removeSpells()
    if effectApplied.journeymanSpell then
        tes3.removeSpell({
            reference = tes3.mobilePlayer,
            spell = journeymanSpell
        })
        effectApplied.journeymanSpell = false
    end
    if effectApplied.expertSpell then
        tes3.removeSpell({
            reference = tes3.mobilePlayer,
            spell = expertSpell
        })
        effectApplied.expertSpell = false
    end
    if effectApplied.masterSpell then
        tes3.removeSpell({
            reference = tes3.mobilePlayer,
            spell = masterSpell
        })
        effectApplied.masterSpell = false
        waterWalked = false
    end
end

local function collideWaterCallback()
    if
        increaseSpeed
        and perkSystem.playerInfo.hasPerk("athleticsMaster")
        and not effectApplied.masterSpell
        and not waterWalked
    then
        tes3.addSpell{ mobile = tes3.mobilePlayer, spell = masterSpell}
        effectApplied.masterSpell = true
        waterWalkTimer:resume()
        tes3.messageBox{ message = "Water Running!" }
    end
end

local fiveSecondTimer = timer.start({
    duration = 5,
    callback = function ()
        if perkSystem.playerInfo.hasPerk("athleticsApprentice") then
            increaseSpeed = true
            tes3.messageBox{ message = "Marathon activated!" }
        end
        if perkSystem.playerInfo.hasPerk("athleticsExpert") then
            tes3.addSpell{ mobile = tes3.mobilePlayer, spell = expertSpell}
            effectApplied.expertSpell = true
        end
    end
})
fiveSecondTimer:pause()

local function runningOrSwimming(e)
    if e.mobile == tes3.mobilePlayer and tes3.mobilePlayer.isMovingForward and tes3.mobilePlayer.isRunning and not tes3.mobilePlayer.isFlying then
        if perkSystem.playerInfo.hasPerk("athleticsApprentice") and fiveSecondTimer.state == timer.paused then
            fiveSecondTimer:resume()
        end
        if increaseSpeed then
            e.speed = e.speed * 1.25
        end
        if perkSystem.playerInfo.hasPerk("athleticsJourneyman") then
            tes3.addSpell{ mobile = tes3.mobilePlayer, spell = journeymanSpell}
            effectApplied.journeymanSpell = true
        end
    end
    local currentWaterLevel = tes3.mobilePlayer.cell.waterLevel or 0
    if currentWaterLevel > tes3.mobilePlayer.position.z then collideWaterCallback() end
    if not (tes3.mobilePlayer.isMovingForward and tes3.mobilePlayer.isRunning) and increaseSpeed then
        tes3.messageBox{ message = "Marathon deactivated!" }
        increaseSpeed = false
        fiveSecondTimer:reset()
        fiveSecondTimer:pause()
        waterWalkTimer:reset()
        waterWalkTimer:pause()
        removeSpells()
    end
end

local function addModules()
    interop.newModule({
        skill = tes3.getSkill(tes3.skill.athletics),
        perks = {
            {
                    id = "athleticsApprentice",
                    name = "Athletics: Apprentice",
                    description = "You are now an Apprentice in Athletics. Running for 5 seconds straight activates Marathon, which increases your movement speed by 25% until you stop running. This applies while swimming as well.",
                    isUnique = true,
                    skillReq = { athletics = config.apprenticeRequirement}
            },
            {
                    id = "athleticsJourneyman",
                    name = "Athletics: Journeyman",
                    description = "You are now a Journeyman in Athletics. You now jump higher when getting a running start.",
                    isUnique = true,
                    skillReq = { athletics = config.journeymanRequirement}
            },
            {
                    id = "athleticsExpert",
                    name = "Athletics: Expert",
                    description = "You are now an Expert in Athletics. Marathon now gives you a 10pt fortify attack buff until you stop running. This applies while swimming as well.",
                    isUnique = true,
                    skillReq = { athletics = config.expertRequirement}
            },
            {
                    id = "athleticsMaster",
                    name = "Athletics: Master",
                    description = "You are now a Master in Athletics. While Marathon is active, you can walk on water for five seconds after hitting the surface.",
                    isUnique = true,
                    skillReq = { athletics = config.masterRequirement}
            }
        },
        refreshCallback = function ()
            event.register(tes3.event.calcMoveSpeed, runningOrSwimming, { unregisterOnLoad = true})
        end
    })
end

event.register(tes3.event.initialized, function (e)
    createSpells()
    addModules()
end)