-- [[ ==========================================
--      MODULE: DEVIL FRUIT ESP (OPTIMIZED)
--    ========================================== ]]

-- // Services
local Workspace = game:GetService("Workspace")
local Players   = game:GetService("Players")

-- // Variables
local Me = Players.LocalPlayer

-- // Wait for Core System Initialization
repeat 
    task.wait(0.1) 
until _G.Cat 
    and _G.Cat.UI 
    and _G.Cat.Settings 
    and _G.Cat.State

-- // Reference Global Components
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State

-- ==========================================
-- 1. UI INITIALIZATION
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)

UI.CreateSection(Page, "FRUIT FINDER")

-- // ESP Toggle Setup
UI.CreateToggle(
    Page, 
    "Fruit ESP", 
    "Show text on any spawned fruits", 
    Settings.FruitESP, 
    function(state) 
        Settings.FruitESP = state 
    end
)

-- ==========================================
-- 2. INTERNAL UTILITIES
-- ==========================================
local Data = {} -- Stores ESP Objects
local Mem  = {} -- Stores last known distance

-- // Function: Get Fruit Position Safely
local function GetPosition(fruit)
    if not (fruit and fruit.Parent) then 
        return nil 
    end
    
    local ok, pos = pcall(function()
        -- Handle Tool Type
        if fruit:IsA("Tool") then
            local handle = fruit:FindFirstChild("Handle")
            return handle and handle.Position
        
        -- Handle Model Type
        elseif fruit:IsA("Model") then
            if fruit.PrimaryPart then 
                return fruit.PrimaryPart.Position 
            end
            
            -- Fallback Search
            local alt = fruit:FindFirstChild("HumanoidRootPart") 
                or fruit:FindFirstChildWhichIsA("BasePart")
            
            return alt and alt.Position
        end
    end)
    
    return ok and pos or nil
end

-- // Function: Validate Devil Fruit Object
local function IsFruit(obj)
    if not (obj and obj.Parent) then return false end
    
    -- Filter super cepat tanpa pcall yang bikin berat CPU
    if not (obj:IsA("Tool") or obj:IsA("Model")) then return false end
    
    return obj:FindFirstChild("Fruit") ~= nil
end

-- [[ ==========================================
--      3. ESP MANAGEMENT (GUI HANDLERS)
--    ========================================== ]]

-- // Function: Add ESP to Fruit Object
local function AddESP(fruit)
    -- Early exit if invalid or already exists
    local shouldIgnore = not (fruit and fruit.Parent) or Data[fruit]
    if shouldIgnore then return end
    
    pcall(function()
        -- // 3.1: BillboardGui Setup
        local bb         = Instance.new("BillboardGui", fruit)
        bb.Name          = "CatESP"
        bb.Size          = UDim2.new(0, 150, 0, 20)
        bb.AlwaysOnTop   = true
        bb.StudsOffset   = Vector3.new(0, 3, 0)
        bb.Enabled       = false
        
        -- // 3.2: TextLabel Setup
        local txt        = Instance.new("TextLabel", bb)
        txt.Size         = UDim2.new(1, 0, 1, 0)
        txt.Text         = string.format("%s []", fruit.Name)
        txt.TextSize     = 13
        txt.Font         = Enum.Font.GothamBold
        txt.TextColor3   = Color3.fromRGB(255, 255, 255)
        txt.TextXAlignment         = Enum.TextXAlignment.Left
        txt.BackgroundTransparency = 1
        txt.TextStrokeTransparency = 0.3
        txt.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
        
        -- // 3.3: Store References
        Data[fruit] = { 
            bb  = bb, 
            txt = txt 
        }
        Mem[fruit]  = -1
    end)
end

-- // Function: Remove ESP from Fruit Object
local function RemoveESP(fruit)
    local entry = Data[fruit]
    
    if entry then
        pcall(function()
            local gui = entry.bb
            if gui and gui.Parent then
                gui:Destroy()
            end
        end)
        
        -- Clear from tracking tables
        Data[fruit] = nil
        Mem[fruit]  = nil
    end
end

-- ==========================================
-- 4. EXPORTED API (YANG KEMAREN KEHAPUS JIR!)
-- ==========================================
_G.Cat.ESP = {
    Data = Data,
    Pos  = GetPosition,
    
    GetNearestFruit = function() 
        local closest = nil
        local minDist = math.huge 
        local char    = Me.Character
        local hrp     = char and char:FindFirstChild("HumanoidRootPart") 
        
        if not hrp then return nil end 
        
        for fruit, _ in pairs(Data) do 
            if fruit and fruit.Parent == Workspace then 
                local fruitPos = GetPosition(fruit) 
                if fruitPos then 
                    local dist = (fruitPos - hrp.Position).Magnitude 
                    if dist < minDist then 
                        closest = fruit
                        minDist = dist 
                    end 
                end 
            else 
                RemoveESP(fruit) 
            end 
        end 
        return closest 
    end,
    
    GetFruitsList = function() 
        local names = {} 
        for fruit, _ in pairs(Data) do 
            if fruit and fruit.Parent then 
                table.insert(names, fruit.Name) 
            end 
        end 
        return names 
    end
}

-- [[ ==========================================
--      5. SMART CCTV X-RAY & ZERO-LAG UPDATER
--    ========================================== ]]

local RunService = game:GetService("RunService")
local distanceLoop = nil

-- // FUNGSI MESIN JARAK (Tidur kalau kaga ada buah)
local function StartDistanceLoop()
    if distanceLoop then return end 
    
    distanceLoop = RunService.Heartbeat:Connect(function()
        if not Settings.FruitESP then
            for _, entry in pairs(Data) do
                if entry and entry.bb then entry.bb.Enabled = false end
            end
            return
        end

        local char  = Me.Character
        local hrp   = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local myPos = hrp.Position
        local hasFruits = false

        for fruit, entry in pairs(Data) do
            hasFruits = true
            
            if not fruit or not fruit.Parent then
                RemoveESP(fruit)
                continue
            end

            local fruitPos = GetPosition(fruit)
            if not fruitPos then 
                entry.bb.Enabled = false
                continue
            end

            local dist = math.floor((fruitPos - myPos).Magnitude)
            local lastDist = Mem[fruit] or -1

            if math.abs(dist - lastDist) > 5 then
                Mem[fruit] = dist
                entry.txt.Text = string.format("%s [%dm]", fruit.Name, dist)
            end

            entry.bb.Enabled = true
        end

        if not hasFruits then
            distanceLoop:Disconnect()
            distanceLoop = nil
        end
    end)
end

-- [[ LOKASI: PALING BAWAH SENDIRI, GANTI FUNGSI OnItemSpawned DAN LISTENER NYA ]]

-- // SENSOR X-RAY (Hanya aktif kalau beneran Model/Tool)
local function OnItemSpawned(obj)
    -- Filter Pintar: Cek dulu tipenya sebelum buka string. Hemat 90% CPU.
    if not (obj:IsA("Model") or obj:IsA("Tool")) then return end

    if typeof(obj.Name) == "string" and string.match(obj.Name, "Fruit$") then
        task.delay(0.5, function() -- Jeda biar game render dulu
            -- Cek validitas isolasi (aman dari error)
            if obj.Parent and IsFruit(obj) and not Data[obj] then
                AddESP(obj)
                StartDistanceLoop() -- Nyalain mesin jarak
                
                -- Webhook logic biarkan sama persis seperti punya lu
                if Settings.FruitWebhook and _G.Cat.Webhook then
                    _G.Cat.Webhook:Send(
                        obj.Name, 
                        game.JobId, 
                        Settings.FruitWebhookRarity, 
                        Settings.FruitWebhookURL
                    )
                end
            end
        end)
    end
end

-- Pasang sensor yang udah pintar
Workspace.ChildAdded:Connect(OnItemSpawned)
Workspace.ChildRemoved:Connect(function(obj)
    if Data[obj] then 
        RemoveESP(obj) 
    end
end)

-- // GELEDAH MAP PAKAI CARA HALUS (Anti-Freeze Startup)
task.spawn(function()
    -- Lu musti paham, di Blox Fruits buah bisa spawn di mana aja.
    -- Kita pakai cara 'StreamingEnabled' style manual.
    
    local descendants = Workspace:GetDescendants() -- Ambil data sekali
    
    for index, obj in ipairs(descendants) do
        -- PROTEKSI: Pause dikit setiap 50 object biar FPS stabil
        if index % 50 == 0 then 
            task.wait() -- Ini kuncinya, biar nggak nge-block main thread
        end
        
        -- Logic cek buah (sama seperti di atas)
        if (obj:IsA("Model") or obj:IsA("Tool")) and typeof(obj.Name) == "string" then
            if string.match(obj.Name, "Fruit$") and IsFruit(obj) and not Data[obj] then
                AddESP(obj)
            end
        end
    end
    
    -- Kalau ketemu buah, baru nyalain mesin jarak
    if next(Data) ~= nil then
        StartDistanceLoop()
    end
end)