-- CatHUB SUPREMACY: UI Library v10.0
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("CatHUB_v10") then CoreGui.CatHUB_v10:Destroy() end

local UI = {
    Visible = true,
    Collapsed = false,
    Accent = Color3.fromRGB(140, 90, 255),
    Settings = {
        AutoFarm = false, AutoAttack = false, AutoSkill = false, SafeMode = true,
        ESP_Fruits = false, ESP_Players = false, AutoStore = false,
        LockAim = false, AntiStun = true, WalkWater = false,
        RunSpeed = 16, JumpPower = 50, TweenSpeed = 300
    }
}

function UI:Save() pcall(function() writefile("CatHUB_v10.json", HttpService:JSONEncode(self.Settings)) end) end
function UI:Load() 
    if isfile and isfile("CatHUB_v10.json") then 
        local s, d = pcall(function() return HttpService:JSONDecode(readfile("CatHUB_v10.json")) end)
        if s then for k,v in pairs(d) do self.Settings[k] = v end end
    end 
end
UI:Load()

local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "CatHUB_v10"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(40, 40, 40)

-- HEADER & DRAG (FIXED)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", TopBar)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function() dragging = false end)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "CATHUB SUPREMACY v10.0"; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = "SourceSansBold"; Title.TextSize = 14; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -30, 0, 0)
Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 50, 50); Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Mini = Instance.new("TextButton", TopBar)
Mini.Size = UDim2.new(0, 30, 0, 30); Mini.Position = UDim2.new(1, -60, 0, 0)
Mini.Text = "-"; Mini.TextColor3 = Color3.fromRGB(200, 200, 200); Mini.BackgroundTransparency = 1
Mini.MouseButton1Click:Connect(function()
    UI.Collapsed = not UI.Collapsed
    Main:FindFirstChild("Sidebar").Visible = not UI.Collapsed
    Main:FindFirstChild("Content").Visible = not UI.Collapsed
    Main:TweenSize(UI.Collapsed and UDim2.new(0, 520, 0, 32) or UDim2.new(0, 520, 0, 340), "Out", "Quad", 0.2, true)
end)

-- MODULAR FRAMEWORK
local Sidebar = Instance.new("Frame", Main)
Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, 130, 1, -42); Sidebar.Position = UDim2.new(0, 5, 0, 37)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 8); Instance.new("UICorner", Sidebar)

local TabList = Instance.new("ScrollingFrame", Sidebar)
TabList.Size = UDim2.new(1, -6, 1, -6); TabList.Position = UDim2.new(0, 3, 0, 3)
TabList.BackgroundTransparency = 1; TabList.ScrollBarThickness = 0
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame", Main)
ContentArea.Name = "Content"; ContentArea.Size = UDim2.new(1, -145, 1, -42); ContentArea.Position = UDim2.new(0, 140, 0, 37)
ContentArea.BackgroundTransparency = 1

function UI:NewTab(name)
    local C = Instance.new("ScrollingFrame", ContentArea)
    C.Size = UDim2.new(1, -10, 1, -10); C.Position = UDim2.new(0, 5, 0, 5)
    C.BackgroundTransparency = 1; C.Visible = false; C.ScrollBarThickness = 2
    Instance.new("UIListLayout", C).Padding = UDim.new(0, 6)
    local B = Instance.new("TextButton", TabList)
    B.Size = UDim2.new(1, 0, 0, 38); B.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    B.Text = name:upper(); B.TextColor3 = Color3.fromRGB(150, 150, 150); B.Font = "SourceSansBold"; B.TextSize = 11; Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        if self.CurrentTab then self.CurrentTab.Visible = false end
        C.Visible = true; self.CurrentTab = C
        for _,v in pairs(TabList:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(20, 20, 20) end end
        B.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
    return C
end

function UI:NewSwitch(parent, set, title, cb)
    local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, 38); F.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", F)
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, -50, 1, 0); L.Position = UDim2.new(0, 10, 0, 0); L.Text = title; L.TextColor3 = Color3.fromRGB(220, 220, 220); L.Font = "SourceSansBold"; L.TextSize = 12; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
    local Sw = Instance.new("TextButton", F); Sw.Size = UDim2.new(0, 34, 0, 18); Sw.Position = UDim2.new(1, -44, 0.5, -9); Sw.BackgroundColor3 = self.Settings[set] and self.Accent or Color3.fromRGB(45, 45, 45); Sw.Text = ""; Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    local K = Instance.new("Frame", Sw); K.Size = UDim2.new(0, 12, 0, 12); K.Position = self.Settings[set] and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6); K.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", K).CornerRadius = UDim.new(1, 0)
    Sw.MouseButton1Click:Connect(function()
        self.Settings[set] = not self.Settings[set]; TweenService:Create(K, TweenInfo.new(0.2), {Position = self.Settings[set] and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)}):Play(); TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = self.Settings[set] and self.Accent or Color3.fromRGB(45, 45, 45)}):Play(); self:Save()
        if cb then cb(self.Settings[set]) end
    end)
end

function UI:NewSlider(parent, set, title, min, max, cb)
    local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, 45); F.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", F)
    local T = Instance.new("TextLabel", F); T.Size = UDim2.new(1, 0, 0, 20); T.Position = UDim2.new(0, 10, 0, 5); T.Text = title .. ": " .. self.Settings[set]; T.TextColor3 = Color3.fromRGB(255, 255, 255); T.Font = "SourceSansBold"; T.TextSize = 11; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", F); Bar.Size = UDim2.new(1, -24, 0, 4); Bar.Position = UDim2.new(0, 12, 0, 32); Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((self.Settings[set]-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = self.Accent
    local drag = false
    local function up()
        local r = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max-min)*r); Fill.Size = UDim2.new(r, 0, 1, 0); T.Text = title .. ": " .. val; UI.Settings[set] = val; UI:Save()
        if cb then cb(val) end
    end
    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true up() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then up() end end)
end

UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then UI.Visible = not UI.Visible; Main.Visible = UI.Visible end end)

return UI