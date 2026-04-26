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
-- PALETTE — RedzHub Accurate
-- ==========================================
local C = {
    Base     = Color3.fromRGB(20, 22, 34),     -- bg utama (navy gelap)
    Side     = Color3.fromRGB(15, 16, 26),     -- sidebar lebih gelap
    Top      = Color3.fromRGB(16, 18, 28),     -- topbar
    Card     = Color3.fromRGB(28, 31, 46),     -- row/card default
    CardHov  = Color3.fromRGB(36, 40, 58),     -- card hover
    CardOn   = Color3.fromRGB(22, 32, 60),     -- card ketika toggle ON
    Text     = Color3.fromRGB(200, 205, 225),  -- teks primer
    TextSec  = Color3.fromRGB(125, 132, 165),  -- teks sekunder / label bawah
    TextDim  = Color3.fromRGB(68, 74, 108),    -- inactive / dim
    Blue     = Color3.fromRGB(58, 108, 240),   -- toggle ON / accent utama
    BlueDim  = Color3.fromRGB(38, 75, 175),    -- border saat ON
    Off      = Color3.fromRGB(38, 41, 60),     -- toggle OFF track
    Divider  = Color3.fromRGB(34, 38, 56),     -- garis pemisah
    SideActv = Color3.fromRGB(20, 22, 38),     -- bg tab aktif di sidebar
    SecTitle = Color3.fromRGB(100, 108, 145),  -- judul section
    Dot      = Color3.fromRGB(255, 255, 255),  -- dot toggle
}

-- ==========================================
-- TOMBOL REOPEN (BISA DIGESER)
-- ==========================================
local OpenBtn = Instance.new("Frame", Gui)
OpenBtn.Size = UDim2.new(0, 96, 0, 28)
OpenBtn.Position = UDim2.new(0, 100, 0.5, 0)
OpenBtn.BackgroundColor3 = C.Top
OpenBtn.BorderSizePixel = 0
OpenBtn.Visible = false

local OBCorner = Instance.new("UICorner", OpenBtn)
OBCorner.CornerRadius = UDim.new(0, 6)

-- Border tipis di sekeliling tombol reopen
local OBStroke = Instance.new("UIStroke", OpenBtn)
OBStroke.Color = C.Divider
OBStroke.Thickness = 1
OBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local OpenText = Instance.new("TextLabel", OpenBtn)
OpenText.Size = UDim2.new(1, 0, 1, 0)
OpenText.Text = "CatHUB"
OpenText.TextColor3 = C.Blue
OpenText.Font = Enum.Font.GothamBold
OpenText.TextSize = 12
OpenText.BackgroundTransparency = 1

local OpenHitbox = Instance.new("TextButton", OpenBtn)
OpenHitbox.Size = UDim2.new(1, 0, 1, 0)
OpenHitbox.BackgroundTransparency = 1
OpenHitbox.Text = ""

-- Drag Reopen Button
local openDrag, openDragStart, openStartPos
OpenHitbox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        openDrag = true; openDragStart = input.Position; openStartPos = OpenBtn.Position
    end
end)
OpenHitbox.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then openDrag = false end end)
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
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 560, 0, 400)
Main.Position = UDim2.new(0.5, -280, 0.5, -200)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 8)

-- Border luar tipis sekeliling window
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(42, 46, 70)
MainStroke.Thickness = 1
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ==========================================
-- TOP BAR
-- ==========================================
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 34)
Top.BackgroundColor3 = C.Top
Top.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner", Top)
TopCorner.CornerRadius = UDim.new(0, 8)

-- Garis bawah topbar
local TopLine = Instance.new("Frame", Top)
TopLine.Size = UDim2.new(1, 0, 0, 1)
TopLine.Position = UDim2.new(0, 0, 1, -1)
TopLine.BackgroundColor3 = C.Divider
TopLine.BorderSizePixel = 0

-- Dot merah kecil di kiri (estetik mirip referensi)
local TitleDot = Instance.new("Frame", Top)
TitleDot.Size = UDim2.new(0, 8, 0, 8)
TitleDot.Position = UDim2.new(0, 12, 0.5, -4)
TitleDot.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
TitleDot.BorderSizePixel = 0
Instance.new("UICorner", TitleDot).CornerRadius = UDim.new(1, 0)

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -80, 1, 0)
Ttl.Position = UDim2.new(0, 26, 0, 0)
Ttl.Text = "CatHUB  |  Blox Fruits"
Ttl.TextColor3 = C.Text
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 12
Ttl.TextXAlignment = Enum.TextXAlignment.Left
Ttl.BackgroundTransparency = 1

-- Tombol X
local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 28, 0, 28)
BtnX.Position = UDim2.new(1, -32, 0.5, -14)
BtnX.Text = "x"
BtnX.TextColor3 = C.TextDim
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 14

-- Tombol Minimize
local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 28, 0, 28)
BtnM.Position = UDim2.new(1, -60, 0.5, -14)
BtnM.Text = "-"
BtnM.TextColor3 = C.TextDim
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.GothamBold
BtnM.TextSize = 16

BtnX.MouseEnter:Connect(function()
    TweenService:Create(BtnX, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255, 85, 85)}):Play()
end)
BtnX.MouseLeave:Connect(function()
    TweenService:Create(BtnX, TweenInfo.new(0.12), {TextColor3 = C.TextDim}):Play()
end)
BtnM.MouseEnter:Connect(function()
    TweenService:Create(BtnM, TweenInfo.new(0.12), {TextColor3 = C.TextSec}):Play()
end)
BtnM.MouseLeave:Connect(function()
    TweenService:Create(BtnM, TweenInfo.new(0.12), {TextColor3 = C.TextDim}):Play()
end)

-- Close
BtnX.MouseButton1Click:Connect(function()
    OpenBtn.Position = UDim2.new(0, Main.Position.X.Offset, 0, Main.Position.Y.Offset)
    Main.Visible = false
    OpenBtn.Visible = true
end)

-- Minimize
local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, Main.Size.X.Offset, 0, 34)
        }):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, Main.Size.X.Offset, 0, 400)
        }):Play()
    end
end)

-- Hotkey
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
Resizer.Size = UDim2.new(0, 18, 0, 18)
Resizer.Position = UDim2.new(1, -18, 1, -18)
Resizer.BackgroundTransparency = 1
Resizer.Text = "/"
Resizer.TextColor3 = C.TextDim
Resizer.TextSize = 12
Resizer.Font = Enum.Font.Gotham

local isResizing, resizeStart, startSize
Resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isResizing = true
        resizeStart = input.Position
        startSize = Main.Size
    end
end)
Resizer.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end
end)
UserInput.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local dx = input.Position.X - resizeStart.X
        local dy = input.Position.Y - resizeStart.Y
        local newX = math.clamp(startSize.X.Offset + dx, 460, 900)
        local newY = math.clamp(startSize.Y.Offset + dy, 260, 700)
        Main.Size = UDim2.new(0, newX, 0, newY)
    end
end)

-- ==========================================
-- SIDEBAR
-- ==========================================
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 120, 1, -34)
Side.Position = UDim2.new(0, 0, 0, 34)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0

-- Garis kanan sidebar
local SideLine = Instance.new("Frame", Side)
SideLine.Size = UDim2.new(0, 1, 1, 0)
SideLine.Position = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3 = C.Divider
SideLine.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 2)

local SidePad = Instance.new("UIPadding", Side)
SidePad.PaddingTop = UDim.new(0, 8)
SidePad.PaddingLeft = UDim.new(0, 6)
SidePad.PaddingRight = UDim.new(0, 6)

-- ==========================================
-- TABEL ACTIVE BARS — untuk toggle per tab
-- ==========================================
local ActiveBars = {}
local Pages = {}

local function CreateTab(name, isFirst)
    -- Container tab button
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, -12, 0, 30)
    Btn.BackgroundColor3 = isFirst and C.SideActv or C.Side
    Btn.Text = ""
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    -- Label teks tab
    local BtnLbl = Instance.new("TextLabel", Btn)
    BtnLbl.Size = UDim2.new(1, -10, 1, 0)
    BtnLbl.Position = UDim2.new(0, 14, 0, 0)
    BtnLbl.Text = name
    BtnLbl.TextColor3 = isFirst and C.Text or C.TextDim
    BtnLbl.Font = Enum.Font.Gotham
    BtnLbl.TextSize = 12
    BtnLbl.TextXAlignment = Enum.TextXAlignment.Left
    BtnLbl.BackgroundTransparency = 1

    -- Accent bar kiri (hanya muncul saat tab aktif)
    local AccBar = Instance.new("Frame", Btn)
    AccBar.Size = UDim2.new(0, 2, 1, -8)
    AccBar.Position = UDim2.new(0, 0, 0, 4)
    AccBar.BackgroundColor3 = C.Blue
    AccBar.BorderSizePixel = 0
    AccBar.Visible = isFirst
    Instance.new("UICorner", AccBar).CornerRadius = UDim.new(0, 1)

    ActiveBars[name] = {Bar = AccBar, Lbl = BtnLbl, Btn = Btn}

    -- Hover
    Btn.MouseEnter:Connect(function()
        if Pages[name] and Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.CardHov}):Play()
        TweenService:Create(BtnLbl, TweenInfo.new(0.1), {TextColor3 = C.TextSec}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if Pages[name] and Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Side}):Play()
        TweenService:Create(BtnLbl, TweenInfo.new(0.1), {TextColor3 = C.TextDim}):Play()
    end)

    -- Halaman konten
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Name = name .. "Pg"
    Page.Size = UDim2.new(1, -138, 1, -42)
    Page.Position = UDim2.new(0, 128, 0, 38)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = C.TextDim
    Page.Visible = isFirst
    Page.BorderSizePixel = 0
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 5)

    local Pad = Instance.new("UIPadding", Page)
    Pad.PaddingTop = UDim.new(0, 6)
    Pad.PaddingBottom = UDim.new(0, 8)
    Pad.PaddingRight = UDim.new(0, 6)

    Pages[name] = Page

    Btn.MouseButton1Click:Connect(function()
        -- Sembunyikan semua page & reset semua tab
        for tName, pPage in pairs(Pages) do
            pPage.Visible = (tName == name)
        end
        for tName, data in pairs(ActiveBars) do
            local isActive = (tName == name)
            data.Bar.Visible = isActive
            TweenService:Create(data.Btn, TweenInfo.new(0.12), {
                BackgroundColor3 = isActive and C.SideActv or C.Side
            }):Play()
            TweenService:Create(data.Lbl, TweenInfo.new(0.12), {
                TextColor3 = isActive and C.Text or C.TextDim
            }):Play()
        end
    end)

    return Page
end

-- ==========================================
-- SECTION HEADER
-- ==========================================
local function Section(parent, text)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 22)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0

    -- Garis kiri pendek berwarna biru
    local Accent = Instance.new("Frame", F)
    Accent.Size = UDim2.new(0, 2, 0, 10)
    Accent.Position = UDim2.new(0, 0, 0.5, -5)
    Accent.BackgroundColor3 = C.Blue
    Accent.BorderSizePixel = 0
    Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 1)

    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -8, 1, 0)
    L.Position = UDim2.new(0, 8, 0, 0)
    L.Text = string.upper(text)
    L.TextColor3 = C.SecTitle
    L.Font = Enum.Font.GothamBold
    L.TextSize = 10
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1

    -- Garis bawah tipis
    local Line = Instance.new("Frame", F)
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 1, -1)
    Line.BackgroundColor3 = C.Divider
    Line.BorderSizePixel = 0
end

-- ==========================================
-- TOGGLE ROW
-- ==========================================
local function Toggle(parent, key, text, subtext)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, 0, 0, subtext and 42 or 36)
    F.BackgroundColor3 = S[key] and C.CardOn or C.Card
    F.BorderSizePixel = 0
    F.Text = ""
    F.AutoButtonColor = false

    local FCorner = Instance.new("UICorner", F)
    FCorner.CornerRadius = UDim.new(0, 6)

    -- Border tipis — biru kalau ON, divider kalau OFF
    local FStroke = Instance.new("UIStroke", F)
    FStroke.Color = S[key] and C.BlueDim or C.Divider
    FStroke.Thickness = 1
    FStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Label utama
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -58, 0, 18)
    L.Position = UDim2.new(0, 12, 0, subtext and 6 or 9)
    L.Text = text
    L.TextColor3 = S[key] and C.Text or Color3.fromRGB(150, 158, 190)
    L.Font = Enum.Font.Gotham
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1

    -- Sub-label (opsional)
    if subtext then
        local Sub = Instance.new("TextLabel", F)
        Sub.Size = UDim2.new(1, -58, 0, 14)
        Sub.Position = UDim2.new(0, 12, 0, 22)
        Sub.Text = subtext
        Sub.TextColor3 = C.TextDim
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 10
        Sub.TextXAlignment = Enum.TextXAlignment.Left
        Sub.BackgroundTransparency = 1
    end

    -- Track toggle
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 36, 0, 18)
    Sw.Position = UDim2.new(1, -46, 0.5, -9)
    Sw.BackgroundColor3 = S[key] and C.Blue or C.Off
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)

    -- Dot toggle
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 12, 0, 12)
    Dot.Position = S[key] and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    Dot.BackgroundColor3 = C.Dot
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    -- Hover
    F.MouseEnter:Connect(function()
        TweenService:Create(F, TweenInfo.new(0.1), {
            BackgroundColor3 = S[key] and C.CardOn or C.CardHov
        }):Play()
    end)
    F.MouseLeave:Connect(function()
        TweenService:Create(F, TweenInfo.new(0.1), {
            BackgroundColor3 = S[key] and C.CardOn or C.Card
        }):Play()
    end)

    -- Klik toggle
    F.MouseButton1Click:Connect(function()
        S[key] = not S[key]

        TweenService:Create(Dot, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
            Position = S[key] and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.14), {
            BackgroundColor3 = S[key] and C.Blue or C.Off
        }):Play()
        TweenService:Create(F, TweenInfo.new(0.14), {
            BackgroundColor3 = S[key] and C.CardOn or C.Card
        }):Play()
        TweenService:Create(L, TweenInfo.new(0.14), {
            TextColor3 = S[key] and C.Text or Color3.fromRGB(150, 158, 190)
        }):Play()

        FStroke.Color = S[key] and C.BlueDim or C.Divider
    end)
end

-- ==========================================
-- TABS & KONTEN
-- ==========================================
local EspPage = CreateTab("ESP", true)

Section(EspPage, "Devil Fruits")
Toggle(EspPage, "FruitESP", "Fruit ESP", "Tampilkan buah yang spawn")

-- ==========================================
-- DRAG MAIN FRAME
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