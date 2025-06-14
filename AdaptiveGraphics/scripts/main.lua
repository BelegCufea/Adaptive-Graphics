local UEHelpers = require('UEHelpers')
local config = require('AG_config')
local engine = FindFirstOf('Engine')
local GetKismetSystemLibrary = UEHelpers.GetKismetSystemLibrary
local ksl = GetKismetSystemLibrary()
local myViewPort

-- Build reverse lookup table: 0 -> "WORLD", etc.
local locationNames = {}
for k, v in pairs(Locations) do
	locationNames[v] = k
end

-- Helper function to execute console commands
---@param cmd string
local function execCommand(cmd)
	ksl:ExecuteConsoleCommand(engine, cmd, nil, 0)
end

-- Logs debug messages based on global debug level and message severity
---@param category string   -- Category label for grouping messages
---@param message  string   -- Message to print
---@param severity number   -- One of DebugLevels.ERROR, INFO, etc.
local function debugConsole(category, message, severity)
	-- Default to INFO if nil or invalid level passed
	if type(severity) ~= "number" then
		severity = DebugLevels.INFO
	end

	if not message then
		message = category
		category = "Misc"
	end

	-- Find the label corresponding to the numeric level (e.g., 2 -> "ERROR")
	local label = "INFO"
	for name, val in pairs(DebugLevels) do
		if val == severity then
			label = name
			break
		end
	end

	-- Only print if our global `debug` threshold allows it
	if config.debugLevel and config.debugLevel >= severity then
		print(string.format(
			"[Adaptive Graphics] [%s] [%s] %s\n",
			label,
			category or "N/A",
			message or "N/A"
		))
	end
end

-- Returns the appropriate config table based on location
---@param location number
---@return table
local function getConfig(location)
	if type(location) ~= "number" or not config[location] then
		return config[Locations.WORLD] ---@type table
	end
	return config[location] ---@type table
end

-- Sets Lumen-related rendering features based on location config
---@param location number
local function setLumen(location)
	debugConsole("Lumen", "setting...", DebugLevels.INFO)
	local cfg = getConfig(location)

	if cfg.enableLumen ~= nil then
		execCommand("r.DynamicGlobalIlluminationMethod " .. cfg.enableLumen)
		execCommand("r.Lumen.DiffuseIndirect.Allow " .. cfg.enableLumen)
	end
	if cfg.hardwareLumen ~= nil then
		execCommand("r.Lumen.HardwareRayTracing " .. cfg.hardwareLumen)
		if cfg.hardwareLumenQuality then
			execCommand("r.Lumen.HardwareRayTracing.LightingMode " .. cfg.hardwareLumenQuality)
		end
	end
	if cfg.enableDFAO ~= nil then
		if cfg.enableDFAO==1 then
			debugConsole("Lumen", "dfao enabled", DebugLevels.INFO)
			execCommand("r.DistanceFieldAO 1")
			execCommand("r.AOHistoryDistanceThreshold 400")
			execCommand("r.AOHistoryWeight 0.9")
			execCommand("r.AOSpecularOcclusionMode 0")
			execCommand("sg.GlobalIlluminationQuality 3")
		end
		if cfg.enableDFAO==0 then
			debugConsole("Lumen", "dfao disabled", DebugLevels.INFO)
			execCommand("r.DistanceFieldAO 0")
			execCommand("r.AOHistoryDistanceThreshold 30")
			execCommand("r.AOHistoryWeight 0.85")
			execCommand("r.AOSpecularOcclusionMode 1")
			if cfg.GlobalIlluminationQuality ~= nil then
				execCommand("sg.GlobalIlluminationQuality " .. cfg.GlobalIlluminationQuality)
			end
		end
	end
end

-- Applies scalability (quality) settings based on the environment
---@param location number
local function setScalability(location)
	debugConsole("Scalability", "setting...", DebugLevels.INFO)
	local cfg = getConfig(location)
	local scalabilitySettings = {
		{ key = "frameRateCap", cmd = "t.MaxFPS" },
		{ key = "GlobalIlluminationQuality", cmd = "sg.GlobalIlluminationQuality", condition = function(cfg) return cfg.enableDFAO == 0 end },
		{ key = "FoliageQuality", cmd = "sg.FoliageQuality" },
		{ key = "ShadowQuality", cmd = "sg.ShadowQuality" },
		{ key = "TextureQuality", cmd = "sg.TextureQuality" },
		{ key = "ViewDistanceQuality", cmd = "sg.ViewDistanceQuality" },
		{ key = "PostProcessQuality", cmd = "sg.PostProcessQuality" },
		{ key = "EffectsQuality", cmd = "sg.EffectsQuality" },
		{ key = "SkylightIntensity", cmd = "r.SkylightIntensityMultiplier" },
	}

	for _, s in ipairs(scalabilitySettings) do
		if cfg[s.key] ~= nil and (s.condition == nil or s.condition(cfg)) then
			execCommand(s.cmd .. " " .. cfg[s.key])
		end
	end

end

-- Applies upscaling settings (DLSS, FSR, XeSS) based on the environment
---@param location number
local function setUpscaling(location)
	debugConsole("Upscaling", "setting...", DebugLevels.INFO)
	local cfg = getConfig(location)

	if cfg.EnableDLSS==1 then
		execCommand("Altar.DLSS.Enabled 1")
		execCommand("Altar.DLSS.FG.Enabled " .. cfg.DLSSFrameGen)
		execCommand("Altar.DLSS.Quality " .. cfg.DLSSQuality)
	elseif cfg.EnableFSR==1 then
		execCommand("Altar.FSR3.Enabled 1")
		execCommand("Altar.FSR3.FI.Enabled " .. cfg.FSRFrameGen)
		execCommand("Altar.FSR3.Quality " .. cfg.FSRQuality)
	elseif cfg.EnableXeSS==1 then
		execCommand("Altar.XeSS.Enabled 1")
		execCommand("Altar.XeSS.Quality " .. cfg.XeSSQuality)
	end
end

-- Executes custom console commands defined in config
---@param location number
local function setCustomCommands(location)
	local cfg = getConfig(location)

	if cfg.customCommands and #cfg.customCommands > 0 then
		debugConsole("Custom commands", "excecutig...", DebugLevels.INFO)
		for _, command in ipairs(cfg.customCommands) do
			debugConsole("Custom commands", " " .. command, DebugLevels.INFO)
			execCommand(command)
		end
	end
end

-- Calls all relevant config application functions (scalability, lumen, upscaling, custom commands)
---@param location number
local function setSettings(location)
	setScalability(location)
	setLumen(location)
	if config.upscalingSettings==1 then
		setUpscaling(location)
	end
	setCustomCommands(location)
end

-- Attempts to retrieve the current World name from the viewport
---@return string|nil
local function getWorldname()
	-- Ensure we have a valid ViewportClient
	if not myViewPort or not myViewPort:IsValid() then
		debugConsole("ViewPort", "Retrying FindFirstOf fallback", DebugLevels.FORCED)
		myViewPort = FindFirstOf("AltarCommonGameViewportClient")
	end

	-- Bail out early if still not found
	if not myViewPort or not myViewPort:IsValid() then
		debugConsole("ViewPort", "ViewPort NOT FOUND or invalid - aborting", DebugLevels.ERROR)
		return nil
	end

	-- Check World object
	local world = myViewPort.World
	if not world or not world:IsValid() then
		debugConsole("World", "World NOT FOUND or invalid - aborting", DebugLevels.ERROR)
		return nil
	end

	-- Get world name
	local worldName = world:GetFullName()
	if not worldName then
		debugConsole("World", "World name NOT FOUND - aborting", DebugLevels.ERROR)
		return nil
	end

	return worldName ---@type string
end

NotifyOnNewObject("/Script/Altar.AltarCommonGameViewportClient", function(viewPort)
	debugConsole("viewPort", "assigned via notify", DebugLevels.FORCED)
	myViewPort = viewPort
end)

RegisterHook("/Script/Altar.VLevelChangeData:OnFadeToGameBeginEventReceived", function(context)
	local worldName = getWorldname()
	if not worldName then return end

	debugConsole("Location", "World name: " .. worldName, DebugLevels.INFO)

	-- Determine location based on worldName content
	local location
	if worldName:find("World/L_Tamriel") or worldName:find("World/L_SEWorld") then
		location = Locations.WORLD
	elseif worldName:find("World/L_Oblivion") then
		location = Locations.OBLIVION
	elseif worldName:find("World/") then
		location = Locations.CITY
	else
		location = Locations.INDOOR
	end

	-- Get readable name for log
	local locationName = locationNames[location] or "UNKNOWN"

	-- Log and apply settings
	debugConsole("Location", "Location resolved as: " .. locationName, DebugLevels.INFO)
	setSettings(location)

end)
