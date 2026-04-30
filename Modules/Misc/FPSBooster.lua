-- [[ ==========================================
--      MODULE: FPS BOOSTER (V8 - BYPASS GEMBOK)
--      Engine: Network Optimizer + VFX Killer
--    ========================================== ]]

local Workspace  = game:GetService("Workspace")
local Lighting   = game:GetService("Lighting")

-- KITA KAGA NUNGGUIN SETTINGS BIAR KAGA ERROR
repeat task.wait(0.1) until _G.Cat and _G.Cat.UI

local UI   = _G.Cat.UI
local Page = UI.CreateTab("Misc", false)

UI.CreateSection(Page, "FPS OPTIMIZER (PILIH SALAH SATU)")

-- // FIX MUTLAK: PAKE JALUR BELAKANG (LOCAL STATE)
-- Kita kaga nyentuh _G.Cat.Settings sama sekali biar kaga kena tendang sistem!
local StateMed  = false
local StateHigh = false
local StateExt  = false

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Simpan original state dengan aman
local OrigLighting = {
    Shadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime
}

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
    pcall(function() Workspace.StreamingIntegrityEnabled = false end)
    
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

Workspace.DescendantAdded:Connect(function(obj)
    -- Dibungkus task.spawn biar kaga nyangkut di event listener
    task.spawn(function()
        task.wait(0.5)
        if obj and obj.Parent and obj:IsA("BasePart") then
            pcall(function()
                if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                    obj.CanTouch = false
                    obj.CanQuery = false
                end
            end)
        end
    end)
end)

-- ==========================================
-- 2. FUNGSI MESIN BOOST (VFX KILLER EDITION)
-- ==========================================
local currentMode = "None"

local function ApplyBoost(level)
    currentMode = level
    
    pcall(function() settings().Rendering.QualityLevel = 1 end)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    if Terrain then
        pcall(function() Terrain.Decoration = false end) 
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
    end

    task.spawn(function()
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if currentMode ~= level then break end 
            
            if (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")) then
                pcall(function() obj.Enabled = false end)
            end
            
            if obj:IsA("BasePart") then
                pcall(function()
                    if level == "High" or level == "Extreme" then
                        obj.CastShadow = false
                    end
                    if level == "Extreme" then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.Reflectance = 0
                    end
                end)
            elseif (obj:IsA("Decal") or obj:IsA("Texture")) and level == "Extreme" then
                pcall(function() obj.Transparency = 1 end)
            end
            
            count = count + 1
            if count >= 100 then 
                count = 0
                task.wait()
            end
        end
        
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
    end)
end

local function RestoreNormal()
    currentMode = "None"
    pcall(function() settings().Rendering.QualityLevel = 3 end)
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
-- 3. MENU TOGGLES (BEBAS DARI METATABLE)
-- ==========================================

UI.CreateToggle(
    Page, 
    "Medium Boost (PvP)", 
    "Matiin VFX skill & bayangan. Paling pas buat war!", 
    StateMed, 
    function(state)
        StateMed = state
        if state then ApplyBoost("Medium") else RestoreNormal() end
    end
)

UI.CreateToggle(
    Page, 
    "High Boost (Smooth)", 
    "Medium + Ilangin Skybox. Enteng gila!", 
    StateHigh, 
    function(state)
        StateHigh = state
        if state then ApplyBoost("High") else RestoreNormal() end
    end
)

UI.CreateToggle(
    Page, 
    "Extreme Boost (Potato)", 
    "Plastik polos, no texture! FPS dewa!", 
    StateExt, 
    function(state)
        StateExt = state
        if state then ApplyBoost("Extreme") else RestoreNormal() end
    end
)