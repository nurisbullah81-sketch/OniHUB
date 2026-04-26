-- CatHUB SUPREMACY v8.0 Loader
_G.CatHUB_Loaded = true
local function Get(f)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"..f.."?v="..math.random()))()
end

_G.UI = Get("UI.lua")
Get("ESP.lua")
Get("Combat.lua")
Get("Farm.lua")
Get("Teleport.lua")

print("[CatHUB]: Reality Override v8.0 Active.")