-- [[ ==========================================
--      MODULE: FPS BOOSTER (GOD TIER V5)
--      Engine: Silent Optimizer + 3 Mode Boost
--    ========================================== ]]

local Workspace  = game:GetService("Workspace")
local Lighting   = game:GetService("Lighting")
local RunService = game:GetService("RunService")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "FPS OPTIMIZER (PILIH SALAH SATU)")

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Simpan original state
local OrigLighting = {
    Shadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    QualityLevel = 3
}
pcall(function() OrigLighting.QualityLevel = settings().Rendering.QualityLevel end)

local OrigTerrain = {}
if Terrain then
    OrigTerrain.Deco = Terrain.Decoration
    OrigTerrain.Wave = Terrain.WaterWaveSize
    OrigTerrain.Speed = Terrain.WaterWaveSpeed
    OrigTerrain.Reflect = Terrain.WaterReflectance
end

-- ==========================================
-- 1. SILENT AUTO-OPTIMIZER (Jalan Otomatis Di Latar Belakang)
-- Ini kagak ngurus bayangan/material (grafik tetep HD). Cuma matiin sensor fisik benda mati biar CPU lega!
-- ==========================================
task.spawn(function()
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
        -- Pake 30 part/detik. Pelan tapi pasti, kagak bakin stutter seperti code z.ai
        if count >= 30 then 
            count = 0 
            task.wait(0.1) 
        end
    end
end)

-- Auto-optimize part baru yang masuk map
Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.5) -- Jeda biar kagak langsung beratin
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
-- 2. FUNGSI MESIN BOOST
-- ==========================================
local currentMode = "None"

local function ApplyBoost(level)
    currentMode = level
    
    -- 1. Optimasi Instan (Lighting & Air)
    pcall(function() settings().Rendering.QualityLevel = 1 end)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    if Terrain then
        pcall(function() Terrain.Decoration = false end) -- Anti Crash
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
    end

    -- 2. Operasi Pembersihan Map (Background Task)
    task.spawn(function()
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            -- Berhenti kalau ganti mode atau di-off
            if currentMode ~= level then break end 
            
            if obj:IsA("BasePart") then
                pcall(function()
                    -- Matiin sensor fisik benda mati
                    if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                        obj.CanTouch = false
                        obj.CanQuery = false
                    end
                    
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
            if count >= 30 then
                count = 0
                task.wait(0.1) -- Jeda biar kagak freeze
            end
        end
    end)
end

local function RestoreNormal()
    currentMode = "None"
    pcall(function() settings().Rendering.QualityLevel = OrigLighting.QualityLevel end)
    Lighting.GlobalShadows = OrigLighting.Shadows
    Lighting.FogEnd = OrigLighting.FogEnd
    
    if Terrain then
        pcall(function() Terrain.Decoration = OrigTerrain.Deco end)
        pcall(function() Terrain.WaterWaveSize = OrigTerrain.Wave end)
        pcall(function() Terrain.WaterWaveSpeed = OrigTerrain.Speed end)
        pcall(function() Terrain.WaterReflectance = OrigTerrain.Reflect end)
    end
end

-- ==========================================
-- 3. MENU TOGGLES
-- ==========================================

UI.CreateToggle(
    Page, 
    "1. Medium Boost (PvP)", 
    "Turunin grafik ringan, air rata, no shadow. Cocok buat PvP.", 
    false, 
    function(state)
        if state then ApplyBoost("Medium") else RestoreNormal() end
    end
)

UI.CreateToggle(
    Page, 
    "2. High Boost (Smooth)", 
    "Hapus SEMUA bayangan detail part. Super enteng!", 
    false, 
    function(state)
        if state then ApplyBoost("High") else RestoreNormal() end
    end
)

UI.CreateToggle(
    Page, 
    "3. Extreme Boost (Burik)", 
    "Plastik semua, no texture! FPS dewa! (Rejoin buat normalin)", 
    false, 
    function(state)
        if state then ApplyBoost("Extreme") else RestoreNormal() end
    end
)