-- CatHUB FREEMIUM Master UI (Ultra-Minimalist Edition)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("CatHUB_Freemium") then CoreGui.CatHUB_Freemium:Destroy() end

local UI_Lib = {
    CurrentTab = nil,
    Visible = true,
    AccentColor = Color3.fromRGB(160, 32, 240),
    Settings = {
        ESP_Enabled = false,
        Tween_Enabled = false,
        Tween_Speed = 300
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatHUB_Freemium"
ScreenGui.Parent = CoreGui
UI_Lib.MainGui = ScreenGui

-- Main Frame (Compact Size: 480x300)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

-- Elegant Border
local Border = Instance.new("Frame")
Border.Size = UDim2.new(1, 2, 1, 2)
Border.Position = UDim2.new(0, -1, 0, -1)
Border.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Border.ZIndex = 0
Border.Parent = MainFrame
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 7)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
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

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sidebar (Compact)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -45)
Sidebar.Position = UDim2.new(0, 5, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)

local TabList = Instance.new("ScrollingFrame")
TabList.Size = UDim2.new(1, -10, 1, -10)
TabList.Position = UDim2.new(0, 5, 0, 5)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
TabList.Parent = Sidebar
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 4)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -145, 1, -45)
ContentArea.Position = UDim2.new(0, 140, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Tab System
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
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name:upper()
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.SourceSans
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

-- Sliding Switch Component
function UI_Lib:CreateSwitch(parent, title, desc, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 55)
    Card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Card.Parent = parent
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)

    local TName = Instance.new("TextLabel")
    TName.Size = UDim2.new(1, -70, 0, 20)
    TName.Position = UDim2.new(0, 12, 0, 8)
    TName.BackgroundTransparency = 1
    TName.Text = title
    TName.TextColor3 = Color3.fromRGB(255, 255, 255)
    TName.Font = Enum.Font.SourceSansBold
    TName.TextSize = 13
    TName.TextXAlignment = Enum.TextXAlignment.Left
    TName.Parent = Card

    local TDesc = Instance.new("TextLabel")
    TDesc.Size = UDim2.new(1, -70, 0, 15)
    TDesc.Position = UDim2.new(0, 12, 0, 28)
    TDesc.BackgroundTransparency = 1
    TDesc.Text = desc
    TDesc.TextColor3 = Color3.fromRGB(120, 120, 120)
    TDesc.Font = Enum.Font.SourceSans
    TDesc.TextSize = 11
    TDesc.TextXAlignment = Enum.TextXAlignment.Left
    TDesc.Parent = Card

    local SwitchBg = Instance.new("TextButton")
    SwitchBg.Size = UDim2.new(0, 40, 0, 20)
    SwitchBg.Position = UDim2.new(1, -52, 0.5, -10)
    SwitchBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SwitchBg.Text = ""
    SwitchBg.Parent = Card
    Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(0, 3, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = SwitchBg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local enabled = false
    SwitchBg.MouseButton1Click:Connect(function()
        enabled = not enabled
        local targetPos = enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        local targetColor = enabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40, 40, 40)
        
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        callback(enabled)
    end)
end

-- Slider Component
function UI_Lib:CreateSlider(parent, title, min, max, default, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 65)
    Card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Card.Parent = parent
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)

    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, -20, 0, 20)
    T.Position = UDim2.new(0, 12, 0, 8)
    T.BackgroundTransparency = 1
    T.Text = title .. ": " .. default
    T.TextColor3 = Color3.fromRGB(255, 255, 255)
    T.Font = Enum.Font.SourceSansBold
    T.TextSize = 13
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = Card

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -24, 0, 4)
    Bar.Position = UDim2.new(0, 12, 0, 42)
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
        local m = UserInputService:GetMouseLocation().X
        local rel = m - Bar.AbsolutePosition.X
        local perc = math.clamp(rel/Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max-min)*perc)
        Fill.Size = UDim2.new(perc, 0, 1, 0)
        T.Text = title .. ": " .. val
        callback(val)
    end
    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then move() end end)
end

-- === TABS ===
local TabFinder = UI_Lib:CreateTab("Fruits Finder")
local TabSetting = UI_Lib:CreateTab("Setting")
local TabStatus = UI_Lib:CreateTab("Status")
local TabFarm = UI_Lib:CreateTab("Main Farm")

-- Components
UI_Lib:CreateSwitch(TabFinder, "Fruit ESP", "High-visibility fruit tracker", function(v) UI_Lib.Settings.ESP_Enabled = v end)
UI_Lib:CreateSwitch(TabFinder, "Auto Tween", "Smooth travel to nearest fruit", function(v) UI_Lib.Settings.Tween_Enabled = v end)
UI_Lib:CreateSlider(TabSetting, "Tween Speed", 100, 500, 300, function(v) UI_Lib.Settings.Tween_Speed = v end)

-- Status
local Lvl = Instance.new("TextLabel", TabStatus)
Lvl.Size = UDim2.new(1, 0, 0, 20)
Lvl.BackgroundTransparency = 1
Lvl.TextColor3 = Color3.fromRGB(200, 200, 200)
Lvl.Font = Enum.Font.SourceSans
Lvl.TextSize = 13
Lvl.TextXAlignment = Enum.TextXAlignment.Left

-- Main Farm
local CS = Instance.new("TextLabel", TabFarm)
CS.Size = UDim2.new(1, 0, 1, 0)
CS.BackgroundTransparency = 1
CS.Text = "COMING SOON"
CS.TextColor3 = Color3.fromRGB(60, 60, 60)
CS.Font = Enum.Font.SourceSansBold
CS.TextSize = 20

-- Loop Status
task.spawn(function()
    while task.wait(1) do
        local d = Players.LocalPlayer:FindFirstChild("Data")
        if d then Lvl.Text = "Level: " .. d.Level.Value .. " | Beli: " .. d.Beli.Value end
    end
end)

-- Start
TabFinder.Visible = true
UI_Lib.CurrentTab = TabFinder

-- Keybind Toggle [Ctrl + G]
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        UI_Lib.Visible = not UI_Lib.Visible
        MainFrame.Visible = UI_Lib.Visible
    end
end)

return UI_Lib