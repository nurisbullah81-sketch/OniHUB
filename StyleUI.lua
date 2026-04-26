-- CatHUB v10.7: FINAL REDZHUB CLONE (Zero Bugs, Perfect Pills, Fixed Crash)
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

-- Cleanup UI Lama
if CoreGui:FindFirstChild("CatUI") then 
    CoreGui.CatUI:Destroy() 
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = CoreGui

-- ==========================================
-- THEME / PALETTE (Sesuai Redz Hub)
-- ==========================================
local Theme = {
    MainBG      = Color3.fromRGB(12, 12, 12),   -- Background Utama Paling Gelap
    SideBG      = Color3.fromRGB(18, 18, 20),   -- Sidebar (Sedikit lebih terang dari MainBG)
    TopBG       = Color3.fromRGB(12, 12, 12),   
    TabOn       = Color3.fromRGB(35, 35, 40),   -- Tab Aktif (Terang jelas)
    TabOff      = Color3.fromRGB(18, 18, 20),   -- Tab Mati (Nyatu sama Sidebar)
    PageBG      = Color3.fromRGB(24, 24, 26),   -- KOTAK KONTEN (Kontras beda dari background utama)
    CardBG      = Color3.fromRGB(32, 32, 36),   -- Kotak Toggle
    CardHov     = Color3.fromRGB(40, 40, 45),   
    Text        = Color3.fromRGB(245, 245, 245),
    TextDim     = Color3.fromRGB(140, 140, 145),
    ToggleOn    = Color3.fromRGB(115, 95, 235), -- UNGU REDZHUB
    ToggleOff   = Color3.fromRGB(70, 70, 75),   -- Abu-abu Toggle Mati (Kelihatan tegas)
    Accent      = Color3.fromRGB(115, 95, 235), 
    Line        = Color3.fromRGB(45, 45, 50)    
}

-- ==========================================
-- FLOATING WIDGET (100% PERMANEN "C")
-- ==========================================
local FloatCont = Instance.new("Frame")
FloatCont.Size = UDim2.new(0, 60, 0, 40) 
FloatCont.Position = UDim2.new(0, 20, 0.5, -20)
FloatCont.BackgroundTransparency = 1
FloatCont.Visible = true
FloatCont.ZIndex = 99999 
FloatCont.Parent = Gui

local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 40, 1, 0)
FloatBtn.Position = UDim2.new(0, 20, 0, 0) 
FloatBtn.BackgroundColor3 = Theme.CardBG
FloatBtn.Text = "C"
FloatBtn.TextColor3 = Theme.Accent
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 20
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 8)
local FloatStroke = Instance.new("UIStroke", FloatBtn)
FloatStroke.Color = Theme.Line
FloatBtn.Parent = FloatCont

local GripLine = Instance.new("Frame")
GripLine.Size = UDim2.new(0, 4, 0, 20)
GripLine.Position = UDim2.new(0, 6, 0.5, -10)
GripLine.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
GripLine.BackgroundTransparency = 0.7 
GripLine.BorderSizePixel = 0
Instance.new("UICorner", GripLine).CornerRadius = UDim.new(1, 0)
GripLine.Parent = FloatCont

local FloatDrag = Instance.new("TextButton")
FloatDrag.Size = UDim2.new(0, 20, 1, 0)
FloatDrag.Position = UDim2.new(0, 0, 0, 0)
FloatDrag.BackgroundTransparency = 1
FloatDrag.Text = ""
FloatDrag.Parent = FloatCont

-- FIX DRAG WIDGET
local draggingFloat = false
local dragStartFloat, startPosFloat

FloatDrag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFloat = true
        dragStartFloat = input.Position
        startPosFloat = FloatCont.Position
    end
end)

UserInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFloat = false
    end
end)

UserInput.InputChanged:Connect(function(input)
    if draggingFloat and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartFloat
        FloatCont.Position = UDim2.new(startPosFloat.X.Scale, startPosFloat.X.Offset + delta.X, startPosFloat.Y.Scale, startPosFloat.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- MAIN FRAME (KOTAK UTAMA UI)
-- ==========================================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 360)
Main.Position = UDim2.new(0.5, -290, 0.5, -180)
Main.BackgroundColor3 = Theme.MainBG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true 
Main.Visible = true 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.Line
Main.Parent = Gui

FloatBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ==========================================
-- TOPBAR & TOMBOL KONTROL
-- ==========================================
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = Theme.TopBG
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)
Top.Parent = Main

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 10)
TopFix.Position = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3 = Theme.TopBG
TopFix.BorderSizePixel = 0
TopFix.Parent = Top

local TitleStr = Instance.new("TextLabel")
TitleStr.Size = UDim2.new(0, 300, 1, 0)
TitleStr.Position = UDim2.new(0, 15, 0, 0)
TitleStr.Text = "CatHub Blox Fruits [Freemium]"
TitleStr.TextColor3 = Theme.Text
TitleStr.Font = Enum.Font.GothamMedium
TitleStr.TextSize = 13
TitleStr.TextXAlignment = Enum.TextXAlignment.Left
TitleStr.BackgroundTransparency = 1
TitleStr.Parent = Top

-- FIX: Tombol X Pakai huruf "X" biar ga ngebug jadi kotak
local BtnX = Instance.new("TextButton")
BtnX.Size = UDim2.new(0, 35, 0, 35)
BtnX.Position = UDim2.new(1, -35, 0, 0)
BtnX.Text = "X" 
BtnX.TextColor3 = Theme.TextDim
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 14
BtnX.Parent = Top

local BtnM = Instance.new("TextButton")
BtnM.Size = UDim2.new(0, 35, 0, 35)
BtnM.Position = UDim2.new(1, -70, 0, 0)
BtnM.Text = "—"
BtnM.TextColor3 = Theme.TextDim
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.GothamBold
BtnM.TextSize = 14
BtnM.Parent = Top

BtnX.MouseEnter:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play() end)
BtnX.MouseLeave:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play() end)
BtnM.MouseEnter:Connect(function() TweenService:Create(BtnM, TweenInfo.new(0.15), {TextColor3 = Theme.Text}):Play() end)
BtnM.MouseLeave:Connect(function() TweenService:Create(BtnM, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play() end)

BtnX.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

local isMin = false
local lastSize = Main.Size
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        lastSize = Main.Size
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, Main.Size.X.Offset, 0, 35)}):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = lastSize}):Play()
    end
end)

-- FIX: Drag UI Utama (Pake InputBegan biar nggak crash)
local draggingMain = false
local dragStartMain, startPosMain

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = Main.Position
    end
end)

UserInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = false
    end
end)

UserInput.InputChanged:Connect(function(input)
    if draggingMain and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartMain
        Main.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- RESIZER (POJOK KANAN BAWAH)
-- ==========================================
local Resizer = Instance.new("TextButton")
Resizer.Size = UDim2.new(0, 25, 0, 25)
Resizer.Position = UDim2.new(1, -25, 1, -25)
Resizer.BackgroundTransparency = 1
Resizer.Text = "⌟"
Resizer.TextColor3 = Theme.TextDim
Resizer.TextSize = 18
Resizer.Font = Enum.Font.Gotham
Resizer.ZIndex = 50
Resizer.Parent = Main

local isResizing = false
local resizeStart, startSizeR

Resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not isMin then
        isResizing = true
        resizeStart = input.Position
        startSizeR = Main.Size
    end
end)

UserInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isResizing = false
    end
end)

UserInput.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStart
        local newX = math.clamp(startSizeR.X.Offset + delta.X, 500, 1000)
        local newY = math.clamp(startSizeR.Y.Offset + delta.Y, 300, 800)
        Main.Size = UDim2.new(0, newX, 0, newY)
        lastSize = Main.Size
    end
end)

-- ==========================================
-- SIDEBAR & AREA KONTEN
-- ==========================================
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -35)
ContentContainer.Position = UDim2.new(0, 0, 0, 35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = Main

local Side = Instance.new("Frame")
Side.Size = UDim2.new(0, 150, 1, 0) 
Side.BackgroundColor3 = Theme.SideBG
Side.BorderSizePixel = 0
Side.Parent = ContentContainer

local SideLine = Instance.new("Frame")
SideLine.Size = UDim2.new(0, 1, 1, 0)
SideLine.Position = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3 = Theme.Line
SideLine.BorderSizePixel = 0
SideLine.Parent = Side

local SideScroll = Instance.new("ScrollingFrame")
SideScroll.Size = UDim2.new(1, 0, 1, 0)
SideScroll.BackgroundTransparency = 1
SideScroll.ScrollBarThickness = 0
SideScroll.BorderSizePixel = 0
SideScroll.Parent = Side

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 6)
SideList.Parent = SideScroll

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 12)
SidePad.PaddingLeft = UDim.new(0, 10)
SidePad.PaddingRight = UDim.new(0, 10)
SidePad.Parent = SideScroll

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -150, 1, 0)
ContentArea.Position = UDim2.new(0, 150, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = ContentContainer

local Pages = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = isFirst and Theme.TabOn or Theme.TabOff 
    Btn.Text = "    " .. name
    Btn.TextColor3 = isFirst and Theme.Text or Theme.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.Parent = SideScroll
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0, 16)
    Indicator.Position = UDim2.new(0, 5, 0.5, -8)
    Indicator.BackgroundColor3 = Theme.Accent
    Indicator.BorderSizePixel = 0
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    Indicator.Visible = isFirst
    Indicator.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        if not Indicator.Visible then TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardHov}):Play() end
    end)
    Btn.MouseLeave:Connect(function()
        if not Indicator.Visible then TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabOff}):Play() end
    end)
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -20, 1, -20) 
    Page.Position = UDim2.new(0, 10, 0, 10) 
    Page.BackgroundColor3 = Theme.PageBG 
    Page.BackgroundTransparency = 0 
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Theme.TextDim 
    Page.Visible = isFirst
    Page.BorderSizePixel = 0
    Instance.new("UICorner", Page).CornerRadius = UDim.new(0, 8)
    local PageStroke = Instance.new("UIStroke", Page)
    PageStroke.Color = Theme.Line
    Page.Parent = ContentArea

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 8) 
    List.Parent = Page
    
    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop = UDim.new(0, 12)
    Pad.PaddingLeft = UDim.new(0, 12)
    Pad.PaddingRight = UDim.new(0, 16) 
    Pad.PaddingBottom = UDim.new(0, 12)
    Pad.Parent = Page
    
    Pages[name] = {Btn = Btn, Page = Page, Ind = Indicator}
    
    Btn.MouseButton1Click:Connect(function()
        for tName, data in pairs(Pages) do
            local active = (tName == name)
            data.Page.Visible = active
            data.Ind.Visible = active
            TweenService:Create(data.Btn, TweenInfo.new(0.15), {
                BackgroundColor3 = active and Theme.TabOn or Theme.TabOff,
                TextColor3 = active and Theme.Text or Theme.TextDim
            }):Play()
        end
    end)
    
    return Page
end

local function CreateSection(parent, text)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 26) 
    F.BackgroundTransparency = 1
    F.Parent = parent
    
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Position = UDim2.new(0, 2, 0, 0)
    L.Text = text
    L.TextColor3 = Theme.TextDim
    L.Font = Enum.Font.GothamBold
    L.TextSize = 11 
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F
end

-- ==========================================
-- TOGGLE KONTROL (BULAT SEMPURNA / PILL)
-- ==========================================
local function CreateToggle(parent, text, stateRef, callback)
    local F = Instance.new("TextButton")
    F.Size = UDim2.new(1, 0, 0, 40)
    F.BackgroundColor3 = Theme.CardBG
    F.BorderSizePixel = 0
    F.Text = ""
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", F)
    Stroke.Color = Theme.Line
    F.Parent = parent
    
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -70, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.Text = text
    L.TextColor3 = Theme.Text
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F
    
    -- FIX: PILL SHAPE (Bulat Kapsul) Menggunakan UDim.new(1, 0)
    local Sw = Instance.new("Frame")
    Sw.Size = UDim2.new(0, 38, 0, 20)
    Sw.Position = UDim2.new(1, -52, 0.5, -10)
    Sw.BackgroundColor3 = stateRef and Theme.ToggleOn or Theme.ToggleOff
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0) 
    Sw.Parent = F
    
    -- FIX: LINGKARAN SEMPURNA Menggunakan UDim.new(1, 0)
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = stateRef and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0) 
    Dot.Parent = Sw
    
    F.MouseEnter:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardHov}):Play() end)
    F.MouseLeave:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardBG}):Play() end)
    
    F.MouseButton1Click:Connect(function()
        stateRef = not stateRef
        TweenService:Create(Sw, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = stateRef and Theme.ToggleOn or Theme.ToggleOff}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = stateRef and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        if callback then callback(stateRef) end
    end)
end

-- ==========================================
-- BUILD TABS 
-- ==========================================
local StatusTab = CreateTab("Status", true) 
local DevilFruitsTab = CreateTab("Devil Fruits", false) 

CreateSection(StatusTab, "PLAYER STATUS")
CreateToggle(StatusTab, "Tampilkan Statistik Pemain", false, function(state)
    -- Logic 
end)

CreateSection(DevilFruitsTab, "DEVIL FRUITS")
CreateToggle(DevilFruitsTab, "ESP Buah (Teks Saja)", false, function(state)
    -- Logic 
end)