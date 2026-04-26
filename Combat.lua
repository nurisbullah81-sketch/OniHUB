-- CatHUB FREEMIUM: Combat Module
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local LockedTarget = nil
local currentTween = nil

local function IsEnemy(p)
    if not p or p == LocalPlayer or not p.Character then return false end
    if LocalPlayer.Team and p.Team and LocalPlayer.Team == p.Team then
        if tostring(LocalPlayer.Team) == "Marines" then return false end
    end
    if LocalPlayer:IsFriendsWith(p.UserId) then return false end
    return true
end

local function GetTarget()
    local t, sd = nil, 150
    for _, p in pairs(Players:GetPlayers()) do
        if IsEnemy(p) and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if d < sd then t, sd = p, d end
            end
        end
    end
    return t
end

RunService.RenderStepped:Connect(function()
    if UI.Settings.LockAim_Enabled then
        if not LockedTarget or not LockedTarget.Character or LockedTarget.Character.Humanoid.Health <= 0 then
            LockedTarget = GetTarget()
        end
        if LockedTarget then Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockedTarget.Character.HumanoidRootPart.Position) end
    else LockedTarget = nil end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local H, RP = LocalPlayer.Character.Humanoid, LocalPlayer.Character.HumanoidRootPart
        if UI.Settings.AntiStun_Enabled then
            H.PlatformStand = false H.Sit = false
            if H:GetState() == Enum.HumanoidStateType.Physics then H:ChangeState("GettingUp") end
        end
        if UI.Settings.FastRun_Enabled then H.WalkSpeed = UI.Settings.Run_Speed end
        if UI.Settings.HighJump_Enabled then H.JumpPower = UI.Settings.Jump_Power H.UseJumpPower = true end
        
        if UI.Settings.Tween_Enabled then
            RP.Anchored = false
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

local function TweenTo(target)
    if not UI.Settings.Tween_Enabled or not target then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local dist = (target:GetModelCFrame().Position - hrp.Position).Magnitude
    if dist < 10 then return end
    if currentTween then currentTween:Cancel() end
    currentTween = TweenService:Create(hrp, TweenInfo.new(dist/UI.Settings.Tween_Speed, Enum.EasingStyle.Linear), {CFrame = target:GetModelCFrame()})
    currentTween:Play()
end

task.spawn(function()
    local pvp = UI:CreateTab("PVP Elite")
    UI:CreateSwitch(pvp, "LockAim_Enabled", "Smart Aim Lock")
    UI:CreateSwitch(pvp, "AntiStun_Enabled", "Anti-Stun Override")
    UI:CreateSwitch(pvp, "FastRun_Enabled", "God Speed")
    UI:CreateSlider(pvp, "Run_Speed", "Speed Value", 16, 1000)
    UI:CreateSwitch(pvp, "HighJump_Enabled", "High Jump")
    UI:CreateSlider(pvp, "Jump_Power", "Jump Value", 50, 500)
    UI:CreateSwitch(pvp, "WalkWater_Enabled", "Walk On Water")

    local finder = UI:CreateTab("Fruits Finder")
    UI:CreateSwitch(finder, "ESP_Enabled", "Fruit ESP")
    UI:CreateSwitch(finder, "Tween_Enabled", "Auto Tween Fruit")
    UI:CreateSwitch(finder, "AutoStore", "Auto Store")
end)

task.spawn(function()
    while task.wait(1) do
        if UI.Settings.Tween_Enabled then
            for _, v in pairs(Workspace:GetChildren()) do
                if (v:IsA("Tool") and v.Name:lower():find("fruit")) or (v:IsA("Model") and v.Name == "Fruit ") then TweenTo(v) end
            end
        end
    end
end)