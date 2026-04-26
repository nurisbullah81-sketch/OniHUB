-- CatHUB v9.4: RedzHub Remake (Fix Palette & Tab Card Contrast)
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Modern Blue/Dark Palette (Sesuai Referensi & Permintaan Contrast)
-- C.Base & C.Side: Hitam pekat (paling gelap)
-- C.Card & C.Top: Hitam abu-abu (sedikit lebih terang dari Base/Side)
local C = {
    Base = Color3.fromRGB(12, 12, 12),    -- Hitam Pekat (Deepest Black)
    Side = Color3.fromRGB(12, 12, 12),    -- Hitam Pekat (Matches Base)
    Top = Color3.fromRGB(22, 22, 22),     -- Hitam Abu-abu (Top Bar)
    Card = Color3.fromRGB(22, 22, 22),    -- Hitam Abu-abu (Active Tab Button)
    CardHov = Color3.fromRGB(30, 30, 30), -- Lighter for Hover
    Text = Color3.fromRGB(250, 250, 250), -- Putih bersih
    TextSec = Color3.fromRGB(160, 160, 160),-- Abu terang
    TextDim = Color3.fromRGB(90, 90, 90),   -- Abu redup
    Blue = Color3.fromRGB(88, 101, 242),  -- Blue Accent (Toggle ON)
    Off = Color3.fromRGB(45, 45, 52),     -- Grey (Toggle OFF)
    SecLine = Color3.fromRGB(35, 35, 35)   -- Section Line (Visible on Card)
}

-- ==========================================
-- TOMBOL REOPEN (BISA DIGESER)
-- ==========================================
local OpenBtn = Instance.new("Frame", Gui)
OpenBtn.Size = UDim2.new(0, 100, 0, 30)
OpenBtn.Position = UDim2.new(0, 100, 0.5, 0)
OpenBtn.BackgroundColor3 = C.Top
OpenBtn.BorderSizePixel = 0
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)

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
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = C.Base -- Deep Black
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

-- Top Bar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 30)
Top.BackgroundColor3 = C.Top -- Grey-Black
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 6)

-- Menutupi sudut bawah Topbar agar menyatu dengan body
local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 10)
TopFix.Position = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3 = C.Top
TopFix.BorderSizePixel = 0

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -70, 1, 0)
Ttl.Position = UDim2.new(0, 12, 0, 0)
Ttl.Text = "CatHUB Blox Fruits"
Ttl.TextColor3 = C.Text
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 13
Ttl.TextXAlignment = "Left"
Ttl.BackgroundTransparency = 1

local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 30, 0, 30)
BtnX.Position = UDim2.new(1, -30, 0, 0)
BtnX.Text = "×"
BtnX.TextColor3 = C.TextDim
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 16

local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 30, 0, 30)
BtnM.Position = UDim2.new(1, -60, 0, 0)
BtnM.Text = "—"
BtnM.TextColor3 = C.TextDim
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.GothamBold
BtnM.TextSize = 14

BtnX.MouseEnter:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play() end)
BtnX.MouseLeave:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.1), {TextColor3 = C.TextDim}):Play() end)

-- Close Logic
BtnX.MouseButton1Click:Connect(function()
    OpenBtn.Position = UDim2.new(0, Main.Position.X.Offset, 0, Main.Position.Y.Offset)
    Main.Visible = false
    OpenBtn.Visible = true
end)

-- Minimize Logic
local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, Main.Size.X.Offset, 0, 30)
        }):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, Main.Size.X.Offset, 0, 380)
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
-- RESIZE HANDLE (POJOK KANAN BAWAH)
-- ==========================================
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 20, 0, 20)
Resizer.Position = UDim2.new(1, -20, 1, -20)
Resizer.BackgroundTransparency = 1
Resizer.Text = "⌟"
Resizer.TextColor3 = C.TextDim
Resizer.TextSize = 14
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
        local newX = math.clamp(startSize.X.Offset + dx, 450, 900)
        local newY = math.clamp(startSize.Y.Offset + dy, 250, 700)
        Main.Size = UDim2.new(0, newX, 0, newY)
    end
end)

-- ==========================================
-- SIDEBAR (HITAM PEKAT)
-- ==========================================
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 110, 1, -30)
Side.Position = UDim2.new(0, 0, 0, 30)
Side.BackgroundColor3 = C.Side -- Deep Black
Side.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 4)
local SidePad = Instance.new("UIPadding", Side)
SidePad.PaddingTop = UDim.new(0, 8)
SidePad.PaddingLeft = UDim.new(0, 6)
SidePad.PaddingRight = UDim.new(0, 6)

-- Content Area: Grey-Black (Matches Card)
local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -110, 1, -30)
ContentArea.Position = UDim2.new(0, 110, 0, 30)
ContentArea.BackgroundColor3 = C.Card
ContentArea.BorderSizePixel = 0
-- Kasih UICorner agar menyatu dengan Top bar fix
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 6)

local Pages = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, 0, 0, 32)
    -- FIX: PERMANENT distinction for active tab button
    Btn.BackgroundColor3 = isFirst and C.Card or C.Side
    Btn.Text = "   " .. name
    Btn.TextColor3 = isFirst and C.Text or C.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = "Left"
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    -- Blue line indicator (Seperti RedzHub)
    local BlueIndicator = Instance.new("Frame", Btn)
    BlueIndicator.Size = UDim2.new(0, 2, 1, -10)
    BlueIndicator.Position = UDim2.new(0, 2, 0, 5)
    BlueIndicator.BackgroundColor3 = C.Blue
    BlueIndicator.BorderSizePixel = 0
    BlueIndicator.Visible = isFirst
    
    Btn.MouseEnter:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.CardHov, TextColor3 = C.TextSec}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
    end)
    
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Name = name .. "Pg"
    Page.Size = UDim2.new(1, -20, 1, -10)
    Page.Position = UDim2.new(0, 10, 0, 5)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = C.TextDim
    Page.Visible = isFirst
    Page.BorderSizePixel = 0
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 6)
    
    local Pad = Instance.new("UIPadding", Page)
    Pad.PaddingTop = UDim.new(0, 4)
    Pad.PaddingBottom = UDim.new(0, 4)
    
    Pages[name] = Page
    
    Btn.MouseButton1Click:Connect(function()
        for tName, pPage in pairs(Pages) do pPage.Visible = (tName == name) end
        for _, otherBtn in pairs(Side:GetChildren()) do
            if otherBtn:IsA("TextButton") then
                local isActive = otherBtn.Text:find(name)
                TweenService:Create(otherBtn, TweenInfo.new(0.1), {BackgroundColor3 = isActive and C.Card or C.Side, TextColor3 = isActive and C.Text or C.TextDim}):Play()
                otherBtn:FindFirstChild("Frame").Visible = isActive
            end
        end
    end)
    return Page
end

-- ==========================================
-- BUILD TABS
-- ==========================================
local EspPage = CreateTab("Devil Fruits", true) -- "Devil Fruits" (ESP) tab
local PlayerPage = CreateTab("Player", false)
local MainTab = CreateTab("Status", false) -- "Status" tab

-- Section Header
local function Section(parent, text)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 24)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(0, 100, 1, 0)
    L.Position = UDim2.new(0, 2, 0, 0)
    L.Text = text
    L.TextColor3 = C.TextSec
    L.Font = Enum.Font.GothamBold
    L.TextSize = 12
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Line = Instance.new("Frame", F)
    Line.Size = UDim2.new(1, -110, 0, 1)
    Line.Position = UDim2.new(0, 108, 0.5, 0)
    Line.BackgroundColor3 = C.SecLine -- Visible Grey on Card BG
    Line.BorderSizePixel = 0
end

-- Toggle (Blue Accent)
local function Toggle(parent, key, text)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, 0, 0, 36)
    F.BackgroundColor3 = C.Card -- Match Card Background
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    F.Text = ""
    
    -- Outline seperti di RedzHub
    local Stroke = Instance.new("UIStroke", F)
    Stroke.Color = C.Side -- Outline visible against card background
    Stroke.Thickness = 1

    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -55, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = text
    L.TextColor3 = C.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 13
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 38, 0, 18)
    Sw.Position = UDim2.new(1, -48, 0.5, -9)
    Sw.BackgroundColor3 = S[key] and C.Blue or C.Off
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = S[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    F.MouseEnter:Connect(function() TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = C.CardHov}):Play() end)
    F.MouseLeave:Connect(function() TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = C.Card}):Play() end)
    
    F.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Dot, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Position = S[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.12), {
            BackgroundColor3 = S[key] and C.Blue or C.Off
        }):Play()
    end)
end

-- ==========================================
-- ADD CONTENT TO TABS
-- ==========================================
Section(EspPage, "DEVIL FRUITS")
Toggle(EspPage, "FruitESP", "Fruit ESP")
Toggle(EspPage, "ChestESP", "Chest ESP")

Section(PlayerPage, "COMBAT")
Toggle(PlayerPage, "SilentAim", "Silent Aim")
Toggle(PlayerPage, "AutoFarm", "Auto Farm")

Section(MainTab, "INFORMATION")
CreateSection(MainTab, "Player Status: " .. tostring(game.Players.LocalPlayer.Name))
CreateSection(MainTab, "Script Status: Running")

-- Drag Main Frame
local dragging, dragStart, startPos
Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
Top.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)