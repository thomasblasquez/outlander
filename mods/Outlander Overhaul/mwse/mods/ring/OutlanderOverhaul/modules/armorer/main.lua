--[[
    New configurations:
    - Fortify Attack amount per perk level
    - Reflect amount per perk level
    - enable heat
    - Heat treatment multiplier
    - Disintigrate multiplier
]]

--#region Common

    local common = require("ring.OutlanderOverhaul.common")
    if not common then return end
    local log = common.log
    local i18n = common.i18n
    local playerHasPerk = common.interops.perkSystem.playerInfo.hasPerk
    local ashfall = common.interops.ashfall

--#endregion

--#region Requirements

local interop = require("ring.OutlanderOverhaul.interop")
local lib = require("ring.lib.main")
local config = require("ring.OutlanderOverhaul.config").modules.armorer

if (not interop) or (not lib) or (not config) then return false end
if not config.enabled then log:debug("ARMORER: module disabled!") return false end

--#endregion

--#region Variables

    local skill = tes3.getSkill(tes3.skill.armorer)

    local skillName = tes3.findGMST(tes3.gmst.sSkillArmorer).value

    local perks = {
        {
            id = "armorerApprentice",
            name = skillName..": "..i18n("apprentice"),
            description = i18n("descriptions.armorer.apprentice"),
            isUnique = true,
            skillReq = { armorer = config.apprenticeRequirement}
        },
        {
            id = "armorerJourneyman",
            name = skillName..": "..i18n("journeyman"),
            description = i18n("descriptions.armorer.journeyman"),
            isUnique = true,
            skillReq = { armorer = config.journeymanRequirement}
        },
        {
            id = "armorerExpert",
            name = skillName..": "..i18n("expert"),
            description = i18n("descriptions.armorer.expert"),
            isUnique = true,
            skillReq = { armorer = config.expertRequirement}
        },
        {
            id = "armorerMaster",
            name = skillName..": "..i18n("master"),
            description = i18n("descriptions.armorer.master"),
            isUnique = true,
            skillReq = { armorer = config.masterRequirement}
        }
    }

    local savedCondition = {
        weapon = nil,
        head = nil,
        cuirass = nil,
        leftPauldron = nil,
        rightPauldron = nil,
        leftGauntlet = nil,
        rightGauntlet = nil,
        greaves = nil,
        boots = nil,
        shield = nil
    }

    local fortifyAttackSpell = tes3.createObject{
        id = "OO_fortifyAttack",
        name = "Tempered Weapon",
        objectType = tes3.objectType.spell,
        castType = tes3.spellType.ability,
        effects = {
            { id = tes3.effect.fortifyAttack, range = tes3.effectRange.self, min = 1, max = 1 }
        }
    }

    local reflectSpell = tes3.createObject{
        id = "OO_reflect",
        name = "Reflective Armor",
        objectType = tes3.objectType.spell,
        castType = tes3.spellType.ability,
        effects = {
            { id = tes3.effect.reflect, range = tes3.effectRange.self, min = 1, max = 1 }
        }
    }

    local equipmentReferenceController = ashfall.referenceController.registerReferenceController{
        id = "equipment",
        requirements = function (_, ref) ---@cast ref tes3reference
            return ref.objectType == tes3.objectType.weapon or ref.objectType == tes3.objectType.armor
        end
    }

    local repairingNow = false
    local mitigate = false
    local mitigation = nil
    local tempering = false
    local temperAmount = 0
    local temperedItems = nil
    local reflect = false
    local reflectAmount = 0
    local reflectiveItems = nil
    local disintegrate = false
    local disintegrateSlot = nil
    local heatTimer = nil

    -- Temp configurations

    local heatEnabled = false
    local heatMultiplier = 2
    local heatDecayRate = 10
    local heatSpeed = 1
    local disintegrateMultiplier = 3

--#endregion

--#region Functions

    local function onAttack()
        local currentEquipment = lib.getEquipmentStack(tes3.player)
        lib.forLoop(currentEquipment, function(slot, item)
            if slot == "pants" then return true end
            if not item then savedCondition[slot] = nil return end
            savedCondition[slot] = item.itemData.condition
        end)
    end

    ---@param e calcArmorPieceHitEventData
    local function onCalcArmorPieceHit(e)
        if e.attacker == tes3.mobilePlayer then
            disintegrateSlot = e.slot
        end
    end

    ---@param e damagedEventData
    local function onDamaged(e)
        if mitigate and e.mobile == tes3.mobilePlayer then
            local damageMitigated = false
            local currentCondition = lib.getEquipmentStack(tes3.player)
            lib.forLoop(currentCondition, function(slot, item) ---@cast item tes3equipmentStack
                if not item then return end
                local condition = item.itemData.condition
                if condition >= savedCondition[slot] then return end
                if math.random(1, 100) < mitigation then return end
                damageMitigated = true
                if slot == "weapon" then
                    tes3.mobilePlayer.readiedWeapon.itemData.condition = savedCondition[slot]
                else
                    tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot[slot]}).itemData.condition = savedCondition[slot]
                end
            end)
            if damageMitigated then
                tes3.messageBox(i18n("messages.armorer.mitigated"))
            end
        end
        if disintegrate and e.attacker == tes3.mobilePlayer then
            local targetedSlot = tes3.getEquippedItem({actor = e.mobile, slot = tes3.armorSlot[disintegrateSlot]})
            if targetedSlot then
                targetedSlot.itemData.condition = e.damage*disintegrateMultiplier
            end
        end
    end

    ---@param e repairEventData
    local function onRepair(e)
        if not e.repairer == tes3.mobilePlayer then return end
        repairingNow = true
        e.itemData.data.OutlanderOverhaul.heat = e.itemData.data.OutlanderOverhaul.heat or 0
        if heatEnabled and e.itemData.data.OutlanderOverhaul.heat > 0 then
            e.repairAmount = e.repairAmount * heatMultiplier
            e.itemData.data.OutlanderOverhaul.heat = e.itemData.data.OutlanderOverhaul.heat - 10
            if e.itemData.data.OutlanderOverhaul.heat < 0 then e.itemData.data.OutlanderOverhaul.heat = 0 end
        elseif heatEnabled and e.itemData.data.OutlanderOverhaul.heat == 0 then
            if ((e.itemData.condition + e.repairAmount)/e.item.maxCondition) >= 0.75 then
                e.chance = 0
                tes3.messageBox(i18n("messages.armorer.noHeat", e.item.name))
            end
        end
        event.register(tes3.event.menuExit,function ()
            local item = tes3.getReference(e.item.id)
            local fullRepair = (item.itemData.condition == item.object.maxCondition)
            if tempering and item.objectType == tes3.objectType.weapon and fullRepair then
                e.itemData.data.OutlanderOverhaul.tempered = true
                if not temperedItems then temperedItems = {} end
                table.insert(temperedItems, item.object.name)
            end
            if reflect and e.item.objectType == tes3.objectType.armor and fullRepair then
                e.itemData.data.OutlanderOverhaul.reflective = true
                if not reflectiveItems then reflectiveItems = {} end
                table.insert(reflectiveItems, item.object.name)
            end
        end, { doOnce = true})
    end

    local function onMenuExit()
        if not repairingNow then return end
        repairingNow = false
        if not reflectiveItems or not temperedItems then return end
        timer.delayOneFrame(function ()
            local reflectMessage = ""
            local temperMessage = ""
            local postRepairMessage = nil
            lib.forLoop(reflectiveItems, function (i, name)
                local final = " "..i18n("and").." "
                if #reflectiveItems > 2 then
                    final = ", "..i18n("and").." "
                end
                if i == #reflectiveItems then
                    reflectMessage = reflectMessage..final..name
                elseif i == 1 then
                    reflectMessage = name
                else
                    reflectMessage = ", "..reflectMessage
                end
            end)
            lib.forLoop(temperedItems, function (i, name)
                local final = " "..i18n("and").." "
                if #temperedItems > 2 then
                    final = ", "..i18n("and").." "
                end
                if i == #temperedItems then
                    temperMessage = temperMessage..final..name
                elseif i == 1 then
                    temperMessage = name
                else
                    temperMessage = ", "..temperMessage
                end
            end)
            temperMessage = i18n(
                "messages.armorer.postRepair", 
                { count = #temperedItems, name = temperMessage, upgrade = i18n("messages.armorer.upgrades.temper") }
            )
            reflectMessage = i18n(
                "messages.armorer.postRepair",
                { count = #reflectiveItems, name = reflectMessage, upgrade = i18n("messages.armorer.upgrades.reflect") }
            )
            if temperMessage and reflectMessage then
                postRepairMessage = temperMessage..reflectMessage
            elseif temperMessage or reflectMessage then
                postRepairMessage = temperMessage or reflectMessage
            end
            if not postRepairMessage then return end
            tes3.messageBox(postRepairMessage)
        end)
    end

    ---@param e uiObjectTooltipEventData
    local function onUIObjectTooltip(e)
        if e.itemData.data.OutlanderOverhaul.tempered then
            e.tooltip:createLabel({
                text = i18n("tooltips.armorer.tempered"),
                color = tes3ui.getPalette(tes3.palette.whiteColor)
            })
        end
        if e.itemData.data.OutlanderOverhaul.reflective then
            e.tooltip:createLabel({
                text = i18n("tooltips.armorer.reflective"),
                color = tes3ui.getPalette(tes3.palette.whiteColor)
            })
        end
    end

    local function checkEquipped()
        local currentEquipment = lib.getEquipmentStack(tes3.player)
        local reflectTotal = 0
        local isTempered = false
        tes3.removeSpell{ reference = tes3.player, spell = fortifyAttackSpell }
        tes3.removeSpell{ reference = tes3.player, spell = reflectSpell }
        lib.forLoop(currentEquipment, function(_, item) ---@cast item tes3equipmentStack
            if not item then return end
            if item.itemData.data.OutlanderOverhaul.tempered then
                if (item.itemData.condition/item.object.maxCondition) < 0.50 then
                    item.itemData.data.OutlanderOverhaul.tempered = false
                else
                    isTempered = true
                end
            end
            if item.itemData.data.OutlanderOverhaul.reflective then
                if (item.itemData.condition/item.object.maxCondition) < 0.50 then
                    item.itemData.data.OutlanderOverhaul.reflective = false
                else
                    reflectTotal = reflectTotal + reflectAmount
                end
            end
        end)
        if reflectTotal > 0 then
            reflectSpell.effects[1].min = reflectTotal
            reflectSpell.effects[1].max = reflectTotal
            tes3.addSpell{ reference = tes3.player, spell = reflectSpell }
        end
        if isTempered then
            fortifyAttackSpell.effects[1].min = temperAmount
            fortifyAttackSpell.effects[1].max = temperAmount
            tes3.addSpell{ reference = tes3.player, spell = fortifyAttackSpell }
        end
    end

    ---@param ref tes3reference
    local function updateTooltip(ref)
        local text = "%"..ref.itemData.data.OutlanderOverhaul.heat
        if ref.itemData.data.OutlanderOverhaul.tooltipped and ref.itemData.data.OutlanderOverhaul.heat == 0 then
            ref.itemData.data.OutlanderOverhaul.tooltipped = false
            ref.itemData.data.OutlanderOverhaul.tooltip:destroy()
        end
        if not ref.itemData.data.OutlanderOverhaul.tooltipped then
            event.register(tes3.event.uiObjectTooltip, function (e)
                if e.reference == ref then
                    ref.itemData.data.OutlanderOverhaul.tooltip = e.tooltip:createLabel{ text = text }
                    ref.itemData.data.OutlanderOverhaul.tooltipped = true
                end
            end, { doOnce = true})
        elseif ref.itemData.data.OutlanderOverhaul.tooltip then
            ref.itemData.data.OutlanderOverhaul.tooltip.text = text
        end
        tes3ui.refreshTooltip()
    end

    ---@param ref tes3reference
    local function itemHeating(ref)
        if not heatEnabled then return end
        local heatSource, heatLevel = ashfall.common.helper.getHeatFromBelow(ref)
        local timestamp = tes3.getSimulationTimestamp()
        ref.itemData.data.OutlanderOverhaul.heat = ref.itemData.data.OutlanderOverhaul.heat or 0
        ref.itemData.data.OutlanderOverhaul.heatUpdated = ref.itemData.data.OutlanderOverhaul.heatUpdated or timestamp
        local difference = timestamp - ref.itemData.data.OutlanderOverhaul.heatUpdated
        local heatAdded = difference*heatSpeed
        local heatLost = difference*heatDecayRate
        if not (heatSource and heatSource.data.isLit and heatLevel) then
            if ref.itemData.data.OutlanderOverhaul.heat > 0 then
                ref.itemData.data.OutlanderOverhaul.heat = ref.itemData.data.OutlanderOverhaul.heat - heatLost
                if ref.itemData.data.OutlanderOverhaul.heat < 0 then ref.itemData.data.OutlanderOverhaul.heat = 0 end
            end
            updateTooltip(ref)
            return
        end
        if heatLevel == "weak" then
            tes3.messageBox(i18n("messages.armorer.lowHeat"), heatSource.object.name)
            return
        end
        ref.itemData.data.OutlanderOverhaul.heat = ref.itemData.data.OutlanderOverhaul.heat + heatAdded
        updateTooltip(ref)
    end

    local function refreshCallback() log:trace("ARMORER: refreshCallback()")
        if playerHasPerk("armorerApprentice") then
            mitigate = true
            mitigation = 90
        else
            mitigate = false
            mitigation = nil
            tempering = false
            temperAmount = 0
            reflect = false
            reflectAmount = 0
        end
        if playerHasPerk("armorerJourneyman") then
            mitigate = true
            mitigation = 75
            tempering = true
            temperAmount = 2
        end
        if playerHasPerk("armorerExpert") then
            mitigate = true
            mitigation = 50
            tempering = true
            temperAmount = 5
            reflect = true
            reflectAmount = 1
        end
        if playerHasPerk("armorerMaster") then
            mitigate = true
            mitigation = 25
            tempering = true
            temperAmount = 10
            reflect = true
            reflectAmount = 2
            disintegrate = true
        end
        checkEquipped()
        if not heatTimer then
            heatTimer = timer.start{
                duration = ashfall.common.helper.getUpdateIntervalInSeconds(),
                iterations = -1,
                callback = function() equipmentReferenceController:iterate(itemHeating) end
            }
        end
    end

    local function onInitialized() log:trace("ARMORER: onInitialized()")
        interop.newModule({
            skill = skill,
            perks = perks,
            refreshCallback = refreshCallback
        })
    end

--#endregion

--#region Events

    event.register(tes3.event.attack, onAttack)
    event.register(tes3.event.calcArmorPieceHit, onCalcArmorPieceHit)
    event.register(tes3.event.damaged, onDamaged)
    event.register(tes3.event.repair, onRepair)
    event.register(tes3.event.menuExit, onMenuExit)
    event.register(tes3.event.uiObjectTooltip, onUIObjectTooltip)
    event.register(tes3.event.equipped, checkEquipped)
    event.register(tes3.event.unequipped, checkEquipped)
    event.register(tes3.event.initialized, onInitialized)

--#endregion