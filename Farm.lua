-- CatHUB SUPREMACY: Farm Module v13.0
local UI = _G.UI
local LP = game:GetService("Players").LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local VU = game:GetService("VirtualUser")

local Tab = UI:NewTab("Main Farm")
UI:NewSelector(Tab, "WeaponType", "Select Weapon", {"Melee", "Sword", "Fruit"})
UI:NewSwitch(Tab, "AutoFarm", "Auto Farm NPC")
UI:NewSwitch(Tab, "AutoAttack", "Elite Fast Attack")
UI:NewSwitch(Tab, "SafeMode", "Escape at 10% HP")

local function Equip()
    local t = UI.Settings.WeaponType
    for _,v in pairs(LP.Backpack:GetChildren()) do
        if (t == "Melee" and (v.ToolTip == "Melee" or v:FindFirstChild("Combat"))) or
           (t == "Sword" and v.ToolTip == "Sword") or
           (t == "Fruit" and v.ToolTip == "Blox Fruit") then
            LP.Character.Humanoid:EquipTool(v)
        end
    end
end

-- AGGRESSIVE ATTACK LOOP (Remote Sync)
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoAttack and UI.Settings.AutoFarm then
            pcall(function()
                Equip()
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Triggering the Attack Remote
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.random(1, 9999))
                    VU:Button1Down(Vector2.new(851, 158), workspace.CurrentCamera.CFrame)
                    game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("Attack", tool)
                end
            end)
        end
    end
end)

-- NO-STUN FARM (Flying Logic)
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoFarm then
            pcall(function()
                local npc, dist = nil, math.huge
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (v.PrimaryPart.Position - LP.Character.PrimaryPart.Position).Magnitude
                        if d < dist then npc, dist = v, d end
                    end
                end
                if npc then
                    -- Terbang 40 unit di atas NPC biar ga kena stun musuh
                    LP.Character.HumanoidRootPart.CFrame = npc.PrimaryPart.CFrame * CFrame.new(0, 40, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
                end
            end)
        end
        -- Safety Escape
        local h = LP.Character:FindFirstChild("Humanoid")
        if UI.Settings.SafeMode and h and h.Health < (h.MaxHealth * 0.1) then
            UI.Settings.AutoFarm = false; LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 15000, 0)
        end
    end
end)