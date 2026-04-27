-- CatHUB: Main Loader (RedzHub Queue Logic)
local _ENV = (getgenv or getrenv or getfenv)()

-- Debounce (Biar ga double execute)
local last_exec = _ENV.cat_exec_debounce
if last_exec and (tick() - last_exec) <= 5 then return end
_ENV.cat_exec_debounce = tick()

-- Queue On Teleport (Auto Re-execute di server baru)
local executor = syn or fluxus
local queueteleport = queue_on_teleport or (executor and executor.queue_on_teleport)

if not _ENV.cat_queued and type(queueteleport) == "function" then
    _ENV.cat_queued = true
    local scriptUrl = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/main.lua"))()'
    pcall(queueteleport, scriptUrl)
end

-- Load System
local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local ok, r = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not ok then warn("[CatHUB] Fail: " .. file .. " | " .. tostring(r)) end
    return r
end

_G.Cat = {
    Player = game:GetService("Players").LocalPlayer,
    Settings = { 
        FruitESP = false, 
        TweenFruit = false,
        AutoStoreFruit = false,
        AutoHop = false,
        AntiAFK = true
    },
    Labels = {}
}

Load("StyleUI.lua")
Load("Status.lua")
Load("Devil_Fruits.lua")