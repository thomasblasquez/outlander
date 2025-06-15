
return{
    --#region Common
        ["OK"] = "OK",
        ["Close"] = "Close",
        ["beginner"] = "Beginner",
        ["novice"] = "Novice",
        ["apprentice"] = "Apprentice",
        ["journeyman"] = "Journeyman",
        ["expert"] = "Expert",
        ["master"] = "Master",
        ["and"] = "and",
    --#endregion
    --#region config
        ["modName"] = "Outlander Overhaul",
        ["mcm.main.label"] = "Main",
        ["mcm.description"] =
            "Outlander Overhaul\n\z
            Mod author: codering\n\z
            \n\z
            An overhaul of several skills and their mechanics. Adds perks, crafting recipes, and new gameplay features.",
        ["mcm.enable.label"] = "Enable Mod",
        ["mcm.enable.description"] = "If no, all mod features are disabled.",
        ["mcm.perksEnabled.label"] = "Skill Perks",
        ["mcm.perksEnabled.description"] = "Turns skill perks on and off. Skill perks are earned when a skill reaches a certain level, as defined in the MCM page for that skill. This will also disable the new gameplay features added by the perks. Does not disable the functionality of perks handled by other mods.",
        ["mcm.levelPerksEnabled.label"] = "Level Perks",
        ["mcm.levelPerksEnabled.description"] = "Turns level perks on and off. Level perks are earned when the player reaches a new character level. This will also disable the new gameplay features added by the perks.",
        --#region Logging
            ["mcm.logCategory.label"] = "Logging",
            ["mcm.log.label"] = "Logging Level",
            ["mcm.log.description"] = "Set the log level.",
            ["mcm.logTimestamp.label"] = "Timestamps",
            ["mcm.logTimestamp.description"] = "If yes, timestamps are added to logs",
            ["mcm.logToConsole.label"] = "Log to console",
            ["mcm.logToConsole.description"] = "If yes, all logs will be displayed in the in-game console",
            --#region Log Levels
                ["TRACE"] = "TRACE",
                ["DEBUG"] = "DEBUG",
                ["INFO"] = "INFO",
                ["WARN"] = "WARN",
                ["ERROR"] = "ERROR",
                ["NONE"] = "NONE",
            --#endregion
        --#endregion
        --#region Interops
            ["mcm.interopsPage.label"] = "Interops",
            ["mcm.interopsPage.description"] = "Enable or disable mod interoperability",
            ["mcm.interopsPage.notInstalled"] = "Mod is not loaded!",
            ["ngc"] = "Next Generation Combat",
            ["ngc.description"] = "Next Generation Combat adds perks for all of the weapon skills. Without it, no weapon perks exist by default.",
            ["buyingGame"] = "Buying Game",
            ["buyingGame.description"] = "Buying Game adds perks for the Mercantile skill. Without it, no Mercantile perks exist by default.",
            ["silverTongue"] = "Silver Tongue",
            ["silverTongue.description"] = "Silver Tongue adds perks for the Speechcraft skill. Without it, no Speechcraft perks exist by default.",
            ["ashfall"] = "Ashfall",
            ["ashfall.description"] = "Ashfall is required for most crafting recipes added by Outlander Overhaul. Without Ashfall, all crafting recipes are inaccessible.",
        --#endregion
        --#region Skills
            ["mcm.skills.description"] = "Perk settings for %s",
            ["mcm.skills.enabled.label"] = "Enable Module",
            ["mcm.skills.enabled.description"] = "Enable this module.",
            ["mcm.skills.gmstFeature.label"] = "Enable GMST changes",
            ["mcm.skills.gmstFeature.description"] = "Enable the GMST changes for this module.",
            ["apprenticeRequirement"] = "Apprentice Perk skill requirement",
            ["journeymanRequirement"] = "Journeyman Perk skill requirement",
            ["expertRequirement"] = "Expert Perk skill requirement",
            ["masterRequirement"] = "Master Perk skill requirement",
            ["alchemy.gmst"] = "fWortChanceValue",
            ["block"] = "Block",
            ["armorer"] = "Armorer",
            ["armorSkills"] = "Armor",
            ["magicSchools"] = "Magic",
            ["mercantile"] = "Mercantile",
            ["speechcraft"] = "Speechcraft",
            ["alchemy"] = "Alchemy",
            ["athletics"] = "Athletics",
            ["enchant"] = "Enchant",
            ["security"] = "Security",
            ["sneak"] = "Sneak",
            ["acrobatics"] = "Acrobatics",
        --#endregion
    --#endregion
    --#region perks
        ["perks.initialMessage.base"] = "You start with the following perks:\n",
        ["perks.initialMessage.end"] = "\n\n Click on a skill name in your stats menu to see its perks!",
        ["perks.noPerksMessage"] = "No perks for ",
        ["perks.literal"] = "Perks",
        ["perks.requirements"] = "\n\nRequirements:",
        ["perks.unlocked"] = "PERK UNLOCKED!",
        ["perks.locked"] = "Perk locked!",
    --#endregion
    --#region Acrobatics
        ["descriptions.acrobatics.apprentice"] = "You are now an Apprentice in Acrobatics. You may now parkour up walls and ledges by jumping near them midair.",
        ["descriptions.acrobatics.journeyman"] = "You are now an Expert in Acrobatics. While mid-jump, you are much harder to hit.",
        ["descriptions.acrobatics.expert"] = "You are now a Journeyman in Acrobatics. If you land on an enemy from a tall height, they will take your full fall damage while you take only half. You also have a chance to knock them down depending on your weight and encumbrance.",
        ["descriptions.acrobatics.master"] = "You are now a Master in Acrobatics. You may now perform a mid-air dash by crouching while in the air.",
    --#endregion
    --#region Alchemy

        ["descriptions.alchemy.apprentice"] = "You are now an Apprentice in the art of Alchemy. You now know the second effect on all ingredients and can equip potions as a throwing weapon by holding Alt while equipping them. The potion effect is applied to any target hit.",
        ["descriptions.alchemy.journeyman"] = "You are now a Journeyman in the art of Alchemy. You now know the third effect on all ingredients. You may now use Journeyman level apparatus",
        ["descriptions.alchemy.expert"] = "You are now an Expert in the art of Alchemy. You have memorized every effect of every ingredient. You may now use Master level apparatus",
        ["descriptions.alchemy.master"] = "You are now a Master in the art of Alchemy. You may now use Grandmaster and Secret Master level apparati.",

    --#endregion
    --#region Armor 
        ["messages.armor.allEquipped"] = "%s Set Bonus!",
        ["messages.armor.lostSetBonus"] = "Set Bonuses lost!",
        --#region Light Armor
            ["descriptions.armor.light.apprentice"] = "You are now an Apprentice with Light Armor. Your armor rating is increased by 25% when wearing all light armor.",
            ["descriptions.armor.light.journeyman"] = "You are now a Journeyman with Light Armor. Equipped Light Armor weighs nothing when wearing all light armor.",
            ["descriptions.armor.light.expert"] = "You are now an Expert with Light Armor. Your armor rating is increased by 50% when wearing all light armor.",
            ["descriptions.armor.light.master"] = "You are now a Master with Light Armor. You have a 10% chance to dodge all attacks while wearing all light armor.",
            ["armorSpellName.light"] = "Light Armor: Journeyman",
            ["messages.lightArmor.master"] = "Master Dodge!",
        --#endregion
        --#region Medium Armor
            ["descriptions.armor.medium.apprentice"] = "You are now an Apprentice with Medium Armor. Your armor rating is increased by 25% when wearing all medium armor.",
            ["descriptions.armor.medium.journeyman"] = "You are now a Journeyman with Medium Armor. Stamina regenerates 50% faster when wearing all medium armor.",
            ["descriptions.armor.medium.expert"] = "You are now an Expert with Medium Armor. Equipped Medium Armor weighs nothing when wearing all medium armor.",
            ["descriptions.armor.medium.master"] = "You are now a Master with Medium Armor. You have a 10% chance to reflect back melee attacks while wearing all medium armor.",
            ["armorSpellName.medium"] = "Medium Armor: Expert",
            ["messages.mediumArmor.master"] = "Master Reflect!",
        --#endregion
        --#region Heavy Armor
            ["descriptions.armor.heavy.apprentice"] = "You are now an Apprentice with Heavy Armor. You can now Bull Rush by running into enemies while wearing all heavy armor, stunning them. Bull Rush only works once every 10 seconds and only affects enemies who have a lower armor rating than you and are in combat.",
            ["descriptions.armor.heavy.journeyman"] = "You are now a Journeyman with Heavy Armor. You now have a 50% chance to avoid being staggered when damaged and wearing all heavy armor.",
            ["descriptions.armor.heavy.expert"] = "You are now an Expert with Heavy Armor. Your armor rating is increased by 25% when wearing all heavy armor.",
            ["descriptions.armor.heavy.master"] = "You are now a Master with Heavy Armor. Equipped Heavy Armor weighs nothing when wearing all heavy armor.",
            ["armorSpellName.heavy"] = "Heavy Armor: Master",
            ["messages.heavyArmor.apprentice.activated"] = "Bull Rush!",
            ["messages.heavyArmor.apprentice.failed"] = "%s is too well armored to be Bull Rushed!",
            ["messages.heavyArmor.apprentice.ready"] = "Bull Rush ready!",
        --#endregion
        --#region Unarmored
            ["descriptions.armor.unarmored.apprentice"] = "You are now an Apprentice with Unarmored. Your stamina and magicka regenerate 50% faster when not wearing any armor. You may still use a shield/Onion items and receive the benefits of Unarmored Perks.",
            ["descriptions.armor.unarmored.journeyman"] = "You are now a Journeyman with Unarmored. Hitting opponents with a higher armor rating than you is 10% easier, and those same opponents will find it 10% harder to hit you.",
            ["descriptions.armor.unarmored.expert"] = "You are now an Expert with Unarmored. You now mitigate 25% of all incoming damage while not wearing any armor.",
            ["descriptions.armor.unarmored.master"] = "You are now a Master with Unarmored. While wearing a robe or a skirt, you can slowfall by holding the jump key while not wearing any armor.",
            ["messages.unarmored.master"] = "Your %s catches the wind, slowing your fall!",
        --#endregion
    --#endregion
    --#region Armorer
        ["descriptions.armorer.apprentice"] = "You are now an Apprentice in Armorer.\nMitigate (10%): Chance to ignore damage to your equipment condition.",
        ["descriptions.armorer.journeyman"] = " You are now a Journeyman in Armorer.\nMitigate (25%): Chance to ignore damage to your equipment condition.\nWeapon Tempering (2pts): Fortify Attack when using a weapon you have repaired to full.",
        ["descriptions.armorer.expert"] = "You are now an Expert in Armorer.\nMitigate (50%): Chance to ignore damage to your equipment condition.\nWeapon Tempering (5pts): Fortify Attack when using a weapon you have repaired to full.\nArmor Polish (1pt per slot): Spell Reflect when wearing armor you have repaired to full.",
        ["descriptions.armorer.master"] = "You are now a Master in Armorer.\nMitigate (75%): Chance to ignore damage to your equipment condition.\nWeapon Tempering (10pts): Fortify Attack when using a weapon you have repaired to full.\nArmor Polish (2pts per slot): Spell Reflect when wearing armor you have repaired to full.\nDisintegrate: Attacks with Tempered weapons also deal double damage to target's armor condition.",
        ["messages.armorer.mitigated"] = "Equipment condition damage mitigated!",
        ["messages.armorer.noHeat"] = "%s needs to be treated with heat before it can be repaired further.",
        ["messages.armorer.lowHeat"] = "%s is not hot enough to treat armor or weapons.",
        ["messages.armorer.upgrades.temper"] = "Tempered",
        ["messages.armorer.upgrades.reflect"] = "Reflective",
        ["messages.armorer.postRepair"] = {
            one = "%{name} is now %{upgrade}!",
            other = "%{name} are now %{upgrade}!"
        },
        ["tooltips.armorer.tempered"] = "Tempered",
        ["tooltips.armorer.reflective"] = "Reflective",
    --#endregion
    --#region Athletics
        ["descriptions.athletics.apprentice"] = "",
        ["descriptions.athletics.journeyman"] = "",
        ["descriptions.athletics.expert"] = "",
        ["descriptions.athletics.master"] = "",
    --#endregion
    --#region Block
        ["descriptions.block.apprentice"] = "",
        ["descriptions.block.journeyman"] = "",
        ["descriptions.block.expert"] = "",
        ["descriptions.block.master"] = "",
    --#endregion
    --#region Enchant
        ["descriptions.enchant.apprentice"] = "",
        ["descriptions.enchant.journeyman"] = "",
        ["descriptions.enchant.expert"] = "",
        ["descriptions.enchant.master"] = "",
    --#endregion
    --#region Magic
        --#region Destruction
            ["descriptions.magic.destruction.apprentice"] = "",
            ["descriptions.magic.destruction.journeyman"] = "",
            ["descriptions.magic.destruction.expert"] = "",
            ["descriptions.magic.destruction.master"] = "",
        --#endregion
        --#region Alteration
            ["descriptions.magic.alteration.apprentice"] = "",
            ["descriptions.magic.alteration.journeyman"] = "",
            ["descriptions.magic.alteration.expert"] = "",
            ["descriptions.magic.alteration.master"] = "",
        --#endregion
        --#region Illusion
            ["descriptions.magic.illusion.apprentice"] = "",
            ["descriptions.magic.illusion.journeyman"] = "",
            ["descriptions.magic.illusion.expert"] = "",
            ["descriptions.magic.illusion.master"] = "",
        --#endregion
        --#region Mysticism
            ["descriptions.magic.mysticism.apprentice"] = "",
            ["descriptions.magic.mysticism.journeyman"] = "",
            ["descriptions.magic.mysticism.expert"] = "",
            ["descriptions.magic.mysticism.master"] = "",
        --#endregion
        --#region Restoration
            ["descriptions.magic.restoration.apprentice"] = "",
            ["descriptions.magic.restoration.journeyman"] = "",
            ["descriptions.magic.restoration.expert"] = "",
            ["descriptions.magic.restoration.master"] = "",
        --#endregion
        --#region Conjuration
            ["descriptions.magic.conjuration.apprentice"] = "",
            ["descriptions.magic.conjuration.journeyman"] = "",
            ["descriptions.magic.conjuration.expert"] = "",
            ["descriptions.magic.conjuration.master"] = "",
        --#endregion
    --#endregion
    --#region Mercantile
        ["descriptions.mercantile.apprentice"] = "",
        ["descriptions.mercantile.journeyman"] = "",
        ["descriptions.mercantile.expert"] = "",
        ["descriptions.mercantile.master"] = "",
    --#endregion
    --#region Security
        ["descriptions.security.apprentice"] = "",
        ["descriptions.security.journeyman"] = "",
        ["descriptions.security.expert"] = "",
        ["descriptions.security.master"] = "",
    --#endregion
    --#region Sneak
        ["descriptions.sneak.apprentice"] = "",
        ["descriptions.sneak.journeyman"] = "",
        ["descriptions.sneak.expert"] = "",
        ["descriptions.sneak.master"] = "",
    --#endregion
    --#region Speechcraft
        ["descriptions.speechcraft.apprentice"] = "",
        ["descriptions.speechcraft.journeyman"] = "",
        ["descriptions.speechcraft.expert"] = "",
        ["descriptions.speechcraft.master"] = "",
    --#endregion
    --#region Weapons
        --#region Axe
            ["descriptions.weapon.axe.apprentice"] = "",
            ["descriptions.weapon.axe.journeyman"] = "",
            ["descriptions.weapon.axe.expert"] = "",
            ["descriptions.weapon.axe.master"] = "",
        --#endregion
        --#region Blunt
            ["descriptions.weapon.blunt.apprentice"] = "",
            ["descriptions.weapon.blunt.journeyman"] = "",
            ["descriptions.weapon.blunt.expert"] = "",
            ["descriptions.weapon.blunt.master"] = "",
        --#endregion
        --#region Long Blade
            ["descriptions.weapon.longBlade.apprentice"] = "",
            ["descriptions.weapon.longBlade.journeyman"] = "",
            ["descriptions.weapon.longBlade.expert"] = "",
            ["descriptions.weapon.longBlade.master"] = "",
        --#endregion
        --#region Marksman
            ["descriptions.weapon.marksman.apprentice"] = "",
            ["descriptions.weapon.marksman.journeyman"] = "",
            ["descriptions.weapon.marksman.expert"] = "",
            ["descriptions.weapon.marksman.master"] = "",
        --#endregion
        --#region Short Blade
            ["descriptions.weapon.shortBlade.apprentice"] = "",
            ["descriptions.weapon.shortBlade.journeyman"] = "",
            ["descriptions.weapon.shortBlade.expert"] = "",
            ["descriptions.weapon.shortBlade.master"] = "",
        --#endregion
        --#region Spear
            ["descriptions.weapon.spear.apprentice"] = "",
            ["descriptions.weapon.spear.journeyman"] = "",
            ["descriptions.weapon.spear.expert"] = "",
            ["descriptions.weapon.spear.master"] = "",
        --#endregion
        --#region handToHand
            ["descriptions.weapon.handToHand.apprentice"] = "",
            ["descriptions.weapon.handToHand.journeyman"] = "",
            ["descriptions.weapon.handToHand.expert"] = "",
            ["descriptions.weapon.handToHand.master"] = "",
        --#endregion
    --#endregion
}