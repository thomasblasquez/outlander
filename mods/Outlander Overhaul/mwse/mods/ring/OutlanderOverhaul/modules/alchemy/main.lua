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
    local ControlledConsumption = require("Controlled Consumption.shared")

    if (not interop) or (not lib) or (not config) then return false end
    if not config.enabled then log:debug("ALCHEMY: Module disabled!") return false end

--#endregion

--#region Variables

    local skill = tes3.getSkill(tes3.skill.alchemy)

    local skillName = tes3.findGMST(tes3.gmst.sSkillAlchemy).value

    local perks = {
        { -- DONE
            id = "alchemyApprentice",
            name = skillName..": "..i18n("apprentice"),
            description = i18n("descriptions.alchemy.apprentice"),
            isUnique = true,
            skillReq = { alchemy = config.apprenticeRequirement}
        },
        { -- DONE
            id = "alchemyJourneyman",
            name = skillName..": "..i18n("journeyman"),
            description = i18n("descriptions.alchemy.journeyman"),
            isUnique = true,
            skillReq = { alchemy = config.journeymanRequirement}
        },
        { -- DONE
            id = "alchemyExpert",
            name = skillName..": "..i18n("expert"),
            description = i18n("descriptions.alchemy.expert"),
            isUnique = true,
            skillReq = { alchemy = config.expertRequirement}
        },
        {
            id = "alchemyMaster",
            name = skillName..": "..i18n("master"),
            description = i18n("descriptions.alchemy.master"),
            isUnique = true,
            skillReq = { alchemy = config.masterRequirement}
        }
    }

--#endregion

--#region Functions

    local function refreshCallback() log:trace("ALCHEMY: refreshCallback()")
        local alchemyBase = tes3.mobilePlayer.alchemy.base log:trace("  alchemyBase = %n", alchemyBase)
        local qualityLimit = 0.5 log:trace("    qualityLimit = %n", qualityLimit)
        if alchemyBase <= config.apprenticeRequirement then
            tes3.findGMST("fWortChanceValue").value = alchemyBase
        elseif alchemyBase >= config.apprenticeRequirement and alchemyBase < config.journeymanRequirement then
            tes3.findGMST("fWortChanceValue").value = math.floor(alchemyBase/2)
        elseif alchemyBase >= config.journeymanRequirement and alchemyBase < config.expertRequirement then
            tes3.findGMST("fWortChanceValue").value = math.floor(alchemyBase/3)
            qualityLimit = 1
        elseif alchemyBase >= config.expertRequirement then
            tes3.findGMST("fWortChanceValue").value = math.floor(alchemyBase/4)
            qualityLimit = 1.2
            if alchemyBase >= config.masterRequirement then
                qualityLimit = 10
            end
        end
        tes3.player.data.OutlanderOverhaul.alchemyQualityLimit = qualityLimit
    end

    ---@param e projectileHitActorEventData
    local function onProjectileHitActor(e)
        local potionId = tes3.player.data.OutlanderOverhaul.throwablePotions[e.firingWeapon.id]
        if potionId then
            local potion = tes3.getObject(potionId)
            tes3.applyMagicSource{
                reference = e.target,
                name = potion.name,
                effects = potion.effects
            }
        end
    end

    ---@param e activateEventData
    local function onActivate(e)
        if e.target.objectType ~= tes3.objectType["apparatus"] then return end
        local qualityLimit = tes3.player.data.OutlanderOverhaul.alchemyQualityLimit
        local reference = e.target
        if reference.object.quality > qualityLimit and not tes3.worldController.inputController:isShiftDown() then
            e.block = true
            e.claim = true
            tes3.messageBox{message = "You are not skilled enough to use this quality of apparatus!", buttons = {"Pick Up", "Cancel"}, callback = function (e)
                if e == 0 then
                    tes3.addItem{reference = tes3.player, item = reference.object.id}
                    reference:disable()
                    reference:delete()
                end
            end}
        end
    end

    ---@param e equipEventData
    local function onEquip(e)
        if not (
            tes3.worldController.inputController:isAltDown()
            and common.interops.perkSystem.playerInfo.hasPerk("alchemyApprentice")
        ) then return end
        if
            ControlledConsumption and ControlledConsumption.basicPotionChecks(e)
            and e.reference == tes3.mobilePlayer.reference
        then
            e.block = true
            e.claim = true
            local potion = e.item
            local throwable = tes3.getObject(potion.id.."_throwable")
            if not throwable then
                throwable = tes3.createObject{ ---@cast throwable tes3weapon
                    id = potion.id.."_throwable",
                    objectType = tes3.objectType.weapon,
                    name = potion.name.." (Throwable)",
                    type = tes3.weaponType.marksmanThrown,
                    icon = potion.icon,
                    mesh = potion.mesh,
                    skill = tes3.skill.alchemy,
                    value = potion.value
                }
                tes3.player.data.OutlanderOverhaul.throwablePotions = tes3.player.data.OutlanderOverhaul.throwablePotions or {}
                tes3.player.data.OutlanderOverhaul.throwablePotions[throwable.id] = potion.id
            end
            tes3.removeItem{
                reference = tes3.player,
                item = potion,
                count = 1,
                playSound = false
            }
            tes3.addItem{
                reference = tes3.player,
                item = throwable,
                count = 1,
                playSound = false
            }
            tes3.equip{
                reference = tes3.player,
                item = throwable,
                playSound = true
            }
        end
        if tes3.player.data.OutlanderOverhaul.throwablePotions[e.item.id] then
            e.block = true
            e.claim = true
            tes3.removeItem{
                reference = tes3.player,
                item = e.item,
                count = 1,
                playSound = false
            }
            tes3.addItem{
                reference = tes3.player,
                item = tes3.getObject(tes3.player.data.OutlanderOverhaul.throwablePotions[e.item.id]),
                count = 1,
                playSound = false
            }
            tes3.player.data.OutlanderOverhaul.throwablePotions[e.item.id] = nil
        end
    end

    local function onInitialized()
        interop.newModule({
            skill = skill,
            perks = perks,
            refreshCallback = refreshCallback
        })
    end

--#endregion

--#region Events

    event.register(tes3.event.initialized, onInitialized)
    event.register(tes3.event.activate, onActivate, {priority = 1000})
    event.register(tes3.event.equip, onEquip, {priority = 1000})
    event.register(tes3.event.projectileHitActor, onProjectileHitActor)

--#endregion