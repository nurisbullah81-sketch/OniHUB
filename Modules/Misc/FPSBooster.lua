-- [[ ==========================================
--      MODULE: FPS BOOSTER (MAX PERFORMANCE)
--      Deskripsi: Membunuh grafik berat Roblox
--    ========================================== ]]

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- // 1. MATIIN PENCAHAYAAN BERAT (SHADOWS & EFFECTS)
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.ShadowSoftness = 0

for _, effect in ipairs(Lighting:GetChildren()) do
    if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
        effect.Enabled = false
    end
end

-- // 2. RATAKAN AIR LAUT (HEMAT CPU)
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
end

-- // 3. MATIIN TEKSTUR & MATERIAL PART SECARA AMAN (ANTI-FREEZE)
-- Kita pakai task.spawn & wait biar pas script jalan kaga bikin game nge-freeze
task.spawn(function()
    local count = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        -- Buat part biasa, ubah jadi plastik polos dan buang bayangannya
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        -- Buat stiker/tekstur, kita tembus pandang aja
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
        
        -- Istirahat sepersekian detik tiap 1000 part biar CPU HP/PC lu kaga kaget
        count = count + 1
        if count >= 1000 then
            count = 0
            task.wait()
        end
    end
    warn("✅ [CatHUB] FPS Booster Berhasil Diaktifkan! Grafik Ultra Kentang!")
end)