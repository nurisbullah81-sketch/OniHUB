--[[
    DIZ HUB - REDZ EDITION (Modular UI)
    Style: Premium Dark, Sidebar, Gotham Fonts
    Features: Keybind Ctrl+G, Custom Toggles
]]

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Bersihkan UI lama
if CoreGui:FindFirstChild("DIZ_Redz_Master") then CoreGui.DIZ_Redz_Master:Destroy() end

local UI_Lib = {
    CurrentTab = nil,
    Visible = true,
    Settings = { -- Ini akan diakses oleh Main.lua
        ESP_Enabled = false,
        Tween_Enabled = false
    }
}

-- Buat Container Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DIZ_Redz_Master"
ScreenGui.Parent = CoreGui
UI_Lib.MainGui = ScreenGui

-- Main Frame (Ukuran RedzHub)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Left Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local TabHolder = Instance.new("ScrollingFrame")
TabHolder.Name = "TabHolder"
TabHolder.Size = UDim2.new(1, -10, 1, -10)
TabHolder.Position = UDim2.new(0, 5, 0, 5)
TabHolder.BackgroundTransparency = 1
TabHolder.BorderSizePixel = 0
TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
TabHolder.ScrollBarThickness = 2
TabHolder.Parent = Sidebar
local TabLayout = Instance.new("UIListLayout", TabHolder)
TabLayout.Padding = UDim.new(0, 5)

-- Top Bar (Title)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BLOX HUB | REDZ EDITION"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold -- Gotham Font untuk look profesional
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -160, 1, -50)
ContentFrame.Position = UDim2.new(0, 155, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Helper: Buat Container Tab
local function CreateTabContainer(name)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = name .. "_Container"
    Container.Size = UDim2.new(1, 0, 1, 0)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.ScrollBarThickness = 2
    Container.Visible = false
    Container.Parent = ContentFrame
    
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 8)
    local Padding = Instance.new("UIPadding", Container)
    Padding.PaddingTop = UDim.new(0, 5)
    
    return Container
end

-- Helper: Buat Tombol Tab
local function CreateTabButton(name, container)
    local Btn = Instance.new("TextButton")
    Btn.Name = name .. "_Tab"
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name:upper()
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.Parent = TabHolder
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        if UI_Lib.CurrentTab then UI_Lib.CurrentTab.Visible = false end
        container.Visible = true
        UI_Lib.CurrentTab = container
        
        -- Reset warna tombol lain
        for _, v in pairs(TabHolder:GetChildren()) do
            if v:IsA("TextButton") then
                TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end
        end
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
end

-- Helper: Buat Toggle (Redz Style)
function UI_Lib:CreateToggle(parent, name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "_Toggle"
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ToggleFrame.Parent = parent
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 40)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleFrame
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = default and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.Parent = ToggleBtn
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    
    local enabled = default
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 40)}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = enabled and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)}):Play()
        callback(enabled)
    end)
end

-- === KONFIGURASI TAB UTAMA ===
local MainTabContainer = CreateTabContainer("Main")
CreateTabButton("Main Functions", MainTabContainer)

-- Aktifkan Tab Utama
MainTabContainer.Visible = true
UI_Lib.CurrentTab = MainTabContainer
for _, v in pairs(TabHolder:GetChildren()) do if v:IsA("TextButton") and v.Name == "MainFunctions_Tab" then v.BackgroundColor3 = Color3.fromRGB(30, 30, 30) v.TextColor3 = Color3.fromRGB(255, 255, 255) end end

-- === TAMBAHKAN TOGGLES ===
UI_Lib:CreateToggle(MainTabContainer, "ESP Fruits (White)", false, function(val)
    UI_Lib.Settings.ESP_Enabled = val
end)

UI_Lib:CreateToggle(MainTabContainer, "Auto Tween to Fruit", false, function(val)
    UI_Lib.Settings.Tween_Enabled = val
end)

-- Footer (Keybind Info)
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -10, 0, 30)
Footer.Position = UDim2.new(0, 10, 1, -30)
Footer.BackgroundTransparency = 1
Footer.Text = "Press [ CTRL + G ] to Toggle Menu"
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 11
Footer.Parent = MainFrame

-- Keybind Logic
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        UI_Lib.Visible = not UI_Lib.Visible
        MainFrame.Visible = UI_Lib.Visible
    end
end)

print("DIZ HUB: REDZ UI LOADED. CTRL+G TO TOGGLE.")
return UI_Lib