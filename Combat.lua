-- CatHUB FREEMIUM: Combat Module (v6.1)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local CombatTab = UI:CreateTab("Combat")

-- Switches
UI:CreateSwitch(CombatTab, "LockAim_Enabled", "Lock Aim (Nearest Enemy)")
UI:CreateSwitch(CombatTab, "AntiStun_Enabled", "Anti Stun")
UI:CreateSwitch(CombatTab, "WalkWater_Enabled", "Walk on Water")
UI:CreateSwitch(CombatTab, "FastRun_Enabled", "Fast Run")
UI:CreateSlider(CombatTab, "Run_Speed", "Run Speed", 16, 100, function(val)
    if UI.Settings.FastRun_Enabled and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)
UI:CreateSwitch(CombatTab, "HighJump_Enabled", "High Jump")
UI:CreateSlider(CombatTab, "Jump_Power", "Jump Power", 50, 200, function(val)
    if UI.Settings.HighJump_Enabled and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

-- Lock Aim System
RunService.RenderStepped:Connect(function()
    if UI.Settings.LockAim_Enabled and LocalPlayer.Character then
        pcall(function()
            local closest, dist = nil, math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if p.Character.Humanoid.Health > 0 then
                        local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then
                            closest, dist = p, d
                        end
                    end
                end
            end
            if closest and closest.Character.HumanoidRootPart then
                Workspace.CurrentCamera.CFrame = CFrame.new(
                    Workspace.CurrentCamera.CFrame.Position,
                    closest.Character.HumanoidRootPart.Position
                )
            end
        end)
    end
end)

-- Anti Stun
RunService.Heartbeat:Connect(function()
    if UI.Settings.AntiStun_Enabled and LocalPlayer.Character then
        pcall(function()
            local hum = LocalPlayer.Character.Humanoid
            if hum:GetState() == Enum.HumanoidStateType.PlatformStanding then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end
end)

-- Walk on Water
task.spawn(function()
    while task.wait(0.1) do
        if UI.Settings.WalkWater_Enabled and LocalPlayer.Character then
            pcall(function()
                local root = LocalPlayer.Character.HumanoidRootPart
                local pos = root.Position
                -- Check if in water region
                for _, v in pairs(Workspace:GetChildren()) do
                    if v:IsA("Terrain") then
                        local cell = v:ReadVoxel(pos)
                        if cell.Material == Enum.Material.Water then
                            root.Velocity = Vector3.new(root.Velocity.X, 25, root.Velocity.Z)
                        end
                    end
                end
            end)
        end
    end
end)

-- Fast Run
task.spawn(function()
    while task.wait(0.5) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if UI.Settings.FastRun_Enabled then
                hum.WalkSpeed = UI.Settings.Run_Speed
            else
                hum.WalkSpeed = 16
            end
            
            if UI.Settings.HighJump_Enabled then
                hum.JumpPower = UI.Settings.Jump_Power
                hum.UseJumpPower = true
            else
                hum.JumpPower = 50
            end
        end
    end
end)

-- Get Nearest Player Function (For Bounty)
function _G.CatHUB_GetNearestPlayer()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Character.Humanoid.Health > 0 then
                local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    closest, dist = p, d
                end
            end
        end
    end
    return closest
end

print("[CatHUB]: Combat Module Loaded.")