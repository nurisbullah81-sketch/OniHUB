-- CatHUB v8.5: Authentic RedzHub Style
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- RedzHub exact colors
local R = {
    Base = Color3.fromRGB(18, 18, 22),
    Dark = Color3.fromRGB(14, 14, 18),
    Card = Color3.fromRGB(24, 24, 30),
    CardHover = Color3.fromRGB(28, 28, 36),
    Top = Color3.fromRGB(16, 14, 24),
    Side = Color3.fromRGB(16, 16, 20),
    TabActive = Color3.fromRGB(28, 24, 42),
    TabHover = Color3.fromRGB(22, 22, 28),
    Accent = Color3.fromRGB(140, 100, 220),
    AccentLight = Color3.fromRGB(165, 130, 240),
    AccentDark = Color3.fromRGB(100, 70, 170),
    TextMain = Color3.fromRGB(235, 235, 245),
    TextSec = Color3.fromRGB(160, 160, 175),
    TextDim = Color3.fromRGB(90, 90, 105),
    ToggleOff = Color3.fromRGB(45, 45, 55),
    SectionBg = Color3.fromRGB(22, 18, 35),
    Divider = Color3.fromRGB(35, 30, 55)
}

-- Main Frame
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 380, 0, 290)
Main.Position = UDim2.new(0.5, -190, 0.5, -145)
Main.BackgroundColor3 = R.Base
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Subtle border
local Bdr = Instance.new("UIStroke", Main)
Bdr.Color = R.Divider
Bdr.Transparency = 0.3
Bdr.Thickness = 0.5

-- Topbar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = R.Top
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 12)

-- Gradient topbar
local TG = Instance.new("UIGradient", Top)
TG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 16, 38)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(32, 20, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 16, 38))
})
TG.Rotation = 90

-- Title
local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -65, 1, 0)
Ttl.Position = UDim2.new(0, 15, 0, 0)
Ttl.Text = "CATHUB"
Ttl.TextColor3 = Color3.new(1, 1, 1)
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 14
Ttl.TextXAlignment = "Left"
Ttl.BackgroundTransparency = 1

-- Subtitle
local Sub = Instance.new("TextLabel", Top)
Sub.Size = UDim2.new(0, 50, 0, 12)
Sub.Position = UDim2.new(0, 15, 1, -15)
Sub.Text = "PREMIUM"
Sub.TextColor3 = R.AccentDark
Sub.Font = Enum.Font.GothamMedium
Sub.TextSize = 8
Sub.BackgroundTransparency = 1

-- Close button
local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 32, 0, 32)
BtnX.Position = UDim2.new(1, -34, 0, 3)
BtnX.Text = "×"
BtnX.TextColor3 = R.TextDim
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 15
BtnX.MouseEnter:Connect(function()
    TweenService:Create(BtnX, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(220, 100, 100)}):Play()
end)
BtnX.MouseLeave:Connect(function()
    TweenService:Create(BtnX, TweenInfo.new(0.1), {TextColor3 = R.TextDim}):Play()
end)
BtnX.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 380, 0, 38),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.15)
    Gui:Destroy()
end)

-- Minimize
local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 32, 0, 32)
BtnM.Position = UDim2.new(1, -66, 0, 3)
BtnM.Text = "—"
BtnM.TextColor3 = R.TextDim
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.GothamBold
BtnM.TextSize = 12

-- Content area
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -110, 1, -46)
Content.Position = UDim2.new(0, 105, 0, 41)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true

local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    Content.Visible = not isMin
    Main:FindFirstChild("Side").Visible = not isMin
    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = isMin and UDim2.new(0, 380, 0, 38) or UDim2.new(0, 380, 0, 290)
    }):Play()
end)

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 96, 1, -46)
Side.Position = UDim2.new(0, 5, 0, 41)
Side.BackgroundColor3 = R.Side
Side.BorderSizePixel = 0
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 10)

-- Tab container
local TabBox = Instance.new("Frame", Side)
TabBox.Size = UDim2.new(1, -8, 0, 200)
TabBox.Position = UDim2.new(0, 4, 0, 8)
TabBox.BackgroundTransparency = 1
local TabLay = Instance.new("UIListLayout", TabBox)
TabLay.Padding = UDim.new(0, 3)

-- Tab function
local function Tab(name, active)
    local B = Instance.new("TextButton", TabBox)
    B.Size = UDim2.new(1, 0, 0, 32)
    B.BackgroundColor3 = active and R.TabActive or Color3.new(1, 1, 1)
    B.BackgroundTransparency = active and 0 or 1
    B.Text = name
    B.TextColor3 = active and R.AccentLight or R.TextDim
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 10
    B.BorderSizePixel = 0
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    
    if active then
        -- Left accent line
        local Line = Instance.new("Frame", B)
        Line.Size = UDim2.new(0, 3, 0.5, 0)
        Line.Position = UDim2.new(0, 0, 0.25, 0)
        Line.BackgroundColor3 = R.Accent
        Line.BorderSizePixel = 0
        Instance.new("UICorner", Line).CornerRadius = UDim.new(0, 2)
        
        -- Subtle glow behind
        local Glow = Instance.new("Frame", B)
        Glow.Size = UDim2.new(1, 0, 1, 0)
        Glow.BackgroundColor3 = R.Accent
        Glow.BackgroundTransparency = 0.92
        Glow.BorderSizePixel = 0
        Glow.ZIndex = -1
        Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 8)
    else
        -- Hover effects
        B.MouseEnter:Connect(function()
            TweenService:Create(B, TweenInfo.new(0.12), {
                BackgroundTransparency = 0.82,
                TextColor3 = R.TextSec
            }):Play()
        end)
        B.MouseLeave:Connect(function()
            TweenService:Create(B, TweenInfo.new(0.12), {
                BackgroundTransparency = 1,
                TextColor3 = R.TextDim
            }):Play()
        end)
    end
end

Tab("ESP", true)
Tab("Combat", false)
Tab("Farm", false)
Tab("Teleport", false)
Tab("Misc", false)

-- Scroll content
local Scroll = Instance.new("ScrollingFrame", Content)
Scroll.Size = UDim2.new(1, -10, 1, -10)
Scroll.Position = UDim2.new(0, 5, 0, 5)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 1
Scroll.ScrollBarImageColor3 = R.AccentDark
Scroll.ScrollBarImageTransparency = 0.5
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local Slay = Instance.new("UIListLayout", Scroll)
Slay.Padding = UDim.new(0, 4)

-- Section header
local function Sec(t)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, 0, 0, 26)
    F.BackgroundColor3 = R.SectionBg
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 7)
    
    -- Accent line left
    local L = Instance.new("Frame", F)
    L.Size = UDim2.new(0, 3, 0.6, 0)
    L.Position = UDim2.new(0, 0, 0.2, 0)
    L.BackgroundColor3 = R.Accent
    L.BorderSizePixel = 0
    Instance.new("UICorner", L).CornerRadius = UDim.new(0, 2)
    
    local Tx = Instance.new("TextLabel", F)
    Tx.Size = UDim2.new(1, -15, 1, 0)
    Tx.Position = UDim2.new(0, 12, 0, 0)
    Tx.Text = t
    Tx.TextColor3 = R.AccentLight
    Tx.Font = Enum.Font.GothamBold
    Tx.TextSize = 10
    Tx.TextXAlignment = "Left"
    Tx.BackgroundTransparency = 1
end

-- Toggle switch
local function Tgl(key, title)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, 0, 0, 32)
    F.BackgroundColor3 = R.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    
    -- Hover effect
    F.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then
            TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = R.CardHover}):Play()
        end
    end)
    F.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then
            TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = R.Card}):Play()
        end
    end)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -52, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.Text = title
    L.TextColor3 = R.TextMain
    L.Font = Enum.Font.Gotham
    L.TextSize = 11
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    -- Toggle track
    local Track = Instance.new("TextButton", F)
    Track.Size = UDim2.new(0, 40, 0, 20)
    Track.Position = UDim2.new(1, -46, 0.5, -10)
    Track.BackgroundColor3 = S[key] and R.Accent or R.ToggleOff
    Track.Text = ""
    Track.BorderSizePixel = 0
    Track.AutoButtonColor = false
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
    
    -- Glow when on
    if S[key] then
        local Gl = Instance.new("UIStroke", Track)
        Gl.Color = R.Accent
        Gl.Transparency = 0.5
        Gl.Thickness = 2
    end
    
    -- Toggle dot
    local Dot = Instance.new("Frame", Track)
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = S[key] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    Track.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        
        -- Animate dot
        TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = S[key] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        -- Animate track color
        TweenService:Create(Track, TweenInfo.new(0.15), {
            BackgroundColor3 = S[key] and R.Accent or R.ToggleOff
        }):Play()
        
        -- Glow effect
        local existing = Track:FindFirstChildOfClass("UIStroke")
        if S[key] then
            if not existing then
                local Gl = Instance.new("UIStroke", Track)
                Gl.Color = R.Accent
                Gl.Transparency = 0.8
                Gl.Thickness = 2
                TweenService:Create(Gl, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
            end
        else
            if existing then
                TweenService:Create(existing, TweenInfo.new(0.15), {Transparency = 1}):Play()
                task.delay(0.15, function() existing:Destroy() end)
            end
        end
    end)
end

-- Coming soon
local function Soon(t)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, 0, 0, 32)
    F.BackgroundColor3 = R.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -78, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.Text = t
    L.TextColor3 = R.TextDim
    L.Font = Enum.Font.Gotham
    L.TextSize = 11
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    -- Soon badge
    local Badge = Instance.new("Frame", F)
    Badge.Size = UDim2.new(0, 40, 0, 16)
    Badge.Position = UDim2.new(1, -52, 0.5, -8)
    Badge.BackgroundColor3 = R.SectionBg
    Badge.BorderSizePixel = 0
    Instance.new("UICorner", Badge).CornerRadius = UDim.new(0, 4)
    
    local Btxt = Instance.new("TextLabel", Badge)
    Btxt.Size = UDim2.new(1, 0, 1, 0)
    Btxt.Text = "SOON"
    Btxt.TextColor3 = R.AccentDark
    Btxt.Font = Enum.Font.GothamBold
    Btxt.TextSize = 8
    Btxt.BackgroundTransparency = 1
    
    -- Disabled toggle
    local Track = Instance.new("Frame", F)
    Track.Size = UDim2.new(0, 40, 0, 20)
    Track.Position = UDim2.new(1, -46, 0.5, -10)
    Track.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    Track.BorderSizePixel = 0
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Track)
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(0, 2, 0.5, -8)
    Dot.BackgroundColor3 = R.TextDim
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
end

-- Build UI
Sec("DEVIL FRUITS")
Tgl("FruitESP", "Fruit ESP")

Sec("PLAYERS")
Soon("Player ESP")

Sec("BOSSES")
Soon("Boss ESP")

Sec("CHESTS")
Soon("Chest ESP")

-- Drag system
local drag, dragStart, startPos
Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)

UserInput.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInput.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

-- Hotkey toggle
UserInput.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)