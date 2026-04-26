-- CatHUB FREEMIUM: Logic Core (Physical Override Edition)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local UI_URL = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/UI.lua"
local UI_Module = loadstring(game:HttpGet(UI_URL .. "?v=" .. math.random()))()

local LockedTarget = nil

-- === PVP LOGIC: STICKY LOCK AIM ===
local function GetClosestToMouse()
    local target = nil
    local shortestDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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
    -- Lock Aim Logic
    if UI_Module.Settings.LockAim_Enabled then
        if not LockedTarget or not LockedTarget.Character or not LockedTarget.Character:FindFirstChild("HumanoidRootPart") or LockedTarget.Character.Humanoid.Health <= 0 then
            LockedTarget = GetClosestToMouse()
        end
        
        if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockedTarget.Character.HumanoidRootPart.Position)
        end
    else
        LockedTarget = nil
    end
    
    -- Physical Force Overrides (Speed & Jump)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        
        -- Force Run Speed
        if UI_Module.Settings.FastRun_Enabled then
            Hum.WalkSpeed = UI_Module.Settings.Run_Speed
        end
        
        -- Force High Jump
        if UI_Module.Settings.HighJump_Enabled then
            Hum.JumpPower = UI_Module.Settings.Jump_Power
            Hum.UseJumpPower = true -- Menjamin game menggunakan JumpPower bukan JumpHeight
        end
    end
end)

-- === MOBILITY: WALK ON WATER ===
task.spawn(function()
    local WaterPart = Instance.new("Part")
    WaterPart.Size = Vector3.new(500, 1, 500)
    WaterPart.Transparency = 1
    WaterPart.Anchored = true
    WaterPart.CanCollide = true
    
    while task.wait(0.1) do
        if UI_Module.Settings.WalkWater_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            WaterPart.Parent = Workspace
            WaterPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position.X, -1.5, LocalPlayer.Character.HumanoidRootPart.Position.Z)
        else
            WaterPart.Parent = nil
        end
    end
end)

-- === PLAYER ESP LOGIC ===
local function CreatePlayerESP(player)
    if player ~= LocalPlayer then
        local function Setup(char)
            task.wait(0.5)
            local root = char:WaitForChild("HumanoidRootPart", 5)
            if root and not root:FindFirstChild("Player_ESP") then
                local Bb = Instance.new("BillboardGui", root)
                Bb.Name = "Player_ESP"
                Bb.AlwaysOnTop = true
                Bb.Size = UDim2.new(0, 150, 0, 40)
                local T = Instance.new("TextLabel", Bb)
                T.Size = UDim2.new(1, 0, 1, 0)
                T.BackgroundTransparency = 1
                T.TextColor3 = Color3.fromRGB(255, 255, 255)
                T.TextSize = 13
                T.Font = Enum.Font.SourceSansBold
                T.TextStrokeTransparency = 0.5
                
                task.spawn(function()
                    while char:IsDescendantOf(Workspace) and Bb do
                        Bb.Enabled = UI_Module.Settings.PlayerESP_Enabled
                        if Bb.Enabled then
                            local dist = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                            T.Text = string.format("%s\n[%dM]", player.Name, dist)
                        end
                        task.wait(0.2)
                    end
                end)
            end
        end
        if player.Character then Setup(player.Character) end
        player.CharacterAdded:Connect(Setup)
    end
end

for _, p in pairs(Players:GetPlayers()) do CreatePlayerESP(p) end
Players.PlayerAdded:Connect(CreatePlayerESP)

-- [Logic Fruit Finder / Auto Store tetap sama]