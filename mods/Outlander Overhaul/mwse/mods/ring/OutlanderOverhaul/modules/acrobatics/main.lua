--#region Common

local common = require("ring.OutlanderOverhaul.common")
if not common then return end
local log = common.log
local i18n = common.i18n

--#endregion

--#region Requirements

local interop = require("ring.OutlanderOverhaul.interop")
local lib = require("ring.lib.main")
local config = require("ring.OutlanderOverhaul.config").modules.acrobatics
local TakeThat = require("StormAtronach.TT.dodge")

if (not interop) or (not lib) or (not config) then return false end
if not config.enabled then log:debug("ACROBATICS: module disabled!") return false end

--#endregion

--#region Variables

    local skill = tes3.getSkill(tes3.skill.acrobatics)

    local skillName = tes3.findGMST(tes3.gmst.sSkillAcrobatics).value    

    local perks = {
        { -- Done
            id = "acrobaticsApprentice",
            name = skillName..": "..i18n("apprentice"),
            description = i18n("descriptions.acrobatics.apprentice"),
            isUnique = true,
            skillReq = { acrobatics = config.apprenticeRequirement}
        },
        { -- Done
            id = "acrobaticsJourneyman",
            name = skillName..": "..i18n("journeyman"),
            description = i18n("descriptions.acrobatics.journeyman"),
            isUnique = true,
            skillReq = { acrobatics = config.journeymanRequirement}
        },
        { -- Done
            id = "acrobaticsExpert",
            name = skillName..": "..i18n("expert"),
            description = i18n("descriptions.acrobatics.expert"),
            isUnique = true,
            skillReq = { acrobatics = config.expertRequirement}
        },
        { -- Done?
            id = "acrobaticsMaster",
            name = skillName..": "..i18n("master"),
            description = i18n("descriptions.acrobatics.master"),
            isUnique = true,
            skillReq = { acrobatics = config.masterRequirement}
        }
    }

    local sanctuarySpell = tes3.createObject{
        id = "acrobaticsSanctuary",
        objectType = tes3.objectType.spell,
        name = "Acrobatics: Expert",
        spellType = tes3.spellType.ability,
        effects = {
            { id = tes3.effect.sanctuary, range = 0, min = 1, max = 1 }
        }
    }

    local hasDashed = false
    local speedCalculated = false
    local dashAmount = 1000
    local dashVector

--#endregion

--#region Functions

    local function performMidAirDash()
        if
            (tes3.mobilePlayer.isJumping or tes3.mobilePlayer.isFalling)
            and
            (common.interops.perkSystem.playerInfo.hasPerk("acrobaticsMaster"))
            and
            (not hasDashed)
        then
            local player = tes3.player
            local playerVector = player.mobile.impulseVelocity
            local currentZ = playerVector.z
            local keyPressed = false

            if tes3.worldController.inputController:isKeyDown(tes3.keybind.left) then
                playerVector = playerVector + (player.rightDirection*-1)
                keyPressed = true
            end
            if tes3.worldController.inputController:isKeyDown(tes3.keybind.right) then
                playerVector = playerVector + player.rightDirection
                keyPressed = true
            end
            if tes3.worldController.inputController:isKeyDown(tes3.keybind.back) then
                playerVector = playerVector + (player.forwardDirection*-1)
                keyPressed = true
            end
            if tes3.worldController.inputController:isKeyDown(tes3.keybind.forward) or not keyPressed then
                playerVector = playerVector + player.forwardDirection
            end

            playerVector = playerVector:normalized()
            dashVector = playerVector * dashAmount
            dashVector.z = currentZ
            player.mobile.impulseVelocity = dashVector
            hasDashed = true
        end
    end

    local function onJump(e) -- priority 1000 to ensure this runs before TakeThat
        hasDashed = false
        if common.interops.perkSystem.playerInfo.hasPerk("acrobaticsJourneyman") and not TakeThat then
            sanctuarySpell.effects[1].min = tes3.mobilePlayer.acrobatics.current
            sanctuarySpell.effects[1].max = tes3.mobilePlayer.acrobatics.current
            tes3.addSpell{
                reference = tes3.player,
                spell = sanctuarySpell
            }
            timer.start{
                duration = 1,
                type = timer.simulate,
                iterations = -1,
                callback = function(e)
                    if not (tes3.mobilePlayer.isJumping or tes3.mobilePlayer.isFalling) then
                        tes3.removeSpell{
                            reference = tes3.player,
                            spell = sanctuarySpell
                        }
                        e.timer:cancel()
                    end
                end
            }
        elseif (not common.interops.perkSystem.playerInfo.hasPerk("acrobaticsJourneyman")) and TakeThat then
            TakeThat.cooldown = true
        end
    end

    local function onInitialized(e)
        interop.newModule({
            skill = skill,
            perks = perks
        })
    end

--#endregion

--#region Events

    event.register(tes3.event.initialized, onInitialized)
    event.register(tes3.event.keyDown, performMidAirDash, { filter = tes3.scanCode.crouch })
    event.register(tes3.event.jump, onJump, { priority = 1000 })

--#endregion