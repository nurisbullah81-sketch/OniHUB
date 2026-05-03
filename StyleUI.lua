--[[ ==========================================
      CATHUB PREMIUM · REDZ HUB REPLICA v3.0
      Part 1/3: Core UI, Topbar, Sidebar, Footer
    ========================================== ]]

-- Services
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput    = game:GetService("UserInputService")
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")

-- Anti duplicate
if CoreGui:FindFirstChild("CatUI") then
    CoreGui.CatUI:Destroy()
end

-- [[ Global Table ]] --
_G.Cat             = _G.Cat or {}
_G.Cat.Player      = Players.LocalPlayer
_G.Cat.Labels      = _G.Cat.Labels or {}
_G.Cat.Settings    = _G.Cat.Settings or {}
local Settings     = _G.Cat.Settings

-- [[ Utility Functions ]] --
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
        writefile("CatHUB_Config.json", HttpService:JSONEncode(Settings))
    end)
end

-- [[ Theme - Dark Premium Redz Style ]] --
local T = {
    BG0     = Color3.fromRGB(12,  12,  16),
    BG1     = Color3.fromRGB(16,  16,  22),
    BG2     = Color3.fromRGB(22,  22,  30),
    BG3     = Color3.fromRGB(28,  28,  38),
    TopBG   = Color3.fromRGB(14,  14,  20),
    Line    = Color3.fromRGB(34,  34,  48),
    LineAct = Color3.fromRGB(80,  130, 255),
    Text    = Color3.fromRGB(225, 225, 235),
    TextSub = Color3.fromRGB(140, 140, 155),
    TextDim = Color3.fromRGB(80,  80,  95),
    Accent  = Color3.fromRGB(85,  130, 255),
    AccentD = Color3.fromRGB(55,  100, 210),
    TglOn   = Color3.fromRGB(85,  130, 255),
    TglOff  = Color3.fromRGB(50,  50,  65),
    TglDot  = Color3.fromRGB(255, 255, 255),
    Gold    = Color3.fromRGB(255, 195,  0),
    Green   = Color3.fromRGB(52,  220, 155),
    Red     = Color3.fromRGB(255, 70,  70),
    Purple  = Color3.fromRGB(140, 100, 255),
}

-- [[ Root ScreenGui ]] --
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name           = "CatUI"
Gui.ResetOnSpawn   = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ Floating Toggle Button (ala Redz) ]] --
local FloatCont = Instance.new("Frame", Gui)
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

local corner1 = Instance.new("UICorner", FloatBtn)
corner1.CornerRadius = UDim.new(0, 8)
local stroke1 = Instance.new("UIStroke", FloatBtn)
stroke1.Color     = T.Line
stroke1.Thickness = 1

local FloatDrag = Instance.new("TextButton", FloatCont)
FloatDrag.Size                   = UDim2.new(0, 30, 1, 0)
FloatDrag.BackgroundTransparency = 1
FloatDrag.Text                   = ""
FloatDrag.AutoButtonColor        = false
FloatDrag.ZIndex                 = 99999

-- [[ Main Window ]] --
local Main = Instance.new("Frame", Gui)
Main.Name             = "MainFrame"
Main.Size             = UDim2.new(0, 640, 0, 420)
Main.Position         = UDim2.new(0.5, -320, 0.5, -210)
Main.BackgroundColor3 = T.BG0
Main.BorderSizePixel  = 0
Main.ClipsDescendants = true
Main.Visible          = true

local corMain = Instance.new("UICorner", Main)
corMain.CornerRadius = UDim.new(0, 8)
local strMain = Instance.new("UIStroke", Main)
strMain.Color     = T.Line
strMain.Thickness = 1

FloatBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- [[ Top Bar ]] --
local Top = Instance.new("Frame", Main)
Top.Name             = "TopBar"
Top.Size             = UDim2.new(1, 0, 0, 42)
Top.BackgroundColor3 = T.TopBG
Top.BorderSizePixel  = 0
Top.ZIndex           = 2

local topCorner = Instance.new("UICorner", Top)
topCorner.CornerRadius = UDim.new(0, 8)
local fixFrame = Instance.new("Frame", Top)
fixFrame.Size             = UDim2.new(1, 0, 0, 12)
fixFrame.Position         = UDim2.new(0, 0, 1, -12)
fixFrame.BackgroundColor3 = T.TopBG
fixFrame.BorderSizePixel  = 0
local topLine = Instance.new("Frame", Top)
topLine.Size             = UDim2.new(1, 0, 0, 1)
topLine.Position         = UDim2.new(0, 0, 1, -1)
topLine.BackgroundColor3 = T.Line
topLine.BorderSizePixel  = 0

-- Title "redz hub · Blox Fruits"
local TitleCont = Instance.new("Frame", Top)
TitleCont.Size                   = UDim2.new(0, 320, 1, 0)
TitleCont.Position               = UDim2.new(0, 14, 0, 0)
TitleCont.BackgroundTransparency = 1
local titleList = Instance.new("UIListLayout", TitleCont)
titleList.FillDirection     = Enum.FillDirection.Horizontal
titleList.VerticalAlignment = Enum.VerticalAlignment.Center
titleList.Padding           = UDim.new(0, 5)

local function addTitleText(text, color, font, size)
    local lbl = Instance.new("TextLabel", TitleCont)
    lbl.Text               = text
    lbl.TextColor3         = color
    lbl.Font               = font or Enum.Font.GothamBold
    lbl.TextSize           = size or 13
    lbl.BackgroundTransparency = 1
    lbl.AutomaticSize      = Enum.AutomaticSize.XY
    return lbl
end
addTitleText("redz",  T.Accent,  Enum.Font.GothamBold, 14)
addTitleText("hub",   T.Text,    Enum.Font.GothamBold, 14)
addTitleText("|",     T.TextDim, Enum.Font.Gotham, 14)
addTitleText("Blox Fruits", T.TextSub, Enum.Font.GothamMedium, 12)

-- Minimize / Close buttons
local function makeControlBtn(xOffset, char, fontSize)
    local btn = Instance.new("TextButton", Top)
    btn.Size                   = UDim2.new(0, 42, 0, 42)
    btn.Position               = UDim2.new(1, xOffset, 0, 0)
    btn.Text                   = char
    btn.TextColor3             = T.TextSub
    btn.TextSize               = fontSize or 16
    btn.Font                   = Enum.Font.GothamBold
    btn.BackgroundTransparency = 1
    btn.AutoButtonColor        = false
    btn.ZIndex                 = 3
    return btn
end

local BtnClose = makeControlBtn(-42, "x", 16) -- X
BtnClose.Text = "x" -- ganti cross simbol
local BtnMin   = makeControlBtn(-84, "_", 14)  -- minimize underscore

BtnClose.MouseEnter:Connect(function() Tween(BtnClose, {TextColor3 = T.Red}, 0.1) end)
BtnClose.MouseLeave:Connect(function() Tween(BtnClose, {TextColor3 = T.TextSub}, 0.1) end)
BtnMin.MouseEnter:Connect(function() Tween(BtnMin, {TextColor3 = T.Text}, 0.1) end)
BtnMin.MouseLeave:Connect(function() Tween(BtnMin, {TextColor3 = T.TextSub}, 0.1) end)

BtnClose.MouseButton1Click:Connect(function() Main.Visible = false end)

local isMinimized = false
local lastSize    = Main.Size
BtnMin.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then lastSize = Main.Size end
    local h = isMinimized and 42 or lastSize.Y.Offset
    Tween(Main, { Size = UDim2.new(0, Main.Size.X.Offset, 0, h) }, 0.25)
end)

-- [[ Drag (Topbar & Float) + Resize ]] --
local dragMain  = {active=false, start=nil, pos=nil}
local dragFloat = {active=false, start=nil, pos=nil}
local resizer   = {active=false, start=nil, size=nil}

Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragMain.active = true
        dragMain.start  = i.Position
        dragMain.pos    = Main.Position
    end
end)
Top.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragMain.active = false
    end
end)

FloatDrag.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragFloat.active = true
        dragFloat.start  = i.Position
        dragFloat.pos    = FloatCont.Position
    end
end)
FloatDrag.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragFloat.active = false
    end
end)

-- Resize handle
local ResizeHandle = Instance.new("TextButton", Main)
ResizeHandle.Size                   = UDim2.new(0, 28, 0, 28)
ResizeHandle.Position               = UDim2.new(1, -28, 1, -28)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text                   = "o"  -- sudut resize
ResizeHandle.TextColor3             = T.TextDim
ResizeHandle.TextSize               = 24
ResizeHandle.Font                   = Enum.Font.Gotham
ResizeHandle.ZIndex                 = 99999
ResizeHandle.AutoButtonColor        = false

ResizeHandle.InputBegan:Connect(function(i)
    if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not isMinimized then
        resizer.active = true
        resizer.start  = UserInput:GetMouseLocation()
        resizer.size   = Main.Size
    end
end)

UserInput.InputChanged:Connect(function(i)
    if not (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then return end
    if dragMain.active and dragMain.start then
        local delta = i.Position - dragMain.start
        Main.Position = UDim2.new(dragMain.pos.X.Scale, dragMain.pos.X.Offset + delta.X, dragMain.pos.Y.Scale, dragMain.pos.Y.Offset + delta.Y)
    end
    if dragFloat.active and dragFloat.start then
        local delta = i.Position - dragFloat.start
        FloatCont.Position = UDim2.new(dragFloat.pos.X.Scale, dragFloat.pos.X.Offset + delta.X, dragFloat.pos.Y.Scale, dragFloat.pos.Y.Offset + delta.Y)
    end
    if resizer.active and resizer.start then
        local cur = UserInput:GetMouseLocation()
        local d   = cur - resizer.start
        Main.Size = UDim2.new(0, math.clamp(resizer.size.X.Offset + d.X, 420, 1000), 0, math.clamp(resizer.size.Y.Offset + d.Y, 280, 800))
        lastSize  = Main.Size
    end
end)

UserInput.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragMain.active  = false
        dragFloat.active = false
        resizer.active   = false
    end
end)

-- [[ Footer Status Bar (Health, Energy, Player count) ]] --
local Footer = Instance.new("Frame", Main)
Footer.Name             = "Footer"
Footer.Size             = UDim2.new(1, 0, 0, 32)
Footer.Position         = UDim2.new(0, 0, 1, -32)
Footer.BackgroundColor3 = T.TopBG
Footer.BorderSizePixel  = 0
Footer.ZIndex           = 2
Instance.new("Frame", Footer).BackgroundColor3 = T.Line
Instance.new("Frame", Footer).Size = UDim2.new(1,0,0,1)

-- Health
local healthFrame = Instance.new("Frame", Footer)
healthFrame.Size = UDim2.new(0,140,0,20); healthFrame.Position = UDim2.new(0,14,0.5,-10); healthFrame.BackgroundTransparency=1
local healthIcon = Instance.new("TextLabel", healthFrame)
healthIcon.Size=UDim2.new(0,18,1,0); healthIcon.Text="HP"; healthIcon.TextColor3=T.Red; healthIcon.Font=Enum.Font.GothamBold; healthIcon.TextSize=13; healthIcon.BackgroundTransparency=1
local healthText = Instance.new("TextLabel", healthFrame)
healthText.Size=UDim2.new(1,-22,1,0); healthText.Position=UDim2.new(0,20,0,0); healthText.Text="100 / 100"; healthText.TextColor3=T.Text; healthText.Font=Enum.Font.GothamMedium; healthText.TextSize=11; healthText.TextXAlignment=Enum.TextXAlignment.Left; healthText.BackgroundTransparency=1

-- Energy
local energyFrame = Instance.new("Frame", Footer)
energyFrame.Size = UDim2.new(0,140,0,20); energyFrame.Position = UDim2.new(0,160,0.5,-10); energyFrame.BackgroundTransparency=1
local energyIcon = Instance.new("TextLabel", energyFrame)
energyIcon.Size=UDim2.new(0,18,1,0); energyIcon.Text="EN"; energyIcon.TextColor3=T.Gold; energyIcon.Font=Enum.Font.GothamBold; energyIcon.TextSize=13; energyIcon.BackgroundTransparency=1
local energyText = Instance.new("TextLabel", energyFrame)
energyText.Size=UDim2.new(1,-22,1,0); energyText.Position=UDim2.new(0,20,0,0); energyText.Text="100 / 100"; energyText.TextColor3=T.Text; energyText.Font=Enum.Font.GothamMedium; energyText.TextSize=11; energyText.TextXAlignment=Enum.TextXAlignment.Left; energyText.BackgroundTransparency=1

-- Version/player count
local versionText = Instance.new("TextLabel", Footer)
versionText.Size = UDim2.new(0,120,1,0); versionText.Position = UDim2.new(1,-130,0,0)
versionText.Text = "u.16 | ".. #Players:GetPlayers() .."/".. game.Players.MaxPlayers
versionText.TextColor3 = T.TextSub; versionText.Font = Enum.Font.GothamMedium; versionText.TextSize=10; versionText.TextXAlignment=Enum.TextXAlignment.Right; versionText.BackgroundTransparency=1

local function updateFooter()
    local plr = Players.LocalPlayer
    if plr and plr.Character then
        local hum = plr.Character:FindFirstChild("Humanoid")
        if hum then
            healthText.Text = math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)
        end
    end
    versionText.Text = "u.16 | ".. #Players:GetPlayers() .."/".. game.Players.MaxPlayers
end
RunService.Stepped:Connect(updateFooter)

-- Body layout adjustment
local Body = Instance.new("Frame", Main)
Body.Size = UDim2.new(1,0,1,-74)  -- 42 topbar + 32 footer
Body.Position = UDim2.new(0,0,0,42)
Body.BackgroundTransparency = 1

-- [[ Sidebar ]] --
local Side = Instance.new("Frame", Body)
Side.Name             = "Sidebar"
Side.Size             = UDim2.new(0,170,1,0)
Side.BackgroundColor3 = T.BG1
Side.BorderSizePixel  = 0
local sideRightLine = Instance.new("Frame", Side)
sideRightLine.Size = UDim2.new(0,1,1,0); sideRightLine.Position = UDim2.new(1,-1,0,0); sideRightLine.BackgroundColor3=T.Line; sideRightLine.BorderSizePixel=0

-- Search box
local SearchWrap = Instance.new("Frame", Side)
SearchWrap.Size = UDim2.new(1,-16,0,30); SearchWrap.Position = UDim2.new(0,8,0,12); SearchWrap.BackgroundColor3=T.BG2; SearchWrap.BorderSizePixel=0
local searchCorner = Instance.new("UICorner", SearchWrap); searchCorner.CornerRadius = UDim.new(0,7)
local searchStroke = Instance.new("UIStroke", SearchWrap); searchStroke.Color=T.Line; searchStroke.Thickness=1
local searchIcon = Instance.new("TextLabel", SearchWrap)
searchIcon.Size = UDim2.new(0,24,1,0); searchIcon.Position = UDim2.new(0,6,0,0); searchIcon.Text = ">"; searchIcon.TextColor3=T.TextDim; searchIcon.Font=Enum.Font.Gotham; searchIcon.TextSize=15; searchIcon.BackgroundTransparency=1
local SearchBox = Instance.new("TextBox", SearchWrap)
SearchBox.Size = UDim2.new(1,-30,1,0); SearchBox.Position=UDim2.new(0,26,0,0); SearchBox.BackgroundTransparency=1; SearchBox.PlaceholderText="Search..."; SearchBox.TextColor3=T.Text; SearchBox.PlaceholderColor3=T.TextDim; SearchBox.Font=Enum.Font.GothamMedium; SearchBox.TextSize=12; SearchBox.Text=""; SearchBox.TextXAlignment=Enum.TextXAlignment.Left

-- Sidebar scroll list
local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Size = UDim2.new(1,0,1,-52); SideScroll.Position=UDim2.new(0,0,0,52); SideScroll.BackgroundTransparency=1; SideScroll.ScrollBarThickness=0; SideScroll.BorderSizePixel=0; SideScroll.CanvasSize=UDim2.new(0,0,0,0)
local SideList = Instance.new("UIListLayout", SideScroll)
SideList.Padding = UDim.new(0,2); SideList.SortOrder = Enum.SortOrder.LayoutOrder
local SidePad = Instance.new("UIPadding", SideScroll)
SidePad.PaddingLeft=UDim.new(0,8); SidePad.PaddingRight=UDim.new(0,8); SidePad.PaddingTop=UDim.new(0,4); SidePad.PaddingBottom=UDim.new(0,8)
SideList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SideScroll.CanvasSize = UDim2.new(0,0,0,SideList.AbsoluteContentSize.Y+16)
end)

-- [[ Content Area ]] --
local ContentArea = Instance.new("Frame", Body)
ContentArea.Size = UDim2.new(1,-170,1,0); ContentArea.Position=UDim2.new(0,170,0,0); ContentArea.BackgroundTransparency=1

-- [[ Tab System ]] --
local Pages = {}
local AllItems = {}

function CreateTab(name, isFirst)
    if Pages[name] then return Pages[name].Page end
    local btn = Instance.new("TextButton", SideScroll)
    btn.Name = name.."_TabBtn"
    btn.LayoutOrder = 99
    btn.Size = UDim2.new(1,0,0,36)
    btn.BackgroundColor3 = isFirst and T.BG2 or T.BG1
    btn.Text = ""; btn.BorderSizePixel=0; btn.AutoButtonColor=false
    local btnCorner = Instance.new("UICorner", btn); btnCorner.CornerRadius = UDim.new(0,7)

    -- indicator left
    local ind = Instance.new("Frame", btn)
    ind.Name = "Indicator"; ind.Size = UDim2.new(0,3,0,16); ind.Position=UDim2.new(0,0,0.5,-8); ind.BackgroundColor3=T.Accent; ind.BorderSizePixel=0; ind.Visible=isFirst
    local indCorner = Instance.new("UICorner", ind); indCorner.CornerRadius = UDim.new(1,0)

    -- label
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1,-10,1,0); lbl.Position = UDim2.new(0,10,0,0); lbl.Text = name; lbl.TextColor3 = isFirst and T.Text or T.TextSub
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.BackgroundTransparency=1

    -- page
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Name = name.."_Page"
    page.Size = UDim2.new(1,-14,1,-14); page.Position=UDim2.new(0,7,0,7); page.BackgroundTransparency=1; page.ScrollBarThickness=2; page.ScrollBarImageColor3=T.Line; page.Visible=isFirst; page.BorderSizePixel=0; page.CanvasSize=UDim2.new(0,0,0,0)
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0,5); pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local pagePad = Instance.new("UIPadding", page)
    pagePad.PaddingTop=UDim.new(0,6); pagePad.PaddingLeft=UDim.new(0,2); pagePad.PaddingRight=UDim.new(0,8); pagePad.PaddingBottom=UDim.new(0,12)
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,pageLayout.AbsoluteContentSize.Y+20)
    end)

    btn.MouseButton1Click:Connect(function()
        if Pages[name] and Pages[name].Page.Visible then return end
        for n, d in pairs(Pages) do
            local active = (n == name)
            d.Page.Visible = active
            d.Indicator.Visible = active
            Tween(d.Btn, {BackgroundColor3 = active and T.BG2 or T.BG1}, 0.15)
            Tween(d.Label, {TextColor3 = active and T.Text or T.TextSub}, 0.15)
        end
    end)

    Pages[name] = {Btn = btn, Page = page, Indicator = ind, Label = lbl}
    return page
end

-- export temporary untuk part 1
_G.Cat.Temp = {
    T = T, Tween = Tween, SaveSettings = SaveSettings,
    Gui = Gui, Main = Main, FloatBtn = FloatBtn,
    SearchBox = SearchBox, AllItems = AllItems, Pages = Pages,
    CreateTab = CreateTab,
    UpdateFooter = updateFooter,
}
warn("[CatHUB v3.0] Part 1 loaded: Core UI ready.")

--[[ ==========================================
      CATHUB PREMIUM · REDZ HUB REPLICA v3.0
      Part 2/3: UI Components & Search
      Requires Part 1 variables (_G.Cat.Temp)
    ========================================== ]]

local Temp       = _G.Cat.Temp
local T          = Temp.T
local Tween      = Temp.Tween
local Save       = Temp.SaveSettings
local SearchBox  = Temp.SearchBox
local AllItems   = Temp.AllItems
local ContentArea = Temp.ContentArea  -- Nanti halaman dari CreateTab

-- [[ Section Header dengan divider line ]] --
local function CreateSection(parent, text)
    local Frame = Instance.new("Frame", parent)
    Frame.Name = "Sec_"..text
    Frame.LayoutOrder = #parent:GetChildren()
    Frame.Size = UDim2.new(1, 0, 0, 28)
    Frame.BackgroundTransparency = 1

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0,0,1,0)
    Lbl.AutomaticSize = Enum.AutomaticSize.X
    Lbl.Position = UDim2.new(0,2,0,0)
    Lbl.Text = string.upper(text)
    Lbl.TextColor3 = T.TextSub
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 10
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    -- Divider line
    local Line = Instance.new("Frame", Frame)
    Line.AnchorPoint = Vector2.new(0,0.5)
    Line.Size = UDim2.new(1,-130,0,1)
    Line.Position = UDim2.new(0,126,0.6,0)
    Line.BackgroundColor3 = T.Line
    Line.BorderSizePixel = 0
end

-- [[ Toggle Switch ]] --
local function CreateToggle(parent, text, description, defaultState, callback)
    local h = description and 56 or 40

    local Btn = Instance.new("TextButton", parent)
    Btn.Name = text.."_Toggle"
    Btn.LayoutOrder = #parent:GetChildren()
    Btn.Size = UDim2.new(1,0,0,h)
    Btn.BackgroundColor3 = T.BG2
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.AutoButtonColor = false

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0,7)
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = T.Line
    Stroke.Thickness = 1

    -- Hover
    Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = T.BG3}, 0.1) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = T.BG2}, 0.1) end)

    -- Title
    local Title = Instance.new("TextLabel", Btn)
    Title.Size = UDim2.new(1,-70,0,18)
    Title.Position = UDim2.new(0,14,0, description and 8 or 11)
    Title.Text = text
    Title.TextColor3 = T.Text
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    if description then
        local Desc = Instance.new("TextLabel", Btn)
        Desc.Size = UDim2.new(1,-70,0,14)
        Desc.Position = UDim2.new(0,14,0,28)
        Desc.Text = description
        Desc.TextColor3 = T.TextSub
        Desc.Font = Enum.Font.Gotham
        Desc.TextSize = 10
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Desc.BackgroundTransparency = 1
    end

    -- Track
    local Track = Instance.new("Frame", Btn)
    Track.Size = UDim2.new(0,40,0,22)
    Track.Position = UDim2.new(1,-54,0.5,-11)
    Track.BackgroundColor3 = defaultState and T.TglOn or T.TglOff
    Track.BorderSizePixel = 0
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1,0)

    -- Dot
    local Dot = Instance.new("Frame", Track)
    Dot.Size = UDim2.new(0,18,0,18)
    Dot.Position = defaultState and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
    Dot.BackgroundColor3 = T.TglDot
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1,0)

    local state = defaultState or false

    Btn.MouseButton1Click:Connect(function()
        state = not state
        Tween(Track, {BackgroundColor3 = state and T.TglOn or T.TglOff}, 0.2)
        Tween(Dot,   {Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}, 0.2)
        if callback then callback(state) end
        Save()
    end)

    table.insert(AllItems, {Btn = Btn, Label = Title})
    return Btn
end

-- [[ Button dengan arrow › ]] --
local function CreateButton(parent, text, description, callback)
    local h = description and 56 or 40

    local Btn = Instance.new("TextButton", parent)
    Btn.Name = text.."_Btn"
    Btn.LayoutOrder = #parent:GetChildren()
    Btn.Size = UDim2.new(1,0,0,h)
    Btn.BackgroundColor3 = T.BG2
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.AutoButtonColor = false

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,7)
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = T.Line
    Stroke.Thickness = 1

    Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = T.BG3}, 0.1) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = T.BG2}, 0.1) end)

    local Title = Instance.new("TextLabel", Btn)
    Title.Size = UDim2.new(1,-50,0,18)
    Title.Position = UDim2.new(0,14,0, description and 8 or 11)
    Title.Text = text
    Title.TextColor3 = T.Text
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    if description then
        local Desc = Instance.new("TextLabel", Btn)
        Desc.Size = UDim2.new(1,-50,0,14)
        Desc.Position = UDim2.new(0,14,0,28)
        Desc.Text = description
        Desc.TextColor3 = T.TextSub
        Desc.Font = Enum.Font.Gotham
        Desc.TextSize = 10
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Desc.BackgroundTransparency = 1
    end

    -- Arrow
    local Arrow = Instance.new("TextLabel", Btn)
    Arrow.Size = UDim2.new(0,32,1,0)
    Arrow.Position = UDim2.new(1,-38,0,0)
    Arrow.Text = ">"
    Arrow.TextColor3 = T.Accent
    Arrow.TextSize = 24
    Arrow.Font = Enum.Font.GothamBold
    Arrow.BackgroundTransparency = 1

    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    table.insert(AllItems, {Btn = Btn, Label = Title})
    return Btn
end

-- [[ Dropdown dengan label kiri, value kanan, cycling ]] --
local function CreateDropdown(parent, text, options, defaultIndex, callback)
    local currentIndex = defaultIndex or 1

    local Btn = Instance.new("TextButton", parent)
    Btn.Name = text.."_Dropdown"
    Btn.LayoutOrder = #parent:GetChildren()
    Btn.Size = UDim2.new(1,0,0,40)
    Btn.BackgroundColor3 = T.BG2
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.AutoButtonColor = false

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,7)
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = T.Line
    Stroke.Thickness = 1

    Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = T.BG3}, 0.1) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = T.BG2}, 0.1) end)

    -- Label
    local Title = Instance.new("TextLabel", Btn)
    Title.Size = UDim2.new(0.45,0,1,0)
    Title.Position = UDim2.new(0,14,0,0)
    Title.Text = text
    Title.TextColor3 = T.Text
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Value
    local ValueLbl = Instance.new("TextLabel", Btn)
    ValueLbl.Size = UDim2.new(0.4,0,1,0)
    ValueLbl.Position = UDim2.new(0.45,0,0,0)
    ValueLbl.Text = options[currentIndex] or ""
    ValueLbl.TextColor3 = T.Text
    ValueLbl.Font = Enum.Font.GothamBold
    ValueLbl.TextSize = 12
    ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
    ValueLbl.BackgroundTransparency = 1

    -- Chevron
    local Chev = Instance.new("TextLabel", Btn)
    Chev.Size = UDim2.new(0,26,1,0)
    Chev.Position = UDim2.new(1,-30,0,0)
    Chev.Text = "v"  -- nanti bisa diganti custom icon
    Chev.TextColor3 = T.Accent
    Chev.TextSize = 15
    Chev.Font = Enum.Font.GothamBold
    Chev.BackgroundTransparency = 1

    Btn.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #options) + 1
        ValueLbl.Text = options[currentIndex]
        if callback then callback(options[currentIndex], currentIndex) end
        Save()
    end)

    table.insert(AllItems, {Btn = Btn, Label = Title})
    return Btn
end

-- [[ Slider dengan track & fill, dragging ]] --
local function CreateSlider(parent, text, minVal, maxVal, defaultVal, step, callback)
    local currentVal = defaultVal

    local Frame = Instance.new("Frame", parent)
    Frame.Name = text.."_Slider"
    Frame.LayoutOrder = #parent:GetChildren()
    Frame.Size = UDim2.new(1,0,0,56)
    Frame.BackgroundColor3 = T.BG2
    Frame.BorderSizePixel = 0

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,7)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = T.Line
    Stroke.Thickness = 1

    -- Title
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1,-28,0,18)
    Title.Position = UDim2.new(0,14,0,8)
    Title.Text = text
    Title.TextColor3 = T.Text
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Value display
    local ValLbl = Instance.new("TextLabel", Frame)
    ValLbl.Size = UDim2.new(0,40,0,18)
    ValLbl.Position = UDim2.new(1,-50,0,8)
    ValLbl.Text = string.format("%.1f", defaultVal)
    ValLbl.TextColor3 = T.Accent
    ValLbl.Font = Enum.Font.GothamBold
    ValLbl.TextSize = 12
    ValLbl.TextXAlignment = Enum.TextXAlignment.Right
    ValLbl.BackgroundTransparency = 1

    -- Track
    local Track = Instance.new("TextButton", Frame)
    Track.Size = UDim2.new(1,-28,0,6)
    Track.Position = UDim2.new(0,14,0,34)
    Track.BackgroundColor3 = T.TglOff
    Track.BorderSizePixel = 0
    Track.Text = ""
    Track.AutoButtonColor = false
    Instance.new("UICorner", Track).CornerRadius = UDim.new(0,3)

    -- Fill
    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal),0,1,0)
    Fill.BackgroundColor3 = T.Accent
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0,3)

    local dragging = false

    local function setValue(input)
        local relX = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local rawVal = minVal + (maxVal - minVal) * relX
        local stepped = minVal + math.floor((rawVal - minVal) / step + 0.5) * step
        stepped = math.clamp(stepped, minVal, maxVal)
        currentVal = stepped
        Fill.Size = UDim2.new((stepped - minVal) / (maxVal - minVal),0,1,0)
        ValLbl.Text = string.format("%.1f", stepped)
        if callback then callback(stepped) end
        Save()
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

    -- Expose setter
    local self = {}
    function self.Set(val)
        setValue({Position = Vector2.new(Track.AbsolutePosition.X + (val-minVal)/(maxVal-minVal)*Track.AbsoluteSize.X, 0)})
    end

    table.insert(AllItems, {Btn = Frame, Label = Title})
    return self
end

-- [[ Label Card ]] --
local function CreateLabel(parent, text, description)
    local h = description and 48 or 34

    local Frame = Instance.new("Frame", parent)
    Frame.Name = "Lbl_"..text
    Frame.LayoutOrder = #parent:GetChildren()
    Frame.Size = UDim2.new(1,0,0,h)
    Frame.BackgroundColor3 = T.BG2
    Frame.BorderSizePixel = 0

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,7)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = T.Line
    Stroke.Thickness = 1

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1,-24,0,18)
    Lbl.Position = UDim2.new(0,14,0, description and 4 or 8)
    Lbl.Text = text
    Lbl.TextColor3 = T.Text
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    if description then
        local Sub = Instance.new("TextLabel", Frame)
        Sub.Size = UDim2.new(1,-24,0,14)
        Sub.Position = UDim2.new(0,14,0,24)
        Sub.Text = description
        Sub.TextColor3 = T.TextSub
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 10
        Sub.TextXAlignment = Enum.TextXAlignment.Left
        Sub.BackgroundTransparency = 1
    end

    return Lbl
end

-- [[ Search Engine ]] --
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(SearchBox.Text)
    for _, item in ipairs(AllItems) do
        local lbl = string.lower(item.Label.Text)
        local empty = (q == "")
        local found = string.find(lbl, q) ~= nil
        item.Btn.Visible = empty or found
    end
end)

-- [[ Export ke global builder ]] --
_G.Cat.UI = {
    CreateTab      = Temp.CreateTab,
    CreateSection  = CreateSection,
    CreateToggle   = CreateToggle,
    CreateButton   = CreateButton,
    CreateDropdown = CreateDropdown,
    CreateSlider   = CreateSlider,
    CreateLabel    = CreateLabel,
    Theme          = T,
    Tween          = Tween,
    SaveSettings   = Save,
    Pages          = Temp.Pages,
    UpdateFooter   = Temp.UpdateFooter,
    MainFrame      = Temp.Main,
    FloatButton    = Temp.FloatBtn,
    SearchBox      = SearchBox,
}

-- Clean up temp
_G.Cat.Temp = nil

warn("[CatHUB v3.0] Part 2 loaded: Component builders ready.")

--[[ ==========================================
      CATHUB PREMIUM · REDZ HUB REPLICA v3.0
      Part 3/3: Tab Initialization & Content
      Requires Part 1 & 2 loaded (_G.Cat.UI)
    ========================================== ]]

local UI = _G.Cat.UI

-- ==========================================
-- 1. HOME / INFO
-- ==========================================
local tabHome = UI.CreateTab("Home / Info", true)
do
    UI.CreateSection(tabHome, "General")

    UI.CreateLabel(tabHome, "Status Script", "Script is running")
    UI.CreateLabel(tabHome, "Info Player", "Loading...")

    UI.CreateButton(tabHome, "Copy Discord Link", nil, function()
        -- callback copy
    end)
    UI.CreateButton(tabHome, "Join Discord", nil, function()
        -- callback join
    end)
end

-- ==========================================
-- 2. AUTO FARM
-- ==========================================
local tabFarm = UI.CreateTab("Auto Farm", false)
do
    UI.CreateSection(tabFarm, "Select Weapon")
    UI.CreateDropdown(tabFarm, "Select Weapon", {"Melee","Sword","Blox Fruit"}, 1, function(val, idx)
        -- weapon selected
    end)

    UI.CreateSection(tabFarm, "Farm General")
    UI.CreateToggle(tabFarm, "Auto Farm Level", nil, false, function(on) end)
    UI.CreateToggle(tabFarm, "Auto Farm Nearest", nil, false, function(on) end)
    UI.CreateToggle(tabFarm, "Auto Farm Mastery", nil, false, function(on) end)

    UI.CreateSection(tabFarm, "Farm Boss")
    UI.CreateButton(tabFarm, "Refresh Boss", nil, function() end)
    UI.CreateDropdown(tabFarm, "Select Boss", {"Boss1","Boss2","Boss3"}, 1, function(val) end)
    UI.CreateToggle(tabFarm, "Auto Farm Boss", nil, false, function(on) end)

    UI.CreateSection(tabFarm, "Farm Material")
    UI.CreateToggle(tabFarm, "Auto Bone", nil, false, function(on) end)
    UI.CreateToggle(tabFarm, "Auto Ectoplasm", nil, false, function(on) end)
    UI.CreateToggle(tabFarm, "Auto Observation Haki", nil, false, function(on) end)
end

-- ==========================================
-- 3. SEA EVENTS
-- ==========================================
local tabSea = UI.CreateTab("Sea Events", false)
do
    UI.CreateSection(tabSea, "Leviathan & Shark")
    UI.CreateToggle(tabSea, "Auto Terror Shark", nil, false, function(on) end)
    UI.CreateToggle(tabSea, "Auto Leviathan", nil, false, function(on) end)
    UI.CreateToggle(tabSea, "ESP Leviathan", nil, false, function(on) end)

    UI.CreateSection(tabSea, "Ship & Pirate")
    UI.CreateToggle(tabSea, "Auto Ship Raid", nil, false, function(on) end)
    UI.CreateToggle(tabSea, "Auto Piranha", nil, false, function(on) end)
    UI.CreateToggle(tabSea, "Auto Farm Sea Event", nil, false, function(on) end)
end

-- ==========================================
-- 4. AUTO STATS
-- ==========================================
local tabStats = UI.CreateTab("Auto Stats", false)
do
    UI.CreateSection(tabStats, "Select Stats")
    UI.CreateToggle(tabStats, "Auto Melee", nil, false, function(on) end)
    UI.CreateToggle(tabStats, "Auto Defense", nil, false, function(on) end)
    UI.CreateToggle(tabStats, "Auto Sword", nil, false, function(on) end)
    UI.CreateToggle(tabStats, "Auto Gun", nil, false, function(on) end)
    UI.CreateToggle(tabStats, "Auto Fruit", nil, false, function(on) end)

    UI.CreateSection(tabStats, "Configuration")
    UI.CreateSlider(tabStats, "Points per second", 1, 100, 1, 1, function(val) end)
end

-- ==========================================
-- 5. TELEPORT
-- ==========================================
local tabTeleport = UI.CreateTab("Teleport", false)
do
    UI.CreateSection(tabTeleport, "World Teleport")
    UI.CreateButton(tabTeleport, "First Sea", nil, function() end)
    UI.CreateButton(tabTeleport, "Second Sea", nil, function() end)
    UI.CreateButton(tabTeleport, "Third Sea", nil, function() end)

    UI.CreateSection(tabTeleport, "Island & NPC")
    UI.CreateDropdown(tabTeleport, "Select Island", {"Island1","Island2","Island3"}, 1, function(val) end)
    UI.CreateButton(tabTeleport, "Teleport", nil, function() end)
    UI.CreateDropdown(tabTeleport, "Select NPC", {"NPC1","NPC2","NPC3"}, 1, function(val) end)
end

-- ==========================================
-- 6. FRUITS / RAID
-- ==========================================
local tabFruit = UI.CreateTab("Fruits / Raid", false)
do
    UI.CreateSection(tabFruit, "Sniper & Store")
    UI.CreateToggle(tabFruit, "Auto Store Fruit", nil, false, function(on) end)
    UI.CreateToggle(tabFruit, "Auto Snipe Fruit", nil, false, function(on) end)
    UI.CreateToggle(tabFruit, "ESP Fruit", nil, false, function(on) end)

    UI.CreateSection(tabFruit, "Auto Raid")
    UI.CreateDropdown(tabFruit, "Select Chip", {"Chip1","Chip2","Chip3"}, 1, function(val) end)
    UI.CreateButton(tabFruit, "Buy Chip", nil, function() end)
    UI.CreateToggle(tabFruit, "Auto Raid", nil, false, function(on) end)
    UI.CreateToggle(tabFruit, "Auto Next Island", nil, false, function(on) end)
    UI.CreateToggle(tabFruit, "Kill Aura (Raid)", nil, false, function(on) end)
end

-- ==========================================
-- 7. VISUAL (ESP)
-- ==========================================
local tabVisual = UI.CreateTab("Visual (ESP)", false)
do
    UI.CreateSection(tabVisual, "ESP Player")
    UI.CreateToggle(tabVisual, "Box", nil, false, function(on) end)
    UI.CreateToggle(tabVisual, "Name", nil, false, function(on) end)
    UI.CreateToggle(tabVisual, "Health", nil, false, function(on) end)
    UI.CreateToggle(tabVisual, "Distance", nil, false, function(on) end)

    UI.CreateSection(tabVisual, "ESP World")
    UI.CreateToggle(tabVisual, "Chest", nil, false, function(on) end)
    UI.CreateToggle(tabVisual, "Fruit", nil, false, function(on) end)
    UI.CreateToggle(tabVisual, "Island", nil, false, function(on) end)
    UI.CreateToggle(tabVisual, "Flowers (V2)", nil, false, function(on) end)
end

-- ==========================================
-- 8. SHOP
-- ==========================================
local tabShop = UI.CreateTab("Shop", false)
do
    UI.CreateSection(tabShop, "Fighting Styles")
    UI.CreateButton(tabShop, "Superhuman", nil, function() end)
    UI.CreateButton(tabShop, "Death Step", nil, function() end)
    UI.CreateButton(tabShop, "Godhuman", nil, function() end)

    UI.CreateSection(tabShop, "Haki & Items")
    UI.CreateButton(tabShop, "Geppo", nil, function() end)
    UI.CreateButton(tabShop, "Buso Haki", nil, function() end)
    UI.CreateButton(tabShop, "Soru", nil, function() end)
end

-- ==========================================
-- 9. MISC (SETTINGS)
-- ==========================================
local tabMisc = UI.CreateTab("Misc", false)
do
    UI.CreateSection(tabMisc, "Player Settings")
    UI.CreateToggle(tabMisc, "No Clip", nil, false, function(on) end)
    UI.CreateToggle(tabMisc, "Infinite Jump", nil, false, function(on) end)
    UI.CreateSlider(tabMisc, "Walkspeed", 16, 200, 16, 1, function(val) end)
    UI.CreateSlider(tabMisc, "JumpPower", 50, 500, 50, 1, function(val) end)

    UI.CreateSection(tabMisc, "Server Settings")
    UI.CreateButton(tabMisc, "Rejoin Server", nil, function() end)
    UI.CreateButton(tabMisc, "Server Hop", nil, function() end)
    UI.CreateButton(tabMisc, "Server Hop (Low Player)", nil, function() end)

    UI.CreateSection(tabMisc, "Code / UI")
    UI.CreateButton(tabMisc, "Redeem All Codes", nil, function() end)
    UI.CreateToggle(tabMisc, "FPS Boost", "Remove Textures", false, function(on) end)
end

warn("[CatHUB v3.0] Part 3 loaded: All tabs initialized. UI fully operational.")