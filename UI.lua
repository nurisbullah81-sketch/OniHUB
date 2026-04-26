-- CatHUB FREEMIUM: Professional Elite UI
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("CatHUB_Freemium") then CoreGui.CatHUB_Freemium:Destroy() end

local UI_Lib = {
    CurrentTab = nil,
    Visible = true,
    AccentColor = Color3.fromRGB(130, 80, 255), -- Modern Violet
    Settings = {
        ESP_Enabled = false,
        Tween_Enabled = false,
        Tween_Speed = 300,
        AutoStore = false
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatHUB_Freemium"
ScreenGui.Parent = CoreGui
UI_Lib.MainGui = ScreenGui

-- Main Frame (Slim Default: 450x280)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 40)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Top Bar (Slim)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CATHUB FREEMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    UI_Lib.Visible = false
    MainFrame.Visible = false
end)

-- Sidebar (Narrow)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -40)
Sidebar.Position = UDim2.new(0, 5, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)

local TabList = Instance.new("ScrollingFrame")
TabList.Size = UDim2.new(1, -6, 1, -6)
TabList.Position = UDim2.new(0, 3, 0, 3)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
TabList.Parent = Sidebar
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 3)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -125, 1, -40)
ContentArea.Position = UDim2.new(0, 120, 0, 35)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Tab System
function UI_Lib:CreateTab(name)
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -10, 1, -10)
    Container.Position = UDim2.new(0, 5, 0, 5)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 1
    Container.Parent = ContentArea
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name:upper()
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 11
    Btn.Parent = TabList
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        if self.CurrentTab then self.CurrentTab.Visible = false end
        Container.Visible = true
        self.CurrentTab = Container
        for _, v in pairs(TabList:GetChildren()) do
            if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) v.BackgroundColor3 = Color3.fromRGB(20, 20, 20) end
        end
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
    return Container
end

-- Component: Slim Switch (Redz/Tumadam Style)
function UI_Lib:CreateSwitch(parent, title, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 32) -- Slimmed down
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Card.Parent = parent
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local Bg = Instance.new("TextButton")
    Bg.Size = UDim2.new(0, 30, 0, 16)
    Bg.Position = UDim2.new(1, -40, 0.5, -8)
    Bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Bg.Text = ""
    Bg.Parent = Card
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new(0, 2, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = Bg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local active = false
    Bg.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = active and UI_Lib.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
        callback(active)
    end)
end

-- Resize Handle (Functional Fix)
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = ""
ResizeHandle.ZIndex = 5
ResizeHandle.Parent = MainFrame

local resing = false
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resing = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resing = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if resing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local newX = math.clamp(mousePos.X - MainFrame.AbsolutePosition.X, 350, 700)
        local newY = math.clamp((mousePos.Y - 36) - MainFrame.AbsolutePosition.Y, 200, 500)
        MainFrame.Size = UDim2.new(0, newX, 0, newY)
    end
end)

-- Initialize Tabs
local TabFinder = UI_Lib:CreateTab("Fruits Finder")
local TabSetting = UI_Lib:CreateTab("Setting")
local TabStatus = UI_Lib:CreateTab("Status")

UI_Lib:CreateSwitch(TabFinder, "Fruit ESP", function(v) UI_Lib.Settings.ESP_Enabled = v end)
UI_Lib:CreateSwitch(TabFinder, "Auto Tween", function(v) UI_Lib.Settings.Tween_Enabled = v end)
UI_Lib:CreateSwitch(TabFinder, "Auto Store", function(v) UI_Lib.Settings.AutoStore = v end)

TabFinder.Visible = true
UI_Lib.CurrentTab = TabFinder

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        UI_Lib.Visible = not UI_Lib.Visible
        MainFrame.Visible = UI_Lib.Visible
    end
end)

return UI_Lib