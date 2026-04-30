-- [[ ==========================================
--      MODULE: FPS BOOSTER & GAME SETTINGS (V10)
--      Status: Anti-Stuck, 0% Memory Leak
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

local OrigLighting = {
    Shadows = Lighting.GlobalShadows,
}
local OrigTerrain = {}
if Terrain then
    OrigTerrain.Deco = Terrain.Decoration
    OrigTerrain.Wave = Terrain.WaterWaveSize
    OrigTerrain.Speed = Terrain.WaterWaveSpeed
    OrigTerrain.Reflect = Terrain.WaterReflectance
end

-- Matiin Streaming Integrity di awal (Aman kaga pake loop)
pcall(function() Workspace.StreamingIntegrityEnabled = false end)

local currentMode = "None"
local boostThread = nil -- Buat ngebatalin proses kalau lu pencet tombol cepet-cepet

local function ApplyBoost(level)
    currentMode = level
    
    Lighting.FogEnd = 9e9 
    Lighting.GlobalShadows = false
    
    if Terrain then
        Terrain.Decoration = false
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
    end

    -- Kalau ada scan yang lagi jalan, berhentiin dulu biar CPU kaga tabrakan
    if boostThread then task.cancel(boostThread) end

    boostThread = task.spawn(function()
        local count = 0
        local descs = Workspace:GetDescendants() -- Tarik data SEKALI doang!
        
        for i = 1, #descs do
            local obj = descs[i]
            
            -- KILL VFX (Instan, kaga pake pcall!)
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            
            -- OPTIMASI BENDA (Instan, kaga pake pcall!)
            elseif obj:IsA("BasePart") then
                -- Anti-Ping (Sensor sentuh mati)
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
                
            -- HAPUS DECAL (Instan)
            elseif (obj:IsA("Decal") or obj:IsA("Texture")) and level == "Extreme" then
                obj.Transparency = 1
            end
            
            count = count + 1
            -- CPU istirahat tiap 1000 benda (Jauh lebih cepet dan mulus dari V9)
            if count >= 1000 then 
                count = 0
                task.wait()
            end
        end
    end)
end

local function RestoreNormal()
    currentMode = "None"
    Lighting.GlobalShadows = OrigLighting.Shadows
    Lighting.FogEnd = 2000 
    
    if Terrain then
        Terrain.Decoration = OrigTerrain.Deco
        Terrain.WaterWaveSize = OrigTerrain.Wave
        Terrain.WaterWaveSpeed = OrigTerrain.Speed
        Terrain.WaterReflectance = OrigTerrain.Reflect
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

UI.CreateToggle(MiscPage, "Extreme Boost (Potato)", "High + Plastik polos. Langit tetep biru!", StateExt, function(state)
    StateExt = state
    if state then ApplyBoost("Extreme") else RestoreNormal() end
end)


-- ==========================================
-- TAB 2: GAME SETTINGS
-- ==========================================
local SettingsPage = UI.CreateTab("Game Settings", false)
UI.CreateSection(SettingsPage, "AUDIO & CAMERA CONTROL")

-- // 1. Mute Background Music
local MuteState = false
UI.CreateToggle(SettingsPage, "Mute Background Music", "Matiin lagu pulau biar kaga berisik", MuteState, function(state)
    MuteState = state
    for _, sound in ipairs(SoundService:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = state and 0 or 0.5 
        end
    end
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