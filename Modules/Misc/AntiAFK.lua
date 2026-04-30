-- [[ ==========================================
--      MODULE: MISC - ANTI-AFK & AUTO-TEAM (ZERO-LAG)
--    ========================================== ]]

local VirtualUser       = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local Me = Players.LocalPlayer

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings

local UI         = _G.Cat.UI
local Settings   = _G.Cat.Settings
local SafeInvoke = _G.Cat.SafeInvoke

-- ==========================================
-- 1. UI INITIALIZATION (MISC TAB)
-- ==========================================
-- Walaupun file beda, kalau namanya sama "Misc", UI bakal gabungin jadi 1 tab!
local Page = UI.CreateTab("Misc", false)

UI.CreateSection(Page, "AUTOMATION & PROTECTION")

if type(Settings.AntiAFK) ~= "boolean" then Settings.AntiAFK = true end
UI.CreateToggle(Page, "Anti AFK", "Prevents 20-minute idle kick", Settings.AntiAFK, function(state) 
    Settings.AntiAFK = state 
end)

if type(Settings.AutoTeam) ~= "boolean" then Settings.AutoTeam = false end
UI.CreateToggle(Page, "Auto Team Marines", "Automatically picks Marines on join", Settings.AutoTeam, function(state) 
    Settings.AutoTeam = state 
end)

-- ==========================================
-- 2. LOGIC: ANTI-IDLE SYSTEM
-- ==========================================
Me.Idled:Connect(function()
    if Settings.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- [[ ==========================================
--      3. LOGIC: SMART AUTO TEAM (NO UI SCANNING!)
--    ========================================== ]]
task.spawn(function()
    while task.wait(1.5) do -- Jeda 1.5 detik biar santai
        if Settings.AutoTeam and Me.Team == nil then
            pcall(function()
                -- 1. Langsung tembak Remote Server kaga usah klik UI!
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local commF   = remotes and remotes:FindFirstChild("CommF_")
                
                if commF then 
                    SafeInvoke(commF, "SetTeam", "Marines") 
                end
                
                task.wait(1)
                
                -- 2. Kalau berhasil masuk tim, bersihin layar
                if Me.Team ~= nil then
                    local playerGui = Me:FindFirstChild("PlayerGui")
                    if playerGui then
                        -- Langsung panggil foldernya, kaga usah GetDescendants()!
                        local chooseTeam = playerGui:FindFirstChild("ChooseTeam")
                        if chooseTeam then chooseTeam.Enabled = false end
                    end
                    
                    -- Balikin Kamera
                    local camera = workspace.CurrentCamera
                    camera.CameraType = Enum.CameraType.Custom
                    if Me.Character and Me.Character:FindFirstChild("Humanoid") then
                        camera.CameraSubject = Me.Character.Humanoid
                    end
                end
            end)
        end
    end
end)