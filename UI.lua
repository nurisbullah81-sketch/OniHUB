-- CatHUB FREEMIUM: UI Module (Anti-Stun Update)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local ConfigFile = "CatHUB_Config.json"

if CoreGui:FindFirstChild("CatHUB_Freemium") then CoreGui.CatHUB_Freemium:Destroy() end

local UI_Lib = {
    CurrentTab = nil,
    Visible = true,
    AccentColor = Color3.fromRGB(130, 80, 255),
    Settings = {
        ESP_Enabled = false,
        Tween_Enabled = false,
        Tween_Speed = 300,
        AutoStore = false,
        PlayerESP_Enabled = false,
        LockAim_Enabled = false,
        WalkWater_Enabled = false,
        FastRun_Enabled = false,
        Run_Speed = 16,
        HighJump_Enabled = false,
        Jump_Power = 50,
        AntiStun_Enabled = false -- New Setting
    }
}

function UI_Lib:SaveSettings()
    if writefile then pcall(function() writefile(ConfigFile, HttpService:JSONEncode(self.Settings)) end) end
end

function UI_Lib:LoadSettings()
    if isfile and isfile(ConfigFile) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if success then for k, v in pairs(decoded) do UI_Lib.Settings[k] = v end end
    end
end

UI_Lib:LoadSettings()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatHUB_Freemium"
ScreenGui.Parent = CoreGui
UI_Lib.MainGui = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(40, 40, 40)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
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
CloseBtn.MouseButton1Click:Connect(function() UI_Lib.Visible = false MainFrame.Visible = false end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 115, 1, -40)
Sidebar.Position = UDim2.new(0, 5, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)

local TabList = Instance.new("ScrollingFrame")
TabList.Size = UDim2.new(1, -6, 1, -6)
TabList.Position = UDim2.new(0, 3, 0, 3)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
TabList.Parent = Sidebar
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 4)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -130, 1, -40)
ContentArea.Position = UDim2.new(0, 125, 0, 35)
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
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name:upper()
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.SourceSansBold
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

function UI_Lib:CreateSwitch(parent, settingName, title, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 32)
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Card.Parent = parent
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -45, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = title
    L.TextColor3 = Color3.fromRGB(200, 200, 200)
    L.Font = Enum.Font.SourceSansBold
    L.TextSize = 11
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = Card

    local Bg = Instance.new("TextButton")
    Bg.Size = UDim2.new(0, 30, 0, 14)
    Bg.Position = UDim2.new(1, -38, 0.5, -7)
    Bg.BackgroundColor3 = self.Settings[settingName] and UI_Lib.AccentColor or Color3.fromRGB(40, 40, 40)
    Bg.Text = ""
    Bg.Parent = Card
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 10, 0, 10)
    Knob.Position = self.Settings[settingName] and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = Bg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    Bg.MouseButton1Click:Connect(function()
        self.Settings[settingName] = not self.Settings[settingName]
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = self.Settings[settingName] and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
        TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = self.Settings[settingName] and UI_Lib.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
        UI_Lib:SaveSettings()
        callback(self.Settings[settingName])
    end)
    callback(self.Settings[settingName])
end

function UI_Lib:CreateSlider(parent, settingName, title, min, max, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 48)
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Card.Parent = parent
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)

    local T = Instance.new("TextLabel")
    local default = self.Settings[settingName]
    T.Size = UDim2.new(1, 0, 0, 18)
    T.Position = UDim2.new(0, 10, 0, 4)
    T.BackgroundTransparency = 1
    T.Text = title .. ": " .. default
    T.TextColor3 = Color3.fromRGB(255, 255, 255)
    T.Font = Enum.Font.SourceSansBold
    T.TextSize = 11
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = Card

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -20, 0, 4)
    Bar.Position = UDim2.new(0, 10, 0, 30)
    Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Bar.Parent = Card
    Instance.new("UICorner", Bar)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = UI_Lib.AccentColor
    Fill.Parent = Bar
    Instance.new("UICorner", Fill)

    local dragging = false
    local function move()
        local mX = UserInputService:GetMouseLocation().X
        local rX = mX - Bar.AbsolutePosition.X
        local perc = math.clamp(rX / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max-min)*perc)
        Fill.Size = UDim2.new(perc, 0, 1, 0)
        T.Text = title .. ": " .. val
        UI_Lib.Settings[settingName] = val
        UI_Lib:SaveSettings()
        callback(val)
    end
    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then move() end end)
    callback(default)
end

-- TABS
local PVPTab = UI_Lib:CreateTab("PVP Elite")
local FinderTab = UI_Lib:CreateTab("Finder")
local SettingTab = UI_Lib:CreateTab("Setting")

UI_Lib:CreateSwitch(PVPTab, "LockAim_Enabled", "Sticky Lock Aim", function(v) end)
UI_Lib:CreateSwitch(PVPTab, "AntiStun_Enabled", "Anti-Stun (Passive)", function(v) end)
UI_Lib:CreateSwitch(PVPTab, "PlayerESP_Enabled", "Player ESP", function(v) end)
UI_Lib:CreateSwitch(PVPTab, "WalkWater_Enabled", "Walk On Water", function(v) end)
UI_Lib:CreateSwitch(PVPTab, "FastRun_Enabled", "Enable Run Speed", function(v) end)
UI_Lib:CreateSlider(PVPTab, "Run_Speed", "Run Speed Value", 16, 250, function(v) end)
UI_Lib:CreateSwitch(PVPTab, "HighJump_Enabled", "Enable High Jump", function(v) end)
UI_Lib:CreateSlider(PVPTab, "Jump_Power", "Jump Power Value", 50, 300, function(v) end)

UI_Lib:CreateSwitch(FinderTab, "ESP_Enabled", "Fruit ESP", function(v) end)
UI_Lib:CreateSwitch(FinderTab, "Tween_Enabled", "Auto Tween", function(v) end)
UI_Lib:CreateSwitch(FinderTab, "AutoStore", "Auto Store", function(v) end)
UI_Lib:CreateSlider(SettingTab, "Tween_Speed", "Tween Speed", 100, 500, function(v) end)

PVPTab.Visible = true
UI_Lib.CurrentTab = PVPTab

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        UI_Lib.Visible = not UI_Lib.Visible
        MainFrame.Visible = UI_Lib.Visible
    end
end)

return UI_Lib