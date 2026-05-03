-- [[ ==========================================
--      CATHUB v3.0 · REDZ HUB ACCURATE STYLE
--      Modular UI Framework · Blox Fruits
--    ========================================== ]]

-- // Services
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput    = game:GetService("UserInputService")
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")

-- // Anti-Duplicate
if CoreGui:FindFirstChild("CatUI") then
    CoreGui.CatUI:Destroy()
end

-- // Global State
_G.Cat          = _G.Cat or {}
_G.Cat.Player   = Players.LocalPlayer
_G.Cat.Settings = _G.Cat.Settings or {}

-- ============================================================
-- THEME  ·  Warna akurat sesuai Redz Hub screenshot
-- ============================================================

local C = {
    -- Window Backgrounds
    BG          = Color3.fromRGB(14,  14,  18),    -- Body utama
    SideBG      = Color3.fromRGB(20,  20,  26),    -- Sidebar
    TopBG       = Color3.fromRGB(18,  18,  23),    -- Topbar

    -- Cards / Rows
    Row         = Color3.fromRGB(24,  24,  32),    -- Row/card background
    RowHov      = Color3.fromRGB(31,  31,  41),    -- Hover state

    -- Tab States
    TabActBG    = Color3.fromRGB(22,  38,  75),    -- Active tab: blue tint
    TabLine     = Color3.fromRGB(62, 112, 235),    -- Active left bar

    -- Borders
    Border      = Color3.fromRGB(34,  34,  46),    -- Border halus
    Divider     = Color3.fromRGB(28,  28,  38),    -- Garis divider

    -- Accent Blue
    Blue        = Color3.fromRGB(62,  112, 235),   -- Biru utama
    BlueLight   = Color3.fromRGB(100, 150, 255),   -- Biru terang

    -- Toggle
    TglOn       = Color3.fromRGB(62,  112, 235),
    TglOff      = Color3.fromRGB(46,  46,  60),
    TglDot      = Color3.fromRGB(255, 255, 255),

    -- Typography
    Text        = Color3.fromRGB(225, 228, 238),   -- Teks utama
    TextSub     = Color3.fromRGB(125, 128, 148),   -- Deskripsi
    TextDim     = Color3.fromRGB(65,  68,  85),    -- Dimmed

    -- Status / Extras
    Gold        = Color3.fromRGB(255, 187,   0),
    Green       = Color3.fromRGB(52,  211, 153),
    Red         = Color3.fromRGB(240,  70,  70),
    Purple      = Color3.fromRGB(160, 100, 255),
}

_G.Cat.Theme = C

-- ============================================================
-- UTILITIES
-- ============================================================

-- Shorthand tween
local function Tween(obj, props, duration, style)
    TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.18, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    ):Play()
end

-- UICorner helper
local function Corner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius or 6)
    return c
end

-- UIStroke helper
local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke", parent)
    s.Color     = color or C.Border
    s.Thickness = thickness or 1
    return s
end

-- Save settings
local function SaveSettings()
    pcall(function()
        writefile("CatHUB_Config.json", HttpService:JSONEncode(_G.Cat.Settings))
    end)
end

_G.Cat.SaveSettings = SaveSettings

-- ============================================================
-- ROOT SCREENGUI
-- ============================================================

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name           = "CatUI"
Gui.ResetOnSpawn   = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder   = 999

-- ============================================================
-- FLOATING TOGGLE BUTTON
-- ============================================================

local FloatCont = Instance.new("Frame", Gui)
FloatCont.Name                   = "FloatCont"
FloatCont.Size                   = UDim2.new(0, 88, 0, 32)
FloatCont.Position               = UDim2.new(0, 12, 0.5, -16)
FloatCont.BackgroundTransparency = 1
FloatCont.ZIndex                 = 99999

-- Drag handle (invisible, kiri)
local FloatDrag = Instance.new("TextButton", FloatCont)
FloatDrag.Size                   = UDim2.new(0, 28, 1, 0)
FloatDrag.BackgroundTransparency = 1
FloatDrag.Text                   = ""
FloatDrag.AutoButtonColor        = false

-- Tombol utama
local FloatBtn = Instance.new("TextButton", FloatCont)
FloatBtn.Size             = UDim2.new(0, 58, 1, 0)
FloatBtn.Position         = UDim2.new(0, 30, 0, 0)
FloatBtn.BackgroundColor3 = C.Row
FloatBtn.Text             = "CAT"
FloatBtn.TextColor3       = C.Blue
FloatBtn.Font             = Enum.Font.GothamBold
FloatBtn.TextSize         = 12
FloatBtn.BorderSizePixel  = 0
FloatBtn.AutoButtonColor  = false

Corner(FloatBtn, 6)
Stroke(FloatBtn, C.Border, 1)

FloatBtn.MouseEnter:Connect(function() Tween(FloatBtn, {BackgroundColor3 = C.RowHov}, 0.1) end)
FloatBtn.MouseLeave:Connect(function() Tween(FloatBtn, {BackgroundColor3 = C.Row},    0.1) end)

-- ============================================================
-- MAIN WINDOW  (660x450, persis rasio Redz Hub)
-- ============================================================

local Main = Instance.new("Frame", Gui)
Main.Name             = "MainFrame"
Main.Size             = UDim2.new(0, 660, 0, 450)
Main.Position         = UDim2.new(0.5, -330, 0.5, -225)
Main.BackgroundColor3 = C.BG
Main.BorderSizePixel  = 0
Main.ClipsDescendants = true

Corner(Main, 8)
Stroke(Main, C.Border, 1)

-- Toggle visibility
FloatBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ============================================================
-- TOP BAR
-- ============================================================

local Top = Instance.new("Frame", Main)
Top.Name             = "TopBar"
Top.Size             = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = C.TopBG
Top.BorderSizePixel  = 0
Top.ZIndex           = 5

Corner(Top, 8)

-- Fix: kotak sudut bawah topbar
local TopFix = Instance.new("Frame", Top)
TopFix.Size             = UDim2.new(1, 0, 0, 9)
TopFix.Position         = UDim2.new(0, 0, 1, -9)
TopFix.BackgroundColor3 = C.TopBG
TopFix.BorderSizePixel  = 0

-- Garis bawah topbar
local TopLine = Instance.new("Frame", Top)
TopLine.Size             = UDim2.new(1, 0, 0, 1)
TopLine.Position         = UDim2.new(0, 0, 1, -1)
TopLine.BackgroundColor3 = C.Border
TopLine.BorderSizePixel  = 0

-- // Title layout (matching "redz Hub : Blox Fruits" style)
local TitleCont = Instance.new("Frame", Top)
TitleCont.Size                   = UDim2.new(0, 420, 1, 0)
TitleCont.Position               = UDim2.new(0, 14, 0, 0)
TitleCont.BackgroundTransparency = 1

local TitleList = Instance.new("UIListLayout", TitleCont)
TitleList.FillDirection     = Enum.FillDirection.Horizontal
TitleList.VerticalAlignment = Enum.VerticalAlignment.Center
TitleList.Padding           = UDim.new(0, 4)

local function MkTitle(text, color, font, size)
    local l = Instance.new("TextLabel", TitleCont)
    l.Text                   = text
    l.TextColor3             = color
    l.Font                   = font   or Enum.Font.GothamBold
    l.TextSize               = size   or 13
    l.BackgroundTransparency = 1
    l.AutomaticSize          = Enum.AutomaticSize.XY
    return l
end

MkTitle("Cat",          C.Blue,    Enum.Font.GothamBold,   14)
MkTitle("HUB",          C.Text,    Enum.Font.GothamBold,   14)
MkTitle(":",            C.TextDim, Enum.Font.Gotham,       13)
MkTitle("Blox Fruits",  C.Text,    Enum.Font.GothamMedium, 13)
MkTitle("[Freemium]",   C.Gold,    Enum.Font.GothamMedium, 11)

-- // Window control buttons (close & minimize)
local function MkWinBtn(xOffset, text, size)
    local b = Instance.new("TextButton", Top)
    b.Size                   = UDim2.new(0, 36, 0, 38)
    b.Position               = UDim2.new(1, xOffset, 0, 0)
    b.Text                   = text
    b.TextColor3             = C.TextSub
    b.TextSize               = size or 14
    b.Font                   = Enum.Font.GothamBold
    b.BackgroundTransparency = 1
    b.AutoButtonColor        = false
    b.ZIndex                 = 6
    return b
end

local BtnX   = MkWinBtn(-36, "✕", 14)
local BtnMin = MkWinBtn(-72, "–", 16)

-- Hover colors
BtnX.MouseEnter:Connect(function()   Tween(BtnX,   {TextColor3 = C.Red},     0.1) end)
BtnX.MouseLeave:Connect(function()   Tween(BtnX,   {TextColor3 = C.TextSub}, 0.1) end)
BtnMin.MouseEnter:Connect(function() Tween(BtnMin, {TextColor3 = C.Text},    0.1) end)
BtnMin.MouseLeave:Connect(function() Tween(BtnMin, {TextColor3 = C.TextSub}, 0.1) end)

-- Close
BtnX.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Minimize / restore
local isMin  = false
local lastSz = Main.Size

BtnMin.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then lastSz = Main.Size end
    local h = isMin and 38 or lastSz.Y.Offset
    Tween(Main, {Size = UDim2.new(0, Main.Size.X.Offset, 0, h)}, 0.22, Enum.EasingStyle.Quint)
end)

-- ============================================================
-- DRAG & RESIZE  (state table bersih)
-- ============================================================

local DS = { -- Drag State
    main  = {on = false, start = nil, pos  = nil},
    float = {on = false, start = nil, pos  = nil},
    rsz   = {on = false, start = nil, size = nil},
}

-- Main window drag (dari topbar)
Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        DS.main.on    = true
        DS.main.start = i.Position
        DS.main.pos   = Main.Position
    end
end)
Top.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        DS.main.on = false
    end
end)

-- Float button drag
FloatDrag.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        DS.float.on    = true
        DS.float.start = i.Position
        DS.float.pos   = FloatCont.Position
    end
end)
FloatDrag.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        DS.float.on = false
    end
end)

-- Resize handle (pojok kanan bawah)
local ResizeHandle = Instance.new("TextButton", Main)
ResizeHandle.Size                   = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position               = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text                   = "⌟"
ResizeHandle.TextColor3             = C.TextDim
ResizeHandle.TextSize               = 20
ResizeHandle.Font                   = Enum.Font.Gotham
ResizeHandle.ZIndex                 = 99999
ResizeHandle.AutoButtonColor        = false

ResizeHandle.InputBegan:Connect(function(i)
    if (i.UserInputType == Enum.UserInputType.MouseButton1
    or  i.UserInputType == Enum.UserInputType.Touch) and not isMin then
        DS.rsz.on    = true
        DS.rsz.start = UserInput:GetMouseLocation()
        DS.rsz.size  = Main.Size
    end
end)

-- Unified input handler
UserInput.InputChanged:Connect(function(i)
    local isMove = i.UserInputType == Enum.UserInputType.MouseMovement
               or i.UserInputType == Enum.UserInputType.Touch
    if not isMove then return end

    -- Window drag
    if DS.main.on and DS.main.start then
        local d = i.Position - DS.main.start
        Main.Position = UDim2.new(
            DS.main.pos.X.Scale, DS.main.pos.X.Offset + d.X,
            DS.main.pos.Y.Scale, DS.main.pos.Y.Offset + d.Y
        )
    end

    -- Float drag
    if DS.float.on and DS.float.start then
        local d = i.Position - DS.float.start
        FloatCont.Position = UDim2.new(
            DS.float.pos.X.Scale, DS.float.pos.X.Offset + d.X,
            DS.float.pos.Y.Scale, DS.float.pos.Y.Offset + d.Y
        )
    end

    -- Window resize
    if DS.rsz.on and DS.rsz.start then
        local cur = UserInput:GetMouseLocation()
        local d   = cur - DS.rsz.start
        Main.Size = UDim2.new(0,
            math.clamp(DS.rsz.size.X.Offset + d.X, 420, 950),
            0,
            math.clamp(DS.rsz.size.Y.Offset + d.Y, 280, 750)
        )
        lastSz = Main.Size
    end
end)

-- Stop semua drag/resize
UserInput.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        DS.main.on  = false
        DS.float.on = false
        DS.rsz.on   = false
    end
end)

-- ============================================================
-- BODY  (di bawah topbar)
-- ============================================================

local Body = Instance.new("Frame", Main)
Body.Name                   = "Body"
Body.Size                   = UDim2.new(1, 0, 1, -38)
Body.Position               = UDim2.new(0, 0, 0, 38)
Body.BackgroundTransparency = 1

-- ============================================================
-- SIDEBAR  (175px lebar, persis Redz Hub)
-- ============================================================

local Side = Instance.new("Frame", Body)
Side.Name             = "Sidebar"
Side.Size             = UDim2.new(0, 175, 1, 0)
Side.BackgroundColor3 = C.SideBG
Side.BorderSizePixel  = 0

-- Garis pembatas kanan sidebar
local SideLine = Instance.new("Frame", Side)
SideLine.Size             = UDim2.new(0, 1, 1, 0)
SideLine.Position         = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3 = C.Border
SideLine.BorderSizePixel  = 0

-- ScrollingFrame untuk list tab
local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Size                   = UDim2.new(1, 0, 1, 0)
SideScroll.BackgroundTransparency = 1
SideScroll.ScrollBarThickness     = 0
SideScroll.BorderSizePixel        = 0
SideScroll.CanvasSize             = UDim2.new(0, 0, 0, 0)

local SideList = Instance.new("UIListLayout", SideScroll)
SideList.Padding   = UDim.new(0, 2)
SideList.SortOrder = Enum.SortOrder.LayoutOrder

local SidePadding = Instance.new("UIPadding", SideScroll)
SidePadding.PaddingLeft   = UDim.new(0, 8)
SidePadding.PaddingRight  = UDim.new(0, 8)
SidePadding.PaddingTop    = UDim.new(0, 10)
SidePadding.PaddingBottom = UDim.new(0, 10)

-- Auto canvas size
SideList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SideScroll.CanvasSize = UDim2.new(0, 0, 0, SideList.AbsoluteContentSize.Y + 20)
end)

-- ============================================================
-- CONTENT AREA  (kanan sidebar)
-- ============================================================

local ContentArea = Instance.new("Frame", Body)
ContentArea.Name                   = "ContentArea"
ContentArea.Size                   = UDim2.new(1, -175, 1, 0)
ContentArea.Position               = UDim2.new(0, 175, 0, 0)
ContentArea.BackgroundTransparency = 1

-- ============================================================
-- TAB CONFIG  (10 tab sesuai Redz Hub)
-- ============================================================

local TAB_CONFIG = {
    {name = "Farm",        icon = "⚔",  order = 1},
    {name = "Sea",         icon = "≈",  order = 2},
    {name = "Quests",      icon = "✦",  order = 3},
    {name = "Raid/Fruits", icon = "◎",  order = 4},
    {name = "Stats",       icon = "≡",  order = 5},
    {name = "Teleport",    icon = "◇",  order = 6},
    {name = "Visual",      icon = "●",  order = 7},
    {name = "Shop",        icon = "◆",  order = 8},
    {name = "Misc",        icon = "⚙",  order = 9},
    {name = "Status",      icon = "◈",  order = 10},
}

-- State
local Pages    = {}   -- {name → {Btn, Page, Ind, Icon, Lbl}}
local AllItems = {}   -- untuk search

-- ============================================================
-- FUNCTION: CreateTab
-- ============================================================

local function CreateTab(name, icon, isFirst)
    if Pages[name] then return Pages[name].Page end

    -- Cari order dari config
    local order = 99
    for _, cfg in ipairs(TAB_CONFIG) do
        if cfg.name == name then order = cfg.order break end
    end

    -- ── Sidebar Button ──────────────────────────────────────

    local Btn = Instance.new("TextButton", SideScroll)
    Btn.Name             = name .. "_Tab"
    Btn.LayoutOrder      = order
    Btn.Size             = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = isFirst and C.TabActBG or C.SideBG
    Btn.Text             = ""
    Btn.BorderSizePixel  = 0
    Btn.AutoButtonColor  = false

    Corner(Btn, 6)

    -- Left indicator (biru, hanya muncul saat aktif)
    local Ind = Instance.new("Frame", Btn)
    Ind.Name             = "Ind"
    Ind.Size             = UDim2.new(0, 3, 0, 18)
    Ind.Position         = UDim2.new(0, 0, 0.5, -9)
    Ind.BackgroundColor3 = C.TabLine
    Ind.BorderSizePixel  = 0
    Ind.Visible          = isFirst or false

    Corner(Ind, 3)

    -- Icon
    local IconLbl = Instance.new("TextLabel", Btn)
    IconLbl.Size                   = UDim2.new(0, 28, 1, 0)
    IconLbl.Position               = UDim2.new(0, 10, 0, 0)
    IconLbl.Text                   = icon or "●"
    IconLbl.TextSize               = 13
    IconLbl.TextColor3             = isFirst and C.Blue or C.TextDim
    IconLbl.Font                   = Enum.Font.GothamBold
    IconLbl.BackgroundTransparency = 1

    -- Label
    local TabLbl = Instance.new("TextLabel", Btn)
    TabLbl.Size                   = UDim2.new(1, -44, 1, 0)
    TabLbl.Position               = UDim2.new(0, 38, 0, 0)
    TabLbl.Text                   = name
    TabLbl.TextColor3             = isFirst and C.Text or C.TextSub
    TabLbl.Font                   = Enum.Font.GothamMedium
    TabLbl.TextSize               = 12
    TabLbl.TextXAlignment         = Enum.TextXAlignment.Left
    TabLbl.BackgroundTransparency = 1

    -- Hover effect
    Btn.MouseEnter:Connect(function()
        if Pages[name] and Pages[name].Page.Visible then return end
        Tween(Btn, {BackgroundColor3 = Color3.fromRGB(26, 28, 38)}, 0.1)
    end)
    Btn.MouseLeave:Connect(function()
        if Pages[name] and Pages[name].Page.Visible then return end
        Tween(Btn, {BackgroundColor3 = C.SideBG}, 0.1)
    end)

    -- ── Content Page ────────────────────────────────────────

    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Name                   = name .. "_Page"
    Page.Size                   = UDim2.new(1, -16, 1, -12)
    Page.Position               = UDim2.new(0, 8, 0, 6)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness     = 2
    Page.ScrollBarImageColor3   = C.Border
    Page.Visible                = isFirst or false
    Page.BorderSizePixel        = 0
    Page.CanvasSize             = UDim2.new(0, 0, 0, 0)

    local PLayout = Instance.new("UIListLayout", Page)
    PLayout.Padding   = UDim.new(0, 4)
    PLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local PPad = Instance.new("UIPadding", Page)
    PPad.PaddingTop    = UDim.new(0, 4)
    PPad.PaddingLeft   = UDim.new(0, 2)
    PPad.PaddingRight  = UDim.new(0, 6)
    PPad.PaddingBottom = UDim.new(0, 14)

    -- Auto canvas
    PLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PLayout.AbsoluteContentSize.Y + 22)
    end)

    -- ── Tab Switch Logic ─────────────────────────────────────

    Btn.MouseButton1Click:Connect(function()
        if Pages[name] and Pages[name].Page.Visible then return end

        for n, d in pairs(Pages) do
            local act = (n == name)

            d.Page.Visible = act
            d.Ind.Visible  = act

            Tween(d.Btn,  {BackgroundColor3 = act and C.TabActBG or C.SideBG}, 0.15)
            Tween(d.Icon, {TextColor3       = act and C.Blue     or C.TextDim}, 0.15)
            Tween(d.Lbl,  {TextColor3       = act and C.Text     or C.TextSub}, 0.15)
        end
    end)

    -- Register
    Pages[name] = {
        Btn  = Btn,
        Page = Page,
        Ind  = Ind,
        Icon = IconLbl,
        Lbl  = TabLbl,
    }

    return Page
end

-- ============================================================
-- COMPONENTS
-- ============================================================

-- // Section Header  →  Plain white bold text (persis Redz Hub)
local function CreateSection(parent, text)
    local F = Instance.new("Frame", parent)
    F.Name                   = "Sec_" .. text
    F.LayoutOrder            = #parent:GetChildren()
    F.Size                   = UDim2.new(1, 0, 0, 34)
    F.BackgroundTransparency = 1

    local L = Instance.new("TextLabel", F)
    L.Size                   = UDim2.new(1, -8, 1, 0)
    L.Position               = UDim2.new(0, 4, 0, 6)
    L.Text                   = text
    L.TextColor3             = C.Text
    L.Font                   = Enum.Font.GothamBold
    L.TextSize               = 14
    L.TextXAlignment         = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1

    return L
end

-- // Dropdown Row  →  Title + "∧" + VALUE (persis Farm Tool → Sword)
local function CreateDropdown(parent, title, desc, options, defaultIdx, callback)
    local h   = desc and 50 or 36
    local idx = defaultIdx or 1

    local Row = Instance.new("TextButton", parent)
    Row.Name             = title .. "_DD"
    Row.LayoutOrder      = #parent:GetChildren()
    Row.Size             = UDim2.new(1, 0, 0, h)
    Row.BackgroundColor3 = C.Row
    Row.BorderSizePixel  = 0
    Row.Text             = ""
    Row.AutoButtonColor  = false

    Corner(Row, 6)
    Stroke(Row, C.Border, 1)

    -- Title (kiri)
    local TLbl = Instance.new("TextLabel", Row)
    TLbl.Size                   = UDim2.new(0.52, 0, 0, 18)
    TLbl.Position               = UDim2.new(0, 12, 0, desc and 7 or 9)
    TLbl.Text                   = title
    TLbl.TextColor3             = C.Text
    TLbl.Font                   = Enum.Font.GothamMedium
    TLbl.TextSize               = 12
    TLbl.TextXAlignment         = Enum.TextXAlignment.Left
    TLbl.BackgroundTransparency = 1

    -- Deskripsi (optional)
    if desc then
        local DLbl = Instance.new("TextLabel", Row)
        DLbl.Size                   = UDim2.new(0.52, 0, 0, 14)
        DLbl.Position               = UDim2.new(0, 12, 0, 28)
        DLbl.Text                   = desc
        DLbl.TextColor3             = C.TextSub
        DLbl.Font                   = Enum.Font.Gotham
        DLbl.TextSize               = 10
        DLbl.TextXAlignment         = Enum.TextXAlignment.Left
        DLbl.BackgroundTransparency = 1
    end

    -- Chevron (∧)
    local Chev = Instance.new("TextLabel", Row)
    Chev.Size                   = UDim2.new(0, 22, 1, 0)
    Chev.Position               = UDim2.new(0.54, 0, 0, 0)
    Chev.Text                   = "∧"
    Chev.TextColor3             = C.TextSub
    Chev.TextSize               = 11
    Chev.Font                   = Enum.Font.GothamBold
    Chev.BackgroundTransparency = 1

    -- Value display (kanan, bold white → persis "Sword", "Large")
    local ValLbl = Instance.new("TextLabel", Row)
    ValLbl.Size                   = UDim2.new(0.4, -14, 1, 0)
    ValLbl.Position               = UDim2.new(0.6, 0, 0, 0)
    ValLbl.Text                   = options[idx] or ""
    ValLbl.TextColor3             = C.Text
    ValLbl.Font                   = Enum.Font.GothamBold
    ValLbl.TextSize               = 13
    ValLbl.TextXAlignment         = Enum.TextXAlignment.Right
    ValLbl.BackgroundTransparency = 1

    -- Hover
    Row.MouseEnter:Connect(function() Tween(Row, {BackgroundColor3 = C.RowHov}, 0.1) end)
    Row.MouseLeave:Connect(function() Tween(Row, {BackgroundColor3 = C.Row},    0.1) end)

    -- Click = cycle options
    Row.MouseButton1Click:Connect(function()
        idx = (idx % #options) + 1
        ValLbl.Text = options[idx]
        if callback then callback(options[idx], idx) end
        SaveSettings()
    end)

    table.insert(AllItems, {Btn = Row, Label = TLbl})
    return ValLbl -- return label biar bisa diupdate manual
end

-- // Toggle Switch  →  Dark pill, blue when ON (persis Redz Hub)
local function CreateToggle(parent, title, desc, defaultState, callback)
    local h     = desc and 50 or 36
    local state = defaultState or false

    local Row = Instance.new("TextButton", parent)
    Row.Name             = title .. "_Tgl"
    Row.LayoutOrder      = #parent:GetChildren()
    Row.Size             = UDim2.new(1, 0, 0, h)
    Row.BackgroundColor3 = C.Row
    Row.BorderSizePixel  = 0
    Row.Text             = ""
    Row.AutoButtonColor  = false

    Corner(Row, 6)
    Stroke(Row, C.Border, 1)

    -- Hover
    Row.MouseEnter:Connect(function() Tween(Row, {BackgroundColor3 = C.RowHov}, 0.1) end)
    Row.MouseLeave:Connect(function() Tween(Row, {BackgroundColor3 = C.Row},    0.1) end)

    -- Title
    local TLbl = Instance.new("TextLabel", Row)
    TLbl.Size                   = UDim2.new(1, -68, 0, 18)
    TLbl.Position               = UDim2.new(0, 12, 0, desc and 7 or 9)
    TLbl.Text                   = title
    TLbl.TextColor3             = C.Text
    TLbl.Font                   = Enum.Font.GothamMedium
    TLbl.TextSize               = 12
    TLbl.TextXAlignment         = Enum.TextXAlignment.Left
    TLbl.BackgroundTransparency = 1

    -- Deskripsi
    if desc then
        local DLbl = Instance.new("TextLabel", Row)
        DLbl.Size                   = UDim2.new(1, -68, 0, 14)
        DLbl.Position               = UDim2.new(0, 12, 0, 27)
        DLbl.Text                   = desc
        DLbl.TextColor3             = C.TextSub
        DLbl.Font                   = Enum.Font.Gotham
        DLbl.TextSize               = 10
        DLbl.TextXAlignment         = Enum.TextXAlignment.Left
        DLbl.BackgroundTransparency = 1
    end

    -- Toggle track (pill shape)
    local Track = Instance.new("Frame", Row)
    Track.Size             = UDim2.new(0, 40, 0, 22)
    Track.Position         = UDim2.new(1, -52, 0.5, -11)
    Track.BackgroundColor3 = state and C.TglOn or C.TglOff
    Track.BorderSizePixel  = 0

    Corner(Track, 11)

    -- Toggle dot (lingkaran putih)
    local Dot = Instance.new("Frame", Track)
    Dot.Size             = UDim2.new(0, 18, 0, 18)
    Dot.Position         = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Dot.BackgroundColor3 = C.TglDot
    Dot.BorderSizePixel  = 0

    Corner(Dot, 9)

    -- Shadow dot (efek depth)
    do
        local ds = Instance.new("UIStroke", Dot)
        ds.Color        = Color3.fromRGB(0, 0, 0)
        ds.Thickness    = 0.8
        ds.Transparency = 0.75
    end

    -- Click logic
    Row.MouseButton1Click:Connect(function()
        state = not state

        Tween(Track, {BackgroundColor3 = state and C.TglOn or C.TglOff}, 0.2)
        Tween(Dot,   {
            Position = state
                and UDim2.new(1, -20, 0.5, -9)
                or  UDim2.new(0,   2, 0.5, -9)
        }, 0.2)

        if callback then callback(state) end
        SaveSettings()
    end)

    table.insert(AllItems, {Btn = Row, Label = TLbl})
    return Row
end

-- // Button Row  →  Title + "›" arrow kanan (persis "Update Boss List >")
local function CreateButton(parent, title, desc, callback)
    local h = desc and 50 or 36

    local Row = Instance.new("TextButton", parent)
    Row.Name             = title .. "_Btn"
    Row.LayoutOrder      = #parent:GetChildren()
    Row.Size             = UDim2.new(1, 0, 0, h)
    Row.BackgroundColor3 = C.Row
    Row.BorderSizePixel  = 0
    Row.Text             = ""
    Row.AutoButtonColor  = false

    Corner(Row, 6)
    Stroke(Row, C.Border, 1)

    Row.MouseEnter:Connect(function() Tween(Row, {BackgroundColor3 = C.RowHov}, 0.1) end)
    Row.MouseLeave:Connect(function() Tween(Row, {BackgroundColor3 = C.Row},    0.1) end)

    -- Title
    local TLbl = Instance.new("TextLabel", Row)
    TLbl.Size                   = UDim2.new(1, -48, 0, 18)
    TLbl.Position               = UDim2.new(0, 12, 0, desc and 7 or 9)
    TLbl.Text                   = title
    TLbl.TextColor3             = C.Text
    TLbl.Font                   = Enum.Font.GothamMedium
    TLbl.TextSize               = 12
    TLbl.TextXAlignment         = Enum.TextXAlignment.Left
    TLbl.BackgroundTransparency = 1

    -- Deskripsi
    if desc then
        local DLbl = Instance.new("TextLabel", Row)
        DLbl.Size                   = UDim2.new(1, -48, 0, 14)
        DLbl.Position               = UDim2.new(0, 12, 0, 27)
        DLbl.Text                   = desc
        DLbl.TextColor3             = C.TextSub
        DLbl.Font                   = Enum.Font.Gotham
        DLbl.TextSize               = 10
        DLbl.TextXAlignment         = Enum.TextXAlignment.Left
        DLbl.BackgroundTransparency = 1
    end

    -- Arrow "›" (biru)
    local Arrow = Instance.new("TextLabel", Row)
    Arrow.Size                   = UDim2.new(0, 28, 1, 0)
    Arrow.Position               = UDim2.new(1, -34, 0, 0)
    Arrow.Text                   = "›"
    Arrow.TextColor3             = C.Blue
    Arrow.TextSize               = 24
    Arrow.Font                   = Enum.Font.GothamBold
    Arrow.BackgroundTransparency = 1

    Row.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    table.insert(AllItems, {Btn = Row, Label = TLbl})
    return Row
end

-- // Slider Component  →  Value display + draggable track
local function CreateSlider(parent, title, desc, min, max, default, callback)
    local val = math.clamp(default or min, min, max)
    local h   = desc and 62 or 52

    local Row = Instance.new("Frame", parent)
    Row.Name             = title .. "_Slider"
    Row.LayoutOrder      = #parent:GetChildren()
    Row.Size             = UDim2.new(1, 0, 0, h)
    Row.BackgroundColor3 = C.Row
    Row.BorderSizePixel  = 0

    Corner(Row, 6)
    Stroke(Row, C.Border, 1)

    -- Title
    local TLbl = Instance.new("TextLabel", Row)
    TLbl.Size                   = UDim2.new(0.7, 0, 0, 18)
    TLbl.Position               = UDim2.new(0, 12, 0, 8)
    TLbl.Text                   = title
    TLbl.TextColor3             = C.Text
    TLbl.Font                   = Enum.Font.GothamMedium
    TLbl.TextSize               = 12
    TLbl.TextXAlignment         = Enum.TextXAlignment.Left
    TLbl.BackgroundTransparency = 1

    -- Value (kanan, biru)
    local ValLbl = Instance.new("TextLabel", Row)
    ValLbl.Size                   = UDim2.new(0.28, -10, 0, 18)
    ValLbl.Position               = UDim2.new(0.72, 0, 0, 8)
    ValLbl.Text                   = tostring(val)
    ValLbl.TextColor3             = C.Blue
    ValLbl.Font                   = Enum.Font.GothamBold
    ValLbl.TextSize               = 12
    ValLbl.TextXAlignment         = Enum.TextXAlignment.Right
    ValLbl.BackgroundTransparency = 1

    -- Deskripsi
    local trackY = 28
    if desc then
        local DLbl = Instance.new("TextLabel", Row)
        DLbl.Size                   = UDim2.new(1, -24, 0, 12)
        DLbl.Position               = UDim2.new(0, 12, 0, 26)
        DLbl.Text                   = desc
        DLbl.TextColor3             = C.TextSub
        DLbl.Font                   = Enum.Font.Gotham
        DLbl.TextSize               = 10
        DLbl.TextXAlignment         = Enum.TextXAlignment.Left
        DLbl.BackgroundTransparency = 1
        trackY = 40
    end

    -- Slider track
    local Track = Instance.new("Frame", Row)
    Track.Size             = UDim2.new(1, -24, 0, 4)
    Track.Position         = UDim2.new(0, 12, 0, trackY)
    Track.BackgroundColor3 = C.TglOff
    Track.BorderSizePixel  = 0
    Corner(Track, 2)

    local pct = (val - min) / (max - min)

    -- Fill
    local Fill = Instance.new("Frame", Track)
    Fill.Size             = UDim2.new(pct, 0, 1, 0)
    Fill.BackgroundColor3 = C.Blue
    Fill.BorderSizePixel  = 0
    Corner(Fill, 2)

    -- Knob
    local Knob = Instance.new("Frame", Track)
    Knob.Size             = UDim2.new(0, 12, 0, 12)
    Knob.Position         = UDim2.new(pct, -6, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel  = 0
    Knob.ZIndex           = 3
    Corner(Knob, 6)

    -- Drag interaction
    local dragging = false

    local function Update(mouseX)
        local abs = Track.AbsolutePosition
        local sz  = Track.AbsoluteSize
        local p   = math.clamp((mouseX - abs.X) / sz.X, 0, 1)
        val = math.floor(min + (max - min) * p)
        pct = (val - min) / (max - min)

        Fill.Size     = UDim2.new(pct, 0, 1, 0)
        Knob.Position = UDim2.new(pct, -6, 0.5, -6)
        ValLbl.Text   = tostring(val)

        if callback then callback(val) end
    end

    Track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(i.Position.X)
        end
    end)

    UserInput.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            Update(i.Position.X)
        end
    end)

    UserInput.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    table.insert(AllItems, {Btn = Row, Label = TLbl})
    return Row
end

-- // Info Label Card
local function CreateLabel(parent, text, desc)
    local h = desc and 46 or 32

    local F = Instance.new("Frame", parent)
    F.Name             = "Lbl_" .. text
    F.LayoutOrder      = #parent:GetChildren()
    F.Size             = UDim2.new(1, 0, 0, h)
    F.BackgroundColor3 = C.Row
    F.BorderSizePixel  = 0

    Corner(F, 6)
    Stroke(F, C.Border, 1)

    local L = Instance.new("TextLabel", F)
    L.Size                   = UDim2.new(1, -20, 0, 18)
    L.Position               = UDim2.new(0, 12, 0, desc and 4 or 7)
    L.Text                   = text
    L.TextColor3             = C.Text
    L.Font                   = Enum.Font.GothamMedium
    L.TextSize               = 12
    L.TextXAlignment         = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1

    if desc then
        local D = Instance.new("TextLabel", F)
        D.Size                   = UDim2.new(1, -20, 0, 14)
        D.Position               = UDim2.new(0, 12, 0, 24)
        D.Text                   = desc
        D.TextColor3             = C.TextSub
        D.Font                   = Enum.Font.Gotham
        D.TextSize               = 10
        D.TextXAlignment         = Enum.TextXAlignment.Left
        D.BackgroundTransparency = 1
    end

    return L
end

-- ============================================================
-- SEARCH ENGINE
-- ============================================================

-- Tambah search box di atas sidebar (opsional, bisa di-comment)
local SearchFrame = Instance.new("Frame", Side)
SearchFrame.Name             = "SearchFrame"
SearchFrame.Size             = UDim2.new(1, -16, 0, 28)
SearchFrame.Position         = UDim2.new(0, 8, 1, -38)
SearchFrame.BackgroundColor3 = C.Row
SearchFrame.BorderSizePixel  = 0

Corner(SearchFrame, 6)
Stroke(SearchFrame, C.Border, 1)

local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Size                   = UDim2.new(1, -12, 1, 0)
SearchBox.Position               = UDim2.new(0, 6, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text                   = ""
SearchBox.PlaceholderText        = "Search..."
SearchBox.TextColor3             = C.Text
SearchBox.PlaceholderColor3      = C.TextDim
SearchBox.Font                   = Enum.Font.GothamMedium
SearchBox.TextSize               = 11
SearchBox.TextXAlignment         = Enum.TextXAlignment.Left

-- Reduce sidebar scroll area by search height
SideScroll.Size     = UDim2.new(1, 0, 1, -40)
SideScroll.Position = UDim2.new(0, 0, 0, 0)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(SearchBox.Text)
    for _, item in ipairs(AllItems) do
        local lbl   = string.lower(item.Label.Text)
        local empty = (q == "")
        local found = string.find(lbl, q, 1, true) ~= nil
        item.Btn.Visible = empty or found
    end
end)

-- ============================================================
-- INIT: BUAT SEMUA TAB
-- ============================================================

for i, cfg in ipairs(TAB_CONFIG) do
    CreateTab(cfg.name, cfg.icon, i == 1)
end

-- ============================================================
-- CONTOH ISI CONTENT  (hapus/ganti di modul masing-masing)
-- ============================================================

local FarmPage   = Pages["Farm"].Page
local SeaPage    = Pages["Sea"].Page
local QuestPage  = Pages["Quests"].Page
local RaidPage   = Pages["Raid/Fruits"].Page
local StatPage   = Pages["Stats"].Page
local TpPage     = Pages["Teleport"].Page
local VisualPage = Pages["Visual"].Page
local ShopPage   = Pages["Shop"].Page
local MiscPage   = Pages["Misc"].Page
local StatusPage = Pages["Status"].Page

-- // FARM
CreateDropdown(FarmPage, "Farm Tool",  "Choose your farming weapon",   {"Sword", "Gun", "Fruit", "Melee"}, 1)
CreateDropdown(FarmPage, "UI Scale",   "Adjust the user interface size",{"Small", "Medium", "Large"}, 2)

CreateSection(FarmPage, "Main Farm")
CreateToggle(FarmPage, "Auto Farm Level",   "Farm level on nearest mob",   false)
CreateToggle(FarmPage, "Auto Farm Nearest", "Targets the nearest enemy",   false)
CreateToggle(FarmPage, "Auto Factory",      nil,                           false)
CreateToggle(FarmPage, "Auto Pirates Sea",  "Finish pirate raid at sea",   false)

CreateSection(FarmPage, "Kill Player")
CreateButton(FarmPage, "Get Quest Elite Players", "Find elite quest targets")
CreateToggle(FarmPage, "Auto Kill Player Quest",  nil,                     false)
CreateToggle(FarmPage, "Auto Safe Mode",          "Avoid banned zones",    false)

CreateSection(FarmPage, "Ectoplasm")
CreateToggle(FarmPage, "Auto Farm Ectoplasm",  "Farm ectoplasm drops",    false)
CreateToggle(FarmPage, "Auto Chest < Tween >", "Auto loot nearby chests", false)

CreateSection(FarmPage, "Bosses")
CreateButton(FarmPage, "Update Boss List",   "Refresh boss locations")
CreateToggle(FarmPage, "Auto Boss Farm",     "Auto kill world bosses",    false)
CreateToggle(FarmPage, "Auto Raid Boss",     nil,                         false)

-- // SEA
CreateDropdown(SeaPage, "Sea Area", "Select your current sea", {"First Sea", "Second Sea", "Third Sea"}, 1)

CreateSection(SeaPage, "Navigation")
CreateToggle(SeaPage, "Auto Sail",       "Automatically sail your ship", false)
CreateToggle(SeaPage, "Avoid Sea Beast", "Steer away from sea beasts",  false)
CreateToggle(SeaPage, "Anti Drown",      "Prevent character from drowning", false)

CreateSection(SeaPage, "Sea Events")
CreateToggle(SeaPage, "Auto Pirate Raid", "Complete pirate raids auto",  false)
CreateToggle(SeaPage, "Auto Sea Event",   "Join and finish sea events",  false)
CreateButton(SeaPage, "Teleport to Ship", "Fast-travel to your ship")

CreateSection(SeaPage, "Chest")
CreateToggle(SeaPage, "Auto Chest Farm", "Auto loot sea chests",         false)
CreateButton(SeaPage, "Collect All Chests", "Collect chests in radius")

-- // QUESTS
CreateSection(QuestPage, "Auto Quest")
CreateToggle(QuestPage, "Auto Accept Quest", "Auto-accept available quests", false)
CreateToggle(QuestPage, "Auto Complete",     "Auto-complete quest goals",    false)
CreateToggle(QuestPage, "Skip Cutscenes",    nil,                            false)

CreateSection(QuestPage, "Items")
CreateToggle(QuestPage, "Auto Loot",         "Collect nearby items auto",    false)
CreateToggle(QuestPage, "Item ESP",          "See items through walls",      false)
CreateButton(QuestPage, "Open Item Tracker", "Track current quest items")

-- // RAID / FRUITS
CreateDropdown(RaidPage, "Target Fruit", "Select fruit to snipe",
    {"Any Fruit", "Dragon", "Leopard", "Kitsune", "Spirit", "Dough", "Shadow"}, 1)

CreateSection(RaidPage, "Fruit Finder")
CreateToggle(RaidPage, "Fruit ESP",         "Show fruit spawn locations",   false)
CreateToggle(RaidPage, "Auto Snipe Fruit",  "Auto grab spawned fruits",     false)
CreateToggle(RaidPage, "Notify On Spawn",   "Alert when fruit spawns",      false)

CreateSection(RaidPage, "Movement System")
CreateToggle(RaidPage, "Tween to Fruits",   "Smooth fly movement to fruit", false)
CreateToggle(RaidPage, "TP Fruits",         "Instant teleport to target",   false)

CreateSection(RaidPage, "Inventory Management")
CreateToggle(RaidPage, "Auto Store Fruits", "Otomatis simpan buah ke tas",  false)
CreateToggle(RaidPage, "Auto Eat Fruit",    nil,                            false)
CreateToggle(RaidPage, "Auto Hop Server",   "Hop if no fruit spawns",       false)

-- // STATS
CreateSection(StatPage, "Player Stats")
CreateLabel(StatPage, "Level",   tostring((_G.Cat.Player and _G.Cat.Player.leaderstats and _G.Cat.Player.leaderstats.Level.Value) or "Unknown"))
CreateLabel(StatPage, "Mastery", "Check in game")
CreateLabel(StatPage, "Beli",    "Check in game")

CreateSection(StatPage, "Session")
CreateLabel(StatPage, "Time Played",   "Calculating...")
CreateLabel(StatPage, "EXP per Hour",  "Calculating...")
CreateLabel(StatPage, "Kills",         "0")

-- // TELEPORT
CreateSection(TpPage, "Quick Teleport")
CreateButton(TpPage, "Teleport to Spawn",   "Go to world spawn point")
CreateButton(TpPage, "Teleport to Quest NPC","Go to your quest NPC")
CreateButton(TpPage, "Teleport to Boss",    "Go to nearest world boss")
CreateButton(TpPage, "Teleport to Ship",    "Go to your ship")

CreateSection(TpPage, "Waypoints")
CreateButton(TpPage, "Add Waypoint",        "Save current position")
CreateButton(TpPage, "Manage Waypoints",    "Edit saved locations")

-- // VISUAL
CreateSection(VisualPage, "ESP Options")
CreateToggle(VisualPage, "Player ESP",      "Show all players location",    false)
CreateToggle(VisualPage, "Mob ESP",         "Show nearby mob locations",    false)
CreateToggle(VisualPage, "Fruit ESP",       "Show fruit spawn points",      false)
CreateToggle(VisualPage, "Boss ESP",        nil,                            false)

CreateSection(VisualPage, "Character")
CreateToggle(VisualPage, "No Clip",         "Walk through walls",           false)
CreateToggle(VisualPage, "Full Bright",     "Remove environment darkness",  false)

CreateSection(VisualPage, "Camera")
CreateSlider(VisualPage, "FOV",             "Field of view",                70, 120, 70)
CreateSlider(VisualPage, "Camera Distance", "Third person zoom",            10, 50,  20)

-- // SHOP
CreateSection(ShopPage, "Auto Buy")
CreateToggle(ShopPage, "Auto Buy Mastery",  "Auto buy mastery resets",      false)
CreateToggle(ShopPage, "Auto Buy Boat",     nil,                            false)

CreateSection(ShopPage, "Gamepass")
CreateButton(ShopPage, "Open Gamepass Shop","Opens Roblox gamepass shop")
CreateButton(ShopPage, "Check Owned",       "List your owned gamepasses")

-- // MISC
CreateSection(MiscPage, "Quality of Life")
CreateToggle(MiscPage, "Anti AFK",          "Prevent auto-kick (moves char)",   true)
CreateToggle(MiscPage, "Auto Rejoin",       "Rejoin on disconnect",             false)
CreateToggle(MiscPage, "FPS Boost",         "Remove particles & shadows",       false)

CreateSection(MiscPage, "Character")
CreateToggle(MiscPage, "Infinite Jump",     nil,                                false)
CreateToggle(MiscPage, "Fly Mode",          "Enable free flight",               false)
CreateSlider(MiscPage, "Walk Speed",        "Default: 16",                      16, 500, 16)
CreateSlider(MiscPage, "Jump Power",        "Default: 50",                      50, 500, 50)

CreateSection(MiscPage, "Server Utilities")
CreateButton(MiscPage, "Rejoin Server",     "Fast server rejoin")
CreateButton(MiscPage, "Copy Server ID",    "Copy current server ID")
CreateButton(MiscPage, "Find Private",      "Search empty private servers")

-- // STATUS
CreateLabel(StatusPage, "CatHUB v3.0  ·  Blox Fruits", "Freemium Edition  ·  2025")

CreateSection(StatusPage, "Player Info")
CreateLabel(StatusPage,
    "Username: " .. (_G.Cat.Player and _G.Cat.Player.Name or "Unknown"),
    "Your current account name"
)
CreateLabel(StatusPage, "Framework",  "CatHUB v3.0 · Redz Hub Style")
CreateLabel(StatusPage, "Status",     "Connected · Running")

CreateSection(StatusPage, "Links & Support")
CreateButton(StatusPage, "Join Discord",     "Get support & latest updates")
CreateButton(StatusPage, "GitHub / Source",  "View source code")
CreateButton(StatusPage, "Check for Update", "Verify latest version")

-- ============================================================
-- GLOBAL EXPORT  →  _G.Cat.UI.CreateToggle(...) dll
-- ============================================================

_G.Cat.UI = {
    -- Tab builder
    CreateTab      = CreateTab,

    -- Component builders
    CreateSection  = CreateSection,
    CreateDropdown = CreateDropdown,
    CreateToggle   = CreateToggle,
    CreateButton   = CreateButton,
    CreateSlider   = CreateSlider,
    CreateLabel    = CreateLabel,

    -- Data & helpers
    Pages          = Pages,
    Theme          = C,
    Tween          = Tween,
    SaveSettings   = SaveSettings,
}

warn("[CatHUB v3.0] Loaded · " .. #TAB_CONFIG .. " tabs · Redz Hub accurate style")