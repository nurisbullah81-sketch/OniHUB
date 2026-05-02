-- [[ ==========================================
--      MODULE: DEVIL FRUIT ESP (ULTIMATE NO-GHOST)
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

-- FIX 1: Cari koordinat dari part APAPUN (kaga usah nyari nama "Handle")
local function GetPosition(fruit)
    if not fruit then return nil end
    local ok, pos = pcall(function()
        -- Cari BasePart apapun di dalem tool/model itu
        local target = fruit:FindFirstChildWhichIsA("BasePart", true)
        return target and target.Position
    end)
    return ok and pos or nil
end

local function IsFruit(obj)
    -- TAMENG 1: HANYA YANG BENER-BENER TOOL
    -- Ini bakal langsung nolak Model Gacha, Model NPC, Model Kosong "Fruits"
    if not obj:IsA("Tool") then 
        return false 
    end

    -- TAMENG 2: WAJIB PUNYA FISIK HANDLE
    -- Tool valid di Roblox WAJIB punya Handle. Kalau kaga ada, berarti mayat.
    if not obj:FindFirstChild("Handle") then 
        return false 
    end

    -- TAMENG 3: PASTIKAN NAMANYA BUAH
    local lowerName = string.lower(obj.Name)
    if not string.find(lowerName, "fruit") then 
        return false 
    end

    -- TAMENG 4: JANGAN DETEKSI BUAH YANG UDAH MASUK TAS (BACKPACK)
    if obj:FindFirstAncestorOfClass("Backpack") then 
        return false 
    end

    return true
end

-- ==========================================
-- 3. ESP MANAGEMENT ENGINE
-- ==========================================
local function AddESP(fruit)
    if not fruit or Data[fruit] then return end

    pcall(function()
        -- FIX 3: Nempelin UI ke part APAPUN yang ada fisiknya
        local targetPart = fruit:FindFirstChildWhichIsA("BasePart", true)
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

        GetNearestFruit = function()
        local closest = nil
        local minDist = math.huge
        local char    = Me.Character
        local hrp     = char and char:FindFirstChild("HumanoidRootPart")

        if not hrp then return nil end

        for fruit, _ in pairs(Data) do
            -- SISTEM DETOX MAYAT: Kalau ternyata Handle-nya ilang, hapus paksa dari memori!
            if not fruit or not fruit.Parent or not fruit:FindFirstChild("Handle") then
                RemoveESP(fruit)
                continue
            end

            -- FILTER GROUND ONLY: Hanya ambil buah yang Parent-nya LANGSUNG Workspace.
            -- Ini yang bikin lu kaga nge-Tween ke NPC atau buah yang lagi dipegang orang.
            if fruit.Parent ~= Workspace then
                continue
            end

            local p = GetPosition(fruit)
            if p then
                local d = (p - hrp.Position).Magnitude
                if d < minDist then
                    closest = fruit
                    minDist = d
                end
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
            -- DETOX REALTIME: Kalau mayat, bersihkan dari UI juga
            if not fruit or not fruit.Parent or not fruit:FindFirstChild("Handle") then
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

-- ==========================================
-- 7. SAFETY SCANNER (DROP WRAPPER FIX)
-- ==========================================
-- Ngecek setiap 3 detik kalau ada buah yang terjebak di dalam Model hasil drop sistem/pemain
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            -- Cek semua anak langsung di Workspace
            for _, potentialWrapper in ipairs(Workspace:GetChildren()) do
                -- Skip kalau bukan Model, atau kalau itu ProxyPart milik kita, atau kalau dia udah ada di Data
                if potentialWrapper:IsA("Model") and potentialWrapper.Name ~= "CatHub_Proxy" and not Data[potentialWrapper] then
                    -- Kalau Model ini punya anak yang bernama mengandung "Fruit" dan itu Tool
                    for _, child in ipairs(potentialWrapper:GetChildren()) do
                        if child:IsA("Tool") and not Data[child] then
                            -- Paksa masuk ke filter utama
                            if IsFruit(child) then
                                AddESP(child)
                            end
                        end
                    end
                end
                
                -- Fallback langsung: Kalau ada Tool yang ke-drop langsung ke Workspace tanpa Model
                if potentialWrapper:IsA("Tool") and not Data[potentialWrapper] then
                    if IsFruit(potentialWrapper) then
                        AddESP(potentialWrapper)
                    end
                end
            end
        end)
    end
end)