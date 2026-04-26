-- CatHUB FREEMIUM: Farm Module (v6.0)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local FarmTab = UI:CreateTab("Auto Farm")
UI:CreateSwitch(FarmTab, "AutoFarm", "Auto Farm NPC")
UI:CreateSwitch(FarmTab, "AutoAttack", "Fast Smooth Attack")
UI:CreateSwitch(FarmTab, "AutoSkill", "Use Skills (Z,X,C,V,1-4)")
UI:CreateSwitch(FarmTab, "BountyHunt", "Auto Bounty (Nearest Player)")
UI:CreateSwitch(FarmTab, "SafeMode", "Safe Mode (10% HP Escape)")

-- Fast Attack Logic
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoAttack and UI.Settings.AutoFarm then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(851, 158), game.Workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

-- Auto Skill Loop
task.spawn(function()
    local keys = {"Z", "X", "C", "V", "One", "Two", "Three", "Four"}
    while task.wait(0.5) do
        if UI.Settings.AutoSkill and (UI.Settings.AutoFarm or UI.Settings.BountyHunt) then
            for _, key in pairs(keys) do
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
            end
        end
    end
end)

-- Health Safety (10% HP)
RunService.Heartbeat:Connect(function()
    if UI.Settings.SafeMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if hum.Health > 0 and hum.Health < (hum.MaxHealth * 0.1) then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0)
            UI.Settings.AutoFarm = false
            UI.Settings.BountyHunt = false
            print("[CatHUB]: Critical HP! Evacuating to Sky.")
        end
    end
end)

local function GetNearestNPC()
    local target, dist = nil, math.huge
    for _, v in pairs(Workspace.Enemies:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local d = (v.PrimaryPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then target, dist = v, d end
        end
    end
    return target
end

-- Farm Loop
task.spawn(function()
    while task.wait(1) do
        if UI.Settings.AutoFarm then
            local npc = GetNearestNPC()
            if npc and npc.PrimaryPart then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local tInfo = TweenInfo.new((npc.PrimaryPart.Position - hrp.Position).Magnitude/300, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(hrp, tInfo, {CFrame = npc.PrimaryPart.CFrame * CFrame.new(0, 5, 0)})
                tween:Play()
                tween.Completed:Wait()
            end
        end
    end
end)