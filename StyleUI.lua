-- CatHUB v9.7: Pure Dark, Perfect Toggle, Working Resizer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then 
    CoreGui.CatUI:Destroy() 
end

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Palette Hitam Pekat & Abu Gelap
local Theme = {
    MainBG      = Color3.fromRGB(12, 12, 12),
    SideBG      = Color3.fromRGB(16, 16, 16),
    TopBG       = Color3.fromRGB(12, 12, 12),
    CardBG      = Color3.fromRGB(22, 22, 22),
    CardHov     = Color3.fromRGB(28, 28, 28),
    Text        = Color3.fromRGB(255, 255, 255),
    TextDim     = Color3.fromRGB(140, 140, 140),
    Accent      = Color3.fromRGB(88, 101, 242),
    Line        = Color3.fromRGB(28, 28, 28)
}

-- ==========================================
-- FLOATING WIDGET (PERMANENT)
-- ==========================================
local FloatBtn = Instance.new("TextButton", Gui)
FloatBtn.Size = UDim2.new(0, 45, 0, 45)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -22)
FloatBtn.BackgroundColor3 = Theme.CardBG
FloatBtn.Text = "C"
FloatBtn.TextColor3 = Theme.Accent
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 22
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
FloatBtn.ZIndex = 99999
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", FloatBtn).Color = Theme.Line

local draggingFloat, dragInputFloat, dragStartFloat, startPosFloat
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFloat = true
        dragStartFloat = input.Position
        startPosFloat = FloatBtn.Position
    end
end)
FloatBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingFloat = false end
end)
UserInput.InputChanged:Connect(function(input)
    if draggingFloat and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartFloat
        FloatBtn.Position = UDim2.new(startPosFloat.X.Scale, startPosFloat.X.Offset + delta.X, startPosFloat.Y.Scale, startPosFloat.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 550, 0, 340)
Main.Position = UDim2.new(0.5, -275, 0.5, -170)
Main.BackgroundColor3 = Theme.MainBG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true 
Main.Visible = false 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", Main).Color = Theme.Line

FloatBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Topbar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = Theme.TopBG
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 6)

local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 10)
TopFix.Position = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3 = Theme.TopBG
TopFix.BorderSizePixel = 0

local TitleStr = Instance.new("TextLabel", Top)
TitleStr.Size = UDim2.new(0, 200, 1, 0)
TitleStr.Position = UDim2.new(0, 15, 0, 0)
TitleStr.Text = "CatHUB"
TitleStr.TextColor3 = Theme.Text
TitleStr.Font = Enum.Font.GothamMedium
TitleStr.TextSize = 13
TitleStr.TextXAlignment = Enum.TextXAlignment.Left
TitleStr.BackgroundTransparency = 1

local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 35, 0, 35)
BtnX.Position = UDim2.new(1, -35, 0, 0)
BtnX.Text = "X" 
BtnX.TextColor3 = Theme.TextDim
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.Gotham
BtnX.TextSize = 15

local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 35, 0, 35)
BtnM.Position = UDim2.new(1, -70, 0, 0)
BtnM.Text = "—"
BtnM.TextColor3 = Theme.TextDim
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.GothamBold
BtnM.TextSize = 13

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

local draggingMain, dragStartMain, startPosMain
Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = Main.Position
    end
end)
Top.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingMain = false end end)
UserInput.InputChanged:Connect(function(input)
    if draggingMain and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartMain
        Main.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- RESIZER (FIXED)
-- ==========================================
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 20, 0, 20)
Resizer.Position = UDim2.new(1, -20, 1, -20)
Resizer.BackgroundTransparency = 1
Resizer.Text = "⌟"
Resizer.TextColor3 = Theme.TextDim
Resizer.TextSize = 16
Resizer.Font = Enum.Font.Gotham
Resizer.ZIndex = 50

local isResizing, resizeStart, startSize
Resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not isMin then
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
        local delta = input.Position - resizeStart
        local newX = math.clamp(startSize.X.Offset + delta.X, 480, 900)
        local newY = math.clamp(startSize.Y.Offset + delta.Y, 280, 700)
        Main.Size = UDim2.new(0, newX, 0, newY)
        lastSize = Main.Size
    end
end)

-- ==========================================
-- DYNAMIC SIDEBAR & KONTEN
-- ==========================================
local ContentContainer = Instance.new("Frame", Main)
ContentContainer.Size = UDim2.new(1, 0, 1, -35)
ContentContainer.Position = UDim2.new(0, 0, 0, 35)
ContentContainer.BackgroundTransparency = 1

local Side = Instance.new("Frame", ContentContainer)
Side.Size = UDim2.new(0.28, 0, 1, 0)
Side.BackgroundColor3 = Theme.SideBG
Side.BorderSizePixel = 0

local SideLine = Instance.new("Frame", Side)
SideLine.Size = UDim2.new(0, 1, 1, 0)
SideLine.Position = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3 = Theme.Line
SideLine.BorderSizePixel = 0

local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Size = UDim2.new(1, 0, 1, 0)
SideScroll.BackgroundTransparency = 1
SideScroll.ScrollBarThickness = 0
SideScroll.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", SideScroll)
SideList.Padding = UDim.new(0, 4)
local SidePad = Instance.new("UIPadding", SideScroll)
SidePad.PaddingTop = UDim.new(0, 10)
SidePad.PaddingLeft = UDim.new(0, 8)
SidePad.PaddingRight = UDim.new(0, 8)

local ContentArea = Instance.new("Frame", ContentContainer)
ContentArea.Size = UDim2.new(0.72, 0, 1, 0)
ContentArea.Position = UDim2.new(0.28, 0, 0, 0)
ContentArea.BackgroundTransparency = 1

local Pages = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", SideScroll)
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = isFirst and Theme.CardHov or Theme.SideBG
    Btn.Text = "    " .. name
    Btn.TextColor3 = isFirst and Theme.Text or Theme.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local Indicator = Instance.new("Frame", Btn)
    Indicator.Size = UDim2.new(0, 3, 0, 14)
    Indicator.Position = UDim2.new(0, 4, 0.5, -7)
    Indicator.BackgroundColor3 = Theme.Accent
    Indicator.BorderSizePixel = 0
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    Indicator.Visible = isFirst
    
    Btn.MouseEnter:Connect(function()
        if not Indicator.Visible then TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardBG, TextColor3 = Theme.Text}):Play() end
    end)
    Btn.MouseLeave:Connect(function()
        if not Indicator.Visible then TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.SideBG, TextColor3 = Theme.TextDim}):Play() end
    end)
    
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Theme.Line
    Page.Visible = isFirst
    Page.BorderSizePixel = 0
    
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 6)
    local Pad = Instance.new("UIPadding", Page)
    Pad.PaddingTop = UDim.new(0, 10)
    Pad.PaddingLeft = UDim.new(0, 12)
    Pad.PaddingRight = UDim.new(0, 16)
    
    Pages[name] = {Btn = Btn, Page = Page, Ind = Indicator}
    
    Btn.MouseButton1Click:Connect(function()
        for tName, data in pairs(Pages) do
            local active = (tName == name)
            data.Page.Visible = active
            data.Ind.Visible = active
            TweenService:Create(data.Btn, TweenInfo.new(0.15), {
                BackgroundColor3 = active and Theme.CardHov or Theme.SideBG,
                TextColor3 = active and Theme.Text or Theme.TextDim
            }):Play()
        end
    end)
    
    return Page
end

local function CreateSection(parent, text)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 24) 
    F.BackgroundTransparency = 1
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Position = UDim2.new(0, 4, 0, 0)
    L.Text = text
    L.TextColor3 = Theme.TextDim
    L.Font = Enum.Font.GothamBold
    L.TextSize = 11 
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
end

local function CreateToggle(parent, text, stateRef, callback)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, 0, 0, 36)
    F.BackgroundColor3 = Theme.CardBG
    F.BorderSizePixel = 0
    F.Text = ""
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", F).Color = Theme.Line
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = text
    L.TextColor3 = Theme.Text
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    
    -- Fix Toggle Shape (Bulat sempurna / pill-shape)
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 36, 0, 18)
    Sw.Position = UDim2.new(1, -48, 0.5, -9)
    Sw.BackgroundColor3 = stateRef and Theme.Accent or Theme.CardBG
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0) 
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0) 
    
    F.MouseEnter:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardHov}):Play() end)
    F.MouseLeave:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardBG}):Play() end)
    
    F.MouseButton1Click:Connect(function()
        stateRef = not stateRef
        TweenService:Create(Sw, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = stateRef and Theme.Accent or Theme.CardBG}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        if callback then callback(stateRef) end
    end)
end

-- ==========================================
-- BUILD TABS 
-- ==========================================
local EspTab = CreateTab("ESP", true)

CreateSection(EspTab, "DEVIL FRUITS")
CreateToggle(EspTab, "Fruit ESP (Text Only)", false, function(state)
    print("Fruit ESP:", state)
end)

Main.Visible = false
FloatBtn.Visible = true