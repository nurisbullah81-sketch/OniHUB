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

    -- Restore Collision (KRITIS: HRP & Accessory Handle HARUS false agar tidak mentok halusinasi)
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name == "HumanoidRootPart" or part.Parent:IsA("Accessory") then
                    part.CanCollide = false -- Ini rahasianya biar lu bisa lewat pintu
                else
                    part.CanCollide = true -- Ini biar lu nggak jatuh tembus lantai pas main normal
                end
            end
        end
    end
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
        if not hrp then continue end

        -- Cari target buah terdekat
        local fruit = ESP.GetNearestFruit()
        if not fruit then
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
        local endPos = fPos + Vector3.new(0, 2, 0)

        -- // Mode: Instant Teleport
        if Settings.InstantTPFruit then
            StopTween()
            if dist > 5 then
                hrp.CFrame = CFrame.new(endPos)
            end

        -- // Mode: Smooth Tween
        elseif Settings.TweenFruit then
            if dist < 5 then
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

                    -- Noclip & Sync Loop (KRITIS: GetDescendants biar aksesoris/sayap juga tembus)
                    noclipConn = RunService.Stepped:Connect(function()
                        if not isTweening then return end

                        -- Matikan collision karakter sampai ke aksesoris
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end

                        -- Kunci physics & ikuti proxy
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.CFrame = ProxyPart.CFrame
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