-- [[ ==========================================
--      MODULE: FPS BOOSTER (MULTI-TIER DEWA)
--      Status: Fix Crash Terrain & 3 Mode Boost
--    ========================================== ]]

local Workspace  = game:GetService("Workspace")
local Lighting   = game:GetService("Lighting")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI

local UI = _G.Cat.UI
local Page = UI.CreateTab("Misc", false)

UI.CreateSection(Page, "FPS OPTIMIZER (PILIH SALAH SATU)")

local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Simpan state original buat Lighting aja (Texture kaga disimpen biar hemat RAM)
local OrigLighting = {
    Shadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd
}

-- // FUNGSI INTI MESIN PENGHANCUR LAG
local function ApplyBoost(level)
    task.spawn(function()
        -- 1. Optimasi Instan (Jalan di Semua Level)
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        
        if Terrain then
            -- FIX MUTLAK: Pake pcall biar kaga crash kayak script z.ai!
            pcall(function() Terrain.Decoration = false end) 
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
        end

        -- 2. Operasi Pembersihan Map (Background Task)
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                -- Bunuh sensor sentuh benda mati (Bikin CPU super lega)
                if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                    obj.CanTouch = false
                    obj.CanQuery = false
                end
                
                -- Level High & Extreme: Hapus semua bayangan mikro
                if level == "High" or level == "Extreme" then
                    obj.CastShadow = false
                end

                -- Level Extreme: Ubah semua jadi plastik polos (Burik Parah)
                if level == "Extreme" then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                end
                
            -- Level Extreme: Hapus semua stiker & tekstur HD
            elseif (obj:IsA("Decal") or obj:IsA("Texture")) and level == "Extreme" then
                obj.Transparency = 1
            end
            
            -- Kasih napas CPU biar kaga freeze pas proses ribuan part
            count = count + 1
            if count >= 500 then
                count = 0
                task.wait()
            end
        end
        warn("✅ [CatHUB] " .. level .. " Boost Berhasil Diaktifkan!")
    end)
end

local function RestoreNormal()
    pcall(function() settings().Rendering.QualityLevel = 3 end)
    Lighting.GlobalShadows = OrigLighting.Shadows
    Lighting.FogEnd = OrigLighting.FogEnd
    -- Catatan: Mode Extreme kaga bisa balikin tekstur tanpa rejoin (Biar RAM kaga jebol)
end

-- ==========================================
-- MENU TOGGLES
-- ==========================================

UI.CreateToggle(
    Page, 
    "1. Medium Boost (PvP Mode)", 
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
    "3. Extreme Boost (Burik Parah)", 
    "Plastik semua, no texture! FPS dewa! (Rejoin buat normalin)", 
    false, 
    function(state)
        if state then ApplyBoost("Extreme") else RestoreNormal() end
    end
)