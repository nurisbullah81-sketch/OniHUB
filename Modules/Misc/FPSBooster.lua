-- [[ ==========================================
--      MODULE: FPS BOOSTER (ZERO GC SPIKE EDITION)
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

local StateMed  = false
local StateHigh = false
local StateExt  = false

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Backup Settings
local OrigLighting = { Shadows = Lighting.GlobalShadows }
local OrigTerrain = {}
if Terrain then
    pcall(function() OrigTerrain.Deco = Terrain.Decoration end)
    pcall(function() OrigTerrain.Wave = Terrain.WaterWaveSize end)
    pcall(function() OrigTerrain.Speed = Terrain.WaterWaveSpeed end)
    pcall(function() OrigTerrain.Reflect = Terrain.WaterReflectance end)
end

pcall(function() Workspace.StreamingIntegrityEnabled = false end)

-- ==========================================
-- LOGIC: ONE-SHOT SWEEP (Anti Lag Loop)
-- ==========================================
local function SweepClean(level)
    -- 1. Environment (Instant)
    Lighting.FogEnd = 9e9 
    Lighting.GlobalShadows = false
    
    if Terrain then
        pcall(function() Terrain.Decoration = false end)
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
    end

    -- 2. Async Cleaner (Berjalan pelan di background tanpa nge-freeze)
    task.spawn(function()
        -- Ambil data SEKALI. Jangan pernah loop GetDescendants!
        local objs = Workspace:GetDescendants()
        
        for i, obj in ipairs(objs) do
            -- Jeda setiap 50 object biar FPS tetap 60
            if i % 50 == 0 then task.wait() end 
            
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("BasePart") then
                if obj.Anchored then
                    obj.CanTouch = false
                    obj.CanQuery = false
                end
                if level == "High" or level == "Extreme" then
                    obj.CastShadow = false
                end
                if level == "Extreme" then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                end
            elseif (obj:IsA("Decal") or obj:IsA("Texture")) and level == "Extreme" then
                obj.Transparency = 1
            end
        end
        warn("[CatHUB] FPS Sweep Complete!")
    end)
end

local function RestoreNormal()
    Lighting.GlobalShadows = OrigLighting.Shadows
    Lighting.FogEnd = 2000 
    
    if Terrain then
        pcall(function() Terrain.Decoration = OrigTerrain.Deco end)
        pcall(function() Terrain.WaterWaveSize = OrigTerrain.Wave end)
        pcall(function() Terrain.WaterWaveSpeed = OrigTerrain.Speed end)
        pcall(function() Terrain.WaterReflectance = OrigTerrain.Reflect end)
    end
end

-- // TOGGLES
UI.CreateToggle(MiscPage, "Medium Boost", "Clean once (Stable)", StateMed, function(state)
    StateMed = state
    if state then SweepClean("Medium") else RestoreNormal() end
end)

UI.CreateToggle(MiscPage, "High Boost", "Clean once (High)", StateHigh, function(state)
    StateHigh = state
    if state then SweepClean("High") else RestoreNormal() end
end)

UI.CreateToggle(MiscPage, "Extreme Boost", "Clean once (Max)", StateExt, function(state)
    StateExt = state
    if state then SweepClean("Extreme") else RestoreNormal() end
end)