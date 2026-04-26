-- CatHUB v9.2: Authentic RedzHub Style
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- RedzHub Exact Colors
local C = {
    Base = Color3.fromRGB(25, 25, 25),
    Side = Color3.fromRGB(20, 20, 20),
    Top = Color3.fromRGB(30, 30, 30),
    Card = Color3.fromRGB(35, 35, 35),
    CardHov = Color3.fromRGB(42, 42, 42),
    Text = Color3.fromRGB(205, 205, 205),
    TextSec = Color3.fromRGB(145, 145, 145),
    TextDim = Color3.fromRGB(85, 85, 85),
    Green = Color3.fromRGB(85, 170, 85), -- RedzHub toggle ON
    Off = Color3.fromRGB(45, 45, 45),
    SecLine = Color3.fromRGB(50, 50, 50)
}

-- Reopen Button
local OpenBtn = Instance.new("TextButton", Gui)
OpenBtn.Size = UDim2.new(0, 90, 0, 28)
OpenBtn.Position = UDim2.new(0, 15, 0.5, 0)
OpenBtn.BackgroundColor3 = C.Card
OpenBtn.TextColor3 = C.Text
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 11
OpenBtn.Text = "CatHUB"
OpenBtn.Visible = false
OpenBtn.BorderSizePixel = 0
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 4)

-- Main Frame
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 550, 0, 370)
Main.Position = UDim2.new(0.5, -275, 0.5, -185)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

-- Top Bar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 28)
Top.BackgroundColor3 = C.Top
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 6)

local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 6)
TopFix.Position = UDim2.new(0, 0, 1, -6)
TopFix.BackgroundColor3 = C.Top
TopFix.BorderSizePixel = 0

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
BtnX.Size = UDim2.new(0, 28, 0, 28)
BtnX.Position = UDim2.new(1, -28, 0, 0)
BtnX.Text = "×"
BtnX.TextColor3 = C.TextDim
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 16

local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 28, 0, 28)
BtnM.Position = UDim2.new(1, -56, 0, 0)
BtnM.Text = "—"
BtnM.TextColor3 = C.TextDim
BtnM.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnM.TextSize = 14

BtnX.MouseEnter:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play() end)
BtnX.MouseLeave:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.1), {TextColor3 = C.TextDim}):Play() end)

-- Close/Reopen Logic
BtnX.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- Minimize Logic (Nggulung)
local isMin = false
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    local SideF = Main:FindFirstChild("Side")
    local ContF = Main:FindFirstChild("Content")
    if isMin then
        if SideF then SideF.Visible = false end
        if ContF then ContF.Visible = false end
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 550, 0, 28)
        }):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 550, 0, 370)
        }):Play()
        task.wait(0.12)
        if SideF then SideF.Visible = true end
        if ContF then ContF.Visible = true end
    end
end)

-- Hotkey
UserInput.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
        OpenBtn.Visible = not Main.Visible
    end
end)

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 105, 1, -28)
Side.Position = UDim2.new(0, 0, 0, 28)
Side.BackgroundColor3 = C.Side
Side.BorderSizePixel = 0

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 2)
local SidePad = Instance.new("UIPadding", Side)
SidePad.PaddingTop = UDim.new(0, 6)
SidePad.PaddingLeft = UDim.new(0, 4)
SidePad.PaddingRight = UDim.new(0, 4)

local Pages = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, -8, 0, 28)
    Btn.BackgroundColor3 = isFirst and C.Base or C.Side
    Btn.Text = "  " .. name
    Btn.TextColor3 = isFirst and C.Text or C.TextDim
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = "Left"
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    Btn.MouseEnter:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Card, TextColor3 = C.TextSec}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if Pages[name].Visible then return end
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Side, TextColor3 = C.TextDim}):Play()
    end)
    
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Name = name .. "Pg"
    Page.Size = UDim2.new(1, -120, 1, -36)
    Page.Position = UDim2.new(0, 112, 0, 32)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
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

-- Section Header (RedzHub Style: Bold text + line)
local function Section(parent, text)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 22)
    F.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    F.BorderSizePixel = 0
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(0, 100, 1, 0)
    L.Position = UDim2.new(0, 2, 0, 0)
    L.Text = text
    L.TextColor3 = C.Text
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

-- Toggle (RedzHub Style: Green ON)
local function Toggle(parent, key, text)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, 0, 0, 32)
    F.BackgroundColor3 = C.Card
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
    F.Text = ""
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -55, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = text
    L.TextColor3 = C.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 12
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 36, 0, 18)
    Sw.Position = UDim2.new(1, -46, 0.5, -9)
    Sw.BackgroundColor3 = S[key] and C.Green or C.Off
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
            BackgroundColor3 = S[key] and C.Green or C.Off
        }):Play()
    end)
end

Section(EspPage, "DEVIL FRUITS")
Toggle(EspPage, "FruitESP", "Fruit ESP")

-- Drag
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