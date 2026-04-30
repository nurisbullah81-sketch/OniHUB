-- [[ ==========================================
--      MODULE: DEVIL FRUIT ESP (SMART CCTV)
--    ========================================== ]]

local Workspace = game:GetService("Workspace")
local Players   = game:GetService("Players")
local RunService = game:GetService("RunService")

local Me = Players.LocalPlayer

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings and _G.Cat.State

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State

-- ==========================================
-- UI INIT
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)
UI.CreateSection(Page, "FRUIT FINDER")

UI.CreateToggle(Page, "Fruit ESP", "Show text on fruits", Settings.FruitESP, function(state) Settings.FruitESP = state end)

-- ==========================================
-- INTERNAL UTILITIES
-- ==========================================
local Data = {} -- ESP Objects
local Mem  = {} -- Distance Cache

local function GetPosition(fruit)
    if not (fruit and fruit.Parent) then return nil end
    
    local ok, pos = pcall(function()
        if fruit:IsA("Tool") then
            local handle = fruit:FindFirstChild("Handle")
            return handle and handle.Position
        elseif fruit:IsA("Model") then
            if fruit.PrimaryPart then return fruit.PrimaryPart.Position end
            local alt = fruit:FindFirstChild("HumanoidRootPart") or fruit:FindFirstChildWhichIsA("BasePart")
            return alt and alt.Position
        end
    end)
    return ok and pos or nil
end

local function IsFruit(obj)
    if not (obj and obj.Parent) then return false end
    if not (obj:IsA("Tool") or obj:IsA("Model")) then return false end
    return obj:FindFirstChild("Fruit") ~= nil
end

local function AddESP(fruit)
    if not (fruit and fruit.Parent) or Data[fruit] then return end
    
    pcall(function()
        local bb = Instance.new("BillboardGui", fruit)
        bb.Name = "CatESP"
        bb.Size = UDim2.new(0, 150, 0, 20)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.Enabled = false -- Awal mati, nyalain pas loop jalan
        
        local txt = Instance.new("TextLabel", bb)
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.Text = fruit.Name
        txt.TextSize = 13
        txt.Font = Enum.Font.GothamBold
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.BackgroundTransparency = 1
        txt.TextStrokeTransparency = 0.3
        
        Data[fruit] = { bb = bb, txt = txt }
        Mem[fruit] = -1
    end)
end

local function RemoveESP(fruit)
    if Data[fruit] then
        pcall(function() if Data[fruit].bb then Data[fruit].bb:Destroy() end end)
        Data[fruit] = nil
        Mem[fruit] = nil
    end
end

-- ==========================================
-- EXPORT API
-- ==========================================
_G.Cat.ESP = {
    Data = Data,
    Pos = GetPosition,
    
    GetNearestFruit = function() 
        local closest, minDist = nil, math.huge 
        local char = Me.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart") 
        if not hrp then return nil end 
        
        for fruit, _ in pairs(Data) do 
            if fruit and fruit.Parent == Workspace then 
                local p = GetPosition(fruit)
                if p then 
                    local d = (p - hrp.Position).Magnitude 
                    if d < minDist then closest, minDist = fruit, d end 
                end 
            else 
                RemoveESP(fruit) 
            end 
        end 
        return closest 
    end
}

-- ==========================================
-- SMART UPDATE LOOP (Optimized RenderStepped)
-- ==========================================
local loopRunning = false

local function StartLoop()
    if loopRunning then return end
    loopRunning = true
    
    RunService.RenderStepped:Connect(function()
        -- Safety: Kalau nggak ada buah atau ESP mati, skip semua logic
        if not Settings.FruitESP or next(Data) == nil then
            -- Jangan langsung disconnect, biarkan ngecek frame selanjutnya
            -- Ini mencegah "bodoh" kalau tiba2 buah spawn
            return 
        end

        local char = Me.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local myPos = hrp.Position

        for fruit, entry in pairs(Data) do
            if not fruit or not fruit.Parent then
                RemoveESP(fruit)
                continue
            end

            local fruitPos = GetPosition(fruit)
            if not fruitPos then 
                entry.bb.Enabled = false
                continue 
            end

            -- Cuma update text kalau posisi berubah signifikan (Hemat CPU)
            local dist = math.floor((fruitPos - myPos).Magnitude)
            if math.abs(dist - (Mem[fruit] or -1)) > 4 then -- Toleransi 4 meter
                Mem[fruit] = dist
                entry.txt.Text = string.format("%s [%sm]", fruit.Name, dist)
            end

            entry.bb.Enabled = true
        end
    end)
end

-- ==========================================
-- DETECTOR (CCTV)
-- ==========================================
Workspace.ChildAdded:Connect(function(obj)
    -- Filter Ketat
    if not (obj:IsA("Model") or obj:IsA("Tool")) then return end
    
    task.delay(0.1, function() -- Jeda dikit biar property ke-load
        if IsFruit(obj) and not Data[obj] then
            AddESP(obj)
            StartLoop() -- Pastiin loop idup kalau ada buah
        end
    end)
end)

Workspace.ChildRemoved:Connect(function(obj)
    if Data[obj] then RemoveESP(obj) end
end)

-- Initial Scan (Async)
task.spawn(function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if IsFruit(obj) and not Data[obj] then AddESP(obj) end
    end
    if next(Data) ~= nil then StartLoop() end
end)