-- CatHUB FREEMIUM: UI Module (v6.3 - RedzHub Style)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("CatHUB_Premium") then CoreGui.CatHUB_Premium:Destroy() end

local UI = {
    Visible = true,
    Collapsed = false,
    AccentColor = Color3.fromRGB(138, 43, 226), -- Purple theme
    DarkAccent = Color3.fromRGB(25, 15, 40),
    CurrentTab = nil,
    TabButtons = {},
    Settings = {
        -- Fruits
        FruitESP_Enabled = false,
        FruitHighlight_Enabled = false,
        TweenFruit_Enabled = false,
        AutoStore_Enabled = false,
        FruitNotify_Enabled = false,
        -- Player ESP
        PlayerESP_Enabled = false,
        PlayerHealth_Enabled = true,
        PlayerWeapon_Enabled = true,
        -- Combat
        LockAim_Enabled = false,
        AntiStun_Enabled = false,
        WalkWater_Enabled = false,
        NoClip_Enabled = false,
        FastRun_Enabled = false,
        Run_Speed = 22,
        HighJump_Enabled = false,
        Jump_Power = 60,
        -- Farm
        AutoFarm = false,
        AutoAttack = false,
        AutoSkill = false,
        AutoQuest = false,
        BountyHunt = false,
        SafeMode = true,
        BringMob_Enabled = false,
        -- Teleport
        Tween_Enabled = true,
        Tween_Speed = 350,
        -- Sea Events
        AutoSeaBeast = false,
        AutoShipRaid = false,
        -- Misc
        FPSBoost_Enabled = false,
        AntiAFK_Enabled = false,
    }
}

function UI:Save() pcall(function() writefile("CatHUB_Premium.json", HttpService:JSONEncode(self.Settings)) end) end
function UI:Load() 
    if isfile and isfile("CatHUB_Premium.json") then 
        local s, d = pcall(function() return HttpService:JSONDecode(readfile("CatHUB_Premium.json")) end)
        if s then for k, v in pairs(d) do self.Settings[k] = v end end
    end 
end
UI:Load()

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CatHUB_Premium"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 380)
Main.Position = UDim2.new(0.5, -250, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(60, 40, 100)
Instance.new("UIStroke", Main).Thickness = 1

-- Top Bar with Gradient
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = UI.DarkAccent
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Gradient = Instance.new("UIGradient", TopBar)
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 30, 120))
})
Gradient.Rotation = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "🟣 CATHUB PREMIUM v6.3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

local Version = Instance.new("TextLabel", TopBar)
Version.Size = UDim2.new(0, 50, 0, 20)
Version.Position = UDim2.new(0, 15, 1, -22)
Version.Text = "REDFORD STYLE"
Version.TextColor3 = Color3.fromRGB(150, 100, 255)
Version.Font = Enum.Font.Gotham
Version.TextSize = 8
Version.BackgroundTransparency = 1

local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -35, 0, 2)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(200, 100, 100)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Minimize = Instance.new("TextButton", TopBar)
Minimize.Size = UDim2.new(0, 35, 0, 35)
Minimize.Position = UDim2.new(1, -70, 0, 2)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(150, 150, 150)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 14
Minimize.BackgroundTransparency = 1
Minimize.MouseButton1Click:Connect(function()
    UI.Collapsed = not UI.Collapsed
    Main:FindFirstChild("Sidebar").Visible = not UI.Collapsed
    Main:FindFirstChild("ContentArea").Visible = not UI.Collapsed
    Main:TweenSize(UI.Collapsed and UDim2.new(0, 500, 0, 38) or UDim2.new(0, 500, 0, 380), "Out", "Quad", 0.25, true)
end)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 125, 1, -48)
Sidebar.Position = UDim2.new(0, 5, 0, 43)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local TabList = Instance.new("ScrollingFrame", Sidebar)
TabList.Size = UDim2.new(1, -8, 1, -8)
TabList.Position = UDim2.new(0, 4, 0, 4)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
local TabLayout = Instance.new("UIListLayout", TabList)
TabLayout.Padding = UDim.new(0, 4)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content Area
local ContentArea = Instance.new("Frame", Main)
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -140, 1, -48)
ContentArea.Position = UDim2.new(0, 135, 0, 43)
ContentArea.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 8)
ContentArea.ClipsDescendants = true

-- Create Tab Function
local tabOrder = 0
function UI:CreateTab(name, icon)
    tabOrder = tabOrder + 1
    local Container = Instance.new("ScrollingFrame", ContentArea)
    Container.Size = UDim2.new(1, -15, 1, -15)
    Container.Position = UDim2.new(0, 8, 0, 8)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 3
    Container.ScrollBarImageColor3 = UI.AccentColor
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

    local B = Instance.new("TextButton", TabList)
    B.Size = UDim2.new(1, 0, 0, 32)
    B.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    B.Text = (icon or "") .. " " .. name
    B.TextColor3 = Color3.fromRGB(100, 100, 120)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 10
    B.LayoutOrder = tabOrder
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    
    local HoverEffect = Instance.new("UIStroke", B)
    HoverEffect.Color = UI.AccentColor
    HoverEffect.Transparency = 1
    HoverEffect.Thickness = 1
    
    B.MouseEnter:Connect(function()
        if B.BackgroundColor3.R < 0.2 then
            TweenService:Create(B, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 25, 45)}):Play()
            TweenService:Create(HoverEffect, TweenInfo.new(0.15), {Transparency = 0.7}):Play()
        end
    end)
    B.MouseLeave:Connect(function()
        if B.BackgroundColor3.R < 0.25 then
            TweenService:Create(B, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 30)}):Play()
            TweenService:Create(HoverEffect, TweenInfo.new(0.15), {Transparency = 1}):Play()
        end
    end)

    table.insert(self.TabButtons, {Button = B, Container = Container, Stroke = HoverEffect})

    B.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabButtons) do
            v.Container.Visible = false
            v.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            v.Button.TextColor3 = Color3.fromRGB(100, 100, 120)
            v.Stroke.Transparency = 1
        end
        Container.Visible = true
        B.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
        B.TextColor3 = UI.AccentColor
        HoverEffect.Transparency = 0
        self.CurrentTab = Container
    end)
    
    return Container
end

-- Auto show first tab
task.spawn(function()
    task.wait(0.3)
    if #self.TabButtons > 0 then
        self.TabButtons[1].Button.MouseButton1Click:Fire()
    end
end)

-- Create Switch
function UI:CreateSwitch(parent, set, title, cb)
    local C = Instance.new("Frame", parent)
    C.Size = UDim2.new(1, 0, 0, 34)
    C.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Instance.new("UICorner", C).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", C)
    L.Size = UDim2.new(1, -55, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = title
    L.TextColor3 = Color3.fromRGB(190, 190, 200)
    L.Font = Enum.Font.Gotham
    L.TextSize = 11
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("TextButton", C)
    Sw.Size = UDim2.new(0, 40, 0, 18)
    Sw.Position = UDim2.new(1, -48, 0.5, -9)
    Sw.BackgroundColor3 = self.Settings[set] and UI.AccentColor or Color3.fromRGB(45, 45, 55)
    Sw.Text = ""
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local K = Instance.new("Frame", Sw)
    K.Size = UDim2.new(0, 14, 0, 14)
    K.Position = self.Settings[set] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    K.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", K).CornerRadius = UDim.new(1, 0)
    
    Sw.MouseButton1Click:Connect(function()
        self.Settings[set] = not self.Settings[set]
        TweenService:Create(K, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = self.Settings[set] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = self.Settings[set] and UI.AccentColor or Color3.fromRGB(45, 45, 55)}):Play()
        self:Save()
        if cb then cb(self.Settings[set]) end
    end)
end

-- Create Slider
function UI:CreateSlider(parent, set, title, min, max, cb)
    local C = Instance.new("Frame", parent)
    C.Size = UDim2.new(1, 0, 0, 45)
    C.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Instance.new("UICorner", C).CornerRadius = UDim.new(0, 6)
    
    local T = Instance.new("TextLabel", C)
    T.Size = UDim2.new(1, 0, 0, 18)
    T.Position = UDim2.new(0, 12, 0, 4)
    T.Text = title .. ": " .. self.Settings[set]
    T.TextColor3 = Color3.fromRGB(220, 220, 230)
    T.Font = Enum.Font.Gotham
    T.TextSize = 10
    T.TextXAlignment = "Left"
    T.BackgroundTransparency = 1
    
    local B = Instance.new("Frame", C)
    B.Size = UDim2.new(1, -24, 0, 6)
    B.Position = UDim2.new(0, 12, 0, 30)
    B.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local F = Instance.new("Frame", B)
    F.Size = UDim2.new((self.Settings[set]-min)/(max-min), 0, 1, 0)
    F.BackgroundColor3 = UI.AccentColor
    Instance.new("UICorner", F).CornerRadius = UDim.new(1, 0)
    
    local drag = false
    local function update()
        local r = math.clamp((UserInputService:GetMouseLocation().X - B.AbsolutePosition.X)/B.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max-min)*r)
        F.Size = UDim2.new(r, 0, 1, 0)
        T.Text = title .. ": " .. val
        UI.Settings[set] = val
        UI:Save()
        if cb then cb(val) end
    end
    B.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true update() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
end

-- Create Section Header
function UI:CreateSection(parent, text)
    local S = Instance.new("Frame", parent)
    S.Size = UDim2.new(1, 0, 0, 28)
    S.BackgroundColor3 = UI.DarkAccent
    Instance.new("UICorner", S).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", S)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = "▸ " .. text
    L.TextColor3 = UI.AccentColor
    L.Font = Enum.Font.GothamBold
    L.TextSize = 10
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
end

-- Create Button
function UI:CreateButton(parent, text, cb)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, 0, 0, 32)
    B.BackgroundColor3 = UI.DarkAccent
    B.Text = text
    B.TextColor3 = Color3.fromRGB(200, 200, 210)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", B)
    Stroke.Color = UI.AccentColor
    Stroke.Transparency = 0.8
    
    B.MouseButton1Click:Connect(function()
        TweenService:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = UI.AccentColor}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.1), {Transparency = 0}):Play()
        task.wait(0.15)
        TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = UI.DarkAccent}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Transparency = 0.8}):Play()
        if cb then cb() end
    end)
end

-- Create Dropdown
function UI:CreateDropdown(parent, set, title, options, cb)
    local C = Instance.new("Frame", parent)
    C.Size = UDim2.new(1, 0, 0, 32)
    C.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Instance.new("UICorner", C).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", C)
    L.Size = UDim2.new(1, -30, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = title .. ": " .. (self.Settings[set] or "None")
    L.TextColor3 = Color3.fromRGB(190, 190, 200)
    L.Font = Enum.Font.Gotham
    L.TextSize = 10
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Arrow = Instance.new("TextLabel", C)
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -25, 0, 0)
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(150, 150, 160)
    Arrow.BackgroundTransparency = 1
    
    local isOpen = false
    local DropFrame = Instance.new("Frame", parent)
    DropFrame.Size = UDim2.new(1, 0, 0, #options * 28)
    DropFrame.Position = UDim2.new(0, 0, 0, 34)
    DropFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    DropFrame.Visible = false
    DropFrame.ZIndex = 10
    Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)
    
    local DropLayout = Instance.new("UIListLayout", DropFrame)
    DropLayout.Padding = UDim.new(0, 2)
    
    for i, opt in pairs(options) do
        local Opt = Instance.new("TextButton", DropFrame)
        Opt.Size = UDim2.new(1, -8, 0, 26)
        Opt.Position = UDim2.new(0, 4, 0, (i-1)*28)
        Opt.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        Opt.Text = opt
        Opt.TextColor3 = Color3.fromRGB(180, 180, 190)
        Opt.Font = Enum.Font.Gotham
        Opt.TextSize = 10
        Opt.ZIndex = 11
        Instance.new("UICorner", Opt).CornerRadius = UDim.new(0, 4)
        
        Opt.MouseButton1Click:Connect(function()
            self.Settings[set] = opt
            L.Text = title .. ": " .. opt
            DropFrame.Visible = false
            isOpen = false
            self:Save()
            if cb then cb(opt) end
        end)
    end
    
    C.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isOpen = not isOpen
            DropFrame.Visible = isOpen
        end
    end)
end

-- Hotkey
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then
        UI.Visible = not UI.Visible
        Main.Visible = UI.Visible
    end
end)

return UI