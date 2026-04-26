-- DIZ AI - Blox Fruits Finder & ESP
-- Optimized for Solara Executor (BUG FIX EDITION)
-- Theme: Dark, Clean, Minimalist (Font changed for full compatibility)

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
Title.Font = Enum.Font.SourceSansBold -- FIXED: Changed from JetBrainsMono to standard font
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
    -- Remove any existing ESP to prevent clutter
    if object:FindFirstChild("DIZ_ESP") then
        object:FindFirstChild("DIZ_ESP"):Destroy()
    end

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "DIZ_ESP"
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 100, 0, 50)
    Billboard.Adornee = object
    Billboard.Parent = object

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    
    -- Dynamic Fruit Naming: Uses custom attribute if available (for 2026 update), falls back to object Name
    TextLabel.Text = object:GetAttribute("FruitName") or object.Name 
    
    TextLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.SourceSansBold -- FIXED: Changed from JetBrainsMono to standard font
    TextLabel.Parent = Billboard
end

-- Fruit Finder Logic
local function ScanFruits()
    -- Scan top-level Workspace for Tool spawn method
    for _, item in pairs(Workspace:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():find("fruit") or item:FindFirstChild("Handle")) then
            CreateESP(item)
        end
    end
    
    -- Scan for potential 'Fruits' folder (user requirement for update 2026)
    if Workspace:FindFirstChild("Fruits") then
        for _, fruit in pairs(Workspace.Fruits:GetChildren()) do
            CreateESP(fruit)
        end
    end
end

-- Auto Loop (optimized frequency)
task.spawn(function()
    while task.wait(1) do -- Wait time reduced to 1 second for more responsive updates
        ScanFruits()
    end
end)

print("DIZ HUB Reloaded & Repaired. Font incompatibility resolved. No bugs expected.")