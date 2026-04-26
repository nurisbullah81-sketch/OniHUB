-- CatHUB FREEMIUM: Farm Module (v6.1 - Bounty Fixed)
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
UI:CreateSwitch(FarmTab, "AutoSkill", "Use Skills (Z,X,C,V)")
UI:CreateSwitch(FarmTab, "BountyHunt", "Auto Bounty Hunt")
UI:CreateSwitch(FarmTab, "SafeMode", "Safe Mode (10% HP Escape)")

-- Bring Mob (Optional Anti-Cheat Bypass)
local BringMob = false

-- Fast Attack Logic
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoAttack and (UI.Settings.AutoFarm or UI.Settings.BountyHunt) then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(851, 158), game.Workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

-- Auto Skill Loop
task.spawn(function()
    local keys = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}
    while task.wait(0.8) do
        if UI.Settings.AutoSkill and (UI.Settings.AutoFarm or UI.Settings.BountyHunt) then
            pcall(function()
                for _, key in pairs(keys) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
            end)
        end
    end
end)

-- Health Safety (10% HP)
RunService.Heartbeat:Connect(function()
    if UI.Settings.SafeMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if hum.Health > 0 and hum.Health < (hum.MaxHealth * 0.1) then
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0)
                UI.Settings.AutoFarm = false
                UI.Settings.BountyHunt = false
                print("[CatHUB]: Critical HP! Evacuating to Sky.")
            end)
        end
    end
end)

local function GetNearestNPC()
    local target, dist = nil, math.huge
    pcall(function()
        for _, v in pairs(Workspace.Enemies:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                if v:FindFirstChild("HumanoidRootPart") then
                    local d = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then target, dist = v, d end
                end
            end
        end
    end)
    return target, dist
end

local function GetNearestPlayer()
    local target, dist = nil, math.huge
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if p.Character.Humanoid.Health > 0 then
                    local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then target, dist = p, d end
                end
            end
        end
    end)
    return target, dist
end

-- NPC Farm Loop
task.spawn(function()
    while task.wait(0.5) do
        if UI.Settings.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local npc, dist = GetNearestNPC()
                if npc and npc:FindFirstChild("HumanoidRootPart") and dist < 500 then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local targetPos = npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 3)
                    local distance = (targetPos.Position - hrp.Position).Magnitude
                    local speed = math.clamp(UI.Settings.Tween_Speed or 300, 100, 800)
                    
                    -- Face target
                    hrp.CFrame = CFrame.new(hrp.Position, npc.HumanoidRootPart.Position)
                    
                    -- Tween to target
                    if distance > 5 then
                        local tween = TweenService:Create(hrp, TweenInfo.new(distance/speed, Enum.EasingStyle.Linear), {CFrame = targetPos})
                        tween:Play()
                    end
                end
            end)
        end
    end
end)

-- Bounty Hunt Loop
task.spawn(function()
    while task.wait(0.5) do
        if UI.Settings.BountyHunt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local target, dist = GetNearestPlayer()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and dist < 1000 then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local targetPos = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    local distance = (targetPos.Position - hrp.Position).Magnitude
                    local speed = math.clamp(UI.Settings.Tween_Speed or 300, 100, 800)
                    
                    hrp.CFrame = CFrame.new(hrp.Position, target.Character.HumanoidRootPart.Position)
                    
                    if distance > 5 then
                        local tween = TweenService:Create(hrp, TweenInfo.new(distance/speed, Enum.EasingStyle.Linear), {CFrame = targetPos})
                        tween:Play()
                    end
                end
            end)
        end
    end
end)

print("[CatHUB]: Farm Module Loaded (v6.1).")