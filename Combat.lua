-- CatHUB FREEMIUM: Combat & Mobility Module
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local LockedTarget = nil

-- Smart Filter
local function IsEnemy(p)
    if not p or p == LocalPlayer or not p.Character then return false end
    if LocalPlayer.Team and p.Team and LocalPlayer.Team == p.Team then
        if tostring(LocalPlayer.Team) == "Marines" then return false end
    end
    if LocalPlayer:IsFriendsWith(p.UserId) then return false end
    return true
end

local function GetTarget()
    local t, sd = nil, 200
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

-- Combat Loop
RunService.RenderStepped:Connect(function()
    if UI.Settings.LockAim_Enabled then
        if not LockedTarget or not LockedTarget.Character or LockedTarget.Character.Humanoid.Health <= 0 then
            LockedTarget = GetTarget()
        end
        if LockedTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockedTarget.Character.HumanoidRootPart.Position)
        end
    else LockedTarget = nil end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local H, RP = LocalPlayer.Character.Humanoid, LocalPlayer.Character.HumanoidRootPart
        if UI.Settings.AntiStun_Enabled then
            H.PlatformStand = false
            H.Sit = false
            if H:GetState() == Enum.HumanoidStateType.Physics then H:ChangeState("GettingUp") end
        end
        if UI.Settings.FastRun_Enabled then H.WalkSpeed = UI.Settings.Run_Speed end
        if UI_Module.Settings.HighJump_Enabled then H.JumpPower = UI.Settings.Jump_Power H.UseJumpPower = true end
        
        -- Tween Noclip Fix
        if UI.Settings.Tween_Enabled then
            RP.Anchored = false
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- Tween Function
local function TweenTo(target)
    if not UI.Settings.Tween_Enabled or not target then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local dist = (target:GetModelCFrame().Position - hrp.Position).Magnitude
    if dist < 10 then return end
    
    local tween = TweenService:Create(hrp, TweenInfo.new(dist/UI.Settings.Tween_Speed, Enum.EasingStyle.Linear), {CFrame = target:GetModelCFrame()})
    tween:Play()
    task.spawn(function()
        while UI.Settings.Tween_Enabled and target:IsDescendantOf(Workspace) and (target:GetModelCFrame().Position - hrp.Position).Magnitude > 5 do task.wait() end
        tween:Cancel()
    end)
end

-- Tab Setup (In UI.lua but logic here)
task.spawn(function()
    local pvp = UI:CreateTab("PVP Elite")
    UI:CreateSwitch(pvp, "LockAim_Enabled", "Smart Sticky Aim")
    UI:CreateSwitch(pvp, "AntiStun_Enabled", "Anti-Stun Override")
    UI:CreateSwitch(pvp, "PlayerESP_Enabled", "Player ESP")
    UI:CreateSwitch(pvp, "WalkWater_Enabled", "Walk On Water")
    UI:CreateSwitch(pvp, "FastRun_Enabled", "Enable Speed")
    UI:CreateSlider(pvp, "Run_Speed", "Speed Value", 16, 250)
    UI:CreateSwitch(pvp, "HighJump_Enabled", "Enable High Jump")
    UI:CreateSlider(pvp, "Jump_Power", "Jump Value", 50, 300)

    local finder = UI:CreateTab("Fruits Finder")
    UI:CreateSwitch(finder, "ESP_Enabled", "Fruit ESP")
    UI:CreateSwitch(finder, "Tween_Enabled", "Auto Tween Fruit")
    UI:CreateSwitch(finder, "AutoStore", "Auto Store")
    
    local set = UI:CreateTab("Setting")
    UI:CreateSlider(set, "Tween_Speed", "Tween Speed", 100, 500)
end)