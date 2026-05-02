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

-- Toggle: Visual Indicator
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
-- Cache untuk menyimpan objek ESP dan data jarak
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
            -- Prioritaskan PrimaryPart
            if fruit.PrimaryPart then
                return fruit.PrimaryPart.Position
            end

            -- Fallback ke BasePart lain
            local alt = fruit:FindFirstChild("HumanoidRootPart")
                or fruit:FindFirstChildWhichIsA("BasePart")

            return alt and alt.Position
        end
    end)

    return ok and pos or nil
end

-- Fungsi: Validasi apakah objek adalah Buah
local function IsFruit(obj)
    if not (obj and obj.Parent) then return false end
    if not (obj:IsA("Tool") or obj:IsA("Model")) then return false end

    -- Deteksi berdasarkan atribut atau child "Fruit"
    return obj:FindFirstChild("Fruit") ~= nil
end

-- ==========================================
-- 3. ESP MANAGEMENT ENGINE
-- ==========================================

-- Membuat BillboardGui dan menempelkannya ke target
local function AddESP(fruit)
    if not (fruit and fruit.Parent) or Data[fruit] then return end

    pcall(function()
        local bb = Instance.new("BillboardGui", fruit)
        bb.Name         = "CatESP"
        bb.Size         = UDim2.new(0, 150, 0, 20)
        bb.AlwaysOnTop  = true
        bb.StudsOffset  = Vector3.new(0, 3, 0)
        bb.Enabled      = false

        -- Konfigurasi Visual Text
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

        -- Register ke Cache
        Data[fruit] = { bb = bb, txt = txt }
        Mem[fruit] = -1
    end)
end

-- Membersihkan objek ESP dari memori dan tampilan
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
-- API publik untuk modul lain (AutoFarm/Teleport)
_G.Cat.ESP = {
    Data = Data,
    Pos  = GetPosition,

    -- Fungsi: Cari buah terdekat dari pemain
    GetNearestFruit = function()
        local closest = nil
        local minDist = math.huge
        local char    = Me.Character
        local hrp     = char and char:FindFirstChild("HumanoidRootPart")

        if not hrp then return nil end

        for fruit, _ in pairs(Data) do
            -- Validasi objek masih ada di Workspace
            if fruit and fruit.Parent == Workspace then
                local p = GetPosition(fruit)

                if p then
                    local d = (p - hrp.Position).Magnitude
                    if d < minDist then
                        closest = fruit
                        minDist = d
                    end
                end
            else
                -- Auto-cleanup jika objek hilang
                RemoveESP(fruit)
            end
        end

        return closest
    end
}

-- ==========================================
-- 5. REAL-TIME RENDERER
-- ==========================================
-- Loop terpisah untuk update jarak (Optimasi: Rate limited)
task.spawn(function()
    while task.wait(0.1) do
        if not Settings.FruitESP then continue end

        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local myPos = hrp.Position

        for fruit, entry in pairs(Data) do
            -- Validasi objek
            if not fruit or not fruit.Parent then
                RemoveESP(fruit)
                continue
            end

            local fruitPos = GetPosition(fruit)
            if fruitPos then
                local dist = math.floor((fruitPos - myPos).Magnitude)

                -- Update text hanya jika jarak berubah signifikan
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
-- Deteksi objek baru masuk ke Workspace
Workspace.ChildAdded:Connect(function(obj)
    local isValidType = obj:IsA("Model") or obj:IsA("Tool")
    if not isValidType then return end

    -- Jeda rendering biar objek ke-load penuh
    task.delay(0.5, function()
        if IsFruit(obj) and not Data[obj] then
            AddESP(obj)
        end
    end)
end)

-- Deteksi objek hilang dari Workspace
Workspace.ChildRemoved:Connect(function(obj)
    if Data[obj] then
        RemoveESP(obj)
    end
end)

-- ==========================================
-- 7. INITIAL SCAN
-- ==========================================
-- Scan seluruh workspace saat script dimuat
for _, obj in ipairs(Workspace:GetDescendants()) do
    if IsFruit(obj) and not Data[obj] then
        AddESP(obj)
    end
end
