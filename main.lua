-- [[ CatHUB MAIN LOADER & AUTO SAVE ENGINE ]] --

-- Environment Setup
local _ENV = (getgenv or getrenv or getfenv)()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Prevent Re-execution
if _ENV.Cat_Executed then return end
_ENV.Cat_Executed = true

-- Teleport Handler (Auto Execute after Server Hop)
local executor = syn or fluxus
local queueteleport = queue_on_teleport or (executor and executor.queue_on_teleport)

if type(queueteleport) == "function" then
    local scriptUrl = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/Main.lua"))()'
    pcall(queueteleport, scriptUrl)
end

local ConfigFile = "CatHUB_Config.json"

-- ==========================================
-- 1. MASTER DEFAULT SETTINGS
-- ==========================================
_G.Cat = {
    Player = Players.LocalPlayer,
    Settings = { 
        FruitESP           = false,
        TweenFruit         = false,
        InstantTPFruit     = false,
        AutoStoreFruit     = false,
        AutoHop            = false,
        AntiAFK            = true, 
        AutoAttack         = false,
        AutoTeam           = false,
        FruitWebhook       = false,
        FruitWebhookURL    = "", 
        FruitWebhookRarity = "Mythical Only"
    },
    Labels = {}
}

-- ==========================================
-- 2. LOAD SYSTEM (Read Saved Config)
-- ==========================================
if isfile and isfile(ConfigFile) then
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(ConfigFile))
    end)
    
    if ok and type(data) == "table" then
        for key, value in pairs(data) do
            -- Hanya update jika key tersebut ada di default settings
            if _G.Cat.Settings[key] ~= nil then
                _G.Cat.Settings[key] = value
            end
        end
    end
end

-- ==========================================
-- 3. AUTO-SAVE SYSTEM (Every 3 Seconds)
-- ==========================================
task.spawn(function()
    while task.wait(3) do
        if writefile then
            pcall(function() 
                local encoded = HttpService:JSONEncode(_G.Cat.Settings)
                writefile(ConfigFile, encoded) 
            end)
        end
    end
end)

-- ==========================================
-- 4. MODULE LOADER FUNCTION
-- ==========================================
local function Load(file)
    -- Cache-busting URL with random version
    local baseUrl = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"
    local version = tostring(math.random(1000, 9999))
    local url = baseUrl .. file .. "?v=" .. version
    
    local ok, r = pcall(function() 
        return loadstring(game:HttpGet(url))() 
    end)
    
    if not ok then 
        warn("[CatHUB] Gagal meload: " .. file .. " | Error: " .. tostring(r)) 
    end
    
    return r
end

-- ==========================================
-- 5. EXECUTION ORDER
-- ==========================================
Load("StyleUI.lua")                     -- 1. Bangun Rumah Kosong
Load("Core.lua")                        -- 2. Pasang Fondasi & Keamanan
Load("Modules/Status.lua")                      -- 3. Penghuni Status (INI BETUL-BETUL HARUS SESUAI NAMA FILE LU)
Load("Modules/AutoFarm/AutoFarm.lua")   -- 4. Penghuni Auto Farm
Load("Modules/DevilFruits/ESP.lua")     -- 5. Penghuni ESP (Scanner)
Load("Modules/DevilFruits/FruitTP.lua") -- 6. Penghuni TP/Tween
Load("Modules/DevilFruits/AutoStore.lua")-- 7. Penghuni AutoStore
Load("Modules/DevilFruits/AutoHop.lua") -- 8. Penghuni AutoHop
Load("Modules/DevilFruits/Webhook.lua") -- 9. Penghuni Webhook & CCTV
Load("Modules/Misc/AntiAFK.lua")        -- 10. Penghuni Anti AFK & Auto Team