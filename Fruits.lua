-- CatHUB FREEMIUM: Fruits Module (v6.2 - FOCUS)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local FruitsTab = UI:CreateTab("Fruits")

UI:CreateLabel(FruitsTab, "━━ FRUIT FINDER ━━")
UI:CreateSwitch(FruitsTab, "FruitESP_Enabled", "Enable Fruit ESP")
UI:CreateSwitch(FruitsTab, "TweenFruit_Enabled", "Linear Tween to Fruits")
UI:CreateSwitch(FruitsTab, "AutoStore_Enabled", "Auto Store to Treasure")

local DetectedFruits = {}
local CurrentTarget = nil
local FruitEspList = {}

-- Fruit Name Formatting
local function FormatFruitName(name)
    local clean = name:gsub("Fruit", ""):gsub("%s+", "")
    if clean == "" then clean = "Unknown" end
    return clean
end

-- Get Fruit Color by Type
local function GetFruitColor(name)
    local n = name:lower()
    if n:find("magma") then return Color3.fromRGB(255, 80, 0)
    elseif n:find("light") or n:find("light") then return Color3.fromRGB(255, 255, 100)
    elseif n:find("dark") then return Color3.fromRGB(100, 0, 150)
    elseif n:find("ice") then return Color3.fromRGB(100, 200, 255)
    elseif n:find("flame") or n:find("fire") then return Color3.fromRGB(255, 50, 0)
    elseif n:find("rubber") then return Color3.fromRGB(200, 150, 50)
    elseif n:find("gravity") then return Color3.fromRGB(150, 50, 200)
    elseif n:find("bounce") then return Color3.fromRGB(255, 200, 0)
    elseif n:find("sand") then return Color3.fromRGB(210, 180, 100)
    elseif n:find("blizzard") then return Color3.fromRGB(150, 220, 255)
    elseif n:find("love") then return Color3.fromRGB(255, 100, 150)
    elseif n:find("sound") then return Color3.fromRGB(255, 255, 255)
    elseif n:find("spring") then return Color3.fromRGB(0, 255, 100)
    elseif n:find("chop") then return Color3.fromRGB(100, 200, 100)
    elseif n:find("spike") then return Color3.fromRGB(200, 200, 200)
    elseif n:find("smoke") then return Color3.fromRGB(150, 150, 150)
    elseif n:find("revive") then return Color3.fromRGB(255, 215, 0)
    elseif n:find("portal") then return Color3.fromRGB(100, 0, 255)
    elseif n:find("diamond") then return Color3.fromRGB(0, 255, 255)
    elseif n:find("control") then return Color3.fromRGB(200, 0, 200)
    elseif n:find("dragon") then return Color3.fromRGB(255, 50, 50)
    elseif n:find("venom") then return Color3.fromRGB(0, 200, 0)
    elseif n:find("shadow") then return Color3.fromRGB(50, 0, 80)
    elseif n:find("leopard") then return Color3.fromRGB(255, 180, 50)
    elseif n:find("spirit") then return Color3.fromRGB(200, 100, 255)
    elseif n:find("dough") then return Color3.fromRGB(200, 150, 100)
    elseif n:find("string") then return Color3.fromRGB(255, 255, 200)
    elseif n:find("kitsune") then return Color3.fromRGB(255, 150, 200)
    else return Color3.fromRGB(255, 255, 255)
    end
end

-- Create ESP for Fruit
local function CreateFruitESP(fruit)
    if fruit:FindFirstChild("CatFruitESP") then return end
    
    local highlight = Instance.new("Highlight", fruit)
    highlight.Name = "CatFruitESP"
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0
    highlight.Enabled = false
    
    local billboard = Instance.new("BillboardGui", fruit)
    billboard.Name = "CatFruitBillboard"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Enabled = false
    
    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = FormatFruitName(fruit.Name)
    nameLabel.TextColor3 = GetFruitColor(fruit.Name)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    
    local distLabel = Instance.new("TextLabel", billboard)
    distLabel.Size = UDim2.new(1, 0, 0, 16)
    distLabel.Position = UDim2.new(0, 0, 0, 20)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0.3
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Font = Enum.Font.SourceSans
    distLabel.TextSize = 12
    
    table.insert(FruitEspList, {
        Fruit = fruit,
        Highlight = highlight,
        Billboard = billboard,
        NameLabel = nameLabel,
        DistLabel = distLabel
    })
end

-- Remove ESP
local function RemoveFruitESP(fruit)
    for i, data in pairs(FruitEspList) do
        if data.Fruit == fruit then
            pcall(function()
                data.Highlight:Destroy()
                data.Billboard:Destroy()
            end)
            table.remove(FruitEspList, i)
            break
        end
    end
end

-- Find All Fruits in Workspace
local function ScanForFruits()
    local fruits = {}
    
    -- Method 1: Direct Workspace scan
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("fruit") then
            table.insert(fruits, v)
        elseif v:IsA("Model") then
            if v.Name:lower():find("fruit") then
                table.insert(fruits, v)
            end
            -- Check inside models
            for _, child in pairs(v:GetChildren()) do
                if child:IsA("Tool") and child.Name:lower():find("fruit") then
                    table.insert(fruits, child)
                end
            end
        end
    end
    
    -- Method 2: Workspace.Descendants
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and v.Name:lower():find("fruit") then
            local found = false
            for _, existing in pairs(fruits) do
                if existing == v then found = true break end
            end
            if not found then table.insert(fruits, v) end
        end
    end
    
    return fruits
end

-- Get Nearest Fruit
local function GetNearestFruit()
    local target, dist = nil, math.huge
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    
    for _, data in pairs(FruitEspList) do
        if data.Fruit and data.Fruit.Parent then
            pcall(function()
                local fruitPos = data.Fruit:IsA("Tool") and data.Fruit.Handle.Position or data.Fruit:GetModelCFrame().Position
                local d = (fruitPos - hrp.Position).Magnitude
                if d < dist then
                    target, dist = data.Fruit, d
                end
            end)
        end
    end
    
    return target, dist
end

-- Auto Store Fruits
local function StoreFruit(fruitName)
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruitName)
    end)
end

-- Main Fruit Scanner Loop
task.spawn(function()
    while task.wait(1) do
        -- Scan and create ESP
        local foundFruits = ScanForFruits()
        for _, fruit in pairs(foundFruits) do
            CreateFruitESP(fruit)
        end
        
        -- Clean up invalid fruits
        for i = #FruitEspList, 1, -1 do
            local data = FruitEspList[i]
            if not data.Fruit or not data.Fruit.Parent then
                RemoveFruitESP(data.Fruit)
            end
        end
    end
end)

-- ESP Update Loop
task.spawn(function()
    while task.wait(0.2) do
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        for _, data in pairs(FruitEspList) do
            local shouldShow = UI.Settings.FruitESP_Enabled
            data.Highlight.Enabled = shouldShow
            data.Billboard.Enabled = shouldShow
            
            if shouldShow and hrp then
                pcall(function()
                    local fruitPos = data.Fruit:IsA("Tool") and data.Fruit.Handle.Position or data.Fruit:GetModelCFrame().Position
                    local dist = math.floor((fruitPos - hrp.Position).Magnitude)
                    data.DistLabel.Text = "[" .. dist .. "m]"
                    
                    -- Color based on distance
                    if dist < 100 then
                        data.Highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                    elseif dist < 500 then
                        data.Highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                    else
                        data.Highlight.OutlineColor = Color3.fromRGB(255, 100, 0)
                    end
                end)
            end
        end
    end
end)

-- Tween to Fruit Loop
task.spawn(function()
    while task.wait(0.5) do
        if UI.Settings.TweenFruit_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local fruit, dist = GetNearestFruit()
            if fruit and dist and dist < 5000 then
                pcall(function()
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local fruitPos = fruit:IsA("Tool") and fruit.Handle.CFrame or fruit:GetModelCFrame()
                    local targetCFrame = fruitPos * CFrame.new(0, 0, 3)
                    local distance = (targetCFrame.Position - hrp.Position).Magnitude
                    local speed = math.clamp(UI.Settings.Tween_Speed or 300, 150, 800)
                    
                    if distance > 5 then
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
    while task.wait(2) do
        if UI.Settings.AutoStore_Enabled and LocalPlayer.Character then
            pcall(function()
                -- Check Backpack
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find("fruit") then
                        StoreFruit(tool.Name)
                        task.wait(0.5)
                    end
                end
                -- Check if holding
                local held = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if held and held.Name:lower():find("fruit") then
                    StoreFruit(held.Name)
                    task.wait(0.5)
                end
            end)
        end
    end
end)

-- Fruit Count Display
local CountLabel = UI:CreateLabel(FruitsTab, "Detected Fruits: 0")

task.spawn(function()
    while task.wait(1) do
        local count = 0
        for _, data in pairs(FruitEspList) do
            if data.Fruit and data.Fruit.Parent then count = count + 1 end
        end
        CountLabel.Text = "Detected Fruits: " .. count
    end
end)

print("[CatHUB]: Fruits Module Loaded.")