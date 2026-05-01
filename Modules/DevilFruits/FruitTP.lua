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

ProxyPart.CFrame = CFrame.new(0, -1000, 0)

-- // State Variables
local TWEEN_SPEED   = 300
local noclipConn    = nil
local isTweening    = false
local currentTarget = nil
local currentTween  = nil
local originalCollisions = {} 

-- ==========================================
-- 3. CONTROL FUNCTIONS
-- ==========================================
local function StopTween()
    if not isTweening then return end

    isTweening    = false
    currentTarget = nil

    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end

    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end

    if ProxyPart then
        ProxyPart.CFrame = CFrame.new(0, -1000, 0)
    end

    local char = Me.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChild("Humanoid")

    if hrp then
        hrp.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        hrp.Anchored = true
        task.wait(0.05)
        hrp.Anchored = false

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
    
    for part, state in pairs(originalCollisions) do
        if part and part.Parent then
            part.CanCollide = state
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

        if not State.IsGameReady or not isActive then
            StopTween()
            continue
        end

        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local fruit = ESP.GetNearestFruit()
        if not fruit then
            StopTween()
            continue
        end

        -- FILTER CERDAS: Jangan kejar buah yang lagi dipegang player lain!
        local isHeldByOther = false
        if fruit:IsA("Tool") then
            isHeldByOther = true
        else
            local ancestorChar = fruit:FindFirstAncestorOfClass("Model")
            if ancestorChar and Players:GetPlayerFromCharacter(ancestorChar) then
                isHeldByOther = true
            end
        end

        if isHeldByOther then
            StopTween() -- Berhenti kalau sempat nyasar kejar buah orang
            continue    -- Lanjut loop, jangan di-tween
        end

        local fPos = ESP.Pos(fruit)
        if not fPos then
            StopTween()
            continue
        end

        local dist   = (fPos - hrp.Position).Magnitude
        local endPos = fPos + Vector3.new(0, 2, 0)

        if Settings.InstantTPFruit then
            StopTween()
            if dist > 5 then
                hrp.CFrame = CFrame.new(endPos)
            end

        elseif Settings.TweenFruit then
            if dist < 1 then
                StopTween()
            else
                local needsStart = currentTarget ~= fruit
                if needsStart or not isTweening then
                    StopTween()

                    currentTarget = fruit
                    isTweening    = true

                    ProxyPart.CFrame = hrp.CFrame

                    table.clear(originalCollisions)
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            originalCollisions[part] = part.CanCollide
                        end
                    end

                    noclipConn = RunService.Stepped:Connect(function()
                        if not isTweening then return end

                        for part, _ in pairs(originalCollisions) do
                            if part.CanCollide then
                                part.CanCollide = false
                            end
                        end

                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.CFrame = ProxyPart.CFrame
                    end)

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