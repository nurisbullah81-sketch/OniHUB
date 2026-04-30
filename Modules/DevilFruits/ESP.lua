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
--      5. SMART CCTV & ZERO-LAG DISTANCE UPDATER
--    ========================================== ]]

local RunService = game:GetService("RunService")
local distanceLoop = nil

-- // Fungsi buat update jarak (Cuma jalan kalau ada buah!)
local function StartDistanceLoop()
    if distanceLoop then return end -- Kalo udah nyala, biarin aja
    
    distanceLoop = RunService.Heartbeat:Connect(function()
        -- Kalau toggle ESP dimatiin di UI, umpetin teksnya
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
            
            -- Kalau buah ilang / udah dimakan, hapus dari memori
            if not fruit or not fruit.Parent or fruit.Parent ~= Workspace then
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

            -- Update text cuma kalau lu jalan lebih dari 5 meter (Biar UI kaga kedut-kedut)
            if math.abs(dist - lastDist) > 5 then
                Mem[fruit] = dist
                entry.txt.Text = string.format("%s [%dm]", fruit.Name, dist)
            end

            entry.bb.Enabled = true
        end

        -- MATIIN MESIN OTOMATIS KALAU UDAH KAGA ADA BUAH DI MAP! (0% CPU Idle)
        if not hasFruits then
            distanceLoop:Disconnect()
            distanceLoop = nil
        end
    end)
end

-- // Fungsi CCTV buat ngawasin langit (Kaga pake loop!)
local function OnItemSpawned(obj)
    -- Filter super cepat: Cek apakah benda yang jatuh namanya ada tulisan "Fruit"
    if typeof(obj.Name) == "string" and string.match(obj.Name, "Fruit$") then
        task.delay(0.5, function() -- Kasih jeda 0.5 detik biar game selesai ngerender modelnya
            if IsFruit(obj) and not Data[obj] then
                AddESP(obj)
                StartDistanceLoop() -- WANGUNIN MESIN PENGHITUNG JARAK!
                
                -- Webhook Discord tetep jalan 100%
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

-- // Pasang CCTV di Workspace
Workspace.ChildAdded:Connect(OnItemSpawned)

-- // Pasang CCTV buat buah yang ilang/diambil orang
Workspace.ChildRemoved:Connect(function(obj)
    if Data[obj] then
        RemoveESP(obj)
    end
end)

-- // Sapu bersih 1x doang pas script baru di-execute
task.spawn(function()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if IsFruit(obj) and not Data[obj] then
            AddESP(obj)
        end
    end
    -- Kalau dari hasil scan awal ternyata ada buah, langsung nyalain mesin jaraknya
    if next(Data) ~= nil then
        StartDistanceLoop()
    end
end)