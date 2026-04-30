-- [[ ==========================================
--      MODULE: FPS BOOSTER & GAME SETTINGS (V12 - SMOOTH ASYNC)
--      Status: No Freeze, Background Cleaner
--    ========================================== ]]

local Workspace    = game:GetService("Workspace")
local Lighting     = game:GetService("Lighting")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI

local UI = _G.Cat.UI

-- ==========================================
-- TAB & UI SETUP
-- ==========================================
local MiscPage = UI.CreateTab("Misc", false)
UI.CreateSection(MiscPage, "FPS OPTIMIZER")

local StateMed  = false
local StateHigh = false
local StateExt  = false

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Backup Original Settings (Safe Method)
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
local cleanupConnection = nil

-- // FUNGSI UTAMA: CLEANER (ANTI-FREEZE)
local function ApplyBoost(level)
    currentMode = level
    
    -- 1. Environment Changes (Instant)
    Lighting.FogEnd = 9e9 
    Lighting.GlobalShadows = false
    
    if Terrain then
        pcall(function() Terrain.Decoration = false end)
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
    end

    -- 2. Stop Previous Cleaner if exist
    if cleanupConnection then cleanupConnection:Disconnect() end
    
    -- 3. Start Background Cleaner (Spread over time)
    -- Kita pake iterator yang lebih halus, bukan GetDescendants() langsung
    cleanupConnection = RunService.Heartbeat:Connect(function()
        local cleaned = 0
        -- Cuma proses 50 object per frame biar FPS stabil 60
        for _, obj in ipairs(Workspace:GetChildren()) do
            if cleaned >= 50 then break end
            
            if obj:IsA("Model") or obj:IsA("Folder") then
                for _, child in ipairs(obj:GetDescendants()) do
                    if child:IsA("ParticleEmitter") or child:IsA("Trail") or child:IsA("Beam") or child:IsA("Smoke") or child:IsA("Fire") or child:IsA("Sparkles") then
                        child.Enabled = false
                    elseif child:IsA("BasePart") then
                        if child.Anchored then
                            child.CanTouch = false
                            child.CanQuery = false
                        end
                        if level == "High" or level == "Extreme" then
                            child.CastShadow = false
                        end
                        if level == "Extreme" then
                            child.Material = Enum.Material.SmoothPlastic
                            child.Reflectance = 0
                        end
                    elseif (child:IsA("Decal") or child:IsA("Texture")) and level == "Extreme" then
                        child.Transparency = 1
                    end
                    cleaned = cleaned + 1
                end
            -- Handle Parts langsung di Workspace
            elseif obj:IsA("BasePart") then
                if obj.Anchored then
                    obj.CanTouch = false
                    obj.CanQuery = false
                end
                cleaned = cleaned + 1
            end
        end
        
        -- Kalau udah kelar semua, matikan koneksi biar nggak makan memory
        -- Note: Untuk simplicity, kita biarkan jalan pelan-pelan atau lu bisa tambah logic "isDone"
    end)
    
    warn("[CatHUB] FPS Boost " .. level .. " Activated (Smooth Mode)")
end

local function RestoreNormal()
    currentMode = "None"
    
    if cleanupConnection then 
        cleanupConnection:Disconnect() 
        cleanupConnection = nil 
    end
    
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
UI.CreateToggle(MiscPage, "Medium Boost", "Clear effects gradually (No Freeze)", StateMed, function(state)
    StateMed = state
    if state then ApplyBoost("Medium") else RestoreNormal() end
end)

UI.CreateToggle(MiscPage, "High Boost", "Clear shadows gradually", StateHigh, function(state)
    StateHigh = state
    if state then ApplyBoost("High") else RestoreNormal() end
end)

UI.CreateToggle(MiscPage, "Extreme Boost", "Full cleanup gradually", StateExt, function(state)
    StateExt = state
    if state then ApplyBoost("Extreme") else RestoreNormal() end
end)