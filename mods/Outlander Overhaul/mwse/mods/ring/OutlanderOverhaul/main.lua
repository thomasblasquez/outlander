--[[
    Outlander Perks
    by codering

    Adds perks and new mechanics specific to Outlander and its mods using the MWSE Perk Framework

    TODO:
    - Finish custom perks:
        - Security (WIP)
        - Armorer
        - Armor
            - Medium Armor
            - Heavy Armor
            - Unarmored
            - Light Armor
        - Enchant
        - Magic
            - Destruction
            - Alteration
            - Illusion
            - Conjuration
            - Mysticism
            - Restoration
        - Sneak
        - Acrobatics
    - Finish logging
    - Finish configuration
        - Message box configs
    - Test
--]]

--#region Common

    local common = require("ring.OutlanderOverhaul.common")
    if not common then return false end
    local log = common.log

--#endregion

--#region Load Mod

    local config = require("ring.OutlanderOverhaul.config")
    if not config then log:error("Config failed to load!") return false end
    if not config.modEnabled then
        log:error("Mod disabled!")
        return false
    end
    if config.perksEnabled then
        if not require("ring.OutlanderOverhaul.perks") then
            log:warn("Skill Perks failed to load!")
        end
    end

--#endregion