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
    if not (obj and obj.Parent) then 
        return false 
    end
    
    local ok, result = pcall(function()
        local isType = obj:IsA("Tool") or obj:IsA("Model")
        local hasTag = obj:FindFirstChild("Fruit")
        
        return isType and hasTag
    end)
    
    return ok and result
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

-- [[ ==========================================
--      4. WORKSPACE OBSERVER (AUTO-DETECTION)
--    ========================================== ]]

-- // 4.1: Initial Scan on Startup
task.spawn(function()
    _G.Cat.WaitUntilReady()
    task.wait(3) -- Buffering period for workspace assets to load

    for _, obj in pairs(Workspace:GetChildren()) do 
        if IsFruit(obj) then 
            AddESP(obj) 
        end 
    end
end)

-- // 4.2: Listen for New Fruits Spawned
Workspace.ChildAdded:Connect(function(obj) 
    -- Delay ensures internal "Fruit" tags replicate to client
    task.wait(1) 
    
    if IsFruit(obj) then 
        AddESP(obj) 
        
        -- Trigger Webhook Notification
        local canNotify = Settings.FruitWebhook and _G.Cat.Webhook
        if canNotify then
            _G.Cat.Webhook:Send(
                obj.Name, 
                game.JobId, 
                Settings.FruitWebhookRarity, 
                Settings.FruitWebhookURL
            )
        end
    end 
end)

-- // 4.3: Handle Object Removal
Workspace.ChildRemoved:Connect(function(obj) 
    RemoveESP(obj) 
end)

-- ==========================================
-- 5. EXPORTED API
-- ==========================================
_G.Cat.ESP = {
    Data = Data,
    Pos  = GetPosition,
    
    -- // Method: Find the closest fruit to LocalPlayer
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
                -- Cleanup if fruit is no longer in Workspace
                RemoveESP(fruit) 
            end 
        end 
        
        return closest 
    end,
    
    -- // Method: Return list of all active fruit names
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
--      6. PERFORMANCE OPTIMIZED UPDATE LOOP
--    ========================================== ]]

-- // Optimization: High-efficiency loop (0.5s interval)
-- // Reduces RAM/CPU overhead by avoiding Heartbeat/RenderStepped
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            -- // 6.1: Global ESP Toggle Check
            if not Settings.FruitESP then 
                for _, entry in pairs(Data) do 
                    if entry and entry.bb then 
                        entry.bb.Enabled = false 
                    end 
                end 
                return 
            end
            
            -- // 6.2: Reference Local Player State
            local char  = Me.Character 
            local hrp   = char and char:FindFirstChild("HumanoidRootPart")
            local myPos = hrp and hrp.Position
            
            -- // 6.3: Process Tracked Fruits
            for fruit, entry in pairs(Data) do 
                -- Cleanup invalid or removed objects
                local isValid = fruit 
                    and fruit.Parent 
                    and entry.bb 
                    and entry.bb.Parent
                
                if not isValid then 
                    RemoveESP(fruit) 
                    continue 
                end 
                
                -- Skip update if player is not loaded (saves FPS)
                if not myPos then continue end 
                
                -- Fetch fruit position via utility
                local fruitPos = GetPosition(fruit) 
                if not fruitPos then 
                    entry.bb.Enabled = false
                    continue 
                end 
                
                -- // 6.4: Distance Calculation & Throttling
                local dx = fruitPos.X - myPos.X
                local dy = fruitPos.Y - myPos.Y
                local dz = fruitPos.Z - myPos.Z
                
                -- Optimization: Fast magnitude calculation
                local dist = math.floor(math.sqrt(dx^2 + dy^2 + dz^2)) 
                
                -- Only update UI text if movement exceeds 5 studs (throttling)
                local lastDist = Mem[fruit] or -1
                local diff     = math.abs(dist - lastDist)

                if diff > 5 then 
                    Mem[fruit]     = dist 
                    entry.txt.Text = string.format("%s [%dm]", fruit.Name, dist) 
                end 
                
                entry.bb.Enabled = true 
            end
        end)
    end
end)