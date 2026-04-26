-- CatHUB v9.1: True RedzHub Mechanics
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Pure Dark Palette
local C = {
    Base = Color3.fromRGB(25, 25, 25),
    Side = Color3.fromRGB(20, 20, 20),
    Card = Color3.fromRGB(32, 32, 32),
    CardHov = Color3.fromRGB(42, 42, 42),
    Top = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(195, 195, 195),
    TextSec = Color3.fromRGB(140, 140, 140),
    TextDim = Color3.fromRGB(80, 80, 80),
    On = Color3.fromRGB(180, 180, 180), -- Toggle ON abu terang
    Off = Color3.fromRGB(45, 45, 45)    -- Toggle OFF abu gelap
}

-- ==========================================
-- TOMBOL REOPEN (MUNCUL PAS UI DI CLOSE)
-- ==========================================
local OpenBtn = Instance.new("TextButton", Gui)
OpenBtn.Size = UDim2.new(0, 100, 0, 30)
OpenBtn.Position = UDim2.new(0, 20, 0.5, 0)
OpenBtn.BackgroundColor3 = C.Card
OpenBtn.TextColor3 = C.Text
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 12
OpenBtn.Text = "Open CatHUB"
OpenBtn.Visible = false
OpenBtn.BorderSizePixel = 0
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- MAIN FRAME (BESAR & LAPANG)
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 580, 0, 380)
Main.Position = UDim2.new(0.5, -290, 0.5, -190)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- TOPBAR (TOMBOL X DAN -)
-- ==========================================
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 32)
Top.BackgroundColor3 = C.Top
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 6)

local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 8)
TopFix.Position = UDim2.new(0, 0, 1, -8)
TopFix.BackgroundColor3 = C.Top
TopFix.BorderSizePixel = 0

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -80, 1, 0)
Ttl.Position = UDim2.new(0, 14, 0, 0)
Ttl.Text = "CatHUB"
Ttl.TextColor3 = C.Text
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 14
Ttl.TextXAlignment = "Left"
Ttl.BackgroundTransparency = 1

local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 32, 0, 32)
BtnX.Position = UDim2.new(1, -32, 0, 0)
BtnX.Text = "×"
BtnX.TextColor3 = C.TextDim
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 18

local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 32, 0, 32)
BtnM.Position = UDim2.new(1, -64, 0, 0)
BtnM.Text = "—"
BtnM.TextColor3 = C.TextDim
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.GothamBold
BtnM.TextSize = 16

-- Hover Effects
BtnX.MouseEnter:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play() end)
BtnX.MouseLeave:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.1), {TextColor3 = C.TextDim}):Play() end)
BtnM.MouseEnter:Connect(function() TweenService:Create(BtnM, TweenInfo.new(0.1), {TextColor3 = C.Text}):Play() end)
BtnM.MouseLeave:Connect(function() TweenService:Create(BtnM, TweenInfo.new(0.1), {TextColor3 = C.TextDim}):Play() end)

-- LOGIC CLOSE (X) -> Munculin Tombol Open
BtnX.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- Hotkey RightCtrl buka/tutup
UserInput.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
        OpenBtn.Visible = not Main.Visible
    end
end)

-- LOGIC MINIMIZE (-) -> Nggulung ke atas
local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    local SideF = Main:FindFirstChild("Side")
    local ContF = Main:FindFirstChild("Content")
    
    if isMin then
        if SideF then SideF.Visible = false end
        if ContF then ContF.Visible = false end
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 580, 0, 32)
        }):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 580, 0, 380)
        }):Play()
        -- Delay biar keliatan animasinya baru muncul isinya
        task.wait(0.15)
        if SideF then SideF.Visible = true end
        if ContF then ContF.Visible = true end
    end
end)

-- ==========================================
-- SIDEBAR
-- ==========================================
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 110, 1, -32)
Side.Position = UDim2.new(0, 0, 0, 32)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 4)
local SidePad = Instance.new("UIPadding", Side)
SidePad.PaddingTop = UDim.new(0, 6)

local Pages = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, -10, 0, 32)
    Btn.Position = UDim2.new(0, 5, 0, 0)
    Btn.BackgroundColor3 = isFirst and C.Base or C.Side
    Btn.Text = "  " .. name
    Btn.TextColor3 = isFirst and C.Text or C.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = "Left"
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    
    Btn.MouseEnter:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = C.CardHov, TextColor3 = C.TextSec}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
    end)
    
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, -130, 1, -44)
    Page.Position = UDim2.new(0, 120, 0, 38)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = C.TextDim
    Page.Visible = isFirst
    Page.BorderSizePixel = 0
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 8)
    
    local Pad = Instance.new("UIPadding", Page)
    Pad.PaddingLeft = UDim.new(0, 4)
    Pad.PaddingRight = UDim.new(0, 4)
    Pad.PaddingTop = UDim.new(0, 2)
    Pad.PaddingBottom = UDim.new(0, 4)
    
    Pages[name] = Page
    
    Btn.MouseButton1Click:Connect(function()
        for tName, pPage in pairs(Pages) do pPage.Visible = (tName == name) end
        for _, btn in pairs(Side:GetChildren()) do
            if btn:IsA("TextButton") then
                if btn.Text:find(name) then
                    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.Base, TextColor3 = C.Text}):Play()
                else
                    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
                end
            end
        end
    end)
    return Page
end

local EspPage = CreateTab("ESP", true)

-- ==========================================
-- TOGGLE FUNCTION (Smooth & Modern)
-- ==========================================
local function CreateToggle(parent, key, text)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, 0, 0, 38)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    F.Text = ""
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.Text = text
    L.TextColor3 = C.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 13
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 40, 0, 20)
    Sw.Position = UDim2.new(1, -52, 0.5, -10)
    Sw.BackgroundColor3 = S[key] and C.On or C.Off
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = S[key] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    F.MouseEnter:Connect(function() TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = C.CardHov}):Play() end)
    F.MouseLeave:Connect(function() TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = C.Card}):Play() end)
    
    F.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = S[key] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.15), {
            BackgroundColor3 = S[key] and C.On or C.Off
        }):Play()
    end)
end

CreateToggle(EspPage, "FruitESP", "Fruit ESP")

-- ==========================================
-- DRAG LOGIC
-- ==========================================
local dragging, dragInput, dragStart, startPos
Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
Top.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)