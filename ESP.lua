-- CatHUB v8.1: Fruit ESP (Pure Logic, Zero Lag)
local Workspace = game:GetService("Workspace")
local Settings = _G.CatHub.Settings
local LocalPlayer = _G.CatHub.Player

local FruitData = {} -- [fruit] = {billboard, text}

-- Cari posisi buah (aman)
local function GetPos(fruit)
    if fruit:IsA("Tool") then
        local h = fruit:FindFirstChild("Handle")
        if h then return h.Position end
    elseif fruit:IsA("Model") then
        local p = fruit.PrimaryPart
        if p then return p.Position end
    end
    return nil
end

-- Buat ESP (HANYA TEKS, TANPA BACKGROUND)
local function Add(fruit)
    if FruitData[fruit] then return end
    
    local bb = Instance.new("BillboardGui", fruit)
    bb.Name = "CatESP"
    bb.Size = UDim2.new(0, 150, 0, 30)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.Enabled = false
    
    -- LANGSUNG 1 TEKST, TANPA FRAME BACKGROUND
    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = fruit.Name -- NAMA ASLI GAME
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.TextStrokeTransparency = 0.3
    txt.TextStrokeColor3 = Color3.new(0, 0, 0)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 13
    
    FruitData[fruit] = {bb = bb, txt = txt}
end

-- Hapus ESP buah yang hilang
local function Clean()
    for fruit, data in pairs(FruitData) do
        if not fruit.Parent then
            data.bb:Destroy()
            FruitData[fruit] = nil
        end
    end
end

-- Cek apakah itu buah
local function IsFruit(obj)
    local name = obj.Name:lower()
    return (obj:IsA("Tool") or obj:IsA("Model")) and name:find("fruit")
end

-- ==========================================
-- SCAN: Event-Based (Bukan Loop GetDescendants)
-- ==========================================

-- 1. Scan awal (sekali saja saat script load)
for _, obj in pairs(Workspace:GetChildren()) do
    if IsFruit(obj) then
        Add(obj)
    end
end

-- 2. Deteksi buah baru yang spawn (ZERO LAG, bukan polling)
Workspace.ChildAdded:Connect(function(obj)
    if IsFruit(obj) then
        Add(obj)
    end
end)

-- 3. Deteksi buah yang diambil/hilang
Workspace.ChildRemoved:Connect(function(obj)
    if FruitData[obj] then
        FruitData[obj].bb:Destroy()
        FruitData[obj] = nil
    end
end)

-- ==========================================
-- UPDATE: 1 Loop Ringan (0.5 detik)
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        -- Langsung skip jika ESP mati
        if not Settings.FruitESP then
            for _, data in pairs(FruitData) do
                data.bb.Enabled = false
            end
            continue
        end
        
        -- Ambil posisi player sekali saja
        local char = LocalPlayer.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local myPos = root.Position
        
        -- Update tiap buah
        for fruit, data in pairs(FruitData) do
            local pos = GetPos(fruit)
            if pos then
                local dist = math.floor((pos - myPos).Magnitude)
                data.txt.Text = fruit.Name .. " [" .. dist .. "m]"
                
                -- Ganti warna berdasarkan jarak
                if dist < 300 then
                    data.txt.TextColor3 = Color3.fromRGB(100, 255, 100) -- Hijau dekat
                elseif dist < 1000 then
                    data.txt.TextColor3 = Color3.fromRGB(255, 255, 100) -- Kuning menengah
                else
                    data.txt.TextColor3 = Color3.fromRGB(255, 130, 100) -- Merah jauh
                end
                
                data.bb.Enabled = true
            else
                data.bb.Enabled = false
            end
        end
        
        -- Bersihkan yang null (jarang terjadi tapi safety)
        Clean()
    end
end)

print("[CatHUB] Fruit ESP Ready (Zero Lag)")