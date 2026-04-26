-- CatHUB FREEMIUM: Main Loader v6.0
local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then warn("[CatHUB]: Load Error -> " .. file) end
    return result
end

_G.CatHUB_UI = Load("UI.lua")
Load("ESP.lua")
Load("Combat.lua")
Load("Teleport.lua")
Load("Farm.lua") -- New Module

print("[CatHUB]: Version 6.0 Active. Farming & Combat Intelligence Synced.")