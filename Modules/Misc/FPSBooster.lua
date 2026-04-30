-- [[ ==========================================
--      MODULE: FPS BOOSTER (ULTRA STEALTH V3)
--      Status: Grafik 100% HD, Daleman Mesin Dibongkar
--    ========================================== ]]

local Workspace = game:GetService("Workspace")

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI

local Page = _G.Cat.UI.CreateTab("Misc", false)
_G.Cat.UI.CreateSection(Page, "EXTREME OPTIMIZATION")

_G.Cat.UI.CreateToggle(
    Page,
    "Stealth FPS Boost",
    "FPS Meroket, Grafik Tetep Cakep 100%!",
    false,
    function(state)
        if state then
            -- =====================================
            -- ON: OPERASI SILUMAN (NO BURIK-BURIK CLUB)
            -- =====================================
            task.spawn(function()
                local count = 0
                -- Kita obrak-abrik isi map, tapi kaga nyentuh efek cahaya Lighting!
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        -- 1. Bunuh Bayangan Detail (GPU Lega, Visual Tetap Terang)
                        obj.CastShadow = false

                        -- 2. Bunuh Sensor Fisika (CPU Super Lega)
                        -- Kalau benda ini diem (Anchored) dan bukan NPC/Player, matiin sensor sentuhnya!
                        if obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
                            obj.CanTouch = false
                            obj.CanQuery = false
                        end
                    end
                    
                    -- Jeda per 1000 part biar game lu kaga freeze pas tombol ini dipencet
                    count = count + 1
                    if count >= 1000 then
                        count = 0
                        task.wait()
                    end
                end
                warn("✅ [CatHUB] Stealth Boost ON! Grafik HD, FPS Dewa!")
            end)
        else
            -- =====================================
            -- OFF: BALIKIN KE NORMAL
            -- =====================================
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
                    if count >= 1000 then
                        count = 0
                        task.wait()
                    end
                end
            end)
        end
    end
)