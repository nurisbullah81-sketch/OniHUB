-- CatHUB SUPREMACY: Farm Module v10.0
local UI = _G.UI_Lib
local LP = game:GetService("Players").LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local Tab = UI:NewTab("Main Farm")
UI:NewSwitch(Tab, "AutoFarm", "Auto Farm NPC")
UI:NewSwitch(Tab, "AutoAttack", "High-Speed Smooth Attack")
UI:NewSwitch(Tab, "AutoSkill", "Spam Z,X,C,V,1-4")
UI:NewSwitch(Tab, "SafeMode", "Escape at 10% HP")

-- AGGRESSIVE ATTACK
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoAttack and UI.Settings.AutoFarm then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)

-- NO-HIT FARM LOOP
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
                    LP.Character.HumanoidRootPart.CFrame = target.PrimaryPart.CFrame * CFrame.new(0, 35, 0)
                    for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
                end
            end)
        end
        local h = LP.Character:FindFirstChild("Humanoid")
        if UI.Settings.SafeMode and h and h.Health < (h.MaxHealth * 0.1) then
            UI.Settings.AutoFarm = false; LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10000, 0)
        end
    end
end)