-- CatHUB v8.7: Fluid UI
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Config
local Config = {
    Scale = "Standard",
    Accent = Color3.fromRGB(130, 90, 220),
    Theme = "Dark"
}

-- Scale presets (HANYA inner elements)
local Scale = {
    Small = {Font = 10, FontSm = 8, FontLg = 11, Card = 28, Section = 22, Toggle = 16, Dot = 12, Pad = 3, SideFont = 10, SideH = 30},
    Standard = {Font = 12, FontSm = 9, FontLg = 13, Card = 34, Section = 26, Toggle = 20, Dot = 16, Pad = 5, SideFont = 12, SideH = 36},
    Large = {Font = 14, FontSm = 11, FontLg = 15, Card = 40, Section = 30, Toggle = 24, Dot = 20, Pad = 7, SideFont = 14, SideH = 42}
}

local function LoadCfg()
    pcall(function()
        if isfile("CatHUB_UI.json") then
            local d = HttpService:JSONDecode(readfile("CatHUB_UI.json"))
            if d.Scale and Scale[d.Scale] then Config.Scale = d.Scale end
            if d.Accent then Config.Accent = Color3.fromRGB(d.Accent[1], d.Accent[2], d.Accent[3]) end
            if d.Theme then Config.Theme = d.Theme end
        end
    end)
end
LoadCfg()

local function SaveCfg()
    pcall(function()
        local c = Config.Accent
        writefile("CatHUB_UI.json", HttpService:JSONEncode({
            Scale = Config.Scale,
            Accent = {math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)},
            Theme = Config.Theme
        }))
    end)
end

local function SC()
    return Scale[Config.Scale]
end

local function GetColors()
    if Config.Theme == "Light" then
        return {
            Base = Color3.fromRGB(245, 245, 250),
            Side = Color3.fromRGB(235, 235, 242),
            Card = Color3.fromRGB(252, 252, 255),
            CardHov = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(25, 25, 35),
            TextSec = Color3.fromRGB(80, 80, 100),
            TextDim = Color3.fromRGB(140, 140, 160),
            Off = Color3.fromRGB(210, 210, 220),
            Sec = Color3.fromRGB(230, 225, 245)
        }
    end
    return {
        Base = Color3.fromRGB(22, 22, 28),
        Side = Color3.fromRGB(18, 18, 24),
        Card = Color3.fromRGB(28, 28, 36),
        CardHov = Color3.fromRGB(34, 34, 44),
        Text = Color3.fromRGB(235, 235, 245),
        TextSec = Color3.fromRGB(160, 160, 180),
        TextDim = Color3.fromRGB(95, 95, 112),
        Off = Color3.fromRGB(48, 48, 62),
        Sec = Color3.fromRGB(30, 26, 44)
    }
end

local C = GetColors()

-- ==========================================
-- MAIN FRAME (FIXED SIZE)
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- ==========================================
-- TOPBAR
-- ==========================================
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 42)
Top.BackgroundColor3 = Config.Accent
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 10)

local TopBot = Instance.new("Frame", Top)
TopBot.Size = UDim2.new(1, 0, 0, 10)
TopBot.Position = UDim2.new(0, 0, 1, -10)
TopBot.BackgroundColor3 = Config.Accent
TopBot.BorderSizePixel = 0

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -80, 1, 0)
Ttl.Position = UDim2.new(0, 18, 0, 0)
Ttl.Text = "CATHUB"
Ttl.TextColor3 = Color3.new(1, 1, 1)
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 17
Ttl.TextXAlignment = "Left"
Ttl.BackgroundTransparency = 1

local Ver = Instance.new("TextLabel", Top)
Ver.Size = UDim2.new(0, 40, 0, 14)
Ver.Position = UDim2.new(18, 0, 1, -16)
Ver.Text = "v8.7"
Ver.TextColor3 = Color3.fromRGB(255, 255, 255)
Ver.Font = Enum.Font.Gotham
Ver.TextSize = 9
Ver.BackgroundTransparency = 1

local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 42, 0, 42)
BtnX.Position = UDim2.new(1, -42, 0, 0)
BtnX.Text = "✕"
BtnX.TextColor3 = Color3.new(1, 1, 1)
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.Gotham
BtnX.TextSize = 18
BtnX.MouseEnter:Connect(function()
    TweenService:Create(BtnX, TweenInfo.new(0.15), {BackgroundTransparency = 0.7, BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
BtnX.MouseLeave:Connect(function()
    TweenService:Create(BtnX, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
end)
BtnX.MouseButton1Click:Connect(function() Gui:Destroy() end)

local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 42, 0, 42)
BtnM.Position = UDim2.new(1, -84, 0, 0)
BtnM.Text = "—"
BtnM.TextColor3 = Color3.new(1, 1, 1)
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.Gotham
BtnM.TextSize = 16

-- Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -135, 1, -52)
Content.Position = UDim2.new(0, 130, 0, 47)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true

local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    Content.Visible = not isMin
    Main:FindFirstChild("Side").Visible = not isMin
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = isMin and UDim2.new(0, 500, 0, 42) or UDim2.new(0, 500, 0, 350)
    }):Play()
end)

-- ==========================================
-- SIDEBAR
-- ==========================================
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 122, 1, -52)
Side.Position = UDim2.new(0, 5, 0, 47)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 8)

local TabBox = Instance.new("Frame", Side)
TabBox.Size = UDim2.new(1, 0, 1, 0)
TabBox.BackgroundTransparency = 1
local TabLay = Instance.new("UIListLayout", TabBox)
TabLay.Padding = UDim.new(0, 2)
TabLay.VerticalAlignment = Enum.VerticalAlignment.Top

local TabData = {}
local ActiveTab = nil
local s = SC()

local function Tab(name)
    local B = Instance.new("TextButton", TabBox)
    B.Size = UDim2.new(1, -10, 0, s.SideH)
    B.Position = UDim2.new(0, 5, 0, 0)
    B.BackgroundColor3 = Color3.new(1, 1, 1)
    B.BackgroundTransparency = 1
    B.Text = "  " .. name
    B.TextColor3 = C.TextDim
    B.Font = Enum.Font.GothamMedium
    B.TextSize = s.SideFont
    B.TextXAlignment = "Left"
    B.BorderSizePixel = 0
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    
    -- Indicator line
    local Ind = Instance.new("Frame", B)
    Ind.Size = UDim2.new(0, 0, 0.5, 0)
    Ind.Position = UDim2.new(0, 0, 0.25, 0)
    Ind.BackgroundColor3 = Config.Accent
    Ind.BorderSizePixel = 0
    Ind.BackgroundTransparency = 1
    Instance.new("UICorner", Ind).CornerRadius = UDim.new(0, 2)
    
    local Container = Instance.new("ScrollingFrame", Content)
    Container.Size = UDim2.new(1, -14, 1, -14)
    Container.Position = UDim2.new(0, 7, 0, 7)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 0
    Container.BorderSizePixel = 0
    Container.Visible = false
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    local CL = Instance.new("UIListLayout", Container)
    CL.Padding = UDim.new(0, s.Pad)
    CL.SortOrder = Enum.SortOrder.LayoutOrder
    
    table.insert(TabData, {Btn = B, Container = Container, Ind = Ind, Name = name})
    
    if not ActiveTab then
        ActiveTab = name
        Ind.Size = UDim2.new(0, 4, 0.5, 0)
        Ind.BackgroundTransparency = 0
        B.TextColor3 = Config.Accent
        Container.Visible = true
    end
    
    -- Hover
    B.MouseEnter:Connect(function()
        if ActiveTab ~= name then
            TweenService:Create(B, TweenInfo.new(0.15), {BackgroundTransparency = 0.88}):Play()
            TweenService:Create(B, TweenInfo.new(0.15), {TextColor3 = C.TextSec}):Play()
        end
    end)
    B.MouseLeave:Connect(function()
        if ActiveTab ~= name then
            TweenService:Create(B, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            TweenService:Create(B, TweenInfo.new(0.15), {TextColor3 = C.TextDim}):Play()
        end
    end)
    
    B.MouseButton1Click:Connect(function()
        for _, t in pairs(TabData) do
            TweenService:Create(t.Btn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = C.TextDim}):Play()
            TweenService:Create(t.Ind, TweenInfo.new(0.15), {Size = UDim2.new(0, 0, 0.5, 0), BackgroundTransparency = 1}):Play()
            t.Container.Visible = false
        end
        TweenService:Create(B, TweenInfo.new(0.15), {BackgroundTransparency = 0.88, TextColor3 = Config.Accent}):Play()
        TweenService:Create(Ind, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, 4, 0.5, 0), BackgroundTransparency = 0}):Play()
        Container.Visible = true
        ActiveTab = name
    end)
    
    return Container
end

-- Create tabs
local EspTab = Tab("ESP")
local CombatTab = Tab("Combat")
local FarmTab = Tab("Farm")
local TeleportTab = Tab("Teleport")
local SettingsTab = Tab("Settings")

-- ==========================================
-- UI HELPERS
-- ==========================================

local function Sec(parent, text)
    s = SC()
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, s.Section)
    F.BackgroundColor3 = C.Sec
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = text
    L.TextColor3 = Config.Accent
    L.Font = Enum.Font.GothamBold
    L.TextSize = s.FontSm
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
end

local function Tgl(parent, key, title)
    s = SC()
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, s.Card)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 7)
    
    -- Hover
    F.MouseEnter:Connect(function()
        TweenService:Create(F, TweenInfo.new(0.12), {BackgroundColor3 = C.CardHov}):Play()
    end)
    F.MouseLeave:Connect(function()
        TweenService:Create(F, TweenInfo.new(0.12), {BackgroundColor3 = C.Card}):Play()
    end)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.Text = title
    L.TextColor3 = C.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = s.Font
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("TextButton", F)
    Sw.Size = UDim2.new(0, s.Toggle + 8, 0, s.Toggle)
    Sw.Position = UDim2.new(1, -Sw.Size.X.Offset - 12, 0.5, -s.Toggle/2)
    Sw.BackgroundColor3 = S[key] and Config.Accent or C.Off
    Sw.Text = ""
    Sw.BorderSizePixel = 0
    Sw.AutoButtonColor = false
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, s.Dot, 0, s.Dot)
    local dotOff = 2
    local dotOn = -(s.Dot + 2)
    Dot.Position = S[key] and UDim2.new(1, dotOn, 0.5, -s.Dot/2) or UDim2.new(0, dotOff, 0.5, -s.Dot/2)
    Dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    Sw.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = S[key] and UDim2.new(1, dotOn, 0.5, -s.Dot/2) or UDim2.new(0, dotOff, 0.5, -s.Dot/2)
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.15), {
            BackgroundColor3 = S[key] and Config.Accent or C.Off
        }):Play()
    end)
end

local function Soon(parent, title)
    s = SC()
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, s.Card)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 7)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -95, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.Text = title
    L.TextColor3 = C.TextDim
    L.Font = Enum.Font.Gotham
    L.TextSize = s.Font
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Badge = Instance.new("Frame", F)
    Badge.Size = UDim2.new(0, 48, 0, 18)
    Badge.Position = UDim2.new(1, -62, 0.5, -9)
    Badge.BackgroundColor3 = C.Sec
    Badge.BorderSizePixel = 0
    Instance.new("UICorner", Badge).CornerRadius = UDim.new(0, 4)
    
    local Bt = Instance.new("TextLabel", Badge)
    Bt.Size = UDim2.new(1, 0, 1, 0)
    Bt.Text = "SOON"
    Bt.TextColor3 = Config.Accent
    Bt.Font = Enum.Font.GothamBold
    Bt.TextSize = s.FontSm
    Bt.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, s.Toggle + 8, 0, s.Toggle)
    Sw.Position = UDim2.new(1, -Sw.Size.X.Offset - 12, 0.5, -s.Toggle/2)
    Sw.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local D = Instance.new("Frame", Sw)
    D.Size = UDim2.new(0, s.Dot, 0, s.Dot)
    D.Position = UDim2.new(0, 2, 0.5, -s.Dot/2)
    D.BackgroundColor3 = C.TextDim
    D.BorderSizePixel = 0
    Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)
end

-- ==========================================
-- ESP TAB
-- ==========================================
Sec(EspTab, "DEVIL FRUITS")
Tgl(EspTab, "FruitESP", "Fruit ESP")

Sec(EspTab, "PLAYERS")
Soon(EspTab, "Player ESP")

Sec(EspTab, "BOSSES")
Soon(EspTab, "Boss ESP")

Sec(EspTab, "CHESTS")
Soon(EspTab, "Chest ESP")

-- Placeholder tabs
local function Placeholder(tab, text)
    local F = Instance.new("Frame", tab)
    F.Size = UDim2.new(1, 0, 0, 80)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 7)
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Text = text
    L.TextColor3 = C.TextDim
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 13
    L.BackgroundTransparency = 1
end

Placeholder(CombatTab, "Combat features coming soon")
Placeholder(FarmTab, "Farm features coming soon")
Placeholder(TeleportTab, "Teleport features coming soon")

-- ==========================================
-- SETTINGS TAB
-- ==========================================

Sec(SettingsTab, "UI SCALE")
s = SC()

local function ScaleBtn(parent, name, scaleName)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, 0, 0, s.Card)
    B.BackgroundColor3 = Config.Scale == scaleName and Config.Accent or C.Card
    B.BackgroundTransparency = Config.Scale == scaleName and 0.2 or 0
    B.Text = name
    B.TextColor3 = Config.Scale == scaleName and Color3.new(1, 1, 1) or C.Text
    B.Font = Enum.Font.GothamMedium
    B.TextSize = s.Font
    B.BorderSizePixel = 0
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 7)
    
    B.MouseEnter:Connect(function()
        if Config.Scale ~= scaleName then
            TweenService:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = C.CardHov}):Play()
        end
    end)
    B.MouseLeave:Connect(function()
        if Config.Scale ~= scaleName then
            TweenService:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = C.Card}):Play()
        end
    end)
    
    B.MouseButton1Click:Connect(function()
        Config.Scale = scaleName
        SaveCfg()
        
        -- Update all siblings
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.15), {BackgroundColor3 = C.Card, BackgroundTransparency = 0, TextColor3 = C.Text}):Play()
            end
        end
        TweenService:Create(B, TweenInfo.new(0.15), {BackgroundColor3 = Config.Accent, BackgroundTransparency = 0.2, TextColor3 = Color3.new(1, 1, 1)}):Play()
        
        -- Reload UI elements
        for _, t in pairs(TabData) do
            local ns = SC()
            t.Btn.TextSize = ns.SideFont
            t.Btn.Size = UDim2.new(1, -10, 0, ns.SideH)
        end
    end)
end

ScaleBtn(SettingsTab, "Small", "Small")
ScaleBtn(SettingsTab, "Standard", "Standard")
ScaleBtn(SettingsTab, "Large", "Large")

Sec(SettingsTab, "THEME")

local function ThemeBtn(parent, name, themeName)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, 0, 0, s.Card)
    B.BackgroundColor3 = Config.Theme == themeName and Config.Accent or C.Card
    B.BackgroundTransparency = Config.Theme == themeName and 0.2 or 0
    B.Text = name
    B.TextColor3 = Config.Theme == themeName and Color3.new(1, 1, 1) or C.Text
    B.Font = Enum.Font.GothamMedium
    B.TextSize = s.Font
    B.BorderSizePixel = 0
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 7)
    
    B.MouseButton1Click:Connect(function()
        Config.Theme = themeName
        SaveCfg()
        C = GetColors()
        
        Main.BackgroundColor3 = C.Base
        Side.BackgroundColor3 = C.Side
        
        for _, t in pairs(TabData) do
            if t.Name ~= ActiveTab then t.Btn.TextColor3 = C.TextDim end
        end
        
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.15), {BackgroundColor3 = C.Card, BackgroundTransparency = 0, TextColor3 = C.Text}):Play()
            end
        end
        TweenService:Create(B, TweenInfo.new(0.15), {BackgroundColor3 = Config.Accent, BackgroundTransparency = 0.2, TextColor3 = Color3.new(1, 1, 1)}):Play()
    end)
end

ThemeBtn(SettingsTab, "Dark Theme", "Dark")
ThemeBtn(SettingsTab, "Light Theme", "Light")

Sec(SettingsTab, "ACCENT COLOR")

local Colors = {
    {"Purple", Color3.fromRGB(130, 90, 220)},
    {"Blue", Color3.fromRGB(60, 130, 246)},
    {"Pink", Color3.fromRGB(236, 72, 153)},
    {"Red", Color3.fromRGB(239, 68, 68)},
    {"Green", Color3.fromRGB(34, 197, 94)},
    {"Orange", Color3.fromRGB(249, 115, 22)},
    {"Cyan", Color3.fromRGB(6, 182, 212)},
}

local Grid = Instance.new("Frame", SettingsTab)
Grid.Size = UDim2.new(1, 0, 0, 52)
Grid.BackgroundTransparency = 1
local GL = Instance.new("UIGridLayout", Grid)
GL.CellSize = UDim2.new(0, 58, 0, 46)
GL.CellPadding = UDim2.new(0, 6, 0, 6)

for _, data in pairs(Colors) do
    local name, color = data[1], data[2]
    local B = Instance.new("TextButton", Grid)
    B.BackgroundColor3 = color
    B.Text = ""
    B.BorderSizePixel = 0
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 10)
    
    if Config.Accent == color then
        local Sel = Instance.new("UIStroke", B)
        Sel.Color = Color3.new(1, 1, 1)
        Sel.Thickness = 3
    end
    
    B.MouseButton1Click:Connect(function()
        Config.Accent = color
        SaveCfg()
        
        Top.BackgroundColor3 = color
        TopBot.BackgroundColor3 = color
        
        for _, t in pairs(TabData) do
            if t.Name == ActiveTab then
                t.Btn.TextColor3 = color
                t.Ind.BackgroundColor3 = color
            end
        end
        
        for _, child in pairs(Grid:GetChildren()) do
            if child:IsA("TextButton") then
                local ex = child:FindFirstChildOfClass("UIStroke")
                if ex then ex:Destroy() end
            end
        end
        Instance.new("UIStroke", B).Color = Color3.new(1, 1, 1).Thickness = 3
    end)
end

-- Drag
local drag, dragStart, startPos
Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true; dragStart = i.Position; startPos = Main.Position
    end
end)
UserInput.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInput.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)

UserInput.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
end)