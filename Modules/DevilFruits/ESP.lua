-- [[ ==========================================
--      MODULE: DEVIL FRUIT ESP
--    ========================================== ]]

-- // Services
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

-- Fungsi: Ambil posisi dunia (World Position) dari objek buah
local function GetPosition(fruit)
    if not (fruit and fruit.Parent) then return nil end

    local ok, pos = pcall(function()
        if fruit:IsA("Tool") then
            local handle = fruit:FindFirstChild("Handle")
            return handle and handle.Position
        elseif fruit:IsA("Model") then
            if fruit.PrimaryPart then
                return fruit.PrimaryPart.Position
            end

            local alt = fruit:FindFirstChild("HumanoidRootPart")
                or fruit:FindFirstChildWhichIsA("BasePart")

            return alt and alt.Position
        end
    end)

    return ok and pos or nil
end

-- Fungsi: Validasi apakah objek adalah Buah Asli Blox Fruits
local function IsFruit(obj)
    if not (obj and obj.Parent) then return false end
    
    local isToolOrModel = obj:IsA("Tool") or obj:IsA("Model")
    if not isToolOrModel then return false end

    -- CARA 1: Cek nama objek. Semua buah Blox Fruits namanya mengandung kata "Fruit"
    if string.find(obj.Name, "Fruit") then
        return true
    end

    -- CARA 2: Cek komponen Handle (buat Tool yang drop di tanah)
    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
        return true
    end

    return false
end

-- [[ === FITUR BARU: ANTI BUAH ORANG === ]]
-- Fungsi: Cek apakah buah sedang dipegang/di tas player lain
local function IsHeldByPlayer(obj)
    if not (obj and obj.Parent) then return true end -- Kalo objek hilang, anggap true biar ke-cleanup
    
    local ok, held = pcall(function()
        -- Deteksi kalau buah ada di dalam Character player lain
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

-- ==========================================
-- 3. ESP MANAGEMENT ENGINE
-- ==========================================

local function AddESP(fruit)
    if not (fruit and fruit.Parent) or Data[fruit] then return end
    -- FILTER: Jangan bikin ESP kalau buah dipegang orang
    if IsHeldByPlayer(fruit) then return end 

    pcall(function()
        local bb = Instance.new("BillboardGui", fruit)
        bb.Name         = "CatESP"
        bb.Size         = UDim2.new(0, 150, 0, 20)
        bb.AlwaysOnTop  = true
        bb.StudsOffset  = Vector3.new(0, 3, 0)
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
            if Data[fruit].bb then
                Data[fruit].bb:Destroy()
            end
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
    IsHeldByPlayer = IsHeldByPlayer, -- Export function ini biar Status.lua bisa pakai

    GetNearestFruit = function()
        local closest = nil
        local minDist = math.huge
        local char    = Me.Character
        local hrp     = char and char:FindFirstChild("HumanoidRootPart")

        if not hrp then return nil end

        for fruit, _ in pairs(Data) do
            -- Validasi objek masih ada dan PASTI BUKAN dipegang player lain
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
                -- Auto-cleanup jika objek hilang ATAU dipegang orang
                RemoveESP(fruit)
            end
        end

        return closest
    end
}

-- ==========================================
-- 5. REAL-TIME RENDERER
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        if not Settings.FruitESP then continue end

        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local myPos = hrp.Position

        for fruit, entry in pairs(Data) do
            -- FILTER: Kalau tiba2 dipegang orang, langsang hancurkan ESP-nya
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

-- ==========================================
-- 6. WORKSPACE MONITORING
-- ==========================================
Workspace.ChildAdded:Connect(function(obj)
    local isValidType = obj:IsA("Model") or obj:IsA("Tool")
    if not isValidType then return end

    task.delay(0.5, function()
        -- FILTER: Jangan masukin ke Data kalau dipegang orang
        if IsFruit(obj) and not Data[obj] and not IsHeldByPlayer(obj) then
            AddESP(obj)
        end
    end)
end)

Workspace.ChildRemoved:Connect(function(obj)
    if Data[obj] then
        RemoveESP(obj)
    end
end)

-- ==========================================
-- 7. INITIAL SCAN (OPTIMIZED)
-- ==========================================
-- Jangan pakai GetDescendants() untuk semua isi workspace, bikin ngelag!
-- Cukup scan anak-anak langsung dari workspace.
for _, obj in ipairs(Workspace:GetChildren()) do
    if IsFruit(obj) and not Data[obj] and not IsHeldByPlayer(obj) then
        AddESP(obj)
    end
end