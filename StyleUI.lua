-- CatHUB v8.4: True Modern UI
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Soft palette
local P = {
    Base = Color3.fromRGB(14, 14, 18),
    Surface = Color3.fromRGB(17, 17, 22),
    Elevate = Color3.fromRGB(22, 22, 28),
    Accent = Color3.fromRGB(130, 95, 210),
    AccentDim = Color3.fromRGB(90, 65, 150),
    Text = Color3.fromRGB(230, 230, 240),
    Sub = Color3.fromRGB(110, 110, 125),
    Muted = Color3.fromRGB(55, 55, 68),
    Off = Color3.fromRGB(38, 38, 48),
    Glow = Color3.fromRGB(100, 70, 180)
}

-- Shadow maker
local function Shadow(parent, blur, offset, color, trans)
    local s = Instance.new("ImageLabel", parent)
    s.Name = "Shadow"
    s.Size = UDim2.new(1, offset, 1, offset)
    s.Position = UDim2.new(0, -offset/2, 0, -offset/2)
    s.BackgroundTransparency = 1
    s.Image = "rbxassetid://6015897843"
    s.ImageColor3 = color or Color3.new(0, 0, 0)
    s.ImageTransparency = trans or 0.4
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.ZIndex = -1
    return s
end

-- Main container
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 340, 0, 260)
Main.Position = UDim2.new(0.5, -170, 0.5, -130)
Main.BackgroundColor3 = P.Base
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

Shadow(Main, 20, 12, Color3.new(0, 0, 0), 0.5)

local Border = Instance.new("UIStroke", Main)
Border.Color = P.AccentDim
Border.Transparency = 0.75
Border.Thickness = 0.8

-- Topbar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 34)
Top.BackgroundColor3 = Color3.fromRGB(18, 15, 28)
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14)

local TGrad = Instance.new("UIGradient", Top)
TGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 18, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(38, 22, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 18, 50))
})
TGrad.Rotation = 90

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -60, 1, 0)
Ttl.Position = UDim2.new(0, 14, 0, 0)
Ttl.Text = "CATHUB"
Ttl.TextColor3 = Color3.new(1, 1, 1)
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 13
Ttl.TextXAlignment = "Left"
Ttl.BackgroundTransparency = 1

-- Buttons
local BtnClose = Instance.new("TextButton", Top)
BtnClose.Size = UDim2.new(0, 28, 0, 28)
BtnClose.Position = UDim2.new(1, -30, 0, 3)
BtnClose.Text = "✕"
BtnClose.TextColor3 = Color3.fromRGB(180, 100, 100)
BtnClose.BackgroundTransparency = 1
BtnClose.Font = Enum.Font.Gotham
BtnClose.TextSize = 12
BtnClose.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 340, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.2)
    Gui:Destroy()
end)

local BtnMin = Instance.new("TextButton", Top)
BtnMin.Size = UDim2.new(0, 28, 0, 28)
BtnMin.Position = UDim2.new(1, -58, 0, 3)
BtnMin.Text = "—"
BtnMin.TextColor3 = P.Sub
BtnMin.BackgroundTransparency = 1
BtnMin.Font = Enum.Font.Gotham
BtnMin.TextSize = 11

-- Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -102, 1, -42)
Content.Position = UDim2.new(0, 97, 0, 37)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true

local isMin = false
BtnMin.MouseButton1Click:Connect(function()
    isMin = not isMin
    Content.Visible = not isMin
    Main:FindFirstChild("Side").Visible = not isMin
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = isMin and UDim2.new(0, 340, 0, 34) or UDim2.new(0, 340, 0, 260)
    }):Play()
end)

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 88, 1, -42)
Side.Position = UDim2.new(0, 5, 0, 37)
Side.BackgroundColor3 = P.Surface
Side.BorderSizePixel = 0
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 10)

local TabBox = Instance.new("Frame", Side)
TabBox.Size = UDim2.new(1, -8, 0, 165)
TabBox.Position = UDim2.new(0, 4, 0, 6)
TabBox.BackgroundTransparency = 1
local TabLay = Instance.new("UIListLayout", TabBox)
TabLay.Padding = UDim.new(0, 3)

-- Tab creation
local function Tab(name, active)
    local B = Instance.new("TextButton", TabBox)
    B.Size = UDim2.new(1, 0, 0, 29)
    B.BackgroundColor3 = active and P.Elevate or Color3.new(1, 1, 1)
    B.BackgroundTransparency = active and 0 or 1
    B.Text = name
    B.TextColor3 = active and P.Accent or P.Muted
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 10
    B.BorderSizePixel = 0
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    
    if active then
        local Glow = Instance.new("Frame", B)
        Glow.Size = UDim2.new(0, 3, 0.45, 0)
        Glow.Position = UDim2.new(0, 0, 0.275, 0)
        Glow.BackgroundColor3 = P.Accent
        Glow.BorderSizePixel = 0
        Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 2)
    end
    
    -- Hover effect for inactive
    if not active then
        B.MouseEnter:Connect(function()
            TweenService:Create(B, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.85,
                TextColor3 = P.Sub
            }):Play()
        end)
        B.MouseLeave:Connect(function()
            TweenService:Create(B, TweenInfo.new(0.15), {
                BackgroundTransparency = 1,
                TextColor3 = P.Muted
            }):Play()
        end)
    end
end

Tab("ESP", true)
Tab("Combat", false)
Tab("Farm", false)
Tab("Teleport", false)
Tab("Misc", false)

-- Scroll
local Scroll = Instance.new("ScrollingFrame", Content)
Scroll.Size = UDim2.new(1, -8, 1, -8)
Scroll.Position = UDim2.new(0, 4, 0, 4)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 0
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local Slay = Instance.new("UIListLayout", Scroll)
Slay.Padding = UDim.new(0, 4)

-- Section
local function Sec(t)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, 0, 0, 24)
    F.BackgroundColor3 = P.Elevate
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 7)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = t
    L.TextColor3 = P.Accent
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 9
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
end

-- Toggle
local function Tgl(key, title)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, 0, 0, 30)
    F.BackgroundColor3 = P.Elevate
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -48, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = title
    L.TextColor3 = P.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 10
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    -- Modern pill toggle
    local Sw = Instance.new("TextButton", F)
    Sw.Size = UDim2.new(0, 36, 0, 18)
    Sw.Position = UDim2.new(1, -42, 0.5, -9)
    Sw.BackgroundColor3 = S[key] and P.Accent or P.Off
    Sw.Text = ""
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = S[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    Sw.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
            Position = S[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.15), {
            BackgroundColor3 = S[key] and P.Accent or P.Off
        }):Play()
    end)
end

-- Coming soon
local function Soon(t)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, 0, 0, 30)
    F.BackgroundColor3 = P.Elevate
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -75, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = t
    L.TextColor3 = P.Muted
    L.Font = Enum.Font.Gotham
    L.TextSize = 10
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Tag = Instance.new("TextLabel", F)
    Tag.Size = UDim2.new(0, 42, 0, 16)
    Tag.Position = UDim2.new(1, -50, 0.5, -8)
    Tag.Text = "SOON"
    Tag.TextColor3 = P.AccentDim
    Tag.Font = Enum.Font.GothamBold
    Tag.TextSize = 7
    Tag.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 36, 0, 18)
    Sw.Position = UDim2.new(1, -42, 0.5, -9)
    Sw.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local D = Instance.new("Frame", Sw)
    D.Size = UDim2.new(0, 14, 0, 14)
    D.Position = UDim2.new(0, 2, 0.5, -7)
    D.BackgroundColor3 = P.Muted
    D.BorderSizePixel = 0
    Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)
end

-- Build
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