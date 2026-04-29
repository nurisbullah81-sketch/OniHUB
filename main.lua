-- [[ CatHUB MAIN LOADER & AUTO SAVE ENGINE ]] --
local _ENV = (getgenv or getrenv or getfenv)()

-- Debounce & Queue on Teleport (Anti-Reset Pas Hop Server)
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
        FruitESP = false, 
        TweenFruit = false,
        AutoStoreFruit = false,
        AutoHop = false,
        AntiAFK = false
    },
    Labels = {}
}

-- 2. LOAD SYSTEM (Membaca file dari PC lu jika ada)
if isfile and isfile(ConfigFile) then
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(ConfigFile))
    end)
    
    if ok and type(data) == "table" then
        for key, value in pairs(data) do
            if _G.Cat.Settings[key] ~= nil then
                _G.Cat.Settings[key] = value -- Menimpa default dengan settingan tersimpan
            end
        end
        warn("[CatHUB] Berhasil memuat settingan dari " .. ConfigFile)
    end
end

-- 3. AUTO-SAVE SYSTEM (Menyimpan otomatis setiap 3 detik di background)
task.spawn(function()
    while task.wait(3) do
        if writefile then
            pcall(function()
                writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings))
            end)
        end
    end
end)

-- 4. MODULE LOADER (Menjalankan file UI dan Logic)
local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. tostring(math.random(1000, 9999))
    local ok, r = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not ok then warn("[CatHUB] Gagal meload: " .. file .. " | Error: " .. tostring(r)) end
    return r
end

-- PENTING: Load UI harus dilakukan SETELAH data JSON di-load!
Load("StyleUI.lua")
Load("Status.lua")
Load("Devil_Fruits.lua")