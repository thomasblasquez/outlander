local public = {}

-- Logging
    local logger = require("logging.logger")
    public.log = logger.new{ name = "Outlander Overhaul" }
    if not public.log then
        mwse.log("[OUTLANDER OVERHAUL] ERROR: LOGGER NON-FUNCTIONAL. UPDATE MWSE AND CONTACT CODERING.")
        return false
    end

-- Translation
    public.i18n = mwse.loadTranslations("ring.Outlander.perks")
    if not public.i18n then
        public.log:error("COMMON: Translation non-functional!")
        return false
    end

-- Interops
    public.interops = {}
    public.interops.ngc = include("ngc")
    public.interops.buyingGame = include("buyingGame")
    public.interops.silverTongue = include("silverTongue")
    public.interops.perkSystem = include("KBLib.PerkSystem.perkSystem")
    public.interops.CraftingFramework = include("CraftingFramework")

    if include("mer.ashfall") then
        public.interops.ashfall = {
            interop = require("mer.ashfall.interop"),
            foodConfig = require("mer.ashfall.config.foodConfig"),
            bushcraftingConfig = require("mer.ashfall.bushcrafting.config"),
            common = require ("mer.ashfall.common.common"),
            referenceController = require("mer.ashfall.referenceController")
        }
    end

return public