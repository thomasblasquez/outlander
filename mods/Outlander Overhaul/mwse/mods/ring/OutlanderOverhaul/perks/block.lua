local perkSystem = require("KBLib.PerkSystem.perkSystem")
local interop = require("ring.OutlanderOverhaul.interop")
local TakeThat = require("StormAtronach.TT.block")
if not interop then
    return false
end

local blockJourneymanLoaded = false
local blockExpertLoaded = false
local blockMasterLoaded = false

local function newModules()
    interop.newModule({
        skill = tes3.getSkill(tes3.skill.block),
        perks = {
            {
                id = "blockApprentice",
                name = "Block: Apprentice",
                description = "You are now an Apprentice in Block. You are much more likely to block while holding an attack and can now block projectiles this way.",
                isUnique = true,
                skillReq = { block = 25}
            },
            {
                id = "blockJourneyman",
                name = "Block: Journeyman",
                description = "You are now a Journeyman in Block. You can now Shield Bash by jumping or falling into an enemy while Active Blocking, staggering them.",
                isUnique = true,
                skillReq = { block = 50}
            },
            {
                id = "blockExpert",
                name = "Block: Expert",
                description = "You are now an Expert in Block. Whenever you successfully block an attack, you can immediately cancel the block animation and Counter Attack.",
                isUnique = true,
                skillReq = { block = 75}
            },
            {
                id = "blockMaster",
                name = "Block: Master",
                description = "You are now a Master in Block. Successful blocks now always stagger your attacker.",
                isUnique = true,
                skillReq = { block = 100}
            }
        },
        refreshCallback = function()
            -- Apprentice perk, Active Blocking, is handled by an edit to ShieldsUp! Sound assets from the original mod are required: https://www.nexusmods.com/morrowind/mods/51027?tab=files
            -- Shield Bash
            if perkSystem.playerInfo.hasPerk("blockJourneyman") and not blockJourneymanLoaded then
                -- Check the following conditions upon a collision:
                    -- Collider must be the player
                    -- Collider must be jumping or falling
                    -- Collider must have an attack readied or is in the middle of an active block
                    -- Collider must be wearing a shield
                    -- Collider target must be a mobileCreature or mobileNPC
                -- If all conditions are met, display a toast and stagger the target
                event.register("collision", function (e)
                    if
                        not e.mobile == tes3mobilePlayer
                        or not (e.mobile.isJumping or e.mobile.isFalling)
                        or not (e.mobile.actionData.animationAttackState == 2 or TakeThat.active)
                        or not e.mobile.readiedShield
                        or not (e.target.objectType == tes3.objectType["mobileCreature"] or e.target.objectType == tes3.objectType["mobileNPC"])
                    then return end
                    tes3.messageBox({
                        message = "Shield Bash!",
                        showInDialog = false
                    })
                    e.target.mobile:hitStun()
                end, { unregisterOnLoad = true})
                blockJourneymanLoaded = true
            else
                blockJourneymanLoaded = false
            end

            -- Counter Attack
            if perkSystem.playerInfo.hasPerk("blockExpert") and not blockExpertLoaded then
                event.register("shieldBlocked", function (e)
                    if not e.mobile == tes3mobilePlayer then return end
                    event.register("mouseButtonDown", function ()
                        if e.mobile.actionData.blockingState == 2 or e.mobile.actionData.blockingState == 1 then
                            e.mobile.animationController.remainingBlockTime = 0
                            timer.frame.delayOneFrame(function ()
                                tes3.messageBox({
                                    message = "Counter Attack!",
                                    showInDialog = false
                                })
                                e.mobile:forceWeaponAttack({attackType = tes3.physicalAttackType.thrust})
                            end)
                        end
                    end, { doOnce = true})
                end, { unregisterOnLoad = true})
                blockExpertLoaded = true
            else
                blockExpertLoaded = false
            end

            -- Stagger
            if perkSystem.playerInfo.hasPerk("blockMaster") and not blockMasterLoaded then
                event.register("shieldBlocked", function (e)
                    if not e.mobile == tes3mobilePlayer then return end
                    e.attacker:hitStun()
                end)
            else
                blockMasterLoaded = false
            end

        end
    })
end

event.register(tes3.event.initialized, newModules)