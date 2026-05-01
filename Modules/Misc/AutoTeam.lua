-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")
local VIM               = game:GetService("VirtualInputManager") -- FIX: Masukin VIM buat backup klik

-- // Variables
local Me = Players.LocalPlayer

-- // Framework Initialization
repeat
    task.wait(0.1)
-- FIX: Wajib nunggu SafeInvoke ke-load dari Core.lua biar kaga ghoib!
until _G.Cat 
    and _G.Cat.UI 
    and _G.Cat.Settings 
    and _G.Cat.SafeInvoke

local UI         = _G.Cat.UI
local Settings   = _G.Cat.Settings
local SafeInvoke = _G.Cat.SafeInvoke

-- ==========================================
-- 1. UI INITIALIZATION
-- ==========================================
local Page = UI.CreateTab("Misc", false)

UI.CreateToggle(
    Page,
    "Auto Team Marines",
    "Automatically picks Marines on join",
    Settings.AutoTeam or false,
    function(state)
        Settings.AutoTeam = state
        UI.SaveSettings()
    end
)

-- ==========================================
-- 2. INTERFACE SEARCHER
-- ==========================================
local function GetMarineButton()
    local playerGui = Me.PlayerGui

    for _, ui in ipairs(playerGui:GetDescendants()) do
        -- Cari Frame Pemilihan Tim
        local isChooseTeam = ui.Name == "ChooseTeam" and ui.Visible
        if not isChooseTeam then continue end

        local container = ui:FindFirstChild("Marines", true)
        if not container then continue end

        local btn = container:FindFirstChildWhichIsA("TextButton", true)
        if not btn then continue end

        -- Validasi ukuran biar ga klik tombol hantu
        local hasSize = btn.AbsoluteSize.X > 0
            and btn.AbsoluteSize.Y > 0

        if hasSize then
            return btn
        end
    end

    return nil
end

-- ==========================================
-- 3. MAIN EXECUTION HANDLER
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- Kondisi: Fitur Nyala & Belum Punya Tim
            local shouldProcess = Settings.AutoTeam
                and Me.Team == nil

            if shouldProcess then
                local targetBtn = GetMarineButton()

                if targetBtn then
                    -- // STEP 1: Remote Method (Fastest)
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local commF   = remotes and remotes:FindFirstChild("CommF_")

                    if commF then
                        SafeInvoke(commF, "SetTeam", "Marines")
                    end

                    task.wait(0.5)

                    -- // STEP 2: UI Fallback (Backup Pake VIM, 100% Works)
                    pcall(function()
                        local pos = targetBtn.AbsolutePosition
                        local size = targetBtn.AbsoluteSize
                        -- Validasi kaga diklik pas UI masih gerak/animasi loading
                        if size.X > 0 and size.Y > 0 then
                            local tx = pos.X + (size.X / 2)
                            local ty = pos.Y + (size.Y / 2) + 58
                            
                            VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                            task.wait(0.05)
                            VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                        end
                    end)

                    task.wait(1)

                    -- // STEP 3: Cleanup
                    if Me.Team ~= nil then
                        -- Tutup UI manual
                        local rootUI = targetBtn:FindFirstAncestor("ChooseTeam")
                        if rootUI then
                            rootUI.Visible = false
                        end

                        -- Reset Kamera
                        local camera = workspace.CurrentCamera
                        camera.CameraType = Enum.CameraType.Custom

                        local char = Me.Character
                        local hum  = char and char:FindFirstChild("Humanoid")
                        if hum then
                            camera.CameraSubject = hum
                        end
                        
                        -- FIX MUTLAK: Kasih jeda 3 detik biar semua UI Blox Fruits kelar loading animasinya.
                        -- Ini yang bikin lu kaga perlu repot-repot mancing buka Server List manual lagi!
                        task.wait(3)
                    end
                end
            end
        end)
    end
end)