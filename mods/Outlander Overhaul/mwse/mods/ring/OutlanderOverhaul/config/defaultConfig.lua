--- Configuration for Outlander Perks
---@class OutlanderOverhaul.Config
local defaultConfig = {
    modEnabled = true,
    logLevel = "INFO",
    logTimestamp = false,
    logToConsole = false,
    perksEnabled = true,
    levelPerksEnabled = true,
    modules = {
        block = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        armorer = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        armorSkills = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        magicSchools = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        mercantile = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        speechcraft = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        alchemy = {
            enabled = true,
            gmstFeature = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        athletics = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        enchant = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        security = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        sneak = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        },
        acrobatics = {
            enabled = true,
            apprenticeRequirement = 25,
            journeymanRequirement = 50,
            expertRequirement = 75,
            masterRequirement = 100
        }
    },
    interops = {
        ngc = true,
        buyingGame = true,
        silverTongue = true,
        ashfall = true
    }
}

return defaultConfig