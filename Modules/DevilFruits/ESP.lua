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

-- [[ ==========================================
--      4 & 6. SMART SCANNER & UPDATE LOOP (ANTI-PING SPIKE)
--    ========================================== ]]

-- KITA GABUNG JADI SATU LOOP, HAPUS WORKSPACE.CHILDADDED!
task.spawn(function()
    local scanTimer = 0
    
    while task.wait(0.5) do
        -- 1. Kalau ESP mati, sembunyiin UI
        if not Settings.FruitESP then 
            for _, entry in pairs(Data) do 
                if entry and entry.bb then entry.bb.Enabled = false end 
            end 
            continue 
        end
        
        local char  = Me.Character 
        local hrp   = char and char:FindFirstChild("HumanoidRootPart")
        local myPos = hrp and hrp.Position
        if not myPos then continue end 
        
        -- 2. SMART SCANNER (Jalanin absen buah cuma setiap 3 detik sekali)
        -- Ini ngebunuh lag peluru/ledakan secara instan, CPU kaga peduli lagi ada part baru!
        scanTimer = scanTimer + 0.5
        if scanTimer >= 3 then
            scanTimer = 0
            for _, obj in ipairs(Workspace:GetChildren()) do 
                if IsFruit(obj) and not Data[obj] then 
                    AddESP(obj) 
                end 
            end
        end
        
        -- 3. NAMPILIN JARAK
        for fruit, entry in pairs(Data) do 
            -- Kalau buah ilang / dimakan, hapus dari memori
            if not fruit or not fruit.Parent or not entry.bb or not entry.bb.Parent then 
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
    end
end)