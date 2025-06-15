-- Logging
local logger = require("logging.logger")
local log = logger.get("Outlander Perks")
-- Config
local config = require("ring.Outlander.outlanderPerks.config").security
if not config.enabled then return end

-- Libraries
local perkSystem = require("KBLib.PerkSystem.perkSystem")

-- Load perks into Perk Framework
require("ring.Outlander.securityOverhaul.securityPerks")

-- Load Crafting Framework interop
local crafting = require("ring.Outlander.securityOverhaul.crafting")
if not crafting then
    mwse.log("")
end

local function pickTrapSpell()
    local pickedSpell
    tes3ui.showMagicSelectMenu{
        title = "Trap Spell",
        selectSpells = true,
        selectPowers = false,
        selectEnchanted = false,
        callback = function (params)
            if params.spell then
                pickedSpell = params.spell
            end
        end
    }
    return pickedSpell
end

local function onToolUsed(e)
    -- Return if not in game with tool readied
    if tes3.menuMode() or tes3.onMainMenu() or e.button ~= 0 or tes3.mobilePlayer.weaponReady == false then return end
    local tool = tes3.mobilePlayer.readiedWeapon
    local currentTarget = tes3.getPlayerTarget()
    if not tool then return end
    -- Journeyman Perk: Trap an untrapped container or door
    -- AND Trap Crafting
    if tool.object.objectType == tes3.objectType.probe then
        if currentTarget ~= nil then
            if
                (currentTarget.objectType == tes3.objectType.door or currentTarget.objectType == tes3.objectType.container)
                and perkSystem.playerInfo.hasPerk("securityJourneyman")
            then
                local pickedSpell = pickTrapSpell()
                tes3.setTrap({
                    reference = currentTarget,
                    spell = pickedSpell
                })
            end
        else
            timer.start{
                duration = 0.5,
                callback = function ()
                    event.trigger("OP:ActivateTrapCraftingMenu")
                end
            }
        end
    end
    -- Apprentice Perk: Lock an unlocked container or door
    if tes3.mobilePlayer.readiedWeapon.object.objectType == tes3.objectType.lockpick and perkSystem.playerInfo.hasPerk("securityApprentice") then
        if not currentTarget then return end
        if not tes3.getLocked{ reference = currentTarget } then
            timer.start{
                callback = function ()
                    local newLockLevel = math.floor(tes3.mobilePlayer.security.current*tool.object.quality)
                    tes3.lock{ reference = currentTarget, level = newLockLevel}
                    tes3ui.refreshTooltip()
                end,
                duration = 0.5
            }
        end
    end
end

event.register("mouseButtonDown", onToolUsed)