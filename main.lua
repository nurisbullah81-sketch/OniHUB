-- CatHUB FREEMIUM: Main Loader v5.0
-- GitHub: nurisbullah81-sketch/OniHUB

local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then 
        warn("[CatHUB]: Critical Load Failure -> " .. file .. " | " .. tostring(result)) 
    end
    return result
end

-- Shared Environment Initialization
_G.CatHUB_Loaded = true
_G.CatHUB_UI = Load("UI.lua")
Load("ESP.lua")
Load("Combat.lua")
Load("Teleport.lua")

print("[CatHUB]: v5.0 Elite Intelligence Fully Deployed.")