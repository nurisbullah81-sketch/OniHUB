-- CatHUB v9.0: Pure Black RedzHub Style
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Pure Black Palette (NO PURPLE)
local C = {
    Base = Color3.fromRGB(20, 20, 20),   -- Hitam pekat
    Side = Color3.fromRGB(15, 15, 15),   -- Hitam lebih pekat
    Card = Color3.fromRGB(30, 30, 30),   -- Abu item
    CardHov = Color3.fromRGB(38, 38, 38),-- Hover sedikit terang
    Top = Color3.fromRGB(25, 25, 25),    -- Topbar hitam
    Text = Color3.fromRGB(200, 200, 200),-- Putih soft
    TextSec = Color3.fromRGB(140, 140, 140), -- Abu teks
    TextDim = Color3.fromRGB(80, 80, 80),-- Abu gelap
    On = Color3.fromRGB(200, 200, 200),  -- Toggle ON (Putih)
    Off = Color3.fromRGB(40, 40, 40)     -- Toggle OFF (Abu gelap)
}

-- Main Frame (Compact & Clean 450x280)
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 450, 0, 280)
Main.Position = UDim2.new(0.5, -225, 0.5, -140)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 4) -- Sedikit rounded

-- Topbar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 30)
Top.BackgroundColor3 = C.Top
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 4)

local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 6)
TopFix.Position = UDim2.new(0, 0, 1, -6)
TopFix.BackgroundColor3 = C.Top
TopFix.BorderSizePixel = 0

local Ttl = Instance.new("TextLabel", Top)
Ttl.Size = UDim2.new(1, -60, 1, 0)
Ttl.Position = UDim2.new(0, 10, 0, 0)
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
BtnX.MouseButton1Click:Connect(function() Gui:Destroy() end)

local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    Main:FindFirstChild("Side").Visible = not isMin
    Main:FindFirstChild("Content").Visible = not isMin
    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = isMin and UDim2.new(0, 450, 0, 30) or UDim2.new(0, 450, 0, 280)
    }):Play()
end)

-- Sidebar (Slim & Flat)
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 90, 1, -30)
Side.Position = UDim2.new(0, 0, 0, 30)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 2)

local Pages = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, 0, 0, 28)
    Btn.BackgroundColor3 = isFirst and C.Base or C.Side
    Btn.Text = "  " .. name
    Btn.TextColor3 = isFirst and C.Text or C.TextDim
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = "Left"
    
    Btn.MouseEnter:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Card, TextColor3 = C.TextSec}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
    end)
    
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Name = name
    Page.Size = UDim2.new(1, -105, 1, -40)
    Page.Position = UDim2.new(0, 95, 0, 35)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = C.TextDim
    Page.Visible = isFirst
    Page.BorderSizePixel = 0
    
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 6)
    
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

-- Toggle Function (Small & Monochrome)
local function CreateToggle(parent, key, text)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, -10, 0, 32)
    F.Position = UDim2.new(0, 5, 0, 0)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
    F.Text = ""
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -55, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = text
    L.TextColor3 = C.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 12
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 34, 0, 16)
    Sw.Position = UDim2.new(1, -44, 0.5, -8)
    Sw.BackgroundColor3 = S[key] and C.On or C.Off
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 12, 0, 12)
    Dot.Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    Dot.BackgroundColor3 = S[key] and C.Side or C.TextDim
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    F.MouseEnter:Connect(function() TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = C.CardHov}):Play() end)
    F.MouseLeave:Connect(function() TweenService:Create(F, TweenInfo.new(0.1), {BackgroundColor3 = C.Card}):Play() end)
    
    F.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Dot, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        }):Play()
        TweenService:Create(Dot, TweenInfo.new(0.15), {
            BackgroundColor3 = S[key] and C.Side or C.TextDim
        }):Play()
        TweenService:Create(Sw, TweenInfo.new(0.15), {
            BackgroundColor3 = S[key] and C.On or C.Off
        }):Play()
    end)
end

CreateToggle(EspPage, "FruitESP", "Fruit ESP")

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