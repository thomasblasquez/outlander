-- Interops
local ashfallBushcraftConfig = require("mer.ashfall.bushcrafting.config")
local ashfallFoodConfig = require("mer.ashfall.config.foodConfig")

local spawnableCreatures = {
    "rat",
    "scrib",
    "kwama forager",
    "mudcrab"
}

local public = {}

timer.register("OP:DeadfallTrapTimer", function (e)
    local securityDC = math.random(1,100)
    local securityRoll = math.random(1,50)
    local reference = e.timer.data.reference
    local baitNode = reference.sceneNode:getObjectByName("baitNode")
    if securityDC <= ((tes3.mobilePlayer.security.current/2) + securityRoll) then
        local trapLocation = reference.position
        local trapOrientation = reference.orientation
        local creatureRoll = spawnableCreatures[math.random(1,4)]
        local creatureScale = 1
        if creatureRoll == "mudcrab" then
            creatureScale = 0.4
        end
        local caughtCreature = tes3.createReference{
            object = tes3.getObject(creatureRoll),
            position = trapLocation,
            orientation = trapOrientation,
            scale = creatureScale
        }
        caughtCreature.mobile:kill()
        tes3.playAnimation{
            reference = reference,
            group = tes3.animationGroup.idle2,
            loopCount = 0
        }
        reference.data.baited = false
        reference.data.bait = nil
        reference.data.triggered = true
        baitNode:detachAllChildren()
        baitNode:update()
        e.timer.data.reference:updateLighting()
        e.timer:reset()
        e.timer:pause()
        tes3.messageBox("Sounds like your trap caught something!")
    else
        baitNode:detachAllChildren()
        baitNode:update()
        e.timer.data.reference:updateLighting()
        reference.data.baited = false
        reference.data.bait = nil
        e.timer:reset()
        e.timer:pause()
        tes3.messageBox("Sounds like your trap had its bait stolen. You might want to bait it again.")
    end
end)

local function baitDeadfallTrap(e)
    local data = e.reference.data
    local baitNode = e.reference.sceneNode:getObjectByName("baitNode")
    if data.baited then
        baitNode:detachAllChildren()
        baitNode:update()
        e.reference:updateLighting()
        tes3.addItem{
            reference = tes3.mobilePlayer,
            item = data.bait,
            itemData = data.baitItemData,
            count = 1
        }
        tes3.messageBox("Removed "..data.bait.name.." from the trap.")
        e.reference.data.baited = false
        return
    end
    tes3ui.showInventorySelectMenu{
        title = "Select bait",
        noResultsText = "You have no valid bait.",
        leaveMenuMode = true,
        filter = function (params)
            local foodType = ashfallFoodConfig.getFoodType(params.item)
            if not foodType then return false end
            local validFoodTypes = {
                meat = true,
                cookedmeat = true,
                mushroom = true,
                vegetable = true,
                food = true,
                fruit = true
            }
            foodType = string.lower(foodType)
            if validFoodTypes[foodType] then return true else return false end
        end,
        callback = function (params)
            if not params.item then return end
            tes3.removeItem{
                reference = tes3.mobilePlayer,
                item = params.item,
                itemData = params.itemData,
                count = 1
            }
            tes3.messageBox("Used "..params.item.name.." as bait.")
            data.bait = params.item
            data.baitItemData = params.itemData
            data.baited = true
            local sceneNode = tes3.loadMesh(params.item.mesh, true)
            if sceneNode ~= nil then
                sceneNode = sceneNode:clone()
                baitNode:attachChild(sceneNode)
                baitNode:update()
                e.reference:updateLighting()
                timer.start{
                    type = timer.game,
                    persist = true,
                    iterations = 1,
                    duration = 0.16,
                    callback = "OP:DeadfallTrapTimer",
                    data = {
                        reference = e.reference
                    }
                }
            end
        end
    }
end

public.recipe = {
    id = "OP_deadfall_trap",
    craftableId = "OP_deadfall_trap",
    description = "A basic trap for small animals such as scribs, rats, foragers, or mudcrabs. Add bait once the trap has been placed.",
    category = "Traps",
    name = "Deadfall Trap",
    additionalMenuOptions = {
        {
            text = "Bait",
            showRequirements = function (e)
                return ((not e.reference.data.baited) and (not e.reference.data.triggered))
            end,
            callback = baitDeadfallTrap,
            tooltip = {
                header = "Bait",
                text = "Place bait into the trap. Bait can be meat, vegetables, mushrooms, fruit, or food items.",
                callback = function (params)
                    params.tooltip:getContentElement():createLabel{ text = "No bait." }
                end
            }
        },
        {
            text = "Remove Bait",
            showRequirements = function (e)
                return e.reference.data.baited
            end,
            callback = baitDeadfallTrap,
            tooltip = {
                header = "Remove Bait",
                text = "Remove current bait from the trap.",
                callback = function (params)
                    local tooltipAddition = "Baited with: "..params.reference.data.bait.name
                    params.tooltip:getContentElement():createLabel{ text = tooltipAddition}
                end
            }
        },
        {
            text = "Reset Trap",
            showRequirements = function (e)
                return e.reference.data.triggered
            end,
            callback = function (e)
                tes3.playAnimation{
                    reference = e.reference,
                    group = tes3.animationGroup.idle1
                }
                e.reference.data.triggered = false
            end,
            tooltip = {
                header = "Reset Trap",
                text = "Set the trap again. Don't forget to bait it afterwards!"
            }
        }
    },
    soundType = "wood",
    materials = {
        { material = "wood", count = 1 },
        { material = "stone", count = 1 }
    },
    toolRequirements = {
        {
            tool = "probe",
            equipped = true,
            count = 1,
            conditionPerUse = 1
    }
    },
    customRequirements = {
        ashfallBushcraftConfig.customRequirements.wildernessOnly
    },
    ---@class CraftingFrameworkParams
    ---@field reference tes3reference
    ---@param params CraftingFrameworkParams
    placeCallback = function (params)
        tes3.messageBox{ message = "Activate the trap to place bait" }
        local luaData = params.reference.data
        luaData.baited = false
        luaData.bait = nil
        luaData.baitItemData = nil
        luaData.triggered = false
    end
}

return public