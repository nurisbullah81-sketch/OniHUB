-- CatHUB v9.7: RedzHub Mobile/PC Exact Remake
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
    Side = Color3.fromRGB(20, 20, 22),
    Top = Color3.fromRGB(20, 20, 22),
    TabDark = Color3.fromRGB(25, 25, 28),
    ButtonBase = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(88, 101, 242), -- Purple-ish Blue Redz
    Text = Color3.fromRGB(255, 255, 255),
    TextSec = Color3.fromRGB(180, 180, 185),
    Stroke = Color3.fromRGB(45, 45, 50)
}

-- Utility Functions
local function Round(obj, r)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, r)
end

local function AddStroke(obj, color, trans)
    local s = Instance.new("UIStroke", obj)
    s.Color = color
    s.Thickness = 1
    s.Transparency = trans or 0.5
end

-- ==========================================
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 600, 0, 380)
Main.Position = UDim2.new(0.5, -300, 0.5, -190)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Round(Main, 12)
AddStroke(Main, C.Stroke)

-- Top Bar (Dragging Area)
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = C.Top
Top.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "redz Hub [ BETA ACCESS ] : Blox Fruits"
Title.TextColor3 = C.Text
Title.Font = Enum.Font.Gotham
Title.TextSize = 12
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

-- Control Buttons
local Close = Instance.new("TextButton", Top)
Close.Size = UDim2.new(0, 35, 1, 0)
Close.Position = UDim2.new(1, -35, 0, 0)
Close.Text = "✕"
Close.TextColor3 = C.Text
Close.Font = Enum.Font.GothamBold
Close.BackgroundTransparency = 1

local Min = Instance.new("TextButton", Top)
Min.Size = UDim2.new(0, 35, 1, 0)
Min.Position = UDim2.new(1, -65, 0, 0)
Min.Text = "—"
Min.TextColor3 = C.Text
Min.Font = Enum.Font.GothamBold
Min.BackgroundTransparency = 1

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = C.Side
Sidebar.BorderSizePixel = 0

local SideScroll = Instance.new("ScrollingFrame", Sidebar)
SideScroll.Size = UDim2.new(1, 0, 1, -10)
SideScroll.Position = UDim2.new(0, 0, 0, 5)
SideScroll.BackgroundTransparency = 1
SideScroll.ScrollBarThickness = 0
SideScroll.CanvasSize = UDim2.new(0,0,0,0)
SideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SideList = Instance.new("UIListLayout", SideScroll)
SideList.Padding = UDim.new(0, 6)
Instance.new("UIPadding", SideScroll).PaddingLeft = UDim.new(0, 10)
Instance.new("UIPadding", SideScroll).PaddingRight = UDim.new(0, 10)

-- Content Area
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -165, 1, -50)
Container.Position = UDim2.new(0, 155, 0, 45)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = C.Accent
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y

Instance.new("UIListLayout", Container).Padding = UDim.new(0, 12)
Instance.new("UIPadding", Container).PaddingRight = UDim.new(0, 10)

-- ==========================================
-- COMPONENTS (TAB, TOGGLE, SECTION)
-- ==========================================
local function AddTab(name, iconId)
    local b = Instance.new("TextButton", SideScroll)
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = C.TabDark
    b.Text = "        " .. name
    b.TextColor3 = C.TextSec
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.TextXAlignment = "Left"
    b.AutoButtonColor = false
    Round(b, 6)
    
    local icon = Instance.new("ImageLabel", b)
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(0, 8, 0.5, -9)
    icon.Image = iconId or "rbxassetid://6023426915"
    icon.BackgroundTransparency = 1
    icon.ImageColor3 = C.TextSec
end

local function Section(txt)
    local l = Instance.new("TextLabel", Container)
    l.Size = UDim2.new(1, 0, 0, 25)
    l.Text = txt
    l.TextColor3 = C.Text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 16
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
end

local function Toggle(key, txt)
    local f = Instance.new("TextButton", Container)
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = C.ButtonBase
    f.Text = ""
    f.AutoButtonColor = false
    Round(f, 8)
    AddStroke(f, C.Stroke, 0.7)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.Text = txt
    l.TextColor3 = C.TextSec
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    
    local sw = Instance.new("Frame", f)
    sw.Size = UDim2.new(0, 36, 0, 18)
    sw.Position = UDim2.new(1, -48, 0.5, -9)
    sw.BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(55, 55, 60)
    Round(sw, 10)
    
    local d = Instance.new("Frame", sw)
    d.Size = UDim2.new(0, 14, 0, 14)
    d.Position = S[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    d.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Round(d, 10)
    
    f.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(55, 55, 60)}):Play()
        TweenService:Create(d, TweenInfo.new(0.2), {Position = S[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
    end)
end

-- ==========================================
-- INIT UI
-- ==========================================
AddTab("Discord", "rbxassetid://6023426915")
AddTab("Farm", "rbxassetid://6031265917")
AddTab("Fishing", "rbxassetid://6034287525")
AddTab("Visual", "rbxassetid://6034287535")

Section("Events")
Toggle("AutoCelestial", "Auto Celestial Soldier")
Toggle("AutoRip", "Auto Rip Commander")
Section("Collect")
Toggle("ChestESP", "Auto Chest [ Tween ]")

-- Resize Handle
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 20, 0, 20)
Resizer.Position = UDim2.new(1, -20, 1, -20)
Resizer.Text = "⌟"
Resizer.TextColor3 = C.TextSec
Resizer.BackgroundTransparency = 1
Resizer.ZIndex = 5

-- Dragging & Logic
local dragging, dragStart, startPos
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