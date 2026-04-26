-- CatHUB FREEMIUM Master UI (Gamepass Style)
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

-- Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Top Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CATHUB FREEMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 170, 1, -70)
Sidebar.Position = UDim2.new(0, 10, 0, 60)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local TabList = Instance.new("ScrollingFrame")
TabList.Size = UDim2.new(1, -10, 1, -10)
TabList.Position = UDim2.new(0, 5, 0, 5)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
TabList.Parent = Sidebar
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 5)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -200, 1, -70)
ContentArea.Position = UDim2.new(0, 190, 0, 60)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Tab Engine
function UI_Lib:CreateTab(name)
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, 0, 1, 0)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
    Container.Parent = ContentArea
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name:upper()
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.Parent = TabList
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

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

-- Gamepass Style Card Component
function UI_Lib:CreateCard(parent, title, desc, callback_toggle)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -10, 0, 80)
    Card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Card.Parent = parent
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

    local TName = Instance.new("TextLabel")
    TName.Size = UDim2.new(1, -80, 0, 30)
    TName.Position = UDim2.new(0, 15, 0, 10)
    TName.BackgroundTransparency = 1
    TName.Text = title
    TName.TextColor3 = Color3.fromRGB(255, 255, 255)
    TName.Font = Enum.Font.GothamBold
    TName.TextSize = 14
    TName.TextXAlignment = Enum.TextXAlignment.Left
    TName.Parent = Card

    local TDesc = Instance.new("TextLabel")
    TDesc.Size = UDim2.new(1, -80, 0, 30)
    TDesc.Position = UDim2.new(0, 15, 0, 35)
    TDesc.BackgroundTransparency = 1
    TDesc.Text = desc
    TDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
    TDesc.Font = Enum.Font.Gotham
    TDesc.TextSize = 12
    TDesc.TextXAlignment = Enum.TextXAlignment.Left
    TDesc.Parent = Card

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 50, 0, 25)
    Toggle.Position = UDim2.new(1, -65, 0.5, -12)
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Font = Enum.Font.GothamBold
    Toggle.TextSize = 10
    Toggle.Parent = Card
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 4)

    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.Text = enabled and "ON" or "OFF"
        Toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40, 40, 40)
        callback_toggle(enabled)
    end)
end

-- Slider Component (For Setting Tab)
function UI_Lib:CreateSlider(parent, title, min, max, default, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -10, 0, 90)
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Card.Parent = parent
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, -20, 0, 30)
    T.Position = UDim2.new(0, 15, 0, 10)
    T.BackgroundTransparency = 1
    T.Text = title .. ": " .. default
    T.TextColor3 = Color3.fromRGB(255, 255, 255)
    T.Font = Enum.Font.GothamBold
    T.TextSize = 14
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = Card

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -30, 0, 6)
    Bar.Position = UDim2.new(0, 15, 0, 55)
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

-- === TAB INITIALIZATION ===
local FruitFinderTab = UI_Lib:CreateTab("Fruits Finder")
local SettingTab = UI_Lib:CreateTab("Setting")
local StatusTab = UI_Lib:CreateTab("Status")
local FarmTab = UI_Lib:CreateTab("Main Farm")

-- Fruits Finder Cards
UI_Lib:CreateCard(FruitFinderTab, "Fruit ESP", "Show location of dropped and system fruits", function(v) UI_Lib.Settings.ESP_Enabled = v end)
UI_Lib:CreateCard(FruitFinderTab, "Auto Tween", "Fly towards the nearest fruit automatically", function(v) UI_Lib.Settings.Tween_Enabled = v end)

-- Setting Tab (Gamepass Style)
UI_Lib:CreateSlider(SettingTab, "Tween Speed", 100, 500, 300, function(v) UI_Lib.Settings.Tween_Speed = v end)

-- Status Tab Logic
local Lvl = Instance.new("TextLabel", StatusTab)
Lvl.Size = UDim2.new(1, -10, 0, 30)
Lvl.BackgroundTransparency = 1
Lvl.TextColor3 = Color3.fromRGB(200, 200, 200)
Lvl.Font = Enum.Font.Gotham
Lvl.TextSize = 14
Lvl.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while task.wait(1) do
        local d = Players.LocalPlayer:FindFirstChild("Data")
        if d then Lvl.Text = "  Level: " .. d.Level.Value .. " | Beli: " .. d.Beli.Value end
    end
end)

-- Main Farm Tab
local CS = Instance.new("TextLabel", FarmTab)
CS.Size = UDim2.new(1, 0, 1, 0)
CS.BackgroundTransparency = 1
CS.Text = "COMING SOON"
CS.TextColor3 = Color3.fromRGB(60, 60, 60)
CS.Font = Enum.Font.GothamBold
CS.TextSize = 25

-- Initial State
FruitFinderTab.Visible = true
UI_Lib.CurrentTab = FruitFinderTab

-- Keybind [Ctrl + G]
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        UI_Lib.Visible = not UI_Lib.Visible
        MainFrame.Visible = UI_Lib.Visible
    end
end)

return UI_Lib