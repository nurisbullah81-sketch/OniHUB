-- CatHUB SUPREMACY: Farm Module v11.0
local UI = _G.UI_Lib
local LP = game:GetService("Players").LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local Tab = UI:NewTab("Main Farm")
UI:NewSelector(Tab, "WeaponType", "Select Weapon", {"Melee", "Sword", "Fruit"})
UI:NewSwitch(Tab, "AutoFarm", "Auto Farm NPC")
UI:NewSwitch(Tab, "AutoAttack", "Smart Aggressive Attack")
UI:NewSwitch(Tab, "AutoSkill", "Spam Skills (Z,X,C,V)")
UI:NewSwitch(Tab, "SafeMode", "Escape at 10% HP")

-- EQUIP WEAPON LOGIC
local function EquipWeapon()
    local type = UI.Settings.WeaponType
    for _,v in pairs(LP.Backpack:GetChildren()) do
        if (type == "Melee" and v:IsA("Tool") and (v.ToolTip == "Melee" or v:FindFirstChild("Combat"))) or
           (type == "Sword" and v:IsA("Tool") and v.ToolTip == "Sword") or
           (type == "Fruit" and v:IsA("Tool") and v.ToolTip == "Blox Fruit") then
            LP.Character.Humanoid:EquipTool(v)
        end
    end
end

-- SMART AUTO ATTACK (Remote + Click)
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoAttack and UI.Settings.AutoFarm then
            pcall(function()
                EquipWeapon()
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.random(1, 9999))
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(851, 158), workspace.CurrentCamera.CFrame)
                -- Remote standard attack Blox Fruits
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool then
                    game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("Attack", tool)
                end
            end)
        end
    end
end)

-- NO-HIT FARM (Flying Above NPC)
task.spawn(function()
    while task.wait() do
        if UI.Settings.AutoFarm then
            local target, dist = nil, math.huge
            for _,v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    local d = (v.PrimaryPart.Position - LP.Character.PrimaryPart.Position).Magnitude
                    if d < dist then target, dist = v, d end
                end
            end
            if target then
                -- Terbang 35 unit di atas NPC (Gak bakal kena hit)
                LP.Character.HumanoidRootPart.CFrame = target.PrimaryPart.CFrame * CFrame.new(0, 35, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
        end
        -- Safe Mode
        local h = LP.Character:FindFirstChild("Humanoid")
        if UI.Settings.SafeMode and h and h.Health < (h.MaxHealth * 0.1) then
            UI.Settings.AutoFarm = false; LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 20000, 0)
        end
    end
end)