-- [[ ==========================================
--      MODULE: FPS BOOSTER (GOD TIER)
--      Engine: Smart Optimization (No Freeze)
--    ========================================== ]]

local Lighting   = game:GetService("Lighting")
local Workspace  = game:GetService("Workspace")

while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do task.wait(0.1) end
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "EXTREME OPTIMIZATION")

-- Simpan settingan awal biar bisa di-Off-in
local Orig = {
    Diffuse = Lighting.EnvironmentDiffuseScale,
    Specular = Lighting.EnvironmentSpecularScale,
    Shadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    QualityLevel = 3,
    PostEffects = {}
}

pcall(function() Orig.QualityLevel = settings().Rendering.QualityLevel end)

for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        Orig.PostEffects[v] = v.Enabled
    end
end

local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local OrigTerrain = {}
if Terrain then
    OrigTerrain.Decoration = Terrain.Decoration
    OrigTerrain.WaterWaveSize = Terrain.WaterWaveSize
    OrigTerrain.WaterWaveSpeed = Terrain.WaterWaveSpeed
    OrigTerrain.WaterReflectance = Terrain.WaterReflectance
end

local optimizationConnection = nil

UI.CreateToggle(
    Page,
    "PvP FPS Boost",
    "Hilangkan lag PVP tanpa freeze! (Optimasi Cerdas)",
    Settings.FPSBoost,
    function(state)
        Settings.FPSBoost = state
        
        if state then
            -- =====================================
            -- ON: MODE PVP (SMART OPTIMIZATION)
            -- =====================================
            
            -- 1. Matiin Grafik Berat Instan (Tanpa Loop)
            pcall(function() settings().Rendering.QualityLevel = 1 end)
            Lighting.GlobalShadows = false
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.FogEnd = 9e9
            
            if Terrain then
                Terrain.Decoration = false
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
            end

            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then v.Enabled = false end
            end

            -- 2. Matiin Batas Streaming (Buat PC Kuat)
            pcall(function() Workspace.StreamingIntegrityEnabled = false end)

            -- 3. SMART CLEANER (Ini Rahasianya biar kagak freeze)
            -- Gemini pake 1000 per detik (berat), gue pake 200 per 0.1 detik (halus)
            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not Settings.FPSBoost then break end 
                    
                    if obj:IsA("BasePart") then
                        obj.CastShadow = false
                        if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                            obj.CanTouch = false
                            obj.CanQuery = false
                        end
                    end
                    count = count + 1
                    if count >= 200 then 
                        count = 0 
                        task.wait(0.1)
                    end 
                end
            end)

            -- 4. Auto-Optimize part baru yang nongol pas main
            if optimizationConnection then optimizationConnection:Disconnect() end
            optimizationConnection = Workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("BasePart") then
                    obj.CastShadow = false
                    if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                        obj.CanTouch = false
                        obj.CanQuery = false
                    end
                end
            end)

        else
            -- =====================================
            -- OFF: BALIK KE GRAFIK BAWAAN
            -- =====================================
            pcall(function() settings().Rendering.QualityLevel = Orig.QualityLevel end)
            Lighting.GlobalShadows = Orig.Shadows
            Lighting.EnvironmentDiffuseScale = Orig.Diffuse
            Lighting.EnvironmentSpecularScale = Orig.Specular
            Lighting.FogEnd = Orig.FogEnd
            
            if Terrain then
                Terrain.Decoration = OrigTerrain.Decoration
                Terrain.WaterWaveSize = OrigTerrain.WaterWaveSize
                Terrain.WaterWaveSpeed = OrigTerrain.WaterWaveSpeed
                Terrain.WaterReflectance = OrigTerrain.WaterReflectance
            end

            for v, origState in pairs(Orig.PostEffects) do
                if v and v.Parent then v.Enabled = origState end
            end
            
            if optimizationConnection then
                optimizationConnection:Disconnect()
                optimizationConnection = nil
            end

            -- Balikin part ke semula
            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if Settings.FPSBoost then break end
                    if obj:IsA("BasePart") then
                        obj.CastShadow = true
                        if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                            obj.CanTouch = true
                            obj.CanQuery = true
                        end
                    end
                    count = count + 1
                    if count >= 200 then count = 0 task.wait(0.1) end
                end
            end)
        end
    end
)