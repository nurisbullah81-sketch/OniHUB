-- CatHUB FREEMIUM Master UI
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("CatHUB_Premium") then CoreGui.CatHUB_Premium:Destroy() end

local UI_Lib = {
    CurrentTab = nil,
    Visible = true,
    AccentColor = Color3.fromRGB(160, 32, 240), -- Default Purple
    Settings = {
        ESP_Enabled = false,
        Tween_Enabled = false,
        Tween_Speed = 300
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatHUB_Premium"
ScreenGui.Parent = CoreGui
UI_Lib.MainGui = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Border Aksen (Dynamic Color)
local Border = Instance.new("Frame")
Border.Size = UDim2.new(1, 2, 1, 2)
Border.Position = UDim2.new(0, -1, 0, -1)
Border.BackgroundColor3 = UI_Lib.AccentColor
Border.ZIndex = 0
Border.Parent = MainFrame
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 11)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CATHUB FREEMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local TabHolder = Instance.new("ScrollingFrame")
TabHolder.Size = UDim2.new(1, -10, 1, -10)
TabHolder.Position = UDim2.new(0, 5, 0, 5)
TabHolder.BackgroundTransparency = 1
TabHolder.ScrollBarThickness = 0
TabHolder.Parent = Sidebar
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -190, 1, -60)
ContentArea.Position = UDim2.new(0, 180, 0, 55)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Tab System Logic
function UI_Lib:CreateTab(name)
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, 0, 1, 0)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
    Container.Parent = ContentArea
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabBtn.Text = name:upper()
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 12
    TabBtn.Parent = TabHolder
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)

    TabBtn.MouseButton1Click:Connect(function()
        if self.CurrentTab then self.CurrentTab.Visible = false end
        Container.Visible = true
        self.CurrentTab = Container
        for _, v in pairs(TabHolder:GetChildren()) do
            if v:IsA("TextButton") then 
                TweenService:Create(v, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            end
        end
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = UI_Lib.AccentColor}):Play()
    end)
    return Container
end

-- Component: Modern Toggle
function UI_Lib:CreateToggle(parent, name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -5, 0, 45)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    ToggleFrame.Parent = parent
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local Bg = Instance.new("TextButton")
    Bg.Size = UDim2.new(0, 45, 0, 22)
    Bg.Position = UDim2.new(1, -55, 0.5, -11)
    Bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Bg.Text = ""
    Bg.Parent = ToggleFrame
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 4, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Bg
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local enabled = false
    Bg.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = enabled and UI_Lib.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = enabled and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)}):Play()
        callback(enabled)
    end)
end

-- Create Tabs
local MainTab = UI_Lib:CreateTab("Main")
local VisualTab = UI_Lib:CreateTab("Visuals")
local StatusTab = UI_Lib:CreateTab("Status")
local ThemeTab = UI_Lib:CreateTab("Themes")

-- Themes Tab Logic
local function CreateThemeBtn(name, color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 35)
    Btn.BackgroundColor3 = color
    Btn.Text = name:upper()
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = ThemeTab
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        UI_Lib.AccentColor = color
        Border.BackgroundColor3 = color
        -- Refresh active tab color
        for _, v in pairs(TabHolder:GetChildren()) do
            if v:IsA("TextButton") and v.TextColor3 == Color3.fromRGB(255, 255, 255) then
                v.BackgroundColor3 = color
            end
        end
    end)
end

CreateThemeBtn("Royal Purple", Color3.fromRGB(160, 32, 240))
CreateThemeBtn("Crimson Red", Color3.fromRGB(220, 20, 60))
CreateThemeBtn("Pure White", Color3.fromRGB(255, 255, 255))
CreateThemeBtn("Midnight Black", Color3.fromRGB(30, 30, 30))

-- Main Content
UI_Lib:CreateToggle(MainTab, "Auto Tween Fruit", function(val) UI_Lib.Settings.Tween_Enabled = val end)
UI_Lib:CreateToggle(VisualTab, "Fruit ESP (White)", function(val) UI_Lib.Settings.ESP_Enabled = val end)

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