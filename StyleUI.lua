-- CatHUB v9.4: RedzHub Aesthetic Remake
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

local S = _G.Cat.Settings

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- RedzHub Inspired Palette
local C = {
    Base = Color3.fromRGB(15, 15, 17),
    Side = Color3.fromRGB(22, 22, 26),
    Top = Color3.fromRGB(22, 22, 26),
    Card = Color3.fromRGB(30, 30, 35),
    CardHov = Color3.fromRGB(40, 40, 48),
    Text = Color3.fromRGB(240, 240, 245),
    TextSec = Color3.fromRGB(160, 160, 170),
    Blue = Color3.fromRGB(88, 101, 242), -- Blurple style
    Off = Color3.fromRGB(45, 45, 52),
    Stroke = Color3.fromRGB(45, 45, 50)
}

-- Helper: Add Rounded Corner & Stroke
local function AddVisuals(obj, radius, strokeColor)
    local corner = Instance.new("UICorner", obj)
    corner.CornerRadius = UDim.new(0, radius)
    
    if strokeColor then
        local stroke = Instance.new("UIStroke", obj)
        stroke.Color = strokeColor
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Transparency = 0.6
    end
end

-- ==========================================
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 580, 0, 360)
Main.Position = UDim2.new(0.5, -290, 0.5, -180)
Main.BackgroundColor3 = C.Base
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
AddVisuals(Main, 10, C.Stroke)

-- Sidebar Background
local SideBg = Instance.new("Frame", Main)
SideBg.Size = UDim2.new(0, 140, 1, 0)
SideBg.BackgroundColor3 = C.Side
SideBg.BorderSizePixel = 0
AddVisuals(SideBg, 10) -- Biar ikut rounded kiri

-- Separator Line
local Sep = Instance.new("Frame", Main)
Sep.Size = UDim2.new(0, 1, 1, 0)
Sep.Position = UDim2.new(0, 140, 0, 0)
Sep.BackgroundColor3 = C.Stroke
Sep.BackgroundTransparency = 0.5
Sep.BorderSizePixel = 0

-- Scrolling Sidebar
local Side = Instance.new("ScrollingFrame", SideBg)
Side.Size = UDim2.new(1, 0, 1, -40)
Side.Position = UDim2.new(0, 0, 0, 40)
Side.BackgroundTransparency = 1
Side.ScrollBarThickness = 0
Side.CanvasSize = UDim2.new(0, 0, 0, 0)
Side.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 5)
local SidePad = Instance.new("UIPadding", Side)
SidePad.PaddingTop = UDim.new(0, 5)
SidePad.PaddingLeft = UDim.new(0, 10)
SidePad.PaddingRight = UDim.new(0, 10)

-- Title / Logo
local Logo = Instance.new("TextLabel", SideBg)
Logo.Size = UDim2.new(1, 0, 0, 40)
Logo.Text = "CatHUB"
Logo.TextColor3 = C.Blue
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 16
Logo.BackgroundTransparency = 1

local Pages = {}

local function CreateTab(name, iconId, isFirst)
    local Btn = Instance.new("TextButton", Side)
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = isFirst and C.Card or Color3.fromRGB(255,255,255)
    Btn.BackgroundTransparency = isFirst and 0 or 1
    Btn.Text = ""
    Btn.AutoButtonColor = false
    AddVisuals(Btn, 8)
    
    local Icon = Instance.new("ImageLabel", Btn)
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0, 10, 0.5, -9)
    Icon.Image = iconId or "rbxassetid://6034287525"
    Icon.ImageColor3 = isFirst and C.Text or C.TextSec
    Icon.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", Btn)
    lbl.Size = UDim2.new(1, -35, 1, 0)
    lbl.Position = UDim2.new(0, 35, 0, 0)
    lbl.Text = name
    lbl.TextColor3 = isFirst and C.Text or C.TextSec
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = "Left"
    lbl.BackgroundTransparency = 1

    local Page = Instance.new("ScrollingFrame", Main)
    Page.Size = UDim2.new(1, -160, 1, -20)
    Page.Position = UDim2.new(0, 150, 0, 10)
    Page.BackgroundTransparency = 1
    Page.Visible = isFirst
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = C.Blue
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", Page).PaddingRight = UDim.new(0, 5)

    Pages[name] = {Page = Page, Button = Btn, Icon = Icon, Label = lbl}

    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do
            v.Page.Visible = false
            TweenService:Create(v.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(v.Icon, TweenInfo.new(0.2), {ImageColor3 = C.TextSec}):Play()
            TweenService:Create(v.Label, TweenInfo.new(0.2), {TextColor3 = C.TextSec}):Play()
        end
        Page.Visible = true
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = C.Card}):Play()
        TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = C.Text}):Play()
        TweenService:Create(lbl, TweenInfo.new(0.2), {TextColor3 = C.Text}):Play()
    end)

    return Page
end

-- ==========================================
-- COMPONENTS (TOGGLE & SECTION)
-- ==========================================
local function Section(parent, text)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 25)
    F.BackgroundTransparency = 1
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Text = text:upper()
    L.TextColor3 = C.Blue
    L.Font = Enum.Font.GothamBold
    L.TextSize = 11
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
end

local function Toggle(parent, key, text)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, 0, 0, 42)
    F.BackgroundColor3 = C.Card
    F.AutoButtonColor = false
    F.Text = ""
    AddVisuals(F, 8, C.Stroke)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = text
    L.TextColor3 = C.Text
    L.Font = Enum.Font.Gotham
    L.TextSize = 14
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 34, 0, 18)
    Sw.Position = UDim2.new(1, -44, 0.5, -9)
    Sw.BackgroundColor3 = S[key] and C.Blue or C.Off
    AddVisuals(Sw, 10)
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 12, 0, 12)
    Dot.Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AddVisuals(Dot, 10)
    
    F.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = S[key] and C.Blue or C.Off}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = S[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
end

-- ==========================================
-- SETUP CONTENT
-- ==========================================
local EspPage = CreateTab("Visual", "rbxassetid://6034287525", true)
local FarmPage = CreateTab("Farming", "rbxassetid://6031265917", false)

Section(EspPage, "Player ESP")
Toggle(EspPage, "FruitESP", "Enable Fruit ESP")
Section(EspPage, "World")
Toggle(EspPage, "ChestESP", "Auto Chest Finder")

-- Dragging Logic
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInput.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
Main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)