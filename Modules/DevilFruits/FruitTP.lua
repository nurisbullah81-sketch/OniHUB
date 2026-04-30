-- [[ ==========================================
--      MODULE: DEVIL FRUIT TELEPORTATION
--    ========================================== ]]

-- // Services
local RunService   = game:GetService("RunService")
local TweenService  = game:GetService("TweenService")
local Players       = game:GetService("Players")

-- // Variables
local Me = Players.LocalPlayer

-- // Wait for Core System Initialization
repeat 
    task.wait(0.1) 
until _G.Cat 
    and _G.Cat.UI 
    and _G.Cat.Settings 
    and _G.Cat.State 
    and _G.Cat.ESP

-- // Reference Global Components
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State
local ESP      = _G.Cat.ESP

-- ==========================================
-- 1. UI INITIALIZATION
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)

-- // Movement Toggles
UI.CreateToggle(
    Page, 
    "Tween to Fruits", 
    "Smoothly fly to collect fruits", 
    Settings.TweenFruit, 
    function(state) 
        Settings.TweenFruit = state 
    end
)

UI.CreateToggle(
    Page, 
    "TP Fruits", 
    "Instant teleport to spawned fruits", 
    Settings.InstantTPFruit, 
    function(state) 
        Settings.InstantTPFruit = state 
    end
)

-- ==========================================
-- 2. LOGIC CONFIGURATION: TWEEN & TP
-- ==========================================
local isTweening         = false
local currentTarget      = nil
local proxyPart          = nil
local noclipConn         = nil
local currentTween       = nil
local originalCollisions = {} 
local TWEEN_SPEED        = 300 

-- // Function: Stop and Cleanup Smart Tween
local StopSmartTween = function()
    if not isTweening then return end
    
    -- Reset Movement States
    isTweening    = false
    currentTarget = nil
    
    -- Cancel Active Tween
    if currentTween then 
        pcall(function() currentTween:Cancel() end) 
        currentTween = nil 
    end
    
    -- Disconnect Connections
    if noclipConn then 
        noclipConn:Disconnect() 
        noclipConn = nil 
    end
    
    -- Cleanup Proxy Object
    if proxyPart then 
        pcall(function() proxyPart:Destroy() end) 
        proxyPart = nil 
    end
    
    -- Restore Character Physics
    pcall(function()
        local char = Me.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if hrp then 
                hrp.AssemblyLinearVelocity  = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero 
            end
            
            -- Restore Collisions
            for part, state in pairs(originalCollisions) do 
                if part and part.Parent then 
                    part.CanCollide = state 
                end 
            end
        end
        
        table.clear(originalCollisions)
    end)
end

-- [[ ==========================================
--      3. MOVEMENT HANDLER: TP & SMART TWEEN
--    ========================================== ]]

State.StopSmartTween = StopSmartTween

task.spawn(function() 
    while task.wait(0.2) do 
        pcall(function() 
            -- // 3.1: Emergency Safety Check
            if not State.IsGameReady then 
                StopSmartTween()
                task.wait(1) -- Throttle loop to save performance
                return 
            end

            -- // 3.2: Cache Local References
            local char    = Me.Character
            local hrp     = char and char:FindFirstChild("HumanoidRootPart")
            local nearest = ESP.GetNearestFruit()

            -- // 3.3: INSTANT TELEPORT LOGIC
            if Settings.InstantTPFruit then
                StopSmartTween() -- Reset any active tweening
                
                if nearest and hrp then 
                    local targetPos = ESP.Pos(nearest) 
                    local dist      = (targetPos - hrp.Position).Magnitude

                    if targetPos and dist > 5 then
                        -- Kill Velocity to stabilize physics
                        hrp.AssemblyLinearVelocity  = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        
                        -- Execute TP
                        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
                        
                        -- Final Reset
                        hrp.AssemblyLinearVelocity  = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end

            -- // 3.4: SMART TWEEN LOGIC
            elseif Settings.TweenFruit then 
                if nearest and hrp then 
                    local targetPos = ESP.Pos(nearest) 
                    
                    if not targetPos then 
                        StopSmartTween() 
                        return 
                    end

                    local dist = (targetPos - hrp.Position).Magnitude 
                    
                    -- Arrived check
                    if dist < 5 then 
                        StopSmartTween()
                    else
                        -- Check if we need to start or restart the tween
                        local isNewTarget = currentTarget ~= nearest
                        
                        if isNewTarget or not isTweening then
                            StopSmartTween() 
                            
                            currentTarget = nearest
                            isTweening    = true
                            
                            -- // 3.5: Prepare Character Collisions (Noclip)
                            table.clear(originalCollisions)
                            for _, part in ipairs(char:GetDescendants()) do 
                                if part:IsA("BasePart") then 
                                    originalCollisions[part] = part.CanCollide 
                                end 
                            end

                            -- // 3.6: Setup Movement Proxy
                            local startCF = CFrame.lookAt(hrp.Position, targetPos)
                            
                            proxyPart              = Instance.new("Part")
                            proxyPart.Name         = "NomexyProxy"
                            proxyPart.Transparency = 1
                            proxyPart.Anchored     = true
                            proxyPart.CanCollide   = false
                            proxyPart.Size         = Vector3.new(1, 1, 1)
                            proxyPart.CFrame       = startCF
                            proxyPart.Parent       = workspace

                            -- // 3.7: Stepped Physics Connection
                            noclipConn = RunService.Stepped:Connect(function()
                                -- Validate if tween should still run
                                local canRun = isTweening 
                                    and Settings.TweenFruit 
                                    and not Settings.InstantTPFruit 
                                    and State.IsGameReady

                                if not canRun then 
                                    StopSmartTween() 
                                    return 
                                end

                                if char and hrp and proxyPart then
                                    -- Continuous Noclip Enforcement
                                    for _, v in ipairs(char:GetDescendants()) do 
                                        if v:IsA("BasePart") and v.CanCollide then 
                                            v.CanCollide = false 
                                        end 
                                    end
                                    
                                    -- Snap Character to Proxy
                                    hrp.AssemblyLinearVelocity  = Vector3.zero
                                    hrp.AssemblyAngularVelocity = Vector3.zero
                                    hrp.CFrame                  = proxyPart.CFrame
                                else 
                                    StopSmartTween() 
                                end
                            end)
                            
                            -- // 3.8: Execute Smooth Movement
                            local endPos    = targetPos + Vector3.new(0, 2, 0) 
                            local tweenInfo = TweenInfo.new(
                                dist / TWEEN_SPEED, 
                                Enum.EasingStyle.Linear, 
                                Enum.EasingDirection.InOut
                            )
                            
                            local lookCF = CFrame.lookAt(
                                endPos, 
                                endPos + startCF.LookVector
                            )

                            currentTween = TweenService:Create(
                                proxyPart, 
                                tweenInfo, 
                                {CFrame = lookCF}
                            )
                            currentTween:Play()
                        end
                    end 
                else 
                    StopSmartTween() 
                end 
            else 
                StopSmartTween() 
            end
        end) 
    end 
end)