-- [[ ==========================================
--      MODULE: DEVIL FRUIT TELEPORTATION (STABLE FIX)
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

UI.CreateToggle(Page, "Tween to Fruits", "Smooth fly (Anti-Stuck)", Settings.TweenFruit, function(state) Settings.TweenFruit = state end)
UI.CreateToggle(Page, "TP Fruits", "Instant teleport", Settings.InstantTPFruit, function(state) Settings.InstantTPFruit = state end)

-- ==========================================
-- LOGIC CONFIGURATION
-- ==========================================
local TWEEN_SPEED = 300 
local currentTarget = nil
local currentTween = nil
local noclipConn = nil
local isTweening = false

-- PROXY PART (Reusable)
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
    
    if currentTween then currentTween:Cancel(); currentTween = nil end
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    
    -- Restore Physics
    local char = Me.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    
    -- FIX NYANGKUT: Pastikan collision balik normal
    pcall(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then 
                part.CanCollide = true -- Balikin ke normal
            end
        end
    end)
end

State.StopSmartTween = StopSmartTween

-- ==========================================
-- SMART MOVEMENT HANDLER
-- ==========================================
task.spawn(function() 
    while task.wait(0.1) do -- Loop utama santai
        if not State.IsGameReady or (not Settings.TweenFruit and not Settings.InstantTPFruit) then 
            StopSmartTween()
            continue 
        end

        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local nearest = ESP.GetNearestFruit()
        if not nearest then StopSmartTween(); continue end

        local targetPos = ESP.Pos(nearest)
        if not targetPos then StopSmartTween(); continue end

        local dist = (targetPos - hrp.Position).Magnitude
        local endPos = targetPos + Vector3.new(0, 2, 0)

        -- INSTANT LOGIC
        if Settings.InstantTPFruit then
            StopSmartTween()
            if dist > 5 then
                hrp.CFrame = CFrame.new(endPos)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end

        -- TWEEN LOGIC
        elseif Settings.TweenFruit then 
            if dist < 5 then 
                StopSmartTween()
            else
                -- Deteksi kalau target berubah atau tween belum jalan
                if currentTarget ~= nearest or not isTweening then
                    StopSmartTween() -- Clean up dulu
                    
                    currentTarget = nearest
                    isTweening = true
                    
                    -- Setup Proxy
                    local startCF = CFrame.lookAt(hrp.Position, endPos)
                    ProxyPart.CFrame = startCF

                    -- FIX NOCLIP: Pake loop Stepped TAPI dengan cache parts
                    -- Ini penting biar bisa tembus tembok tanpa lag
                    noclipConn = RunService.Stepped:Connect(function()
                        if not isTweening or not char then return end
                        
                        -- Langsung set property tanpa loop 'GetDescendants' baru
                        -- Ini cara paling efisien nge-force noclip
                        for _, part in ipairs(char:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                        
                        -- Kunci posisi ke Proxy
                        if hrp then
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.CFrame = ProxyPart.CFrame
                        end
                    end)
                    
                    -- Play Tween
                    local tweenInfo = TweenInfo.new(dist / TWEEN_SPEED, Enum.EasingStyle.Linear)
                    local lookCF = CFrame.lookAt(endPos, endPos + startCF.LookVector)

                    currentTween = TweenService:Create(ProxyPart, tweenInfo, {CFrame = lookCF})
                    currentTween:Play()
                end
            end 
        end
    end 
end)