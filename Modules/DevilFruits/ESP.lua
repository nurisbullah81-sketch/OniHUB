-- [[ ==========================================
--      MODULE: DEVIL FRUIT ESP (ULTIMATE FIX)
--    ========================================== ]]

local Workspace   = game:GetService("Workspace")
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")

local Me = Players.LocalPlayer

-- // Framework Initialization
repeat
    task.wait(0.1)
until _G.Cat and _G.Cat.UI and _G.Cat.Settings and _G.Cat.State

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
    "Display real-time fruit location",
    Settings.FruitESP,
    function(state)
        Settings.FruitESP = state
    end
)

-- ==========================================
-- 2. INTERNAL UTILITIES
-- ==========================================
local Data = {}
local Mem  = {}

local function GetPosition(fruit)
    if not fruit then return nil end
    local ok, pos = pcall(function()
        if fruit:IsA("Tool") then
            local handle = fruit:FindFirstChild("Handle")
            return handle and handle.Position
        elseif fruit:IsA("Model") then
            local target = fruit.PrimaryPart or fruit:FindFirstChildWhichIsA("BasePart", true)
            return target and target.Position
        end
    end)
    return ok and pos or nil
end

-- // FIX MUTLAK: ANTI GHOST FRUIT & NPC
local function IsFruit(obj)
    if not obj then return false end
    
    -- Wajib berwujud Tool (buah yang jatuh) atau Model
    if not (obj:IsA("Tool") or obj:IsA("Model")) then return false end

    -- Coret keras kalo punya nyawa (NPC)
    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
        return false 
    end

    local lowerName = string.lower(obj.Name)

    -- Blacklist nama abang-abang NPC
    local isNPC = string.find(lowerName, "dealer") 
               or string.find(lowerName, "gacha") 
               or string.find(lowerName, "cousin")
               or string.find(lowerName, "remover")
               or string.find(lowerName, "merchant")
               or string.find(lowerName, "npc")
    if isNPC then return false end

    -- Wajib ada kata "fruit" di namanya
    if string.find(lowerName, "fruit") == nil then return false end

    -- ==========================================
    -- FILTER PAMUNGKAS (ANTI GHOST FRUIT)
    -- Objek WAJIB punya part fisik, kalo kaga ada buang!
    -- ==========================================
    local hasPhysics = false
    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
        hasPhysics = true
    elseif obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)) then
        hasPhysics = true
    end

    return hasPhysics
end

-- // FIX 2: DETEKSI BUAH DI PEGANG ORANG
local function IsHeldByPlayer(obj)
    if not (obj and obj.Parent) then return true end 
    
    local ok, isHeld = pcall(function()
        local parent = obj.Parent
        -- Kalau di dalem tas (Backpack) atau di dalem karakter orang (Model)
        if parent:IsA("Backpack") then return true end
        if parent:IsA("Model") and Players:GetPlayerFromCharacter(parent) then return true end
        return false
    end)
    
    if not ok then return true end
    return isHeld
end

-- ==========================================
-- 3. ESP MANAGEMENT ENGINE
-- ==========================================
local function AddESP(fruit)
    if not fruit or Data[fruit] then return end

    pcall(function()
        local targetPart = nil
        if fruit:IsA("Tool") then
            targetPart = fruit:FindFirstChild("Handle")
        elseif fruit:IsA("Model") then
            targetPart = fruit.PrimaryPart or fruit:FindFirstChildWhichIsA("BasePart", true)
        end

        if not targetPart then return end

        local bb = Instance.new("BillboardGui")
        bb.Name         = "CatESP"
        bb.Size         = UDim2.new(0, 150, 0, 20)
        bb.AlwaysOnTop  = true
        bb.StudsOffset  = Vector3.new(0, 3, 0)
        bb.Adornee      = targetPart 
        bb.Parent       = targetPart
        bb.Enabled      = false

        local txt = Instance.new("TextLabel", bb)
        txt.Size                  = UDim2.new(1, 0, 1, 0)
        txt.Text                  = string.format("%s []", fruit.Name)
        txt.TextSize              = 13
        txt.Font                  = Enum.Font.GothamBold
        txt.TextColor3            = Color3.fromRGB(255, 255, 255)
        txt.TextXAlignment        = Enum.TextXAlignment.Left
        txt.BackgroundTransparency = 1
        txt.TextStrokeTransparency = 0.3
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

-- ==========================================
-- 4. EXPORTED API
-- ==========================================
_G.Cat.ESP = {
    Data = Data,
    Pos  = GetPosition,
    IsHeldByPlayer = IsHeldByPlayer, -- Kita export ini biar Status & AutoHop bisa pake

    -- FIX 3: MESIN TP CUMA NYARI BUAH DI TANAH
    GetNearestFruit = function()
        local closest = nil
        local minDist = math.huge
        local char    = Me.Character
        local hrp     = char and char:FindFirstChild("HumanoidRootPart")

        if not hrp then return nil end

        for fruit, _ in pairs(Data) do
            if fruit and fruit:IsDescendantOf(Workspace) then
                -- SARINGAN MUTLAK: Kalo dipegang orang, lewatin! Jangan di-TP-in!
                if not IsHeldByPlayer(fruit) then
                    local p = GetPosition(fruit)
                    if p then
                        local d = (p - hrp.Position).Magnitude
                        if d < minDist then
                            closest = fruit
                            minDist = d
                        end
                    end
                end
            else
                RemoveESP(fruit)
            end
        end

        return closest
    end
}

-- ==========================================
-- 5. REAL-TIME RENDERER (VISUAL ESP)
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        if not Settings.FruitESP then continue end

        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local myPos = hrp.Position

        for fruit, entry in pairs(Data) do
            if not fruit or not fruit:IsDescendantOf(Workspace) then
                RemoveESP(fruit)
                continue
            end

            local fruitPos = GetPosition(fruit)
            if fruitPos then
                local dist = math.floor((fruitPos - myPos).Magnitude)
                
                -- Ganti warna kalau dipegang orang biar lu gampang bedainnya
                if IsHeldByPlayer(fruit) then
                    entry.txt.TextColor3 = Color3.fromRGB(255, 100, 100) -- Merah (Punya Orang)
                else
                    entry.txt.TextColor3 = Color3.fromRGB(255, 255, 255) -- Putih (Nganggur)
                end

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

-- ==========================================
-- 6. WORKSPACE MONITORING & SCAN
-- ==========================================
Workspace.DescendantAdded:Connect(function(obj)
    task.delay(0.5, function()
        if IsFruit(obj) and not Data[obj] then AddESP(obj) end
    end)
end)

Workspace.DescendantRemoving:Connect(function(obj)
    if Data[obj] then RemoveESP(obj) end
end)

for _, obj in ipairs(Workspace:GetDescendants()) do
    if IsFruit(obj) and not Data[obj] then AddESP(obj) end
end