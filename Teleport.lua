-- CatHUB FREEMIUM: Teleport Module (v6.1)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local TeleportTab = UI:CreateTab("Teleport")

-- Island Data
local Islands = {
    {name = "Pirate Village", pos = CFrame.new(1045, 15, 1585)},
    {name = "Marine Fortress", pos = CFrame.new(-2550, 73, 2040)},
    {name = "Jungle", pos = CFrame.new(-1180, 15, 3800)},
    {name = "Skylands", pos = CFrame.new(-4850, 750, -2600)},
    {name = "Colosseum", pos = CFrame.new(-1450, 50, -300)},
    {name = "Magma Village", pos = CFrame.new(-5500, 60, 600)},
    {name = "Fishman Island", pos = CFrame.new(61000, 5, 1500)},
    {name = "Dressrosa", pos = CFrame.new(6400, 100, -200)},
    {name = "Green Zone", pos = CFrame.new(-2400, 70, -3100)},
    {name = "Kingdom of Rose", pos = CFrame.new(-2300, 100, -7350)},
    {name = "Graveyard", pos = CFrame.new(-5400, 200, -800)},
    {name = "Snow Mountain", pos = CFrame.new(1300, 400, -5200)},
    {name = "Hot and Cold", pos = CFrame.new(-6000, 100, -5000)},
    {name = "Puzzles", pos = CFrame.new(-5600, 100, -8000)},
    {name = "Sea of Treats", pos = CFrame.new(-1000, 40, 6800)},
    {name = "Tiki Outpost", pos = CFrame.new(-16500, 50, -50)},
    {name = "Great Tree", pos = CFrame.new(2100, 1600, -6200)},
    {name = "Port Town", pos = CFrame.new(-300, 50, -10500)},
    {name = "Hydra Island", pos = CFrame.new(-4950, 500, -7200)},
    {name = "Floating Turtle", pos = CFrame.new(-13000, 200, -8500)},
}

-- Title
local Title = Instance.new("TextLabel", TeleportTab)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "ISLAND TELEPORT"
Title.TextColor3 = Color3.fromRGB(180, 130, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

-- Create Island Buttons
local ScrollFrame = Instance.new("ScrollingFrame", TeleportTab)
ScrollFrame.Size = UDim2.new(1, 0, 1, -35)
ScrollFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 2
local ListLayout = Instance.new("UIListLayout", ScrollFrame)
ListLayout.Padding = UDim.new(0, 3)

for _, island in pairs(Islands) do
    local btn = Instance.new("TextButton", ScrollFrame)
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = "⚡ " .. island.name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 11
    btn.TextXAlignment = "Left"
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local padding = Instance.new("UIPadding", btn)
    padding.PaddingLeft = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local dist = (island.pos.Position - hrp.Position).Magnitude
            local speed = math.clamp(UI.Settings.Tween_Speed or 300, 100, 1000)
            local tween = TweenService:Create(hrp, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = island.pos})
            tween:Play()
            btn.Text = "TELEPORTING..."
            tween.Completed:Wait()
            btn.Text = "⚡ " .. island.name
        end)
    end)
end

-- Tween Speed Setting
UI:CreateSwitch(TeleportTab, "Tween_Enabled", "Use Tween Teleport")
UI:CreateSlider(TeleportTab, "Tween_Speed", "Tween Speed", 100, 1000, nil)

-- Auto Store Fruits
UI:CreateSwitch(TeleportTab, "AutoStore", "Auto Store Devil Fruits")

task.spawn(function()
    while task.wait(2) do
        if UI.Settings.AutoStore and LocalPlayer.Character then
            pcall(function()
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find("fruit") then
                        local args = {
                            [1] = "StoreFruit",
                            [2] = tool.Name
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        print("[CatHUB]: Stored " .. tool.Name)
                    end
                end
                -- Also check if holding fruit
                if LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
                    local held = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                    if held.Name:lower():find("fruit") then
                        local args = {
                            [1] = "StoreFruit",
                            [2] = held.Name
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        print("[CatHUB]: Stored " .. held.Name)
                    end
                end
            end)
        end
    end
end)

-- Quick Teleport Function (Global)
function _G.CatHUB_Teleport(position)
    pcall(function()
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if UI.Settings.Tween_Enabled then
            local dist = (position - hrp.Position).Magnitude
            local speed = UI.Settings.Tween_Speed or 300
            TweenService:Create(hrp, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)}):Play()
        else
            hrp.CFrame = CFrame.new(position)
        end
    end)
end

print("[CatHUB]: Teleport Module Loaded.")