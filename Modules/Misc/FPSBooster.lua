-- [[ ==========================================
--      MODULE: FPS BOOSTER (THE BYPASS)
--      Status: Force-Lock Lighting & Disable 3D Clouds
--    ========================================== ]]

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI

_G.IsFPSBoostOn = false -- Variabel Global buat gembok

local Page = _G.Cat.UI.CreateTab("Misc", false)
_G.Cat.UI.CreateSection(Page, "EXTREME OPTIMIZATION")

-- // 1. BYPASS: GEMBOK PAKSA SYSTEM BLOX FRUITS
-- Kalau game nyoba nyalain bayangan/kabut, script kita langsung matiin lagi!
Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
    if _G.IsFPSBoostOn and Lighting.GlobalShadows == true then
        Lighting.GlobalShadows = false
    end
end)

Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
    if _G.IsFPSBoostOn and Lighting.FogEnd < 9000 then
        Lighting.FogEnd = 9e9
    end
end)

_G.Cat.UI.CreateToggle(
    Page,
    "Force FPS Boost",
    "Gembok paksa bayangan, awan 3D, dan kabut!",
    false,
    function(state)
        _G.IsFPSBoostOn = state
        
        if state then
            -- MATIIN PAKSA
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            
            -- Bypass: Matiin Awan 3D (Ini penyedot FPS paling parah di Update 20)
            local clouds = Workspace:FindFirstChildOfClass("Clouds")
            if clouds then clouds.Enabled = false end
            
            local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmos then atmos.Enabled = false end
        else
            -- NYALAIN LAGI
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
            
            local clouds = Workspace:FindFirstChildOfClass("Clouds")
            if clouds then clouds.Enabled = true end
            
            local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmos then atmos.Enabled = true end
        end
    end
)