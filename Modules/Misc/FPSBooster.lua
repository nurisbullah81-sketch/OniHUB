-- [[ ==========================================
--      MODULE: FPS BOOSTER (GOD TIER V3)
--      Engine: Slow-Scan Background Optimizer
--    ========================================== ]]

local Lighting  = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do task.wait(0.1) end
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

-- SUPER OBAT: Pastiin variable ini boolean biar toggle kagak error
if type(Settings.FPSBoost) ~= "boolean" then
    Settings.FPSBoost = false
end

local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "EXTREME OPTIMIZATION")

-- Simpan Original State
local Orig = {
    Shadows = Lighting.GlobalShadows,
    QualityLevel = 3,
    FogEnd = Lighting.FogEnd,
}
pcall(function() Orig.QualityLevel = settings().Rendering.QualityLevel end)

local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local OrigTerrain = Terrain and {
    Deco = Terrain.Decoration,
    Wave = Terrain.WaterWaveSize,
    Speed = Terrain.WaterWaveSpeed,
    Reflect = Terrain.WaterReflectance
}

-- State buat nge-stop loop di background
local isBoosting = false
local descendantConn = nil

UI.CreateToggle(
    Page, 
    "God Tier FPS Boost", 
    "Optimasi Super Berat di Background (Tunggu 1-2 Menit, FX Aman!)", 
    Settings.FPSBoost == true, 
    function(state)
        Settings.FPSBoost = state
        isBoosting = state
        
        if state then
            -- =====================================
            -- ON: MODE PVP (Instant Render + Slow CPU Boost)
            -- =====================================
            
            -- 1. Instant Boost (Matiin Bayangan & Air)
            pcall(function() settings().Rendering.QualityLevel = 1 end)
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9 -- Ilangin kabut jauh biar GPU lega
            
            if Terrain then
                Terrain.Decoration = false
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
            end

            -- KAGAK SENTUH PostEffects (Bloom, SunRays tetep nyala biar kagak jelek!)

            -- 2. Slow Background Optimizer (20 part per detik, kagak freeze!)
            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    -- Kalau di-off in tengah jalan, langsung berhenti
                    if not isBoosting then break end 
                    
                    if obj:IsA("BasePart") then
                        pcall(function()
                            obj.CastShadow = false
                            -- Matiin fisik benda mati biar CPU super lega
                            if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                                obj.CanTouch = false
                                obj.CanQuery = false
                            end
                        end)
                    end
                    count = count + 1
                    if count >= 20 then 
                        count = 0 
                        task.wait(0.1) -- Jeda stabil biar kagak stutter
                    end 
                end
            end)

            -- 3. Auto-Optimize part baru yang nongol
            if descendantConn then descendantConn:Disconnect() end
            descendantConn = Workspace.DescendantAdded:Connect(function(obj)
                if isBoosting and obj:IsA("BasePart") then
                    task.spawn(function()
                        task.wait(0.5) -- Jeda biar kagak langsung beratin
                        if isBoosting then
                            pcall(function()
                                obj.CastShadow = false
                                if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                                    obj.CanTouch = false
                                    obj.CanQuery = false
                                end
                            end)
                        end
                    end)
                end
            end)

        else
            -- =====================================
            -- OFF: BALIKIN KE HD BAWAAN
            -- =====================================
            
            -- 1. Balikin Instant Render
            pcall(function() settings().Rendering.QualityLevel = Orig.QualityLevel end)
            Lighting.GlobalShadows = Orig.Shadows
            Lighting.FogEnd = Orig.FogEnd
            
            if Terrain then
                Terrain.Decoration = OrigTerrain.Deco
                Terrain.WaterWaveSize = OrigTerrain.Wave
                Terrain.WaterWaveSpeed = OrigTerrain.Speed
                Terrain.WaterReflectance = OrigTerrain.Reflect
            end

            -- 2. Stop Background Optimizer
            if descendantConn then descendantConn:Disconnect(); descendantConn = nil end

            -- 3. Slow Revert (Balikin part pelan-pelan biar kagak freeze)
            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if isBoosting then break end -- Berhenti kalau di-ON balik
                    if obj:IsA("BasePart") then
                        pcall(function()
                            obj.CastShadow = true
                            if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                                obj.CanTouch = true
                                obj.CanQuery = true
                            end
                        end)
                    end
                    count = count + 1
                    if count >= 20 then count = 0 task.wait(0.1) end
                end
            end)
        end
    end
)