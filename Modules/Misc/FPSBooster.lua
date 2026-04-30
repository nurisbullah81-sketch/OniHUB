-- [[ ==========================================
--      MODULE: FPS BOOSTER (SMART TOGGLE)
--      Status: Grafik Aman, FPS Nyaman
--    ========================================== ]]

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- // Tunggu UI Core siap
repeat 
    task.wait(0.1) 
until _G.Cat and _G.Cat.UI and _G.Cat.Settings

-- // 1. Simpan Grafik Original (Biar bisa di-Off-in lagi)
local Orig = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    WaterWaveSize = Terrain and Terrain.WaterWaveSize or 0,
    WaterWaveSpeed = Terrain and Terrain.WaterWaveSpeed or 0,
    WaterReflectance = Terrain and Terrain.WaterReflectance or 0,
}

-- // 2. Bikin Menu di Tab "Misc"
local Page = _G.Cat.UI.CreateTab("Misc", false)
_G.Cat.UI.CreateSection(Page, "GAME OPTIMIZATION")

_G.Cat.UI.CreateToggle(
    Page,
    "Lite FPS Boost",
    "Matiin bayangan & air (Grafik tetep HD, FPS naik)",
    false, -- Default-nya OFF biar pas masuk kaga kaget
    function(state)
        if state then
            -- =====================================
            -- ON: MODE RINGAN (ANTI-LAG)
            -- =====================================
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            
            if Terrain then
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
            end
            
            -- Matiin efek cahaya silau (Kecuali ColorCorrection biar warna kaga pudar)
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("PostEffect") or string.match(effect.ClassName, "Effect") then
                    if effect:IsA("ColorCorrectionEffect") then continue end
                    effect.Enabled = false
                end
            end
        else
            -- =====================================
            -- OFF: BALIK KE GRAFIK ASLI
            -- =====================================
            Lighting.GlobalShadows = Orig.GlobalShadows
            Lighting.FogEnd = Orig.FogEnd
            
            if Terrain then
                Terrain.WaterWaveSize = Orig.WaterWaveSize
                Terrain.WaterWaveSpeed = Orig.WaterWaveSpeed
                Terrain.WaterReflectance = Orig.WaterReflectance
            end
            
            -- Nyalain efek cahaya bawaan game
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("PostEffect") or string.match(effect.ClassName, "Effect") then
                    effect.Enabled = true
                end
            end
        end
    end
)