-- Modules/DevilFruits/FruitTP.lua
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Me = Players.LocalPlayer
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings or not _G.Cat.State or not _G.Cat.ESP do task.wait(0.1) end
local UI = _G.Cat.UI
local Settings = _G.Cat.Settings
local State = _G.Cat.State
local ESP = _G.Cat.ESP

-- FIX: Panggil CreateTab lagi buat masuk ke kamar yang udah ada!
local Page = UI.CreateTab("Devil Fruits", false)

-- 1. PASANG UI
UI.CreateToggle(Page, "Tween to Fruits", "Smoothly fly to collect fruits", Settings.TweenFruit, function(s) Settings.TweenFruit = s UI.SaveSettings() end)
UI.CreateToggle(Page, "TP Fruits", "Instant teleport to spawned fruits", Settings.InstantTPFruit, function(s) Settings.InstantTPFruit = s UI.SaveSettings() end)

-- 2. LOGIC TWEEN & INSTAN TP (MURNI DARI CODE LU)
local isTweening = false
local currentTarget = nil
local proxyPart = nil
local noclipConn = nil
local currentTween = nil
local originalCollisions = {} 
local TWEEN_SPEED = 300 

local StopSmartTween = function()
    if not isTweening then return end
    isTweening = false; currentTarget = nil
    if currentTween then pcall(function() currentTween:Cancel() end) currentTween = nil end
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if proxyPart then pcall(function() proxyPart:Destroy() end) proxyPart = nil end
    
    pcall(function()
        if Me.Character then
            local hrp = Me.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end
            for part, state in pairs(originalCollisions) do if part and part.Parent then part.CanCollide = state end end
        end
        table.clear(originalCollisions)
    end)
end

State.StopSmartTween = StopSmartTween

task.spawn(function() 
    while task.wait(0.2) do 
        pcall(function() 
            if State.IsGameReady then 
                if Settings.InstantTPFruit then
                    StopSmartTween()
                    local nearest = ESP.GetNearestFruit() 
                    local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
                    if nearest and hrp then 
                        local targetPos = ESP.Pos(nearest) 
                        if targetPos and (targetPos - hrp.Position).Magnitude > 5 then
                            hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero
                            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
                            hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                elseif Settings.TweenFruit then 
                    local nearest = ESP.GetNearestFruit() 
                    local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
                    if nearest and hrp then 
                        local targetPos = ESP.Pos(nearest) 
                        if not targetPos then StopSmartTween() return end
                        local dist = (targetPos - hrp.Position).Magnitude 
                        if dist < 5 then StopSmartTween()
                        else
                            if currentTarget ~= nearest or not isTweening then
                                StopSmartTween() 
                                currentTarget = nearest; isTweening = true
                                table.clear(originalCollisions)
                                for _, part in pairs(Me.Character:GetDescendants()) do if part:IsA("BasePart") then originalCollisions[part] = part.CanCollide end end
                                local startCFrame = CFrame.lookAt(hrp.Position, targetPos)
                                proxyPart = Instance.new("Part") proxyPart.Name = "NomexyProxy" proxyPart.Transparency = 1 proxyPart.Anchored = true proxyPart.CanCollide = false proxyPart.Size = Vector3.new(1, 1, 1) proxyPart.CFrame = startCFrame proxyPart.Parent = workspace

                                noclipConn = RunService.Stepped:Connect(function()
                                    if isTweening and Settings.TweenFruit and not Settings.InstantTPFruit and State.IsGameReady then
                                        local success, hrpCheck = pcall(function() return Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") end)
                                        if success and hrpCheck and proxyPart then
                                            for _, part in pairs(Me.Character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end
                                            hrpCheck.AssemblyLinearVelocity = Vector3.zero; hrpCheck.AssemblyAngularVelocity = Vector3.zero; hrpCheck.CFrame = proxyPart.CFrame
                                        end
                                    else StopSmartTween() end
                                end)
                                
                                local endPos = targetPos + Vector3.new(0, 2, 0) 
                                currentTween = TweenService:Create(proxyPart, TweenInfo.new(dist / TWEEN_SPEED, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = CFrame.lookAt(endPos, endPos + startCFrame.LookVector)})
                                currentTween:Play()
                            end
                        end 
                    else StopSmartTween() end 
                else StopSmartTween() end
            else StopSmartTween() end 
        end) 
    end 
end)