-- CatHUB v9.8: 1:1 RedzHub Logic Fix
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"

local C = {
    Base = Color3.fromRGB(15, 15, 17),
    Side = Color3.fromRGB(20, 20, 22),
    Accent = Color3.fromRGB(88, 101, 242),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 165),
    Stroke = Color3.fromRGB(50, 50, 55)
}

-- ==========================================
-- LOGO HIDE (KOTAK KECIL REDZ)
-- ==========================================
local OpenBtn = Instance.new("ImageButton", Gui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 50, 0, 50)
OpenBtn.Visible = false
OpenBtn.BackgroundColor3 = C.Base
OpenBtn.Image = "rbxassetid://6023426915" -- Logo Redz
OpenBtn.PaddingLeft = UDim.new(0,5)
local OBCorner = Instance.new("UICorner", OpenBtn)
OBCorner.CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", OpenBtn).Color = C.Accent

-- ==========================================
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = C.Stroke

-- Top Bar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = C.Side
Top.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "redz Hub : Visuals [ CatHub ]"
Title.TextColor3 = C.Text
Title.Font = Enum.Font.Gotham
Title.TextSize = 12
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

-- Close (X) & Minimize (-)
local function MakeBtn(txt, pos)
    local b = Instance.new("TextButton", Top)
    b.Size = UDim2.new(0, 30, 1, 0)
    b.Position = pos
    b.Text = txt
    b.TextColor3 = C.Text
    b.Font = Enum.Font.GothamBold
    b.BackgroundTransparency = 1
    return b
end

local Close = MakeBtn("✕", UDim2.new(1, -35, 0, 0))
local Min = MakeBtn("—", UDim2.new(1, -65, 0, 0))

-- Sidebar (HANYA 1 TAB: ESP)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = C.Side

local Tab = Instance.new("TextButton", Sidebar)
Tab.Size = UDim2.new(1, -20, 0, 35)
Tab.Position = UDim2.new(0, 10, 0, 10)
Tab.BackgroundColor3 = C.Accent
Tab.Text = "      Visual/ESP"
Tab.TextColor3 = C.Text
Tab.Font = Enum.Font.GothamMedium
Tab.TextSize = 13
Tab.TextXAlignment = "Left"
Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 6)

local TabIcon = Instance.new("ImageLabel", Tab)
TabIcon.Size = UDim2.new(0, 18, 0, 18)
TabIcon.Position = UDim2.new(0, 8, 0.5, -9)
TabIcon.Image = "rbxassetid://6034287535"
TabIcon.BackgroundTransparency = 1

-- Content Container
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -160, 1, -45)
Container.Position = UDim2.new(0, 150, 0, 40)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
local List = Instance.new("UIListLayout", Container)
List.Padding = UDim.new(0, 10)

-- ==========================================
-- TOGGLE & SECTION
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
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    
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
    sw.Position = UDim2.new(1, -44, 0.5, -8)
    sw.BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(60, 60, 65)
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
    
    f.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(60, 60, 65)}):Play()
    end)
end

Section("Devil Fruits")
Toggle("FruitESP", "Fruit ESP")
Section("World")
Toggle("ChestESP", "Chest Finder")

-- ==========================================
-- FIX LOGIC (RESIZE, HIDE, MINIMIZE)
-- ==========================================

-- 1. Resize Pojok Kanan Bawah
local ResizeBtn = Instance.new("TextButton", Main)
ResizeBtn.Size = UDim2.new(0, 20, 0, 20)
ResizeBtn.Position = UDim2.new(1, -20, 1, -20)
ResizeBtn.BackgroundTransparency = 1
ResizeBtn.Text = "⌟"
ResizeBtn.TextColor3 = C.TextDim
ResizeBtn.TextSize = 18

local isResizing = false
ResizeBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = true end end)
UserInput.InputChanged:Connect(function(i)
    if isResizing and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - Vector3.new(Main.AbsolutePosition.X, Main.AbsolutePosition.Y, 0)
        Main.Size = UDim2.new(0, math.clamp(delta.X, 300, 800), 0, math.clamp(delta.Y, 200, 600))
    end
end)
UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end end)

-- 2. Tombol X (Hide ke Kotak Kecil)
Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- 3. Tombol Minimize (Ciutkan UI)
local isMin = false
Min.MouseButton1Click:Connect(function()
    isMin = not isMin
    TweenService:Create(Main, TweenInfo.new(0.3), {Size = isMin and UDim2.new(0, Main.Size.X.Offset, 0, 35) or UDim2.new(0, Main.Size.X.Offset, 0, 350)}):Play()
end)

-- 4. Dragging Top Bar
local dragging, dragStart, startPos
Top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = Main.Position end end)
UserInput.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)