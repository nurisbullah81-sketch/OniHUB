-- CatHUB FREEMIUM: Farm Module (v7.0)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local FarmTab = UI:CreateTab("Auto Farm")
UI:CreateSwitch(FarmTab, "AutoFarm", "Auto Farm NPC")
UI:CreateSwitch(FarmTab, "AutoAttack", "Fast High Speed Attack")
UI:CreateSwitch(FarmTab, "AutoSkill", "Auto Skills (Z,X,C,V,1-4)")
UI:CreateSwitch(FarmTab, "SafeMode", "Safety 10% HP Escape")

-- Fast Attack (Optimized Clicker)
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoAttack and UI.Settings.AutoFarm then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)

-- Skills Engine
task.spawn(function()
    local keys = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}
    while task.wait(0.3) do
        if UI.Settings.AutoSkill and UI.Settings.AutoFarm then
            for _, k in pairs(keys) do
                VIM:SendKeyEvent(true, k, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, k, false, game)
            end
        end
    end
end)

-- Safe Escape Logic
task.spawn(function()
    while task.wait(0.1) do
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if UI.Settings.SafeMode and hum and hum.Health > 0 and hum.Health < (hum.MaxHealth * 0.1) then
            UI.Settings.AutoFarm = false
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10000, 0)
            print("[CatHUB]: Danger! Teleporting to Safe Sky.")
        end
    end
end)

local function GetNearestNPC()
    local t, d = nil, math.huge
    for _, v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local dist = (v.PrimaryPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < d then t, d = v, dist end
        end
    end
    return t
end

-- Farm Tween Engine (Above NPC Logic)
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoFarm then
            local npc = GetNearestNPC()
            if npc and npc.PrimaryPart then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                -- Terbang 25 stud di atas NPC
                local targetPos = npc.PrimaryPart.CFrame * CFrame.new(0, 25, 0)
                local dist = (targetPos.Position - hrp.Position).Magnitude
                
                -- Smooth High Speed Tween
                local t = TweenService:Create(hrp, TweenInfo.new(dist/300, Enum.EasingStyle.Linear), {CFrame = targetPos})
                t:Play()
                
                -- Noclip while farming
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
        end
    end
end)