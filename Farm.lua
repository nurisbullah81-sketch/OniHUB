-- CatHUB PREMIUM: Fruits Module (v6.3 - RedzHub Style)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local FruitsTab = UI:CreateTab("Fruits", "🍇")

UI:CreateSection(FruitsTab, "FRUIT ESP")
UI:CreateSwitch(FruitsTab, "FruitESP_Enabled", "Fruit Name ESP")
UI:CreateSwitch(FruitsTab, "FruitHighlight_Enabled", "Fruit Highlight Glow")
UI:CreateSwitch(FruitsTab, "FruitNotify_Enabled", "Fruit Spawn Notification")

UI:CreateSection(FruitsTab, "FRUIT GRABBER")
UI:CreateSwitch(FruitsTab, "TweenFruit_Enabled", "Auto Tween to Fruits")
UI:CreateSwitch(FruitsTab, "AutoStore_Enabled", "Auto Store to Treasure")

local FruitData = {}
local FruitCount = 0

-- Fruit Colors
local FruitColors = {
    ["Magma"] = Color3.fromRGB(255, 80, 0),
    ["Light"] = Color3.fromRGB(255, 255, 100),
    ["Dark"] = Color3.fromRGB(100, 0, 150),
    ["Ice"] = Color3.fromRGB(100, 200, 255),
    ["Flame"] = Color3.fromRGB(255, 50, 0),
    ["Rubber"] = Color3.fromRGB(200, 150, 50),
    ["Gravity"] = Color3.fromRGB(150, 50, 200),
    ["Buddha"] = Color3.fromRGB(255, 215, 0),
    ["Sand"] = Color3.fromRGB(210, 180, 100),
    ["Blizzard"] = Color3.fromRGB(150, 220, 255),
    ["Love"] = Color3.fromRGB(255, 100, 150),
    ["Sound"] = Color3.fromRGB(200, 200, 255),
    ["Spring"] = Color3.fromRGB(0, 255, 100),
    ["Chop"] = Color3.fromRGB(100, 200, 100),
    ["Spike"] = Color3.fromRGB(200, 200, 200),
    ["Smoke"] = Color3.fromRGB(150, 150, 150),
    ["Revive"] = Color3.fromRGB(255, 215, 0),
    ["Portal"] = Color3.fromRGB(100, 0, 255),
    ["Diamond"] = Color3.fromRGB(0, 255, 255),
    ["Control"] = Color3.fromRGB(200, 0, 200),
    ["Dragon"] = Color3.fromRGB(255, 50, 50),
    ["Venom"] = Color3.fromRGB(0, 200, 0),
    ["Shadow"] = Color3.fromRGB(50, 0, 80),
    ["Leopard"] = Color3.fromRGB(255, 180, 50),
    ["Spirit"] = Color3.fromRGB(200, 100, 255),
    ["Dough"] = Color3.fromRGB(200, 150, 100),
    ["String"] = Color3.fromRGB(255, 255, 200),
    ["Kitsune"] = Color3.fromRGB(255, 150, 200),
    ["T-Rex"] = Color3.fromRGB(0, 180, 0),
    ["Mammoth"] = Color3.fromRGB(150, 100, 50),
    ["Bisento"] = Color3.fromRGB(180, 180, 180),
    ["Paw"] = Color3.fromRGB(255, 200, 150),
    ["Rumble"] = Color3.fromRGB(255, 255, 0),
    ["Barrier"] = Color3.fromRGB(100, 150, 255),
    ["Phoenix"] = Color3.fromRGB(255, 150, 50),
}

local function GetFruitColor(name)
    for fruit, color in pairs(FruitColors) do
        if name:lower():find(fruit:lower()) then
            return color
        end
    end
    return Color3.fromRGB(255, 255, 255)
end

-- Notification System
local function Notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- Create Fruit ESP
local function CreateFruitESP(fruit)
    if fruit:FindFirstChild("CatFruitESP") then return end
    
    local data = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight", fruit)
    highlight.Name = "CatFruitESP"
    highlight.FillTransparency = 0.85
    highlight.FillColor = GetFruitColor(fruit.Name)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0.3
    highlight.Enabled = false
    data.Highlight = highlight
    
    -- Billboard
    local billboard = Instance.new("BillboardGui", fruit)
    billboard.Name = "CatFruitBillboard"
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Enabled = false
    
    -- Background
    local bg = Instance.new("Frame", billboard)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, -10, 0, 25)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = fruit.Name:gsub("Fruit", ""):gsub("%s+", "")
    nameLabel.TextColor3 = GetFruitColor(fruit.Name)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    data.NameLabel = nameLabel
    
    local distLabel = Instance.new("TextLabel", billboard)
    distLabel.Size = UDim2.new(1, -10, 0, 18)
    distLabel.Position = UDim2.new(0, 5, 0, 32)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m away"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 11
    data.DistLabel = distLabel
    
    data.Billboard = billboard
    data.Notified = false
    FruitData[fruit] = data
    
    -- Notify on spawn
    if UI.Settings.FruitNotify_Enabled and not data.Notified then
        Notify("🍇 FRUIT FOUND!", fruit.Name, 8)
        data.Notified = true
    end
end

-- Scan for Fruits
local function ScanFruits()
    local found = {}
    
    -- Method 1: Workspace direct children
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("fruit") then
            table.insert(found, v)
        elseif v:IsA("Model") and v.Name:lower():find("fruit") then
            table.insert(found, v)
        end
    end
    
    -- Method 2: Deep scan
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and v.Name:lower():find("fruit") then
            local exists = false
            for _, f in pairs(found) do
                if f == v then exists = true break end
            end
            if not exists then table.insert(found, v) end
        end
    end
    
    -- Method 3: Check inside models
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") then
            for _, child in pairs(model:GetChildren()) do
                if child:IsA("Tool") and child.Name:lower():find("fruit") then
                    local exists = false
                    for _, f in pairs(found) do
                        if f == child then exists = true break end
                    end
                    if not exists then table.insert(found, child) end
                end
            end
        end
    end
    
    return found
end

-- Get Nearest Fruit
local function GetNearestFruit()
    local target, dist = nil, math.huge
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    
    for fruit, data in pairs(FruitData) do
        if fruit and fruit.Parent then
            pcall(function()
                local fruitPos = fruit:IsA("Tool") and fruit.Handle.Position or (fruit.PrimaryPart and fruit.PrimaryPart.Position or fruit:GetModelCFrame().Position)
                local d = (fruitPos - hrp.Position).Magnitude
                if d < dist then
                    target, dist = fruit, d
                end
            end)
        end
    end
    return target, dist
end

-- Store Fruit
local function StoreFruit(fruitName)
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruitName)
    end)
end

-- Main Scanner Loop
task.spawn(function()
    while task.wait(0.5) do
        local fruits = ScanFruits()
        for _, fruit in pairs(fruits) do
            CreateFruitESP(fruit)
        end
        
        -- Cleanup
        for fruit, data in pairs(FruitData) do
            if not fruit or not fruit.Parent then
                pcall(function()
                    data.Highlight:Destroy()
                    data.Billboard:Destroy()
                end)
                FruitData[fruit] = nil
            end
        end
        
        FruitCount = 0
        for _ in pairs(FruitData) do FruitCount = FruitCount + 1 end
    end
end)

-- ESP Update Loop
task.spawn(function()
    while task.wait(0.15) do
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        for fruit, data in pairs(FruitData) do
            local showESP = UI.Settings.FruitESP_Enabled
            local showHL = UI.Settings.FruitHighlight_Enabled
            
            data.Highlight.Enabled = showHL
            data.Billboard.Enabled = showESP
            
            if (showESP or showHL) and hrp then
                pcall(function()
                    local fruitPos = fruit:IsA("Tool") and fruit.Handle.Position or (fruit.PrimaryPart and fruit.PrimaryPart.Position or fruit:GetModelCFrame().Position)
                    local dist = math.floor((fruitPos - hrp.Position).Magnitude)
                    data.DistLabel.Text = "[" .. dist .. "m away]"
                    
                    -- Distance based color
                    if dist < 200 then
                        data.Highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                        data.DistLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif dist < 1000 then
                        data.Highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        data.DistLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        data.Highlight.OutlineColor = Color3.fromRGB(255, 100, 0)
                        data.DistLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
                    end
                end)
            end
        end
    end
end)

-- Tween to Fruit Loop
task.spawn(function()
    while task.wait(0.3) do
        if UI.Settings.TweenFruit_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local fruit, dist = GetNearestFruit()
            if fruit and dist and dist < 10000 then
                pcall(function()
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local fruitPos = fruit:IsA("Tool") and fruit.Handle.CFrame or (fruit.PrimaryPart and fruit.PrimaryPart.CFrame or fruit:GetModelCFrame())
                    local targetCFrame = fruitPos * CFrame.new(0, -2, 0)
                    local distance = (targetCFrame.Position - hrp.Position).Magnitude
                    local speed = math.clamp(UI.Settings.Tween_Speed or 350, 150, 1000)
                    
                    if distance > 8 then
                        local tween = TweenService:Create(hrp, TweenInfo.new(distance/speed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                        tween:Play()
                    end
                end)
            end
        end
    end
end)

-- Auto Store Loop
task.spawn(function()
    while task.wait(1.5) do
        if UI.Settings.AutoStore_Enabled and LocalPlayer.Character then
            pcall(function()
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find("fruit") then
                        StoreFruit(tool.Name)
                        Notify("📦 FRUIT STORED", tool.Name, 3)
                        task.wait(0.3)
                    end
                end
                local held = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if held and held.Name:lower():find("fruit") then
                    StoreFruit(held.Name)
                    Notify("📦 FRUIT STORED", held.Name, 3)
                end
            end)
        end
    end
end)

-- Status Label
local StatusLabel = UI:CreateSection(FruitsTab, "STATUS: Scanning...")

task.spawn(function()
    while task.wait(1) do
        local count = 0
        for _ in pairs(FruitData) do count = count + 1 end
        StatusLabel:FindFirstChildWhichIsA("TextLabel").Text = "▸ FRUITS DETECTED: " .. count
    end
end)

print("[CatHUB]: Fruits Module Loaded (RedzHub Style)")