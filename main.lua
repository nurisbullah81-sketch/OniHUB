-- CatHUB SUPREMACY v13.0: Loader
_G.CatHUB_Loaded = true

local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"..file.."?v="..math.random()
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then 
        warn("[CatHUB]: Critical Error Loading -> "..file.." | "..tostring(result)) 
    end
    return result
end

-- INITIALIZATION ORDER
_G.UI = Load("UI.lua")
Load("ESP.lua")
Load("Fruits.lua")
Load("Combat.lua")
Load("Farm.lua")
Load("Teleport.lua")

print("[CatHUB]: v13.0 Absolute Restoration Fully Active.")