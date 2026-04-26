-- CatHUB FREEMIUM: Master UI (Stable Extended Edition)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("CatHUB_Freemium") then CoreGui.CatHUB_Freemium:Destroy() end

local UI_Lib = {
    CurrentTab = nil,
    Visible = true,
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 300)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CATHUB FREEMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -32, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    UI_Lib.Visible = false
    MainFrame.Visible = false
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -42)
Sidebar.Position = UDim2.new(0, 5, 0, 37)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)

local TabList = Instance.new("ScrollingFrame")
TabList.Size = UDim2.new(1, -6, 1, -6)
TabList.Position = UDim2.new(0, 3, 0, 3)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
TabList.Parent = Sidebar
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -145, 1, -42)
ContentArea.Position = UDim2.new(0, 140, 0, 37)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

function UI_Lib:CreateTab(name)
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -10, 1, -10)
    Container.Position = UDim2.new(0, 5, 0, 5)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
    Container.Parent = ContentArea
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 6)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name:upper()
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 12
    Btn.Parent = TabList
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        if self.CurrentTab then self.CurrentTab.Visible = false end
        Container.Visible = true
        self.CurrentTab = Container
        for _, v in pairs(TabList:GetChildren()) do
            if v:IsA("TextButton") then 
                TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            end
        end
        TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)
    return Container
end

function UI_Lib:CreateSwitch(parent, title, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 42)
    Card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Card.Parent = parent
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local Bg = Instance.new("TextButton")
    Bg.Size = UDim2.new(0, 36, 0, 20)
    Bg.Position = UDim2.new(1, -48, 0.5, -10)
    Bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Bg.Text = ""
    Bg.Parent = Card
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(0, 3, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = Bg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local active = false
    Bg.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40, 40, 40)}):Play()
        callback(active)
    end)
end

function UI_Lib:CreateSlider(parent, title, min, max, default, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 55)
    Card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Card.Parent = parent
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)

    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, 0, 0, 20)
    T.Position = UDim2.new(0, 12, 0, 5)
    T.BackgroundTransparency = 1
    T.Text = title .. ": " .. default
    T.TextColor3 = Color3.fromRGB(255, 255, 255)
    T.Font = Enum.Font.SourceSansBold
    T.TextSize = 12
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = Card

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -24, 0, 4)
    Bar.Position = UDim2.new(0, 12, 0, 35)
    Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Bar.Parent = Card
    Instance.new("UICorner", Bar)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(160, 32, 240)
    Fill.Parent = Bar
    Instance.new("UICorner", Fill)

    local dragging = false
    local function move()
        local mouseX = UserInputService:GetMouseLocation().X
        local relX = mouseX - Bar.AbsolutePosition.X
        local perc = math.clamp(relX / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * perc)
        Fill.Size = UDim2.new(perc, 0, 1, 0)
        T.Text = title .. ": " .. val
        callback(val)
    end

    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then move() end end)
end

-- TABS
local FinderTab = UI_Lib:CreateTab("Fruits Finder")
local SettingTab = UI_Lib:CreateTab("Setting")
local StatusTab = UI_Lib:CreateTab("Status")

UI_Lib:CreateSwitch(FinderTab, "Fruit ESP", function(v) UI_Lib.Settings.ESP_Enabled = v end)
UI_Lib:CreateSwitch(FinderTab, "Auto Tween", function(v) UI_Lib.Settings.Tween_Enabled = v end)
UI_Lib:CreateSwitch(FinderTab, "Auto Store", function(v) UI_Lib.Settings.AutoStore = v end)
UI_Lib:CreateSlider(SettingTab, "Tween Speed", 100, 500, 300, function(v) UI_Lib.Settings.Tween_Speed = v end)

FinderTab.Visible = true
UI_Lib.CurrentTab = FinderTab

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        UI_Lib.Visible = not UI_Lib.Visible
        MainFrame.Visible = UI_Lib.Visible
    end
end)

return UI_Lib