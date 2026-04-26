-- CatHUB FREEMIUM: Main Loader v6.2
local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then warn("[CatHUB]: Load Error -> " .. file .. " | " .. tostring(result)) end
    return result
end

_G.CatHUB_UI = Load("UI.lua")
Load("Fruits.lua")   -- Priority 1: Fruits
Load("ESP.lua")      -- Priority 2: Player ESP
Load("Combat.lua")
Load("Teleport.lua")
Load("Farm.lua")

print("[CatHUB]: Version 6.2 Active - Fruits Focus Update")