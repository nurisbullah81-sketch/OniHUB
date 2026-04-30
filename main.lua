-- [[ ==========================================
--      CatHUB: MAIN LOADER & AUTO-SAVE ENGINE
--    ========================================== ]]

-- // Environment Initialization
local _ENV        = (getgenv or getrenv or getfenv)()
local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")

-- // Prevent Re-execution (Singleton Pattern)
if _ENV.Cat_Executed then 
    return 
end
_ENV.Cat_Executed = true

-- // 1. TELEPORT HANDLER (Persistent Execution)
-- Ensures the script re-runs automatically after a Server Hop
local executor      = syn or fluxus
local queueTeleport = queue_on_teleport 
    or (executor and executor.queue_on_teleport)

if type(queueTeleport) == "function" then
    local scriptURL = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/Main.lua"))()'
    
    pcall(function()
        queueTeleport(scriptURL)
    end)
end

local ConfigFile = "CatHUB_Config.json"

-- ==========================================
-- 2. GLOBAL FRAMEWORK & DEFAULT SETTINGS
-- ==========================================
_G.Cat = {
    Player   = Players.LocalPlayer,
    Labels   = {},
    Settings = { 
        -- Visual & ESP
        FruitESP           = false,
        
        -- Movement & Teleport
        TweenFruit         = false,
        InstantTPFruit     = false,
        AutoHop            = false,
        
        -- Automation
        AutoStoreFruit     = false,
        AutoAttack         = false,
        AntiAFK            = true, 
        AutoTeam           = false,
        FPSBoost           = false, -- <--- TAMBAHKAN INI BANG!
        
        -- Webhook Alerts
        FruitWebhook       = false,
        FruitWebhookURL    = "", 
        FruitWebhookRarity = "Mythical Only"
    }
}

-- ==========================================
-- 3. CONFIGURATION LOADER (Read Saved Data)
-- ==========================================
local function LoadConfig()
    local hasFile = isfile and isfile(ConfigFile)
    
    if hasFile then
        local ok, data = pcall(function()
            local content = readfile(ConfigFile)
            return HttpService:JSONDecode(content)
        end)
        
        -- Merge saved data into default settings
        if ok and type(data) == "table" then
            for key, value in pairs(data) do
                local isExistingKey = _G.Cat.Settings[key] ~= nil
                
                if isExistingKey then
                    _G.Cat.Settings[key] = value
                end
            end
        end
    end
end

-- Execute Load
LoadConfig()

-- ==========================================
-- 4. AUTO-SAVE ENGINE (Persistence)
-- ==========================================
-- Periodically saves settings to disk every 3 seconds
task.spawn(function()
    while task.wait(3) do
        local canSave = writefile ~= nil
        
        if canSave then
            pcall(function() 
                local payload = HttpService:JSONEncode(_G.Cat.Settings)
                writefile(ConfigFile, payload) 
            end)
        end
    end
end)

-- [[ ==========================================
--      5. MODULE LOADER FUNCTION
--    ========================================== ]]

-- // Function: Remote Module Loader with Cache-Busting
local function Load(file)
    local baseUrl = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"
    local version = tostring(math.random(1000, 9999))
    
    -- Construct URL with versioning to prevent old cache loading
    local url = string.format("%s%s?v=%s", baseUrl, file, version)
    
    -- Execute remote load
    local ok, result = pcall(function() 
        return loadstring(game:HttpGet(url))() 
    end)
    
    -- Error Reporting
    if not ok then 
        local errMsg = "[CatHUB] Failed to load module: %s | Error: %s"
        warn(string.format(errMsg, file, tostring(result))) 
    end
    
    return result
end

-- ==========================================
-- 6. EXECUTION ORDER (INITIALIZATION)
-- ==========================================

-- // Phase 1: UI & Core Framework
Load("StyleUI.lua")                 -- Initialize UI Engine
Load("Core.lua")                    -- Setup Foundation & Security

-- // Phase 2: Information & Tracking
Load("Modules/Status.lua")          -- Player & Server Status Labels
Load("Modules/DevilFruits/ESP.lua") -- Fruit Detection System

-- // Phase 3: Automation Modules
Load("Modules/AutoFarm/AutoFarm.lua") -- Main Farming Logic
Load("Modules/DevilFruits/FruitTP.lua")   -- Movement (Tween/TP)
Load("Modules/DevilFruits/AutoStore.lua") -- Inventory Management
Load("Modules/DevilFruits/AutoHop.lua")   -- Server Browser Logic

-- // Phase 4: Utilities & Protection
Load("Modules/DevilFruits/Webhook.lua") -- Alerts & Logging
Load("Modules/Misc/AntiAFK.lua")        -- Idle Protection & Auto Team

-- // Phase 5: Miscellaneous & Optimization
Load("Modules/Misc/FPSBooster.lua")     -- Max Performance (Anti-Lag)