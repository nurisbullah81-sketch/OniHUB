-- CatHUB v9.5: RedzHub Real Remake (1:1 Style)
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false

-- Color Palette RedzHub
local C = {
    Base = Color3.fromRGB(20, 20, 22),
    Top = Color3.fromRGB(25, 25, 28),
    Accent = Color3.fromRGB(88, 101, 242), -- Blue Purple
    Text = Color3.fromRGB(240, 240, 245),
    TextDim = Color3.fromRGB(150, 150, 160),
    Stroke = Color3.fromRGB(50, 50, 55)
}

-- ==========================================
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 500, 0, 320)
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.BackgroundColor3 = C.Base
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = C.Stroke
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.5

-- Top Bar (Dragging Area)
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = C.Top
Top.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner", Top)
TopCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "redz Hub : Visuals [ CatHub ]"
Title.TextColor3 = C.Text
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 13
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

-- Control Buttons (X & -)
local function CreateCtrl(txt, pos, color)
    local b = Instance.new("TextButton", Top)
    b.Size = UDim2.new(0, 30, 0, 35)
    b.Position = pos
    b.Text = txt
    b.TextColor3 = C.TextDim
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BackgroundTransparency = 1
    return b
end

local Close = CreateCtrl("✕", UDim2.new(1, -35, 0, 0))
local Min = CreateCtrl("—", UDim2.new(1, -65, 0, 0))

-- Container Content
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -20, 1, -45)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = C.Accent
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local List = Instance.new("UIListLayout", Content)
List.Padding = UDim.new(0, 8)

-- ==========================================
-- RESIZE HANDLE (Pojok Kanan Bawah)
-- ==========================================
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 15, 0, 15)
Resizer.Position = UDim2.new(1, -15, 1, -15)
Resizer.BackgroundTransparency = 1
Resizer.Text = "◢"
Resizer.TextColor3 = C.TextDim
Resizer.TextSize = 12

local isResizing = false
Resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = true end
end)
UserInput.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInput:GetMouseLocation() - Vector2.new(0, 36)
        local newSize = UDim2.new(0, math.clamp(mousePos.X - Main.AbsolutePosition.X, 300, 800), 0, math.clamp(mousePos.Y - Main.AbsolutePosition.Y, 150, 600))
        Main.Size = newSize
    end
end)
UserInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end
end)

-- ==========================================
-- COMPONENTS
-- ==========================================
local function Section(text)
    local L = Instance.new("TextLabel", Content)
    L.Size = UDim2.new(1, 0, 0, 30)
    L.Text = text
    L.TextColor3 = C.Text
    L.Font = Enum.Font.GothamBold
    L.TextSize = 16
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
end

local function Toggle(key, text)
    local F = Instance.new("TextButton", Content)
    F.Size = UDim2.new(1, 0, 0, 40)
    F.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    F.AutoButtonColor = false
    F.Text = ""
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = text
    L.TextColor3 = C.TextDim
    L.Font = Enum.Font.Gotham
    L.TextSize = 14
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 34, 0, 18)
    Sw.Position = UDim2.new(1, -44, 0.5, -9)
    Sw.BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(60, 60, 65)
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 12, 0, 12)
    Dot.Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    F.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(60, 60, 65)}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
end

-- ==========================================
-- LOGIC & CONTENT
-- ==========================================
Section("ESP")
Toggle("PlayerESP", "Enable Player ESP")
Toggle("FruitESP", "Enable Fruit ESP")
Section("World")
Toggle("ChestESP", "Chest Finder")

-- Dragging
local dragStart, startPos, dragging
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

-- Close & Minimize
Close.MouseButton1Click:Connect(function() Gui:Destroy() end)

local isMin = false
local oldSizeY = Main.Size.Y.Offset
Min.MouseButton1Click:Connect(function()
    isMin = not isMin
    local targetY = isMin and 35 or 320
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, Main.Size.X.Offset, 0, targetY)}):Play()
end)