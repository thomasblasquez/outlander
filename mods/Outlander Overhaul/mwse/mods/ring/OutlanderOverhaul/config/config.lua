--#region Common

    local common = require("ring.OutlanderOverhaul.common")
    if not common then return end
    local i18n = common.i18n
    local log = common.log

--#endregion

--#region Requirements

    local defaultConfig = require("ring.OutlanderOverhaul.defaultConfig")
    local interop = require("ring.OutlanderOverhaul.interop")
    local lib = require("ring.lib.main")

    if not defaultConfig then
        log:error("Default Config failed to load!")
        return false
    end
    if not interop then
        log:error("Interop non-functional!")
        return false
    end
    if not lib then
        log:error("Ring's Library non-functional!")
        return false
    end

--#endregion

--#region Variables

    --- Current configuration
    ---@class OutlanderOverhaul.Config.Current : OutlanderOverhaul.Config
    local loadedConfig = mwse.loadConfig("OutlanderOverhaul", defaultConfig)
    log:trace("CONFIG: Loaded MCM configuration:\n\z"..json.encode(loadedConfig))

--#endregion

--#region Functions

    --- Creates the Outlander Overhaul MCM template
    ---@return mwseMCMTemplate
    local function createMCM()
        log:debug("CONFIG: Creating MCM...")
        local mcm = mwse.mcm.createTemplate({
            name = i18n("modName"),
            config = loadedConfig,
            defaultConfig = defaultConfig,
            showDefaultSetting = true,
            onClose = function ()
                interop.refreshPerks()
            end,
        })

        -- Outlander Perks MCM Main Page

            log:debug("CONFIG:   Creating main page...")
            local mainPage = mcm:createSideBarPage{
                label = i18n("mcm.main.label"), showHeader = true, showReset = true,
                description = i18n("mcm.description")

            }
            -- Enable mod
            mainPage:createYesNoButton{
                label = i18n("mcm.enable.label"),
                configKey = "modEnabled",
                restartRequired = true,
                description = i18n("mcm.enable.description")
            }
            -- Enable skill perks
            mainPage:createYesNoButton{
                label = i18n("mcm.perksEnabled.label"),
                configKey = "perksEnabled",
                restartRequired = true,
                description = i18n("mcm.perksEnabled.description")
            }
            -- Enable level perks
            mainPage:createYesNoButton{
                label = i18n("mcm.levelPerksEnabled.label"),
                configKey = "levelPerksEnabled",
                restartRequired = true,
                description = i18n("mcm.levelPerksEnabled.description")
            }

            -- Logging

                local logCategory = mainPage:createCategory{
                    label = i18n("mcm.logCategory.label"),
                    indent = 12
                }
                -- Logging Level
                logCategory:createDropdown{
                    label = i18n("mcm.log.label"),
                    description = i18n("mcm.log.description"),
                    options = {
                        { label = i18n("TRACE"), value = "TRACE"},
                        { label = i18n("DEBUG"), value = "DEBUG"},
                        { label = i18n("INFO"), value = "INFO"},
                        { label = i18n("WARN"), value = "WARN"},
                        { label = i18n("ERROR"), value = "ERROR"},
                        { label = i18n("NONE"), value = "NONE"},
                    },
                    variable = mwse.mcm.createTableVariable{ id = "logLevel", table = loadedConfig },
                    callback = function(self)
                        log:setLevel(self.variable.value)
                    end
                }
                -- Log timestamps
                logCategory:createYesNoButton{
                    label = i18n("mcm.logTimestamp.label"),
                    configKey = "logTimestamp",
                    description = i18n("mcm.logTimestamp.description")
                }
                -- Log to console
                logCategory:createYesNoButton{
                    label = i18n("mcm.logToConsole.label"),
                    configKey = "logToConsole",
                    description = i18n("mcm.logToConsole.description")
                }
     
        -- Interop Page

            log:debug("CONFIG:   Creating Interop page...")
            local interopPage = mcm:createSideBarPage{
                label = i18n("mcm.interopsPage.label"),
                description = i18n("mcm.interopsPage.description")
            }
            local ngcButton = interopPage:createYesNoButton{
                label = i18n("ngc"),
                configKey = "interops.ngc",
                description = i18n("ngc.description")
            }
            if not common.interops.ngc then
                loadedConfig.interops.ngc = false
                ngcButton:disable()
                ngcButton.description = i18n("mcm.interopsPage.notInstalled")
            end
            local buyingGameButton = interopPage:createYesNoButton{
                label = i18n("buyingGame"),
                configKey = "interops.buyingGame",
                description = i18n("buyingGame.description")
            }
            if not common.interops.buyingGame then
                loadedConfig.interops.buyingGame = false
                buyingGameButton:disable()
                buyingGameButton.description = i18n("mcm.interopsPage.notInstalled")
            end
            local silverTongueButton = interopPage:createYesNoButton{
                label = i18n("silverTongue"),
                configKey = "interops.silverTongue",
                description = i18n("silverTongue.description")
            }
            if not common.interops.silverTongue then
                loadedConfig.interops.silverTongue = false
                silverTongueButton:disable()
                silverTongueButton.description = i18n("mcm.interopsPage.notInstalled")
            end
            local ashfallButton = interopPage:createYesNoButton{
                label = i18n("ashfall"),
                configKey = "interops.ashfall",
                description = i18n("ashfall.description")
            }
            if not common.interops.ashfall then
                loadedConfig.interops.ashfall = false
                ashfallButton:disable()
                ashfallButton.description = i18n("mcm.interopsPage.notInstalled")
            end

        -- Skill Pages

            log:debug("CONFIG:   Creating skill module MCM pages...")
            lib.forLoop(loadedConfig.modules, function (skill, options)
                log:trace("CONFIG:     "..skill.." Page:")
                local thisSkillPage = mcm:createSideBarPage{
                    label = i18n(skill),
                    description = i18n("mcm.skills.description", { i18n(skill) })
                }
                lib.forLoop(options, function (key, value)
                    if type(value) == "boolean" then
                        thisSkillPage:createYesNoButton{
                            label = i18n("mcm.skills."..key..".label"),
                            description = i18n("mcm.skills."..key..".description"),
                            configKey = "modules."..skill.."."..key
                        }
                    elseif type(value) == "number" then
                        thisSkillPage:createTextField{
                            label = i18n(key),
                            description = i18n(key),
                            numbersOnly = true,
                            configKey = "modules."..skill.."."..key
                        }
                    else
                        log:trace("CONFIG:       Why is "..key.." a "..type(value).."?")
                    end
                    log:trace("CONFIG:       "..key..": "..tostring(value))
                end)
            end)

        return mcm
    end

    --- Registers MCM and applies current configuration
    local function onModConfigReady()
        -- Update log
            log:setLevel(loadedConfig.logLevel)
            log.includeTimestamp = loadedConfig.logTimestamp
            log.logToConsole = loadedConfig.logToConsole
        -- Outlander Overhaul MCM
        local mcm = createMCM()
        mcm:register()
        mcm:saveOnClose("OutlanderOverhaul", loadedConfig)
        log:debug("CONFIG: MCM ready!")
    end

--#endregion

--#region Events

    event.register(tes3.event.modConfigReady, onModConfigReady)

--#endregion

return loadedConfig