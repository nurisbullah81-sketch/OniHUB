-- [[ CatHUB MAIN LOADER & AUTO SAVE ENGINE ]] --
local _ENV = (getgenv or getrenv or getfenv)()

-- Debounce & Queue on Teleport
if _ENV.Cat_Executed then return end
_ENV.Cat_Executed = true

local executor = syn or fluxus
local queueteleport = queue_on_teleport or (executor and executor.queue_on_teleport)
if type(queueteleport) == "function" then
    local scriptUrl = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/Main.lua"))()'
    pcall(queueteleport, scriptUrl)
end

local HttpService = game:GetService("HttpService")
local ConfigFile = "CatHUB_Config.json"

-- 1. INISIALISASI SETTINGAN DEFAULT
_G.Cat = {
    Player = game:GetService("Players").LocalPlayer,
    Settings = { 
        FruitESP = false, TweenFruit = false, InstantTPFruit = false,
        AutoStoreFruit = false, AutoHop = false, AntiAFK = false, 
        AutoAttack = false, FruitWebhook = false, FruitWebhookURL = "", 
        FruitWebhookRarity = "Mythical Only", AutoTeam = false
    },
    Labels = {}
}

-- 2. LOAD SYSTEM
if isfile and isfile(ConfigFile) then
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
    if ok and type(data) == "table" then
        for key, value in pairs(data) do if _G.Cat.Settings[key] ~= nil then _G.Cat.Settings[key] = value end end
    end
end

-- 3. AUTO-SAVE SYSTEM
task.spawn(function()
    while task.wait(3) do if writefile then pcall(function() writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings)) end) end end
end)

-- 4. MODULE LOADER
local function Load(file)
    -- Path sekarang mengikuti struktur folder GitHub lu
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. tostring(math.random(1000, 9999))
    local ok, r = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not ok then warn("[CatHUB] Gagal meload: " .. file .. " | Error: " .. tostring(r)) end
    return r
end

-- PENTING: JANGAN UBAH URUTAN INI!
Load("StyleUI.lua")                     -- 1. Bangun Rumah Kosong
Load("Core.lua")                        -- 2. Pasang Fondasi & Keamanan
Load("Modules/Status/Status.lua")       -- 3. Penghuni Status
Load("Modules/AutoFarm/AutoFarm.lua")   -- 4. Penghuni Auto Farm
Load("Modules/DevilFruits/ESP.lua")     -- 5. Penghuni ESP (Scanner)
Load("Modules/DevilFruits/FruitTP.lua") -- 6. Penghuni TP/Tween
Load("Modules/DevilFruits/AutoStore.lua")-- 7. Penghuni AutoStore
Load("Modules/DevilFruits/AutoHop.lua") -- 8. Penghuni AutoHop
Load("Modules/DevilFruits/Webhook.lua") -- 9. Penghuni Webhook & CCTV
Load("Modules/Misc/AntiAFK.lua")        -- 10. Penghuni Anti AFK & Auto Team