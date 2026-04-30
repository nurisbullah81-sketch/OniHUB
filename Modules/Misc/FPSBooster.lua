-- [[ ==========================================
--      MODULE: FPS BOOSTER & GAME SETTINGS (V11)
--      Status: 1000% Anti-Crash, 0% GC Spike
--    ========================================== ]]

local Workspace    = game:GetService("Workspace")
local Lighting     = game:GetService("Lighting")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local SoundService = game:GetService("SoundService")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI

local UI = _G.Cat.UI

-- ==========================================
-- TAB 1: MISC (FPS OPTIMIZER)
-- ==========================================
local MiscPage = UI.CreateTab("Misc", false)
UI.CreateSection(MiscPage, "FPS OPTIMIZER (PILIH SALAH SATU)")

local StateMed  = false
local StateHigh = false
local StateExt  = false

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- // FIX MUTLAK: SEMUA BACKUP HARUS DI-PCALL BIAR KAGA CRASH!
local OrigLighting = { Shadows = Lighting.GlobalShadows }
local OrigTerrain = {}

if Terrain then
    pcall(function() OrigTerrain.Deco = Terrain.Decoration end)
    pcall(function() OrigTerrain.Wave = Terrain.WaterWaveSize end)
    pcall(function() OrigTerrain.Speed = Terrain.WaterWaveSpeed end)
    pcall(function() OrigTerrain.Reflect = Terrain.WaterReflectance end)
end

pcall(function() Workspace.StreamingIntegrityEnabled = false end)

local currentMode = "None"
local boostThread = nil 

local function ApplyBoost(level)
    currentMode = level
    
    Lighting.FogEnd = 9e9 
    Lighting.GlobalShadows = false
    
    if Terrain then
        pcall(function() Terrain.Decoration = false end)
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
    end

    if boostThread then task.cancel(boostThread) end

    boostThread = task.spawn(function()
        local count = 0
        local descs = Workspace:GetDescendants()
        
        for i = 1, #descs do
            local obj = descs[i]
            
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("BasePart") then
                if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
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
            
            count = count + 1
            if count >= 1000 then 
                count = 0
                task.wait()
            end
        end
        warn("[CatHUB] FPS Boost " .. level .. " Berhasil Dieksekusi!")
    end)
end

local function RestoreNormal()
    currentMode = "None"
    Lighting.GlobalShadows = OrigLighting.Shadows
    Lighting.FogEnd = 2000 
    
    if Terrain then
        pcall(function() Terrain.Decoration = OrigTerrain.Deco end)
        pcall(function() Terrain.WaterWaveSize = OrigTerrain.Wave end)
        pcall(function() Terrain.WaterWaveSpeed = OrigTerrain.Speed end)
        pcall(function() Terrain.WaterReflectance = OrigTerrain.Reflect end)
    end
end

-- // TOGGLES FPS
UI.CreateToggle(MiscPage, "Medium Boost (PvP)", "Matiin VFX skill, rumput & air. Tekstur aman!", StateMed, function(state)
    StateMed = state
    if state then ApplyBoost("Medium") else RestoreNormal() end
end)

UI.CreateToggle(MiscPage, "High Boost (Smooth)", "Medium + Matiin semua bayangan mikro part.", StateHigh, function(state)
    StateHigh = state
    if state then ApplyBoost("High") else RestoreNormal() end
end)

UI.CreateToggle(MiscPage, "Extreme Boost (Potato)", "High + Plastik polos. Langit tetep cakep!", StateExt, function(state)
    StateExt = state
    if state then ApplyBoost("Extreme") else RestoreNormal() end
end)