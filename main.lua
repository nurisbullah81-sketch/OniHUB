-- CatHUB FREEMIUM: Logic Core (PVP & Combat Update)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local UI_URL = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/UI.lua"
local UI_Module = loadstring(game:HttpGet(UI_URL .. "?v=" .. math.random()))()

-- === PVP LOGIC: AIMBOT ===
local function GetClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortestDist then
                    closest = player
                    shortestDist = dist
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if UI_Module.Settings.LockAim_Enabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
    
    -- Mobility: Run Speed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if UI_Module.Settings.FastRun_Enabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = UI_Module.Settings.Run_Speed
        end
    end
end)

-- === PVP LOGIC: WALK ON WATER ===
task.spawn(function()
    local WaterPart = Instance.new("Part")
    WaterPart.Size = Vector3.new(500, 1, 500)
    WaterPart.Transparency = 1
    WaterPart.Anchored = true
    WaterPart.CanCollide = true
    
    while task.wait(0.1) do
        if UI_Module.Settings.WalkWater_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            WaterPart.Parent = Workspace
            WaterPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position.X, -1, LocalPlayer.Character.HumanoidRootPart.Position.Z)
        else
            WaterPart.Parent = nil
        end
    end
end)

-- === PLAYER ESP LOGIC ===
local function CreatePlayerESP(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if not char:FindFirstChild("Player_ESP") then
                local Bb = Instance.new("BillboardGui", char:WaitForChild("HumanoidRootPart"))
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
                    while char:IsDescendantOf(Workspace) do
                        Bb.Enabled = UI_Module.Settings.PlayerESP_Enabled
                        if Bb.Enabled then
                            local dist = math.floor((char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                            T.Text = string.format("%s\n[%dM]", player.Name, dist)
                        end
                        task.wait(0.2)
                    end
                end)
            end
        end)
    end
end

for _, p in pairs(Players:GetPlayers()) do CreatePlayerESP(p) end
Players.PlayerAdded:Connect(CreatePlayerESP)

-- === FRUIT FINDER LOGIC (PREVIOUS) ===
-- [Logika Tween, Fruit ESP, dan Auto Store tetap sama seperti versi sebelumnya]