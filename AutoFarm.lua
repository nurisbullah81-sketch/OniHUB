local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VIM = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Me = _G.Cat.Player
local Settings = _G.Cat.Settings

-- Local state checker biar ga ganggu file utama
local function IsReady()
    return Me.Team ~= nil and Me.Character and Me.Character:FindFirstChild("HumanoidRootPart")
end

-- ==========================================
-- 1. AUTO ATTACK SYSTEM
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoAttack and IsReady() then
            pcall(function()
                local character = Me.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    -- Basic Universal Attack
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
        end
    end
end)

-- ==========================================
-- 2. MYTHICAL WEBHOOK SCANNER
-- ==========================================
local WebhookCooldown = false

local function SendMythicalWebhook(fruitName)
    if WebhookCooldown or not Settings.WebhookEnabled or not Settings.WebhookURL or Settings.WebhookURL == "" then return end
    WebhookCooldown = true
    local data = HttpService:JSONEncode({
        content = "🚨 **MYTHICAL FRUIT DETECTED!** 🚨\n**Fruit:** " .. fruitName .. "\n**JobID:** `" .. game.JobId .. "`\nUse this JobID to teleport!"
    })
    pcall(function() 
        HttpService:PostAsync(Settings.WebhookURL, data) 
        warn("[CatHUB] Webhook sent for " .. fruitName) 
    end)
    task.delay(60, function() WebhookCooldown = false end)
end

-- Fungsi pengecekan buah
local function IsFruit(o) 
    if not o or not o.Parent then return false end 
    local ok,r=pcall(function() if (o:IsA("Tool") or o:IsA("Model")) and o:FindFirstChild("Fruit") then return true end return false end) 
    return ok and r 
end

-- Scan pas buah spawn
Workspace.ChildAdded:Connect(function(o) 
    task.wait(0.5) 
    if IsFruit(o) and Settings.WebhookEnabled and IsReady() then 
        local name = string.lower(o.Name)
        local isMythical = string.find(name, "venom") or string.find(name, "shadow") or string.find(name, "dragon") or string.find(name, "control") or string.find(name, "spirit") or string.find(name, "t rex") or string.find(name, "leopard") or string.find(name, "kitsune")
        if isMythical then SendMythicalWebhook(o.Name) end
    end 
end)

-- Scan pas baru join server
task.spawn(function()
    task.wait(15) 
    if Settings.WebhookEnabled and IsReady() then 
        for _, o in pairs(Workspace:GetChildren()) do 
            if IsFruit(o) then 
                local name = string.lower(o.Name)
                local isMythical = string.find(name, "venom") or string.find(name, "shadow") or string.find(name, "dragon") or string.find(name, "control") or string.find(name, "spirit") or string.find(name, "t rex") or string.find(name, "leopard") or string.find(name, "kitsune")
                if isMythical then SendMythicalWebhook(o.Name) end
            end 
        end 
    end
end)