-- CatHUB Loader + Auto Re-execute + AUTO SAVE
local _ENV = (getgenv or getrenv or getfenv)()

-- Debounce
local last_exec = _ENV.cat_exec_debounce
if last_exec and (tick() - last_exec) <= 5 then return end
_ENV.cat_exec_debounce = tick()

-- queue_on_teleport
local executor = syn or fluxus
local queueteleport = queue_on_teleport or (executor and executor.queue_on_teleport)

if not _ENV.cat_queued and type(queueteleport) == "function" then
    _ENV.cat_queued = true
    local scriptUrl = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/Main.lua"))()'
    pcall(queueteleport, scriptUrl)
end

-- Load System
local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local ok, r = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not ok then warn("[CatHUB] Fail: " .. file .. " | " .. tostring(r)) end
    return r
end

-- [[ AUTO-SAVE SYSTEM ]]
local HttpService = game:GetService("HttpService")
local defaultSettings = { 
    FruitESP = true, 
    TweenFruit = true,
    AutoStoreFruit = true,
    AutoHop = true,
    AntiAFK = true
}

local function loadSettings()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile("CatHUB_Settings.json"))
    end)
    if ok and type(data) == "table" then
        for k, v in pairs(defaultSettings) do
            if data[k] == nil then data[k] = v end
        end
        return data
    end
    return defaultSettings
end

local function saveSettings()
    pcall(function()
        writefile("CatHUB_Settings.json", HttpService:JSONEncode(_G.Cat.Settings))
    end)
end

_G.Cat = {
    Player = game:GetService("Players").LocalPlayer,
    Settings = loadSettings(), -- LANGSUNG LOAD DARI FILE!
    Labels = {},
    SaveSettings = saveSettings
}

Load("StyleUI.lua")
Load("Status.lua")
Load("Devil_Fruits.lua")