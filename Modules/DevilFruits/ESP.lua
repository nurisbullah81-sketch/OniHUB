-- [[ ==========================================
--      MODULE: DEVIL FRUIT ESP (GC SAFE)
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

UI.CreateToggle(Page, "Fruit ESP", "Show distance", Settings.FruitESP, function(state) Settings.FruitESP = state end)

-- ==========================================
-- UTILITIES
-- ==========================================
local Data = {} 
local Mem  = {} 

local function GetPosition(fruit)
    if not (fruit and fruit.Parent) then return nil end
    local ok, pos = pcall(function()
        if fruit:IsA("Tool") then
            local h = fruit:FindFirstChild("Handle"); return h and h.Position
        elseif fruit:IsA("Model") then
            return fruit.PrimaryPart and fruit.PrimaryPart.Position
        end
    end)
    return ok and pos or nil
end

local function IsFruit(obj)
    if not (obj and obj.Parent and (obj:IsA("Tool") or obj:IsA("Model"))) then return false end
    return obj:FindFirstChild("Fruit") ~= nil
end

local function AddESP(fruit)
    if Data[fruit] then return end
    local bb = Instance.new("BillboardGui", fruit)
    bb.Name = "CatESP"; bb.Size = UDim2.new(0, 100, 0, 20); bb.AlwaysOnTop = true; bb.Enabled = false
    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.new(1,1,1); txt.TextSize = 13; txt.Font = Enum.Font.GothamBold
    Data[fruit] = { bb = bb, txt = txt }
end

local function RemoveESP(fruit)
    if Data[fruit] then pcall(function() Data[fruit].bb:Destroy() end); Data[fruit] = nil end
end

_G.Cat.ESP = {
    Data = Data,
    Pos = GetPosition,
    GetNearestFruit = function()
        local minDist, closest = math.huge, nil
        local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        for fruit, _ in pairs(Data) do
            if fruit and fruit.Parent then
                local p = GetPosition(fruit)
                if p then local d = (p - hrp.Position).Magnitude; if d < minDist then minDist, closest = d, fruit end end
            else RemoveESP(fruit) end
        end
        return closest
    end
}

-- ==========================================
-- SMOOTH UPDATER (Heartbeat based, NOT RenderStepped)
-- ==========================================
task.spawn(function()
    while task.wait(0.15) do -- Update 7x per detik saja, cukup untuk ESP
        if not Settings.FruitESP then continue end
        
        local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local pos = hrp.Position
        for fruit, entry in pairs(Data) do
            if not fruit or not fruit.Parent then RemoveESP(fruit); continue end
            
            local fPos = GetPosition(fruit)
            if fPos then
                local dist = math.floor((fPos - pos).Magnitude)
                -- Hanya update text kalau jarak berubah drastis (hemat string garbage)
                if not Mem[fruit] or math.abs(Mem[fruit] - dist) > 4 then
                    Mem[fruit] = dist
                    entry.txt.Text = string.format("%s [%sm]", fruit.Name, dist)
                end
                entry.bb.Enabled = true
            else
                entry.bb.Enabled = false
            end
        end
    end
end)

-- CCTV
Workspace.ChildAdded:Connect(function(obj)
    if not (obj:IsA("Model") or obj:IsA("Tool")) then return end
    task.delay(0.1, function()
        if IsFruit(obj) then AddESP(obj) end
    end)
end)
Workspace.ChildRemoved:Connect(function(obj) if Data[obj] then RemoveESP(obj) end end)

-- Initial Scan
for _, obj in ipairs(Workspace:GetDescendants()) do if IsFruit(obj) then AddESP(obj) end end