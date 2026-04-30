-- [[ ==========================================
--      MODULE: FPS BOOSTER (PVP MODE)
--      Engine: Native Roblox Rendering Killer
--    ========================================== ]]

local Lighting  = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do task.wait(0.1) end
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "EXTREME OPTIMIZATION")

-- Simpan settingan awal biar bisa di-Off-in (Tanpa Loop Berat!)
local Orig = {
    Diffuse = Lighting.EnvironmentDiffuseScale,
    Specular = Lighting.EnvironmentSpecularScale,
    Shadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    PostEffects = {}
}

-- Simpan state PostEffects (Bloom, SunRays, dll)
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        Orig.PostEffects[v] = v.Enabled
    end
end

-- Simpan state Terrain
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
if Terrain then
    Orig.Decoration = Terrain.Decoration
    Orig.WaterWaveSize = Terrain.WaterWaveSize
    Orig.WaterWaveSpeed = Terrain.WaterWaveSpeed
    Orig.WaterReflectance = Terrain.WaterReflectance
end

-- Inisialisasi Settings jika belum ada
if Settings.FPSBoost == nil then Settings.FPSBoost = false end

UI.CreateToggle(
    Page,
    "PvP FPS Boost",
    "Matikan grafik berat, hilangkan lag PVP!",
    Settings.FPSBoost,
    function(state)
        Settings.FPSBoost = state
        
        if state then
            -- =====================================
            -- ON: MODE PVP (SEDITIK BURIK TAPI LANCAR)
            -- =====================================
            
            -- 1. Paksa Quality Level ke Level 1 (Paling Ampuh, Nge-bypass setting game)
            pcall(function() settings().Rendering.QualityLevel = 1 end)
            
            -- 2. Matiin Bayangan Global (Roblox otomatis matiin semua CastShadow tanpa loop!)
            Lighting.GlobalShadows = false
            
            -- 3. Botakin Rumput 3D & Ratain Air
            if Terrain then
                Terrain.Decoration = false
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
            end

            -- 4. Bikin Lighting Datar / Matte
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.FogEnd = 9e9

            -- 5. Matiin Efek Silau & Bloom (Tetep pertahankan warna dasar)
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") and not v:IsA("ColorCorrectionEffect") then
                    v.Enabled = false
                end
            end

            warn("[CatHUB] PvP Boost ON! FPS Tembus Langit!")

        else
            -- =====================================
            -- OFF: BALIK KE GRAFIK BAWAAN
            -- =====================================
            
            -- Balikin Quality Level ke Default
            pcall(function() settings().Rendering.QualityLevel = 3 end) 
            
            -- Balikin Bayangan
            Lighting.GlobalShadows = Orig.Shadows
            
            -- Balikin Terrain
            if Terrain then
                Terrain.Decoration = Orig.Decoration
                Terrain.WaterWaveSize = Orig.WaterWaveSize
                Terrain.WaterWaveSpeed = Orig.WaterWaveSpeed
                Terrain.WaterReflectance = Orig.WaterReflectance
            end

            -- Balikin Lighting
            Lighting.EnvironmentDiffuseScale = Orig.Diffuse
            Lighting.EnvironmentSpecularScale = Orig.Specular
            Lighting.FogEnd = Orig.FogEnd

            -- Balikin PostEffects
            for v, state in pairs(Orig.PostEffects) do
                if v and v.Parent then v.Enabled = state end
            end
            
            warn("[CatHUB] PvP Boost OFF! Grafik balik normal.")
        end
    end
)