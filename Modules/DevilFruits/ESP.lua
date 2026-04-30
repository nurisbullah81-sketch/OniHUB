-- ==========================================
-- MODULE: DEVIL FRUIT ESP (SUPER OPTIMIZED)
-- ==========================================

-- Services
local Workspace   = game:GetService("Workspace")
local Players     = game:GetService("Players")

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

-- TUNGGU GAME READY DULU SEBELUM SCAN AWAL (BIAR KAGAK MISDETEKSI)
task.spawn(function()
    _G.Cat.WaitUntilReady()
    task.wait(3) -- Jeda 3 detik setelah hidup biar map ke-load semua
    
    for _, obj in pairs(Workspace:GetChildren()) do 
        if IsFruit(obj) then AddESP(obj) end 
    end
end)

-- Monitor New Fruits
Workspace.ChildAdded:Connect(function(obj) 
    task.wait(1) -- Diperbesar dari 0.5 ke 1 detik, biar object "Fruit" didalemnya sempat ke-load oleh game
    
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
-- 6. SUPER LIGHTWEIGHT LOOP (NAT HUB STYLE)
-- ==========================================
-- Gue buang RunService! Pake task.spawn biasa yang jauh lebih hemat RAM & CPU.
-- Update 2x per detik aja (0.5), mata lu kagak bakal ngeliat bedanya tapi PC lu LEGA!
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            -- Kalau ESP dimatikan, sembunyikan semua text
            if not Settings.FruitESP then 
                for _, d in pairs(Data) do 
                    if d and d.bb then d.bb.Enabled = false end 
                end 
                return 
            end
            
            local c = Me.Character 
            local r = c and c:FindFirstChild("HumanoidRootPart")
            local mp = r and r.Position
            
            for f, d in pairs(Data) do 
                -- Bersihkan data buah yang udah ilang
                if not f or not f.Parent or not d.bb or not d.bb.Parent then 
                    RemoveESP(f) 
                    continue 
                end 
                
                -- Kalau karakter belum load / lagi mati, kagak usah update jarak (hemat fps)
                -- Tapi ESP tetep nyala kaya biasa!
                if not mp then continue end 
                
                local p = GetPosition(f) 
                if not p then 
                    d.bb.Enabled = false
                    continue 
                end 
                
                local dx, dy, dz = p.X - mp.X, p.Y - mp.Y, p.Z - mp.Z 
                local m = math.floor(math.sqrt(dx*dx + dy*dy + dz*dz)) 
                
                -- Update text jarak kalo perubahan lebih dari 5 meter
                if math.abs(m - (Mem[f] or -1)) > 5 then 
                    Mem[f] = m 
                    d.txt.Text = f.Name .. " [" .. m .. "m]" 
                end 
                d.bb.Enabled = true 
            end
        end)
    end
end)