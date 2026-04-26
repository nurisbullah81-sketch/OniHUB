-- CatHUB v7.0: Fruits (Optimized, Accurate Names)
local UI = _G.CatHUB_UI
local Cache = _G.CatCache
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Tab = UI:CreateTab("🍇 Fruits")

UI:CreateSection(Tab, "FRUIT DETECTION")
UI:CreateSwitch(Tab, "FruitESP", "Fruit ESP")
UI:CreateSwitch(Tab, "FruitHL", "Fruit Highlight")
UI:CreateSwitch(Tab, "FruitNotify", "Spawn Notification")

UI:CreateSection(Tab, "FRUIT COLLECT")
UI:CreateSwitch(Tab, "TweenFruit", "Auto Tween to Fruit")
UI:CreateSwitch(Tab, "AutoStore", "Auto Store to Treasure")

local fruitData = {} -- [fruit] = {highlight, billboard, nameTxt, distTxt}
local scanCooldown = 0
local fruitTween = nil

-- Notify without using StarterGui (more reliable)
local function Notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title, Text = text, Duration = 6
        })
    end)
end

-- Get fruit position safely
local function GetFruitPos(fruit)
    if fruit:IsA("Tool") then
        local handle = fruit:FindFirstChild("Handle")
        if handle then return handle.Position end
    end
    if fruit:IsA("Model") then
        local primary = fruit.PrimaryPart
        if primary then return primary.Position end
        local p = fruit:FindFirstChildWhichIsA("BasePart")
        if p then return p.Position end
    end
    -- Fallback
    local p = fruit:FindFirstChildWhichIsA("BasePart")
    if p then return p.Position end
    return nil
end

-- Create ESP for one fruit
local function AddESP(fruit)
    if fruitData[fruit] then return end
    if fruit:FindFirstChild("CatESP") then return end

    -- Get actual name from game (no manual naming)
    local realName = fruit.Name

    local hl = Instance.new("Highlight", fruit)
    hl.Name = "CatESP"
    hl.FillTransparency = 0.85
    hl.FillColor = Color3.fromRGB(255, 215, 0)
    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
    hl.OutlineTransparency = 0.2
    hl.Enabled = false

    local bb = Instance.new("BillboardGui", fruit)
    bb.Name = "CatBB"
    bb.Size = UDim2.new(0, 220, 0, 45)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.Enabled = false

    -- Background
    local bg = Instance.new("Frame", bb)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)

    local nameTxt = Instance.new("TextLabel", bb)
    nameTxt.Size = UDim2.new(1, -8, 0, 22)
    nameTxt.Position = UDim2.new(0, 4, 0, 3)
    nameTxt.BackgroundTransparency = 1
    nameTxt.Text = realName -- ACTUAL GAME NAME
    nameTxt.TextColor3 = Color3.fromRGB(255, 215, 0)
    nameTxt.TextStrokeTransparency = 0
    nameTxt.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameTxt.Font = Enum.Font.GothamBold
    nameTxt.TextSize = 12

    local distTxt = Instance.new("TextLabel", bb)
    distTxt.Size = UDim2.new(1, -8, 0, 16)
    distTxt.Position = UDim2.new(0, 4, 0, 24)
    distTxt.BackgroundTransparency = 1
    distTxt.Text = ""
    distTxt.TextColor3 = Color3.fromRGB(200, 200, 200)
    distTxt.TextStrokeTransparency = 0.5
    distTxt.TextStrokeColor3 = Color3.new(0, 0, 0)
    distTxt.Font = Enum.Font.Gotham
    distTxt.TextSize = 10

    fruitData[fruit] = {
        highlight = hl,
        billboard = bb,
        nameTxt = nameTxt,
        distTxt = distTxt,
        notified = false
    }

    -- Immediate notification
    if UI.Settings.FruitNotify then
        Notify("🍇 Fruit Found!", realName)
        fruitData[fruit].notified = true
    end
end

-- Clean dead fruits
local function CleanDead()
    for fruit, data in pairs(fruitData) do
        if not fruit or not fruit.Parent then
            pcall(function()
                data.highlight:Destroy()
                data.billboard:Destroy()
            end)
            fruitData[fruit] = nil
        end
    end
end

-- Scan (runs ONCE per second, not in a tight loop)
local function ScanOnce()
    CleanDead()
    local found = {}

    -- Check Workspace children
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("fruit") then
            found[v] = true
            AddESP(v)
        elseif v:IsA("Model") and v.Name:lower():find("fruit") then
            found[v] = true
            AddESP(v)
        end
    end

    -- Deep scan (only if surface scan found nothing)
    if next(found) == nil then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Tool") and v.Name:lower():find("fruit") then
                if not found[v] then
                    found[v] = true
                    AddESP(v)
                end
            end
        end
    end
end

-- Get nearest fruit
local function GetNearest()
    local best, bestDist = nil, math.huge
    if not Cache.IsValid then return nil, nil end
    for fruit, _ in pairs(fruitData) do
        if fruit and fruit.Parent then
            local pos = GetFruitPos(fruit)
            if pos then
                local d = (pos - Cache.Position).Magnitude
                if d < bestDist then
                    best, bestDist = fruit, d
                end
            end
        end
    end
    return best, bestDist
end

-- Smooth tween to fruit (CANCEL old tween first!)
local function TweenToFruit(fruit)
    if fruitTween then
        fruitTween:Cancel()
        fruitTween = nil
    end

    local pos = GetFruitPos(fruit)
    if not pos or not Cache.IsValid then return end

    local targetCFrame = CFrame.new(pos)
    local dist = (targetCFrame.Position - Cache.Position).Magnitude

    if dist > 6 then
        local speed = math.clamp(UI.Settings.TweenSpeed or 350, 200, 800)
        fruitTween = TweenService:Create(
            Cache.HumanoidRootPart,
            TweenInfo.new(dist / speed, Enum.EasingStyle.Linear),
            { CFrame = targetCFrame * CFrame.new(0, -2, 0) }
        )
        fruitTween:Play()
    end
end

-- Store fruit
local function StoreFruit(name)
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", name)
    end)
end

-- === MAIN LOOPS (Minimal, not 10 parallel loops) ===

-- Single scan loop (1 second interval)
task.spawn(function()
    while task.wait(1) do
        ScanOnce()
    end
end)

-- Single update loop (0.25s - not every frame!)
task.spawn(function()
    while task.wait(0.25) do
        local showESP = UI.Settings.FruitESP
        local showHL = UI.Settings.FruitHL

        for fruit, data in pairs(fruitData) do
            data.highlight.Enabled = showHL
            data.billboard.Enabled = showESP

            if (showESP or showHL) and Cache.IsValid then
                local pos = GetFruitPos(fruit)
                if pos then
                    local dist = math.floor((pos - Cache.Position).Magnitude)
                    data.distTxt.Text = "[" .. dist .. "m]"

                    if dist < 200 then
                        data.highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                        data.distTxt.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif dist < 800 then
                        data.highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        data.distTxt.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        data.highlight.OutlineColor = Color3.fromRGB(255, 80, 0)
                        data.distTxt.TextColor3 = Color3.fromRGB(255, 80, 0)
                    end
                end
            end

            -- Notify if just appeared
            if UI.Settings.FruitNotify and not data.notified then
                Notify("🍇 Fruit Found!", data.nameTxt.Text)
                data.notified = true
            end
        end

        -- Tween to nearest
        if UI.Settings.TweenFruit then
            local fruit, dist = GetNearest()
            if fruit and dist and dist < 10000 then
                TweenToFruit(fruit)
            end
        else
            if fruitTween then
                fruitTween:Cancel()
                fruitTween = nil
            end
        end
    end
end)

-- Auto store (slow interval, no spam)
task.spawn(function()
    while task.wait(2) do
        if not UI.Settings.AutoStore or not Cache.IsValid then continue end
        pcall(function()
            for _, tool in pairs(Cache.LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("fruit") then
                    StoreFruit(tool.Name)
                    task.wait(0.5)
                end
            end
            local held = Cache.Character:FindFirstChildWhichIsA("Tool")
            if held and held.Name:lower():find("fruit") then
                StoreFruit(held.Name)
            end
        end)
    end
end)

-- Status
local StatusSec = UI:CreateSection(Tab, "FRUITS: Scanning...")
task.spawn(function()
    while task.wait(1.5) do
        local count = 0
        for _ in pairs(fruitData) do count = count + 1 end
        StatusSec:FindFirstChildWhichIsA("TextLabel").Text = "FRUITS DETECTED: " .. count
    end
end)

print("[CatHUB] Fruits loaded")