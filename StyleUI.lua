-- CatHUB v8.9: Modern Navy UI + Big Window + Correct Scaling
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Modern Navy/Purple Palette
local C = {
    Base = Color3.fromRGB(25, 25, 40),       -- Navy dark
    Side = Color3.fromRGB(20, 20, 35),        -- Deeper navy
    Card = Color3.fromRGB(35, 35, 55),        -- Soft raised card
    CardHov = Color3.fromRGB(45, 45, 65),     -- Hover card
    Top = Color3.fromRGB(120, 80, 210),       -- Vibrant purple topbar
    Text = Color3.fromRGB(210, 210, 230),     -- Soft off-white
    TextSec = Color3.fromRGB(150, 150, 180),  -- Muted text
    TextDim = Color3.fromRGB(90, 90, 120),    -- Dim text
    Off = Color3.fromRGB(45, 45, 65),         -- Toggle off
    Accent = Color3.fromRGB(120, 80, 210)     -- Main accent
}

-- Main Frame (BESAR)
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 650, 0, 420)
Main.Position = UDim2.new(0.5, -325, 0.5, -210)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Topbar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 40)
Top.BackgroundColor3 = C.Accent
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 10)

local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = C.Accent
TopFix.BorderSizePixel = 0

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -80, 1, 0)
Ttl.Position = UDim2.new(0, 18, 0, 0)
Ttl.Text = "CatHUB"
Ttl.TextColor3 = Color3.new(1, 1, 1)
Ttl.Font = Enum.Font.GothamBold
Ttl.TextSize = 17
Ttl.TextXAlignment = "Left"
Ttl.BackgroundTransparency = 1

local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 40, 0, 40)
BtnX.Position = UDim2.new(1, -40, 0, 0)
BtnX.Text = "×"
BtnX.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 20

local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 40, 0, 40)
BtnM.Position = UDim2.new(1, -80, 0, 0)
BtnM.Text = "—"
BtnM.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnM.BackgroundTransparency = 1
BtnM.Font = Enum.Font.GothamBold
BtnM.TextSize = 18

BtnX.MouseEnter:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play() end)
BtnX.MouseLeave:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play() end)
BtnX.MouseButton1Click:Connect(function() Gui:Destroy() end)

local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    Main:FindFirstChild("Side").Visible = not isMin
    Main:FindFirstChild("Content").Visible = not isMin
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
        Size = isMin and UDim2.new(0, 650, 0, 40) or UDim2.new(0, 650, 0, 420)
    }):Play()
end)

-- Sidebar (Slim & Elegant)
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 110, 1, -40)
Side.Position = UDim2.new(0, 0, 0, 40)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 4)

local SideScale = Instance.new("UIScale", Side)
SideScale.Scale = 1.0 -- Default standard

local Pages = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, -10, 0, 38)
    Btn.Position = UDim2.new(0, 5, 0, 0)
    Btn.BackgroundColor3 = isFirst and C.Card or C.Side
    Btn.Text = "  " .. name
    Btn.TextColor3 = isFirst and C.Text or C.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 14
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = "Left"
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
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
    Page.Size = UDim2.new(1, -130, 1, -50)
    Page.Position = UDim2.new(0, 120, 0, 45)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = C.Accent
    Page.Visible = isFirst
    Page.BorderSizePixel = 0
    
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 8)
    
    local PageScale = Instance.new("UIScale", Page)
    PageScale.Scale = 1.0 -- Default standard
    
    Pages[name] = Page
    
    Btn.MouseButton1Click:Connect(function()
        for tName, pPage in pairs(Pages) do pPage.Visible = (tName == name) end
        for _, btn in pairs(Side:GetChildren()) do
            if btn:IsA("TextButton") then
                if btn.Text:find(name) then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C.Card, TextColor3 = C.Text}):Play()
                else
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
                end
            end
        end
    end)
    return Page
end

local EspPage = CreateTab("ESP", true)
local SetPage = CreateTab("Settings", false)

local function CreateSection(parent, text)
    local Sec = Instance.new("Frame", parent)
    Sec.Size = UDim2.new(1, -20, 0, 30)
    Sec.Position = UDim2.new(0, 10, 0, 0)
    Sec.BackgroundColor3 = C.Side
    Sec.BorderSizePixel = 0
    Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", Sec)
    L.Size = UDim2.new(1, -20, 1, 0)
    L.Position = UDim2.new(0, 15, 0, 0)
    L.Text = text
    L.TextColor3 = C.Accent
    L.Font = Enum.Font.GothamBold
    L.TextSize = 12
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
end

local function CreateToggle(parent, key, text)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, -20, 0, 40)
    F.Position = UDim2.new(0, 10, 0, 0)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    F.Text = ""
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -70, 1, 0)
    L.Position = UDim2.new(0, 18, 0, 0)
    L.Text = text
    L.TextColor3 = C.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 14
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 44, 0, 22)
    Sw.Position = UDim2.new(1, -56, 0.5, -11)
    Sw.BackgroundColor3 = S[key] and C.Accent or C.Off
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = S[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    F.MouseEnter:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = C.CardHov}):Play() end)
    F.MouseLeave:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = C.Card}):Play() end)
    
    F.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = S[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.15), {
            BackgroundColor3 = S[key] and C.Accent or C.Off
        }):Play()
    end)
end

CreateSection(EspPage, "DEVIL FRUITS")
CreateToggle(EspPage, "FruitESP", "Fruit ESP")

CreateSection(SetPage, "UI SCALE (Inner Content)")

-- PERBAIKAN SKALA: Small itu rapat, Large itu gede
local ScaleMap = {Small = 0.75, Standard = 0.9, Large = 1.1}

local function CreateScaleBtn(name, scaleVal)
    local B = Instance.new("TextButton", SetPage)
    B.Size = UDim2.new(0.3, -10, 0, 35)
    B.BackgroundColor3 = C.Card
    B.TextColor3 = C.TextSec
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 13
    B.BorderSizePixel = 0
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    B.Text = name
    
    B.MouseButton1Click:Connect(function()
        TweenService:Create(SideScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Scale = scaleVal}):Play()
        TweenService:Create(EspPage:FindFirstChild("UIScale"), TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Scale = scaleVal}):Play()
        TweenService:Create(SetPage:FindFirstChild("UIScale"), TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Scale = scaleVal}):Play()
        
        for _, btn in pairs(SetPage:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C.Card, TextColor3 = C.TextSec}):Play()
            end
        end
        TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = C.Accent, TextColor3 = Color3.new(1,1,1)}):Play()
    end)
    return B
end

local SBtn = CreateScaleBtn("Small", ScaleMap.Small)
local MBtn = CreateScaleBtn("Standard", ScaleMap.Standard)
local LBtn = CreateScaleBtn("Large", ScaleMap.Large)

local RowLayout = Instance.new("UIListLayout", SetPage)
RowLayout.FillDirection = Enum.FillDirection.Horizontal
RowLayout.Padding = UDim.new(0, 10)

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