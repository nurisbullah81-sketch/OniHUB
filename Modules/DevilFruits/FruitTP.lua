-- [[ ==========================================
--      MODULE: DEVIL FRUIT TELEPORTATION
--    ========================================== ]]

local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")

local Me = Players.LocalPlayer

-- // Framework Initialization
repeat
    task.wait(0.1)
until _G.Cat
    and _G.Cat.UI
    and _G.Cat.Settings
    and _G.Cat.State
    and _G.Cat.ESP

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State
local ESP      = _G.Cat.ESP

-- // Configuration Defaults
if type(Settings.TweenFruit) ~= "boolean" then
    Settings.TweenFruit = false
end

if type(Settings.InstantTPFruit) ~= "boolean" then
    Settings.InstantTPFruit = false
end

-- ==========================================
-- 1. UI SETUP
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)
UI.CreateSection(Page, "MOVEMENT SYSTEM")

UI.CreateToggle(
    Page,
    "Tween to Fruits",
    "Smooth fly movement",
    Settings.TweenFruit,
    function(state)
        Settings.TweenFruit = state
    end
)

UI.CreateToggle(
    Page,
    "TP Fruits",
    "Instant teleport to target",
    Settings.InstantTPFruit,
    function(state)
        Settings.InstantTPFruit = state
    end
)

-- ==========================================
-- 2. PROXY SYSTEM SETUP
-- ==========================================
-- Part virtual untuk memanipulasi physics tanpa bug
local ProxyPart = workspace:FindFirstChild("CatHub_Proxy")
if not ProxyPart then
    ProxyPart = Instance.new("Part")
    ProxyPart.Name         = "CatHub_Proxy"
    ProxyPart.Transparency = 1
    ProxyPart.Anchored     = true
    ProxyPart.CanCollide   = false
    ProxyPart.Massless     = true
    ProxyPart.Size         = Vector3.new(1, 1, 1)
    ProxyPart.Parent       = workspace
end

-- Isolasi proxy part jauh dari map saat idle
ProxyPart.CFrame = CFrame.new(0, -1000, 0)

-- // State Variables
local TWEEN_SPEED   = 300
local noclipConn    = nil
local isTweening    = false
local currentTarget = nil
local currentTween  = nil

-- Wadah buat nyimpen ingatan physics asli
local originalCollisions = {} 

-- ==========================================
-- 3. CONTROL FUNCTIONS
-- ==========================================
local function StopTween()
    if not isTweening then return end

    isTweening    = false
    currentTarget = nil

    -- Hentikan tween aktif
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end

    -- Putuskan koneksi noclip
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end

    -- Reset Proxy Position (Penjara Virtual)
    if ProxyPart then
        ProxyPart.CFrame = CFrame.new(0, -1000, 0)
    end

    -- Player Physics Reset
    local char = Me.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChild("Humanoid")

    if hrp then
        -- Hentikan momentum
        hrp.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        -- Reset anchor state untuk mencegah sliding
        hrp.Anchored = true
        task.wait(0.05)
        hrp.Anchored = false

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
    
    -- 🚨 FIX: Restore Collision dengan Pengaman Memori 🚨
    -- Mencegah error kalau karakter lu udah ke-destroy duluan pas lu mati
    for part, state in pairs(originalCollisions) do
        if part and part.Parent and part:IsDescendantOf(workspace) then
            pcall(function() part.CanCollide = state end)
        end
    end
    table.clear(originalCollisions)
end

State.StopSmartTween = StopTween

-- ==========================================
-- 4. MAIN EXECUTION LOOP
-- ==========================================
task.spawn(function()
    while task.wait(0.2) do
        local isActive = Settings.TweenFruit or Settings.InstantTPFruit

        -- Skip jika tidak aktif atau game belum siap
        if not State.IsGameReady or not isActive then
            StopTween()
            continue
        end

        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChild("Humanoid")
        if not hrp or not hum then continue end

        -- Cari target buah terdekat
        local fruit = ESP.GetNearestFruit()
        if not fruit then
            StopTween()
            continue
        end

        -- 🚨 FIX ANJING NGEJAR EKOR 🚨
        -- Kalo buahnya udah masuk ke tangan lu, tangan orang lain (Character), atau ke dalem tas (Backpack),
        -- JANGAN DI-TWEEN! Biar lu kaga nge-freeze ngejar tangan sendiri!
        local inBackpack = fruit:FindFirstAncestorOfClass("Backpack")
        local inChar = fruit:FindFirstAncestorOfClass("Model")
        if inBackpack or (inChar and inChar:FindFirstChildOfClass("Humanoid")) then
            StopTween()
            continue
        end

        local fPos = ESP.Pos(fruit)
        if not fPos then
            StopTween()
            continue
        end

        -- Kalkulasi jarak dan posisi akhir
        local dist   = (fPos - hrp.Position).Magnitude
        local endPos = fPos -- Langsung seruduk badan buahnya, jangan melayang 2 stud

        -- // Mode: Instant Teleport
        if Settings.InstantTPFruit then
            StopTween()
            if dist > 5 then
                hrp.CFrame = CFrame.new(endPos)
            end

        -- // Mode: Smooth Tween
        elseif Settings.TweenFruit then
            if dist < 1 then
                StopTween()
            else
                -- Cek apakah target berubah atau tween belum jalan
                local needsStart = currentTarget ~= fruit
                if needsStart or not isTweening then
                    StopTween()

                    currentTarget = fruit
                    isTweening    = true

                    -- Sinkronkan Proxy ke pemain
                    ProxyPart.CFrame = hrp.CFrame

                    -- Catat semua status asli anggota tubuh sebelum berubah jadi hantu
                    table.clear(originalCollisions)
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part.Name == "HumanoidRootPart" or part.Parent:IsA("Accessory") then
                                originalCollisions[part] = false
                            else
                                originalCollisions[part] = part.CanCollide
                            end
                        end
                    end

                    -- Noclip & Sync Loop
                    noclipConn = RunService.Stepped:Connect(function()
                        if not isTweening then return end

                        -- Matikan collision tubuh kita
                        for part, _ in pairs(originalCollisions) do
                            if part.CanCollide then
                                part.CanCollide = false
                            end
                        end

                        -- 🚨 RAHASIA PREMIUM: MATIKAN FISIKA BUAH TARGET
                        -- Touched-nya tetap nyala, tapi tendangannya ilang 100%
                        if currentTarget then
                            local targetPart = currentTarget:FindFirstChildWhichIsA("BasePart", true)
                            if targetPart and targetPart.CanCollide then
                                targetPart.CanCollide = false
                            end
                        end

                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        char:PivotTo(ProxyPart.CFrame)
                    end)

                    -- Jalankan Tween
                    local timeDur = dist / TWEEN_SPEED
                    local tInfo   = TweenInfo.new(timeDur, Enum.EasingStyle.Linear)
                    local tProps  = { CFrame = CFrame.new(endPos) }

                    currentTween = TweenService:Create(ProxyPart, tInfo, tProps)
                    currentTween:Play()
                end
            end
        end
    end
end)