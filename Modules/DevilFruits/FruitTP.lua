-- [[ ==========================================
--      MODULE: DEVIL FRUIT TELEPORTATION (CLEAN PROXY)
--    ========================================== ]]

local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")

local Me = Players.LocalPlayer

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings and _G.Cat.State and _G.Cat.ESP

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State
local ESP      = _G.Cat.ESP

if type(Settings.TweenFruit) ~= "boolean" then Settings.TweenFruit = false end
if type(Settings.InstantTPFruit) ~= "boolean" then Settings.InstantTPFruit = false end

local Page = UI.CreateTab("Devil Fruits", false)
UI.CreateSection(Page, "MOVEMENT SYSTEM")

UI.CreateToggle(Page, "Tween to Fruits", "Smooth fly", Settings.TweenFruit, function(state) Settings.TweenFruit = state end)
UI.CreateToggle(Page, "TP Fruits", "Instant teleport", Settings.InstantTPFruit, function(state) Settings.InstantTPFruit = state end)

-- ==========================================
-- SETUP PROXY (PART PENIPU)
-- ==========================================
local ProxyPart = workspace:FindFirstChild("CatHub_Proxy")
if not ProxyPart then
    ProxyPart = Instance.new("Part")
    ProxyPart.Name = "CatHub_Proxy"
    ProxyPart.Transparency = 1
    ProxyPart.Anchored = true
    ProxyPart.CanCollide = false -- Pastiin false
    ProxyPart.Massless = true -- Biar ga ganggu physics
    ProxyPart.Size = Vector3.new(1, 1, 1)
    ProxyPart.Parent = workspace
end
-- Langsung buang jauh pas awal
ProxyPart.CFrame = CFrame.new(0, -1000, 0)

local TWEEN_SPEED = 300 
local noclipConn = nil
local isTweening = false
local currentTarget = nil
local currentTween = nil

local function StopTween()
    if not isTweening then return end
    isTweening = false
    currentTarget = nil
    
    if currentTween then currentTween:Cancel(); currentTween = nil end
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    
    -- FIX 1: BUANG PROXYPART JAUH-JAUH (Biarkan dia di penjara)
    if ProxyPart then ProxyPart.CFrame = CFrame.new(0, -1000, 0) end
    
    -- FIX 2: RESET PHYSICS PLAYER
    local char = Me.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        
        -- Trik "Sticky" biar nggak gerak sendiri
        hrp.Anchored = true
        task.wait(0.05)
        hrp.Anchored = false
        
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
    
    -- FIX 3: Balikin Collision
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

State.StopSmartTween = StopTween

-- ==========================================
-- LOOP UTAMA
-- ==========================================
task.spawn(function()
    while task.wait(0.2) do
        if not State.IsGameReady or (not Settings.TweenFruit and not Settings.InstantTPFruit) then 
            StopTween()
            continue 
        end
        
        local char = Me.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local fruit = ESP.GetNearestFruit()
        if not fruit then StopTween(); continue end
        
        local fPos = ESP.Pos(fruit)
        if not fPos then StopTween(); continue end
        
        local dist = (fPos - hrp.Position).Magnitude
        local endPos = fPos + Vector3.new(0, 2, 0)
        
        -- INSTANT
        if Settings.InstantTPFruit then
            StopTween()
            if dist > 5 then
                hrp.CFrame = CFrame.new(endPos)
            end
        
        -- TWEEN
        elseif Settings.TweenFruit then
            if dist < 5 then
                StopTween()
            else
                if currentTarget ~= fruit or not isTweening then
                    StopTween()
                    
                    currentTarget = fruit
                    isTweening = true
                    
                    -- Set Proxy posisi ke player
                    ProxyPart.CFrame = hrp.CFrame
                    
                    -- NoClip Loop
                    noclipConn = RunService.Stepped:Connect(function()
                        if not isTweening then return end
                        for _, part in pairs(char:GetChildren()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                        hrp.CFrame = ProxyPart.CFrame
                    end)
                    
                    -- Play Tween
                    local tInfo = TweenInfo.new(dist / TWEEN_SPEED, Enum.EasingStyle.Linear)
                    currentTween = TweenService:Create(ProxyPart, tInfo, {CFrame = CFrame.new(endPos)})
                    currentTween:Play()
                end
            end
        end
    end
end)