-- CatHUB SUPREMACY v9.0 Loader
_G.CatHUB_Loaded = true
local function Get(f)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"..f.."?v="..math.random()
    local s, r = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not s then warn("[CatHUB]: Failed to load "..f) end
    return r
end

_G.UI = Get("UI.lua")
Get("ESP.lua")
Get("Combat.lua")
Get("Farm.lua")
Get("Fruits.lua") -- MODUL KERAMAT LU
Get("Teleport.lua")

print("[CatHUB]: Reality Override v9.0 Deployed.")