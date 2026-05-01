-- [[ ==========================================
--      CatHUB: MAIN LOADER & AUTO-SAVE ENGINE
--    ========================================== ]]

-- // Environment Initialization
-- Cari environment global yang aman biar script survive saat server hop
local _ENV        = (getgenv or getrenv or getfenv)()
local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")

-- // Prevent Re-execution (Singleton Pattern)
-- Cek kalo script udah jalan sekali, biar ga dobel eksekusi
if _ENV.Cat_Executed then 
    return 
end
_ENV.Cat_Executed = true

-- // 1. TELEPORT HANDLER (Persistent Execution)
-- Fungsi ini biar script otomatis jalan lagi pas pindah server (Server Hop)
local executor      = syn or fluxus
local queueTeleport = queue_on_teleport 
    or (executor and executor.queue_on_teleport)

if type(queueTeleport) == "function" then
    -- Define URL script utama (dipisah biar ga panjang ke kanan)
    local scriptURL = 'loadstring(game:HttpGet(' ..
        '"https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/Main.lua"))()'
    
    -- Masukin antrian teleport dengan aman (pcall buat handling error)
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
        -- // Visual & ESP
        FruitESP           = false,
        
        -- // Movement & Teleport
        TweenFruit         = false,
        InstantTPFruit     = false,
        AutoHop            = false,
        
        -- // Automation
        AutoStoreFruit     = false,
        AutoAttack         = false,
        AntiAFK            = true, 
        AutoTeam           = false,
        FPSBoost           = false, -- <--- WAJIB ADA INI BANG!
        
        -- // Webhook Alerts
        FruitWebhook       = false,
        FruitWebhookURL    = "", 
        FruitWebhookRarity = "Mythical Only"
    }
}

-- ==========================================
-- 3. CONFIGURATION LOADER
-- ==========================================
local function LoadConfig()
    local hasFile = isfile and isfile(ConfigFile)

    if hasFile then
        -- Baca file dengan aman (pcall)
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigFile))
        end)

        -- Gabung data lama ke settings
        if ok and type(data) == "table" then
            for key, value in pairs(data) do
                if _G.Cat.Settings[key] ~= nil then
                    _G.Cat.Settings[key] = value
                end
            end
        end
    end
end

LoadConfig()

-- ==========================================
-- 4. SMART AUTO-SAVE ENGINE
-- ==========================================
-- Cuma nulis kalo ada perubahan data
task.spawn(function()
    -- Simpen state awal (dipecah biar ga panjang)
    local LastSavedState = HttpService:JSONEncode(
        _G.Cat.Settings
    )

    while task.wait(5) do
        if writefile then
            pcall(function()
                local CurrentState = HttpService:JSONEncode(
                    _G.Cat.Settings
                )

                -- Cek perubahan sebelum save
                if CurrentState ~= LastSavedState then
                    writefile(ConfigFile, CurrentState)
                    LastSavedState = CurrentState
                end
            end)
        end
    end
end)

-- [[ ==========================================
--      5. MODULE LOADER FUNCTION
--    ========================================== ]]

-- // Function: Remote Loader with Cache-Busting
local function Load(file)
    -- URL dipecah biar ga panjang ke kanan
    local baseUrl = "https://raw.githubusercontent.com/" ..
        "nurisbullah81-sketch/OniHUB/refs/heads/main/"
    local version = tostring(math.random(1000, 9999))
    
    -- Tambah param version biar bypass cache
    local url = string.format("%s%s?v=%s", baseUrl, file, version)
    
    -- Load script dari URL
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    -- Warning kalo gagal load
    if not ok then 
        warn(string.format(
            "[CatHUB] Failed: %s | Err: %s", 
            file, 
            tostring(result)
        )) 
    end
    
    return result
end

-- ==========================================
-- 6. EXECUTION ORDER
-- ==========================================

-- // Phase 1: UI & Core
Load("StyleUI.lua")                  -- UI Engine
Load("Core.lua")                     -- Foundation

-- // Phase 2: Info & Tracking
Load("Modules/Status.lua")           -- Status Labels
Load("Modules/DevilFruits/ESP.lua")  -- Fruit ESP

-- // Phase 3: Automation
Load("Modules/AutoFarm/AutoFarm.lua")    -- Auto Farm
Load("Modules/DevilFruits/FruitTP.lua")  -- Fruit TP
Load("Modules/DevilFruits/AutoStore.lua")-- Auto Store
Load("Modules/DevilFruits/AutoHop.lua")  -- Auto Hop

-- // Phase 4: Utilities
Load("Modules/DevilFruits/Webhook.lua")  -- Webhook
Load("Modules/Misc/AntiAFK.lua")         -- Anti AFK

-- // Phase 5: Misc
Load("Modules/Misc/FPSBooster.lua")   -- FPS Boost
Load("Modules/Misc/GameSettings.lua") -- Settings