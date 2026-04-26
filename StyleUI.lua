-- CatHUB v8.3: Premium Minimal UI
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Palette
local P = {
    Base = Color3.fromRGB(12, 12, 16),
    Surface = Color3.fromRGB(18, 18, 24),
    Top = Color3.fromRGB(20, 15, 32),
    Card = Color3.fromRGB(22, 22, 30),
    Accent = Color3.fromRGB(140, 100, 220),
    Text = Color3.fromRGB(220, 220, 230),
    Sub = Color3.fromRGB(100, 100, 115),
    Off = Color3.fromRGB(35, 35, 45),
    Border = Color3.fromRGB(40, 30, 65)
}

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 360, 0, 240)
Main.Position = UDim2.new(0.5, -180, 0.5, -120)
Main.BackgroundColor3 = P.Base
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

Instance.new("UIStroke", Main).Color = P.Border
Instance.new("UIStroke", Main).Thickness = 0.5

-- Top
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 30)
Top.BackgroundColor3 = P.Top
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

local G = Instance.new("UIGradient", Top)
G.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 18, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 28, 80))
})

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -50, 1, 0)
Ttl.Position = UDim2.new(0, 12, 0, 0)
Ttl.Text = "CATHUB"
Ttl.TextColor3 = Color3.fromRGB(255, 255, 255)
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 12
Ttl.TextXAlignment = "Left"
Ttl.BackgroundTransparency = 1

local X = Instance.new("TextButton", Top)
X.Size = UDim2.new(0, 30, 0, 30)
X.Position = UDim2.new(1, -30, 0, 0)
X.Text = "×"
X.TextColor3 = Color3.fromRGB(160, 80, 80)
X.BackgroundTransparency = 1
X.Font = Enum.Font.Gotham
X.TextSize = 14
X.MouseButton1Click:Connect(function() Gui:Destroy() end)

local Mn = Instance.new("TextButton", Top)
Mn.Size = UDim2.new(0, 30, 0, 30)
Mn.Position = UDim2.new(1, -60, 0, 0)
Mn.Text = "—"
Mn.TextColor3 = P.Sub
Mn.BackgroundTransparency = 1
Mn.Font = Enum.Font.Gotham
Mn.TextSize = 12

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -108, 1, -38)
Content.Position = UDim2.new(0, 103, 0, 33)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true

local isMin = false
Mn.MouseButton1Click:Connect(function()
    isMin = not isMin
    Content.Visible = not isMin
    Main:FindFirstChild("Side").Visible = not isMin
    Main:TweenSize(isMin and UDim2.new(0, 360, 0, 30) or UDim2.new(0, 360, 0, 240), "Out", "Quad", 0.15, true)
end)

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 95, 1, -38)
Side.Position = UDim2.new(0, 4, 0, 33)
Side.BackgroundColor3 = P.Surface
Side.BorderSizePixel = 0
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 6)

local Tabs = Instance.new("Frame", Side)
Tabs.Size = UDim2.new(1, -6, 0, 160)
Tabs.Position = UDim2.new(0, 3, 0, 5)
Tabs.BackgroundTransparency = 1
local TL = Instance.new("UIListLayout", Tabs)
TL.Padding = UDim.new(0, 2)

local function Tab(name, active)
    local B = Instance.new("TextButton", Tabs)
    B.Size = UDim2.new(1, 0, 0, 28)
    B.BackgroundColor3 = active and Color3.fromRGB(28, 20, 45) or Color3.fromRGB(0, 0, 0)
    B.BackgroundTransparency = active and 0 or 1
    B.Text = name
    B.TextColor3 = active and P.Accent or P.Sub
    B.Font = Enum.Font.GothamBold
    B.TextSize = 9
    B.BorderSizePixel = 0
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 5)
    
    if active then
        local I = Instance.new("Frame", B)
        I.Size = UDim2.new(0, 2, 0.5, 0)
        I.Position = UDim2.new(0, 0, 0.25, 0)
        I.BackgroundColor3 = P.Accent
        I.BorderSizePixel = 0
        Instance.new("UICorner", I).CornerRadius = UDim.new(0, 1)
    end
end

Tab("ESP", true)
Tab("Combat", false)
Tab("Farm", false)
Tab("Teleport", false)

-- Content
local Scroll = Instance.new("ScrollingFrame", Content)
Scroll.Size = UDim2.new(1, -8, 1, -8)
Scroll.Position = UDim2.new(0, 4, 0, 4)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 1
Scroll.ScrollBarImageColor3 = P.Border
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 3)

-- Section
local function Sec(t)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, 0, 0, 22)
    F.BackgroundColor3 = P.Top
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Position = UDim2.new(0, 8, 0, 0)
    L.Text = t
    L.TextColor3 = P.Accent
    L.Font = Enum.Font.GothamBold
    L.TextSize = 9
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
end

-- Toggle
local function Tgl(key, title)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, 0, 0, 28)
    F.BackgroundColor3 = P.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -46, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = title
    L.TextColor3 = P.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 10
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("TextButton", F)
    Sw.Size = UDim2.new(0, 34, 0, 16)
    Sw.Position = UDim2.new(1, -40, 0.5, -8)
    Sw.BackgroundColor3 = S[key] and P.Accent or P.Off
    Sw.Text = ""
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local D = Instance.new("Frame", Sw)
    D.Size = UDim2.new(0, 12, 0, 12)
    D.Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    D.BackgroundColor3 = Color3.new(1, 1, 1)
    D.BorderSizePixel = 0
    Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)
    
    Sw.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(D, TweenInfo.new(0.12, Enum.EasingStyle.Back), {
            Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.1), {
            BackgroundColor3 = S[key] and P.Accent or P.Off
        }):Play()
    end)
end

-- Soon
local function Soon(t)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, 0, 0, 28)
    F.BackgroundColor3 = P.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -70, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = t
    L.TextColor3 = Color3.fromRGB(50, 50, 60)
    L.Font = Enum.Font.Gotham
    L.TextSize = 10
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local T = Instance.new("TextLabel", F)
    T.Size = UDim2.new(0, 40, 1, 0)
    T.Position = UDim2.new(1, -48, 0, 0)
    T.Text = "SOON"
    T.TextColor3 = Color3.fromRGB(50, 40, 70)
    T.Font = Enum.Font.GothamBold
    T.TextSize = 7
    T.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 34, 0, 16)
    Sw.Position = UDim2.new(1, -40, 0.5, -8)
    Sw.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local D = Instance.new("Frame", Sw)
    D.Size = UDim2.new(0, 12, 0, 12)
    D.Position = UDim2.new(0, 2, 0.5, -6)
    D.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    D.BorderSizePixel = 0
    Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)
end

Sec("DEVIL FRUITS")
Tgl("FruitESP", "Fruit ESP")

Sec("PLAYERS")
Soon("Player ESP")

Sec("BOSSES")
Soon("Boss ESP")

Sec("CHESTS")
Soon("Chest ESP")

-- Drag
local dr, ds, ps
Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dr = true; ds = i.Position; ps = Main.Position
    end
end)
UserInput.InputChanged:Connect(function(i)
    if dr and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        Main.Position = UDim2.new(ps.X.Scale, ps.X.Offset + d.X, ps.Y.Scale, ps.Y.Offset + d.Y)
    end
end)
UserInput.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dr = false end
end)

UserInput.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)