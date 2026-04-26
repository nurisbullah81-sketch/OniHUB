local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local ok, r = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not ok then warn("[CatHUB] Fail: " .. file .. " | " .. tostring(r)) end
    return r
end

Load("StyleUI.lua")
Load("ESP.lua")