-- CatHUB FREEMIUM: Main Loader v4.0
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

print("[CatHUB]: System v4.0 Active. All modules synced.")