-- CatHUB SUPREMACY: Combat Module v8.0
local UI = _G.UI
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

local Tab = UI:NewTab("PVP Elite")
UI:NewSwitch(Tab, "LockAim", "Smart Sticky Aim")
UI:NewSwitch(Tab, "AntiStun", "Force Anti-Stun Override")
UI:NewSwitch(Tab, "WalkWater", "Walk On Water")
UI:NewSlider(Tab, "RunSpeed", "Run Speed", 16, 1000)
UI:NewSlider(Tab, "JumpPower", "Jump Power", 50, 500)

game:GetService("RunService").RenderStepped:Connect(function()
    if UI.Settings.LockAim then
        local t, sd = nil, 200
        for _,p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not (LP.Team == p.Team and tostring(LP.Team) == "Marines") then
                    local pos, vis = Camera:WorldToViewportPoint(p.Character.PrimaryPart.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if d < sd then t, sd = p, d end
                    end
                end
            end
        end
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.PrimaryPart.Position) end
    end

    local h = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if h then
        h.WalkSpeed = UI.Settings.RunSpeed
        h.JumpPower = UI.Settings.JumpPower
        h.UseJumpPower = true
        if UI.Settings.AntiStun then
            h.PlatformStand = false
            h.Sit = false
            if h:GetState() == Enum.HumanoidStateType.Physics then h:ChangeState("GettingUp") end
        end
    end
end)