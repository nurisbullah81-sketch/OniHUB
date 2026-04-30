-- [[ ==========================================
--      MODULE: FPS BOOSTER (LAG FREE VERSION)
--    ========================================== ]]

local Workspace    = game:GetService("Workspace")
local Lighting     = game:GetService("Lighting")
local Players      = game:GetService("Players")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI

local UI = _G.Cat.UI

-- ==========================================
-- TAB & UI
-- ==========================================
local MiscPage = UI.CreateTab("Misc", false)
UI.CreateSection(MiscPage, "FPS OPTIMIZER")

local StateBoost = false

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Backup Settings
local OrigLighting = { Shadows = Lighting.GlobalShadows, Fog = Lighting.FogEnd }
local OrigTerrain = {}
if Terrain then
    pcall(function() OrigTerrain.Deco = Terrain.Decoration end)
    pcall(function() OrigTerrain.Wave = Terrain.WaterWaveSize end)
    pcall(function() OrigTerrain.Speed = Terrain.WaterWaveSpeed end)
    pcall(function() OrigTerrain.Reflect = Terrain.WaterReflectance end)
end

-- ==========================================
-- LOGIC: PURE GRAPHICS TWEAK (No Map Scan)
-- ==========================================
local function ApplyBoost()
    -- 1. Lighting (Hilangin bayangan & kabut)
    Lighting.FogEnd = 100000 
    Lighting.GlobalShadows = false
    Lighting.Brightness = 2 -- Biar terang tanpa shadow
    
    -- 2. Terrain (Bikin flat)
    if Terrain then
        pcall(function() Terrain.Decoration = false end)
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
    end
    
    -- 3. Streaming (Beban Memory)
    pcall(function() Workspace.StreamingIntegrityEnabled = false end)
    
    warn("[CatHUB] Graphics Boost Active!")
end

local function RestoreNormal()
    Lighting.GlobalShadows = OrigLighting.Shadows
    Lighting.FogEnd = OrigLighting.Fog 
    
    if Terrain then
        pcall(function() Terrain.Decoration = OrigTerrain.Deco end)
        pcall(function() Terrain.WaterWaveSize = OrigTerrain.Wave end)
        pcall(function() Terrain.WaterWaveSpeed = OrigTerrain.Speed end)
        pcall(function() Terrain.WaterReflectance = OrigTerrain.Reflect end)
    end
end

-- // TOGGLE
UI.CreateToggle(MiscPage, "Boost Graphics", "Optimize lighting & terrain (Stable)", StateBoost, function(state)
    StateBoost = state
    if state then ApplyBoost() else RestoreNormal() end
end)