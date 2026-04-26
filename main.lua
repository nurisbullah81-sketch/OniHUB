-- CatHUB v7.0: Optimized Loader
local StartTime = tick()

local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("[CatHUB] Failed: " .. file)
    end
    return result
end

-- Shared Cache System (anti redundant calculations)
_G.CatCache = {
    LocalPlayer = game:GetService("Players").LocalPlayer,
    Character = nil,
    Humanoid = nil,
    HumanoidRootPart = nil,
    Position = Vector3.zero,
    IsValid = false,
    CurrentTween = nil,
    IsMoving = false,
    TargetPlayer = nil,
    TargetLocked = false,
    Jitter = 0 -- Anti-ban random delay
}

-- Single cache update (runs once per frame, not per module)
local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
    local cache = _G.CatCache
    local char = cache.LocalPlayer.Character
    cache.IsValid = char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0
    if cache.IsValid then
        if cache.Character ~= char then
            cache.Character = char
            cache.Humanoid = char.Humanoid
            cache.HumanoidRootPart = char.HumanoidRootPart
        end
        cache.Position = char.HumanoidRootPart.Position
    else
        cache.Character = nil
        cache.Humanoid = nil
        cache.HumanoidRootPart = nil
    end
    -- Random jitter for anti-detect (0.01 - 0.05s variance)
    cache.Jitter = math.random(10, 50) / 1000
end)

_G.CatHUB_UI = Load("UI.lua")
Load("Fruits.lua")
Load("ESP.lua")  
Load("Combat.lua")
Load("Teleport.lua")
Load("Farm.lua")

print("[CatHUB] v7.0 Loaded in " .. math.floor((tick() - StartTime) * 1000) .. "ms")