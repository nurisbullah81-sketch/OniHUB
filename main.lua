--[[
   ⚡ ONIHUB PRO v2.0 — Blox Fruits (Update 2026)
   FITUR: Fruit ESP (Highlight + Billboard), Auto Fruit Finder,
          Anti-Ban (silent-exec), Tween Collector, ServerHop opsional
   SUPPORT: Solara Executor (Level 3, UNC 52%)
   CATATAN: Hanya gunakan di akun alt! Gunakan dengan bijak!
--]]

-- // KONFIGURASI GLOBAL \\ --
local cfg = {
    ESP = true,              -- Fruit ESP aktif?
    AUTO_COLLECT = false,    -- Otomatis ambil buah?
    NOTIFY_RARE = true,      -- Notifikasi buah Rare/Mythical?
    SCAN_RADIUS = 500,       -- Jarak maksimum Auto Collect (stud)
    TEAM = "Pirates",        -- Pirates / Marines
    SERVER_HOP = false,      -- Server hop setelah collect?
    HOP_DELAY = 5,           -- Delay sebelum server hop
    USE_HIGHLIGHT = true,    -- Gunakan Highlight (aktifkan jika Solara support)
    USE_BILLBOARD = true     -- Gunakan BillboardGUI (selalu aman)
}

-- // ANTI-BAN BASIC (Silent Execution) \\ --
local function antiBan()
    -- Matikan jejak script di environment
    if getgenv then getgenv().script = nil end
    if getrenv then getrenv().script = nil end
    -- Hindari deteksi CoreGui
    local coreGui = game:GetService("CoreGui")
    if coreGui then
        coreGui.ChildAdded:Connect(function(child)
            if child.Name:find("Script") or child.Name:find("Inject") then
                pcall(function() child:Destroy() end)
            end
        end)
    end
end
antiBan()

-- // FRUIT DATABASE 2026 (Update 30 + 4th Sea) \\ --
local FRUIT_LIST = {
    -- Natural
    "Bomb-Fruit", "Spike-Fruit", "Chop-Fruit", "Spring-Fruit",
    "Rocket-Fruit", "Spin-Fruit", "Kilo-Fruit", "Love-Fruit",
    "Rubber-Fruit", "Barrier-Fruit", "Ghost-Fruit", "Revive-Fruit",
    "Diamond-Fruit", "Pain-Fruit", "Shadow-Fruit", "Spirit-Fruit",
    "Control-Fruit", "Portal-Fruit", "Venom-Fruit",
    -- Elemental
    "Flame-Fruit", "Ice-Fruit", "Light-Fruit", "Magma-Fruit",
    "Rumble-Fruit", "Dough-Fruit", "Blizzard-Fruit", "Sound-Fruit",
    "Phoenix-Fruit", "Gas-Fruit", "Smoke-Fruit", "Sand-Fruit",
    "Dark-Fruit", "Gravity-Fruit", "Lightning-Fruit",
    -- Beast
    "Buddha-Fruit", "Dragon-Fruit", "Leopard-Fruit", "Kitsune-Fruit",
    "T-Rex-Fruit", "Mammoth-Fruit", "Tiger-Fruit", "Yeti-Fruit",
    "Eagle-Fruit",
    -- New 2026 Possible
    "Celestial-Fruit", "Oni-Fruit"
}

-- Fungsi untuk mendapatkan nama bersih (tanpa "-Fruit")
local function getCleanName(fruitName)
    return fruitName:gsub("%-Fruit$", "")
end

-- // UTILITY: Notifikasi \\ --
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- // ESP SYSTEM (Highlight + Billboard) \\ --
local ESP = {}
ESP.Active = {}
ESP.Highlights = {}

function ESP:CreateBillboard(fruit)
    if not cfg.USE_BILLBOARD then return end
    if fruit:FindFirstChild("OniESP_Bill") then return end
    local bill = Instance.new("BillboardGui")
    bill.Name = "OniESP_Bill"
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = fruit

    local frame = Instance.new("Frame", bill)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.6
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = getCleanName(fruit.Name) .. " 🍈"
    label.TextColor3 = Color3.fromRGB(0, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansBold
    label.BackgroundTransparency = 1
end

function ESP:CreateHighlight(fruit)
    if not cfg.USE_HIGHLIGHT then return end
    if ESP.Highlights[fruit] then return end
    local h = Instance.new("Highlight")
    h.Name = "OniESP_High"
    h.FillColor = Color3.fromRGB(0, 255, 255)
    h.OutlineColor = Color3.fromRGB(0, 200, 255)
    h.FillTransparency = 0.4
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = fruit
    ESP.Highlights[fruit] = h
end

function ESP:RemoveFromFruit(fruit)
    if fruit:FindFirstChild("OniESP_Bill") then
        fruit.OniESP_Bill:Destroy()
    end
    if ESP.Highlights[fruit] then
        ESP.Highlights[fruit]:Destroy()
        ESP.Highlights[fruit] = nil
    end
end

function ESP:Scan()
    local ws = game:GetService("Workspace")
    for _, obj in ipairs(ws:GetChildren()) do
        if obj:IsA("Tool") and obj.Name:find("-Fruit") then
            if cfg.ESP then
                ESP:CreateBillboard(obj)
                ESP:CreateHighlight(obj)
                if not ESP.Active[obj] and cfg.NOTIFY_RARE and obj.Name:find("Dragon|Kitsune|Leopard|Dough|T-Rex|Yeti|Tiger|Celestial|Oni") then
                    notify("⭐ BUAH RARE!", getCleanName(obj.Name) .. " spawn!", 8)
                end
                ESP.Active[obj] = true
            end
        end
    end
    -- Cleanup
    for fruit, _ in pairs(ESP.Active) do
        if fruit.Parent == nil then
            ESP:RemoveFromFruit(fruit)
            ESP.Active[fruit] = nil
        end
    end
end

-- // AUTO COLLECT SYSTEM \\ --
local Collect = {}
local tweenService = game:GetService("TweenService")

function Collect:FindFruits()
    local fruits = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and obj.Name:find("-Fruit") then
            table.insert(fruits, obj)
        end
    end
    return fruits
end

function Collect:GetNearestFruit()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local nearest = nil
    local nearestDist = math.huge
    for _, fruit in ipairs(Collect:FindFruits()) do
        local handle = fruit:FindFirstChild("Handle")
        if handle then
            local dist = (handle.Position - root.Position).Magnitude
            if dist < nearestDist and dist <= cfg.SCAN_RADIUS then
                nearest = fruit
                nearestDist = dist
            end
        end
    end
    return nearest
end

function Collect:CollectFruit(fruit)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local handle = fruit:FindFirstChild("Handle")
    if not handle then return end
    -- Tween ke buah
    local tween = tweenService:Create(root, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {CFrame = handle.CFrame})
    tween:Play()
    tween.Completed:Wait()
    -- Equip (pickup)
    pcall(function()
        fruit.Parent = game.Players.LocalPlayer.Backpack
    end)
    notify("🎒 DIAMBIL", getCleanName(fruit.Name) .. " masuk backpack!", 3)
end

function Collect:AutoCollectLoop()
    while task.wait(0.5) do
        if cfg.AUTO_COLLECT then
            local fruit = Collect:GetNearestFruit()
            if fruit then
                Collect:CollectFruit(fruit)
                if cfg.SERVER_HOP then
                    task.wait(cfg.HOP_DELAY)
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end
            end
        end
    end
end

-- // MAIN \\ --
task.spawn(function()
    while task.wait(0.2) do
        if cfg.ESP then
            ESP:Scan()
        end
    end
end)

task.spawn(Collect.AutoCollectLoop)

-- // UI SIMPLE (Console Based) \\ --
local function printUI()
    print("========================================")
    print("   ONIHUB PRO v2.0 - Blox Fruits 2026")
    print("========================================")
    print(" FITUR:")
    print("   🍈 Fruit ESP : " .. tostring(cfg.ESP))
    print("   🎒 Auto Collect : " .. tostring(cfg.AUTO_COLLECT))
    print("   🔔 Notify Rare : " .. tostring(cfg.NOTIFY_RARE))
    print("   🌐 Server Hop : " .. tostring(cfg.SERVER_HOP))
    print("----------------------------------------")
    print(" COMMANDS:")
    print("   esp_on()  - Aktifkan ESP")
    print("   esp_off() - Matikan ESP")
    print("   collect_on()  - Aktifkan Auto Collect")
    print("   collect_off() - Matikan Auto Collect")
    print("   serverhop_on() - Aktifkan Server Hop")
    print("   serverhop_off() - Matikan Server Hop")
    print("========================================")
end

-- Global commands (untuk debug/testing)
function esp_on() cfg.ESP = true print("ESP: ON") end
function esp_off() cfg.ESP = false print("ESP: OFF")
    for fruit, _ in pairs(ESP.Active) do
        ESP:RemoveFromFruit(fruit)
    end
    ESP.Active = {}
end
function collect_on() cfg.AUTO_COLLECT = true print("Auto Collect: ON") end
function collect_off() cfg.AUTO_COLLECT = false print("Auto Collect: OFF") end
function serverhop_on() cfg.SERVER_HOP = true print("Server Hop: ON") end
function serverhop_off() cfg.SERVER_HOP = false print("Server Hop: OFF") end

printUI()
notify("✅ ONIHUB AKTIF", "Script berjalan, Sir! 🫡", 5)

print("ONIHUB PRO v2.0 loaded successfully!")