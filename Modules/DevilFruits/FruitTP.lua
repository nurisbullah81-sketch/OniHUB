-- [[ ==========================================
--      MODULE: DEVIL FRUIT TELEPORTATION
--      Status: GC Spike Killer, Permanent Proxy, 0% Lag
--    ========================================== ]]

local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")

local Me = Players.LocalPlayer

-- // Tunggu Core & ESP Siap
repeat 
    task.wait(0.1) 
until _G.Cat and _G.Cat.UI and _G.Cat.Settings and _G.Cat.State and _G.Cat.ESP

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State
local ESP      = _G.Cat.ESP

-- Safety boolean
if type(Settings.TweenFruit) ~= "boolean" then Settings.TweenFruit = false end
if type(Settings.InstantTPFruit) ~= "boolean" then Settings.InstantTPFruit = false end

-- ==========================================
-- 1. UI INITIALIZATION
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)

UI.CreateSection(Page, "MOVEMENT SYSTEM (0% LAG)")

UI.CreateToggle(Page, "Tween to Fruits", "Smoothly fly to collect fruits", Settings.TweenFruit, function(state) 
    Settings.TweenFruit = state 
end)

UI.CreateToggle(Page, "TP Fruits", "Instant teleport to spawned fruits", Settings.InstantTPFruit, function(state) 
    Settings.InstantTPFruit = state 
end)

-- ==========================================
-- 2. LOGIC CONFIGURATION: PERMANENT PROXY & STATE
-- ==========================================
local TWEEN_SPEED = 300 
local currentTarget = nil
local currentTween = nil
local noclipConn = nil
local isTweening = false
local originalCollisions = {}

-- BIKIN PROXY PERMANEN (Biar kaga nyampah memori Destroy/Create!)
local ProxyPart = workspace:FindFirstChild("CatHub_Proxy")
if not ProxyPart then
    ProxyPart = Instance.new("Part")
    ProxyPart.Name = "CatHub_Proxy"
    ProxyPart.Transparency = 1
    ProxyPart.Anchored = true
    ProxyPart.CanCollide = false
    ProxyPart.Size = Vector3.new(1, 1, 1)
    ProxyPart.Parent = workspace
end

local function StopSmartTween()
    if not isTweening then return end
    
    isTweening = false
    currentTarget = nil
    
    if currentTween then 
        currentTween:Cancel()
        currentTween = nil 
    end
    
    if noclipConn then 
        noclipConn:Disconnect() 
        noclipConn = nil 
    end
    
    -- Restore Physics 
    local char = Me.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then 
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero 
        end
        
        -- Balikin collision dari cache
        for part, state in pairs(originalCollisions) do 
            if part and part.Parent then 
                part.CanCollide = state 
            end 
        end
    end
    table.clear(originalCollisions)
end

State.StopSmartTween = StopSmartTween

-- ==========================================
-- 3. SMART MOVEMENT HANDLER
-- ==========================================
task.spawn(function() 
    while task.wait(0.1) do 
        -- 1. Safety Check (Tanpa pcall biar RAM kaga bocor)
        if not State.IsGameReady or (not Settings.TweenFruit and not Settings.InstantTPFruit) then 
            StopSmartTween()
            continue 
        end

        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        -- 2. Tanya ke ESP CCTV (Sangat ringan karena cuma ngecek tabel ActiveFruits)
        local nearest = ESP.GetNearestFruit()
        if not nearest then
            StopSmartTween()
            continue
        end

        local targetPos = ESP.Pos(nearest)
        if not targetPos then
            StopSmartTween()
            continue
        end

        local dist = (targetPos - hrp.Position).Magnitude
        local endPos = targetPos + Vector3.new(0, 2, 0)

        -- 3. INSTANT TELEPORT LOGIC
        if Settings.InstantTPFruit then
            StopSmartTween()
            if dist > 5 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(endPos)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end

        -- 4. SMART TWEEN LOGIC
        elseif Settings.TweenFruit then 
            if dist < 5 then 
                StopSmartTween()
            else
                -- Cuma bikin Tween BARU kalau targetnya beda (Anti-Spam Tween)
                if currentTarget ~= nearest or not isTweening then
                    StopSmartTween() 
                    
                    currentTarget = nearest
                    isTweening = true
                    
                    -- Cache Collision 1x doang
                    table.clear(originalCollisions)
                    for _, part in ipairs(char:GetDescendants()) do 
                        if part:IsA("BasePart") then 
                            originalCollisions[part] = part.CanCollide 
                        end 
                    end

                    -- Setup Proxy & Noclip
                    local startCF = CFrame.lookAt(hrp.Position, endPos)
                    ProxyPart.CFrame = startCF

                    noclipConn = RunService.Stepped:Connect(function()
                        if not isTweening or not hrp or not char then return end
                        -- Bikin tembus tembok
                        for part, _ in pairs(originalCollisions) do 
                            if part.CanCollide then part.CanCollide = false end 
                        end
                        -- Kunci karakter ke Proxy
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        hrp.CFrame = ProxyPart.CFrame
                    end)
                    
                    -- Jalanin Animasi Terbang
                    local tweenInfo = TweenInfo.new(dist / TWEEN_SPEED, Enum.EasingStyle.Linear)
                    local lookCF = CFrame.lookAt(endPos, endPos + startCF.LookVector)

                    currentTween = TweenService:Create(ProxyPart, tweenInfo, {CFrame = lookCF})
                    currentTween:Play()
                end
            end 
        end
    end 
end)