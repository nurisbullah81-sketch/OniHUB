-- CatHUB FREEMIUM: Main Loader v7.0
-- Developed for DIZX | No Filter | Absolute Power

local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then warn("[CatHUB]: Critical Failure Loading -> " .. file) end
    return result
end

_G.CatHUB_UI = Load("UI.lua")
Load("ESP.lua")
Load("Combat.lua")
Load("Teleport.lua")
Load("Farm.lua")

print("[CatHUB]: v7.0 Full System Deployed. Ready to Dominate.")