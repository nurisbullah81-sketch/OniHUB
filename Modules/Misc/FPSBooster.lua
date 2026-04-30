-- [[ ==========================================
--      MODULE: FPS BOOSTER (PVP MODE)
--      Status: Sedikit Burik, FPS Rata Kanan!
--    ========================================== ]]

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI

local Page = _G.Cat.UI.CreateTab("Misc", false)
_G.Cat.UI.CreateSection(Page, "EXTREME OPTIMIZATION")

-- Simpan settingan awal biar bisa di-Off-in
local Orig = {
    Diffuse = Lighting.EnvironmentDiffuseScale,
    Specular = Lighting.EnvironmentSpecularScale,
    Decoration = Terrain and Terrain.Decoration or true
}

_G.Cat.UI.CreateToggle(
    Page,
    "PvP FPS Boost (Medium)",
    "Grafik agak datar, rumput dicukur, FPS tembus langit!",
    false,
    function(state)
        if state then
            -- =====================================
            -- ON: MODE PVP (SEDITIK BURIK TAPI LANCAR)
            -- =====================================
            
            -- 1. Botakin Rumput 3D & Ratain Air
            if Terrain then
                Terrain.Decoration = false -- Rumput 3D ILANG! (Boost Tergede)
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
            end

            -- 2. Bikin Lighting Datar / Matte (Kaga ada pantulan HD)
            Lighting.GlobalShadows = false
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.FogEnd = 9e9

            -- 3. Matiin Efek Silau
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") and not v:IsA("ColorCorrectionEffect") then
                    v.Enabled = false
                end
            end

            -- 4. Optimasi CPU (Matiin Bayangan & Sensor Sentuh Benda Mati)
            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CastShadow = false
                        if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                            obj.CanTouch = false
                            obj.CanQuery = false
                        end
                    end
                    count = count + 1
                    if count >= 1000 then count = 0 task.wait() end
                end
                warn("✅ [CatHUB] PvP Boost ON! Siap Bantai-Bantai!")
            end)

        else
            -- =====================================
            -- OFF: BALIK KE GRAFIK BAWAAN
            -- =====================================
            if Terrain then
                Terrain.Decoration = Orig.Decoration
            end

            Lighting.GlobalShadows = true
            Lighting.EnvironmentDiffuseScale = Orig.Diffuse
            Lighting.EnvironmentSpecularScale = Orig.Specular
            Lighting.FogEnd = 2000

            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then v.Enabled = true end
            end

            task.spawn(function()
                local count = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CastShadow = true
                        if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                            obj.CanTouch = true
                            obj.CanQuery = true
                        end
                    end
                    count = count + 1
                    if count >= 1000 then count = 0 task.wait() end
                end
            end)
        end
    end
)