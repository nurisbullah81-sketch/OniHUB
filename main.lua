-- CatHUB SUPREMACY v10.0: Loader
_G.CatHUB_Loaded = true

local function LoadFile(fileName)
    local baseUrl = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"
    local success, result = pcall(function()
        return loadstring(game:HttpGet(baseUrl .. fileName .. "?v=" .. math.random()))()
    end)
    if not success then 
        warn("[CatHUB]: Failed to load " .. fileName .. " | Error: " .. tostring(result))
    end
    return result
end

-- Loading Order
_G.UI_Lib = LoadFile("UI.lua")
LoadFile("ESP.lua")
LoadFile("Fruits.lua")
LoadFile("Combat.lua")
LoadFile("Farm.lua")
LoadFile("Teleport.lua")

print("[CatHUB]: Version 10.0 Fully Deployed.")