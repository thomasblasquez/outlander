--[[
    TODO for this file:
    - Logging
    - Translation
--]]

--#region Classes

    --- Table representing an individual perk.
    ---@class OutlanderOverhaul.Perks.Perk
    ---@field id string Unique perk ID
    ---@field name string Display name of the perk
    ---@field description string Perk description 
    ---@field isUnique boolean Should always be true
    ---@field skillReq table<tes3.skill,integer> Table of skill requirements

    --- Table representing a perk module
    ---@class OutlanderOverhaul.Perks.Module
    ---@field skill tes3skill The skill that this module controls
    ---@field perks [OutlanderOverhaul.Perks.Perk] Table of perks added by this module
    ---@field refreshCallback function? Optional function called when checking what perks should be granted to a character, such as on a skill raise or save game load

    --- Outlander Overhaul Perks Interop
    --- 
    --- Returns false if mod or perks are disabled in the config.
    --- 
    --- You can change any module:
    --- ```
    ---     local module = interop.getModule(skill)
    ---     module.perks = newPerkTable
    ---     module.refreshCallback = newCallbackFunction
    ---     interop.newModule(module)
    --- ```
    --- You can add new skills in the same way:
    --- ```
    ---     ---@type OutlanderOverhaul.Perks.Module
    ---     local module = {
    ---         skill = tes3skill,
    ---         perks = perkTable,
    ---         refreshCallback = function()
    ---     }
    ---     interop.newModule(module)
    --- ```
    --- `newModule()` will always overwrite an existing module, if it exists.
    ---@class OutlanderOverhaul.Perks.Interop
    ---@field refreshPerks fun(): nil Calls all stored perk refresh callbacks. Runs on `loaded`, `charGenFinished`, and `skillRaised` events by default.
    ---@field getModule fun(skill: tes3.skill): OutlanderOverhaul.Perks.Module | boolean Returns the perk module controlling the given skill
    ---@field getModules fun(): OutlanderOverhaul.Perks.Module[] Returns all registered perk modules
    ---@field newModule fun(module: OutlanderOverhaul.Perks.Module): OutlanderOverhaul.Perks.Module | boolean Registers a new perk module with Outlander Overhaul

--#endregion

--#region Requirements

    local perkSystem = require("KBLib.PerkSystem.perkSystem")
    local config = require("ring.OutlanderOverhaul.config")

    if not config then return false end
    if not (config.modEnabled and config.perksEnabled) then return false end

--#endregion

--#region Variables

    --- Array of registered tables
    ---@type OutlanderOverhaul.Perks.Module[]
    local modules = {}
    ---@type OutlanderOverhaul.Perks.Interop
    local public

--#endregion

--#region Public Functions

    public.refreshPerks = function ()
        for i, module in pairs(modules) do
            if module.refreshCallback then
                module.refreshCallback()
            end
        end
    end

    public.getModule = function (skill)
        for i, module in pairs(modules) do
            if module.skill.id == skill then
                return module
            end
        end
        return false
    end

    public.getModules = function ()
        return modules
    end

    public.newModule = function (module)
        local oldModule = public.getModule(module.skill)
        if oldModule then
            table.removevalue(modules, oldModule)
        end
        local skillPerkList = {}
        table.insert(modules, module)
        for _, perk in pairs(module.perks) do
            perkSystem.createPerk(perk)
            table.insert(skillPerkList, perk.id)
            -- Register skillRaised events for each skill requirement
            for skill,level in pairs(perk.skillReq) do
                event.register(
                    tes3.event.skillRaised,
                    function (e)
                        if level >= e.level and not perkSystem.playerInfo.hasPerk(perk.id) then
                            perkSystem.playerInfo.grantPerk(perk.id)
                            module.refreshCallback()
                        end
                    end,
                    {
                        filter = skill
                    }
                )
            end
        end
        return module
    end
--#endregion

return public