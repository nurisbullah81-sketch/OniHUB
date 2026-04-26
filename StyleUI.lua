-- CatHUB v9.3: RedzHub Remake (Resizable + No Clip Minimize + Draggable Reopen)
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ==========================================
-- PALETTE — Persis RedzHub dari screenshot
-- NO UIStroke anywhere, flat design only
-- ==========================================
local C = {
    Win      = Color3.fromRGB(26, 29, 44),    -- bg window
    Side     = Color3.fromRGB(20, 23, 36),    -- sidebar (lebih gelap)
    TopBar   = Color3.fromRGB(22, 25, 38),    -- topbar
    Row      = Color3.fromRGB(30, 34, 50),    -- bg row
    RowHov   = Color3.fromRGB(36, 40, 58),    -- row hover
    RowOn    = Color3.fromRGB(24, 34, 62),    -- row toggle ON
    Divider  = Color3.fromRGB(38, 42, 60),    -- garis 1px
    Text     = Color3.fromRGB(215, 218, 235), -- teks aktif
    TextSec  = Color3.fromRGB(130, 136, 165), -- teks row (off state)
    TextDim  = Color3.fromRGB(70, 76, 105),   -- sidebar inactive / sec title
    TrackOn  = Color3.fromRGB(40, 80, 210),   -- track ON
    TrackOff = Color3.fromRGB(48, 52, 72),    -- track OFF
    Dot      = Color3.fromRGB(240, 242, 255), -- dot toggle
    Logo     = Color3.fromRGB(210, 50, 50),   -- logo RZ merah
    VerColor = Color3.fromRGB(70, 76, 105),   -- versi
}

-- ==========================================
-- REOPEN BUTTON
-- ==========================================
local OpenBtn = Instance.new("Frame", Gui)
OpenBtn.Size = UDim2.new(0, 90, 0, 26)
OpenBtn.Position = UDim2.new(0, 100, 0.5, 0)
OpenBtn.BackgroundColor3 = C.TopBar
OpenBtn.BorderSizePixel = 0
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 5)

local OpenText = Instance.new("TextLabel", OpenBtn)
OpenText.Size = UDim2.new(1, 0, 1, 0)
OpenText.Text = "CatHUB"
OpenText.TextColor3 = C.TrackOn
OpenText.Font = Enum.Font.GothamBold
OpenText.TextSize = 11
OpenText.BackgroundTransparency = 1

local OpenHitbox = Instance.new("TextButton", OpenBtn)
OpenHitbox.Size = UDim2.new(1, 0, 1, 0)
OpenHitbox.BackgroundTransparency = 1
OpenHitbox.Text = ""

local openDrag, openDragStart, openStartPos
OpenHitbox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        openDrag = true; openDragStart = input.Position; openStartPos = OpenBtn.Position
    end
end)
OpenHitbox.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then openDrag = false end
end)
UserInput.InputChanged:Connect(function(input)
    if openDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - openDragStart
        OpenBtn.Position = UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset + d.X, openStartPos.Y.Scale, openStartPos.Y.Offset + d.Y)
    end
end)
OpenHitbox.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- ==========================================
-- MAIN WINDOW
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 560, 0, 420)
Main.Position = UDim2.new(0.5, -280, 0.5, -210)
Main.BackgroundColor3 = C.Win
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- TOPBAR
-- ==========================================
local Top = Instance.new("Frame", Main)
Top.Name = "Top"
Top.Size = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = C.TopBar
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

-- Garis bawah topbar
local TopDiv = Instance.new("Frame", Top)
TopDiv.Size = UDim2.new(1, 0, 0, 1)
TopDiv.Position = UDim2.new(0, 0, 1, -1)
TopDiv.BackgroundColor3 = C.Divider
TopDiv.BorderSizePixel = 0

-- Logo "RZ" merah — persis Redz Hub
local LogoBox = Instance.new("Frame", Top)
LogoBox.Size = UDim2.new(0, 24, 0, 24)
LogoBox.Position = UDim2.new(0, 10, 0.5, -12)
LogoBox.BackgroundColor3 = C.Logo
LogoBox.BorderSizePixel = 0
Instance.new("UICorner", LogoBox).CornerRadius = UDim.new(0, 4)

local LogoLbl = Instance.new("TextLabel", LogoBox)
LogoLbl.Size = UDim2.new(1, 0, 1, 0)
LogoLbl.Text = "RZ"
LogoLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoLbl.Font = Enum.Font.GothamBold
LogoLbl.TextSize = 9
LogoLbl.BackgroundTransparency = 1

-- Judul bold
local TitleBold = Instance.new("TextLabel", Top)
TitleBold.Size = UDim2.new(0, 80, 1, 0)
TitleBold.Position = UDim2.new(0, 42, 0, 0)
TitleBold.Text = "CatHUB"
TitleBold.TextColor3 = C.Text
TitleBold.Font = Enum.Font.GothamBold
TitleBold.TextSize = 13
TitleBold.TextXAlignment = Enum.TextXAlignment.Left
TitleBold.BackgroundTransparency = 1

-- Subtitle dim
local TitleDim = Instance.new("TextLabel", Top)
TitleDim.Size = UDim2.new(0, 200, 1, 0)
TitleDim.Position = UDim2.new(0, 124, 0, 0)
TitleDim.Text = "[BETA]  :  Blox Fruits"
TitleDim.TextColor3 = C.TextDim
TitleDim.Font = Enum.Font.Gotham
TitleDim.TextSize = 12
TitleDim.TextXAlignment = Enum.TextXAlignment.Left
TitleDim.BackgroundTransparency = 1

-- Tombol close
local BtnClose = Instance.new("TextButton", Top)
BtnClose.Size = UDim2.new(0, 26, 0, 26)
BtnClose.Position = UDim2.new(1, -30, 0.5, -13)
BtnClose.Text = "x"
BtnClose.TextColor3 = C.TextDim
BtnClose.BackgroundTransparency = 1
BtnClose.Font = Enum.Font.GothamBold
BtnClose.TextSize = 14
BtnClose.BorderSizePixel = 0

-- Tombol minimize
local BtnMin = Instance.new("TextButton", Top)
BtnMin.Size = UDim2.new(0, 26, 0, 26)
BtnMin.Position = UDim2.new(1, -56, 0.5, -13)
BtnMin.Text = "-"
BtnMin.TextColor3 = C.TextDim
BtnMin.BackgroundTransparency = 1
BtnMin.Font = Enum.Font.GothamBold
BtnMin.TextSize = 16
BtnMin.BorderSizePixel = 0

BtnClose.MouseEnter:Connect(function() TweenService:Create(BtnClose, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play() end)
BtnClose.MouseLeave:Connect(function() TweenService:Create(BtnClose, TweenInfo.new(0.1), {TextColor3 = C.TextDim}):Play() end)

BtnClose.MouseButton1Click:Connect(function()
    OpenBtn.Position = UDim2.new(0, Main.Position.X.Offset, 0, Main.Position.Y.Offset)
    Main.Visible = false
    OpenBtn.Visible = true
end)

local isMin = false
BtnMin.MouseButton1Click:Connect(function()
    isMin = not isMin
    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = isMin
            and UDim2.new(0, Main.Size.X.Offset, 0, 38)
            or  UDim2.new(0, Main.Size.X.Offset, 0, 420)
    }):Play()
end)

UserInput.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if Main.Visible then
            OpenBtn.Position = UDim2.new(0, Main.Position.X.Offset, 0, Main.Position.Y.Offset)
        end
        Main.Visible = not Main.Visible
        OpenBtn.Visible = not Main.Visible
    end
end)

-- ==========================================
-- RESIZE HANDLE
-- ==========================================
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 16, 0, 16)
Resizer.Position = UDim2.new(1, -16, 1, -16)
Resizer.BackgroundTransparency = 1
Resizer.Text = "/"
Resizer.TextColor3 = C.TextDim
Resizer.TextSize = 11
Resizer.Font = Enum.Font.Gotham
Resizer.BorderSizePixel = 0

local isResizing, resizeStart, startSize
Resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isResizing = true; resizeStart = input.Position; startSize = Main.Size
    end
end)
Resizer.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end
end)
UserInput.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local dx = input.Position.X - resizeStart.X
        local dy = input.Position.Y - resizeStart.Y
        Main.Size = UDim2.new(0, math.clamp(startSize.X.Offset + dx, 460, 900), 0, math.clamp(startSize.Y.Offset + dy, 260, 700))
    end
end)

-- ==========================================
-- SIDEBAR — cuma text, FLAT, tanpa kotak
-- ==========================================
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 115, 1, -56)  -- 38 top + 18 bottom
Side.Position = UDim2.new(0, 0, 0, 38)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0

-- Garis kanan sidebar (1px Frame, bukan UIStroke)
local SideDiv = Instance.new("Frame", Side)
SideDiv.Size = UDim2.new(0, 1, 1, 0)
SideDiv.Position = UDim2.new(1, -1, 0, 0)
SideDiv.BackgroundColor3 = C.Divider
SideDiv.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 0)

local SidePad = Instance.new("UIPadding", Side)
SidePad.PaddingTop = UDim.new(0, 10)

-- ==========================================
-- BOTTOM BAR
-- ==========================================
local BottomBar = Instance.new("Frame", Main)
BottomBar.Size = UDim2.new(1, 0, 0, 18)
BottomBar.Position = UDim2.new(0, 0, 1, -18)
BottomBar.BackgroundColor3 = C.TopBar
BottomBar.BorderSizePixel = 0

local BotDiv = Instance.new("Frame", BottomBar)
BotDiv.Size = UDim2.new(1, 0, 0, 1)
BotDiv.BackgroundColor3 = C.Divider
BotDiv.BorderSizePixel = 0

local VerLbl = Instance.new("TextLabel", BottomBar)
VerLbl.Size = UDim2.new(1, -12, 1, 0)
VerLbl.Text = "v2.4.1 — cathub"
VerLbl.TextColor3 = C.VerColor
VerLbl.Font = Enum.Font.Gotham
VerLbl.TextSize = 10
VerLbl.TextXAlignment = Enum.TextXAlignment.Right
VerLbl.BackgroundTransparency = 1

-- ==========================================
-- TAB SYSTEM
-- ==========================================
local Pages   = {}
local TabLbls = {}

local function CreateTab(name, isFirst)
    -- Sidebar button: NO background, hanya warna text berubah
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, -1, 0, 32)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false

    local Lbl = Instance.new("TextLabel", Btn)
    Lbl.Size = UDim2.new(1, -16, 1, 0)
    Lbl.Position = UDim2.new(0, 16, 0, 0)
    Lbl.Text = name
    Lbl.TextColor3 = isFirst and C.Text or C.TextDim
    Lbl.Font = isFirst and Enum.Font.GothamSemibold or Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    TabLbls[name] = Lbl

    Btn.MouseEnter:Connect(function()
        if Pages[name] and Pages[name].Visible then return end
        TweenService:Create(Lbl, TweenInfo.new(0.1), {TextColor3 = C.TextSec}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if Pages[name] and Pages[name].Visible then return end
        TweenService:Create(Lbl, TweenInfo.new(0.1), {TextColor3 = C.TextDim}):Play()
    end)

    -- Halaman
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Name = name .. "Pg"
    Page.Size = UDim2.new(1, -124, 1, -60)
    Page.Position = UDim2.new(0, 120, 0, 42)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = C.TextDim
    Page.Visible = isFirst
    Page.BorderSizePixel = 0
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)

    local PList = Instance.new("UIListLayout", Page)
    PList.Padding = UDim.new(0, 4)

    local PPad = Instance.new("UIPadding", Page)
    PPad.PaddingTop = UDim.new(0, 6)
    PPad.PaddingBottom = UDim.new(0, 8)
    PPad.PaddingRight = UDim.new(0, 10)

    Pages[name] = Page

    Btn.MouseButton1Click:Connect(function()
        for tName, pg in pairs(Pages) do pg.Visible = (tName == name) end
        for tName, lbl in pairs(TabLbls) do
            local act = (tName == name)
            TweenService:Create(lbl, TweenInfo.new(0.12), {
                TextColor3 = act and C.Text or C.TextDim
            }):Play()
            lbl.Font = act and Enum.Font.GothamSemibold or Enum.Font.Gotham
        end
    end)

    return Page
end

-- ==========================================
-- SECTION HEADER — uppercase, flat, no deco
-- ==========================================
local function Section(parent, text)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 26)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0

    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Text = string.upper(text)
    L.TextColor3 = C.TextDim
    L.Font = Enum.Font.GothamSemibold
    L.TextSize = 10
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
end

-- ==========================================
-- TOGGLE — flat, NO UIStroke, clean pill
-- ==========================================
local function Toggle(parent, key, text, subtext)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, 0, 0, subtext and 44 or 36)
    F.BackgroundColor3 = S[key] and C.RowOn or C.Row
    F.BorderSizePixel = 0
    F.Text = ""
    F.AutoButtonColor = false
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel", F)
    Lbl.Size = UDim2.new(1, -58, 0, 18)
    Lbl.Position = UDim2.new(0, 14, 0, subtext and 7 or 9)
    Lbl.Text = text
    Lbl.TextColor3 = S[key] and C.Text or C.TextSec
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    if subtext then
        local Sub = Instance.new("TextLabel", F)
        Sub.Size = UDim2.new(1, -58, 0, 14)
        Sub.Position = UDim2.new(0, 14, 0, 23)
        Sub.Text = subtext
        Sub.TextColor3 = C.TextDim
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 10
        Sub.TextXAlignment = Enum.TextXAlignment.Left
        Sub.BackgroundTransparency = 1
    end

    -- Track
    local Track = Instance.new("Frame", F)
    Track.Size = UDim2.new(0, 38, 0, 20)
    Track.Position = UDim2.new(1, -48, 0.5, -10)
    Track.BackgroundColor3 = S[key] and C.TrackOn or C.TrackOff
    Track.BorderSizePixel = 0
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    -- Dot
    local Dot = Instance.new("Frame", Track)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = S[key] and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    Dot.BackgroundColor3 = C.Dot
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    F.MouseEnter:Connect(function()
        TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = C.RowHov}):Play()
    end)
    F.MouseLeave:Connect(function()
        TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = S[key] and C.RowOn or C.Row}):Play()
    end)

    F.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Dot, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
            Position = S[key] and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        }):Play()
        TweenService:Create(Track, TweenInfo.new(0.14), {
            BackgroundColor3 = S[key] and C.TrackOn or C.TrackOff
        }):Play()
        TweenService:Create(F, TweenInfo.new(0.14), {
            BackgroundColor3 = S[key] and C.RowOn or C.Row
        }):Play()
        TweenService:Create(Lbl, TweenInfo.new(0.14), {
            TextColor3 = S[key] and C.Text or C.TextSec
        }):Play()
    end)
end

-- ==========================================
-- TABS — isi sesuai kebutuhan proyek
-- ==========================================
local EspPage = CreateTab("ESP", true)

Section(EspPage, "Devil Fruits")
Toggle(EspPage, "FruitESP", "Fruit ESP", "Tampilkan buah yang spawn")

-- ==========================================
-- DRAG
-- ==========================================
local dragging, dragStart, startPos
Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
Top.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)