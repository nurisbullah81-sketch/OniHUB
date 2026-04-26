-- CatHUB v7.0: UI (Optimized)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("CatHUB_v7") then CoreGui.CatHUB_v7:Destroy() end

local UI = {
    Visible = true,
    Collapsed = false,
    Accent = Color3.fromRGB(138, 43, 226),
    Dark = Color3.fromRGB(18, 18, 25),
    TabButtons = {},
    Settings = {
        FruitESP = false, FruitHL = false, TweenFruit = false, AutoStore = false, FruitNotify = false,
        PlayerESP = false,
        AutoAttack = false, Aimbot = false, AntiStun = false, NoClip = false,
        FastRun = false, RunSpeed = 22, HighJump = false, JumpPower = 60,
        AutoFarm = false, AutoSkill = false, SafeMode = true,
        BountyHunt = false, BountyTarget = "None",
        TweenSpeed = 350, FPSBoost = false, AntiAFK = true,
    }
}

function UI:Save()
    pcall(function() writefile("CatHUB_v7.json", HttpService:JSONEncode(self.Settings)) end)
end

function UI:Load()
    if isfile and isfile("CatHUB_v7.json") then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile("CatHUB_v7.json")) end)
        if ok then
            for k, v in pairs(data) do
                if self.Settings[k] ~= nil then self.Settings[k] = v end
            end
        end
    end
end
UI:Load()

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatHUB_v7"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 490, 0, 360)
Main.Position = UDim2.new(0.5, -245, 0.5, -180)
Main.BackgroundColor3 = UI.Dark
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(50, 35, 80)

local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 36)
Top.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Text = "CATHUB v7.0"
Title.TextColor3 = UI.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Top)
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -34, 0, 1)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 80, 80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)

local MinBtn = Instance.new("TextButton", Top)
MinBtn.Size = UDim2.new(0, 34, 0, 34)
MinBtn.Position = UDim2.new(1, -68, 0, 1)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(140, 140, 150)
MinBtn.BackgroundTransparency = 1
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.MouseButton1Click:Connect(function()
    UI.Collapsed = not UI.Collapsed
    local side = Main:FindFirstChild("Side")
    local content = Main:FindFirstChild("Content")
    if side then side.Visible = not UI.Collapsed end
    if content then content.Visible = not UI.Collapsed end
    Main:TweenSize(UI.Collapsed and UDim2.new(0, 490, 0, 36) or UDim2.new(0, 490, 0, 360), "Out", "Quad", 0.2, true)
end)

-- Drag
local dragging, dragStart, startPos
Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (i.Position - dragStart).X, startPos.Y.Scale, startPos.Y.Offset + (i.Position - dragStart).Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local Side = Instance.new("Frame", Main)
Side.Name = "Side"
Side.Size = UDim2.new(0, 118, 1, -46)
Side.Position = UDim2.new(0, 5, 0, 41)
Side.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 8)

local TabFrame = Instance.new("ScrollingFrame", Side)
TabFrame.Size = UDim2.new(1, -6, 1, -6)
TabFrame.Position = UDim2.new(0, 3, 0, 3)
TabFrame.BackgroundTransparency = 1
TabFrame.ScrollBarThickness = 0
local TabLayout = Instance.new("UIListLayout", TabFrame)
TabLayout.Padding = UDim.new(0, 3)

local Content = Instance.new("Frame", Main)
Content.Name = "Content"
Content.Size = UDim2.new(1, -133, 1, -46)
Content.Position = UDim2.new(0, 128, 0, 41)
Content.BackgroundColor3 = Color3.fromRGB(13, 13, 19)
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 8)
Content.ClipsDescendants = true

local tabIdx = 0
function UI:CreateTab(name)
    tabIdx = tabIdx + 1
    local Container = Instance.new("ScrollingFrame", Content)
    Container.Size = UDim2.new(1, -12, 1, -12)
    Container.Position = UDim2.new(0, 6, 0, 6)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = UI.Accent
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 4)

    local Btn = Instance.new("TextButton", TabFrame)
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(90, 90, 110)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.LayoutOrder = tabIdx
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

    local entry = {Btn = Btn, Container = Container}
    table.insert(self.TabButtons, entry)

    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabButtons) do
            v.Container.Visible = false
            v.Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            v.Btn.TextColor3 = Color3.fromRGB(90, 90, 110)
        end
        Container.Visible = true
        Btn.BackgroundColor3 = Color3.fromRGB(30, 22, 50)
        Btn.TextColor3 = UI.Accent
    end)
    return Container
end

-- Auto show first tab
task.defer(function()
    if #UI.TabButtons > 0 then
        UI.TabButtons[1].Btn.MouseButton1Click:Fire()
    end
end)

function UI:CreateSection(parent, text)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 26)
    f.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Text = text
    l.TextColor3 = UI.Accent
    l.Font = Enum.Font.GothamBold
    l.TextSize = 10
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    return f
end

function UI:CreateSwitch(parent, key, title, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 32)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -52, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Text = title
    l.TextColor3 = Color3.fromRGB(185, 185, 195)
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    local sw = Instance.new("TextButton", f)
    sw.Size = UDim2.new(0, 38, 0, 18)
    sw.Position = UDim2.new(1, -46, 0.5, -9)
    sw.BackgroundColor3 = self.Settings[key] and UI.Accent or Color3.fromRGB(40, 40, 50)
    sw.Text = ""
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", sw)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = self.Settings[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    sw.MouseButton1Click:Connect(function()
        self.Settings[key] = not self.Settings[key]
        TweenService:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
            Position = self.Settings[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        TweenService:Create(sw, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Settings[key] and UI.Accent or Color3.fromRGB(40, 40, 50)
        }):Play()
        self:Save()
        if cb then cb(self.Settings[key]) end
    end)
end

function UI:CreateSlider(parent, key, title, min, max, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 18)
    t.Position = UDim2.new(0, 10, 0, 3)
    t.Text = title .. ": " .. self.Settings[key]
    t.TextColor3 = Color3.fromRGB(210, 210, 220)
    t.Font = Enum.Font.Gotham
    t.TextSize = 10
    t.TextXAlignment = "Left"
    t.BackgroundTransparency = 1
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1, -20, 0, 5)
    bar.Position = UDim2.new(0, 10, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((self.Settings[key] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = UI.Accent
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function update()
        local r = math.clamp((UserInputService:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * r)
        fill.Size = UDim2.new(r, 0, 1, 0)
        t.Text = title .. ": " .. val
        UI.Settings[key] = val
        UI:Save()
        if cb then cb(val) end
    end
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
end

function UI:CreateDropdown(parent, key, title, options, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 30)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -30, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Text = title .. ": " .. (self.Settings[key] or "None")
    l.TextColor3 = Color3.fromRGB(185, 185, 195)
    l.Font = Enum.Font.Gotham
    l.TextSize = 10
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    local arrow = Instance.new("TextLabel", f)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(130, 130, 140)
    arrow.BackgroundTransparency = 1
    local open = false
    local drop = Instance.new("Frame", parent)
    drop.Size = UDim2.new(1, 0, 0, 0)
    drop.Position = UDim2.new(0, 0, 0, 32)
    drop.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    drop.Visible = false
    drop.ZIndex = 10
    Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 5)
    local dropLayout = Instance.new("UIListLayout", drop)
    dropLayout.Padding = UDim.new(0, 1)
    for _, opt in pairs(options) do
        local btn = Instance.new("TextButton", drop)
        btn.Size = UDim2.new(1, -6, 0, 24)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        btn.Text = opt
        btn.TextColor3 = Color3.fromRGB(170, 170, 180)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 10
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.MouseButton1Click:Connect(function()
            self.Settings[key] = opt
            l.Text = title .. ": " .. opt
            drop.Visible = false
            open = false
            drop.Size = UDim2.new(1, 0, 0, 0)
            self:Save()
            if cb then cb(opt) end
        end)
    end
    f.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            open = not open
            drop.Visible = open
            drop.Size = UDim2.new(1, 0, 0, open and (#options * 25) or 0)
        end
    end)
end

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then
        UI.Visible = not UI.Visible
        Main.Visible = UI.Visible
    end
end)

return UI