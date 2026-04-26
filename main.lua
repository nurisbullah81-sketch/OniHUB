-- CatHUB FREEMIUM: Main Loader
local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then warn("[CatHUB]: Failed to load " .. file .. " -> " .. tostring(result)) end
    return result
end

_G.CatHUB_UI = Load("UI.lua")
Load("ESP.lua")
Load("Combat.lua")

print("[CatHUB]: Full Modular System Loaded Successfully.")