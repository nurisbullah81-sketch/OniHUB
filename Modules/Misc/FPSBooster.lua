-- [[ ==========================================
--      MODULE: FPS BOOSTER (CatHUB x z.ai V7)
--      Engine: Network Optimizer + VFX Killer + Anti-Crash
--    ========================================== ]]

local Workspace  = game:GetService("Workspace")
local Lighting   = game:GetService("Lighting")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local Page     = UI.CreateTab("Misc", false)

UI.CreateSection(Page, "FPS OPTIMIZER (PILIH SALAH SATU)")

-- Setup Default Settings biar UI kaga gaib
if type(Settings.BoostMed) ~= "boolean" then Settings.BoostMed = false end
if type(Settings.BoostHigh) ~= "boolean" then Settings.BoostHigh = false end
if type(Settings.BoostExt) ~= "boolean" then Settings.BoostExt = false end

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Simpan original state dengan aman
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
    pcall(function() OrigTerrain.Deco = Terrain.Decoration end)
    pcall(function() OrigTerrain.Wave = Terrain.WaterWaveSize end)
    pcall(function() OrigTerrain.Speed = Terrain.WaterWaveSpeed end)
    pcall(function() OrigTerrain.Reflect = Terrain.WaterReflectance end)
end

-- ==========================================
-- 1. SISTEM ANTI-PING & SILENT OPTIMIZER (z.ai Core)
-- ==========================================
task.spawn(function()
    -- Matiin Streaming Integrasi (Anti lag spike pas pindah pulau)
    pcall(function() Workspace.StreamingIntegrityEnabled = false end)
    
    -- Silent CPU Cleaner
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

-- Auto-clean part baru (Peluru, jurus baru)
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
        pcall(function() Terrain.Decoration = false end) -- Digembok anti-crash!
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
    end

    -- 2. Operasi Pembersihan Map & VFX
    task.spawn(function()
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if currentMode ~= level then break end -- Batalin kalau ganti mode
            
            -- KILL VFX (Asap, Api, Partikel) - z.ai signature move!
            if (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")) then
                if level == "Medium" or level == "High" or level == "Extreme" then
                    pcall(function() obj.Enabled = false end)
                end
            end
            
            if obj:IsA("BasePart") then
                pcall(function()
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
            if count >= 100 then -- Dibikin 100 biar lebih cepet ngeloadnya
                count = 0
                task.wait()
            end
        end
        
        -- 3. Post-Loop Optimizations (Skybox & Lighting)
        if currentMode == level then
            if level == "High" or level == "Extreme" then
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Sky") then pcall(function() v.Parent = nil end) end
                end
            end
            
            if level == "Extreme" then
                Lighting.Brightness = 0.5
                Lighting.Ambient = Color3.fromRGB(120, 120, 120)
                Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
            end
        end
        warn("[CatHUB] " .. level .. " Mode Activated (VFX Killed)")
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
    
    pcall(function()
        if not Lighting:FindFirstChildOfClass("Sky") then
            Instance.new("Sky", Lighting)
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
    Settings.BoostMed, 
    function(state)
        Settings.BoostMed = state
        if state then ApplyBoost("Medium") else RestoreNormal() end
    end
)

UI.CreateToggle(
    Page, 
    "2. High (Ultra Light)", 
    "Medium + Ilangin Skybox & Cahaya HD. Enteng gila!", 
    Settings.BoostHigh, 
    function(state)
        Settings.BoostHigh = state
        if state then ApplyBoost("High") else RestoreNormal() end
    end
)

UI.CreateToggle(
    Page, 
    "3. Extreme (Potato PC)", 
    "Plastik polos, no texture, gelap! FPS 60+ di PC Kentang!", 
    Settings.BoostExt, 
    function(state)
        Settings.BoostExt = state
        if state then ApplyBoost("Extreme") else RestoreNormal() end
    end
)