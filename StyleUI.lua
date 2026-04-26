-- CatHUB v11.0: THE REAL REDZHUB CLONE (1:1 VISUAL)
-- Gue udah melototin gambar RedzHub, kali ini detailnya gue bikin dapet.

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"

-- Palette Warna 1:1 RedzHub
local Theme = {
    Main = Color3.fromRGB(18, 18, 20),
    Sidebar = Color3.fromRGB(22, 22, 25),
    Accent = Color3.fromRGB(100, 115, 255), -- Purple-Blue khas Redz
    Section = Color3.fromRGB(28, 28, 32),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 155),
    Stroke = Color3.fromRGB(45, 45, 50)
}

-- ==========================================
-- LOGO HIDE (KOTAK KECIL REDZ - FLOATING)
-- ==========================================
local OpenBtn = Instance.new("ImageButton", Gui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0, 20)
OpenBtn.Visible = false
OpenBtn.BackgroundColor3 = Theme.Main
OpenBtn.Image = "rbxassetid://6023426915" -- Logo Redz Asli
OpenBtn.ScaleType = Enum.ScaleType.Fit
local OBC = Instance.new("UICorner", OpenBtn)
OBC.CornerRadius = UDim.new(0, 12)
local OBS = Instance.new("UIStroke", OpenBtn)
OBS.Color = Theme.Accent
OBS.Thickness = 1.5

-- ==========================================
-- MAIN FRAME (DETAIL SHADOW & ROUNDING)
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 580, 0, 380)
Main.Position = UDim2.new(0.5, -290, 0.5, -190)
Main.BackgroundColor3 = Theme.Main
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Theme.Stroke
MStroke.Thickness = 1

-- Top Bar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 40)
Top.BackgroundColor3 = Theme.Sidebar
Top.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.Text = "redz Hub [ BETA ACCESS ] : Blox Fruits"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 13
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

local Icon = Instance.new("ImageLabel", Top)
Icon.Size = UDim2.new(0, 22, 0, 22)
Icon.Position = UDim2.new(0, 15, 0.5, -11)
Icon.Image = "rbxassetid://6023426915"
Icon.BackgroundTransparency = 1

-- Close & Min
local function ControlBtn(txt, pos, color)
    local b = Instance.new("TextButton", Top)
    b.Size = UDim2.new(0, 35, 0, 35)
    b.Position = pos
    b.Text = txt
    b.TextColor3 = color or Theme.Text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BackgroundTransparency = 1
    return b
end

local Close = ControlBtn("✕", UDim2.new(1, -40, 0, 2), Color3.fromRGB(255, 100, 100))
local Min = ControlBtn("—", UDim2.new(1, -75, 0, 2))

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 155, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Theme.Sidebar

-- Sidebar Item (HANYA 1 TAB: ESP)
local Tab = Instance.new("TextButton", Sidebar)
Tab.Size = UDim2.new(1, -20, 0, 38)
Tab.Position = UDim2.new(0, 10, 0, 15)
Tab.BackgroundColor3 = Theme.Accent
Tab.Text = "      Visuals/ESP"
Tab.TextColor3 = Theme.Text
Tab.Font = Enum.Font.GothamMedium
Tab.TextSize = 13
Tab.TextXAlignment = "Left"
Tab.AutoButtonColor = false
Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 8)

local TabIcon = Instance.new("ImageLabel", Tab)
TabIcon.Size = UDim2.new(0, 18, 0, 18)
TabIcon.Position = UDim2.new(0, 10, 0.5, -9)
TabIcon.Image = "rbxassetid://6034287535"
TabIcon.BackgroundTransparency = 1

-- Container
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -175, 1, -60)
Container.Position = UDim2.new(0, 165, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Theme.Accent
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
local List = Instance.new("UIListLayout", Container)
List.Padding = UDim.new(0, 10)

-- ==========================================
-- COMPONENTS (THE REAL REDZ STYLE)
-- ==========================================
local function Section(txt)
    local f = Instance.new("Frame", Container)
    f.Size = UDim2.new(1, -5, 0, 25)
    f.BackgroundTransparency = 1
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Text = txt:upper()
    l.TextColor3 = Theme.Accent
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1, -80, 0, 1)
    line.Position = UDim2.new(0, 70, 0.5, 0)
    line.BackgroundColor3 = Theme.Stroke
    line.BorderSizePixel = 0
end

local function Toggle(txt, default)
    local state = default or false
    local f = Instance.new("TextButton", Container)
    f.Size = UDim2.new(1, -10, 0, 45)
    f.BackgroundColor3 = Theme.Section
    f.Text = ""
    f.AutoButtonColor = false
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", f).Color = Theme.Stroke
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.new(0, 15, 0, 0)
    l.Text = txt
    l.TextColor3 = Theme.TextDim
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    
    local bg = Instance.new("Frame", f)
    bg.Size = UDim2.new(0, 40, 0, 20)
    bg.Position = UDim2.new(1, -55, 0.5, -10)
    bg.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", bg)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    f.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(bg, TweenInfo.new(0.25), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(40, 40, 45)}):Play()
        TweenService:Create(dot, TweenInfo.new(0.25), {Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)}):Play()
        TweenService:Create(l, TweenInfo.new(0.25), {TextColor3 = state and Theme.Text or Theme.TextDim}):Play()
    end)
end

-- Build Content
Section("Devil Fruits")
Toggle("Enable Fruit ESP", true)
Section("World")
Toggle("Auto Chest Finder", false)
Toggle("Player Names", false)

-- ==========================================
-- FIX LOGIC (RESIZE, HIDE, MINIMIZE)
-- ==========================================

-- 1. Resize Pojok Bawah (Corner Grabber)
local ResizeGrab = Instance.new("Frame", Main)
ResizeGrab.Size = UDim2.new(0, 20, 0, 20)
ResizeGrab.Position = UDim2.new(1, -20, 1, -20)
ResizeGrab.BackgroundTransparency = 1

local isResizing = false
ResizeGrab.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = true end end)
UserInput.InputChanged:Connect(function(i)
    if isResizing and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - Vector3.new(Main.AbsolutePosition.X, Main.AbsolutePosition.Y, 0)
        Main.Size = UDim2.new(0, math.clamp(delta.X, 400, 800), 0, math.clamp(delta.Y, 250, 600))
    end
end)
UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end end)

-- 2. X = HIDE
Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- 3. MINIMIZE
local isMin = false
Min.MouseButton1Click:Connect(function()
    isMin = not isMin
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = isMin and UDim2.new(0, Main.Size.X.Offset, 0, 40) or UDim2.new(0, Main.Size.X.Offset, 0, 380)}):Play()
end)

-- 4. Dragging
local drag, dStart, sPos
Top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dStart = i.Position; sPos = Main.Position end end)
UserInput.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dStart
        Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)
UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)