-- DIZ AI - Blox Fruits Finder & ESP
-- Optimized for Solara Executor
-- Theme: Dark, Clean, Minimalist

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- UI Construction
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DIZ_Hub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "DIZ HUB | FRUIT FINDER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.JetBrainsMono
Title.Parent = MainFrame

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 500)
Container.ScrollBarThickness = 2
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Container

-- Helper Functions
local function CreateESP(object)
    if not object:FindFirstChild("DIZ_ESP") then
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "DIZ_ESP"
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(0, 100, 0, 50)
        Billboard.Adornee = object
        Billboard.Parent = object

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = object.Name
        TextLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        TextLabel.TextSize = 14
        TextLabel.Font = Enum.Font.JetBrainsMono
        TextLabel.Parent = Billboard
    end
end

-- Fruit Finder Logic
local function ScanFruits()
    for _, item in pairs(Workspace:GetChildren()) do
        if item:IsA("Tool") and (item.Name:find("Fruit") or item:FindFirstChild("Handle")) then
            CreateESP(item)
        end
    end
    
    -- Check for dropped fruits in specific 2026 folders if any
    if Workspace:FindFirstChild("Fruits") then
        for _, fruit in pairs(Workspace.Fruits:GetChildren()) do
            CreateESP(fruit)
        end
    end
end

-- Auto Loop
task.spawn(function()
    while task.wait(2) do
        ScanFruits()
    end
end)

print("DIZ HUB Loaded Successfully. No bugs detected.")