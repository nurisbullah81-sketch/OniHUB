-- CatHUB FREEMIUM: Combat Module (v5.0 Fix)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local LockedTarget = nil

local function IsEnemy(p)
    if not p or p == LocalPlayer or not p.Character or p.Character.Humanoid.Health <= 0 then return false end
    if p.Team == LocalPlayer.Team and tostring(p.Team) == "Marines" then return false end
    if LocalPlayer:IsFriendsWith(p.UserId) then return false end
    return true
end

local function GetTarget()
    local target, dist = nil, 180
    for _, p in pairs(Players:GetPlayers()) do
        if IsEnemy(p) and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mDist < dist then target, dist = p, mDist end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if UI.Settings.LockAim_Enabled then
        if not LockedTarget or not IsEnemy(LockedTarget) then LockedTarget = GetTarget() end
        if LockedTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockedTarget.Character.HumanoidRootPart.Position)
        end
    else LockedTarget = nil end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local H = LocalPlayer.Character.Humanoid
        if UI.Settings.AntiStun_Enabled then
            H.PlatformStand = false H.Sit = false
            if H:GetState() == Enum.HumanoidStateType.Physics then H:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end
        if UI.Settings.FastRun_Enabled then H.WalkSpeed = UI.Settings.Run_Speed end
        if UI.Settings.HighJump_Enabled then H.JumpPower = UI.Settings.Jump_Power H.UseJumpPower = true end
        
        if UI.Settings.Tween_Enabled or _G.CatHUB_TPing then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

task.spawn(function()
    local pvp = UI:CreateTab("PVP Elite")
    UI:CreateSwitch(pvp, "LockAim_Enabled", "Smart Aim Lock")
    UI:CreateSwitch(pvp, "AntiStun_Enabled", "Anti-Stun Override")
    UI:CreateSwitch(pvp, "FastRun_Enabled", "Enable God Speed")
    UI:CreateSlider(pvp, "Run_Speed", "Speed Value", 16, 1000)
    UI:CreateSwitch(pvp, "HighJump_Enabled", "Enable High Jump")
    UI:CreateSlider(pvp, "Jump_Power", "Jump Value", 50, 500)
    
    local finder = UI:CreateTab("Finder")
    UI:CreateSwitch(finder, "ESP_Enabled", "Fruit ESP")
    UI:CreateSwitch(finder, "PlayerESP_Enabled", "Player ESP (Team Color)")
    UI:CreateSwitch(finder, "AutoStore", "Auto Store Fruit")
end)