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

-- Modern Blue/Dark Palette (Sesuai Referensi)
local C = {
    Base = Color3.fromRGB(25, 25, 28),
    Side = Color3.fromRGB(20, 20, 23),
    Top = Color3.fromRGB(30, 30, 35),
    Card = Color3.fromRGB(35, 35, 40),
    CardHov = Color3.fromRGB(45, 45, 52),
    Text = Color3.fromRGB(200, 200, 205),
    TextSec = Color3.fromRGB(145, 145, 155),
    TextDim = Color3.fromRGB(85, 85, 95),
    Blue = Color3.fromRGB(75, 150, 255), -- Toggle ON sesuai gambar
    Off = Color3.fromRGB(45, 45, 52),
    SecLine = Color3.fromRGB(55, 55, 65)
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
-- MAIN FRAME (CLIPS DESCENDANTS BIAR MULUS)
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Main.ClipsDescendants = true -- RAHASIA MINIMIZE MULUS
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

-- Top Bar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 30)
Top.BackgroundColor3 = C.Top
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 6)

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -70, 1, 0)
Ttl.Position = UDim2.new(0, 12, 0, 0)
Ttl.Text = "CatHUB"
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

-- Close Logic (Pindah posisi ke Reopen)
BtnX.MouseButton1Click:Connect(function()
    OpenBtn.Position = UDim2.new(0, Main.Position.X.Offset, 0, Main.Position.Y.Offset)
    Main.Visible = false
    OpenBtn.Visible = true
end)

-- Minimize Logic (Mulus karena ClipsDescendants)
local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, Main.Size.X.Offset, 0, 30)
        }):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, Main.Size.X.Offset, 0, 380) -- Dynamic nanti kalau di-resize
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
        -- Batasin minimal dan maximal ukuran
        local newX = math.clamp(startSize.X.Offset + dx, 450, 900)
        local newY = math.clamp(startSize.Y.Offset + dy, 250, 700)
        Main.Size = UDim2.new(0, newX, 0, newY)
    end
end)

-- ==========================================
-- SIDEBAR (PROPORSIONAL)
-- ==========================================
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 110, 1, -30)
Side.Position = UDim2.new(0, 0, 0, 30)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 4)
local SidePad = Instance.new("UIPadding", Side)
SidePad.PaddingTop = UDim.new(0, 8)
SidePad.PaddingLeft = UDim.new(0, 6)
SidePad.PaddingRight = UDim.new(0, 6)

local Pages = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, -12, 0, 32) -- Tinggi tab pas
    Btn.BackgroundColor3 = isFirst and C.Base or C.Side
    Btn.Text = "  " .. name
    Btn.TextColor3 = isFirst and C.Text or C.TextDim
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = "Left"
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    
    Btn.MouseEnter:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.CardHov, TextColor3 = C.TextSec}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
    end)
    
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Name = name .. "Pg"
    Page.Size = UDim2.new(1, -130, 1, -40)
    Page.Position = UDim2.new(0, 118, 0, 36)
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
        for _, btn in pairs(Side:GetChildren()) do
            if btn:IsA("TextButton") then
                if btn.Text:find(name) then
                    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Base, TextColor3 = C.Text}):Play()
                else
                    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
                end
            end
        end
    end)
    return Page
end

local EspPage = CreateTab("ESP", true)

-- Section Header
local function Section(parent, text)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 24)
    F.BackgroundColor3 = C.Base
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
    Line.BackgroundColor3 = C.SecLine
    Line.BorderSizePixel = 0
end

-- Toggle (Blue Accent)
local function Toggle(parent, key, text)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, 0, 0, 36)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    F.Text = ""
    
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

Section(EspPage, "DEVIL FRUITS")
Toggle(EspPage, "FruitESP", "Fruit ESP")

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