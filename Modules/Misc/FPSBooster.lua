-- [[ ==========================================
--      MODULE: FPS BOOSTER (STATIC EDITION)
--      Note: Jalan sekali, lalu diam. Anti-Lag!
--    ========================================== ]]

local Workspace    = game:GetService("Workspace")
local Lighting     = game:GetService("Lighting")
local Players      = game:GetService("Players")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI

local UI = _G.Cat.UI

-- ==========================================
-- UI SETUP
-- ==========================================
local MiscPage = UI.CreateTab("Misc", false)
UI.CreateSection(MiscPage, "PERFORMANCE")

local StateBoost = false

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Backup Variable
local Orig = {
    Shadows = Lighting.GlobalShadows,
    Fog = Lighting.FogEnd,
    Brightness = Lighting.Brightness
}
local OrigTerrain = {}

if Terrain then
    pcall(function()
        OrigTerrain.Deco = Terrain.Decoration
        OrigTerrain.Wave = Terrain.WaterWaveSize
        OrigTerrain.Speed = Terrain.WaterWaveSpeed
        OrigTerrain.Reflect = Terrain.WaterReflectance
    end)
end

-- ==========================================
-- LOGIC: TOGGLE GRAPHICS (NO LOOPS!)
-- ==========================================
local function ToggleBoost(state)
    if state then
        -- TERAPKAN PENGATURAN GRAFIS RENDAH
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000
        Lighting.Brightness = 0 -- Ga perlu terang berlebihan
        
        if Terrain then
            Terrain.Decoration = false
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
        end
        
        -- Matikan Streaming biar RAM lega
        pcall(function() Workspace.StreamingIntegrityEnabled = false end)
        
        -- Hapus Partikel yang ada SAAT INI (Sekali jalan, bukan loop)
        task.spawn(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
        end)
    else
        -- KEMBALIKAN KE NORMAL
        Lighting.GlobalShadows = Orig.Shadows
        Lighting.FogEnd = Orig.Fog
        Lighting.Brightness = Orig.Brightness
        
        if Terrain then
            pcall(function()
                Terrain.Decoration = OrigTerrain.Deco
                Terrain.WaterWaveSize = OrigTerrain.Wave
                Terrain.WaterWaveSpeed = OrigTerrain.Speed
                Terrain.WaterReflectance = OrigTerrain.Reflect
            end)
        end
    end
end

UI.CreateToggle(MiscPage, "Optimize Graphics", "Disable shadows/fog (Recommended)", StateBoost, function(state)
    StateBoost = state
    ToggleBoost(state)
end)