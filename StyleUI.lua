-- [[ ==========================================
--      CATHUB PREMIUM · REDESIGNED UI v2.0
--      Inspired by Redz Hub aesthetic
--    ========================================== ]]

-- // Services
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput    = game:GetService("UserInputService")
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")

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
-- 3. THEME · Dark Premium (Redz-inspired)
-- ==========================================

local T = {
    -- Base Backgrounds
    BG0     = Color3.fromRGB(8,   8,  11),   -- Window background
    BG1     = Color3.fromRGB(13,  13, 17),   -- Sidebar
    BG2     = Color3.fromRGB(18,  18, 24),   -- Cards
    BG3     = Color3.fromRGB(24,  24, 32),   -- Card hover
    TopBG   = Color3.fromRGB(11,  11, 15),   -- Topbar

    -- Borders
    Line    = Color3.fromRGB(32,  32, 44),   -- Subtle border
    LineAct = Color3.fromRGB(55, 120, 255),  -- Active border

    -- Text
    Text    = Color3.fromRGB(235, 235, 240), -- Primary text
    TextSub = Color3.fromRGB(120, 120, 138), -- Secondary text
    TextDim = Color3.fromRGB(65,  65,  80),  -- Dimmed text

    -- Accent / Blue
    Accent  = Color3.fromRGB(55,  120, 255), -- Main accent blue
    AccentD = Color3.fromRGB(35,   90, 210), -- Darker blue

    -- Toggle
    TglOn   = Color3.fromRGB(55,  120, 255),
    TglOff  = Color3.fromRGB(32,  32,  44),
    TglDot  = Color3.fromRGB(255, 255, 255),

    -- Status Colors
    Gold    = Color3.fromRGB(255, 187,  0),
    Green   = Color3.fromRGB(52,  211, 153),
    Red     = Color3.fromRGB(239,  68,  68),
    Purple  = Color3.fromRGB(155, 100, 255),
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
-- 5. FLOATING BUTTON (Mobile / Toggle)
-- ==========================================

-- Container (draggable area + button)
local FloatCont = Instance.new("Frame", Gui)
FloatCont.Name                   = "FloatContainer"
FloatCont.Size                   = UDim2.new(0, 80, 0, 36)
FloatCont.Position               = UDim2.new(0, 16, 0.5, -18)
FloatCont.BackgroundTransparency = 1
FloatCont.ZIndex                 = 99999

-- Visible button
local FloatBtn = Instance.new("TextButton", FloatCont)
FloatBtn.Size             = UDim2.new(0, 52, 1, 0)
FloatBtn.Position         = UDim2.new(0, 28, 0, 0)
FloatBtn.BackgroundColor3 = T.BG2
FloatBtn.Text             = "CAT"
FloatBtn.TextColor3       = T.Accent
FloatBtn.Font             = Enum.Font.GothamBold
FloatBtn.TextSize         = 13
FloatBtn.BorderSizePixel  = 0
FloatBtn.AutoButtonColor  = false

do
    local c = Instance.new("UICorner", FloatBtn)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", FloatBtn)
    s.Color     = T.Line
    s.Thickness = 1
end

-- Invisible drag handle
local FloatDrag = Instance.new("TextButton", FloatCont)
FloatDrag.Size                   = UDim2.new(0, 28, 1, 0)
FloatDrag.BackgroundTransparency = 1
FloatDrag.Text                   = ""
FloatDrag.AutoButtonColor        = false

-- ==========================================
-- 6. MAIN WINDOW
-- ==========================================

local Main = Instance.new("Frame", Gui)
Main.Name             = "MainFrame"
Main.Size             = UDim2.new(0, 590, 0, 370)
Main.Position         = UDim2.new(0.5, -295, 0.5, -185)
Main.BackgroundColor3 = T.BG0
Main.BorderSizePixel  = 0
Main.ClipsDescendants = true

do
    local c = Instance.new("UICorner", Main)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", Main)
    s.Color     = T.Line
    s.Thickness = 1
end

-- Float button toggles window
FloatBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ==========================================
-- 7. TOP BAR
-- ==========================================

local Top = Instance.new("Frame", Main)
Top.Name             = "TopBar"
Top.Size             = UDim2.new(1, 0, 0, 40)
Top.BackgroundColor3 = T.TopBG
Top.BorderSizePixel  = 0
Top.ZIndex           = 2

do
    local c = Instance.new("UICorner", Top)
    c.CornerRadius = UDim.new(0, 8)
    -- Fix: kotak bagian bawah topbar
    local fix = Instance.new("Frame", Top)
    fix.Size             = UDim2.new(1, 0, 0, 10)
    fix.Position         = UDim2.new(0, 0, 1, -10)
    fix.BackgroundColor3 = T.TopBG
    fix.BorderSizePixel  = 0
    -- Bottom separator line
    local line = Instance.new("Frame", Top)
    line.Size             = UDim2.new(1, 0, 0, 1)
    line.Position         = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = T.Line
    line.BorderSizePixel  = 0
end

-- Title section
local TitleCont = Instance.new("Frame", Top)
TitleCont.Name                   = "TitleCont"
TitleCont.Size                   = UDim2.new(0, 320, 1, 0)
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

MakeTitlePart("Cat",          T.Accent,  Enum.Font.GothamBold,   14)
MakeTitlePart("HUB",          T.Text,    Enum.Font.GothamBold,   14)
MakeTitlePart("·",            T.TextDim, Enum.Font.Gotham,       13)
MakeTitlePart("Blox Fruits",  T.TextSub, Enum.Font.GothamMedium, 12)
MakeTitlePart("[Freemium]",   T.Gold,    Enum.Font.GothamMedium, 11)

-- Window control buttons
local function MakeWinBtn(xOffset, symbol, size)
    local b = Instance.new("TextButton", Top)
    b.Size                   = UDim2.new(0, 38, 0, 40)
    b.Position               = UDim2.new(1, xOffset, 0, 0)
    b.Text                   = symbol
    b.TextColor3             = T.TextSub
    b.TextSize               = size or 14
    b.Font                   = Enum.Font.GothamBold
    b.BackgroundTransparency = 1
    b.AutoButtonColor        = false
    b.ZIndex                 = 3
    return b
end

local BtnX = MakeWinBtn(-38,  "✕", 14)
local BtnM = MakeWinBtn(-76,  "—", 12)

-- Hover effects
BtnX.MouseEnter:Connect(function() Tween(BtnX, {TextColor3 = T.Red}, 0.1) end)
BtnX.MouseLeave:Connect(function() Tween(BtnX, {TextColor3 = T.TextSub}, 0.1) end)
BtnM.MouseEnter:Connect(function() Tween(BtnM, {TextColor3 = T.Text}, 0.1) end)
BtnM.MouseLeave:Connect(function() Tween(BtnM, {TextColor3 = T.TextSub}, 0.1) end)

-- Actions
BtnX.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

local isMinimized = false
local lastSize    = Main.Size

BtnM.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then lastSize = Main.Size end
    local h = isMinimized and 40 or lastSize.Y.Offset
    Tween(Main, { Size = UDim2.new(0, Main.Size.X.Offset, 0, h) }, 0.25, Enum.EasingStyle.Quint)
end)

-- ==========================================
-- 8. DRAG & RESIZE STATE
-- ==========================================

local dragMain  = { active = false, start = nil, pos = nil }
local dragFloat = { active = false, start = nil, pos = nil }
local resizer   = { active = false, start = nil, size = nil }

-- Top bar: start main drag
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

-- Float drag
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

-- ==========================================
-- 9. WINDOW RESIZER (Bottom-right corner)
-- ==========================================

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

-- Unified InputChanged handler
UserInput.InputChanged:Connect(function(i)
    local isMove = i.UserInputType == Enum.UserInputType.MouseMovement
               or i.UserInputType == Enum.UserInputType.Touch
    if not isMove then return end

    -- Main drag
    if dragMain.active and dragMain.start then
        local d = i.Position - dragMain.start
        Main.Position = UDim2.new(
            dragMain.pos.X.Scale, dragMain.pos.X.Offset + d.X,
            dragMain.pos.Y.Scale, dragMain.pos.Y.Offset + d.Y
        )
    end

    -- Float drag
    if dragFloat.active and dragFloat.start then
        local d = i.Position - dragFloat.start
        FloatCont.Position = UDim2.new(
            dragFloat.pos.X.Scale, dragFloat.pos.X.Offset + d.X,
            dragFloat.pos.Y.Scale, dragFloat.pos.Y.Offset + d.Y
        )
    end

    -- Resize
    if resizer.active and resizer.start then
        local cur = UserInput:GetMouseLocation()
        local d   = cur - resizer.start
        Main.Size = UDim2.new(0,
            math.clamp(resizer.size.X.Offset + d.X, 400, 950),
            0,
            math.clamp(resizer.size.Y.Offset + d.Y, 250, 750)
        )
        lastSize = Main.Size
    end
end)

-- Stop all on input end
UserInput.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragMain.active  = false
        dragFloat.active = false
        resizer.active   = false
    end
end)

-- ==========================================
-- 10. BODY LAYOUT
-- ==========================================

local Body = Instance.new("Frame", Main)
Body.Name                   = "Body"
Body.Size                   = UDim2.new(1, 0, 1, -40)
Body.Position               = UDim2.new(0, 0, 0, 40)
Body.BackgroundTransparency = 1

-- ==========================================
-- 11. SIDEBAR
-- ==========================================

local Side = Instance.new("Frame", Body)
Side.Name             = "Sidebar"
Side.Size             = UDim2.new(0, 160, 1, 0)
Side.BackgroundColor3 = T.BG1
Side.BorderSizePixel  = 0

-- Right border line
local SideLine = Instance.new("Frame", Side)
SideLine.Size             = UDim2.new(0, 1, 1, 0)
SideLine.Position         = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3 = T.Line
SideLine.BorderSizePixel  = 0

-- Search Box
local SearchWrap = Instance.new("Frame", Side)
SearchWrap.Name             = "SearchWrap"
SearchWrap.Size             = UDim2.new(1, -16, 0, 28)
SearchWrap.Position         = UDim2.new(0, 8, 0, 10)
SearchWrap.BackgroundColor3 = T.BG2
SearchWrap.BorderSizePixel  = 0

do
    local c = Instance.new("UICorner", SearchWrap)
    c.CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", SearchWrap)
    s.Color     = T.Line
    s.Thickness = 1
end

local SearchIcon = Instance.new("TextLabel", SearchWrap)
SearchIcon.Size                   = UDim2.new(0, 22, 1, 0)
SearchIcon.Position               = UDim2.new(0, 6, 0, 0)
SearchIcon.Text                   = "⌕"
SearchIcon.TextSize               = 14
SearchIcon.TextColor3             = T.TextDim
SearchIcon.Font                   = Enum.Font.Gotham
SearchIcon.BackgroundTransparency = 1

local SearchBox = Instance.new("TextBox", SearchWrap)
SearchBox.Size                   = UDim2.new(1, -28, 1, 0)
SearchBox.Position               = UDim2.new(0, 24, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text                   = ""
SearchBox.PlaceholderText        = "Search..."
SearchBox.TextColor3             = T.Text
SearchBox.PlaceholderColor3      = T.TextDim
SearchBox.Font                   = Enum.Font.GothamMedium
SearchBox.TextSize               = 11
SearchBox.TextXAlignment         = Enum.TextXAlignment.Left

-- Scrollable tab list
local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Name                   = "SideScroll"
SideScroll.Size                   = UDim2.new(1, 0, 1, -50)
SideScroll.Position               = UDim2.new(0, 0, 0, 50)
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

-- Auto-update sidebar canvas
SideList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SideScroll.CanvasSize = UDim2.new(0, 0, 0, SideList.AbsoluteContentSize.Y + 12)
end)

-- ==========================================
-- 12. CONTENT AREA
-- ==========================================

local ContentArea = Instance.new("Frame", Body)
ContentArea.Name                   = "ContentArea"
ContentArea.Size                   = UDim2.new(1, -160, 1, 0)
ContentArea.Position               = UDim2.new(0, 160, 0, 0)
ContentArea.BackgroundTransparency = 1

-- ==========================================
-- 13. TAB SYSTEM
-- ==========================================

local Pages    = {}
local AllItems = {} -- untuk search

-- Tab priority & icons
local TabOrder = { "Status", "Auto Farm", "Devil Fruits", "Misc" }
local TabIcons = {
    ["Status"]       = "◈",
    ["Auto Farm"]    = "⚔",
    ["Devil Fruits"] = "◉",
    ["Misc"]         = "⚙",
}

local function CreateTab(name, isFirst)
    if Pages[name] then return Pages[name].Page end

    -- Get sort order
    local order = 99
    for i, v in ipairs(TabOrder) do
        if v == name then order = i break end
    end

    -- ── Sidebar Button ──────────────────────
    local Btn = Instance.new("TextButton", SideScroll)
    Btn.Name             = name .. "_TabBtn"
    Btn.LayoutOrder      = order
    Btn.Size             = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = isFirst and T.BG2 or T.BG1
    Btn.Text             = ""
    Btn.BorderSizePixel  = 0
    Btn.AutoButtonColor  = false

    local BtnCorner = Instance.new("UICorner", Btn)
    BtnCorner.CornerRadius = UDim.new(0, 6)

    -- Blue active indicator bar (left side)
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
    Icon.Position               = UDim2.new(0, 10, 0, 0)
    Icon.Text                   = TabIcons[name] or "●"
    Icon.TextSize               = 14
    Icon.TextColor3             = isFirst and T.Accent or T.TextDim
    Icon.Font                   = Enum.Font.Gotham
    Icon.BackgroundTransparency = 1

    -- Label
    local Lbl = Instance.new("TextLabel", Btn)
    Lbl.Size                   = UDim2.new(1, -40, 1, 0)
    Lbl.Position               = UDim2.new(0, 36, 0, 0)
    Lbl.Text                   = name
    Lbl.TextColor3             = isFirst and T.Text or T.TextSub
    Lbl.Font                   = Enum.Font.GothamMedium
    Lbl.TextSize               = 12
    Lbl.TextXAlignment         = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    -- Hover effect
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
    PagePad.PaddingTop    = UDim.new(0, 4)
    PagePad.PaddingLeft   = UDim.new(0, 2)
    PagePad.PaddingRight  = UDim.new(0, 8)
    PagePad.PaddingBottom = UDim.new(0, 10)

    -- Auto canvas size
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)

    -- ── Tab Switch Logic ─────────────────────
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
-- 14. UI COMPONENTS
-- ==========================================

-- // Section Header (dengan divider line kanan)
local function CreateSection(parent, text)
    local Frame = Instance.new("Frame", parent)
    Frame.Name                   = "Sec_" .. text
    Frame.LayoutOrder            = #parent:GetChildren()
    Frame.Size                   = UDim2.new(1, 0, 0, 30)
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

    -- Divider line setelah label
    local Line = Instance.new("Frame", Frame)
    Line.Name             = "Line"
    Line.AnchorPoint      = Vector2.new(0, 0.5)
    Line.Size             = UDim2.new(1, -120, 0, 1)
    Line.Position         = UDim2.new(0, 118, 0.62, 0)
    Line.BackgroundColor3 = T.Line
    Line.BorderSizePixel  = 0
end

-- // Toggle Switch (mirip Redz Hub style)
local function CreateToggle(parent, text, description, defaultState, callback)
    local h = description and 54 or 38

    local Btn = Instance.new("TextButton", parent)
    Btn.Name             = text .. "_Toggle"
    Btn.LayoutOrder      = #parent:GetChildren()
    Btn.Size             = UDim2.new(1, 0, 0, h)
    Btn.BackgroundColor3 = T.BG2
    Btn.BorderSizePixel  = 0
    Btn.Text             = ""
    Btn.AutoButtonColor  = false

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color     = T.Line
    Stroke.Thickness = 1

    -- Hover effect pada card
    Btn.MouseEnter:Connect(function()
        Tween(Btn, { BackgroundColor3 = T.BG3 }, 0.1)
    end)
    Btn.MouseLeave:Connect(function()
        Tween(Btn, { BackgroundColor3 = T.BG2 }, 0.1)
    end)

    -- Title
    local Title = Instance.new("TextLabel", Btn)
    Title.Size                   = UDim2.new(1, -66, 0, 18)
    Title.Position               = UDim2.new(0, 12, 0, description and 8 or 10)
    Title.Text                   = text
    Title.TextColor3             = T.Text
    Title.Font                   = Enum.Font.GothamMedium
    Title.TextSize               = 12
    Title.TextXAlignment         = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Description (opsional)
    if description then
        local Desc = Instance.new("TextLabel", Btn)
        Desc.Size                   = UDim2.new(1, -66, 0, 14)
        Desc.Position               = UDim2.new(0, 12, 0, 28)
        Desc.Text                   = description
        Desc.TextColor3             = T.TextSub
        Desc.Font                   = Enum.Font.Gotham
        Desc.TextSize               = 10
        Desc.TextXAlignment         = Enum.TextXAlignment.Left
        Desc.BackgroundTransparency = 1
    end

    -- Toggle Track
    local Track = Instance.new("Frame", Btn)
    Track.Size             = UDim2.new(0, 38, 0, 20)
    Track.Position         = UDim2.new(1, -50, 0.5, -10)
    Track.BackgroundColor3 = defaultState and T.TglOn or T.TglOff
    Track.BorderSizePixel  = 0

    local TrackCorner = Instance.new("UICorner", Track)
    TrackCorner.CornerRadius = UDim.new(1, 0)

    -- Toggle Dot
    local Dot = Instance.new("Frame", Track)
    Dot.Size             = UDim2.new(0, 16, 0, 16)
    Dot.Position         = defaultState
        and UDim2.new(1, -18, 0.5, -8)
        or  UDim2.new(0,   2, 0.5, -8)
    Dot.BackgroundColor3 = T.TglDot
    Dot.BorderSizePixel  = 0

    local DotCorner = Instance.new("UICorner", Dot)
    DotCorner.CornerRadius = UDim.new(1, 0)

    -- State logic
    local state = defaultState or false

    Btn.MouseButton1Click:Connect(function()
        state = not state

        Tween(Track, { BackgroundColor3 = state and T.TglOn or T.TglOff }, 0.2)
        Tween(Dot,   { Position = state
            and UDim2.new(1, -18, 0.5, -8)
            or  UDim2.new(0,   2, 0.5, -8) }, 0.2)

        if callback then callback(state) end
        SaveSettings()
    end)

    table.insert(AllItems, { Btn = Btn, Label = Title })
    return Btn
end

-- // Button (dengan arrow ›)
local function CreateButton(parent, text, description, callback)
    local h = description and 54 or 38

    local Btn = Instance.new("TextButton", parent)
    Btn.Name             = text .. "_Btn"
    Btn.LayoutOrder      = #parent:GetChildren()
    Btn.Size             = UDim2.new(1, 0, 0, h)
    Btn.BackgroundColor3 = T.BG2
    Btn.BorderSizePixel  = 0
    Btn.Text             = ""
    Btn.AutoButtonColor  = false

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color     = T.Line
    Stroke.Thickness = 1

    Btn.MouseEnter:Connect(function()
        Tween(Btn, { BackgroundColor3 = T.BG3 }, 0.1)
    end)
    Btn.MouseLeave:Connect(function()
        Tween(Btn, { BackgroundColor3 = T.BG2 }, 0.1)
    end)

    local Title = Instance.new("TextLabel", Btn)
    Title.Size                   = UDim2.new(1, -50, 0, 18)
    Title.Position               = UDim2.new(0, 12, 0, description and 8 or 10)
    Title.Text                   = text
    Title.TextColor3             = T.Text
    Title.Font                   = Enum.Font.GothamMedium
    Title.TextSize               = 12
    Title.TextXAlignment         = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    if description then
        local Desc = Instance.new("TextLabel", Btn)
        Desc.Size                   = UDim2.new(1, -50, 0, 14)
        Desc.Position               = UDim2.new(0, 12, 0, 28)
        Desc.Text                   = description
        Desc.TextColor3             = T.TextSub
        Desc.Font                   = Enum.Font.Gotham
        Desc.TextSize               = 10
        Desc.TextXAlignment         = Enum.TextXAlignment.Left
        Desc.BackgroundTransparency = 1
    end

    -- Arrow indicator
    local Arrow = Instance.new("TextLabel", Btn)
    Arrow.Size                   = UDim2.new(0, 32, 1, 0)
    Arrow.Position               = UDim2.new(1, -38, 0, 0)
    Arrow.Text                   = "›"
    Arrow.TextColor3             = T.Accent
    Arrow.TextSize               = 22
    Arrow.Font                   = Enum.Font.GothamBold
    Arrow.BackgroundTransparency = 1

    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    table.insert(AllItems, { Btn = Btn, Label = Title })
    return Btn
end

-- // Dropdown (label + value kanan, seperti Redz Hub "Farm Tool")
local function CreateDropdown(parent, text, options, defaultIndex, callback)
    local currentIndex = defaultIndex or 1

    local Btn = Instance.new("TextButton", parent)
    Btn.Name             = text .. "_Dropdown"
    Btn.LayoutOrder      = #parent:GetChildren()
    Btn.Size             = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = T.BG2
    Btn.BorderSizePixel  = 0
    Btn.Text             = ""
    Btn.AutoButtonColor  = false

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color     = T.Line
    Stroke.Thickness = 1

    Btn.MouseEnter:Connect(function() Tween(Btn, { BackgroundColor3 = T.BG3 }, 0.1) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, { BackgroundColor3 = T.BG2 }, 0.1) end)

    local Title = Instance.new("TextLabel", Btn)
    Title.Size                   = UDim2.new(0.5, 0, 1, 0)
    Title.Position               = UDim2.new(0, 12, 0, 0)
    Title.Text                   = text
    Title.TextColor3             = T.Text
    Title.Font                   = Enum.Font.GothamMedium
    Title.TextSize               = 12
    Title.TextXAlignment         = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Value display (kanan seperti Redz "Sword", "Large")
    local ValueLbl = Instance.new("TextLabel", Btn)
    ValueLbl.Size                   = UDim2.new(0.45, 0, 1, 0)
    ValueLbl.Position               = UDim2.new(0.5, 0, 0, 0)
    ValueLbl.Text                   = options[currentIndex] or ""
    ValueLbl.TextColor3             = T.Text
    ValueLbl.Font                   = Enum.Font.GothamBold
    ValueLbl.TextSize               = 12
    ValueLbl.TextXAlignment         = Enum.TextXAlignment.Right
    ValueLbl.BackgroundTransparency = 1

    local ChevLbl = Instance.new("TextLabel", Btn)
    ChevLbl.Size                   = UDim2.new(0, 24, 1, 0)
    ChevLbl.Position               = UDim2.new(1, -28, 0, 0)
    ChevLbl.Text                   = "⌄"
    ChevLbl.TextColor3             = T.Accent
    ChevLbl.TextSize               = 14
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

-- // Info Label Card
local function CreateLabel(parent, text, description)
    local h = description and 46 or 32

    local Frame = Instance.new("Frame", parent)
    Frame.Name            = "Lbl_" .. text
    Frame.LayoutOrder     = #parent:GetChildren()
    Frame.Size            = UDim2.new(1, 0, 0, h)
    Frame.BackgroundColor3 = T.BG2
    Frame.BorderSizePixel = 0

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color     = T.Line
    Stroke.Thickness = 1

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size                   = UDim2.new(1, -20, 0, 18)
    Lbl.Position               = UDim2.new(0, 12, 0, description and 4 or 7)
    Lbl.Text                   = text
    Lbl.TextColor3             = T.Text
    Lbl.Font                   = Enum.Font.GothamMedium
    Lbl.TextSize               = 12
    Lbl.TextXAlignment         = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    if description then
        local Sub = Instance.new("TextLabel", Frame)
        Sub.Size                   = UDim2.new(1, -20, 0, 14)
        Sub.Position               = UDim2.new(0, 12, 0, 24)
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
-- 15. SEARCH ENGINE
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
-- 16. INIT: DEFAULT TABS
-- ==========================================

CreateTab("Status",       true)
CreateTab("Auto Farm",    false)
CreateTab("Devil Fruits", false)
CreateTab("Misc",         false)

-- ==========================================
-- 17. GLOBAL EXPORT
-- ==========================================

_G.Cat.UI = {
    -- Core builders
    CreateTab      = CreateTab,
    CreateSection  = CreateSection,
    CreateToggle   = CreateToggle,
    CreateButton   = CreateButton,
    CreateDropdown = CreateDropdown,
    CreateLabel    = CreateLabel,

    -- Helpers
    Theme          = T,
    Tween          = Tween,
    SaveSettings   = SaveSettings,
}

warn("[CatHUB v2.0] Redesigned UI loaded successfully.")