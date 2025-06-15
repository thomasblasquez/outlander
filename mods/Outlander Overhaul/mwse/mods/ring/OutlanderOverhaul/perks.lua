--#region Common

    local common = require("ring.OutlanderOverhaul.common")
    if not common then return end
    local log = common.log
    local i18n = common.i18n

--#endregion

--#region Requirements

    local interop = require("ring.OutlanderOverhaul.interop")
    local lib = require("ring.lib.main")
    local config = require("ring.OutlanderOverhaul.config")

    if not interop then
        log:warn("PERKS: Interop non-functional!")
        return false
    end
    if not lib then
        log:warn("PERKS: Ring's Library non-functional!")
        return false
    end
    if not config then
        log:warn("PERKS: Config failed to load!")
        return false
    end

--#endregion

--#region Variables

    local charGenComplete = false

--#endregion

--#region Functions

    --- Adds perks to a new character
    ---@return nil
    local function addInitialPerks()
        log:debug("Checking and granting inital perks.")
        local initialPerks = {}
        local modules = interop.getModules()
        lib.forLoop(modules, function (_, module)
            lib.forLoop(module.perks, function (_, perk)
                local grantPerk = true
                log:debug("Checking perk: "..perk.id)
                lib.forLoop(perk.skillReq, function (skill, level)
                    log:debug("  "..tes3.skill[skill].." Requirement")
                    log:debug("    Need: "..level)
                    log:debug("    Current: "..tes3.mobilePlayer:getSkillValue(skill))
                    if tes3.mobilePlayer:getSkillValue(tes3.skill[skill]) < level then
                        log:debug("    Skipping perk")
                        grantPerk = false
                        return
                    end
                end)
                if grantPerk then
                    log:debug("  All requirements met! Granting perk to player.")
                    common.interop.perkSystem.playerInfo.grantPerk(perk.id)
                    table.insert(initialPerks, perk.name)
                end
            end)
        end)
        local message = i18n("perks.initialMessage.base")
        lib.forLoop(initialPerks, function (i, perk)
            message = message.."\n"..i..". "..perk
        end)
        message = message..i18n("perks.initialMessage.end")
        tes3.messageBox({
            message = message,
            buttons = {i18n("OK")}
        })
        interop.refreshPerks()
        tes3.player.data.OutlanderPerks = true
        log:info("Successfully added initial perks to the player!")
    end

    --- Creates perk menu when skill is clicked
    ---@param e uiSkillTooltipEventData
    ---@return nil
    local function onSkillTooltip(e)
        if (not config.perksEnabled) or (not charGenComplete) then return end
        local thisSkillsLabel = e.creator
        if thisSkillsLabel == nil then return end
        if not thisSkillsLabel:getTopLevelMenu().id == "MenuStat" then return end
        local module = interop.getModule(e.skill)
        thisSkillsLabel:register(tes3.uiEvent.mouseClick, function ()
            if not module then tes3.messageBox{message = i18n("perks.noPerksMessage")..tes3.getSkill(e.skill).name} return end
            local menu = tes3ui.createMenu{ id = "OutlanderPerks:"..module.skill.name, fixedFrame = true }
                menu.autoHeight = true
                menu.autoWidth = true
            local header = menu:createBlock{}
                header.autoHeight = true
                header.autoWidth = true
                header.childAlignX = 0.5
                header:createLabel{ text = module.skill.name.." "..i18n("perks.literal")}
                header:createDivider{}
            local contentBlock = menu:createBlock{}
                contentBlock.flowDirection = tes3.flowDirection.leftToRight
                contentBlock.autoHeight = true
                contentBlock.autoWidth = true
            local leftBlock = contentBlock:createBlock{}
                leftBlock.autoHeight = true
                leftBlock.width = 200
                leftBlock.flowDirection = tes3.flowDirection.topToBottom
            local perkList = leftBlock:createVerticalScrollPane()
            local rightBlock = contentBlock:createBlock{}
                rightBlock.autoHeight = true
                rightBlock.autoWidth = true
            local rightBorder = rightBlock:createThinBorder{}
                rightBorder.autoHeight = true
                rightBorder.autoWidth = true
            local descriptionBox = rightBlock:createParagraphInput{}
                descriptionBox.disabled = true
                descriptionBox.width = 300
            lib.forLoop(module.perks, function (_, perk)
                local perkLabel = leftBlock:createTextSelect{ text = perk.name}
                local rightBoxText = perk.description..i18n("perks.requirements")
                lib.forLoop(perk.skillReq, function (skill, level)
                    rightBoxText = rightBoxText.."\n  "..tes3.getSkill(skill).name.." "..level
                end)
                if common.interop.perkSystem.playerInfo.hasPerk(perk.id) then
                    rightBoxText = rightBoxText.."\n\n"..i18n("perks.unlocked")
                else
                    rightBoxText = rightBoxText.."\n\n"..i18n("perks.locked")
                    perkLabel.color = {1,0,0}
                end
                perkLabel:register(tes3.uiEvent.mouseClick, function ()
                    descriptionBox.text = rightBoxText
                end)
            end)
            local closeButton = menu:createButton{ text = i18n("Close") }
            closeButton:register(tes3.uiEvent.mouseClick, function ()
                tes3ui.leaveMenuMode()
                menu:destroy()
            end)
        end)
    end

    --- Initialize perks
    ---@param e loadedEventData | charGenFinishedEventData
    ---@return nil
    local function initPerks(e)
        if e.newGame then return end
        charGenComplete = true
        if not e.filename then
            timer.start{
                duration = 1,
                callback = addInitialPerks
            }
            return
        end
        if not tes3.player.data.OutlanderPerks then
            addInitialPerks()
        else
            interop.refreshPerks()
        end
    end

    --- Displays a message when a perk is unlocked
    ---@param perk { perk: OutlanderOverhaul.Perks.Perk }
    ---@return nil
    local function onPerkActivated(perk)
        local perkDescription = common.interop.perkSystem.getPerk(perk.perk).description
        tes3.messageBox({
            message = i18n("perks.unlocked").."\n\n"..perkDescription,
            buttons = {i18n("OK")}
        })
    end

--#endregion

--#region Events

    event.register(tes3.event.uiSkillTooltip, onSkillTooltip)
    event.register(tes3.event.loaded, initPerks)
    event.register(tes3.event.charGenFinished, initPerks)
    event.register("KBPerks:perkActivated", onPerkActivated)

--#endregion