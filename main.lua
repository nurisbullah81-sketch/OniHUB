-- CatHUB v8.0: Main Loader
-- Hanya ini dan ESP.lua yang aktif

local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not ok then
        warn("[CatHUB] Gagal load: " .. file)
        return nil
    end
    return result
end

-- Cache sederhana (bisa dipakai semua module nanti)
_G.CatHub = {
    Player = game:GetService("Players").LocalPlayer,
    Settings = {}
}

-- Load ESP saja dulu
Load("ESP.lua")

print("[CatHUB] v8.0 Ready - ESP Only")