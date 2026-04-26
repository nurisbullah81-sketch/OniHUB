-- CatHUB FREEMIUM: Core Engine (Precision Update)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local UI_URL = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/UI.lua"
local UI_Module = loadstring(game:HttpGet(UI_URL .. "?v=" .. math.random()))()

local LockedTarget = nil

-- === COMPACT COMBAT HUD ===
local TargetHUD = Instance.new("Frame")
TargetHUD.Size = UDim2.new(0, 160, 0, 26) -- Smaller, more compact
TargetHUD.Position = UDim2.new(0.5, -80, 0, 40)
TargetHUD.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TargetHUD.BorderSizePixel = 0
TargetHUD.Visible = false
TargetHUD.Parent = CoreGui
Instance.new("UICorner", TargetHUD).CornerRadius = UDim.new(0, 4)
local HUDStroke = Instance.new("UIStroke", TargetHUD)
HUDStroke.Color = UI_Module.AccentColor
HUDStroke.Thickness = 1

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 1, 0)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "LOCKED: NONE"
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.Font = Enum.Font.SourceSansBold
TargetLabel.TextSize = 11
TargetLabel.Parent = TargetHUD

-- === PVP LOGIC: PRECISION LOCK ===
local function GetClosestToCursor()
    local target = nil
    local shortestDist = 150 -- FOV Radius (Tighter)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortestDist then
                    target = player
                    shortestDist = dist
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if UI_Module.Settings.LockAim_Enabled then
        -- Sticky Logic Fix
        if not LockedTarget or not LockedTarget.Character or not LockedTarget.Character:FindFirstChild("HumanoidRootPart") or LockedTarget.Character.Humanoid.Health <= 0 then
            LockedTarget = GetClosestToCursor()
        end
        
        if LockedTarget then
            TargetHUD.Visible = true
            TargetLabel.Text = "LOCKED: " .. LockedTarget.Name:upper()
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockedTarget.Character.HumanoidRootPart.Position)
        else
            TargetHUD.Visible = true
            TargetLabel.Text = "AIM: SCANNING..."
        end
    else
        LockedTarget = nil
        TargetHUD.Visible = false
    end
    
    -- Force Physical Overrides
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        if UI_Module.Settings.FastRun_Enabled then Hum.WalkSpeed = UI_Module.Settings.Run_Speed end
        if UI_Module.Settings.HighJump_Enabled then 
            Hum.JumpPower = UI_Module.Settings.Jump_Power
            Hum.UseJumpPower = true 
        end
    end
end)

-- === FRUIT FINDER: DEBUG LOGS ===
task.spawn(function()
    while task.wait(5) do
        if UI_Module.Settings.ESP_Enabled then
            local found = false
            for _, v in pairs(Workspace:GetChildren()) do
                if (v:IsA("Tool") and v.Name:lower():find("fruit")) or (v:IsA("Model") and v.Name == "Fruit ") then
                    found = true
                    break
                end
            end
            if not found then print("[CatHUB]: No fruits detected in workspace.") end
        end
    end
end)

-- [Logic WalkWater, ESP Player, Fruit ESP, Auto Store tetap aktif]