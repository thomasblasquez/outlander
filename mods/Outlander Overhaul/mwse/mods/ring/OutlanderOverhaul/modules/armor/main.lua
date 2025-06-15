--#region Common

    local common = require("ring.OutlanderOverhaul.common")
    if not common then return end
    local log = common.log
    local i18n = common.i18n
    local playerHasPerk = common.interops.perkSystem.playerInfo.hasPerk

--#endregion

--#region Requirements

    local interop = require("ring.OutlanderOverhaul.interop")
    local lib = require("ring.lib.main")
    local config = require("ring.OutlanderOverhaul.config").modules.armorSkills

    if (not interop) or (not lib) or (not config) then return false end
    if not config.enabled then log:debug("ARMOR: module disabled!") return false end

--#endregion

--#region Variables

    local slots = {
        allEquipped = {
            head = true,
            cuirass = true,
            leftPauldron = true,
            rightPauldron = true,
            leftGauntlet = true,
            rightGauntlet = true,
            greaves = true,
            boots = true
        },
        [tes3.armorWeightClass.light] = {
            head = false,
            cuirass = false,
            leftPauldron = false,
            rightPauldron = false,
            leftGauntlet = false,
            rightGauntlet = false,
            greaves = false,
            boots = false
        },
        [tes3.armorWeightClass.medium] = {
            head = false,
            cuirass = false,
            leftPauldron = false,
            rightPauldron = false,
            leftGauntlet = false,
            rightGauntlet = false,
            greaves = false,
            boots = false
        },
        [tes3.armorWeightClass.heavy] = {
            head = false,
            cuirass = false,
            leftPauldron = false,
            rightPauldron = false,
            leftGauntlet = false,
            rightGauntlet = false,
            greaves = false,
            boots = false
        },
        ["unarmored"] = {
            head = false,
            cuirass = false,
            leftPauldron = false,
            rightPauldron = false,
            leftGauntlet = false,
            rightGauntlet = false,
            greaves = false,
            boots = false,
            shield = false
        }
    }

    local lightArmorPerks = {
        { -- DONE
            id = "lightArmorApprentice",
            name = tes3.findGMST(tes3.gmst.sSkillLightarmor).value..": "..i18n("apprentice"),
            description = i18n("descriptions.lightArmor.apprentice"),
            isUnique = true,
            skillReq = { lightArmor = config.apprenticeRequirement}
        },
        { -- DONE
            id = "lightArmorJourneyman",
            name = tes3.findGMST(tes3.gmst.sSkillLightarmor).value..": "..i18n("journeyman"),
            description = i18n("descriptions.lightArmor.journeyman"),
            isUnique = true,
            skillReq = { lightArmor = config.journeymanRequirement}
        },
        { -- DONE
            id = "lightArmorExpert",
            name = tes3.findGMST(tes3.gmst.sSkillLightarmor).value..": "..i18n("expert"),
            description = i18n("descriptions.lightArmor.expert"),
            isUnique = true,
            skillReq = { lightArmor = config.expertRequirement}
        },
        { -- DONE
            id = "lightArmorMaster",
            name = tes3.findGMST(tes3.gmst.sSkillLightarmor).value..": "..i18n("master"),
            description = i18n("descriptions.lightArmor.master"),
            isUnique = true,
            skillReq = { lightArmor = config.masterRequirement}
        }
    }

    local mediumArmorPerks = {
        { -- DONE
            id = "mediumArmorApprentice",
            name = tes3.findGMST(tes3.gmst.sSkillMediumarmor).value..": "..i18n("apprentice"),
            description = i18n("descriptions.mediumArmor.apprentice"),
            isUnique = true,
            skillReq = { mediumArmor = config.apprenticeRequirement}
        },
        { -- DONE
            id = "mediumArmorJourneyman",
            name = tes3.findGMST(tes3.gmst.sSkillMediumarmor).value..": "..i18n("journeyman"),
            description = i18n("descriptions.mediumArmor.journeyman"),
            isUnique = true,
            skillReq = { mediumArmor = config.journeymanRequirement}
        },
        { -- DONE
            id = "mediumArmorExpert",
            name = tes3.findGMST(tes3.gmst.sSkillMediumarmor).value..": "..i18n("expert"),
            description = i18n("descriptions.mediumArmor.expert"),
            isUnique = true,
            skillReq = { mediumArmor = config.expertRequirement}
        },
        { -- DONE
            id = "mediumArmorMaster",
            name = tes3.findGMST(tes3.gmst.sSkillMediumarmor).value..": "..i18n("master"),
            description = i18n("descriptions.mediumArmor.master"),
            isUnique = true,
            skillReq = { mediumArmor = config.masterRequirement}
        }
    }

    local heavyArmorPerks = {
        { -- DONE
            id = "heavyArmorApprentice",
            name = tes3.findGMST(tes3.gmst.sSkillHeavyarmor).value..": "..i18n("apprentice"),
            description = i18n("descriptions.heavyArmor.apprentice"),
            isUnique = true,
            skillReq = { heavyArmor = config.apprenticeRequirement}
        },
        { -- DONE
            id = "heavyArmorJourneyman",
            name = tes3.findGMST(tes3.gmst.sSkillHeavyarmor).value..": "..i18n("journeyman"),
            description = i18n("descriptions.heavyArmor.journeyman"),
            isUnique = true,
            skillReq = { heavyArmor = config.journeymanRequirement}
        },
        { -- DONE
            id = "heavyArmorExpert",
            name = tes3.findGMST(tes3.gmst.sSkillHeavyarmor).value..": "..i18n("expert"),
            description = i18n("descriptions.heavyArmor.expert"),
            isUnique = true,
            skillReq = { heavyArmor = config.expertRequirement}
        },
        { -- DONE
            id = "heavyArmorMaster",
            name = tes3.findGMST(tes3.gmst.sSkillHeavyarmor).value..": "..i18n("master"),
            description = i18n("descriptions.heavyArmor.master"),
            isUnique = true,
            skillReq = { heavyArmor = config.masterRequirement}
        }
    }

    local unarmoredPerks = {
        { -- DONE
            id = "unarmoredApprentice",
            name = tes3.findGMST(tes3.gmst.sSkillUnarmored).value..": "..i18n("apprentice"),
            description = i18n("descriptions.unarmored.apprentice"),
            isUnique = true,
            skillReq = { unarmored = config.apprenticeRequirement}
        },
        { -- DONE
            id = "unarmoredJourneyman",
            name = tes3.findGMST(tes3.gmst.sSkillUnarmored).value..": "..i18n("journeyman"),
            description = i18n("descriptions.unarmored.journeyman"),
            isUnique = true,
            skillReq = { unarmored = config.journeymanRequirement}
        },
        { -- DONE
            id = "unarmoredExpert",
            name = tes3.findGMST(tes3.gmst.sSkillUnarmored).value..": "..i18n("expert"),
            description = i18n("descriptions.unarmored.expert"),
            isUnique = true,
            skillReq = { unarmored = config.expertRequirement}
        },
        { -- DONE
            id = "unarmoredMaster",
            name = tes3.findGMST(tes3.gmst.sSkillUnarmored).value..": "..i18n("master"),
            description = i18n("descriptions.unarmored.master"),
            isUnique = true,
            skillReq = { unarmored = config.masterRequirement}
        }
    }

    local featherSpell = tes3.createObject({
        id = "OO_FeatherSpell",
        objectType = tes3.objectType.spell,
        castType = tes3.spellType.ability,
        name = "NOT SET",
        effects = {
            { id = tes3.effect.feather, range = tes3.effectRange.self, min = 100, max = 100 }
        }
    })

    local slowfallSpell = tes3.createObject({
        id = "OO_SlowfallSpell",
        objectType = tes3.objectType.spell,
        castType = tes3.spellType.ability,
        name = i18n("descriptions.armor.unarmored.master"),
        effects = {
            { id = tes3.effect.slowFall, range = tes3.effectRange.self, min = 1, max = 1 }
        }
    })

    local defaultfFatigueReturnBase = tes3.findGMST(tes3.gmst.fFatigueReturnBase).value + 0
    local armorEncumberance = 0

    local allLightArmor = false
    local allMediumArmor = false
    local allHeavyArmor = false
    local noArmor = false
    local canSlowfall = false
    local canBullRush = true
    local hadSetBonus = false
    local firstJump = true

--#endregion

--#region Functions

    ---@param e loadedEventData | nil
    local function checkArmor(e) log:trace("ARMOR: checkArmor()")
        if e and (e.filename or e.newGame) then
            canBullRush = true
            hadSetBonus = false
            firstJump = true
        end
        local skillName = nil
        local spellName = nil
        local castFeather = false
        local hasRobe = tes3.getEquippedItem({actor = tes3.player, slot = tes3.clothingSlot.robe}) log:trace("ARMOR: checkArmor() - hasRobe: %s", tostring(hasRobe))
        local hasSkirt = tes3.getEquippedItem({actor = tes3.player, slot = tes3.clothingSlot.skirt}) log:trace("ARMOR: checkArmor() - hasSkirt: %s", tostring(hasSkirt))
        local hasShield = tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot.shield})
        local isEquipped = {
            head = tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot.helmet}),
            cuirass = tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot.cuirass}),
            leftPauldron = tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot.leftPauldron}),
            rightPauldron = tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot.rightPauldron}),
            leftGauntlet = tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot.leftGauntlet}),
            rightGauntlet = tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot.rightGauntlet}),
            greaves = tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot.greaves}),
            boots = tes3.getEquippedItem({actor = tes3.player, slot = tes3.armorSlot.boots})
        }   log:trace("ARMOR: checkArmor() - isEquipped: \n%s", json.encode(isEquipped))
        allHeavyArmor = false
        allLightArmor = false
        allMediumArmor = false
        noArmor = false
        armorEncumberance = 0

        lib.forLoop(isEquipped, function(slotName, itemStack) ---@param itemStack tes3itemStack
            slots[tes3.armorWeightClass.light][slotName] = false
            slots[tes3.armorWeightClass.medium][slotName] = false
            slots[tes3.armorWeightClass.heavy][slotName] = false
            slots["unarmored"][slotName] = false
            if itemStack then
                local armorType = itemStack.object.weightClass
                if slots[armorType] then
                    slots[armorType][slotName] = true
                end
                armorEncumberance = armorEncumberance + itemStack.object.weight
            else
                if slotName == "shield" then
                    slots[tes3.armorWeightClass.heavy][slotName] = true
                    slots[tes3.armorWeightClass.light][slotName] = true
                    slots[tes3.armorWeightClass.medium][slotName] = true
                end
                slots["unarmored"][slotName] = true
            end
        end)
        log:trace("ARMOR: checkArmor() - slots: \n%s", json.encode(slots))
        log:trace("ARMOR: checkArmor() - armorEncumberance: %s", tostring(armorEncumberance))

        if slots[tes3.armorWeightClass.light] == slots.allEquipped then
            if hasShield and hasShield.object.weightClass ~= tes3.armorWeightClass.light then
                return
            end
            allLightArmor = true
            if playerHasPerk("lightArmorApprentice") then
                skillName =  tes3.findGMST(tes3.gmst.sSkillLightarmor).value
            end
            if playerHasPerk("lightArmorJourneyman") then
                castFeather = true
                spellName = i18n("armorSpellName.light")
            end
        elseif slots[tes3.armorWeightClass.medium] == slots.allEquipped then
            if hasShield and hasShield.object.weightClass ~= tes3.armorWeightClass.medium then
                return
            end
            allMediumArmor = true
            if playerHasPerk("mediumArmorApprentice") then
                skillName =  tes3.findGMST(tes3.gmst.sSkillMediumarmor).value
            end
            if playerHasPerk("mediumArmorExpert") then
                castFeather = true
                spellName = i18n("armorSpellName.medium")
            end
        elseif slots[tes3.armorWeightClass.heavy] == slots.allEquipped then
            if hasShield and hasShield.object.weightClass ~= tes3.armorWeightClass.heavy then
                return
            end
            allHeavyArmor = true
            if playerHasPerk("heavyArmorApprentice") then
                skillName =  tes3.findGMST(tes3.gmst.sSkillHeavyarmor).value
            end
            if playerHasPerk("heavyArmorMaster") then
                castFeather = true
                spellName = i18n("armorSpellName.heavy")
            end
        elseif slots["unarmored"] == slots.allEquipped then
            noArmor = true
            if playerHasPerk("unarmoredApprentice") then
                skillName =  tes3.findGMST(tes3.gmst.sSkillUnarmored).value
            end
        end
        log:trace("ARMOR: checkArmor() - allLightArmor: %s", tostring(allLightArmor))
        log:trace("ARMOR: checkArmor() - allMediumArmor: %s", tostring(allMediumArmor))
        log:trace("ARMOR: checkArmor() - allHeavyArmor: %s", tostring(allHeavyArmor))
        log:trace("ARMOR: checkArmor() - noArmor: %s", tostring(noArmor))

        if skillName and not hadSetBonus then
            tes3.messageBox(i18n("messages.armor.allEquipped", skillName))
            hadSetBonus = true
        elseif not skillName and hadSetBonus then
            tes3.messageBox(i18n("messages.armor.lostSetBonus"))
            hadSetBonus = false
        end

        if
            (playerHasPerk("unarmoredApprentice") and noArmor)
            or
            (playerHasPerk("mediumArmorJourneyman") and allMediumArmor)
        then
            tes3.findGMST(tes3.gmst.fFatigueReturnBase).value = tes3.findGMST(tes3.gmst.fFatigueReturnBase).value * 1.5
        elseif tes3.findGMST(tes3.gmst.fFatigueReturnBase).value ~= defaultfFatigueReturnBase then
            tes3.findGMST(tes3.gmst.fFatigueReturnBase).value = defaultfFatigueReturnBase
        end
        if
            (hasRobe or hasSkirt)
            and
            (playerHasPerk("unarmoredMaster") and noArmor)
        then
            canSlowfall = true
        else
            canSlowfall = false
        end
        if castFeather then
            featherSpell.name = spellName
            featherSpell.effects[1].min = armorEncumberance
            featherSpell.effects[1].max = armorEncumberance
            tes3.addSpell({
                reference = tes3.player,
                spell = featherSpell
            })
        else
            tes3.removeSpell({
                reference = tes3.player,
                spell = featherSpell
            })
        end
    end

    ---@param e calcArmorRatingEventData
    local function onCalcArmorRating(e) log:trace("ARMOR: onCalcArmorRating()")
        local armorBonus = 0
        if allLightArmor and playerHasPerk("lightArmorApprentice")
        then
            armorBonus = 0.25
        elseif allLightArmor and playerHasPerk("lightArmorExpert")
        then
            armorBonus = 0.50
        elseif allMediumArmor and playerHasPerk("mediumArmorApprentice")
        then
            armorBonus = 0.25
        elseif allHeavyArmor and playerHasPerk("heavyArmorExpert")
        then
            armorBonus = 0.25
        end
        e.armorRating = e.armorRating * (1 + armorBonus)
    end

    local function onJumpDown() log:trace("ARMOR: onJumpDown()")
        if firstJump then
            firstJump = false
            return
        end
        if canSlowfall and (tes3.mobilePlayer.isFalling or tes3.mobilePlayer.isJumping) then
            local robe = tes3.getEquippedItem({actor = tes3.player, slot = tes3.clothingSlot.robe}).object
            local skirt = tes3.getEquippedItem({actor = tes3.player, slot = tes3.clothingSlot.skirt}).object
            local item = robe or skirt
            tes3.messageBox(i18n("messages.armor.unarmored.master", item.name))
            tes3.addSpell({
                reference = tes3.player,
                spell = slowfallSpell
            })
            event.register(tes3.event.keyUp, function()
                tes3.removeSpell({
                    reference = tes3.player,
                    spell = slowfallSpell
                })
            end, { filter = tes3.getInputBinding(tes3.keybind.jump).code, doOnce = true })
        end
    end

    ---@param e attackHitEventData
    local function onAttackHit(e) log:trace("ARMOR: onAttackHit()")
        if
            (not e.targetMobile == tes3.mobilePlayer)
            or e.mobile.readiedWeapon.object.type == tes3.weaponType.marksmanBow
            or e.mobile.readiedWeapon.object.type == tes3.weaponType.marksmanCrossbow
            or e.mobile.readiedWeapon.object.type == tes3.weaponType.marksmanThrown
        then
            return
        end
        if allLightArmor and playerHasPerk("lightArmorMaster") then
            if math.random(10) == 10 then
                tes3.messageBox(i18n("messages.lightArmor.master"))
                e.mobile.actionData.physicalDamage = 0
            end
        end
        if allMediumArmor and playerHasPerk("mediumArmorMaster") then
            if math.random(10) == 10 then
                tes3.messageBox(i18n("messages.mediumArmor.master"))
                e.mobile:applyDamage{
                    damage = e.mobile.actionData.physicalDamage,
                    applyArmor = true,
                    playerAttack = true
                }
                e.mobile:hitStun()
                e.mobile.actionData.physicalDamage = 0
            end
        end
    end

    ---@param e collisionEventData
    local function onCollision(e) log:trace("ARMOR: onCollision()")
        if
            not (
                (e.mobile == tes3.mobilePlayer)
                and (
                    (
                        e.target.objectType == tes3.objectType.npc
                        or e.target.objectType == tes3.objectType.mobileNPC
                    )
                    or
                    (
                        e.target.objectType == tes3.objectType.creature
                        or e.target.objectType == tes3.objectType.mobileCreature
                    )
                )
                and e.mobile.isRunning and e.mobile.inCombat and e.target.mobile.inCombat
            )
        then return end
        if
            (allHeavyArmor and playerHasPerk("heavyArmorApprentice"))
            and
            canBullRush
        then
            if e.target.mobile.armorRating >= tes3.mobilePlayer.armorRating then
                tes3.messageBox(i18n("messages.heavyArmor.apprentice.failed", e.target.object.name))
                return
            end
            tes3.messageBox(i18n("messages.heavyArmor.apprentice.activated"))
            e.target.mobile:hitStun()
            canBullRush = false
            timer.start{
                duration = 0.1666666667, -- 1/6 of a second
                type = timer.real,
                callback = function()
                    tes3.messageBox(i18n("messages.heavyArmor.apprentice.ready"))
                    canBullRush = true
                end
            }
        end
    end

    ---@param e damagedEventData
    local function onDamaged(e) log:trace("ARMOR: onDamaged()")
        if not e.mobile == tes3.mobilePlayer then return end
        if allHeavyArmor and playerHasPerk("heavyArmorJourneyman") then
            log:debug("ARMOR: HA Journeyman perk activated")
            if math.random(2) == 2 then
                log:debug("ARMOR: HitStun avoided!")
                e.mobile:hitStun{ cancel = true }
            end 
        end
        if noArmor and playerHasPerk("unarmoredExpert") then
            e.damage = e.damage * 0.75
        end
    end

    ---@param e calcHitChanceEventData
    local function onCalcHitChance(e) log:trace("ARMOR: onCalcHitChance()")
        if
            e.attackerMobile == tes3.mobilePlayer
            and e.targetMobile
            and noArmor
            and playerHasPerk("unarmoredJourneyman")
            and e.attackerMobile.armorRating < e.targetMobile.armorRating
        then
            e.hitChance = e.hitChance + (e.hitChance*.10)
        end
        if
            e.targetMobile == tes3.mobilePlayer
            and e.attackerMobile
            and noArmor
            and playerHasPerk("unarmoredJourneyman")
            and e.targetMobile.armorRating < e.attackerMobile.armorRating
        then
            e.hitChance = e.hitChance - (e.hitChance*.10)
        end
    end

    local function onCalcWalkSpeed()
        firstJump = true
    end

    local function onInitialized() log:trace("ARMOR: onInitialized()")
        interop.newModule({
            skill = tes3.getSkill(tes3.skill.lightArmor),
            perks = lightArmorPerks,
            refreshCallback = checkArmor
        })
        interop.newModule({
            skill = tes3.getSkill(tes3.skill.mediumArmor),
            perks = mediumArmorPerks,
            refreshCallback = checkArmor
        })
        interop.newModule({
            skill = tes3.getSkill(tes3.skill.heavyArmor),
            perks = heavyArmorPerks,
            refreshCallback = checkArmor
        })
        interop.newModule({
            skill = tes3.getSkill(tes3.skill.unarmored),
            perks = unarmoredPerks,
            refreshCallback = checkArmor
        })
    end

--#endregion

--#region Events

    event.register(tes3.event.equipped, checkArmor)
    event.register(tes3.event.unequipped, checkArmor)
    event.register(tes3.event.calcArmorRating, onCalcArmorRating)
    event.register(tes3.event.keyDown, onJumpDown, { filter = tes3.getInputBinding(tes3.keybind.jump).code })
    event.register(tes3.event.attack, onAttackHit)
    event.register(tes3.event.collision, onCollision)
    event.register(tes3.event.damaged, onDamaged)
    event.register(tes3.event.calcHitChance, onCalcHitChance)
    event.register(tes3.event.calcWalkSpeed, onCalcWalkSpeed)
    event.register(tes3.event.initialized, onInitialized)

--#endregion