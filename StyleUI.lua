-- CatHUB v12.0 | HTML to Luau Translation
-- Focus: Ultra-Clean UI, Smooth Animations, & Multi-Tab System

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatHUB_v12") then CoreGui.CatHUB_v12:Destroy() end

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatHUB_v12"

-- ==========================================
-- THEME & STYLE (Translasi dari CSS)
-- ==========================================
local Theme = {
    Background = Color3.fromRGB(20, 23, 40),      -- #1a1d2e
    Sidebar = Color3.fromRGB(15, 17, 34),         -- #0f1122
    TopBar = Color3.fromRGB(15, 18, 33),          -- #0f1221
    Accent = Color3.fromRGB(77, 120, 240),       -- #4d78f0 (Blue)
    Red = Color3.fromRGB(232, 51, 58),            -- #e8333a
    Stroke = Color3.fromRGB(45, 49, 88),          -- #2d3158
    Text = Color3.fromRGB(192, 200, 232),         -- #c0c8e8
    TextDim = Color3.fromRGB(90, 96, 128),        -- #5a6080
    Row = Color3.fromRGB(26, 29, 48),             -- #1a1d30
}

local function Round(obj, r)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, r)
end

local function AddStroke(obj, color, thickness)
    local s = Instance.new("UIStroke", obj)
    s.Color = color
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

-- ==========================================
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 580, 0, 460) -- Sesuai Tinggi Layout HTML
Main.Position = UDim2.new(0.5, -290, 0.5, -230)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Round(Main, 12)
AddStroke(Main, Theme.Stroke, 1)

-- Shadow Effect (Drop Shadow)
local Shadow = Instance.new("ImageLabel", Main)
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 50, 1, 50)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6015667341"
Shadow.ImageColor3 = Color3.new(0,0,0)
Shadow.ImageTransparency = 0.5
Shadow.ZIndex = 0

-- ==========================================
-- TITLE BAR (RZ Logo + Title)
-- ==========================================
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Theme.TopBar
AddStroke(TitleBar, Color3.fromRGB(37, 40, 69), 1)

local IconBox = Instance.new("Frame", TitleBar)
IconBox.Size = UDim2.new(0, 28, 0, 28)
IconBox.Position = UDim2.new(0, 14, 0.5, -14)
IconBox.BackgroundColor3 = Theme.Red
Round(IconBox, 6)

local IconText = Instance.new("TextLabel", IconBox)
IconText.Size = UDim2.new(1, 0, 1, 0)
IconText.Text = "RZ"
IconText.TextColor3 = Color3.new(1,1,1)
IconText.Font = Enum.Font.GothamBold
IconText.TextSize = 10
IconText.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TitleBar)
Title.Position = UDim2.new(0, 52, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Text = "redz Hub <font color='#5a6080'>[BETA]</font> : Blox Fruits"
Title.RichText = true
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 13
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

-- ==========================================
-- SIDEBAR
-- ==========================================
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 148, 1, -84) -- Potong Topbar & Bottombar
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundColor3 = Theme.Sidebar
AddStroke(Sidebar, Color3.fromRGB(37, 40, 69), 1)

local SideScroll = Instance.new("ScrollingFrame", Sidebar)
SideScroll.Size = UDim2.new(1, 0, 1, 0)
SideScroll.BackgroundTransparency = 1
SideScroll.ScrollBarThickness = 0
SideScroll.CanvasSize = UDim2.new(0,0,0,0)
SideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SideList = Instance.new("UIListLayout", SideScroll)
SideList.Padding = UDim.new(0, 2)

-- ==========================================
-- BOTTOM BAR
-- ==========================================
local BottomBar = Instance.new("Frame", Main)
BottomBar.Size = UDim2.new(1, 0, 0, 40)
BottomBar.Position = UDim2.new(0, 0, 1, -40)
BottomBar.BackgroundColor3 = Theme.Sidebar
AddStroke(BottomBar, Color3.fromRGB(37, 40, 69), 1)

local VerText = Instance.new("TextLabel", BottomBar)
VerText.Size = UDim2.new(1, -15, 1, 0)
VerText.Position = UDim2.new(0, 0, 0, 0)
VerText.Text = "v2.4.1 — redz hub"
VerText.TextColor3 = Color3.fromRGB(58, 64, 96)
VerText.Font = Enum.Font.Gotham
VerText.TextSize = 10
VerText.TextXAlignment = "Right"
VerText.BackgroundTransparency = 1

-- ==========================================
-- CONTENT AREA
-- ==========================================
local ContentHolder = Instance.new("Frame", Main)
ContentHolder.Size = UDim2.new(1, -148, 1, -84)
ContentHolder.Position = UDim2.new(0, 148, 0, 44)
ContentHolder.BackgroundTransparency = 1

local Tabs = {}
local function CreateTab(name, icon)
    local Page = Instance.new("ScrollingFrame", ContentHolder)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Theme.Stroke
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 10)
    Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0, 12)
    Instance.new("UIPadding", Page).PaddingRight = UDim.new(0, 12)

    local TabBtn = Instance.new("TextButton", SideScroll)
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.BackgroundColor3 = Theme.Sidebar
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = "      " .. name
    TabBtn.TextColor3 = Theme.TextDim
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 12
    TabBtn.TextXAlignment = "Left"
    
    local Indicator = Instance.new("Frame", TabBtn)
    Indicator.Size = UDim2.new(0, 2, 1, 0)
    Indicator.BackgroundColor3 = Theme.Accent
    Indicator.Visible = false

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do 
            v.Page.Visible = false 
            v.Btn.TextColor3 = Theme.TextDim
            v.Ind.Visible = false
        end
        Page.Visible = true
        TabBtn.TextColor3 = Theme.Text
        Indicator.Visible = true
    end)

    Tabs[name] = {Page = Page, Btn = TabBtn, Ind = Indicator}
    return Page
end

-- ==========================================
-- COMPONENTS (Toggle, Section, etc)
-- ==========================================
local function AddSection(parent, text)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Text = text:upper()
    l.TextColor3 = Color3.fromRGB(136, 144, 184)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
end

local function AddToggle(parent, text, sub)
    local Row = Instance.new("TextButton", parent)
    Row.Size = UDim2.new(1, 0, 0, 45)
    Row.BackgroundColor3 = Theme.Row
    Row.Text = ""
    Round(Row, 8)
    AddStroke(Row, Color3.fromRGB(37, 40, 69), 1)

    local Label = Instance.new("TextLabel", Row)
    Label.Size = UDim2.new(1, -60, 0, 20)
    Label.Position = UDim2.new(0, 12, 0, 5)
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = "Left"
    Label.BackgroundTransparency = 1

    if sub then
        local Sub = Instance.new("TextLabel", Row)
        Sub.Size = UDim2.new(1, -60, 0, 15)
        Sub.Position = UDim2.new(0, 12, 0, 22)
        Sub.Text = sub
        Sub.TextColor3 = Theme.TextDim
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 10.5
        Sub.TextXAlignment = "Left"
        Sub.BackgroundTransparency = 1
    end

    local TogBG = Instance.new("Frame", Row)
    TogBG.Size = UDim2.new(0, 38, 0, 21)
    TogBG.Position = UDim2.new(1, -50, 0.5, -10)
    TogBG.BackgroundColor3 = Color3.fromRGB(37, 40, 69)
    Round(TogBG, 11)

    local Dot = Instance.new("Frame", TogBG)
    Dot.Size = UDim2.new(0, 15, 0, 15)
    Dot.Position = UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.new(1,1,1)
    Round(Dot, 15)

    local active = false
    Row.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(TogBG, TweenInfo.new(0.2), {BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(37, 40, 69)}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
    end)
end

-- ==========================================
-- IMPLEMENTASI TAB & FITUR
-- ==========================================
local FarmPage = CreateTab("Farm", "⚔️")
AddSection(FarmPage, "Events")
AddToggle(FarmPage, "Auto Celestial Soldier")
AddToggle(FarmPage, "Auto Rip Commander")
AddSection(FarmPage, "Collect")
AddToggle(FarmPage, "Auto Chest [Tween]", "Collect all nearby chests")

local VisualPage = CreateTab("Visual", "🎨")
AddSection(VisualPage, "ESP")
AddToggle(VisualPage, "Player ESP", "Show players through walls")
AddToggle(VisualPage, "Chest ESP")

-- Aktifkan Tab Farm Pertama kali
Tabs["Farm"].Btn.TextColor3 = Theme.Text
Tabs["Farm"].Ind.Visible = true
Tabs["Farm"].Page.Visible = true

-- ==========================================
-- DRAGGING LOGIC
-- ==========================================
local drag, dStart, sPos
TitleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dStart = i.Position; sPos = Main.Position end end)
UserInput.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dStart
        Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)
UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)