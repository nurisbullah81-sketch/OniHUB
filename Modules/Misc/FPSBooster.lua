-- [[ ==========================================
--      MODULE: FPS BOOSTER (GOD TIER V4)
--      Engine: Background Cleaner + PVP Toggle
--    ========================================== ]]

local Workspace  = game:GetService("Workspace")
local Lighting   = game:GetService("Lighting")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

-- OBAT AMAN: Pastiin setting boolean biar kagak error apapun yang terjadi
if type(Settings.FPSBoost) ~= "boolean" then
    Settings.FPSBoost = false
end

local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "EXTREME OPTIMIZATION")

-- ==========================================
-- 1. AUTO-BOOST (Jalan Otomatis Tanpa Ngurangin Grafik)
-- Ini merapikan CPU game di background biar kagak makan RAM/Ping
-- ==========================================
task.spawn(function()
    -- A. Matiin Streaming Roblox (Biar kagak patah-patah pas jalan)
    pcall(function() Workspace.StreamingIntegrityEnabled = false end)
    
    -- B. Background Cleaner (Ngurus benda mati pelan-pelan biar kagak freeze)
    local count = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function()
                -- Bayangan tetep nyala (kagak ngaruh grafik), tapi sensor fisik dimatiin
                if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                    obj.CanTouch = false
                    obj.CanQuery = false
                end
            end)
        end
        
        count = count + 1
        if count >= 50 then
            count = 0
            task.wait(0.1) -- Jeda biar kagak lag
        end
    end
end)

-- ==========================================
-- 2. PVP FPS BOOST TOGGLE
-- ==========================================
-- Gue pake cara Gemini (Hardcode false) biar muncul 100%
local CurrentBoostState = Settings.FPSBoost

-- Simpan Original State buat restore
local OrigShadows = Lighting.GlobalShadows
local OrigTerrain = {}
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
if Terrain then
    OrigTerrain.Deco = Terrain.Decoration
    OrigTerrain.Wave = Terrain.WaterWaveSize
    OrigTerrain.Speed = Terrain.WaterWaveSpeed
    OrigTerrain.Reflect = Terrain.WaterReflectance
end

UI.CreateToggle(
    Page,
    "PvP FPS Boost",
    "Kurangi bayangan & air, FPS meroket! (FX Tetap Aman)",
    CurrentBoostState, -- Pake variable, kagak langsung dari Settings biar aman
    function(state)
        Settings.FPSBoost = state
        
        if state then
            -- =====================================
            -- ON: MODE PVP (Instant +20 FPS)
            -- =====================================
            
            -- 1. Turunin Quality Level (Paling ampuh, tapi kagak ngilangin FX)
            pcall(function() settings().Rendering.QualityLevel = 1 end)
            
            -- 2. Matiin Bayangan Global (GPU Lega)
            Lighting.GlobalShadows = false
            
            -- 3. Matiin Air Berat
            if Terrain then
                Terrain.Decoration = false
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
            end

            -- KAGAK SENTUH PostEffects (Bloom, SunRays tetep nyala biar cakep!)

        else
            -- =====================================
            -- OFF: BALIKIN KE HD BAWAAN
            -- =====================================
            
            pcall(function() settings().Rendering.QualityLevel = 3 end)
            Lighting.GlobalShadows = OrigShadows
            
            if Terrain then
                Terrain.Decoration = OrigTerrain.Deco
                Terrain.WaterWaveSize = OrigTerrain.Wave
                Terrain.WaterWaveSpeed = OrigTerrain.Speed
                Terrain.WaterReflectance = OrigTerrain.Reflect
            end
        end
    end
)

-- ==========================================
-- 3. AUTO-CLEANER (Buat part baru yang nongol)
-- ==========================================
Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.5) -- Jeda biar kagak langsung beratin
    if obj:IsA("BasePart") then
        pcall(function()
            if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                obj.CanTouch = false
                obj.CanQuery = false
            end
            -- Kalau PVP Boost nyala, matiin bayangan part baru juga
            if Settings.FPSBoost then
                obj.CastShadow = false
            end
        end)
    end
end)