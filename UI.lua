-- CatHUB Premium: UI Module (Slider Update)
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
        Tween_Enabled = false,
        Tween_Speed = 300 -- Default Speed
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatHUB_Master"
ScreenGui.Parent = CoreGui
UI_Lib.MainGui = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Sidebar & Content
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -45)
Sidebar.Position = UDim2.new(0, 5, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local TabHolder = Instance.new("ScrollingFrame")
TabHolder.Size = UDim2.new(1, -10, 1, -10)
TabHolder.Position = UDim2.new(0, 5, 0, 5)
TabHolder.BackgroundTransparency = 1
TabHolder.ScrollBarThickness = 0
TabHolder.Parent = Sidebar
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -175, 1, -50)
ContentFrame.Position = UDim2.new(0, 170, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CATHUB | BLOX FRUITS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- UI Components Logic
function UI_Lib:CreateTab(name)
    local Container = Instance.new("ScrollingFrame")
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

function UI_Lib:CreateToggle(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = name .. " : OFF"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
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

function UI_Lib:CreateSlider(parent, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 45)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SliderFrame.Parent = parent
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. " : " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 4)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBar.Parent = SliderFrame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Fill.Parent = SliderBar

    local isDragging = false
    local function UpdateSlider()
        local mousePos = UserInputService:GetMouseLocation()
        local relativePos = mousePos.X - SliderBar.AbsolutePosition.X
        local percentage = math.clamp(relativePos / SliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * percentage)
        
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Label.Text = name .. " : " .. value
        callback(value)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = true UpdateSlider() end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider() end
    end)
end

-- Initialize
local MainTab = UI_Lib:CreateTab("Main")
UI_Lib:CreateToggle(MainTab, "ESP Fruits", function(val) UI_Lib.Settings.ESP_Enabled = val end)
UI_Lib:CreateToggle(MainTab, "Auto Tween Fruit", function(val) UI_Lib.Settings.Tween_Enabled = val end)
UI_Lib:CreateSlider(MainTab, "Tween Speed", 100, 500, 300, function(val) UI_Lib.Settings.Tween_Speed = val end)

MainTab.Visible = true
UI_Lib.CurrentTab = MainTab

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        UI_Lib.Visible = not UI_Lib.Visible
        MainFrame.Visible = UI_Lib.Visible
    end
end)

return UI_Lib