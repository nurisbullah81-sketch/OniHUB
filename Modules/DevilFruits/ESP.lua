-- ==========================================
-- MODULE: DEVIL FRUIT ESP
-- ==========================================

-- Services
local Workspace   = game:GetService("Workspace")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")

-- Variables
local Me = Players.LocalPlayer

-- Wait for Core
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings or not _G.Cat.State do 
    task.wait(0.1) 
end

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State

-- ==========================================
-- 1. UI SETUP
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)

UI.CreateSection(Page, "FRUIT FINDER")

UI.CreateToggle(
    Page, 
    "Fruit ESP", 
    "Show text on any spawned fruits", 
    Settings.FruitESP, 
    function(s) 
        Settings.FruitESP = s 
    end
)

-- ==========================================
-- 2. INTERNAL UTILITIES
-- ==========================================
local Data  = {} -- Stores ESP Objects
local Mem   = {} -- Stores last known distance
local FC    = 0
local SKIP  = 10 -- Update every 10 frames

-- Function: Get Fruit Position safely
local function GetPosition(fruit)
    if not fruit or not fruit.Parent then return nil end
    
    local ok, pos = pcall(function()
        if fruit:IsA("Tool") then
            local handle = fruit:FindFirstChild("Handle")
            return handle and handle.Position
        elseif fruit:IsA("Model") then
            if fruit.PrimaryPart then 
                return fruit.PrimaryPart.Position 
            end
            
            local alternative = fruit:FindFirstChild("HumanoidRootPart") 
                or fruit:FindFirstChildWhichIsA("BasePart")
            return alternative and alternative.Position
        end
    end)
    
    return ok and pos or nil
end

-- Function: Check if object is a Devil Fruit
local function IsFruit(obj)
    if not obj or not obj.Parent then return false end
    
    local ok, result = pcall(function()
        -- Devil Fruits in Blox Fruits are usually Tools/Models with a "Fruit" tag inside
        if (obj:IsA("Tool") or obj:IsA("Model")) and obj:FindFirstChild("Fruit") then
            return true
        end
        return false
    end)
    
    return ok and result
end

-- ==========================================
-- 3. ESP MANAGEMENT
-- ==========================================

local function AddESP(fruit)
    if not fruit or not fruit.Parent or Data[fruit] then return end
    
    pcall(function()
        local bb = Instance.new("BillboardGui", fruit)
        bb.Name = "CatESP"
        bb.Size = UDim2.new(0, 150, 0, 20)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.Enabled = false
        
        local txt = Instance.new("TextLabel", bb)
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = fruit.Name .. " []"
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.TextStrokeTransparency = 0.3
        txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 13
        txt.TextXAlignment = Enum.TextXAlignment.Left
        
        Data[fruit] = { bb = bb, txt = txt }
        Mem[fruit] = -1
    end)
end

local function RemoveESP(fruit)
    if Data[fruit] then
        pcall(function()
            if Data[fruit].bb and Data[fruit].bb.Parent then
                Data[fruit].bb:Destroy()
            end
        end)
        Data[fruit] = nil
        Mem[fruit] = nil
    end
end

-- ==========================================
-- 4. WORKSPACE OBSERVER
-- ==========================================

-- Initial Scan
for _, obj in pairs(Workspace:GetChildren()) do 
    if IsFruit(obj) then AddESP(obj) end 
end

-- Monitor New Fruits
Workspace.ChildAdded:Connect(function(obj) 
    task.wait(0.5) -- Small delay for object replication
    
    if IsFruit(obj) then 
        AddESP(obj) 
        
        -- Webhook Integration
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

-- Monitor Fruit Removal
Workspace.ChildRemoved:Connect(function(obj) 
    RemoveESP(obj) 
end)

-- ==========================================
-- 5. EXPORTED API
-- ==========================================
_G.Cat.ESP = {
    Data = Data,
    Pos  = GetPosition,
    
    GetNearestFruit = function() 
        local closest, minDist = nil, math.huge 
        local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
        
        if not hrp then return nil end 
        
        for fruit, _ in pairs(Data) do 
            if fruit and fruit.Parent == Workspace then 
                local p = GetPosition(fruit) 
                if p then 
                    local dist = (p - hrp.Position).Magnitude 
                    if dist < minDist then 
                        closest, minDist = fruit, dist 
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

-- ==========================================
-- 6. RENDER LOOP (Distance Updates)
-- ==========================================
RunService.Heartbeat:Connect(function() 
    FC = FC + 1 
    if FC % 10 ~= 0 then return end -- Cek 10x per detik aja
    
    pcall(function() 
        -- PINTU DARURAT: Kalau lagi loading/mati, matiin semua ESP & langsung diam
        if not _G.Cat.State.IsGameReady then 
            for _, d in pairs(Data) do 
                if d and d.bb then d.bb.Enabled = false end 
            end 
            return 
        end 
        
        if not Settings.FruitESP then 
            for _, d in pairs(Data) do 
                if d and d.bb then d.bb.Enabled = false end 
            end 
            return 
        end 
        
        local c = Me.Character 
        if not c then return end 
        local r = c:FindFirstChild("HumanoidRootPart") 
        if not r then return end 
        local mp = r.Position 
        
        for f, d in pairs(Data) do 
            -- FIX BUG: Rem -> RemoveESP, Pos -> GetPosition biar kagak crash!
            if not f or not f.Parent or not d.bb or not d.bb.Parent then 
                RemoveESP(f) 
                continue 
            end 
            
            local p = GetPosition(f) 
            if not p then 
                d.bb.Enabled = false 
                continue 
            end 
            
            local dx, dy, dz = p.X - mp.X, p.Y - mp.Y, p.Z - mp.Z 
            local m = math.floor(math.sqrt(dx*dx + dy*dy + dz*dz)) 
            
            if math.abs(m - (Mem[f] or -1)) > 5 then 
                Mem[f] = m 
                d.txt.Text = f.Name .. " [" .. m .. "m]" 
            end 
            d.bb.Enabled = true 
        end
    end) 
end)