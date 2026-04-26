local function Load(f)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. f .. "?v=" .. math.random()
    local ok, r = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not ok then warn("[CatHUB] Fail: " .. f) end
    return r
end

_G.Cat = {
    Player = game:GetService("Players").LocalPlayer,
    Settings = { FruitESP = false }
}

Load("StyleUI.lua")
Load("ESP.lua")