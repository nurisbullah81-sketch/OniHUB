-- CatHUB SUPREMACY v11.0: THE FINAL ARCHIVE
_G.CatHUB_Loaded = true

local function GetFile(name)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"..name.."?v="..math.random()
    local s, r = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not s then warn("[CatHUB]: Critical Error on "..name.." -> "..tostring(r)) end
    return r
end

-- LOADING SEQUENCE
_G.UI_Lib = GetFile("UI.lua")
GetFile("ESP.lua")
GetFile("Fruits.lua")
GetFile("Combat.lua")
GetFile("Farm.lua")
GetFile("Teleport.lua")

print("[CatHUB]: v11.0 Reality Override Fully Deployed.")