-- CatHUB FREEMIUM: UI Module (v6.2 - Tab Fix)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("CatHUB_Freemium") then CoreGui.CatHUB_Freemium:Destroy() end

local UI = {
    Visible = true,
    Collapsed = false,
    AccentColor = Color3.fromRGB(130, 80, 255),
    CurrentTab = nil,
    TabButtons = {},
    Settings = {
        -- ESP
        PlayerESP_Enabled = false,
        -- Fruits
        FruitESP_Enabled = false,
        TweenFruit_Enabled = false,
        AutoStore_Enabled = false,
        -- Teleport
        Tween_Enabled = false,
        Tween_Speed = 300,
        -- Combat
        LockAim_Enabled = false,
        AntiStun_Enabled = false,
        WalkWater_Enabled = false,
        FastRun_Enabled = false,
        Run_Speed = 16,
        HighJump_Enabled = false,
        Jump_Power = 50,
        -- Farm
        AutoFarm = false,
        AutoAttack = false,
        AutoSkill = false,
        BountyHunt = false,
        SafeMode = true
    }
}

function UI:Save() pcall(function() writefile("CatHUB_Config.json", HttpService:JSONEncode(self.Settings)) end) end
function UI:Load() 
    if isfile and isfile("CatHUB_Config.json") then 
        local s, d = pcall(function() return HttpService:JSONDecode(readfile("CatHUB_Config.json")) end)
        if s then for k, v in pairs(d) do self.Settings[k] = v end end
    end 
end
UI:Load()

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CatHUB_Freemium"
ScreenGui.ResetOnSpawn = false
UI.MainGui = ScreenGui

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 340)
Main.Position = UDim2.new(0.5, -240, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(45, 45, 45)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

-- Drag Logic
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "CATHUB FREEMIUM v6.2"
Title.TextColor3 = UI.AccentColor
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0, 32, 0, 32)
Close.Position = UDim2.new(1, -32, 0, 0)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(150, 150, 150)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Minimize = Instance.new("TextButton", TopBar)
Minimize.Size = UDim2.new(0, 32, 0, 32)
Minimize.Position = UDim2.new(1, -64, 0, 0)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(150, 150, 150)
Minimize.BackgroundTransparency = 1
Minimize.MouseButton1Click:Connect(function()
    UI.Collapsed = not UI.Collapsed
    Main:FindFirstChild("Sidebar").Visible = not UI.Collapsed
    Main:FindFirstChild("ContentArea").Visible = not UI.Collapsed
    Main:TweenSize(UI.Collapsed and UDim2.new(0, 480, 0, 32) or UDim2.new(0, 480, 0, 340), "Out", "Quad", 0.2, true)
end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, -42)
Sidebar.Position = UDim2.new(0, 5, 0, 37)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local TabList = Instance.new("ScrollingFrame", Sidebar)
TabList.Size = UDim2.new(1, -6, 1, -6)
TabList.Position = UDim2.new(0, 3, 0, 3)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 3)

local ContentArea = Instance.new("Frame", Main)
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -135, 1, -42)
ContentArea.Position = UDim2.new(0, 130, 0, 37)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true

function UI:CreateTab(name)
    local Container = Instance.new("ScrollingFrame", ContentArea)
    Container.Size = UDim2.new(1, -10, 1, -10)
    Container.Position = UDim2.new(0, 5, 0, 5)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 4)

    local B = Instance.new("TextButton", TabList)
    B.Size = UDim2.new(1, 0, 0, 30)
    B.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    B.Text = name:upper()
    B.TextColor3 = Color3.fromRGB(120, 120, 120)
    B.Font = Enum.Font.SourceSansBold
    B.TextSize = 10
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 5)
    
    table.insert(self.TabButtons, {Button = B, Container = Container})

    B.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabButtons) do
            v.Container.Visible = false
            v.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            v.Button.TextColor3 = Color3.fromRGB(120, 120, 120)
        end
        Container.Visible = true
        B.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
        B.TextColor3 = self.AccentColor
        self.CurrentTab = Container
    end)
    
    return Container
end

-- Auto show first tab after delay
task.spawn(function()
    task.wait(0.5)
    if #self.TabButtons > 0 then
        self.TabButtons[1].Button.MouseButton1Click:Fire()
    end
end)

function UI:CreateSwitch(parent, set, title, cb)
    local C = Instance.new("Frame", parent)
    C.Size = UDim2.new(1, 0, 0, 32)
    C.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", C).CornerRadius = UDim.new(0, 4)
    
    local L = Instance.new("TextLabel", C)
    L.Size = UDim2.new(1, -50, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = title
    L.TextColor3 = Color3.fromRGB(200, 200, 200)
    L.Font = Enum.Font.SourceSans
    L.TextSize = 11
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1
    
    local Sw = Instance.new("TextButton", C)
    Sw.Size = UDim2.new(0, 36, 0, 16)
    Sw.Position = UDim2.new(1, -44, 0.5, -8)
    Sw.BackgroundColor3 = self.Settings[set] and self.AccentColor or Color3.fromRGB(40, 40, 40)
    Sw.Text = ""
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    
    local K = Instance.new("Frame", Sw)
    K.Size = UDim2.new(0, 12, 0, 12)
    K.Position = self.Settings[set] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    K.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", K).CornerRadius = UDim.new(1, 0)
    
    Sw.MouseButton1Click:Connect(function()
        self.Settings[set] = not self.Settings[set]
        TweenService:Create(K, TweenInfo.new(0.2), {Position = self.Settings[set] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = self.Settings[set] and self.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
        self:Save()
        if cb then cb(self.Settings[set]) end
    end)
end

function UI:CreateSlider(parent, set, title, min, max, cb)
    local C = Instance.new("Frame", parent)
    C.Size = UDim2.new(1, 0, 0, 42)
    C.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", C).CornerRadius = UDim.new(0, 4)
    
    local T = Instance.new("TextLabel", C)
    T.Size = UDim2.new(1, 0, 0, 18)
    T.Position = UDim2.new(0, 10, 0, 3)
    T.Text = title .. ": " .. self.Settings[set]
    T.TextColor3 = Color3.fromRGB(255, 255, 255)
    T.Font = Enum.Font.SourceSans
    T.TextSize = 10
    T.TextXAlignment = "Left"
    T.BackgroundTransparency = 1
    
    local B = Instance.new("Frame", C)
    B.Size = UDim2.new(1, -20, 0, 4)
    B.Position = UDim2.new(0, 10, 0, 28)
    B.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local F = Instance.new("Frame", B)
    F.Size = UDim2.new((self.Settings[set]-min)/(max-min), 0, 1, 0)
    F.BackgroundColor3 = self.AccentColor
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

function UI:CreateLabel(parent, text, color)
    local L = Instance.new("TextLabel", parent)
    L.Size = UDim2.new(1, 0, 0, 20)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = color or Color3.fromRGB(180, 130, 255)
    L.Font = Enum.Font.SourceSansBold
    L.TextSize = 11
    L.TextXAlignment = "Left"
    return L
end

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        UI.Visible = not UI.Visible
        Main.Visible = UI.Visible
    end
end)

return UI