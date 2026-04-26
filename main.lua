-- CatHUB PREMIUM: Main Loader v6.3
local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then warn("[CatHUB]: " .. file .. " failed to load") end
    return result
end

_G.CatHUB_UI = Load("UI.lua")
Load("Fruits.lua")
Load("ESP.lua")
Load("Combat.lua")
Load("Teleport.lua")
Load("Farm.lua")

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("  🟣 CATHUB PREMIUM v6.3")
print("  RedzHub Style Interface")
print("  Press RightCtrl to toggle")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")