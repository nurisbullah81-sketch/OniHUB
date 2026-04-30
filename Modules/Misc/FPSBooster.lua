-- [[ ==========================================
--      MODULE: FPS BOOSTER (STEALTH OPTIMIZER)
--      Engine: Smart Background & PVP Mode
--    ========================================== ]]

local Workspace  = game:GetService("Workspace")
local Lighting   = game:GetService("Lighting")
local RunService = game:GetService("RunService")

while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do task.wait(0.1) end
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

-- OBAT UI HILANG: Pastiin setting ada biar toggle kagak error
if Settings.FPSBoost == nil then 
    Settings.FPSBoost = false 
end

local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "EXTREME OPTIMIZATION")

-- ==========================================
-- 1. SISTEM SILUMAN (Jalan Otomatis Tanpa Ngurangin Grafik)
-- Ini ngurus script internal biar kagak makan RAM dan ngurus Roblox agar kagak stutter
-- ==========================================
task.spawn(function()
    -- A. Matiin Streaming Integrasi Roblox (Biar kagak patah-patah pas teleport/hop)
    pcall(function() Workspace.StreamingIntegrityEnabled = false end)
    
    -- B. Batasin Quality Level ke 3 (Medium-High) biar kagak ada spike aneh
    -- Kita kagak set ke 1, biar grafik tetep HD sebelum tombol dipencet
    pcall(function() 
        if settings().Rendering.QualityLevel > 3 then
            settings().Rendering.QualityLevel = 3 
        end
    end)

    -- C. Bersihin Memory Lua tiap 30 detik (Anti 3GB RAM seperti di screenshot lu)
    while task.wait(30) do
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
local optimizationConnection = nil

UI.CreateToggle(
    Page, 
    "PvP FPS Boost", 
    "Kurangi beban CPU & Bayangan, FX tetap aman!", 
    Settings.FPSBoost, 
    function(state)
        Settings.FPSBoost = state
        
        if state then
            -- =====================================
            -- ON: MODE PVP (Bayangan Sedikit Kurang, CPU Lega)
            -- =====================================
            
            -- 1. Turunin Quality Level ke 1 (Paling ringan tapi FX tetep nyala)
            pcall(function() settings().Rendering.QualityLevel = 1 end)
            
            -- 2. Matiin Bayangan Global (Ini yang paling makan GPU)
            Lighting.GlobalShadows = false
            
            -- 3. Kita KAGAK sentuh PostEffects (Bloom, SunRays tetep nyala biar kagak jelek!)
            -- Kita KAGAK ubah FogEnd biar cahaya alami tetep ada.
            
            -- 4. Smart Cleaner (Ngurus bayangan & fisik benda mati pelan-pelan)
            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not Settings.FPSBoost then break end 
                    
                    if obj:IsA("BasePart") then
                        pcall(function()
                            obj.CastShadow = false
                            -- Matiin sensor fisik buat benda mati biar CPU super lega
                            if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                                obj.CanTouch = false
                                obj.CanQuery = false
                            end
                        end)
                    end
                    count = count + 1
                    if count >= 50 then 
                        count = 0 
                        task.wait(0.05) -- Jeda biar kagak stutter
                    end 
                end
            end)

            -- 5. Auto-Optimize part baru yang nongol pas main
            if optimizationConnection then pcall(function() optimizationConnection:Disconnect() end) end
            optimizationConnection = Workspace.DescendantAdded:Connect(function(obj)
                task.wait(0.1) -- Jeda biar kagak langsung beratin pas spawn
                if obj:IsA("BasePart") and Settings.FPSBoost then
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
            -- Balikin Quality Level ke 3
            pcall(function() settings().Rendering.QualityLevel = 3 end)
            
            -- Balikin Bayangan
            Lighting.GlobalShadows = true

            if optimizationConnection then 
                pcall(function() optimizationConnection:Disconnect() end) 
                optimizationConnection = nil 
            end

            -- Balikin part ke semula (Pelan-pelan juga biar kagak freeze)
            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if Settings.FPSBoost then break end -- Berhenti kalau di-ON balik
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