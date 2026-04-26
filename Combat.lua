-- CatHUB FREEMIUM: Combat Module (v4.0)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Remote untuk Blox Fruits
local CommF = game:GetService("ReplicatedStorage").Remotes.CommF

local function StoreFruit()
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool.Name:lower():find("fruit") then
            CommF:InvokeServer("StoreFruit", tool.Name, tool)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        
        -- Anti Stun & Force
        if UI.Settings.AntiStun_Enabled then
            Hum.PlatformStand = false
            Hum.Sit = false
            if Hum:GetState() == Enum.HumanoidStateType.Physics then Hum:ChangeState("GettingUp") end
        end
        
        if UI.Settings.FastRun_Enabled then Hum.WalkSpeed = UI.Settings.Run_Speed end
        if UI.Settings.HighJump_Enabled then 
            Hum.JumpPower = UI_Module.Settings.Jump_Power 
            Hum.UseJumpPower = true 
        end
        
        -- Auto Store Check
        if UI.Settings.AutoStore then StoreFruit() end
    end
end)

-- Tab Setup
task.spawn(function()
    local pvp = UI:CreateTab("PVP Elite")
    UI:CreateSwitch(pvp, "LockAim_Enabled", "Sticky Aim Lock")
    UI:CreateSwitch(pvp, "AntiStun_Enabled", "Anti-Stun Override")
    UI:CreateSwitch(pvp, "PlayerESP_Enabled", "Player Highlight (Red)")
    UI:CreateSwitch(pvp, "FastRun_Enabled", "Enable Run Speed")
    UI:CreateSlider(pvp, "Run_Speed", "Value", 16, 500)
    
    local finder = UI:CreateTab("Fruits Finder")
    UI:CreateSwitch(finder, "ESP_Enabled", "Fruit ESP")
    UI:CreateSwitch(finder, "Tween_Enabled", "Auto Tween Fruit")
    UI:CreateSwitch(finder, "AutoStore", "Auto Store Fruit")
end)