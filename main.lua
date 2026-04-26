-- CatHUB v8.1: Loader
local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local ok, res = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not ok then warn("[CatHUB] Gagal: " .. file) end
    return res
end

_G.CatHub = {
    Player = game:GetService("Players").LocalPlayer,
    Settings = { FruitESP = false }
}

Load("StyleUI.lua")
Load("ESP.lua")

print("[CatHUB] v8.1 Loaded")