-- CatHUB SUPREMACY: Combat Module v10.0
local UI = _G.UI_Lib
local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera

local Tab = UI:NewTab("PVP Elite")
UI:NewSwitch(Tab, "LockAim", "Sticky Target Lock")
UI:NewSwitch(Tab, "AntiStun", "Passive Anti-Stun Override")
UI:NewSlider(Tab, "RunSpeed", "Run Speed Value", 16, 1000)

game:GetService("RunService").RenderStepped:Connect(function()
    local h = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if h then
        h.WalkSpeed = UI.Settings.RunSpeed
        if UI.Settings.AntiStun then
            h.PlatformStand = false; h.Sit = false
            if h:GetState() == Enum.HumanoidStateType.Physics then h:ChangeState("GettingUp") end
        end
    end
    if UI.Settings.LockAim then
        local t, sd = nil, 180
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not (LP.Team == p.Team and tostring(LP.Team) == "Marines") then
                    local pos, vis = Cam:WorldToViewportPoint(p.Character.PrimaryPart.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(LP:GetMouse().X, LP:GetMouse().Y)).Magnitude
                        if d < sd then t, sd = p, d end
                    end
                end
            end
        end
        if t then Cam.CFrame = CFrame.new(Cam.CFrame.Position, t.Character.PrimaryPart.Position) end
    end
end)