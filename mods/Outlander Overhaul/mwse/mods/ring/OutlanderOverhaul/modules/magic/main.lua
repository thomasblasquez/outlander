--[[
    magicka cost reduction + ability to use that school in the self Spellmaking menu
    Specialization    
    Ritual Spells with Crafting Framework
    individual capstones
]]

local perkSystem = require("KBLib.PerkSystem.perkSystem")
local interop = require("ring.OutlanderOverhaul.interop")

-- School Names

local illusionName = tes3.getSkillName(tes3.skill.illusion):lower()
local conjurationName = tes3.getSkillName(tes3.skill.conjuration):lower()
local alterationName = tes3.getSkillName(tes3.skill.alteration):lower()
local destructionName = tes3.getSkillName(tes3.skill.destruction):lower()
local mysticismName = tes3.getSkillName(tes3.skill.mysticism):lower()
local restorationName = tes3.getSkillName(tes3.skill.restoration):lower()

local function onMagicEffectsResolved()
    summonStorageMagicEffect = tes3.addMagicEffect
end

local currentSpellInstance

---@param e damagedEventData
local function onDamaged(e)
    if
        e.attacker ~= tes3.mobilePlayer
        or e.magicEffectInstance == currentSpellInstance
        or not perkSystem.playerInfo.hasPerk(destructionName.."Apprentice")
        or not e.magicEffect
        or not e.magicSourceInstance.source.castType == tes3.spellType.spell
        or e.magicEffect.skill ~= tes3.skill.destruction
    then
        return
    end
    currentSpellInstance = e.magicEffectInstance
    e.mobile:hitStun()
end

---@param e spellCastedFailureEventData
local function onSpellCastedFailure(e)
    if e.caster ~= tes3.player or not perkSystem.playerInfo.hasPerk(alterationName.."Apprentice") then
        return
    end
    for _, effect in ipairs(e.source.effects) do
        if effect.skill == tes3.skill.alteration  then
            tes3.modStatistic{
                reference = tes3.mobilePlayer,
                name = "magicka",
                current = tes3.mobilePlayer.magicka.current + math.round(effect.cost/2)
            }
            tes3.messageBox("You have regained half the Magicka cost of your failed %s cast", effect.object.name)
        end
    end
end

-- Master level perk

--- Checks if a spell only has effects from a single school
---@param spell tes3spell
---@return tes3.skill | nil
local function isSingleSchool(spell)
    local school
    for _, effect in ipairs(spell.effects) do
        school = school or effect.skill
        if effect.skill ~= school then
            return nil
        end
    end
    return school
end

--- Handles the spellMagickaUse event to reduce the cost of spells that only use a single school of magic when the player has the corresponding Master perk
---@param e spellMagickaUseEventData
local function onspellMagickaUse(e)
    if e.caster ~= tes3.player then
        return
    end
    local skill = isSingleSchool(e.spell)
    if skill and perkSystem.playerInfo.hasPerk(tes3.getSkillName(skill):lower().."Master") then
        e.cost = e.cost * 0.5
    end
end

event.register(tes3.event.spellMagickaUse, onspellMagickaUse)
event.register(tes3.event.spellCastedFailure, onSpellCastedFailure)
event.register(tes3.event.damaged, onDamaged)
event.register(tes3.event.magicEffectsResolved, onMagicEffectsResolved)