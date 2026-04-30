-- [[ ==========================================
--      MODULE: FPS BOOSTER (NO-LOOP ENGINE)
--      Engine: Pure Rendering Toggles
--    ========================================== ]]

local Lighting  = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do task.wait(0.1) end
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

-- OBAT UI HILANG
if Settings.FPSBoost == nil then Settings.FPSBoost = false end

local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "EXTREME OPTIMIZATION")

-- Simpan original state
local Orig = {
    Shadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    QualityLevel = 3,
}
pcall(function() Orig.QualityLevel = settings().Rendering.QualityLevel end)

local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local OrigTerrain = Terrain and {
    Deco = Terrain.Decoration,
    Wave = Terrain.WaterWaveSize,
    Speed = Terrain.WaterWaveSpeed,
    Reflect = Terrain.WaterReflectance
}

local OrigPostFX = {}
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        OrigPostFX[v] = v.Enabled
    end
end

-- ==========================================
-- 1. SISTEM BACKGROUND (Jalan 1 Kali, Tanpa Loop!)
-- Ini ngatasin game yang ke-set Quality Level 21 (Super Berat)
-- ==========================================
task.spawn(function()
    pcall(function() 
        if settings().Rendering.QualityLevel > 3 then
            settings().Rendering.QualityLevel = 3 
        end
    end)
end)

-- ==========================================
-- 2. PVP FPS BOOST TOGGLE
-- ==========================================
UI.CreateToggle(
    Page, 
    "PvP FPS Boost", 
    "Kurangi bayangan & air, FX tetap aman! (Tanpa Lag Loop)", 
    Settings.FPSBoost, 
    function(state)
        Settings.FPSBoost = state
        
        if state then
            -- =====================================
            -- ON: MODE PVP (Instant 0.01 Detik)
            -- =====================================
            
            -- 1. Turunin Quality Level
            pcall(function() settings().Rendering.QualityLevel = 1 end)
            
            -- 2. Matiin Bayangan Global (Paling Ampuh)
            Lighting.GlobalShadows = false
            
            -- 3. Matiin Air berat
            if Terrain then
                Terrain.Decoration = false
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
            end

            -- 4. Matiin FX Berat (Tapi Biarin Bloom biar tetep cakep)
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") and not v:IsA("BloomEffect") then
                    pcall(function() v.Enabled = false end)
                end
            end

        else
            -- =====================================
            -- OFF: BALIKIN KE HD (Instant 0.01 Detik)
            -- =====================================
            pcall(function() settings().Rendering.QualityLevel = Orig.QualityLevel end)
            Lighting.GlobalShadows = Orig.Shadows
            
            if Terrain then
                Terrain.Decoration = OrigTerrain.Deco
                Terrain.WaterWaveSize = OrigTerrain.Wave
                Terrain.WaterWaveSpeed = OrigTerrain.Speed
                Terrain.WaterReflectance = OrigTerrain.Reflect
            end

            for v, origState in pairs(OrigPostFX) do
                if v and v.Parent then pcall(function() v.Enabled = origState end) end
            end
        end
    end
)