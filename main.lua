-- CatHUB FREEMIUM: Core Engine (Anti-Stun & HUD Fixed)
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

-- === COMPACT COMBAT HUD (Re-Constructed) ===
if CoreGui:FindFirstChild("CatHUD_TargetInfo") then CoreGui.CatHUB_TargetInfo:Destroy() end

local TargetHUD = Instance.new("Frame")
TargetHUD.Name = "CatHUB_TargetInfo"
TargetHUD.Size = UDim2.new(0, 180, 0, 30)
TargetHUD.Position = UDim2.new(0.5, -90, 0, 45)
TargetHUD.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TargetHUD.BorderSizePixel = 0
TargetHUD.Visible = false
TargetHUD.ZIndex = 100
TargetHUD.Parent = CoreGui
Instance.new("UICorner", TargetHUD).CornerRadius = UDim.new(0, 5)
local HUDStroke = Instance.new("UIStroke", TargetHUD)
HUDStroke.Color = UI_Module.AccentColor
HUDStroke.Thickness = 1

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 1, 0)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "SCANNING TARGET..."
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.Font = Enum.Font.SourceSansBold
TargetLabel.TextSize = 12
TargetLabel.Parent = TargetHUD

-- === COMBAT & PHYSICAL LOGIC ===
local function GetClosestTarget()
    local target = nil
    local shortestDist = 200 -- FOV Radius
    
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
    -- Lock Aim & HUD Logic
    if UI_Module.Settings.LockAim_Enabled then
        if not LockedTarget or not LockedTarget.Character or not LockedTarget.Character:FindFirstChild("HumanoidRootPart") or LockedTarget.Character.Humanoid.Health <= 0 then
            LockedTarget = GetClosestTarget()
        end
        
        TargetHUD.Visible = true
        if LockedTarget then
            TargetLabel.Text = "LOCKED: " .. LockedTarget.Name:upper()
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockedTarget.Character.HumanoidRootPart.Position)
        else
            TargetLabel.Text = "SCANNING FOR TARGET..."
        end
    else
        LockedTarget = nil
        TargetHUD.Visible = false
    end
    
    -- Physical Overrides & Anti-Stun
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        
        -- Anti-Stun Logic
        if UI_Module.Settings.AntiStun_Enabled then
            Hum.PlatformStand = false
            Hum.Sit = false
            -- Resetting states often used by stuns
            if Hum:GetState() == Enum.HumanoidStateType.Physics or Hum:GetState() == Enum.HumanoidStateType.PlatformStanding then
                Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end

        if UI_Module.Settings.FastRun_Enabled then Hum.WalkSpeed = UI_Module.Settings.Run_Speed end
        if UI_Module.Settings.HighJump_Enabled then 
            Hum.JumpPower = UI_Module.Settings.Jump_Power
            Hum.UseJumpPower = true 
        end
    end
end)

-- [Logic WalkWater, ESP Player, Fruit Finder tetap aktif]