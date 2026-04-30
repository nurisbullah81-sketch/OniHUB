-- [[ ==========================================
--      MODULE: FPS BOOSTER & GAME SETTINGS (V9)
--      Status: Aesthetic Sky, 3-Tier Boost & No Shake
--    ========================================== ]]

local Workspace   = game:GetService("Workspace")
local Lighting    = game:GetService("Lighting")
local RunService  = game:GetService("RunService")
local Players     = game:GetService("Players")
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

local OrigLighting = {
    Shadows = Lighting.GlobalShadows,
    QualityLevel = 3
}

local OrigTerrain = {}
if Terrain then
    pcall(function() OrigTerrain.Deco = Terrain.Decoration end)
    pcall(function() OrigTerrain.Wave = Terrain.WaterWaveSize end)
    pcall(function() OrigTerrain.Speed = Terrain.WaterWaveSpeed end)
    pcall(function() OrigTerrain.Reflect = Terrain.WaterReflectance end)
end

-- // SISTEM ANTI-PING (Background Cleaner)
task.spawn(function()
    pcall(function() Workspace.StreamingIntegrityEnabled = false end)
    local count = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function()
                if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                    obj.CanTouch = false
                    obj.CanQuery = false
                end
            end)
        end
        count = count + 1
        if count >= 100 then count = 0 task.wait(0.1) end
    end
end)

local currentMode = "None"

local function ApplyBoost(level)
    currentMode = level
    
    -- Jarak pandang jauh (kaga ada kabut) & matiin bayangan matahari
    Lighting.FogEnd = 9e9 
    Lighting.GlobalShadows = false
    
    if Terrain then
        pcall(function() Terrain.Decoration = false end) 
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
    end

    task.spawn(function()
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if currentMode ~= level then break end 
            
            -- KILL VFX (Semua Level)
            if (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")) then
                pcall(function() obj.Enabled = false end)
            end
            
            if obj:IsA("BasePart") then
                pcall(function()
                    -- Mode High & Extreme: Matiin bayangan detail
                    if level == "High" or level == "Extreme" then
                        obj.CastShadow = false
                    end
                    -- Mode Extreme: Plastik polos
                    if level == "Extreme" then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.Reflectance = 0
                    end
                end)
            -- Mode Extreme: Hapus decal/stiker
            elseif (obj:IsA("Decal") or obj:IsA("Texture")) and level == "Extreme" then
                pcall(function() obj.Transparency = 1 end)
            end
            
            count = count + 1
            if count >= 150 then 
                count = 0
                task.wait()
            end
        end
    end)
end

local function RestoreNormal()
    currentMode = "None"
    Lighting.GlobalShadows = OrigLighting.Shadows
    Lighting.FogEnd = 2000 -- Default kabut Blox Fruits
    
    if Terrain then
        pcall(function() Terrain.Decoration = OrigTerrain.Deco end)
        pcall(function() Terrain.WaterWaveSize = OrigTerrain.Wave end)
        pcall(function() Terrain.WaterWaveSpeed = OrigTerrain.Speed end)
        pcall(function() Terrain.WaterReflectance = OrigTerrain.Reflect end)
    end
end

-- // TOGGLES FPS
UI.CreateToggle(MiscPage, "Medium Boost (PvP)", "Matiin VFX skill, rumput & air. Tekstur & Skybox aman!", StateMed, function(state)
    StateMed = state
    if state then ApplyBoost("Medium") else RestoreNormal() end
end)

UI.CreateToggle(MiscPage, "High Boost (Smooth)", "Medium + Matiin semua bayangan mikro part. Enteng!", StateHigh, function(state)
    StateHigh = state
    if state then ApplyBoost("High") else RestoreNormal() end
end)

UI.CreateToggle(MiscPage, "Extreme Boost (Potato)", "High + Plastik polos, no texture. Langit tetep cakep!", StateExt, function(state)
    StateExt = state
    if state then ApplyBoost("Extreme") else RestoreNormal() end
end)


-- ==========================================
-- TAB 2: GAME SETTINGS (NEW!)
-- ==========================================
local SettingsPage = UI.CreateTab("Game Settings", false)
UI.CreateSection(SettingsPage, "AUDIO & CAMERA CONTROL")

-- // 1. Mute Background Music
local MuteState = false
UI.CreateToggle(SettingsPage, "Mute Background Music", "Matiin lagu pulau biar kaga berisik", MuteState, function(state)
    MuteState = state
    for _, sound in ipairs(SoundService:GetDescendants()) do
        if sound:IsA("Sound") then
            -- Kalau true volumenya 0, kalau false balik ke 0.5
            sound.Volume = state and 0 or 0.5 
        end
    end
    -- Pasang listener buat lagu baru yang mau play
    if state then
        SoundService.DescendantAdded:Connect(function(obj)
            if MuteState and obj:IsA("Sound") then
                task.wait(0.1)
                obj.Volume = 0
            end
        end)
    end
end)

-- // 2. Disable Screen Shake (Anti Gempa)
local ShakeState = false
local ShakeConn = nil

UI.CreateToggle(SettingsPage, "Disable Screen Shake", "Kamera stabil biarpun ada yang spam jurus", ShakeState, function(state)
    ShakeState = state
    if state then
        ShakeConn = RunService.RenderStepped:Connect(function()
            local char = Players.LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if hum then
                -- Ngunci offset kamera biar kaga geter
                hum.CameraOffset = Vector3.new(0, 0, 0)
            end
        end)
    else
        if ShakeConn then 
            ShakeConn:Disconnect() 
            ShakeConn = nil 
        end
    end
end)