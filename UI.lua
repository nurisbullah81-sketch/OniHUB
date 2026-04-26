-- CatHUB Premium Interface
-- Style: RedzHub Deep Dark
-- Features: Resizable, Status Tab, Ctrl+G Toggle

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("CatHUB_Master") then CoreGui.CatHUB_Master:Destroy() end

local UI_Lib = {
    CurrentTab = nil,
    Visible = true,
    Settings = {
        ESP_Enabled = false,
        Tween_Enabled = false
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatHUB_Master"
ScreenGui.Parent = CoreGui
UI_Lib.MainGui = ScreenGui

-- Main Frame (Larger Default Size: 550x350)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Resize Handle (Bottom Right)
local ResizeHandle = Instance.new("Frame")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Active = true
ResizeHandle.Parent = MainFrame

-- Resizing Logic
local isResizing = false
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isResizing = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local newWidth = mousePos.X - MainFrame.AbsolutePosition.X
        local newHeight = (mousePos.Y - 36) - MainFrame.AbsolutePosition.Y -- Offset for TopBar
        
        -- Minimum size limits
        newWidth = math.max(400, newWidth)
        newHeight = math.max(250, newHeight)
        
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isResizing = false
    end
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -45)
Sidebar.Position = UDim2.new(0, 5, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local TabHolder = Instance.new("ScrollingFrame")
TabHolder.Size = UDim2.new(1, -10, 1, -10)
TabHolder.Position = UDim2.new(0, 5, 0, 5)
TabHolder.BackgroundTransparency = 1
TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
TabHolder.ScrollBarThickness = 0
TabHolder.Parent = Sidebar
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -175, 1, -50)
ContentFrame.Position = UDim2.new(0, 170, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CATHUB PREMIUM | BLOX FRUITS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Tab System
function UI_Lib:CreateTab(name)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = name .. "_Container"
    Container.Size = UDim2.new(1, 0, 1, 0)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
    Container.Parent = ContentFrame
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabBtn.Text = name:upper()
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 12
    TabBtn.Parent = TabHolder
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

    TabBtn.MouseButton1Click:Connect(function()
        if self.CurrentTab then self.CurrentTab.Visible = false end
        Container.Visible = true
        self.CurrentTab = Container
        for _, v in pairs(TabHolder:GetChildren()) do
            if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(180, 180, 180) end
        end
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return Container
end

-- Create Tabs
local MainTab = UI_Lib:CreateTab("Main")
local StatusTab = UI_Lib:CreateTab("Status")

-- Status Tab Detail
local function CreateStatusLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 30)
    Label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.Parent = StatusTab
    Instance.new("UICorner", Label).CornerRadius = UDim.new(0, 4)
    return Label
end

local LevelLabel = CreateStatusLabel("Level: Loading...")
local BeliLabel = CreateStatusLabel("Beli: Loading...")
local FragLabel = CreateStatusLabel("Fragments: Loading...")

task.spawn(function()
    while task.wait(1) do
        local data = Players.LocalPlayer:FindFirstChild("Data")
        if data then
            LevelLabel.Text = "Level: " .. tostring(Players.LocalPlayer.Data.Level.Value)
            BeliLabel.Text = "Beli: " .. tostring(Players.LocalPlayer.Data.Beli.Value)
            FragLabel.Text = "Fragments: " .. tostring(Players.LocalPlayer.Data.Fragments.Value)
        end
    end
end)

-- Toggles (Main Tab)
function UI_Lib:CreateToggle(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = name .. " : OFF"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.Text = name .. " : " .. (enabled and "ON" or "OFF")
        Btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(200, 200, 200)
        callback(enabled)
    end)
end

UI_Lib:CreateToggle(MainTab, "ESP Fruits", function(val) self.Settings.ESP_Enabled = val end)
UI_Lib:CreateToggle(MainTab, "Auto Tween Fruit", function(val) self.Settings.Tween_Enabled = val end)

-- Initial State
MainTab.Visible = true
UI_Lib.CurrentTab = MainTab

-- Keybind [Ctrl + G]
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        UI_Lib.Visible = not UI_Lib.Visible
        MainFrame.Visible = UI_Lib.Visible
    end
end)

return UI_Lib