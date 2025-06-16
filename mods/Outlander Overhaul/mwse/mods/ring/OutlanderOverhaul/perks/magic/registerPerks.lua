local interop = require("ring.OutlanderOverhaul.interop")
local spells = require("ring.OutlanderOverhaul.modules.magic.spells")
local schools = require("ring.OutlanderOverhaul.modules.magic.schoolNames")
if not interop then return end

interop.newModule({
    skill = tes3.getSkill(tes3.skill.illusion),
    perks = {
        {
            id = schools.illusionName.."Apprentice",
            name = "Illusion: Apprentice",
            description = "You are now an Apprentice in Illusion. Illusion spell effects can no longer give you a bounty.",
            isUnique = true,
            skillReq = { illusion = 25 }
        },
        {
            id = schools.illusionName.."Journeyman",
            name = "Illusion: Journeyman",
            description = "You are now a Journeyman in Illusion. You can now create Illusion spells in the self-Spellmaking menu (B)",
            isUnique = true,
            skillReq = { illusion = 50 }
        },
        {
            id = schools.illusionName.."Expert",
            name = "Illusion: Expert",
            description = "You are now an Expert in Illusion. You can now cast Ritual Spells in the School of Illusion.",
            isUnique = true,
            skillReq = { illusion = 75 }
        },
        {
            id = schools.illusionName.."Master",
            name = "Illusion: Master",
            description = "You are now a Master in Illusion. Casting spells with only Illusion effects cost half the Magicka.",
            isUnique = true,
            skillReq = { illusion = 100 }
        }
    }
})

interop.newModule({
    skill = tes3.getSkill(tes3.skill.conjuration),
    perks = {
        {
            id = schools.conjurationName.."Apprentice",
            name = "Conjuration: Apprentice",
            description = "You are now an Apprentice in Conjuration. You have learned the Summon Storage spell, which opens a portal to a liminal storage container.",
            isUnique = true,
            skillReq = { conjuration = 25 }
        },
        {
            id = schools.conjurationName.."Journeyman",
            name = "Conjuration: Journeyman",
            description = "You are now a Journeyman in Conjuration. You can now create Conjuration spells in the self-Spellmaking menu (B)",
            isUnique = true,
            skillReq = { conjuration = 50 }
        },
        {
            id = schools.conjurationName.."Expert",
            name = "Conjuration: Expert",
            description = "You are now an Expert in Conjuration. You can now cast Ritual Spells in the School of Conjuration.",
            isUnique = true,
            skillReq = { conjuration = 75 }
        },
        {
            id = schools.conjurationName.."Master",
            name = "Conjuration: Master",
            description = "You are now a Master in Conjuration. Casting spells with only Conjuration effects cost half the Magicka.",
            isUnique = true,
            skillReq = { conjuration = 100 }
        }
    },
    refreshCallback = spells.checkSpells
})

interop.newModule({
    skill = tes3.getSkill(tes3.skill.alteration),
    perks = {
        {
            id = schools.alterationName.."Apprentice",
            name = "Alteration: Apprentice",
            description = "You are now an Apprentice in Alteration. You have learned to cast the survival spells Warm, Chill, Water Shield, and Sun Screen.",
            isUnique = true,
            skillReq = { alteration = 25 }
        },
        {
            id = schools.alterationName.."Journeyman",
            name = "Alteration: Journeyman",
            description = "You are now a Journeyman in Alteration. You can now create Alteration spells in the self-Spellmaking menu (B).",
            isUnique = true,
            skillReq = { alteration = 50 }
        },
        {
            id = schools.alterationName.."Expert",
            name = "Alteration: Expert",
            description = "You are now an Expert in Alteration.You can now cast Ritual Spells in the School of Alteration.",
            isUnique = true,
            skillReq = { alteration = 75 }
        },
        {
            id = schools.alterationName.."Master",
            name = "Alteration: Master",
            description = "You are now a Master in Alteration. Casting spells with only Alteration effects cost half the Magicka.",
            isUnique = true,
            skillReq = { alteration = 100 }
        }
    },
    refreshCallback = spells.checkSpells
})

interop.newModule({
    skill = tes3.getSkill(tes3.skill.destruction),
    perks = {
        {
            id = schools.destructionName.."Apprentice",
            name = "Destruction: Apprentice",
            description = "You are now an Apprentice in Destruction. Targets hit by your Destruction spell effects are staggered.",
            isUnique = true,
            skillReq = { destruction = 25 }
        },
        {
            id = schools.destructionName.."Journeyman",
            name = "Destruction: Journeyman",
            description = "You are now a Journeyman in Destruction. You can now create Destruction spells in the self-Spellmaking menu (B).",
            isUnique = true,
            skillReq = { destruction = 50 }
        },
        {
            id = schools.destructionName.."Expert",
            name = "Destruction: Expert",
            description = "You are now an Expert in Destruction. You can now cast Ritual Spells in the School of Destruction.",
            isUnique = true,
            skillReq = { destruction = 75 }
        },
        {
            id = schools.destructionName.."Master",
            name = "Destruction: Master",
            description = "You are now a Master in Destruction. Casting spells with only Destruction effects cost half the Magicka.",
            isUnique = true,
            skillReq = { destruction = 100 }
        }
    },
    refreshCallback = spells.checkSpells
})

interop.newModule({
    skill = tes3.getSkill(tes3.skill.mysticism),
    perks = {
        {
            id = schools.mysticismName.."Apprentice",
            name = "Mysticism: Apprentice",
            description = "You are now an Apprentice in Mysticism. You can now keep two Marks to Recall to at once.",
            isUnique = true,
            skillReq = { mysticism = 25 }
        },
        {
            id = schools.mysticismName.."Journeyman",
            name = "Mysticism: Journeyman",
            description = "You are now a Journeyman in Mysticism. You get another Mark to Recall to, for a total of three Marks, and you can create Mysticism spells in the self-Spellmaking menu.",
            isUnique = true,
            skillReq = { mysticism = 50 }
        },
        {
            id = schools.mysticismName.."Expert",
            name = "Mysticism: Expert",
            description = "You are now an Expert in Mysticism. You get an additional Mark to Recall to, for a total of four Marks, and you can now cast Ritual Spells in the School of Mysticism.",
            isUnique = true,
            skillReq = { mysticism = 75 }
        },
        {
            id = schools.mysticismName.."Master",
            name = "Mysticism: Master",
            description = "You are now a Master in Mysticism. You get a final Mark to Recall to, for a total of five Marks, and casting spells with only Mysticism effects cost half the Magicka.",
            isUnique = true,
            skillReq = { mysticism = 100 }
        }
    },
    refreshCallback = spells.checkSpells
})

interop.newModule({
    skill = tes3.getSkill(tes3.skill.restoration),
    perks = {
        {
            id = schools.restorationName.."Apprentice",
            name = "Restoration: Apprentice",
            description = "You are now an Apprentice in Restoration. You can now cast the Cleanse spell, which purifies water, and the Stave spells, which stave off sleep, thirst, and hunger.",
            isUnique = true,
            skillReq = { restoration = 25 }
        },
        {
            id = schools.restorationName.."Journeyman",
            name = "Restoration: Journeyman",
            description = "You are now a Journeyman in Restoration. You can now create Restoration spells in the self-Spellmaking menu (B).",
            isUnique = true,
            skillReq = { restoration = 50 }
        },
        {
            id = schools.restorationName.."Expert",
            name = "Restoration: Expert",
            description = "You are now an Expert in Restoration. You can now cast Ritual Spells in the School of Restoration.",
            isUnique = true,
            skillReq = { restoration = 75 }
        },
        {
            id = schools.restorationName.."Master",
            name = "Restoration: Master",
            description = "You are now a Master in Restoration. Casting spells with only Restoration effects cost half the Magicka.",
            isUnique = true,
            skillReq = { restoration = 100 }
        }
    },
    refreshCallback = spells.checkSpells
})