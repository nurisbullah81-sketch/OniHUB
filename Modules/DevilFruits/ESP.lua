-- [[ ==========================================
--      MODULE: DEVIL FRUIT ESP (STYLE RESTORED)
--    ========================================== ]]

local Workspace = game:GetService("Workspace")
local Players   = game:GetService("Players")
local RunService = game:GetService("RunService")

local Me = Players.LocalPlayer

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings and _G.Cat.State

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State

local Page = UI.CreateTab("Devil Fruits", false)
UI.CreateSection(Page, "FRUIT FINDER")

UI.CreateToggle(Page, "Fruit ESP", "Show text on any spawned fruits", Settings.FruitESP, function(state) 
    Settings.FruitESP = state 
end)

-- ==========================================
-- INTERNAL UTILITIES
-- ==========================================
local Data = {} -- Stores ESP Objects
local Mem  = {} -- Stores last known distance

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

-- ==========================================
-- ESP MANAGEMENT (STYLE PREMIUM RESTORED)
-- ==========================================
local function AddESP(fruit)
    if not (fruit and fruit.Parent) or Data[fruit] then return end
    
    pcall(function()
        local bb = Instance.new("BillboardGui", fruit)
        bb.Name = "CatESP"
        bb.Size = UDim2.new(0, 150, 0, 20)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.Enabled = false
        
        -- Style Text Persis Punya Lu
        local txt = Instance.new("TextLabel", bb)
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.Text = string.format("%s []", fruit.Name) -- Format awal
        txt.TextSize = 13
        txt.Font = Enum.Font.GothamBold -- Balikin Font Premium
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.BackgroundTransparency = 1
        txt.TextStrokeTransparency = 0.3
        txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        
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
-- EXPORTED API
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
-- SMOOTH UPDATER (HEARTBEAT - HEMAT CPU)
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do -- Update setiap 0.1 detik (Cukup smooth)
        if not Settings.FruitESP then continue end
        
        local char = Me.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local myPos = hrp.Position

        for fruit, entry in pairs(Data) do
            if not fruit or not fruit.Parent then
                RemoveESP(fruit)
                continue
            end

            local fruitPos = GetPosition(fruit)
            if fruitPos then
                local dist = math.floor((fruitPos - myPos).Magnitude)
                
                -- Update Text kalau jarak berubah (Hemat String Rendering)
                if math.abs(dist - (Mem[fruit] or -1)) > 3 then
                    Mem[fruit] = dist
                    -- Format Persis: Nama [Jarak m]
                    entry.txt.Text = string.format("%s [%dm]", fruit.Name, dist)
                end
                entry.bb.Enabled = true
            else
                entry.bb.Enabled = false
            end
        end
    end
end)

-- CCTV SENSOR
Workspace.ChildAdded:Connect(function(obj)
    if not (obj:IsA("Model") or obj:IsA("Tool")) then return end
    task.delay(0.5, function()
        if IsFruit(obj) and not Data[obj] then AddESP(obj) end
    end)
end)

Workspace.ChildRemoved:Connect(function(obj)
    if Data[obj] then RemoveESP(obj) end
end)

-- Initial Scan
for _, obj in ipairs(Workspace:GetDescendants()) do
    if IsFruit(obj) and not Data[obj] then AddESP(obj) end
end