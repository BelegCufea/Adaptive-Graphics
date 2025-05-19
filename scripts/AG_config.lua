local _ = require('AG_shared')
-------------------
--GLOBAL SETTINGS--
-------------------

local cfg = {
	upscalingSettings = 1, -- If set to 0, in game upscaling settings will be used. If set to 1, below settings will be used.
	debugLevel        = DebugLevels.ERROR
}

-- Comment out settings by putting -- before them to use in game settings
------------------
--WORLD SETTINGS--
-----------------=

cfg[Locations.WORLD] = {

	enableLumen       = 1,
	hardwareLumen     = 0,
	enableDFAO        = 1,
	skylightIntensity = 0.8, -- if DFAO is too dark for your taste, raise this slightly, to 1.2 for example.

	hardwareLumenQuality      = Quality.LOW,
	GlobalIlluminationQuality = Quality.HIGH,
	EffectsQuality            = Quality.HIGH,
	FoliageQuality            = Quality.HIGH,
	ShadowQuality             = Quality.HIGH,
	TextureQuality            = Quality.HIGH,
	ViewDistanceQuality       = Quality.HIGH,
	PostProcessQuality        = Quality.HIGH,

	frameRateCap = 0, -- 0 = uncapped

	EnableDLSS   = 1,
	DLSSQuality  = 5, -- 2: DLAA, 4: Quality, 5: Balanced, 6: performance, 7: Ultra performance
	DLSSFrameGen = 1,

	EnableFSR    = 0,
	FSRQuality   = 0, -- 0: Native AA, 1: Quality, 2: Balanced, 3: performance
	FSRFrameGen  = 0,

	EnableXeSS   = 0,
	XeSSQuality  = 7 -- 3: Ultra Performance, 2: Performance, 3: Balanced, 4: Quality, 5: Ultra quality, 6: Ultra quality+ 7: XeSS AA
}

-------------------
--INDOOR SETTINGS--
-------------------

cfg[Locations.INDOOR] = {

	enableLumen       = 1,
	hardwareLumen     = 1,
	enableDFAO        = 1,
	skylightIntensity = 1.2, -- if DFAO is too dark for your taste, raise this slightly, to 1.2 for example.

	hardwareLumenQuality      = Quality.ULTRA,
	GlobalIlluminationQuality = Quality.ULTRA,
	EffectsQuality            = Quality.ULTRA,
	FoliageQuality            = Quality.ULTRA,
	ShadowQuality             = Quality.ULTRA,
	TextureQuality            = Quality.ULTRA,
	ViewDistanceQuality       = Quality.ULTRA,
	PostProcessQuality        = Quality.ULTRA,

	frameRateCap = 0, -- 0 = uncapped

	EnableDLSS   = 1,
	DLSSQuality  = 2, -- 2: DLAA, 4: Quality, 5: Balanced, 6: performance, 7: Ultra performance
	DLSSFrameGen = 1,

	EnableFSR    = 0,
	FSRQuality   = 0, -- 0: Native AA, 1: Quality, 2: Balanced, 3: performance
	FSRFrameGen  = 0,

	EnableXeSS   = 0,
	XeSSQuality  = 7 -- 3: Ultra Performance, 2: Performance, 3: Balanced, 4: Quality, 5: Ultra quality, 6: Ultra quality+ 7: XeSS AA
}

-----------------
--CITY SETTINGS--
-----------------

cfg[Locations.CITY] = {

	enableLumen       = 1,
	hardwareLumen     = 0,
	enableDFAO        = 1,
	skylightIntensity = 0.8, -- if DFAO is too dark for your taste, raise this slightly, to 1.2 for example.

	hardwareLumenQuality      = Quality.LOW,
	GlobalIlluminationQuality = Quality.HIGH,
	EffectsQuality            = Quality.HIGH,
	FoliageQuality            = Quality.HIGH,
	ShadowQuality             = Quality.HIGH,
	TextureQuality            = Quality.HIGH,
	ViewDistanceQuality       = Quality.HIGH,
	PostProcessQuality        = Quality.HIGH,

	frameRateCap = 0, -- 0 = uncapped

	EnableDLSS   = 1,
	DLSSQuality  = 4, -- 2: DLAA, 4: Quality, 5: Balanced, 6: performance, 7: Ultra performance
	DLSSFrameGen = 1,

	EnableFSR    = 0,
	FSRQuality   = 0, -- 0: Native AA, 1: Quality, 2: Balanced, 3: performance
	FSRFrameGen  = 0,

	EnableXeSS   = 0,
	XeSSQuality  = 7 -- 3: Ultra Performance, 2: Performance, 3: Balanced, 4: Quality, 5: Ultra quality, 6: Ultra quality+ 7: XeSS AA
}

---------------------
--OBLIVION SETTINGS--
---------------------

cfg[Locations.OBLIVION] = {

	enableLumen       = 1,
	hardwareLumen     = 1,
	enableDFAO        = 1,
	skylightIntensity = 0.8, -- if DFAO is too dark for your taste, raise this slightly, to 1.2 for example.

	hardwareLumenQuality      = Quality.HIGH,
	GlobalIlluminationQuality = Quality.HIGH,
	EffectsQuality            = Quality.HIGH,
	FoliageQuality            = Quality.HIGH,
	ShadowQuality             = Quality.HIGH,
	TextureQuality            = Quality.HIGH,
	ViewDistanceQuality       = Quality.HIGH,
	PostProcessQuality        = Quality.HIGH,

	frameRateCap = 0, -- 0 = uncapped

	EnableDLSS   = 1,
	DLSSQuality  = 2, -- 2: DLAA, 4: Quality, 5: Balanced, 6: performance, 7: Ultra performance
	DLSSFrameGen = 1,

	EnableFSR    = 0,
	FSRQuality   = 0, -- 0: Native AA, 1: Quality, 2: Balanced, 3: performance
	FSRFrameGen  = 0,

	EnableXeSS   = 0,
	XeSSQuality  = 7 -- 3: Ultra Performance, 2: Performance, 3: Balanced, 4: Quality, 5: Ultra quality, 6: Ultra quality+ 7: XeSS AA
}


-------------------
--CUSTOM COMMANDS--
-------------------

--[[
--------------------------------------------------------------------------------------------------------------------------------------------------------------
Here you can set any commands to run on indoors and outdoors
The command should be in the following format: "command value"
For multiple commands, you need to put a comma at the end of each command

	For example, if you wanted to change texture pool size, and change brightness, it should look like this
 	cfg[Locations.INDOOR].customCommands = {
		"r.Streaming.PoolSize 1000",
		"Altar.GraphicsOptions.Brightness -3"
	}
	cfg[Locations.WORLD].customCommands = {
		"r.Streaming.PoolSize 600",
		"Altar.GraphicsOptions.Brightness 1"
	}
--------------------------------------------------------------------------------------------------------------------------------------------------------------]]

return cfg