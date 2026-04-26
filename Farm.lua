-- CatHUB SUPREMACY: Farm Module v9.0
local UI = _G.UI
local LP = game:GetService("Players").LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local Tab = UI:NewTab("Main Farm")
UI:NewSwitch(Tab, "AutoFarm", "Auto Farm NPC")
UI:NewSwitch(Tab, "AutoAttack", "Elite Fast Attack")
UI:NewSwitch(Tab, "AutoSkill", "Use Skills (Z,X,C,V,1-4)")

-- Aggressive Fast Attack
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoAttack and UI.Settings.AutoFarm then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)

-- Skills Loop
task.spawn(function()
    local keys = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.One, Enum.KeyCode.Two}
    while task.wait(0.5) do
        if UI.Settings.AutoSkill and UI.Settings.AutoFarm then
            for _,k in pairs(keys) do VIM:SendKeyEvent(true, k, false, game) task.wait(0.05) VIM:SendKeyEvent(false, k, false, game) end
        end
    end
end)

-- High-Altitude Farm Loop
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoFarm then
            pcall(function()
                local target, dist = nil, math.huge
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (v.PrimaryPart.Position - LP.Character.PrimaryPart.Position).Magnitude
                        if d < dist then target, dist = v, d end
                    end
                end
                if target then
                    -- Terbang 35 unit di atas NPC biar ga kena hit
                    LP.Character.HumanoidRootPart.CFrame = target.PrimaryPart.CFrame * CFrame.new(0, 35, 0)
                    for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
                end
            end)
        end
    end
end)