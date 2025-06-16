local interop = require("ring.Outlander.outlanderPerks.interop")
local config = require("ring.Outlander.outlanderPerks.config").ngc
local configNGC = require("ngc.common").config

local function addModules()
    if
        not config.enabled
        or not configNGC.toggleWeaponPerks
    then return end

    local apprenticeReq = configNGC.weaponTier1.weaponSkillMin
    local journeymanReq = configNGC.weaponTier2.weaponSkillMin
    local expertReq = configNGC.weaponTier3.weaponSkillMin
    local masterReq = configNGC.weaponTier4.weaponSkillMin

    interop.newModule({
        skill = tes3.getSkill(tes3.skill.bluntWeapon),
        perks = {
            {
                id = "bluntWeaponApprentice",
                name = "Blunt: Apprentice",
                description = "You are now an Apprentice with Blunt weapons. Each strike you land has a 5% chance to stun your target for 1 second.",
                isUnique = true,
                skillReq = { bluntWeapon = apprenticeReq},
            },
            {
                id = "bluntWeaponJourneyman",
                name = "Blunt: Journeyman",
                description = "You are now a Journeyman with Blunt weapons. Each strike you land has a 10% chance to stun your target for 1 second. You also do 0.2% more damage per point of your target's Armor Rating.",
                isUnique = true,
                skillReq = { bluntWeapon = journeymanReq},
            },
            {
                id = "bluntWeaponExpert",
                name = "Blunt: Expert",
                description = "You are now an Expert with Blunt weapons. Each strike you land has a 15% chance to stun your target for 1 second. You also do 0.25% more damage per point of your target's Armor Rating..",
                isUnique = true,
                skillReq = { bluntWeapon = expertReq},
            },
            {
                id = "bluntWeaponMaster",
                name = "Blunt: Master",
                description = "You are now a Master with Blunt weapons. Each strike you land has a 20% chance to stun your target for 1 second. You also do 0.33% more damage per point of your target's Armor Rating..",
                isUnique = true,
                skillReq = { bluntWeapon = masterReq}
            }
        }
    })

    interop.newModule({
        skill = tes3.getSkill(tes3.skill.longBlade),
        perks = {
            {
                    id = "longBladeApprentice",
                    name = "Long Blades: Apprentice",
                    description = "You are now an Apprentice with Long Blades. Every third attack you land will now Multistrike, doing 10% bonus damage.",
                    isUnique = true,
                    skillReq = { longBlade = apprenticeReq}
            },
            {
                    id = "longBladeJourneyman",
                    name = "Long Blades: Journeyman",
                    description = "You are now a Journeyman with Long Blades. Multistrike now does 20% bonus damage with a 5% chance for double damage. Additionally, you can now counter attack within two seconds to Riposte. Riposte has a 10% chance to deal 50% bonus damage.",
                    isUnique = true,
                    skillReq = { longBlade = journeymanReq}
            },
            {
                    id = "longBladeExpert",
                    name = "Long Blades: Expert",
                    description = "You are now an Expert with Long Blades. Multistrike now does 35% bonus damage with a 10% chance for double damage. Riposte now has a 15% chance to deal 50% bonus damage.",
                    isUnique = true,
                    skillReq = { longBlade = expertReq}
            },
            {
                    id = "longBladeMaster",
                    name = "Long Blades: Master",
                    description = "You are now a Master with Long Blades. Multistrike now does 50% bonus damage with a 20% chance for double damage. Riposte now has a 20% chance to deal 50% bonus damage.",
                    isUnique = true,
                    skillReq = { longBlade = masterReq}
            }
        }
    })

    interop.newModule({
        skill = tes3.getSkill(tes3.skill.axe),
        perks = {
            {
                    id = "axeApprentice",
                    name = "Axe: Apprentice",
                    description = "You are now an Apprentice with Axes. Your strikes have a 15% chance to deal 150% bleed damage over 3 seconds. Bleed damage cannot kill an enemy.",
                    isUnique = true,
                    skillReq = { axe = apprenticeReq}
            },
            {
                    id = "axeJourneyman",
                    name = "Axe: Journeyman",
                    description = "You are now a Journeyman with Axes. Your strikes now have a 20% chance to deal 150% bleed damage over 3 seconds. Bleed damage cannot kill an enemy.",
                    isUnique = true,
                    skillReq = { axe = journeymanReq}
            },
            {
                    id = "axeExpert",
                    name = "Axe: Expert",
                    description = "You are now an Expert with Axes. Your strikes now have a 25% chance to deal 150% bleed damage over 3 seconds, and bleed can stack twice. Bleed damage cannot kill an enemy.",
                    isUnique = true,
                    skillReq = { axe = expertReq}
            },
            {
                    id = "axeMaster",
                    name = "Axe: Master",
                    description = "You are now a Master with Axes. Your strikes now have a 30% chance to deal 150% bleed damage over 3 seconds, and bleed can stack up to three times. Bleed damage cannot kill an enemy.",
                    isUnique = true,
                    skillReq = { axe = masterReq}
            }
        }
    })

    interop.newModule({
        skill = tes3.getSkill(tes3.skill.spear),
        perks = {
            {
                    id = "spearApprentice",
                    name = "Spear: Apprentice",
                    description = "You are now an Apprentice with Spears. You can now gain Momentum, granting you 15% bonus damage on hit if your fatigue percentage is higher than your target's.",
                    isUnique = true,
                    skillReq = { spear = apprenticeReq}
            },
            {
                    id = "spearJourneyman",
                    name = "Spear: Journeyman",
                    description = "You are now a Journeyman with Spears. Momentum now grants you 30% bonus damage. You also have a 10% chance to gain Adrenaline Rush, giving you 50pts Restore Fatgiue for 3 seconds.",
                    isUnique = true,
                    skillReq = { spear = journeymanReq}
            },
            {
                    id = "spearExpert",
                    name = "Spear: Expert",
                    description = "You are now an Expert with Spears. Momentum now grants you 45% bonus damage. Your chance to gain Adrenaline Rush is now 20%.",
                    isUnique = true,
                    skillReq = { spear = expertReq}
            },
            {
                    id = "spearMaster",
                    name = "Spear: Master",
                    description = "You are now a Master with Spears. Momentum now grants you 60% bonus damage. Your chance to gain Adrenaline Rush is now 30%.",
                    isUnique = true,
                    skillReq = { spear = masterReq}
            },
        }
    })

    interop.newModule({
        skill = tes3.getSkill(tes3.skill.shortBlade),
        perks = {
            {
                    id = "shortBladeApprentice",
                    name = "Short Blades: Apprentice",
                    description = "You are now an Apprentice with Short Blades. Attacks with Short Blades have a 10% chance to Critical Strike, dealing 100% bonus damage.",
                    isUnique = true,
                    skillReq = { shortBlade = apprenticeReq}
            },
            {
                    id = "shortBladeJourneyman",
                    name = "Short Blades: Journeyman",
                    description = "You are now a Journeyman with Short Blades. Attacks with Short Blades have a 20% chance to Critical Strike, dealing 100% bonus damage. You also now do Execute damage, dealing 50% bonus damage when your target is at 25% HP or lower.",
                    isUnique = true,
                    skillReq = { shortBlade = journeymanReq}
            },
            {
                    id = "shortBladeExpert",
                    name = "Short Blades: Expert",
                    description = "You are now an Expert with Short Blades. Attacks with Short Blades have a 35% chance to Critical Strike, dealing 100% bonus damage. You do 100% more Execute damage when your target is at 25% HP or lower.",
                    isUnique = true,
                    skillReq = { shortBlade = expertReq}
            },
            {
                    id = "shortBladeMaster",
                    name = "Short Blades: Master",
                    description = "You are now a Master with Short Blades. Attacks with Short Blades have a 50% chance to Critical Strike, dealing 150% bonus damage. You do 100% more Execute damage when your target is at 25% HP or lower.",
                    isUnique = true,
                    skillReq = { shortBlade = masterReq} 
            }
        }
    })

    interop.newModule({
        skill = tes3.getSkill(tes3.skill.marksman),
        perks = {
            {
                    id = "marksmanApprentice",
                    name = "Marksman: Apprentice",
                    description = "You are now an Apprentice with Marksman weapons. You can now achieve a Full Draw with bows, rapidly draining your fatigue to give you a zoomed view and 25% bonus damage on hit. Additionally, Crossbows can do more damage at close range, adding 10% bonus damage when in Critical Range. Finally, Thrown Weapons have a 10% chance to Critical Strike for 100% bonus damage.",
                    isUnique = true,
                    skillReq = { marksman = apprenticeReq}
            },
            {
                    id = "marksmanJourneyman",
                    name = "Marksman: Journeyman",
                    description = "You are now a Journeyman with Marksman weapons. Full Draw now deals 50% bonus damage and every bow hit has a 10% chance to Hamstring your target, reducing their movement speed by 50% for three seconds. Crossbows deal 15% bonus damage when in Critical Range and have a 20% chance to trigger Repeater on each hit, instantly reloading a new bolt. Thrown Weapons have a 20% chance to Critical Strike.",
                    isUnique = true,
                    skillReq = { marksman = journeymanReq}
            },
            {
                    id = "marksmanExpert",
                    name = "Marksman: Expert",
                    description = "You are now an Expert with Marksman weapons. Full Draw now deals 50% bonus damage and every bow hit has a 15% chance to Hamstring your target. Crossbows deal 20% bonus damage when in Critical Range and have a 35% chance to trigger Repeater on each hit. Thrown Weapons have a 35% chance to Critical Strike.",
                    isUnique = true,
                    skillReq = { marksman = expertReq}
            },
            {
                    id = "marksmanMaster",
                    name = "Marksman: Master",
                    description = "You are now a Master with Marksman weapons. Full Draw now deals 100% bonus damage and every bow hit has a 20% chance to Hamstring your target. Additionally, you can now rapid fire arrows with Multishot. Crossbows deal 25% bonus damage when in Critical Range and have a 50% chance to trigger Repeater on each hit. Thrown Weapons have a 50% chance to Critical Strike.",
                    isUnique = true,
                    skillReq = { marksman = masterReq}
            }
        }
    })

    interop.newModule({
        skill = tes3.getSkill(tes3.skill.handToHand),
        perks = {
            {
                    id = "handToHandApprentice",
                    name = "Hand-to-Hand: Apprentice",
                    description = "You are now an Apprentice in Hand-to-Hand combat. Your unarmed base damage has increased to 3-4, you have a 5% chance to knockdown your target, and you gain 10% bonus damage to knocked down enemies",
                    isUnique = true,
                    skillReq = { handToHand = apprenticeReq}
            },
            {
                    id = "handToHandJourneyman",
                    name = "Hand-to-Hand: Journeyman",
                    description = "You are now a Journeyman in Hand-to-Hand combat. Your unarmed base damage has increased to 5-7, you have a 10% chance to knockdown your target, and you gain 10% bonus damage to knocked down enemies",
                    isUnique = true,
                    skillReq = { handToHand = journeymanReq}
            },
            {
                    id = "handToHandExpert",
                    name = "Hand-to-Hand: Expert",
                    description = "You are now an Expert in Hand-to-Hand combat. Your unarmed base damage has increased to 8-11, you have a 15% chance to knockdown your target, and you gain 20% bonus damage to knocked down enemies",
                    isUnique = true,
                    skillReq = { handToHand = expertReq}
            },
            {
                    id = "handToHandMaster",
                    name = "Hand-to-Hand: Master",
                    description = "You are now a Master in Hand-to-Hand combat. Your unarmed base damage has increased to 11-14, you have a 20% chance to knockdown your target, and you gain 35% bonus damage to knocked down enemies",
                    isUnique = true,
                    skillReq = { handToHand = masterReq}
            }
        }
    })
end


event.register(tes3.event.initialized, function (e)
    addModules()
end)