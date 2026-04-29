local HttpService = game:GetService("HttpService")

local Webhook = {}

-- ==========================================
-- 1. DATABASE RARITY (BLOX FRUITS)
-- ==========================================
Webhook.Rarities = {
    Mythical = {"Kitsune", "Leopard", "T-Rex", "Dragon", "Venom", "Shadow", "Spirit", "Control", "Gravity", "Paw", "Dough", "Mama"},
    Legendary = {"Quake", "Buddha", "Rumble", "Phoenix", "String", "Dark", "Ice", "Light", "Magma", "Flame", "Sand", "Rubber"}
}

-- ==========================================
-- 2. DATABASE THUMBNAIL (FOTO BUAH)
-- ==========================================
-- Ganti URL ini dengan link gambar buah yang lu mau. 
-- Cara dapetin: Klik kanan gambar buah di Wiki Blox Fruits -> Copy Image Address (harus ujungnya .png/.webp)
Webhook.Thumbnails = {
    ["Kitsune"] = "https://static.wikia.nocookie.net/roblox-blox-piece/images/5/5a/KitsuneFruit.png", -- CONTOH
    ["Leopard"] = "https://static.wikia.nocookie.net/roblox-blox-piece/images/5/5a/LeopardFruit.png", -- CONTOH
    -- Tambahin sisanya sesuai wiki...
    ["Default"] = "https://static.wikia.nocookie.net/roblox/images/5/5a/DevilFruitIcon.png" -- Fallback kalau buah ga ada di database
}

-- ==========================================
-- 3. FUNGSI CEK RARITY
-- ==========================================
local function GetRarity(fruitName)
    local name = string.lower(fruitName)
    for _, mythName in ipairs(Webhook.Rarities.Mythical) do
        if string.find(name, string.lower(mythName)) then return "Mythical" end
    end
    for _, legName in ipairs(Webhook.Rarities.Legendary) do
        if string.find(name, string.lower(legName)) then return "Legendary" end
    end
    return "Common"
end

-- ==========================================
-- 4. FUNGSI KIRIM WEBHOOK (EMBED PREMIUM)
-- ==========================================
function Webhook:Send(fruitName, jobId, raritySetting, webhookURL)
    if not webhookURL or webhookURL == "" then return end
    
    local fruitRarity = GetRarity(fruitName)
    local shouldSend = false
    
    if raritySetting == "All Fruits" then
        shouldSend = true
    elseif raritySetting == "Legendary & Mythical" then
        if fruitRarity == "Legendary" or fruitRarity == "Mythical" then shouldSend = true end
    elseif raritySetting == "Mythical Only" then
        if fruitRarity == "Mythical" then shouldSend = true end
    end
    
    if not shouldSend then return end
    
    -- Cari gambar buah
    local thumbURL = Webhook.Thumbnails["Default"]
    for key, url in pairs(Webhook.Thumbnails) do
        if string.find(string.lower(fruitName), string.lower(key)) then
            thumbURL = url
            break
        end
    end
    
    -- Warna embed berdasarkan rarity
    local embedColor = 16777215 -- Putih (Common)
    if fruitRarity == "Legendary" then embedColor = 16753920 -- Oranye
    elseif fruitRarity == "Mythical" then embedColor = 16711935 -- Magenta/Pink
    end
    
    local data = HttpService:JSONEncode({
        embeds = {{
            title = "🚨 " .. fruitRarity .. " Fruit Detected! 🚨",
            description = "**Fruit:** " .. fruitName .. "\n**JobID:** `" .. jobId .. "`\n\nUse this JobID to teleport to the server!",
            color = embedColor,
            thumbnail = {
                url = thumbURL
            },
            footer = {
                text = "CatHUB Premium Scanner"
            }
        }}
    })
    
    pcall(function()
        HttpService:PostAsync(webhookURL, data)
    end)
end

-- Daftarin ke Global biar Devil_Fruits bisa akses
_G.Cat.Webhook = Webhook

return Webhook