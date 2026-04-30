-- [[ ==========================================
--      MODULE: FPS BOOSTER (GOD TIER V2)
--      Engine: Smart Optimization (No Stutter)
--    ========================================== ]]

local Workspace  = game:GetService("Workspace")
local Lighting   = game:GetService("Lighting")

while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do task.wait(0.1) end
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

-- Proteksi biar kagak error kalau Main.lua belum di update
if Settings.FPSBoost == nil then Settings.FPSBoost = false end

local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "EXTREME OPTIMIZATION")

-- Simpan Original State buat restore
local OrigShadows = Lighting.GlobalShadows
local OrigDiffuse = Lighting.EnvironmentDiffuseScale
local OrigSpecular = Lighting.EnvironmentSpecularScale
local OrigFogEnd = Lighting.FogEnd
local OrigStream = true
pcall(function() OrigStream = Workspace.StreamingIntegrityEnabled end)

local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local OrigTerrain = Terrain and {
    Deco = Terrain.Decoration,
    Wave = Terrain.WaterWaveSize,
    Speed = Terrain.WaterWaveSpeed,
    Reflect = Terrain.WaterReflectance
}

local cleanConnection = nil

-- ==========================================
-- 1. AUTO SCRIPT OPTIMIZER (Jalan Otomatis)
-- Ini ngurus memory biar script kagak makan RAM, grafik tetep HD!
-- ==========================================
task.spawn(function()
    while task.wait(30) do
        -- Bersihin memory Lua biar kagak numpuk sampah (Anti 3GB RAM)
        pcall(function() 
            if type(collectgarbage) == "function" then
                collectgarbage("step", 50)
            end
        end)
    end
end)

-- ==========================================
-- 2. PVP FPS BOOST TOGGLE
-- ==========================================
UI.CreateToggle(
    Page, 
    "PvP FPS Boost", 
    "Turunin grafik sedikit, FPS meroket tajam tanpa patah-patah!", 
    Settings.FPSBoost, 
    function(state)
        Settings.FPSBoost = state
        
        if state then
            -- =====================================
            -- ON: MODE PVP (GRAFIK SEDIKIT TURUN, FPS DEWA)
            -- =====================================
            
            -- 1. Matiin grafik berat secara instan (Kagak pake loop)
            pcall(function() settings().Rendering.QualityLevel = 1 end)
            Lighting.GlobalShadows = false
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.FogEnd = 9e9
            pcall(function() Workspace.StreamingIntegrityEnabled = false end)
            
            if Terrain then
                Terrain.Decoration = false
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
            end

            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then pcall(function() v.Enabled = false end) end
            end

            -- 2. SMART CLEANER (Anti Stutter/Lag)
            -- Gemini pake 1000 part/detik (PC drop). Gue pake 50 part/0.05 detik (Halus)!
            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    -- Kalau di-off in tengah jalan, langsung berhenti biar kagak ganggu
                    if not Settings.FPSBoost then break end 
                    
                    if obj:IsA("BasePart") then
                        pcall(function()
                            obj.CastShadow = false
                            -- Matiin sensor fisik buat benda mati biar CPU lega
                            if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                                obj.CanTouch = false
                                obj.CanQuery = false
                            end
                        end)
                    end
                    count = count + 1
                    if count >= 50 then 
                        count = 0 
                        task.wait(0.05) -- Jeda micro biar FPS kagak drop pas proses
                    end 
                end
            end)

            -- 3. Auto-Optimize part baru yang nongol pas main
            if cleanConnection then pcall(function() cleanConnection:Disconnect() end) end
            cleanConnection = Workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("BasePart") then
                    pcall(function()
                        obj.CastShadow = false
                        if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                            obj.CanTouch = false
                            obj.CanQuery = false
                        end
                    end)
                end
            end)

        else
            -- =====================================
            -- OFF: BALIKIN KE GRAFIK HD BAWAAN
            -- =====================================
            pcall(function() settings().Rendering.QualityLevel = 3 end)
            Lighting.GlobalShadows = OrigShadows
            Lighting.EnvironmentDiffuseScale = OrigDiffuse
            Lighting.EnvironmentSpecularScale = OrigSpecular
            Lighting.FogEnd = OrigFogEnd
            pcall(function() Workspace.StreamingIntegrityEnabled = OrigStream end)
            
            if Terrain and OrigTerrain then
                Terrain.Decoration = OrigTerrain.Deco
                Terrain.WaterWaveSize = OrigTerrain.Wave
                Terrain.WaterWaveSpeed = OrigTerrain.Speed
                Terrain.WaterReflectance = OrigTerrain.Reflect
            end

            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then pcall(function() v.Enabled = true end) end
            end
            
            if cleanConnection then 
                pcall(function() cleanConnection:Disconnect() end) 
                cleanConnection = nil 
            end

            -- Balikin part ke semula (Juga diurus pelan-pelan)
            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if Settings.FPSBoost then break end -- Berhenti kalo di-ON balik
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
                    if count >= 50 then count = 0 task.wait(0.05) end
                end
            end)
        end
    end
)