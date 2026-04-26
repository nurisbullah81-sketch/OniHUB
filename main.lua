-- CatHUB FREEMIUM: Core Engine (Target HUD Edition)
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

-- === TARGET HUD CONSTRUCTION ===
local TargetHUD = Instance.new("Frame")
TargetHUD.Size = UDim2.new(0, 200, 0, 35)
TargetHUD.Position = UDim2.new(0.5, -100, 0, 50)
TargetHUD.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TargetHUD.BorderSizePixel = 0
TargetHUD.Visible = false
TargetHUD.Parent = CoreGui
Instance.new("UICorner", TargetHUD).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", TargetHUD).Color = UI_Module.AccentColor

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 1, 0)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "LOCKED: NONE"
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.Font = Enum.Font.SourceSansBold
TargetLabel.TextSize = 13
TargetLabel.Parent = TargetHUD

-- === PVP & PHYSICAL ENGINE ===
local function GetClosestToMouse()
    local target = nil
    local shortestDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < 150 then -- Radius penguncian
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
        if not LockedTarget or not LockedTarget.Character or not LockedTarget.Character:FindFirstChild("HumanoidRootPart") or LockedTarget.Character.Humanoid.Health <= 0 then
            LockedTarget = GetClosestToMouse()
        end
        
        if LockedTarget then
            TargetHUD.Visible = true
            TargetLabel.Text = "LOCKED: " .. LockedTarget.Name:upper()
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockedTarget.Character.HumanoidRootPart.Position)
        else
            TargetHUD.Visible = false
        end
    else
        LockedTarget = nil
        TargetHUD.Visible = false
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        if UI_Module.Settings.FastRun_Enabled then Hum.WalkSpeed = UI_Module.Settings.Run_Speed end
        if UI_Module.Settings.HighJump_Enabled then 
            Hum.JumpPower = UI_Module.Settings.Jump_Power
            Hum.UseJumpPower = true 
        end
    end
end)

-- [Logika WalkWater, ESP Player, Fruit Finder, Auto Store tetap aktif]