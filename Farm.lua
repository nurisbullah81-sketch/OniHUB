-- CatHUB SUPREMACY: Farm Module v8.0
local UI = _G.UI
local LP = game:GetService("Players").LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local Tab = UI:NewTab("Main Farm")
UI:NewSwitch(Tab, "AutoFarm", "Auto Farm NPC")
UI:NewSwitch(Tab, "AutoAttack", "Elite Fast Attack")
UI:NewSwitch(Tab, "AutoSkill", "Use All Skills (Z,X,C,V,1-4)")
UI:NewSwitch(Tab, "SafeMode", "Escape at 10% HP")

-- Fast Attack
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoAttack and UI.Settings.AutoFarm then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)

-- Skills
task.spawn(function()
    local keys = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}
    while task.wait(0.3) do
        if UI.Settings.AutoSkill and UI.Settings.AutoFarm then
            for _,k in pairs(keys) do VIM:SendKeyEvent(true, k, false, game) task.wait(0.05) VIM:SendKeyEvent(false, k, false, game) end
        end
    end
end)

-- Safe Mode
task.spawn(function()
    while task.wait(0.1) do
        local h = LP.Character and LP.Character:FindFirstChild("Humanoid")
        if UI.Settings.SafeMode and h and h.Health > 0 and h.Health < (h.MaxHealth * 0.1) then
            UI.Settings.AutoFarm = false
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 15000, 0)
        end
    end
end)

-- Farm Loop (Above NPC)
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoFarm then
            pcall(function()
                local t, d = nil, math.huge
                for _,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local dist = (v.PrimaryPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                        if dist < d then t, d = v, dist end
                    end
                end
                if t then
                    local targetPos = t.PrimaryPart.CFrame * CFrame.new(0, 30, 0) -- Terbang Tinggi
                    LP.Character.HumanoidRootPart.CFrame = targetPos
                    for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
                end
            end)
        end
    end
end)