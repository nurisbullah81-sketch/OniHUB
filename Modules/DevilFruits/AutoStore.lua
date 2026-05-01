-- [[ ==========================================
--      MODULE: DEVIL FRUITS - AUTO STORE
--    ========================================== ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local Me = Players.LocalPlayer

-- Tunggu Global Framework
repeat
    task.wait(0.1)
until _G.Cat and _G.Cat.UI and _G.Cat.Settings and _G.Cat.State

local UI         = _G.Cat.UI
local Settings   = _G.Cat.Settings
local State      = _G.Cat.State
local SafeInvoke = _G.Cat.SafeInvoke

-- Default Fallback
if type(Settings.AutoStoreFruit) ~= "boolean" then
    Settings.AutoStoreFruit = false
end

-- ==========================================
-- 1. UI SETUP
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)
UI.CreateSection(Page, "INVENTORY MANAGEMENT")

UI.CreateToggle(
    Page,
    "Auto Store Fruits",
    "Otomatis simpan buah ke tas (0% Lag)",
    Settings.AutoStoreFruit,
    function(state)
        Settings.AutoStoreFruit = state
    end
)

-- ==========================================
-- 2. LOGIC ENGINE
-- ==========================================
local StoreBlacklist = {}
local isStoring      = false

local function AttemptStore(fruitTool)
    -- Cek kondisi dasar
    local condition1 = isStoring
    local condition2 = not Settings.AutoStoreFruit
    local condition3 = not State.IsGameReady

    if condition1 or condition2 or condition3 then
        return
    end

    -- Skip kalo udah di blacklist
    if table.find(StoreBlacklist, fruitTool.Name) then
        return
    end

    isStoring = true

    task.spawn(function()
        pcall(function()
            local fruitName = fruitTool.Name
            local fruitVal  = fruitTool:FindFirstChild("Fruit")

            -- Ambil nama buah yang bener
            if fruitVal and fruitVal:IsA("StringValue") and fruitVal.Value ~= "" then
                fruitName = fruitVal.Value
            else
                local rawName = string.gsub(fruitTool.Name, " Fruit", "")
                fruitName     = string.format("%s-%s", rawName, rawName)
            end

            local storeSuccess = false
            local remoteParent = ReplicatedStorage:FindFirstChild("Remotes")
            local storeRemote  = remoteParent and remoteParent:FindFirstChild("CommF_")

            if storeRemote then
                -- Coba simpen 3 kali
                for attempt = 1, 3 do
                    if storeSuccess then break end

                    local ok, result = SafeInvoke(
                        storeRemote,
                        "StoreFruit",
                        fruitName,
                        fruitTool
                    )

                    if ok and result == true then
                        storeSuccess = true
                        warn("[CatHUB] Saved: " .. fruitName)
                    else
                        task.wait(0.5)
                    end
                end
            end

            -- Blacklist kalo gagal
            if not storeSuccess then
                table.insert(StoreBlacklist, fruitTool.Name)
            end
        end)

        isStoring = false
    end)
end

-- // Deteksi Tool (Event-Driven)
local function CheckTool(item)
    local isTool = item:IsA("Tool")
    local isValid = typeof(item.Name) == "string"
    local isFruit = string.match(item.Name, "Fruit$")

    if isTool and isValid and isFruit then
        -- Jeda kecil biar tool ke-render
        task.delay(0.2, function()
            AttemptStore(item)
        end)
    end
end

-- // CCTV PINTAR (ANTI-MAMPUS PAS RESPAWN)
Me.CharacterAdded:Connect(function(char)
    -- 1. Pasang ulang CCTV ke tangan karakter baru
    char.ChildAdded:Connect(CheckTool)
    
    -- 2. Pasang ulang CCTV ke tas baru (KARENA TAS LAMA KEHAPUS PAS MATI!)
    local newBackpack = Me:WaitForChild("Backpack", 5)
    if newBackpack then
        newBackpack.ChildAdded:Connect(CheckTool)
    end
end)

-- // Pasang CCTV untuk tas & karakter yang sedang aktif saat script baru di-execute
if Me.Backpack then
    Me.Backpack.ChildAdded:Connect(CheckTool)
end
if Me.Character then
    Me.Character.ChildAdded:Connect(CheckTool)
end

-- Scan Awal (1x jalankan)
task.spawn(function()
    if Me.Backpack then
        for _, item in ipairs(Me.Backpack:GetChildren()) do
            CheckTool(item)
        end
    end

    if Me.Character then
        for _, item in ipairs(Me.Character:GetChildren()) do
            CheckTool(item)
        end
    end
end)