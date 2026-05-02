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
    -- Hanya terima Tool (Tolak Model NPC/Gacha)
    if not obj:IsA("Tool") then return false end
    
    -- Harus punya fisik Handle
    if not obj:FindFirstChild("Handle") then return false end
    
    -- Harus ada kata "fruit" di namanya
    local lowerName = string.lower(obj.Name)
    if not string.find(lowerName, "fruit") then return false end
    
    -- Jangan deteksi kalau masuk Backpack
    if obj:FindFirstAncestorOfClass("Backpack") then return false end
    
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
            -- DETOX MAYAT: Kalau Handle-nya ilang, hapus paksa dari memori!
            if not fruit or not fruit.Parent or not fruit:FindFirstChild("Handle") then
                RemoveESP(fruit)
                continue
            end

            -- FILTER GROUND ONLY: 
            -- 1. Harus masih di Workspace (Bisa langsung, atau di dalam Model Wrapper Gacha)
            -- 2. TAPI TOLAK kalau dia lagi dipegang pemain (Model yang punya Humanoid)
            if not fruit:IsDescendantOf(workspace) then continue end
            
            local ancestorModel = fruit:FindFirstAncestorOfClass("Model")
            if ancestorModel and ancestorModel:FindFirstChildOfClass("Humanoid") then
                continue -- Ini buah yang lagi dipegang orang, skip
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

-- Fast Reject: Langsung tolak kalau objek bukan Tool biar kaga makan resource
Workspace.DescendantAdded:Connect(function(obj)
    if not obj:IsA("Tool") then return end
    
    task.delay(0.5, function()
        pcall(function()
            -- Cek lagi apakah dia masih valid setelah 0.5 detik
            if not obj:IsA("Tool") or not obj.Parent then return end
            
            -- Sihir Anti-Gacha Lag: Tunggu Handle muncul maksimal 2 detik.
            -- Ini yang bikin buah drop Gacha yang lambat loading bisa kebaca!
            local handle = obj:WaitForChild("Handle", 2)
            if not handle then return end 
            
            local lowerName = string.lower(obj.Name)
            if not string.find(lowerName, "fruit") then return end
            
            if obj:FindFirstAncestorOfClass("Backpack") then return end
            
            if not Data[obj] then
                AddESP(obj)
            end
        end)
    end)
end)

Workspace.DescendantRemoving:Connect(function(obj)
    if Data[obj] then RemoveESP(obj) end
end)

-- Scan awal pas script baru jalan
for _, obj in ipairs(Workspace:GetDescendants()) do
    if IsFruit(obj) and not Data[obj] then AddESP(obj) end
end