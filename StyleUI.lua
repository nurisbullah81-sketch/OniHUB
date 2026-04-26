-- CatHUB v8.1: UI Style (RedzHub Vibe)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatHUB_UI") then CoreGui.CatHUB_UI:Destroy() end

local Settings = _G.CatHub.Settings
local LocalPlayer = _G.CatHub.Player

-- Main GUI
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatHUB_UI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Root Frame
local Root = Instance.new("Frame", Gui)
Root.Size = UDim2.new(0, 460, 0, 320)
Root.Position = UDim2.new(0.5, -230, 0.5, -160)
Root.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Root.BorderSizePixel = 0
Instance.new("UICorner", Root).CornerRadius = UDim.new(0, 12)

local Border = Instance.new("UIStroke", Root)
Border.Color = Color3.fromRGB(55, 35, 90)
Border.Thickness = 1

-- Top Bar (Gradient Purple)
local Top = Instance.new("Frame", Root)
Top.Size = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = Color3.fromRGB(28, 20, 45)
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 12)

local Gradient = Instance.new("UIGradient", Top)
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 25, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 35, 120))
})

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Text = "CATHUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

local Ver = Instance.new("TextLabel", Top)
Ver.Size = UDim2.new(0, 40, 0, 14)
Ver.Position = UDim2.new(0, 16, 1, -16)
Ver.Text = "v8.1"
Ver.TextColor3 = Color3.fromRGB(140, 100, 220)
Ver.Font = Enum.Font.Gotham
Ver.TextSize = 9
Ver.BackgroundTransparency = 1

-- Buttons Top Right
local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 38, 0, 38)
BtnX.Position = UDim2.new(1, -38, 0, 0)
BtnX.Text = "×"
BtnX.TextColor3 = Color3.fromRGB(220, 100, 100)
BtnX.BackgroundTransparency = 1
BtnX.Font = Enum.Font.GothamBold
BtnX.TextSize = 18
BtnX.MouseButton1Click:Connect(function() Gui:Destroy() end)

local BtnMin = Instance.new("TextButton", Top)
BtnMin.Size = UDim2.new(0, 38, 0, 38)
BtnMin.Position = UDim2.new(1, -76, 0, 0)
BtnMin.Text = "—"
BtnMin.TextColor3 = Color3.fromRGB(140, 140, 160)
BtnMin.BackgroundTransparency = 1
BtnMin.Font = Enum.Font.GothamBold
BtnMin.TextSize = 16

local Content = Root:FindFirstChild("Content") or Instance.new("Frame", Root)
Content.Name = "Content"
Content.Size = UDim2.new(1, -135, 1, -48)
Content.Position = UDim2.new(0, 130, 0, 43)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true

local isMin = false
BtnMin.MouseButton1Click:Connect(function()
    isMin = not isMin
    Content.Visible = not isMin
    Root:FindFirstChild("Sidebar").Visible = not isMin
    Root:TweenSize(isMin and UDim2.new(0, 460, 0, 38) or UDim2.new(0, 460, 0, 320), "Out", "Quad", 0.2, true)
end)

-- Sidebar
local Side = Instance.new("Frame", Root)
Side.Name = "Sidebar"
Side.Size = UDim2.new(0, 120, 1, -48)
Side.Position = UDim2.new(0, 5, 0, 43)
Side.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Side.BorderSizePixel = 0
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 10)

local TabList = Instance.new("Frame", Side)
TabList.Size = UDim2.new(1, -8, 1, -8)
TabList.Position = UDim2.new(0, 4, 0, 4)
TabList.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabList)
TabLayout.Padding = UDim.new(0, 4)

-- Create Tab
local tabs = {}
local function CreateTab(name, active)
    local Btn = Instance.new("TextButton", TabList)
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = active and Color3.fromRGB(32, 24, 55) or Color3.fromRGB(20, 20, 28)
    Btn.Text = name
    Btn.TextColor3 = active and Color3.fromRGB(180, 140, 255) or Color3.fromRGB(80, 80, 100)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 7)
    
    table.insert(tabs, {Btn = Btn, Active = active})
    
    if not active then
        -- Coming Soon Tooltip
        Btn.MouseButton1Click:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 30, 60)}):Play()
            task.wait(0.15)
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 28)}):Play()
        end)
    end
    
    return Btn
end

-- Tabs (Hanya ESP yang aktif)
CreateTab("ESP", true)
CreateTab("Combat", false)
CreateTab("Farm", false)
CreateTab("Teleport", false)
CreateTab("Misc", false)

-- ==========================================
-- ESP TAB CONTENT (Only Active Tab)
-- ==========================================
local EspScroll = Instance.new("ScrollingFrame", Content)
EspScroll.Size = UDim2.new(1, -12, 1, -12)
EspScroll.Position = UDim2.new(0, 6, 0, 6)
EspScroll.BackgroundTransparency = 1
EspScroll.ScrollBarThickness = 2
EspScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 50, 140)
EspScroll.BorderSizePixel = 0
EspScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UIListLayout", EspScroll).Padding = UDim.new(0, 5)

-- Section Helper
local function Section(text)
    local f = Instance.new("Frame", EspScroll)
    f.Size = UDim2.new(1, 0, 0, 28)
    f.BackgroundColor3 = Color3.fromRGB(28, 20, 45)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.Text = text
    l.TextColor3 = Color3.fromRGB(170, 130, 255)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
end

-- Switch Helper
local function Switch(key, title, enabled)
    local f = Instance.new("Frame", EspScroll)
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -56, 1, 0)
    l.Position = UDim2.new(0, 14, 0, 0)
    l.Text = title
    l.TextColor3 = Color3.fromRGB(200, 200, 210)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    
    local sw = Instance.new("TextButton", f)
    sw.Size = UDim2.new(0, 42, 0, 20)
    sw.Position = UDim2.new(1, -50, 0.5, -10)
    sw.BackgroundColor3 = enabled and Color3.fromRGB(140, 80, 255) or Color3.fromRGB(50, 50, 60)
    sw.Text = ""
    sw.BorderSizePixel = 0
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", sw)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    sw.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        TweenService:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
            Position = Settings[key] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        TweenService:Create(sw, TweenInfo.new(0.15), {
            BackgroundColor3 = Settings[key] and Color3.fromRGB(140, 80, 255) or Color3.fromRGB(50, 50, 60)
        }):Play()
    end)
end

-- Disabled Switch Helper (Coming Soon)
local function SwitchDisabled(title)
    local f = Instance.new("Frame", EspScroll)
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -80, 1, 0)
    l.Position = UDim2.new(0, 14, 0, 0)
    l.Text = title
    l.TextColor3 = Color3.fromRGB(70, 70, 80)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    
    local soon = Instance.new("TextLabel", f)
    soon.Size = UDim2.new(0, 60, 1, 0)
    soon.Position = UDim2.new(1, -65, 0, 0)
    soon.Text = "SOON"
    soon.TextColor3 = Color3.fromRGB(90, 70, 120)
    soon.Font = Enum.Font.GothamBold
    soon.TextSize = 9
    soon.BackgroundTransparency = 1
    
    -- Fake toggle (off)
    local sw = Instance.new("Frame", f)
    sw.Size = UDim2.new(0, 42, 0, 20)
    sw.Position = UDim2.new(1, -50, 0.5, -10)
    sw.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    sw.BorderSizePixel = 0
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", sw)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0, 2, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
end

-- Build ESP Tab
Section("DEVIL FRUITS")
Switch("FruitESP", "Fruit ESP", false)

Section("PLAYERS")
SwitchDisabled("Player ESP")

Section("BOSSES")
SwitchDisabled("Boss ESP")

Section("CHESTS")
SwitchDisabled("Chest ESP")

Section("ISLANDS")
SwitchDisabled("Island ESP")

-- Drag Logic
local drag, dragStart, startPos
Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true; dragStart = i.Position; startPos = Root.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)

-- Hotkey
UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        Root.Visible = not Root.Visible
    end
end)