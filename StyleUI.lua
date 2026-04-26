-- CatHUB v8.6: Real RedzHub Style + Resizable
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

-- UI Config (bisa diubah lewat Settings tab)
local Config = {
    Size = "Standard", -- Small, Standard, Large
    Accent = Color3.fromRGB(130, 90, 220),
    Theme = "Dark" -- Dark, Light
}

-- Size presets
local Sizes = {
    Small = UDim2.new(0, 420, 0, 280),
    Standard = UDim2.new(0, 500, 0, 340),
    Large = UDim2.new(0, 580, 0, 400)
}

-- Load config
local function LoadCfg()
    pcall(function()
        if isfile("CatHUB_UI.json") then
            local d = HttpService:JSONDecode(readfile("CatHUB_UI.json"))
            if d.Size and Sizes[d.Size] then Config.Size = d.Size end
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
            Size = Config.Size,
            Accent = {math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)},
            Theme = Config.Theme
        }))
    end)
end

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Theme colors
local function GetColors()
    if Config.Theme == "Light" then
        return {
            Base = Color3.fromRGB(240, 240, 245),
            Side = Color3.fromRGB(230, 230, 238),
            Card = Color3.fromRGB(248, 248, 252),
            CardHover = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(30, 30, 40),
            TextSec = Color3.fromRGB(80, 80, 100),
            TextDim = Color3.fromRGB(140, 140, 155),
            Off = Color3.fromRGB(200, 200, 210),
            Section = Color3.fromRGB(225, 220, 240)
        }
    else
        return {
            Base = Color3.fromRGB(20, 20, 26),
            Side = Color3.fromRGB(16, 16, 22),
            Card = Color3.fromRGB(26, 26, 34),
            CardHover = Color3.fromRGB(32, 32, 42),
            Text = Color3.fromRGB(230, 230, 240),
            TextSec = Color3.fromRGB(160, 160, 175),
            TextDim = Color3.fromRGB(90, 90, 105),
            Off = Color3.fromRGB(45, 45, 58),
            Section = Color3.fromRGB(28, 24, 42)
        }
    end
end

local C = GetColors()

-- Main Frame
local Main = Instance.new("Frame", Gui)
Main.Size = Sizes[Config.Size]
Main.Position = UDim2.new(0.5, -Sizes[Config.Size].X.Offset/2, 0.5, -Sizes[Config.Size].Y.Offset/2)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Topbar (simple, no gradient overkill)
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 40)
Top.BackgroundColor3 = Config.Accent
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

-- Fix bottom corners
local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 8)
TopFix.Position = UDim2.new(0, 0, 1, -8)
TopFix.BackgroundColor3 = Config.Accent
TopFix.BorderSizePixel = 0

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -70, 1, 0)
Ttl.Position = UDim2.new(0, 16, 0, 0)
Ttl.Text = "CATHUB"
Ttl.TextColor3 = Color3.new(1, 1, 1)
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 16
Ttl.TextXAlignment = "Left"
Ttl.BackgroundTransparency = 1

local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 36, 0, 36)
BtnX.Position = UDim2.new(1, -38, 0, 2)
BtnX.Text = "×"
BtnX.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 18
BtnX.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 36, 0, 36)
BtnM.Position = UDim2.new(1, -74, 0, 2)
BtnM.Text = "—"
BtnM.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.GothamBold
BtnM.TextSize = 14

-- Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -130, 1, -48)
Content.Position = UDim2.new(0, 125, 0, 44)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true

local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    Content.Visible = not isMin
    Main:FindFirstChild("Side").Visible = not isMin
    TweenService:Create(Main, TweenInfo.new(0.2), {
        Size = isMin and UDim2.new(0, Main.Size.X.Offset, 0, 40) or Sizes[Config.Size]
    }):Play()
end)

-- Sidebar (RedzHub style: full height, simple text)
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 120, 1, -48)
Side.Position = UDim2.new(0, 5, 0, 44)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 6)

local TabBox = Instance.new("Frame", Side)
TabBox.Size = UDim2.new(1, -8, 1, -8)
TabBox.Position = UDim2.new(0, 4, 0, 4)
TabBox.BackgroundTransparency = 1
local TabLay = Instance.new("UIListLayout", TabBox)
TabLay.Padding = UDim.new(0, 4)

-- Tab data
local TabData = {}
local ActiveTab = nil

local function Tab(name)
    local B = Instance.new("TextButton", TabBox)
    B.Size = UDim2.new(1, 0, 0, 36)
    B.BackgroundColor3 = Color3.new(1, 1, 1)
    B.BackgroundTransparency = 1
    B.Text = name
    B.TextColor3 = C.TextDim
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 12
    B.TextXAlignment = "Left"
    B.BorderSizePixel = 0
    B.AutoButtonColor = false
    Instance.new("UIPadding", B).PaddingLeft = UDim.new(0, 10)
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    
    -- Container for this tab
    local Container = Instance.new("ScrollingFrame", Content)
    Container.Size = UDim2.new(1, -12, 1, -12)
    Container.Position = UDim2.new(0, 6, 0, 6)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = Config.Accent
    Container.BorderSizePixel = 0
    Container.Visible = false
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 6)
    
    table.insert(TabData, {Btn = B, Container = Container, Name = name})
    
    -- Set first tab active
    if not ActiveTab then
        ActiveTab = name
        B.BackgroundColor3 = Config.Accent
        B.BackgroundTransparency = 0.85
        B.TextColor3 = Color3.new(1, 1, 1)
        Container.Visible = true
    end
    
    B.MouseButton1Click:Connect(function()
        -- Deactivate all
        for _, t in pairs(TabData) do
            t.Btn.BackgroundColor3 = Color3.new(1, 1, 1)
            t.Btn.BackgroundTransparency = 1
            t.Btn.TextColor3 = C.TextDim
            t.Container.Visible = false
        end
        -- Activate clicked
        B.BackgroundColor3 = Config.Accent
        B.BackgroundTransparency = 0.85
        B.TextColor3 = Color3.new(1, 1, 1)
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
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 30)
    F.BackgroundColor3 = C.Section
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = text
    L.TextColor3 = Config.Accent
    L.Font = Enum.Font.GothamBold
    L.TextSize = 12
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
end

local function Tgl(parent, key, title)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 38)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.Text = title
    L.TextColor3 = C.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 13
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("TextButton", F)
    Sw.Size = UDim2.new(0, 44, 0, 22)
    Sw.Position = UDim2.new(1, -54, 0.5, -11)
    Sw.BackgroundColor3 = S[key] and Config.Accent or C.Off
    Sw.Text = ""
    Sw.BorderSizePixel = 0
    Sw.AutoButtonColor = false
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = S[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    Sw.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Dot, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
            Position = S[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.12), {
            BackgroundColor3 = S[key] and Config.Accent or C.Off
        }):Play()
    end)
end

local function Soon(parent, title)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 38)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -90, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.Text = title
    L.TextColor3 = C.TextDim
    L.Font = Enum.Font.Gotham
    L.TextSize = 13
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Badge = Instance.new("Frame", F)
    Badge.Size = UDim2.new(0, 50, 0, 20)
    Badge.Position = UDim2.new(1, -60, 0.5, -10)
    Badge.BackgroundColor3 = C.Section
    Badge.BorderSizePixel = 0
    Instance.new("UICorner", Badge).CornerRadius = UDim.new(0, 4)
    
    local Bt = Instance.new("TextLabel", Badge)
    Bt.Size = UDim2.new(1, 0, 1, 0)
    Bt.Text = "SOON"
    Bt.TextColor3 = Config.Accent
    Bt.Font = Enum.Font.GothamBold
    Bt.TextSize = 9
    Bt.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 44, 0, 22)
    Sw.Position = UDim2.new(1, -54, 0.5, -11)
    Sw.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local D = Instance.new("Frame", Sw)
    D.Size = UDim2.new(0, 18, 0, 18)
    D.Position = UDim2.new(0, 2, 0.5, -9)
    D.BackgroundColor3 = C.TextDim
    D.BorderSizePixel = 0
    Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)
end

-- ==========================================
-- BUILD ESP TAB
-- ==========================================
Sec(EspTab, "DEVIL FRUITS")
Tgl(EspTab, "FruitESP", "Fruit ESP")

Sec(EspTab, "PLAYERS")
Soon(EspTab, "Player ESP")

Sec(EspTab, "BOSSES")
Soon(EspTab, "Boss ESP")

Sec(EspTab, "CHESTS")
Soon(EspTab, "Chest ESP")

-- Other tabs placeholder
local function PlaceholderTab(tab, text)
    local F = Instance.new("Frame", tab)
    F.Size = UDim2.new(1, 0, 0, 60)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Text = text
    L.TextColor3 = C.TextDim
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 14
    L.BackgroundTransparency = 1
end

PlaceholderTab(CombatTab, "Combat features coming soon")
PlaceholderTab(FarmTab, "Farm features coming soon")
PlaceholderTab(TeleportTab, "Teleport features coming soon")

-- ==========================================
-- SETTINGS TAB
-- ==========================================

-- UI Size section
Sec(SettingsTab, "UI SIZE")

local function SizeBtn(parent, name, sizeName)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, 0, 0, 38)
    B.BackgroundColor3 = Config.Size == sizeName and Config.Accent or C.Card
    B.BackgroundTransparency = Config.Size == sizeName and 0.15 or 0
    B.Text = name
    B.TextColor3 = Config.Size == sizeName and Color3.new(1, 1, 1) or C.Text
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 13
    B.BorderSizePixel = 0
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    
    B.MouseButton1Click:Connect(function()
        Config.Size = sizeName
        SaveCfg()
        
        -- Update UI size
        local newSize = Sizes[sizeName]
        local centerX = Main.Position.X.Scale
        local centerY = Main.Position.Y.Scale
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = isMin and UDim2.new(0, newSize.X.Offset, 0, 40) or newSize,
            Position = UDim2.new(0.5, -newSize.X.Offset/2, 0.5, -newSize.Y.Offset/2)
        }):Play()
        
        -- Update button visuals
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = C.Card
                child.BackgroundTransparency = 0
                child.TextColor3 = C.Text
            end
        end
        B.BackgroundColor3 = Config.Accent
        B.BackgroundTransparency = 0.15
        B.TextColor3 = Color3.new(1, 1, 1)
    end)
end

SizeBtn(SettingsTab, "Small", "Small")
SizeBtn(SettingsTab, "Standard", "Standard")
SizeBtn(SettingsTab, "Large", "Large")

-- Theme section
Sec(SettingsTab, "THEME")

local function ThemeBtn(parent, name, themeName)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, 0, 0, 38)
    B.BackgroundColor3 = Config.Theme == themeName and Config.Accent or C.Card
    B.BackgroundTransparency = Config.Theme == themeName and 0.15 or 0
    B.Text = name
    B.TextColor3 = Config.Theme == themeName and Color3.new(1, 1, 1) or C.Text
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 13
    B.BorderSizePixel = 0
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    
    B.MouseButton1Click:Connect(function()
        Config.Theme = themeName
        SaveCfg()
        
        -- Update colors
        C = GetColors()
        
        -- Update all UI elements
        Main.BackgroundColor3 = C.Base
        Side.BackgroundColor3 = C.Side
        
        for _, t in pairs(TabData) do
            if t.Name ~= ActiveTab then
                t.Btn.TextColor3 = C.TextDim
            end
        end
        
        -- Update button visuals
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = C.Card
                child.BackgroundTransparency = 0
                child.TextColor3 = C.Text
            end
        end
        B.BackgroundColor3 = Config.Accent
        B.BackgroundTransparency = 0.15
        B.TextColor3 = Color3.new(1, 1, 1)
    end)
end

ThemeBtn(SettingsTab, "Dark Theme", "Dark")
ThemeBtn(SettingsTab, "Light Theme", "Light")

-- Accent Color section
Sec(SettingsTab, "ACCENT COLOR")

local Colors = {
    {"Purple", Color3.fromRGB(130, 90, 220)},
    {"Blue", Color3.fromRGB(60, 130, 246)},
    {"Pink", Color3.fromRGB(236, 72, 153)},
    {"Red", Color3.fromRGB(239, 68, 68)},
    {"Green", Color3.fromRGB(34, 197, 94)},
    {"Orange", Color3.fromRGB(249, 115, 22)},
    {"Cyan", Color3.fromRGB(6, 182, 212)},
    {"Yellow", Color3.fromRGB(234, 179, 8)}
}

local ColorGrid = Instance.new("Frame", SettingsTab)
ColorGrid.Size = UDim2.new(1, 0, 0, 50)
ColorGrid.BackgroundTransparency = 1
local GridLayout = Instance.new("UIGridLayout", ColorGrid)
GridLayout.CellSize = UDim2.new(0, 50, 0, 44)
GridLayout.CellPadding = UDim2.new(0, 6, 0, 6)

for _, data in pairs(Colors) do
    local name, color = data[1], data[2]
    local B = Instance.new("TextButton", ColorGrid)
    B.BackgroundColor3 = color
    B.Text = ""
    B.BorderSizePixel = 0
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    
    -- Selected indicator
    if Config.Accent == color then
        local Sel = Instance.new("UIStroke", B)
        Sel.Color = Color3.new(1, 1, 1)
        Sel.Thickness = 3
    end
    
    B.MouseButton1Click:Connect(function()
        Config.Accent = color
        SaveCfg()
        
        -- Update topbar
        Top.BackgroundColor3 = color
        TopFix.BackgroundColor3 = color
        
        -- Update active tab
        for _, t in pairs(TabData) do
            if t.Name == ActiveTab then
                t.Btn.BackgroundColor3 = color
            end
        end
        
        -- Update scrollbars
        for _, t in pairs(TabData) do
            t.Container.ScrollBarImageColor3 = color
        end
        
        -- Update color grid selection
        for _, child in pairs(ColorGrid:GetChildren()) do
            if child:IsA("TextButton") then
                local existing = child:FindFirstChildOfClass("UIStroke")
                if existing then existing:Destroy() end
            end
        end
        local Sel = Instance.new("UIStroke", B)
        Sel.Color = Color3.new(1, 1, 1)
        Sel.Thickness = 3
    end)
end

-- Info
local Info = Instance.new("TextLabel", SettingsTab)
Info.Size = UDim2.new(1, 0, 0, 30)
Info.Text = "Settings auto-saved"
Info.TextColor3 = C.TextDim
Info.Font = Enum.Font.Gotham
Info.TextSize = 11
Info.BackgroundTransparency = 1

-- Drag
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
        local d = i.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

UserInput.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

-- Hotkey
UserInput.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)