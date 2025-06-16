local effects = {
    summonStorage = nil,
    warm = nil,
    chill = nil,
    waterShield = nil,
    sunShield = nil,
    cleanse = nil,
    staveSleep = nil,
    staveThirst = nil,
    staveHunger = nil,
    currentStorageRef = nil
}

local interop = require("ring.OutlanderOverhaul.interop")
if not interop then return end

-- Claim spell effect IDs

local summonStorageMagicEffectId = tes3.claimSpellEffectId("OO_summonStorage")
local warmMagicEffectId = tes3.claimSpellEffectId("OO_warm")
local chillMagicEffectId = tes3.claimSpellEffectId("OO_chill")
local waterShieldMagicEffectId = tes3.claimSpellEffectId("OO_waterShield")
local sunShieldMagicEffectId = tes3.claimSpellEffectId("OO_sunShield")
local cleanseMagicEffectId = tes3.claimSpellEffectId("OO_cleanse")
local staveSleepMagicEffectId = tes3.claimSpellEffectId("OO_staveSleep")
local staveThirstMagicEffectId = tes3.claimSpellEffectId("OO_staveThirst")
local staveHungerMagicEffectId = tes3.claimSpellEffectId("OO_staveHunger")

-- Object Creation

local cloudStorageContainer = tes3.createObject{
    objectType = tes3.objectType.container,
    id = "OO_cloudStorageContainer",
    name = "Cloud Storage",
    capacity = 50
}

-- onTick Callbacks

local function positionCloudContainer()
    local position = tes3.player.position + {x = 0, y = 0, z = -1000}
    tes3.positionCell{
        reference = effects.currentStorageRef,
        position = position,
        orientation = tes3.player.orientation,
        cell = tes3.player.cell
    }
end

local function summonStorage()
    if not effects.currentStorageRef then
        return
    end
    positionCloudContainer()
    tes3.player:activate(effects.currentStorageRef)
end

-- addMagicEffect Parameters

local summonStorageParams = {
    id = summonStorageMagicEffectId,
    name = "Summon Storage",
    baseCost = 20,
    school = tes3.magicSchool.conjuration,
    description = "Opens a portal to a liminal storage container.",
    icon = tes3.getMagicEffect(tes3.effect.boundShield).icon,
    particleTexture = tes3.getMagicEffect(tes3.effect.boundShield).particleTexture,
    allowEnchanting = false,
    allowSpellmaking = false,
    appliesOnce = true,
    canCastSelf = true,
    canCastTarget = false,
    canCastTouch = false,
    hasNoDuration = true,
    hasNoMagnitude = true,
    unreflectable = true,
    castSound = tes3.getMagicEffect(tes3.effect.boundShield).castSoundEffect.id,
    boltSound = tes3.getMagicEffect(tes3.effect.boundShield).boltSoundEffect.id,
    hitSound = tes3.getMagicEffect(tes3.effect.boundShield).hitSoundEffect.id,
    areaSound = tes3.getMagicEffect(tes3.effect.boundShield).areaSoundEffect.id,
    onTick = summonStorage
}

-- Event Callbacks

function effects.onLoaded()
    if not tes3.player.data.cloudStorage then
        effects.currentStorageRef = tes3.createReference{
            object = cloudStorageContainer,
            position = tes3.player.position + {x = 0, y = 0, z = -1000},
            orientation = tes3.player.orientation,
            cell = tes3.player.cell
        }
        tes3.player.data.cloudStorage = effects.currentStorageRef.id
    else
        effects.currentStorageRef = tes3.getReference(tes3.player.data.cloudStorage)
    end
end

function effects.onMagicEffectsResolved()
    effects.summonStorage = tes3.addMagicEffect(summonStorageParams)
end

return effects