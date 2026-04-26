-- CatHUB FREEMIUM: Core Engine (Smart PVP & Visibility Update)
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
local currentTween = nil

-- === SMART TARGET FILTER ===
local function IsEnemy(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return false end
    
    -- Check if both are in Marines team
    if LocalPlayer.Team and targetPlayer.Team and LocalPlayer.Team == targetPlayer.Team then
        if tostring(LocalPlayer.Team) == "Marines" then return false end
    end
    
    -- Check for Allies / Friends
    if LocalPlayer:IsFriendsWith(targetPlayer.UserId) then return false end
    
    return true
end

-- === TARGET HUD ===
if CoreGui:FindFirstChild("CatHUD_TargetInfo") then CoreGui.CatHUB_TargetInfo:Destroy() end
local TargetHUD = Instance.new("Frame", CoreGui)
TargetHUD.Name = "CatHUB_TargetInfo"
TargetHUD.Size = UDim2.new(0, 180, 0, 30)
TargetHUD.Position = UDim2.new(0.5, -90, 0, 50)
TargetHUD.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TargetHUD.Visible = false
Instance.new("UICorner", TargetHUD).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", TargetHUD).Color = UI_Module.AccentColor

local TargetLabel = Instance.new("TextLabel", TargetHUD)
TargetLabel.Size = UDim2.new(1, 0, 1, 0)
TargetLabel.BackgroundTransparency = 1
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.Font = Enum.Font.SourceSansBold
TargetLabel.TextSize = 12

-- === COMBAT LOGIC ===
local function GetSmartTarget()
    local target = nil
    local shortestDist = 200 -- FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if IsEnemy(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
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

-- === PHYSICAL OVERRIDE LOOP ===
RunService.RenderStepped:Connect(function()
    -- Smart Lock Aim
    if UI_Module.Settings.LockAim_Enabled then
        if not LockedTarget or not LockedTarget.Character or not LockedTarget.Character:FindFirstChild("HumanoidRootPart") or LockedTarget.Character.Humanoid.Health <= 0 then
            LockedTarget = GetSmartTarget()
        end
        
        TargetHUD.Visible = true
        if LockedTarget then
            TargetLabel.Text = "LOCKED: " .. LockedTarget.Name:upper()
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockedTarget.Character.HumanoidRootPart.Position)
        else
            TargetLabel.Text = "SCANNING ENEMIES..."
        end
    else
        LockedTarget = nil
        TargetHUD.Visible = false
    end
    
    -- Character Mechanics
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        local HRP = LocalPlayer.Character.HumanoidRootPart
        
        -- Anti-Stun
        if UI_Module.Settings.AntiStun_Enabled then
            Hum.PlatformStand = false
            Hum.Sit = false
            if Hum:GetState() == Enum.HumanoidStateType.Physics then Hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end

        -- Movement Fix
        if UI_Module.Settings.FastRun_Enabled then Hum.WalkSpeed = UI_Module.Settings.Run_Speed end
        if UI_Module.Settings.HighJump_Enabled then Hum.JumpPower = UI_Module.Settings.Jump_Power Hum.UseJumpPower = true end
        
        -- Tween Noclip Fix
        if UI_Module.Settings.Tween_Enabled then
            HRP.Anchored = false
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- === FRUIT ESP (ULTRA VISIBILITY) ===
local function CreateFruitESP(object)
    if not object:FindFirstChild("Cat_ESP") then
        local Bb = Instance.new("BillboardGui", object)
        Bb.Name = "Cat_ESP"
        Bb.AlwaysOnTop = true
        Bb.Size = UDim2.new(0, 200, 0, 50)
        
        local T = Instance.new("TextLabel", Bb)
        T.Size = UDim2.new(1, 0, 1, 0)
        T.BackgroundTransparency = 1
        T.TextColor3 = Color3.fromRGB(255, 255, 255)
        T.TextSize = 18 -- LARGER
        T.Font = Enum.Font.SourceSansBold
        T.TextStrokeTransparency = 0 -- MAX STROKE
        T.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        task.spawn(function()
            while object:IsDescendantOf(Workspace) do
                Bb.Enabled = (UI_Module.Settings.ESP_Enabled and not object:IsDescendantOf(LocalPlayer.Character))
                if Bb.Enabled then
                    local name = object.Name == "Fruit " and "??? (System)" or object.Name
                    local dist = math.floor((object:GetModelCFrame().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    T.Text = string.format("%s\n%dM", name, dist)
                end
                task.wait(0.2)
            end
            if Bb then Bb:Destroy() end
        end)
    end
end

-- === TWEEN TO FRUIT ENGINE ===
local function TweenTo(target)
    if not UI_Module.Settings.Tween_Enabled or not target then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if target:IsDescendantOf(char) or target:IsDescendantOf(Workspace.Characters) then return end
        local dist = (target:GetModelCFrame().Position - char.HumanoidRootPart.Position).Magnitude
        if dist < 10 then return end
        
        if currentTween then currentTween:Cancel() end
        local tInfo = TweenInfo.new(dist/UI_Module.Settings.Tween_Speed, Enum.EasingStyle.Linear)
        currentTween = TweenService:Create(char.HumanoidRootPart, tInfo, {CFrame = target:GetModelCFrame()})
        currentTween:Play()
    end
end

-- Main Loop
task.spawn(function()
    while task.wait(1) do
        if UI_Module.Settings.ESP_Enabled or UI_Module.Settings.Tween_Enabled then
            for _, v in pairs(Workspace:GetChildren()) do
                if (v:IsA("Tool") and v.Name:lower():find("fruit")) or (v:IsA("Model") and v.Name == "Fruit ") then
                    if UI_Module.Settings.ESP_Enabled then CreateFruitESP(v) end
                    if UI_Module.Settings.Tween_Enabled then TweenTo(v) end
                end
            end
        end
    end
end)