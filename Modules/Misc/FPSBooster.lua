-- [[ ==========================================
--      MODULE: FPS BOOSTER (GOD TIER V6)
--      Engine: Network Optimizer + VFX Killer
--    ========================================== ]]

local Workspace  = game:GetService("Workspace")
local Lighting   = game:GetService("Lighting")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "FPS OPTIMIZER (PILIH SALAH SATU)")

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Simpan original state
local OrigLighting = {
    Shadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    QualityLevel = 3,
    ClockTime = Lighting.ClockTime
}
pcall(function() OrigLighting.QualityLevel = settings().Rendering.QualityLevel end)

local OrigTerrain = {}
if Terrain then
    OrigTerrain.Deco = Terrain.Decoration
    OrigTerrain.Wave = Terrain.WaterWaveSize
    OrigTerrain.Speed = Terrain.WaterWaveSpeed
    OrigTerrain.Reflect = Terrain.WaterReflectance
end

-- ==========================================
-- 1. SISTEM ANTI-PING & SILENT OPTIMIZER
-- Jalan otomatis, ngurangin beban jaringan & CPU tanpa ngaruh grafik
-- ==========================================
task.spawn(function()
    -- A. Matiin Streaming Integrasi (Biar kagak lag spike pas load map)
    pcall(function() Workspace.StreamingIntegrityEnabled = false end)
    
    -- B. Silent CPU Cleaner (Matiin sensor fisik benda mati pelan-pelan)
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
        if count >= 50 then count = 0 task.wait(0.1) end
    end
end)

-- Auto-clean part baru
Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.5)
    if obj:IsA("BasePart") then
        pcall(function()
            if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                obj.CanTouch = false
                obj.CanQuery = false
            end
        end)
    end
end)

-- ==========================================
-- 2. FUNGSI MESIN BOOST (VFX KILLER EDITION)
-- ==========================================
local currentMode = "None"

local function ApplyBoost(level)
    currentMode = level
    
    -- 1. Optimasi Instan (Lighting & Air)
    pcall(function() settings().Rendering.QualityLevel = 1 end)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    if Terrain then
        pcall(function() Terrain.Decoration = false end)
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
    end

    -- 2. Operasi Pembersihan Map & VFX
    task.spawn(function()
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if currentMode ~= level then break end -- Berhenti kalau ganti mode
            
            -- KILL VFX (Asap, Api, Partikel) - Ini yang paling bikin drop pas PVP!
            if (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")) then
                if level == "Medium" or level == "High" or level == "Extreme" then
                    pcall(function() obj.Enabled = false end)
                end
            end
            
            if obj:IsA("BasePart") then
                pcall(function()
                    -- Matiin sensor fisik benda mati
                    if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                        obj.CanTouch = false
                        obj.CanQuery = false
                    end
                    
                    -- Level High & Extreme: Matiin Bayangan Mikro
                    if level == "High" or level == "Extreme" then
                        obj.CastShadow = false
                    end

                    -- Level Extreme: Plastik Polos + Hapus Tekstur
                    if level == "Extreme" then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.Reflectance = 0
                    end
                end)
                
            elseif (obj:IsA("Decal") or obj:IsA("Texture")) and level == "Extreme" then
                pcall(function() obj.Transparency = 1 end)
            end
            
            count = count + 1
            if count >= 50 then
                count = 0
                task.wait(0.1)
            end
        end
        
        -- 3. Post-Loop Optimizations (Setelah selesai scan)
        if currentMode == level then
            -- Level High: Ilangin Skybox biar GPU kaga mikir keras
            if level == "High" then
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Sky") then pcall(function() v.Parent = nil end) end
                end
            end
            
            -- Level Extreme: Ilangin Skybox + Cahaya Datar
            if level == "Extreme" then
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Sky") then pcall(function() v.Parent = nil end) end
                end
                Lighting.Brightness = 0.5
                Lighting.Ambient = Color3.fromRGB(120, 120, 120)
                Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
            end
        end
    end)
end

local function RestoreNormal()
    currentMode = "None"
    pcall(function() settings().Rendering.QualityLevel = OrigLighting.QualityLevel end)
    Lighting.GlobalShadows = OrigLighting.Shadows
    Lighting.FogEnd = OrigLighting.FogEnd
    Lighting.Brightness = OrigLighting.Brightness
    Lighting.Ambient = OrigLighting.Ambient
    Lighting.OutdoorAmbient = OrigLighting.OutdoorAmbient
    Lighting.ClockTime = OrigLighting.ClockTime
    
    if Terrain then
        pcall(function() Terrain.Decoration = OrigTerrain.Deco end)
        pcall(function() Terrain.WaterWaveSize = OrigTerrain.Wave end)
        pcall(function() Terrain.WaterWaveSpeed = OrigTerrain.Speed end)
        pcall(function() Terrain.WaterReflectance = OrigTerrain.Reflect end)
    end
    
    -- Balikin Skybox kalau ilang
    pcall(function()
        if not Lighting:FindFirstChildOfClass("Sky") then
            local sky = Instance.new("Sky", Lighting)
        end
    end)
end

-- ==========================================
-- 3. MENU TOGGLES
-- ==========================================

UI.CreateToggle(
    Page, 
    "1. Medium (PvP Smooth)", 
    "Matiin efek skill (asap/api) & bayangan. Paling pas buat war!", 
    false, 
    function(state)
        if state then ApplyBoost("Medium") else RestoreNormal() end
    end
)

UI.CreateToggle(
    Page, 
    "2. High (Ultra Light)", 
    "Medium + Ilangin Skybox & Cahaya HD. Enteng gila!", 
    false, 
    function(state)
        if state then ApplyBoost("High") else RestoreNormal() end
    end
)

UI.CreateToggle(
    Page, 
    "3. Extreme (Potato PC)", 
    "Plastik polos, no texture, gelap! FPS 60+ di PC Kentang!", 
    false, 
    function(state)
        if state then ApplyBoost("Extreme") else RestoreNormal() end
    end
)