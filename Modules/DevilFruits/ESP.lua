-- [[ ==========================================
--      MODULE: DEVIL FRUIT ESP (ULTIMATE FIX)
--    ========================================== ]]

local Workspace   = game:GetService("Workspace")
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")

local Me = Players.LocalPlayer

repeat
    task.wait(0.1)
until _G.Cat and _G.Cat.UI and _G.Cat.Settings and _G.Cat.State

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State

local Page = UI.CreateTab("Devil Fruits", false)
UI.CreateSection(Page, "FRUIT FINDER")

UI.CreateToggle(
    Page,
    "Fruit ESP",
    "Display real-time fruit location",
    Settings.FruitESP,
    function(state)
        Settings.FruitESP = state
    end
)

local Data = {}
local Mem  = {}

local function GetPosition(fruit)
    if not (fruit and fruit.Parent) then return nil end
    local ok, pos = pcall(function()
        if fruit:IsA("Tool") then
            local handle = fruit:FindFirstChild("Handle")
            return handle and handle.Position
        elseif fruit:IsA("Model") then
            local target = fruit.PrimaryPart or fruit:FindFirstChildWhichIsA("BasePart")
            return target and target.Position
        end
    end)
    return ok and pos or nil
end

local function IsHeldByPlayer(obj)
    if not (obj and obj.Parent) then return true end 
    
    local ok, held = pcall(function()
        -- Deteksi kalau buah ada di badan orang
        local ancestor = obj:FindFirstAncestorOfClass("Model")
        if ancestor and Players:GetPlayerFromCharacter(ancestor) then
            return true
        end
        -- Deteksi kalau buah ada di dalam Backpack
        if obj:FindFirstAncestorWhichIsA("Backpack") then
            return true
        end
        return false
    end)
    return ok and held or true
end

-- FIX MUTLAK: Kenali Buah Asli
local function IsFruit(obj)
    if not obj then return false end
    if not (obj:IsA("Tool") or obj:IsA("Model")) then return false end
    
    -- Standar Blox Fruits: Nama buah asli selalu mengandung kata "Fruit" 
    -- (contoh: "Flame Fruit", "Kitsune Fruit", "Fruit ")
    return string.find(string.lower(obj.Name), "fruit") ~= nil
end

local function AddESP(fruit)
    if not (fruit and fruit.Parent) or Data[fruit] then return end
    if IsHeldByPlayer(fruit) then return end 

    pcall(function()
        -- FIX 1: CARI PART FISIK BIAR BISA DITEMPELIN UI ESP (Anti Ghoib)
        local targetPart = nil
        if fruit:IsA("Tool") then
            targetPart = fruit:FindFirstChild("Handle")
        elseif fruit:IsA("Model") then
            targetPart = fruit.PrimaryPart or fruit:FindFirstChildWhichIsA("BasePart")
        end
        
        if not targetPart then return end -- Kalo ga ada fisik, skip

        local bb = Instance.new("BillboardGui")
        bb.Name         = "CatESP"
        bb.Size         = UDim2.new(0, 150, 0, 20)
        bb.AlwaysOnTop  = true
        bb.StudsOffset  = Vector3.new(0, 3, 0)
        bb.Adornee      = targetPart -- INI DIA KUNCI BIAR TULISAN MUNCUL!
        bb.Parent       = targetPart
        bb.Enabled      = false

        local txt = Instance.new("TextLabel", bb)
        txt.Size                  = UDim2.new(1, 0, 1, 0)
        txt.Text                  = string.format("%s []", fruit.Name)
        txt.TextSize              = 13
        txt.Font                  = Enum.Font.GothamBold
        txt.TextColor3            = Color3.fromRGB(255, 255, 255)
        txt.TextXAlignment        = Enum.TextXAlignment.Left
        txt.BackgroundTransparency= 1
        txt.TextStrokeTransparency= 0.3
        txt.TextStrokeColor3      = Color3.fromRGB(0, 0, 0)

        Data[fruit] = { bb = bb, txt = txt }
        Mem[fruit] = -1
    end)
end

local function RemoveESP(fruit)
    if Data[fruit] then
        pcall(function()
            if Data[fruit].bb then Data[fruit].bb:Destroy() end
        end)
        Data[fruit] = nil
        Mem[fruit] = nil
    end
end

_G.Cat.ESP = {
    Data = Data,
    Pos  = GetPosition,
    IsHeldByPlayer = IsHeldByPlayer,
    
    GetNearestFruit = function()
        local closest = nil
        local minDist = math.huge
        local char    = Me.Character
        local hrp     = char and char:FindFirstChild("HumanoidRootPart")

        if not hrp then return nil end

        for fruit, _ in pairs(Data) do
            if fruit and fruit.Parent and not IsHeldByPlayer(fruit) then
                local p = GetPosition(fruit)
                if p then
                    local d = (p - hrp.Position).Magnitude
                    if d < minDist then
                        closest = fruit
                        minDist = d
                    end
                end
            else
                RemoveESP(fruit)
            end
        end
        return closest
    end
}

task.spawn(function()
    while task.wait(0.1) do
        if not Settings.FruitESP then continue end

        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local myPos = hrp.Position

        for fruit, entry in pairs(Data) do
            if not fruit or not fruit.Parent or IsHeldByPlayer(fruit) then
                RemoveESP(fruit)
                continue
            end

            local fruitPos = GetPosition(fruit)
            if fruitPos then
                local dist = math.floor((fruitPos - myPos).Magnitude)
                local lastDist = Mem[fruit] or -1
                
                if math.abs(dist - lastDist) > 3 then
                    Mem[fruit] = dist
                    entry.txt.Text = string.format("%s [%dm]", fruit.Name, dist)
                end
                entry.bb.Enabled = true
            else
                entry.bb.Enabled = false
            end
        end
    end
end)

-- FIX 2: PANTAU SELURUH PELOSOK MAP (Anti Buta kalo lu AFK 20 Menit)
Workspace.DescendantAdded:Connect(function(obj)
    -- Filter ringan biar ga ngelag pas nunggu
    if obj:IsA("Tool") or obj:IsA("Model") then
        task.delay(0.5, function()
            if IsFruit(obj) and not Data[obj] and not IsHeldByPlayer(obj) then
                AddESP(obj)
            end
        end)
    end
end)

-- Initial Scan pas baru masuk server
task.spawn(function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") or obj:IsA("Model") then
            if IsFruit(obj) and not Data[obj] and not IsHeldByPlayer(obj) then
                AddESP(obj)
            end
        end
    end
end)