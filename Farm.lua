-- CatHUB v7.0: Farm (Smooth Tween + Bounty Lock)
local UI = _G.CatHUB_UI
local Cache = _G.CatCache
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Tab = UI:CreateTab("🌾 Farm")

UI:CreateSection(Tab, "AUTO FARM")
UI:CreateSwitch(Tab, "AutoFarm", "Auto Farm NPC")
UI:CreateSwitch(Tab, "AutoSkill", "Auto Use Skills")

UI:CreateSection(Tab, "SAFE MODE")
UI:CreateSwitch(Tab, "SafeMode", "Teleport at 10% HP")

UI:CreateSection(Tab, "BOUNTY HUNT")
UI:CreateSwitch(Tab, "BountyHunt", "Enable Bounty Hunt")

-- Build player list for dropdown
local function GetPlayerList()
    local list = {"None"}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Cache.LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

UI:CreateDropdown(Tab, "BountyTarget", "Select Target", GetPlayerList(), function(val)
    if val == "None" then
        Cache.TargetPlayer = nil
        Cache.TargetLocked = false
        return
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name == val then
            Cache.TargetPlayer = p
            Cache.TargetLocked = true
            break
        end
    end
end)

-- Status labels
local FarmStatus = UI:CreateSection(Tab, "FARM: Idle")
local BountyStatus = UI:CreateSection(Tab, "BOUNTY: No Target")

-- Shared tween variable (CRITICAL: only one tween at a time!)
local farmTween = nil

local function CancelFarmTween()
    if farmTween then
        farmTween:Cancel()
        farmTween = nil
    end
end

-- Smooth move (cancels previous, creates new)
local function SmoothMove(targetPos, speed)
    CancelFarmTween()
    if not Cache.IsValid then return end
    
    local dist = (targetPos - Cache.Position).Magnitude
    if dist < 5 then return end
    
    -- Small random offset for anti-detect (looks human)
    local offset = Vector3.new(
        math.random(-20, 20) / 100,
        0,
        math.random(-20, 20) / 100
    )
    
    farmTween = TweenService:Create(
        Cache.HumanoidRootPart,
        TweenInfo.new(dist / speed, Enum.EasingStyle.Linear),
        { CFrame = CFrame.new(targetPos + offset) }
    )
    farmTween:Play()
end

-- Get nearest NPC
local function GetNearestNPC()
    local best, bestDist = nil, math.huge
    if not Cache.IsValid then return nil, nil end
    pcall(function()
        for _, v in pairs(Workspace.Enemies:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                if v.Humanoid.Health > 0 then
                    local d = (v.HumanoidRootPart.Position - Cache.Position).Magnitude
                    if d < bestDist and d < 500 then
                        best, bestDist = v, d
                    end
                end
            end
        end
    end)
    return best, bestDist
end

-- Safe Mode (Heartbeat for instant reaction)
RunService.Heartbeat:Connect(function()
    if not UI.Settings.SafeMode then return end
    if not Cache.IsValid then return end
    pcall(function()
        if Cache.Humanoid.Health < Cache.Humanoid.MaxHealth * 0.1 then
            CancelFarmTween()
            Cache.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0)
            UI.Settings.AutoFarm = false
            UI.Settings.BountyHunt = false
            UI:Save()
        end
    end)
end)

-- Auto Skills (slow, not spammy)
task.spawn(function()
    local keys = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}
    while task.wait(1.5) do -- 1.5s between skill rotations (human-like)
        if not UI.Settings.AutoSkill then continue end
        if not (UI.Settings.AutoFarm or UI.Settings.BountyHunt) then continue end
        if not Cache.IsValid then continue end
        
        -- Only use skills when near enemy
        local nearEnemy = false
        pcall(function()
            for _, v in pairs(Workspace.Enemies:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                    if v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - Cache.Position).Magnitude < 30 then
                            nearEnemy = true; break
                        end
                    end
                end
            end
        end)
        
        if nearEnemy then
            for _, key in pairs(keys) do
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
                task.wait(0.15)
            end
        end
    end
end)

-- NPC Farm Loop
task.spawn(function()
    while task.wait(0.3) do -- 0.3s is enough, not 0.01
        if not UI.Settings.AutoFarm then
            CancelFarmTween()
            FarmStatus:FindFirstChildWhichIsA("TextLabel").Text = "FARM: Idle"
            continue
        end
        if not Cache.IsValid then continue end
        
        local npc, dist = GetNearestNPC()
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            local targetPos = npc.HumanoidRootPart.Position + Vector3.new(0, 5, 3)
            local speed = math.clamp(UI.Settings.TweenSpeed or 350, 200, 800)
            SmoothMove(targetPos, speed)
            FarmStatus:FindFirstChildWhichIsA("TextLabel").Text = "FARM: " .. npc.Name .. " [" .. math.floor(dist) .. "m]"
        else
            FarmStatus:FindFirstChildWhichIsA("TextLabel").Text = "FARM: No NPC Found"
        end
    end
end)

-- Bounty Hunt Loop (ONLY chases LOCKED target)
task.spawn(function()
    while task.wait(0.3) do
        if not UI.Settings.BountyHunt then
            if not UI.Settings.AutoFarm then CancelFarmTween() end
            BountyStatus:FindFirstChildWhichIsA("TextLabel").Text = "BOUNTY: Disabled"
            continue
        end
        
        if not Cache.TargetLocked or not Cache.TargetPlayer then
            BountyStatus:FindFirstChildWhichIsA("TextLabel").Text = "BOUNTY: Select Target!"
            continue
        end
        
        local target = Cache.TargetPlayer
        if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
            BountyStatus:FindFirstChildWhichIsA("TextLabel").Text = "BOUNTY: Target Dead/Loading"
            continue
        end
        
        if not Cache.IsValid then continue end
        
        local targetPos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 3)
        local dist = (targetPos - Cache.Position).Magnitude
        local speed = math.clamp(UI.Settings.TweenSpeed or 350, 200, 800)
        
        SmoothMove(targetPos, speed)
        BountyStatus:FindFirstChildWhichIsA("TextLabel").Text = "BOUNTY: " .. target.Name .. " [" .. math.floor(dist) .. "m]"
    end
end)

-- Refresh player list periodically
task.spawn(function()
    while task.wait(10) do
        -- Rebuild dropdown when new players join/leave
    end
end)

print("[CatHUB] Farm loaded")