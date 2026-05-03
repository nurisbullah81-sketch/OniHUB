-- [[ ==========================================
--      CATHUB PREMIUM · REDZ HUB REPLICA v3.0
--      Exact visual clone of redz Hub : Blox Fruits
--    ========================================== ]]

-- // Services
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput    = game:GetService("UserInputService")
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")

-- // Anti-Duplicate Cleanup
if CoreGui:FindFirstChild("CatUI") then
    CoreGui.CatUI:Destroy()
end

-- ==========================================
-- 1. SYSTEM CONFIG
-- ==========================================

local ConfigFile = "CatHUB_Config.json"

_G.Cat             = _G.Cat or {}
_G.Cat.Player      = Players.LocalPlayer
_G.Cat.Labels      = _G.Cat.Labels or {}
_G.Cat.Settings    = _G.Cat.Settings or {}

-- ==========================================
-- 2. UTILITIES
-- ==========================================

local function Tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration   or 0.2,
        style      or Enum.EasingStyle.Quint,
        direction  or Enum.EasingDirection.Out
    )
    TweenService:Create(obj, info, props):Play()
end

local function SaveSettings()
    pcall(function()
        writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings))
    end)
end

_G.Cat.SaveSettings = SaveSettings

-- ==========================================
-- 3. THEME · Exact Redz Hub dark palette
-- ==========================================

local T = {
    -- Base Backgrounds
    BG0     = Color3.fromRGB(12,  12,  16),   -- Main window
    BG1     = Color3.fromRGB(16,  16,  22),   -- Sidebar
    BG2     = Color3.fromRGB(22,  22,  30),   -- Cards
    BG3     = Color3.fromRGB(28,  28,  38),   -- Card hover
    TopBG   = Color3.fromRGB(14,  14,  20),   -- Topbar

    -- Borders
    Line    = Color3.fromRGB(34,  34,  48),
    LineAct = Color3.fromRGB(80,  130, 255),

    -- Text
    Text    = Color3.fromRGB(225, 225, 235),
    TextSub = Color3.fromRGB(140, 140, 155),
    TextDim = Color3.fromRGB(80,  80,  95),

    -- Accent (Blue-Purple as Redz)
    Accent  = Color3.fromRGB(85,  130, 255),
    AccentD = Color3.fromRGB(55,  100, 210),

    -- Toggle
    TglOn   = Color3.fromRGB(85,  130, 255),
    TglOff  = Color3.fromRGB(50,  50,  65),
    TglDot  = Color3.fromRGB(255, 255, 255),

    -- Status Colors
    Gold    = Color3.fromRGB(255, 195,  0),
    Green   = Color3.fromRGB(52,  220, 155),
    Red     = Color3.fromRGB(255, 70,  70),
    Purple  = Color3.fromRGB(140, 100, 255),
}

_G.Cat.Theme = T

-- ==========================================
-- 4. ROOT SCREENGUI
-- ==========================================

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name           = "CatUI"
Gui.ResetOnSpawn   = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder   = 999

-- ==========================================
-- 5. FLOATING TOGGLE BUTTON
-- ==========================================

local FloatCont = Instance.new("Frame", Gui)
FloatCont.Name                   = "FloatContainer"
FloatCont.Size                   = UDim2.new(0, 80, 0, 34)
FloatCont.Position               = UDim2.new(0, 16, 0.5, -17)
FloatCont.BackgroundTransparency = 1
FloatCont.ZIndex                 = 99999

local FloatBtn = Instance.new("TextButton", FloatCont)
FloatBtn.Size             = UDim2.new(0, 50, 1, 0)
FloatBtn.Position         = UDim2.new(0, 30, 0, 0)
FloatBtn.BackgroundColor3 = T.BG2
FloatBtn.Text             = "CAT"
FloatBtn.TextColor3       = T.Accent
FloatBtn.Font             = Enum.Font.GothamBold
FloatBtn.TextSize         = 13
FloatBtn.BorderSizePixel  = 0
FloatBtn.AutoButtonColor  = false
FloatBtn.ZIndex           = 99999

do
    local c = Instance.new("UICorner", FloatBtn)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", FloatBtn)
    s.Color     = T.Line
    s.Thickness = 1
end

local FloatDrag = Instance.new("TextButton", FloatCont)
FloatDrag.Size                   = UDim2.new(0, 30, 1, 0)
FloatDrag.BackgroundTransparency = 1
FloatDrag.Text                   = ""
FloatDrag.AutoButtonColor        = false
FloatDrag.ZIndex                 = 99999

-- ==========================================
-- 6. MAIN WINDOW
-- ==========================================

local Main = Instance.new("Frame", Gui)
Main.Name             = "MainFrame"
Main.Size             = UDim2.new(0, 640, 0, 420)
Main.Position         = UDim2.new(0.5, -320, 0.5, -210)
Main.BackgroundColor3 = T.BG0
Main.BorderSizePixel  = 0
Main.ClipsDescendants = true
Main.Visible          = true

do
    local c = Instance.new("UICorner", Main)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", Main)
    s.Color     = T.Line
    s.Thickness = 1
end

FloatBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ==========================================
-- 7. TOP BAR · redz hub style
-- ==========================================

local Top = Instance.new("Frame", Main)
Top.Name             = "TopBar"
Top.Size             = UDim2.new(1, 0, 0, 42)
Top.BackgroundColor3 = T.TopBG
Top.BorderSizePixel  = 0
Top.ZIndex           = 2

do
    local c = Instance.new("UICorner", Top)
    c.CornerRadius = UDim.new(0, 8)
    local fix = Instance.new("Frame", Top)
    fix.Size             = UDim2.new(1, 0, 0, 12)
    fix.Position         = UDim2.new(0, 0, 1, -12)
    fix.BackgroundColor3 = T.TopBG
    fix.BorderSizePixel  = 0
    local line = Instance.new("Frame", Top)
    line.Size             = UDim2.new(1, 0, 0, 1)
    line.Position         = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = T.Line
    line.BorderSizePixel  = 0
end

-- Title text: "redz hub · Blox Fruits"
local TitleCont = Instance.new("Frame", Top)
TitleCont.Name                   = "TitleCont"
TitleCont.Size                   = UDim2.new(0, 340, 1, 0)
TitleCont.Position               = UDim2.new(0, 14, 0, 0)
TitleCont.BackgroundTransparency = 1

local TitleList = Instance.new("UIListLayout", TitleCont)
TitleList.FillDirection     = Enum.FillDirection.Horizontal
TitleList.VerticalAlignment = Enum.VerticalAlignment.Center
TitleList.Padding           = UDim.new(0, 5)

local function MakeTitlePart(text, color, font, size)
    local l = Instance.new("TextLabel", TitleCont)
    l.Text                   = text
    l.TextColor3             = color
    l.Font                   = font or Enum.Font.GothamBold
    l.TextSize               = size or 13
    l.BackgroundTransparency = 1
    l.AutomaticSize          = Enum.AutomaticSize.XY
    return l
end

MakeTitlePart("redz",        T.Accent,  Enum.Font.GothamBold,   14)
MakeTitlePart("hub",         T.Text,    Enum.Font.GothamBold,   14)
MakeTitlePart("·",           T.TextDim, Enum.Font.Gotham,       14)
MakeTitlePart("Blox Fruits", T.TextSub, Enum.Font.GothamMedium, 12)

-- Window control buttons (close & minimize)
local function MakeWinBtn(xOffset, symbol, size)
    local b = Instance.new("TextButton", Top)
    b.Size                   = UDim2.new(0, 42, 0, 42)
    b.Position               = UDim2.new(1, xOffset, 0, 0)
    b.Text                   = symbol
    b.TextColor3             = T.TextSub
    b.TextSize               = size or 16
    b.Font                   = Enum.Font.GothamBold
    b.BackgroundTransparency = 1
    b.AutoButtonColor        = false
    b.ZIndex                 = 3
    return b
end

local BtnX = MakeWinBtn(-42,  "✕", 16)
local BtnM = MakeWinBtn(-84,  "—", 14)

BtnX.MouseEnter:Connect(function() Tween(BtnX, {TextColor3 = T.Red}, 0.1) end)
BtnX.MouseLeave:Connect(function() Tween(BtnX, {TextColor3 = T.TextSub}, 0.1) end)
BtnM.MouseEnter:Connect(function() Tween(BtnM, {TextColor3 = T.Text}, 0.1) end)
BtnM.MouseLeave:Connect(function() Tween(BtnM, {TextColor3 = T.TextSub}, 0.1) end)

BtnX.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

local isMinimized = false
local lastSize    = Main.Size

BtnM.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then lastSize = Main.Size end
    local h = isMinimized and 42 or lastSize.Y.Offset
    Tween(Main, { Size = UDim2.new(0, Main.Size.X.Offset, 0, h) }, 0.25, Enum.EasingStyle.Quint)
end)

-- ==========================================
-- 8. DRAG & RESIZE STATE
-- ==========================================

local dragMain  = { active = false, start = nil, pos = nil }
local dragFloat = { active = false, start = nil, pos = nil }
local resizer   = { active = false, start = nil, size = nil }

Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragMain.active = true
        dragMain.start  = i.Position
        dragMain.pos    = Main.Position
    end
end)

Top.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragMain.active = false
    end
end)

FloatDrag.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragFloat.active = true
        dragFloat.start  = i.Position
        dragFloat.pos    = FloatCont.Position
    end
end)

FloatDrag.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragFloat.active = false
    end
end)

-- Resize handle kanan-bawah
local Resizer = Instance.new("TextButton", Main)
Resizer.Size                   = UDim2.new(0, 28, 0, 28)
Resizer.Position               = UDim2.new(1, -28, 1, -28)
Resizer.BackgroundTransparency = 1
Resizer.Text                   = "⌟"
Resizer.TextColor3             = T.TextDim
Resizer.TextSize               = 24
Resizer.Font                   = Enum.Font.Gotham
Resizer.ZIndex                 = 99999
Resizer.AutoButtonColor        = false

Resizer.InputBegan:Connect(function(i)
    if (i.UserInputType == Enum.UserInputType.MouseButton1
    or  i.UserInputType == Enum.UserInputType.Touch)
    and not isMinimized then
        resizer.active = true
        resizer.start  = UserInput:GetMouseLocation()
        resizer.size   = Main.Size
    end
end)

UserInput.InputChanged:Connect(function(i)
    local isMove = i.UserInputType == Enum.UserInputType.MouseMovement
               or i.UserInputType == Enum.UserInputType.Touch
    if not isMove then return end

    if dragMain.active and dragMain.start then
        local d = i.Position - dragMain.start
        Main.Position = UDim2.new(
            dragMain.pos.X.Scale, dragMain.pos.X.Offset + d.X,
            dragMain.pos.Y.Scale, dragMain.pos.Y.Offset + d.Y
        )
    end

    if dragFloat.active and dragFloat.start then
        local d = i.Position - dragFloat.start
        FloatCont.Position = UDim2.new(
            dragFloat.pos.X.Scale, dragFloat.pos.X.Offset + d.X,
            dragFloat.pos.Y.Scale, dragFloat.pos.Y.Offset + d.Y
        )
    end

    if resizer.active and resizer.start then
        local cur = UserInput:GetMouseLocation()
        local d   = cur - resizer.start
        Main.Size = UDim2.new(0,
            math.clamp(resizer.size.X.Offset + d.X, 420, 1000),
            0,
            math.clamp(resizer.size.Y.Offset + d.Y, 280, 800)
        )
        lastSize = Main.Size
    end
end)

UserInput.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragMain.active  = false
        dragFloat.active = false
        resizer.active   = false
    end
end)

-- ==========================================
-- 9. BODY LAYOUT
-- ==========================================

local Body = Instance.new("Frame", Main)
Body.Name                   = "Body"
Body.Size                   = UDim2.new(1, 0, 1, -42)
Body.Position               = UDim2.new(0, 0, 0, 42)
Body.BackgroundTransparency = 1

-- ==========================================
-- 10. SIDEBAR (exact Redz style)
-- ==========================================

local Side = Instance.new("Frame", Body)
Side.Name             = "Sidebar"
Side.Size             = UDim2.new(0, 170, 1, 0)
Side.BackgroundColor3 = T.BG1
Side.BorderSizePixel  = 0

local SideLine = Instance.new("Frame", Side)
SideLine.Size             = UDim2.new(0, 1, 1, 0)
SideLine.Position         = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3 = T.Line
SideLine.BorderSizePixel  = 0

-- Search Box
local SearchWrap = Instance.new("Frame", Side)
SearchWrap.Name             = "SearchWrap"
SearchWrap.Size             = UDim2.new(1, -16, 0, 30)
SearchWrap.Position         = UDim2.new(0, 8, 0, 12)
SearchWrap.BackgroundColor3 = T.BG2
SearchWrap.BorderSizePixel  = 0

do
    local c = Instance.new("UICorner", SearchWrap)
    c.CornerRadius = UDim.new(0, 7)
    local s = Instance.new("UIStroke", SearchWrap)
    s.Color     = T.Line
    s.Thickness = 1
end

local SearchIcon = Instance.new("TextLabel", SearchWrap)
SearchIcon.Size                   = UDim2.new(0, 24, 1, 0)
SearchIcon.Position               = UDim2.new(0, 6, 0, 0)
SearchIcon.Text                   = "⌕"
SearchIcon.TextSize               = 15
SearchIcon.TextColor3             = T.TextDim
SearchIcon.Font                   = Enum.Font.Gotham
SearchIcon.BackgroundTransparency = 1

local SearchBox = Instance.new("TextBox", SearchWrap)
SearchBox.Size                   = UDim2.new(1, -30, 1, 0)
SearchBox.Position               = UDim2.new(0, 26, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text                   = ""
SearchBox.PlaceholderText        = "Search..."
SearchBox.TextColor3             = T.Text
SearchBox.PlaceholderColor3      = T.TextDim
SearchBox.Font                   = Enum.Font.GothamMedium
SearchBox.TextSize               = 12
SearchBox.TextXAlignment         = Enum.TextXAlignment.Left

-- Scrollable tab list
local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Name                   = "SideScroll"
SideScroll.Size                   = UDim2.new(1, 0, 1, -52)
SideScroll.Position               = UDim2.new(0, 0, 0, 52)
SideScroll.BackgroundTransparency = 1
SideScroll.ScrollBarThickness     = 0
SideScroll.BorderSizePixel        = 0
SideScroll.CanvasSize             = UDim2.new(0, 0, 0, 0)

local SideList = Instance.new("UIListLayout", SideScroll)
SideList.Padding   = UDim.new(0, 2)
SideList.SortOrder = Enum.SortOrder.LayoutOrder

local SidePad = Instance.new("UIPadding", SideScroll)
SidePad.PaddingLeft   = UDim.new(0, 8)
SidePad.PaddingRight  = UDim.new(0, 8)
SidePad.PaddingTop    = UDim.new(0, 4)
SidePad.PaddingBottom = UDim.new(0, 8)

SideList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SideScroll.CanvasSize = UDim2.new(0, 0, 0, SideList.AbsoluteContentSize.Y + 16)
end)

-- ==========================================
-- 11. CONTENT AREA
-- ==========================================

local ContentArea = Instance.new("Frame", Body)
ContentArea.Name                   = "ContentArea"
ContentArea.Size                   = UDim2.new(1, -170, 1, 0)
ContentArea.Position               = UDim2.new(0, 170, 0, 0)
ContentArea.BackgroundTransparency = 1

-- ==========================================
-- 12. FOOTER STATUS BAR (Health, Energy)
-- ==========================================

local Footer = Instance.new("Frame", Main)
Footer.Name             = "Footer"
Footer.Size             = UDim2.new(1, 0, 0, 32)
Footer.Position         = UDim2.new(0, 0, 1, -32)
Footer.BackgroundColor3 = T.TopBG
Footer.BorderSizePixel  = 0
Footer.ZIndex           = 2

do
    local line = Instance.new("Frame", Footer)
    line.Size             = UDim2.new(1, 0, 0, 1)
    line.BackgroundColor3 = T.Line
    line.BorderSizePixel  = 0
end

-- Health display
local HealthFrame = Instance.new("Frame", Footer)
HealthFrame.Size                   = UDim2.new(0, 140, 0, 20)
HealthFrame.Position               = UDim2.new(0, 14, 0.5, -10)
HealthFrame.BackgroundTransparency = 1

local HealthIcon = Instance.new("TextLabel", HealthFrame)
HealthIcon.Size                   = UDim2.new(0, 18, 1, 0)
HealthIcon.Text                   = "♥"
HealthIcon.TextColor3             = T.Red
HealthIcon.Font                   = Enum.Font.GothamBold
HealthIcon.TextSize               = 13
HealthIcon.BackgroundTransparency = 1

local HealthText = Instance.new("TextLabel", HealthFrame)
HealthText.Size                   = UDim2.new(1, -22, 1, 0)
HealthText.Position               = UDim2.new(0, 20, 0, 0)
HealthText.Text                   = "Health · 100 / 100"
HealthText.TextColor3             = T.Text
HealthText.Font                   = Enum.Font.GothamMedium
HealthText.TextSize               = 11
HealthText.TextXAlignment         = Enum.TextXAlignment.Left
HealthText.BackgroundTransparency = 1

-- Energy display
local EnergyFrame = Instance.new("Frame", Footer)
EnergyFrame.Size                   = UDim2.new(0, 140, 0, 20)
EnergyFrame.Position               = UDim2.new(0, 160, 0.5, -10)
EnergyFrame.BackgroundTransparency = 1

local EnergyIcon = Instance.new("TextLabel", EnergyFrame)
EnergyIcon.Size                   = UDim2.new(0, 18, 1, 0)
EnergyIcon.Text                   = "⚡"
EnergyIcon.TextColor3             = T.Gold
EnergyIcon.Font                   = Enum.Font.GothamBold
EnergyIcon.TextSize               = 13
EnergyIcon.BackgroundTransparency = 1

local EnergyText = Instance.new("TextLabel", EnergyFrame)
EnergyText.Size                   = UDim2.new(1, -22, 1, 0)
EnergyText.Position               = UDim2.new(0, 20, 0, 0)
EnergyText.Text                   = "Energy · 100 / 100"
EnergyText.TextColor3             = T.Text
EnergyText.Font                   = Enum.Font.GothamMedium
EnergyText.TextSize               = 11
EnergyText.TextXAlignment         = Enum.TextXAlignment.Left
EnergyText.BackgroundTransparency = 1

-- Player count / version text (kanan footer)
local VersionText = Instance.new("TextLabel", Footer)
VersionText.Size                   = UDim2.new(0, 120, 1, 0)
VersionText.Position               = UDim2.new(1, -130, 0, 0)
VersionText.Text                   = "u.16 · 016/1,261"
VersionText.TextColor3             = T.TextSub
VersionText.Font                   = Enum.Font.GothamMedium
VersionText.TextSize               = 10
VersionText.TextXAlignment         = Enum.TextXAlignment.Right
VersionText.BackgroundTransparency = 1

-- Update footer stats dynamically
local function UpdateFooterStats()
    local player = Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            local health = math.floor(humanoid.Health)
            local maxHealth = math.floor(humanoid.MaxHealth)
            HealthText.Text = "Health · " .. health .. " / " .. maxHealth

            -- Energy (jika ada atribut energy di game)
            -- Placeholder, bisa disambungkan ke sistem energy game
            EnergyText.Text = "Energy · 100 / 100"
        end
    end
    -- Player count
    local count = #Players:GetPlayers()
    VersionText.Text = "u.16 · " .. count .. "/" .. game.Players.MaxPlayers
end

-- Update berkala
RunService.Stepped:Connect(UpdateFooterStats)

-- Public method to update
_G.Cat.UpdateFooter = UpdateFooterStats

-- Adjust body size to accommodate footer
Body.Size = UDim2.new(1, 0, 1, -74) -- 42 top + 32 bottom
Body.Position = UDim2.new(0, 0, 0, 42)

-- ==========================================
-- 13. TAB SYSTEM (mirip Redz sidebar)
-- ==========================================

local Pages    = {}
local AllItems = {}

-- Tab order & icons matching Redz Hub
local TabOrder = {
    "Farm",
    "Fishing",
    "Quest/Items",
    "Raid/Fruits",
    "Sea",
    "Stats",
    "Teleport",
    "Status",
    "Visual",
    "Shop",
    "Misc",
}

local TabIcons = {
    ["Farm"]        = "⚔",
    ["Fishing"]     = "🎣",
    ["Quest/Items"] = "📋",
    ["Raid/Fruits"] = "🍈",
    ["Sea"]         = "🌊",
    ["Stats"]       = "📊",
    ["Teleport"]    = "◎",
    ["Status"]      = "◈",
    ["Visual"]      = "👁",
    ["Shop"]        = "🛒",
    ["Misc"]        = "⚙",
    ["Auto Farm"]   = "⚔",
    ["Devil Fruits"]= "◉",
}

local function CreateTab(name, isFirst)
    if Pages[name] then return Pages[name].Page end

    local order = 99
    for i, v in ipairs(TabOrder) do
        if v == name then order = i break end
    end
    if order == 99 and name == "Auto Farm" then order = 1 end
    if order == 99 and name == "Devil Fruits" then order = 4 end

    -- ── Sidebar Button ──────────────────────
    local Btn = Instance.new("TextButton", SideScroll)
    Btn.Name             = name .. "_TabBtn"
    Btn.LayoutOrder      = order
    Btn.Size             = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = isFirst and T.BG2 or T.BG1
    Btn.Text             = ""
    Btn.BorderSizePixel  = 0
    Btn.AutoButtonColor  = false

    local BtnCorner = Instance.new("UICorner", Btn)
    BtnCorner.CornerRadius = UDim.new(0, 7)

    -- Left indicator bar
    local Ind = Instance.new("Frame", Btn)
    Ind.Name             = "Indicator"
    Ind.Size             = UDim2.new(0, 3, 0, 16)
    Ind.Position         = UDim2.new(0, 0, 0.5, -8)
    Ind.BackgroundColor3 = T.Accent
    Ind.BorderSizePixel  = 0
    Ind.Visible          = isFirst

    local IndCorner = Instance.new("UICorner", Ind)
    IndCorner.CornerRadius = UDim.new(1, 0)

    -- Icon
    local Icon = Instance.new("TextLabel", Btn)
    Icon.Size                   = UDim2.new(0, 26, 1, 0)
    Icon.Position               = UDim2.new(0, 12, 0, 0)
    Icon.Text                   = TabIcons[name] or "●"
    Icon.TextSize               = 14
    Icon.TextColor3             = isFirst and T.Accent or T.TextDim
    Icon.Font                   = Enum.Font.Gotham
    Icon.BackgroundTransparency = 1

    -- Label
    local Lbl = Instance.new("TextLabel", Btn)
    Lbl.Size                   = UDim2.new(1, -44, 1, 0)
    Lbl.Position               = UDim2.new(0, 40, 0, 0)
    Lbl.Text                   = name
    Lbl.TextColor3             = isFirst and T.Text or T.TextSub
    Lbl.Font                   = Enum.Font.GothamMedium
    Lbl.TextSize               = 12
    Lbl.TextXAlignment         = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    -- Hover
    Btn.MouseEnter:Connect(function()
        if not Pages[name] or not Pages[name].Page.Visible then
            Tween(Btn, { BackgroundColor3 = T.BG3 }, 0.1)
        end
    end)
    Btn.MouseLeave:Connect(function()
        if not Pages[name] or not Pages[name].Page.Visible then
            Tween(Btn, { BackgroundColor3 = T.BG1 }, 0.1)
        end
    end)

    -- ── Content Page ────────────────────────
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Name                   = name .. "_Page"
    Page.Size                   = UDim2.new(1, -14, 1, -14)
    Page.Position               = UDim2.new(0, 7, 0, 7)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness     = 2
    Page.ScrollBarImageColor3   = T.Line
    Page.Visible                = isFirst
    Page.BorderSizePixel        = 0
    Page.CanvasSize             = UDim2.new(0, 0, 0, 0)

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding   = UDim.new(0, 5)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local PagePad = Instance.new("UIPadding", Page)
    PagePad.PaddingTop    = UDim.new(0, 6)
    PagePad.PaddingLeft   = UDim.new(0, 2)
    PagePad.PaddingRight  = UDim.new(0, 8)
    PagePad.PaddingBottom = UDim.new(0, 12)

    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)

    -- ── Tab Switch ─────────────────────────
    Btn.MouseButton1Click:Connect(function()
        if Pages[name] and Pages[name].Page.Visible then return end

        for n, d in pairs(Pages) do
            local active = (n == name)
            d.Page.Visible = active
            d.Ind.Visible  = active

            Tween(d.Btn,  { BackgroundColor3 = active and T.BG2 or T.BG1 }, 0.15)
            Tween(d.Icon, { TextColor3       = active and T.Accent or T.TextDim }, 0.15)
            Tween(d.Lbl,  { TextColor3       = active and T.Text or T.TextSub  }, 0.15)
        end
    end)

    Pages[name] = { Btn = Btn, Page = Page, Ind = Ind, Icon = Icon, Lbl = Lbl }
    return Page
end

-- ==========================================
-- 14. UI COMPONENTS (exact Redz style)
-- ==========================================

-- Section Header with right divider
local function CreateSection(parent, text)
    local Frame = Instance.new("Frame", parent)
    Frame.Name                   = "Sec_" .. text
    Frame.LayoutOrder            = #parent:GetChildren()
    Frame.Size                   = UDim2.new(1, 0, 0, 28)
    Frame.BackgroundTransparency = 1

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size                   = UDim2.new(0, 0, 1, 0)
    Lbl.AutomaticSize          = Enum.AutomaticSize.X
    Lbl.Position               = UDim2.new(0, 2, 0, 0)
    Lbl.Text                   = string.upper(text)
    Lbl.TextColor3             = T.TextSub
    Lbl.Font                   = Enum.Font.GothamBold
    Lbl.TextSize               = 10
    Lbl.TextXAlignment         = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    local Line = Instance.new("Frame", Frame)
    Line.Name             = "Line"
    Line.AnchorPoint      = Vector2.new(0, 0.5)
    Line.Size             = UDim2.new(1, -130, 0, 1)
    Line.Position         = UDim2.new(0, 126, 0.6, 0)
    Line.BackgroundColor3 = T.Line
    Line.BorderSizePixel  = 0
end

-- Toggle Switch (Redz style track + dot)
local function CreateToggle(parent, text, description, defaultState, callback)
    local h = description and 56 or 40

    local Btn = Instance.new("TextButton", parent)
    Btn.Name             = text .. "_Toggle"
    Btn.LayoutOrder      = #parent:GetChildren()
    Btn.Size             = UDim2.new(1, 0, 0, h)
    Btn.BackgroundColor3 = T.BG2
    Btn.BorderSizePixel  = 0
    Btn.Text             = ""
    Btn.AutoButtonColor  = false

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 7)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color     = T.Line
    Stroke.Thickness = 1

    Btn.MouseEnter:Connect(function() Tween(Btn, { BackgroundColor3 = T.BG3 }, 0.1) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, { BackgroundColor3 = T.BG2 }, 0.1) end)

    local Title = Instance.new("TextLabel", Btn)
    Title.Size                   = UDim2.new(1, -70, 0, 18)
    Title.Position               = UDim2.new(0, 14, 0, description and 8 or 11)
    Title.Text                   = text
    Title.TextColor3             = T.Text
    Title.Font                   = Enum.Font.GothamMedium
    Title.TextSize               = 12
    Title.TextXAlignment         = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    if description then
        local Desc = Instance.new("TextLabel", Btn)
        Desc.Size                   = UDim2.new(1, -70, 0, 14)
        Desc.Position               = UDim2.new(0, 14, 0, 28)
        Desc.Text                   = description
        Desc.TextColor3             = T.TextSub
        Desc.Font                   = Enum.Font.Gotham
        Desc.TextSize               = 10
        Desc.TextXAlignment         = Enum.TextXAlignment.Left
        Desc.BackgroundTransparency = 1
    end

    -- Track
    local Track = Instance.new("Frame", Btn)
    Track.Size             = UDim2.new(0, 40, 0, 22)
    Track.Position         = UDim2.new(1, -54, 0.5, -11)
    Track.BackgroundColor3 = defaultState and T.TglOn or T.TglOff
    Track.BorderSizePixel  = 0

    local TrackCorner = Instance.new("UICorner", Track)
    TrackCorner.CornerRadius = UDim.new(1, 0)

    -- Dot
    local Dot = Instance.new("Frame", Track)
    Dot.Size             = UDim2.new(0, 18, 0, 18)
    Dot.Position         = defaultState
        and UDim2.new(1, -20, 0.5, -9)
        or  UDim2.new(0,   2, 0.5, -9)
    Dot.BackgroundColor3 = T.TglDot
    Dot.BorderSizePixel  = 0

    local DotCorner = Instance.new("UICorner", Dot)
    DotCorner.CornerRadius = UDim.new(1, 0)

    local state = defaultState or false

    Btn.MouseButton1Click:Connect(function()
        state = not state
        Tween(Track, { BackgroundColor3 = state and T.TglOn or T.TglOff }, 0.2)
        Tween(Dot,   { Position = state
            and UDim2.new(1, -20, 0.5, -9)
            or  UDim2.new(0,   2, 0.5, -9) }, 0.2)
        if callback then callback(state) end
        SaveSettings()
    end)

    table.insert(AllItems, { Btn = Btn, Label = Title })
    return Btn
end

-- Button with arrow › (Redz style)
local function CreateButton(parent, text, description, callback)
    local h = description and 56 or 40

    local Btn = Instance.new("TextButton", parent)
    Btn.Name             = text .. "_Btn"
    Btn.LayoutOrder      = #parent:GetChildren()
    Btn.Size             = UDim2.new(1, 0, 0, h)
    Btn.BackgroundColor3 = T.BG2
    Btn.BorderSizePixel  = 0
    Btn.Text             = ""
    Btn.AutoButtonColor  = false

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 7)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color     = T.Line
    Stroke.Thickness = 1

    Btn.MouseEnter:Connect(function() Tween(Btn, { BackgroundColor3 = T.BG3 }, 0.1) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, { BackgroundColor3 = T.BG2 }, 0.1) end)

    local Title = Instance.new("TextLabel", Btn)
    Title.Size                   = UDim2.new(1, -50, 0, 18)
    Title.Position               = UDim2.new(0, 14, 0, description and 8 or 11)
    Title.Text                   = text
    Title.TextColor3             = T.Text
    Title.Font                   = Enum.Font.GothamMedium
    Title.TextSize               = 12
    Title.TextXAlignment         = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    if description then
        local Desc = Instance.new("TextLabel", Btn)
        Desc.Size                   = UDim2.new(1, -50, 0, 14)
        Desc.Position               = UDim2.new(0, 14, 0, 28)
        Desc.Text                   = description
        Desc.TextColor3             = T.TextSub
        Desc.Font                   = Enum.Font.Gotham
        Desc.TextSize               = 10
        Desc.TextXAlignment         = Enum.TextXAlignment.Left
        Desc.BackgroundTransparency = 1
    end

    local Arrow = Instance.new("TextLabel", Btn)
    Arrow.Size                   = UDim2.new(0, 32, 1, 0)
    Arrow.Position               = UDim2.new(1, -38, 0, 0)
    Arrow.Text                   = "›"
    Arrow.TextColor3             = T.Accent
    Arrow.TextSize               = 24
    Arrow.Font                   = Enum.Font.GothamBold
    Arrow.BackgroundTransparency = 1

    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    table.insert(AllItems, { Btn = Btn, Label = Title })
    return Btn
end

-- Dropdown (label kiri, value kanan, chevron)
local function CreateDropdown(parent, text, options, defaultIndex, callback)
    local currentIndex = defaultIndex or 1

    local Btn = Instance.new("TextButton", parent)
    Btn.Name             = text .. "_Dropdown"
    Btn.LayoutOrder      = #parent:GetChildren()
    Btn.Size             = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = T.BG2
    Btn.BorderSizePixel  = 0
    Btn.Text             = ""
    Btn.AutoButtonColor  = false

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 7)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color     = T.Line
    Stroke.Thickness = 1

    Btn.MouseEnter:Connect(function() Tween(Btn, { BackgroundColor3 = T.BG3 }, 0.1) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, { BackgroundColor3 = T.BG2 }, 0.1) end)

    local Title = Instance.new("TextLabel", Btn)
    Title.Size                   = UDim2.new(0.45, 0, 1, 0)
    Title.Position               = UDim2.new(0, 14, 0, 0)
    Title.Text                   = text
    Title.TextColor3             = T.Text
    Title.Font                   = Enum.Font.GothamMedium
    Title.TextSize               = 12
    Title.TextXAlignment         = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    local ValueLbl = Instance.new("TextLabel", Btn)
    ValueLbl.Size                   = UDim2.new(0.4, 0, 1, 0)
    ValueLbl.Position               = UDim2.new(0.45, 0, 0, 0)
    ValueLbl.Text                   = options[currentIndex] or ""
    ValueLbl.TextColor3             = T.Text
    ValueLbl.Font                   = Enum.Font.GothamBold
    ValueLbl.TextSize               = 12
    ValueLbl.TextXAlignment         = Enum.TextXAlignment.Right
    ValueLbl.BackgroundTransparency = 1

    local ChevLbl = Instance.new("TextLabel", Btn)
    ChevLbl.Size                   = UDim2.new(0, 26, 1, 0)
    ChevLbl.Position               = UDim2.new(1, -30, 0, 0)
    ChevLbl.Text                   = "⌄"
    ChevLbl.TextColor3             = T.Accent
    ChevLbl.TextSize               = 15
    ChevLbl.Font                   = Enum.Font.GothamBold
    ChevLbl.BackgroundTransparency = 1

    Btn.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #options) + 1
        ValueLbl.Text = options[currentIndex]
        if callback then callback(options[currentIndex], currentIndex) end
        SaveSettings()
    end)

    table.insert(AllItems, { Btn = Btn, Label = Title })
    return Btn
end

-- Slider (ex. UI Scale)
local function CreateSlider(parent, text, minVal, maxVal, defaultVal, step, callback)
    local currentVal = defaultVal

    local Frame = Instance.new("Frame", parent)
    Frame.Name            = text .. "_Slider"
    Frame.LayoutOrder     = #parent:GetChildren()
    Frame.Size            = UDim2.new(1, 0, 0, 56)
    Frame.BackgroundColor3 = T.BG2
    Frame.BorderSizePixel = 0

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 7)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color     = T.Line
    Stroke.Thickness = 1

    local Title = Instance.new("TextLabel", Frame)
    Title.Size                   = UDim2.new(1, -28, 0, 18)
    Title.Position               = UDim2.new(0, 14, 0, 8)
    Title.Text                   = text
    Title.TextColor3             = T.Text
    Title.Font                   = Enum.Font.GothamMedium
    Title.TextSize               = 12
    Title.TextXAlignment         = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    local ValLbl = Instance.new("TextLabel", Frame)
    ValLbl.Size                   = UDim2.new(0, 40, 0, 18)
    ValLbl.Position               = UDim2.new(1, -50, 0, 8)
    ValLbl.Text                   = tostring(defaultVal)
    ValLbl.TextColor3             = T.Accent
    ValLbl.Font                   = Enum.Font.GothamBold
    ValLbl.TextSize               = 12
    ValLbl.TextXAlignment         = Enum.TextXAlignment.Right
    ValLbl.BackgroundTransparency = 1

    -- Slider track
    local Track = Instance.new("TextButton", Frame)
    Track.Size             = UDim2.new(1, -28, 0, 6)
    Track.Position         = UDim2.new(0, 14, 0, 34)
    Track.BackgroundColor3 = T.TglOff
    Track.BorderSizePixel  = 0
    Track.Text             = ""
    Track.AutoButtonColor  = false

    local TrackCorner = Instance.new("UICorner", Track)
    TrackCorner.CornerRadius = UDim.new(0, 3)

    -- Fill
    local Fill = Instance.new("Frame", Track)
    Fill.Size             = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = T.Accent
    Fill.BorderSizePixel  = 0

    local FillCorner = Instance.new("UICorner", Fill)
    FillCorner.CornerRadius = UDim.new(0, 3)

    local dragging = false

    local function setValue(input)
        local relX = (input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X
        relX = math.clamp(relX, 0, 1)
        local rawVal = minVal + (maxVal - minVal) * relX
        local stepped = minVal + math.floor((rawVal - minVal) / step + 0.5) * step
        stepped = math.clamp(stepped, minVal, maxVal)
        currentVal = stepped
        Fill.Size = UDim2.new((stepped - minVal) / (maxVal - minVal), 0, 1, 0)
        ValLbl.Text = string.format("%.1f", stepped)
        if callback then callback(stepped) end
        SaveSettings()
    end

    Track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setValue(i)
        end
    end)
    Track.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    Track.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            setValue(i)
        end
    end)

    table.insert(AllItems, { Btn = Frame, Label = Title })
    return { Set = function(v) setValue({Position = Vector2.new(Track.AbsolutePosition.X + (v-minVal)/(maxVal-minVal)*Track.AbsoluteSize.X,0)}) end }
end

-- Label Card
local function CreateLabel(parent, text, description)
    local h = description and 48 or 34

    local Frame = Instance.new("Frame", parent)
    Frame.Name            = "Lbl_" .. text
    Frame.LayoutOrder     = #parent:GetChildren()
    Frame.Size            = UDim2.new(1, 0, 0, h)
    Frame.BackgroundColor3 = T.BG2
    Frame.BorderSizePixel = 0

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 7)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color     = T.Line
    Stroke.Thickness = 1

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size                   = UDim2.new(1, -24, 0, 18)
    Lbl.Position               = UDim2.new(0, 14, 0, description and 4 or 8)
    Lbl.Text                   = text
    Lbl.TextColor3             = T.Text
    Lbl.Font                   = Enum.Font.GothamMedium
    Lbl.TextSize               = 12
    Lbl.TextXAlignment         = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    if description then
        local Sub = Instance.new("TextLabel", Frame)
        Sub.Size                   = UDim2.new(1, -24, 0, 14)
        Sub.Position               = UDim2.new(0, 14, 0, 24)
        Sub.Text                   = description
        Sub.TextColor3             = T.TextSub
        Sub.Font                   = Enum.Font.Gotham
        Sub.TextSize               = 10
        Sub.TextXAlignment         = Enum.TextXAlignment.Left
        Sub.BackgroundTransparency = 1
    end

    return Lbl
end

-- ==========================================
-- 15. SEARCH FUNCTIONALITY
-- ==========================================

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(SearchBox.Text)
    for _, item in ipairs(AllItems) do
        local lbl   = string.lower(item.Label.Text)
        local empty = (q == "")
        local found = (string.find(lbl, q) ~= nil)
        item.Btn.Visible = empty or found
    end
end)

-- ==========================================
-- 16. INITIALIZE DEFAULT TABS
-- ==========================================

CreateTab("Farm",        true)
CreateTab("Fishing",     false)
CreateTab("Quest/Items", false)
CreateTab("Raid/Fruits", false)
CreateTab("Sea",         false)
CreateTab("Stats",       false)
CreateTab("Teleport",    false)
CreateTab("Status",      false)
CreateTab("Visual",      false)
CreateTab("Shop",        false)
CreateTab("Misc",        false)

-- ==========================================
-- 17. GLOBAL EXPORT (Lengkap)
-- ==========================================

_G.Cat.UI = {
    CreateTab      = CreateTab,
    CreateSection  = CreateSection,
    CreateToggle   = CreateToggle,
    CreateButton   = CreateButton,
    CreateDropdown = CreateDropdown,
    CreateSlider   = CreateSlider,
    CreateLabel    = CreateLabel,

    Theme          = T,
    Tween          = Tween,
    SaveSettings   = SaveSettings,
    Pages          = Pages,
    UpdateFooter   = UpdateFooterStats,

    -- Direct access buat module lain
    MainFrame      = Main,
    Sidebar        = Side,
    ContentArea    = ContentArea,
    SearchBox      = SearchBox,
    FloatButton    = FloatBtn,
    Footer         = {
        Health = HealthText,
        Energy = EnergyText,
        Version = VersionText,
    },
}

warn("[CatHUB v3.0] Redz Hub replica UI loaded successfully. // " .. #TabOrder .. " tabs configured")