-- CatHUB FREEMIUM: Loader Utama
-- Entry Point: nurisbullah81-sketch/OniHUB

local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then 
        warn("[CatHUB]: Gagal memuat modul " .. file .. " -> " .. tostring(result)) 
    end
    return result
end

-- Inisialisasi Urutan Loading
_G.CatHUB_UI = Load("UI.lua")
Load("ESP.lua")
Load("Combat.lua")
Load("Teleport.lua")

print("[CatHUB]: Seluruh sistem modular v3.5 telah aktif.")