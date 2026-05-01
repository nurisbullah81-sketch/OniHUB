-- [[ ==========================================
--      MODULE: FPS BOOSTER
--    ========================================== ]]

local Workspace  = game:GetService("Workspace")
local Lighting   = game:GetService("Lighting")
local Players    = game:GetService("Players")

-- // Framework Initialization
repeat
    task.wait(0.1)
until _G.Cat and _G.Cat.UI and _G.Cat.Settings

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

-- ==========================================
-- 1. UI SETUP
-- ==========================================
local MiscPage = UI.CreateTab("Misc", false)
UI.CreateSection(MiscPage, "PERFORMANCE")

-- Default Setting
if type(Settings.FPSBoost) ~= "boolean" then
    Settings.FPSBoost = false
end

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- // Backup Original Properties
local Orig = {
    Shadows  = Lighting.GlobalShadows,
    Fog      = Lighting.FogEnd,
    Bright   = Lighting.Brightness,
    Quality  = settings().Rendering.QualityLevel
}

local OrigTerrain = {}

if Terrain then
    pcall(function()
        OrigTerrain.Deco    = Terrain.Decoration
        OrigTerrain.Wave    = Terrain.WaterWaveSize
        OrigTerrain.Speed   = Terrain.WaterWaveSpeed
        OrigTerrain.Reflect = Terrain.WaterReflectance
    end)
end

-- ==========================================
-- 2. LOGIC: TOGGLE GRAPHICS
-- ==========================================
local function ToggleBoost(state)
    if state then
        -- // Apply Low Graphics Settings
        -- 1. Rendering Quality (Paling berpengaruh)
        settings().Rendering.QualityLevel = 1

        -- 2. Lighting Optimization
        Lighting.GlobalShadows = false
        Lighting.FogEnd        = 1000000
        -- Hapus Brightness = 0 biar ga gelap total

        -- 3. Terrain Optimization
        if Terrain then
            Terrain.Decoration     = false
            Terrain.WaterWaveSize  = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
        end

        -- 4. Streaming Integrity
        pcall(function()
            Workspace.StreamingIntegrityEnabled = false
        end)

        -- 5. Particle Cleanup (One-time Scan)
        task.spawn(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                local isParticle = v:IsA("ParticleEmitter")
                local isTrail    = v:IsA("Trail")
                local isSmoke    = v:IsA("Smoke")
                local isFire     = v:IsA("Fire")

                if isParticle or isTrail or isSmoke or isFire then
                    v.Enabled = false
                end
            end
        end)

    else
        -- // Restore Original Settings
        settings().Rendering.QualityLevel = Orig.Quality
        
        Lighting.GlobalShadows = Orig.Shadows
        Lighting.FogEnd        = Orig.Fog
        Lighting.Brightness    = Orig.Bright

        if Terrain then
            pcall(function()
                Terrain.Decoration     = OrigTerrain.Deco
                Terrain.WaterWaveSize  = OrigTerrain.Wave
                Terrain.WaterWaveSpeed = OrigTerrain.Speed
                Terrain.WaterReflectance = OrigTerrain.Reflect
            end)
        end
    end
end

-- // UI Toggle Creation
UI.CreateToggle(
    MiscPage,
    "Optimize Graphics",
    "Disable shadows/fog (Recommended)",
    Settings.FPSBoost,
    function(state)
        Settings.FPSBoost = state
        ToggleBoost(state)
    end
)