-- CatHUB v7.0: Combat (Fixed Attack + Anti-Detect)
local UI = _G.CatHUB_UI
local Cache = _G.CatCache
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Tab = UI:CreateTab("⚔️ Combat")

UI:CreateSection(Tab, "ATTACK")
UI:CreateSwitch(Tab, "AutoAttack", "Auto Attack")

UI:CreateSection(Tab, "DEFENSE")
UI:CreateSwitch(Tab, "AntiStun", "Anti Stun")
UI:CreateSwitch(Tab, "NoClip", "No Clip")

UI:CreateSection(Tab, "MOVEMENT")
UI:CreateSwitch(Tab, "FastRun", "Fast Run")
UI:CreateSlider(Tab, "RunSpeed", "Run Speed", 16, 100, nil)
UI:CreateSwitch(Tab, "HighJump", "High Jump")
UI:CreateSlider(Tab, "JumpPower", "Jump Power", 50, 200, nil)

UI:CreateSection(Tab, "AIMBOT")
UI:CreateSwitch(Tab, "Aimbot", "Lock Aim to Nearest")

-- Auto Attack: uses Heartbeat but with frame limiter
local lastAttackTick = 0
local attackInterval = 0.08 -- ~12 attacks/sec (safe, not insane)

RunService.Heartbeat:Connect(function()
    if not UI.Settings.AutoAttack then return end
    if not Cache.IsValid then return end
    
    -- Frame limiter (don't attack EVERY frame)
    if tick() - lastAttackTick < attackInterval then return end
    
    -- Check if near enemy
    local nearEnemy = false
    pcall(function()
        for _, v in pairs(Workspace.Enemies:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                if v.Humanoid.Health > 0 then
                    local d = (v.HumanoidRootPart.Position - Cache.Position).Magnitude
                    if d < 30 then -- Only attack if CLOSE (not teleporting)
                        nearEnemy = true
                        break
                    end
                end
            end
        end
    end)
    
    -- Also check if near bounty target
    if not nearEnemy and Cache.TargetLocked and Cache.TargetPlayer then
        pcall(function()
            local target = Cache.TargetPlayer
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local d = (target.Character.HumanoidRootPart.Position - Cache.Position).Magnitude
                if d < 30 then nearEnemy = true end
            end
        end)
    end
    
    if nearEnemy then
        lastAttackTick = tick()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(851, 158), Workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- Anti Stun (lightweight)
RunService.Heartbeat:Connect(function()
    if not UI.Settings.AntiStun then return end
    if not Cache.IsValid then return end
    pcall(function()
        local state = Cache.Humanoid:GetState()
        if state == Enum.HumanoidStateType.PlatformStanding or state == Enum.HumanoidStateType.FallingDown then
            Cache.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end)

-- No Clip
RunService.Stepped:Connect(function()
    if not UI.Settings.NoClip then return end
    if not Cache.IsValid then return end
    pcall(function()
        if Cache.Humanoid:GetState() ~= Enum.HumanoidStateType.StrafingNoPhysics then
            Cache.Humanoid:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics)
        end
    end)
end)

-- Fast Run / Jump (slow interval, not every frame)
task.spawn(function()
    while task.wait(0.5) do
        if not Cache.IsValid then continue end
        pcall(function()
            Cache.Humanoid.WalkSpeed = UI.Settings.FastRun and UI.Settings.RunSpeed or 16
            if UI.Settings.HighJump then
                Cache.Humanoid.UseJumpPower = true
                Cache.Humanoid.JumpPower = UI.Settings.JumpPower
            end
        end)
    end
end)

-- Aimbot (RenderStepped because camera)
RunService.RenderStepped:Connect(function()
    if not UI.Settings.Aimbot then return end
    if not Cache.IsValid then return end
    
    local closest, dist = nil, math.huge
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Cache.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if p.Character.Humanoid.Health > 0 then
                    local d = (p.Character.HumanoidRootPart.Position - Cache.Position).Magnitude
                    if d < dist and d < 500 then
                        closest, dist = p, d
                    end
                end
            end
        end
        if closest then
            Workspace.CurrentCamera.CFrame = CFrame.new(
                Workspace.CurrentCamera.CFrame.Position,
                closest.Character.HumanoidRootPart.Position
            )
        end
    end)
end)

print("[CatHUB] Combat loaded")