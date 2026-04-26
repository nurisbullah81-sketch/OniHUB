-- CatHUB v8.8: True Fluid UI (RedzHub Vibe + UIScale Trick)
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Theme Colors
local C = {
    Base = Color3.fromRGB(25, 25, 30),
    Side = Color3.fromRGB(20, 20, 25),
    Card = Color3.fromRGB(32, 32, 40),
    CardHov = Color3.fromRGB(38, 38, 48),
    Top = Color3.fromRGB(130, 90, 220),
    Text = Color3.fromRGB(225, 225, 235),
    TextSec = Color3.fromRGB(160, 160, 180),
    TextDim = Color3.fromRGB(90, 90, 110),
    Off = Color3.fromRGB(50, 50, 62),
    Accent = Color3.fromRGB(130, 90, 220)
}

-- Main Frame (Fixed Size)
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Topbar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = C.Accent
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 10)
TopFix.Position = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3 = C.Accent
TopFix.BorderSizePixel = 0

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -80, 1, 0)
Ttl.Position = UDim2.new(0, 15, 0, 0)
Ttl.Text = "CatHUB"
Ttl.TextColor3 = Color3.new(1, 1, 1)
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 15
Ttl.TextXAlignment = "Left"
Ttl.BackgroundTransparency = 1

-- Close & Minimize with Hover
local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 35, 0, 35)
BtnX.Position = UDim2.new(1, -35, 0, 0)
BtnX.Text = "×"
BtnX.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 18

local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 35, 0, 35)
BtnM.Position = UDim2.new(1, -70, 0, 0)
BtnM.Text = "—"
BtnM.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.GothamBold
BtnM.TextSize = 16

BtnX.MouseEnter:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play() end)
BtnX.MouseLeave:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play() end)
BtnX.MouseButton1Click:Connect(function() Gui:Destroy() end)

-- Minimize Logic
local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    local SideF = Main:FindFirstChild("Side")
    local ContF = Main:FindFirstChild("Content")
    if SideF then SideF.Visible = not isMin end
    if ContF then ContF.Visible = not isMin end
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
        Size = isMin and UDim2.new(0, 500, 0, 35) or UDim2.new(0, 500, 0, 350)
    }):Play()
end)

-- Sidebar (Slim 100px)
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 100, 1, -35)
Side.Position = UDim2.new(0, 0, 0, 35)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 2)

-- UIScale TRICK: Ini yang bikin isi mengecil tapi kotak tetap sama
local SideScale = Instance.new("UIScale", Side)
SideScale.Scale = 1.0

local Tabs = {EspTab = nil, SettingTab = nil}
local Pages = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = isFirst and C.Card or C.Side
    Btn.Text = name
    Btn.TextColor3 = isFirst and C.Text or C.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = "Left"
    local Pad = Instance.new("UIPadding", Btn)
    Pad.PaddingLeft = UDim.new(0, 15)
    
    Btn.MouseEnter:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = C.CardHov, TextColor3 = C.TextSec}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
    end)
    
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Name = name
    Page.Size = UDim2.new(1, -110, 1, -45)
    Page.Position = UDim2.new(0, 105, 0, 40)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = C.Accent
    Page.Visible = isFirst
    Page.BorderSizePixel = 0
    
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 6)
    
    local PageScale = Instance.new("UIScale", Page)
    PageScale.Scale = 1.0
    
    Pages[name] = Page
    
    Btn.MouseButton1Click:Connect(function()
        for tName, pPage in pairs(Pages) do
            pPage.Visible = (tName == name)
        end
        for _, btn in pairs(Side:GetChildren()) do
            if btn:IsA("TextButton") then
                if btn.Text == name then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C.Card, TextColor3 = C.Text}):Play()
                else
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
                end
            end
        end
    end)
    
    return Page
end

-- Build Tabs
local EspPage = CreateTab("ESP", true)
local SetPage = CreateTab("Settings", false)

-- UI Elements Helpers
local function CreateSection(parent, text)
    local Sec = Instance.new("Frame", parent)
    Sec.Size = UDim2.new(1, -10, 0, 25)
    Sec.Position = UDim2.new(0, 5, 0, 0)
    Sec.BackgroundColor3 = C.Side
    Sec.BorderSizePixel = 0
    Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 5)
    
    local L = Instance.new("TextLabel", Sec)
    L.Size = UDim2.new(1, -10, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = text
    L.TextColor3 = C.Accent
    L.Font = Enum.Font.GothamBold
    L.TextSize = 11
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
end

local function CreateToggle(parent, key, text)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, -10, 0, 35)
    F.Position = UDim2.new(0, 5, 0, 0)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    F.Text = ""
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 15, 0, 0)
    L.Text = text
    L.TextColor3 = C.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 13
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 38, 0, 18)
    Sw.Position = UDim2.new(1, -50, 0.5, -9)
    Sw.BackgroundColor3 = S[key] and C.Accent or C.Off
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = S[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    -- Hover effect untuk card
    F.MouseEnter:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = C.CardHov}):Play() end)
    F.MouseLeave:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = C.Card}):Play() end)
    
    F.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = S[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.15), {
            BackgroundColor3 = S[key] and C.Accent or C.Off
        }):Play()
    end)
end

-- ESP Page Content
CreateSection(EspPage, "DEVIL FRUITS")
CreateToggle(EspPage, "FruitESP", "Fruit ESP")

-- Settings Page Content
CreateSection(SetPage, "UI SCALE")

local function CreateScaleBtn(name, scaleVal)
    local B = Instance.new("TextButton", SetPage)
    B.Size = UDim2.new(0.3, -5, 0, 30)
    B.BackgroundColor3 = C.Card
    B.TextColor3 = C.TextSec
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 11
    B.BorderSizePixel = 0
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.Text = name
    
    B.MouseButton1Click:Connect(function()
        -- Animasi UIScale (Isi mengecil/membesar, kotak tetap)
        TweenService:Create(SideScale, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Scale = scaleVal}):Play()
        TweenService:Create(EspPage:FindFirstChild("UIScale"), TweenInfo.new(0.3, Enum.EasingStyle.Back), {Scale = scaleVal}):Play()
        TweenService:Create(SetPage:FindFirstChild("UIScale"), TweenInfo.new(0.3, Enum.EasingStyle.Back), {Scale = scaleVal}):Play()
        
        -- Highlight tombol aktif
        for _, btn in pairs(SetPage:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C.Card, TextColor3 = C.TextSec}):Play()
            end
        end
        TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = C.Accent, TextColor3 = Color3.new(1,1,1)}):Play()
    end)
    return B
end

local SBtn = CreateScaleBtn("Small", 0.8)
local MBtn = CreateScaleBtn("Standard", 1.0)
local LBtn = CreateScaleBtn("Large", 1.15)

-- Layout Scale Buttons
local RowLayout = Instance.new("UIListLayout", SetPage)
RowLayout.FillDirection = Enum.FillDirection.Horizontal
RowLayout.Padding = UDim.new(0, 5)

-- Set initial active highlight
TweenService:Create(MBtn, TweenInfo.new(0), {BackgroundColor3 = C.Accent, TextColor3 = Color3.new(1,1,1)}):Play()

-- Drag Logic
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