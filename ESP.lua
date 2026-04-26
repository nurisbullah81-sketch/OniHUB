-- CatHUB v8.0: ESP Module (ALL-IN-ONE)
-- Fruits, Players, Bosses, Chests

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = _G.CatHub.Player

-- Hapus GUI lama kalo ada
if CoreGui:FindFirstChild("CatHUB_ESP") then
    CoreGui.CatHUB_ESP:Destroy()
end

-- ============================================================
-- SETTINGS
-- ============================================================
local Settings = {
    -- Fruits
    FruitESP = false,
    FruitHighlight = false,
    FruitDistance = true,
    
    -- Players
    PlayerESP = false,
    PlayerHighlight = false,
    PlayerDistance = true,
    PlayerHealth = true,
    
    -- Bosses
    BossESP = false,
    BossHighlight = false,
    
    -- Chests
    ChestESP = false,
    ChestHighlight = false,
}

-- Load/Save config
local function SaveConfig()
    pcall(function()
        writefile("CatHUB_ESP.json", HttpService:JSONEncode(Settings))
    end)
end

local function LoadConfig()
    pcall(function()
        if isfile("CatHUB_ESP.json") then
            local data = HttpService:JSONDecode(readfile("CatHUB_ESP.json"))
            for k, v in pairs(data) do
                if Settings[k] ~= nil then
                    Settings[k] = v
                end
            end
        end
    end)
end
LoadConfig()

-- Simpan ke global biar module lain bisa akses
_G.CatHub.Settings = Settings

-- ============================================================
-- GUI CREATION
-- ============================================================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CatHUB_ESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 400)
Main.Position = UDim2.new(0, 20, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(60, 40, 100)
Stroke.Thickness = 1

-- Top Bar
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "CATHUB ESP"
Title.TextColor3 = Color3.fromRGB(180, 130, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -32, 0, 1)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Button
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -62, 0, 1)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
MinBtn.BackgroundTransparency = 1
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14

local isMinimized = false
local ContentFrame = Instance.new("ScrollingFrame", Main)
ContentFrame.Size = UDim2.new(1, -16, 1, -40)
ContentFrame.Position = UDim2.new(0, 8, 0, 36)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 3
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 70, 160)
ContentFrame.BorderSizePixel = 0
Instance.new("UIListLayout", ContentFrame).Padding = UDim.new(0, 4)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentFrame.Visible = not isMinimized
    Main:TweenSize(
        isMinimized and UDim2.new(0, 280, 0, 32) or UDim2.new(0, 280, 0, 400),
        "Out", "Quad", 0.2, true
    )
end)

-- Drag Logic
local dragging = false
local dragInput
local dragStart
local startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================================
-- UI HELPER FUNCTIONS
-- ============================================================

-- Section Header
local function CreateSection(text)
    local frame = Instance.new("Frame", ContentFrame)
    frame.Size = UDim2.new(1, 0, 0, 26)
    frame.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = "▸ " .. text
    label.TextColor3 = Color3.fromRGB(160, 120, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextXAlignment = "Left"
    label.BackgroundTransparency = 1
    
    return frame
end

-- Switch Toggle
local function CreateSwitch(key, title)
    local frame = Instance.new("Frame", ContentFrame)
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = title
    label.TextColor3 = Color3.fromRGB(190, 190, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = "Left"
    label.BackgroundTransparency = 1
    
    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 38, 0, 18)
    switch.Position = UDim2.new(1, -46, 0.5, -9)
    switch.BackgroundColor3 = Settings[key] and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(45, 45, 55)
    switch.Text = ""
    switch.BorderSizePixel = 0
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", switch)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = Settings[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    switch.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        TweenService:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
            Position = Settings[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        TweenService:Create(switch, TweenInfo.new(0.15), {
            BackgroundColor3 = Settings[key] and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(45, 45, 55)
        }):Play()
        SaveConfig()
    end)
end

-- Status Label (bisa diupdate)
local function CreateStatus(text)
    local frame = Instance.new("Frame", ContentFrame)
    frame.Size = UDim2.new(1, 0, 0, 22)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(120, 120, 140)
    label.Font = Enum.Font.Gotham
    label.TextSize = 9
    label.TextXAlignment = "Left"
    label.BackgroundTransparency = 1
    
    return label
end

-- ============================================================
-- CREATE UI ELEMENTS
-- ============================================================

CreateSection("FRUITS ESP")
CreateSwitch("FruitESP", "Fruit Name + Distance")
CreateSwitch("FruitHighlight", "Fruit Glow")
local FruitStatus = CreateStatus("Fruits: 0")

CreateSection("PLAYERS ESP")
CreateSwitch("PlayerESP", "Player Name + Info")
CreateSwitch("PlayerHighlight", "Player Glow")
local PlayerStatus = CreateStatus("Players: 0")

CreateSection("BOSSES ESP")
CreateSwitch("BossESP", "Boss Name + HP")
CreateSwitch("BossHighlight", "Boss Glow")
local BossStatus = CreateStatus("Bosses: 0")

CreateSection("CHESTS ESP")
CreateSwitch("ChestESP", "Chest Name")
CreateSwitch("ChestHighlight", "Chest Glow")
local ChestStatus = CreateStatus("Chests: 0")

-- Hotkey info
local HotkeyLabel = CreateStatus("Hotkey: RightCtrl to toggle")

-- ============================================================
-- ESP DATA STORAGE
-- ============================================================
local FruitESP = {}  -- [fruit] = {highlight, billboard}
local PlayerESP = {} -- [player] = {highlight, billboard}
local BossESP = {}   -- [boss] = {highlight, billboard}
local ChestESP = {}  -- [chest] = {highlight, billboard}

-- ============================================================
-- HELPER: Get My Position
-- ============================================================
local function GetMyPosition()
    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    return root.Position
end

-- ============================================================
-- FRUIT ESP
-- ============================================================

local function GetFruitPosition(fruit)
    -- Handle = untuk Tool
    local handle = fruit:FindFirstChild("Handle")
    if handle then
        return handle.Position
    end
    -- PrimaryPart = untuk Model
    if fruit:IsA("Model") and fruit.PrimaryPart then
        return fruit.PrimaryPart.Position
    end
    -- Fallback: cari BasePart apapun
    for _, child in pairs(fruit:GetChildren()) do
        if child:IsA("BasePart") then
            return child.Position
        end
    end
    return nil
end

local function CreateFruitESP(fruit)
    if FruitESP[fruit] then return end
    
    local highlight = Instance.new("Highlight", fruit)
    highlight.Name = "CatESP"
    highlight.FillTransparency = 0.85
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0.3
    highlight.Enabled = false
    
    local billboard = Instance.new("BillboardGui", fruit)
    billboard.Name = "CatBB"
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Enabled = false
    
    -- Background
    local bg = Instance.new("Frame", billboard)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
    
    local nameText = Instance.new("TextLabel", billboard)
    nameText.Size = UDim2.new(1, -10, 0, 20)
    nameText.Position = UDim2.new(0, 5, 0, 2)
    nameText.BackgroundTransparency = 1
    nameText.Text = fruit.Name -- NAMA ASLI DARI GAME
    nameText.TextColor3 = Color3.fromRGB(255, 215, 0)
    nameText.TextStrokeTransparency = 0
    nameText.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameText.Font = Enum.Font.GothamBold
    nameText.TextSize = 12
    
    local distText = Instance.new("TextLabel", billboard)
    distText.Size = UDim2.new(1, -10, 0, 16)
    distText.Position = UDim2.new(0, 5, 0, 22)
    distText.BackgroundTransparency = 1
    distText.Text = ""
    distText.TextColor3 = Color3.fromRGB(200, 200, 200)
    distText.TextStrokeTransparency = 0.5
    distText.TextStrokeColor3 = Color3.new(0, 0, 0)
    distText.Font = Enum.Font.Gotham
    distText.TextSize = 10
    
    FruitESP[fruit] = {
        highlight = highlight,
        billboard = billboard,
        nameText = nameText,
        distText = distText
    }
end

-- ============================================================
-- PLAYER ESP
-- ============================================================

local function CreatePlayerESP(player)
    if PlayerESP[player] then return end
    if not player.Character then return end
    
    local char = player.Character
    
    local highlight = Instance.new("Highlight", char)
    highlight.Name = "CatESP"
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 0.5
    highlight.Enabled = false
    
    local billboard = Instance.new("BillboardGui", char)
    billboard.Name = "CatBB"
    billboard.Size = UDim2.new(0, 180, 0, 45)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Enabled = false
    
    local bg = Instance.new("Frame", billboard)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
    
    local nameText = Instance.new("TextLabel", billboard)
    nameText.Size = UDim2.new(1, -8, 0, 18)
    nameText.Position = UDim2.new(0, 4, 0, 2)
    nameText.BackgroundTransparency = 1
    nameText.Text = player.DisplayName
    nameText.TextColor3 = Color3.new(1, 1, 1)
    nameText.TextStrokeTransparency = 0
    nameText.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameText.Font = Enum.Font.GothamBold
    nameText.TextSize = 12
    
    local infoText = Instance.new("TextLabel", billboard)
    infoText.Size = UDim2.new(1, -8, 0, 22)
    infoText.Position = UDim2.new(0, 4, 0, 20)
    infoText.BackgroundTransparency = 1
    infoText.Text = ""
    infoText.TextColor3 = Color3.fromRGB(180, 180, 180)
    infoText.TextStrokeTransparency = 0.4
    infoText.TextStrokeColor3 = Color3.new(0, 0, 0)
    infoText.Font = Enum.Font.Gotham
    infoText.TextSize = 9
    
    PlayerESP[player] = {
        highlight = highlight,
        billboard = billboard,
        nameText = nameText,
        infoText = infoText
    }
end

-- ============================================================
-- BOSS ESP
-- ============================================================

-- Cek apakah itu boss (biasanya ada di Workspace, bukan di Workspace.Enemies biasa)
-- Boss biasanya punya nama spesifik atau HP tinggi
local function IsBoss(model)
    if not model:IsA("Model") then return false end
    local humanoid = model:FindFirstChild("Humanoid")
    if not humanoid then return false end
    if humanoid.Health <= 0 then return false end
    
    -- Cek nama: biasanya boss punya kata "Boss" atau nama kapital semua
    local name = model.Name:lower()
    if name:find("boss") then return true end
    
    -- Cek HP: boss biasanya HP > 10000
    if humanoid.MaxHealth > 10000 then return true end
    
    -- Cek apakah ini raid boss atau sea beast
    if name:find("sea") or name:find("beast") or name:find("raid") then return true end
    
    return false
end

local function CreateBossESP(boss)
    if BossESP[boss] then return end
    
    local highlight = Instance.new("Highlight", boss)
    highlight.Name = "CatESP"
    highlight.FillTransparency = 0.8
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0.2
    highlight.Enabled = false
    
    local billboard = Instance.new("BillboardGui", boss)
    billboard.Name = "CatBB"
    billboard.Size = UDim2.new(0, 220, 0, 45)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.Enabled = false
    
    local bg = Instance.new("Frame", billboard)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    bg.BackgroundTransparency = 0.4
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
    
    local nameText = Instance.new("TextLabel", billboard)
    nameText.Size = UDim2.new(1, -10, 0, 22)
    nameText.Position = UDim2.new(0, 5, 0, 2)
    nameText.BackgroundTransparency = 1
    nameText.Text = "👑 " .. boss.Name
    nameText.TextColor3 = Color3.fromRGB(255, 80, 80)
    nameText.TextStrokeTransparency = 0
    nameText.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameText.Font = Enum.Font.GothamBold
    nameText.TextSize = 13
    
    local hpText = Instance.new("TextLabel", billboard)
    hpText.Size = UDim2.new(1, -10, 0, 18)
    hpText.Position = UDim2.new(0, 5, 0, 24)
    hpText.BackgroundTransparency = 1
    hpText.Text = ""
    hpText.TextColor3 = Color3.fromRGB(255, 150, 150)
    hpText.TextStrokeTransparency = 0.4
    hpText.TextStrokeColor3 = Color3.new(0, 0, 0)
    hpText.Font = Enum.Font.Gotham
    hpText.TextSize = 10
    
    BossESP[boss] = {
        highlight = highlight,
        billboard = billboard,
        nameText = nameText,
        hpText = hpText
    }
end

-- ============================================================
-- CHEST ESP
-- ============================================================

local function CreateChestESP(chest)
    if ChestESP[chest] then return end
    
    local highlight = Instance.new("Highlight", chest)
    highlight.Name = "CatESP"
    highlight.FillTransparency = 0.8
    highlight.FillColor = Color3.fromRGB(255, 200, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
    highlight.OutlineTransparency = 0.3
    highlight.Enabled = false
    
    local billboard = Instance.new("BillboardGui", chest)
    billboard.Name = "CatBB"
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Enabled = false
    
    local nameText = Instance.new("TextLabel", billboard)
    nameText.Size = UDim2.new(1, 0, 1, 0)
    nameText.BackgroundTransparency = 1
    nameText.Text = chest.Name -- NAMA ASLI DARI GAME
    nameText.TextColor3 = Color3.fromRGB(255, 215, 0)
    nameText.TextStrokeTransparency = 0
    nameText.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameText.Font = Enum.Font.GothamBold
    nameText.TextSize = 11
    
    ChestESP[chest] = {
        highlight = highlight,
        billboard = billboard,
        nameText = nameText
    }
end

-- ============================================================
-- CLEANUP FUNCTION
-- ============================================================
local function CleanESP(table)
    for obj, data in pairs(table) do
        if not obj or not obj.Parent then
            pcall(function()
                data.highlight:Destroy()
                data.billboard:Destroy()
            end)
            table[obj] = nil
        end
    end
end

-- ============================================================
-- SCAN LOOPS
-- ============================================================

-- Scan Fruits (tiap 1 detik)
task.spawn(function()
    while task.wait(1) do
        CleanESP(FruitESP)
        
        -- Scan Workspace langsung
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Tool") and obj.Name:lower():find("fruit") then
                CreateFruitESP(obj)
            elseif obj:IsA("Model") and obj.Name:lower():find("fruit") then
                CreateFruitESP(obj)
            end
        end
        
        -- Deep scan (backup)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name:lower():find("fruit") then
                if not FruitESP[obj] then
                    CreateFruitESP(obj)
                end
            end
        end
    end
end)

-- Scan Players
task.spawn(function()
    -- Initial
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreatePlayerESP(player)
        end
    end
    
    -- New players
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            task.wait(2)
            CreatePlayerESP(player)
        end
    end)
    
    -- Character respawn
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function()
                task.wait(2)
                CreatePlayerESP(player)
            end)
        end
    end)
end)

-- Scan Bosses (tiap 2 detik)
task.spawn(function()
    while task.wait(2) do
        CleanESP(BossESP)
        
        -- Scan Workspace (bukan Enemies folder)
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and IsBoss(obj) then
                CreateBossESP(obj)
            end
        end
        
        -- Juga cek Enemies folder untuk boss
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, obj in pairs(enemies:GetChildren()) do
                if obj:IsA("Model") and IsBoss(obj) then
                    CreateBossESP(obj)
                end
            end
        end
    end
end)

-- Scan Chests (tiap 2 detik)
task.spawn(function()
    while task.wait(2) do
        CleanESP(ChestESP)
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local name = obj.Name:lower()
                if name:find("chest") then
                    CreateChestESP(obj)
                end
            end
        end
    end
end)

-- ============================================================
-- UPDATE LOOP (Single loop untuk update semua ESP)
-- ============================================================
task.spawn(function()
    while task.wait(0.3) do
        local myPos = GetMyPosition()
        if not myPos then continue end
        
        local fruitCount = 0
        local playerCount = 0
        local bossCount = 0
        local chestCount = 0
        
        -- Update Fruit ESP
        for fruit, data in pairs(FruitESP) do
            fruitCount = fruitCount + 1
            data.highlight.Enabled = Settings.FruitHighlight
            data.billboard.Enabled = Settings.FruitESP
            
            if Settings.FruitESP then
                local pos = GetFruitPosition(fruit)
                if pos then
                    local dist = math.floor((pos - myPos).Magnitude)
                    data.distText.Text = "[" .. dist .. "m]"
                    
                    -- Warna berdasarkan jarak
                    if dist < 300 then
                        data.highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                        data.distText.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif dist < 1000 then
                        data.highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        data.distText.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        data.highlight.OutlineColor = Color3.fromRGB(255, 100, 0)
                        data.distText.TextColor3 = Color3.fromRGB(255, 100, 0)
                    end
                end
            end
        end
        
        -- Update Player ESP
        for player, data in pairs(PlayerESP) do
            playerCount = playerCount + 1
            data.highlight.Enabled = Settings.PlayerHighlight
            data.billboard.Enabled = Settings.PlayerESP
            
            if Settings.PlayerESP then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local root = char.HumanoidRootPart
                    local hum = char.Humanoid
                    local dist = math.floor((root.Position - myPos).Magnitude)
                    local hp = math.floor(hum.Health)
                    local maxHp = math.floor(hum.MaxHealth)
                    
                    -- Team check
                    local isEnemy = true
                    pcall(function()
                        if player.Team and LocalPlayer.Team then
                            isEnemy = player.Team ~= LocalPlayer.Team
                        end
                    end)
                    
                    local color = isEnemy and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(70, 150, 255)
                    data.highlight.OutlineColor = color
                    data.nameText.TextColor3 = color
                    data.nameText.Text = player.DisplayName
                    data.infoText.Text = "[" .. dist .. "m] HP: " .. hp .. "/" .. maxHp
                end
            end
        end
        
        -- Update Boss ESP
        for boss, data in pairs(BossESP) do
            bossCount = bossCount + 1
            data.highlight.Enabled = Settings.BossHighlight
            data.billboard.Enabled = Settings.BossESP
            
            if Settings.BossESP then
                local root = boss:FindFirstChild("HumanoidRootPart")
                local hum = boss:FindFirstChild("Humanoid")
                if root and hum then
                    local dist = math.floor((root.Position - myPos).Magnitude)
                    local hp = math.floor(hum.Health)
                    local maxHp = math.floor(hum.MaxHealth)
                    data.hpText.Text = "[" .. dist .. "m] " .. hp .. "/" .. maxHp
                end
            end
        end
        
        -- Update Chest ESP
        for chest, data in pairs(ChestESP) do
            chestCount = chestCount + 1
            data.highlight.Enabled = Settings.ChestHighlight
            data.billboard.Enabled = Settings.ChestESP
        end
        
        -- Update status labels
        FruitStatus.Text = "Fruits: " .. fruitCount
        PlayerStatus.Text = "Players: " .. playerCount
        BossStatus.Text = "Bosses: " .. bossCount
        ChestStatus.Text = "Chests: " .. chestCount
    end
end)

-- ============================================================
-- HOTKEY: Toggle GUI
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("[CatHUB] ESP Module Loaded")