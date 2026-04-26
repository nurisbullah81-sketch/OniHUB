-- CatHUB v9.6: Final RedzHub Layout Remake
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local C = {
    Base = Color3.fromRGB(15, 15, 17),
    Side = Color3.fromRGB(22, 22, 26),
    Top = Color3.fromRGB(22, 22, 26),
    Card = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(88, 101, 242),
    Text = Color3.fromRGB(240, 240, 245),
    TextDim = Color3.fromRGB(160, 160, 170),
    Stroke = Color3.fromRGB(45, 45, 50)
}

-- ==========================================
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 580, 0, 360)
Main.Position = UDim2.new(0.5, -290, 0.5, -180)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local function Round(obj, r)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, r)
end

local function AddStroke(obj, color)
    local s = Instance.new("UIStroke", obj)
    s.Color = color
    s.Thickness = 1
    s.Transparency = 0.6
end

Round(Main, 10)
AddStroke(Main, C.Stroke)

-- Top Bar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = C.Top
Top.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "redz Hub [ BETA ACCESS ] : Blox Fruits"
Title.TextColor3 = C.Text
Title.Font = Enum.Font.Gotham
Title.TextSize = 12
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Top)
Close.Size = UDim2.new(0, 35, 1, 0)
Close.Position = UDim2.new(1, -35, 0, 0)
Close.Text = "✕"
Close.TextColor3 = C.TextDim
Close.Font = Enum.Font.GothamBold
Close.BackgroundTransparency = 1

-- Sidebar (Tab Area)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = C.Side
Sidebar.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.Padding = UDim.new(0, 5)
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)

-- Content Area
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -170, 1, -45)
Container.Position = UDim2.new(0, 160, 0, 40)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = C.Accent
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y

Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

-- ==========================================
-- TAB BUTTON (BIAR MIRIP REDZ)
-- ==========================================
local function AddTab(name, iconId)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.new(0, 10, 0, 0)
    b.BackgroundColor3 = C.Card
    b.Text = "  " .. name
    b.TextColor3 = C.Text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.TextXAlignment = "Left"
    Round(b, 6)
    
    -- Icon Placeholder
    local img = Instance.new("ImageLabel", b)
    img.Size = UDim2.new(0, 16, 0, 16)
    img.Position = UDim2.new(0, 8, 0.5, -8)
    img.Image = iconId or "rbxassetid://6031225818"
    img.BackgroundTransparency = 1
    b.Text = "      " .. name
end

-- ==========================================
-- TOGGLE & SECTION (STYLE REDZ)
-- ==========================================
local function Section(txt)
    local l = Instance.new("TextLabel", Container)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = txt
    l.TextColor3 = C.Text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 15
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
end

local function Toggle(key, txt)
    local f = Instance.new("TextButton", Container)
    f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    f.Text = ""
    Round(f, 6)
    AddStroke(f, C.Stroke)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.Text = txt
    l.TextColor3 = C.TextDim
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    
    local sw = Instance.new("Frame", f)
    sw.Size = UDim2.new(0, 32, 0, 16)
    sw.Position = UDim2.new(1, -42, 0.5, -8)
    sw.BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(50, 50, 55)
    Round(sw, 10)
    
    local d = Instance.new("Frame", sw)
    d.Size = UDim2.new(0, 12, 0, 12)
    d.Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    d.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Round(d, 10)
    
    f.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(50, 50, 55)}):Play()
        TweenService:Create(d, TweenInfo.new(0.2), {Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
end

-- ==========================================
-- BUILD UI
-- ==========================================
AddTab("Visual", "rbxassetid://6034287525")
AddTab("Farming", "rbxassetid://6031265917") -- Contoh aja, biar sidebarnya nggak kosong kayak foto Redz

Section("ESP")
Toggle("PlayerESP", "Enable Player ESP")
Toggle("FruitESP", "Enable Fruit ESP")
Section("World")
Toggle("ChestESP", "Auto Chest [ Tween ]")

-- Resize Handle (Kanan Bawah)
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 20, 0, 20)
Resizer.Position = UDim2.new(1, -20, 1, -20)
Resizer.Text = "⌟"
Resizer.TextColor3 = C.TextDim
Resizer.BackgroundTransparency = 1

local dragging, dragInput, dragStart, startPos
Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
Top.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

Close.MouseButton1Click:Connect(function() Gui:Destroy() end)