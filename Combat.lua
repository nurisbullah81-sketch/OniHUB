-- CatHUB FREEMIUM: Combat Module (v7.0)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local LockedTarget = nil

local function IsValidTarget(p)
    if not p or p == LocalPlayer or not p.Character or p.Character.Humanoid.Health <= 0 then return false end
    if p.Team == LocalPlayer.Team and tostring(p.Team) == "Marines" then return false end
    if LocalPlayer:IsFriendsWith(p.UserId) then return false end
    return true
end

local function GetTarget()
    local t, d = nil, 180
    for _, p in pairs(Players:GetPlayers()) do
        if IsValidTarget(p) and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local mD = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mD < d then t, d = p, mD end
            end
        end
    end
    return t
end

RunService.RenderStepped:Connect(function()
    if UI.Settings.LockAim_Enabled then
        if not LockedTarget or not IsValidTarget(LockedTarget) then LockedTarget = GetTarget() end
        if LockedTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockedTarget.Character.HumanoidRootPart.Position)
        end
    else LockedTarget = nil end
    
    -- Mobility Overrides
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        if UI.Settings.FastRun_Enabled then hum.WalkSpeed = UI.Settings.Run_Speed end
        if UI.Settings.HighJump_Enabled then hum.JumpPower = UI.Settings.Jump_Power hum.UseJumpPower = true end
    end
end)

task.spawn(function()
    local pvp = UI:CreateTab("PVP Elite")
    UI:CreateSwitch(pvp, "LockAim_Enabled", "Smart Aim Lock")
    UI:CreateSwitch(pvp, "FastRun_Enabled", "Enable Speed Hack")
    UI:CreateSlider(pvp, "Run_Speed", "Speed Value", 16, 1000)
    UI:CreateSwitch(pvp, "HighJump_Enabled", "Enable High Jump")
    UI:CreateSlider(pvp, "Jump_Power", "Jump Value", 50, 500)
end)