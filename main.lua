-- CatHUB SUPREMACY v12.0: The Final Restoration
_G.CatHUB_Loaded = true

local function GetFile(name)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"..name.."?v="..math.random()
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then 
        warn("[CatHUB]: Critical Error on "..name.." -> "..tostring(result)) 
    end
    return result
end

-- LOADING ORDER (Pastiin urutan ini bener)
_G.UI_Lib = GetFile("UI.lua")
GetFile("ESP.lua")
GetFile("Fruits.lua")
GetFile("Combat.lua")
GetFile("Farm.lua")
GetFile("Teleport.lua")

print("[CatHUB]: v12.0 Absolute Power Deployed.")