local HttpService = game:GetService("HttpService")

local Webhook = {}

-- ==========================================
-- 1. DATABASE RARITY (Hanya buat filter. Nama di Discord otomatis dari Game)
-- ==========================================
-- Kalau ada buah baru besok, lu cuma perlu nambahin disini.
-- Kalau lu milih "All Fruits", daftar ini diabaikan (semua kekirim).
Webhook.Rarities = {
    Mythical = {"Kitsune", "Leopard", "T-Rex", "Dragon", "Venom", "Shadow", "Spirit", "Control", "Gravity", "Dough"},
    Legendary = {"Quake", "Buddha", "Rumble", "Phoenix", "String", "Dark", "Ice", "Light", "Magma", "Flame"}
}

-- ==========================================
-- 2. DATABASE THUMBNAIL (Opsional)
-- ==========================================
-- Masukin link gambar kalau mau keren. Kalau ga ada, otomatis pakai gambar Default.
Webhook.Thumbnails = {
    -- ["Venom"] = "LINK GAMBAR VENOM SINI",
    -- ["Dragon"] = "LINK GAMBAR DRAGON SINI",
    ["Default"] = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Question_mark_%28black%29.svg/800px-Question_mark_%28black%29.svg.png"
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
-- 4. FUNGSI KIRIM WEBHOOK
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
    
    -- Cari gambar buah, kalau ga ada pakai default
    local thumbURL = Webhook.Thumbnails["Default"]
    for key, url in pairs(Webhook.Thumbnails) do
        if string.find(string.lower(fruitName), string.lower(key)) then
            thumbURL = url
            break
        end
    end
    
    -- Warna embed
    local embedColor = 16777215 -- Putih
    if fruitRarity == "Legendary" then embedColor = 16753920 -- Oranye
    elseif fruitRarity == "Mythical" then embedColor = 16711935 -- Pink
    end
    
    -- Format Nama Buah Otomatis dari Game (Bukan dari tabel lagi)
    local data = HttpService:JSONEncode({
        embeds = {{
            title = "🚨 " .. fruitRarity .. " Fruit Detected! 🚨",
            description = "**Fruit:** " .. fruitName .. "\n**JobID:** `" .. jobId .. "`\n\nUse this JobID to teleport!",
            color = embedColor,
            thumbnail = { url = thumbURL },
            footer = { text = "CatHUB Premium Scanner" }
        }}
    })
    
    pcall(function() HttpService:PostAsync(webhookURL, data) end)
end

-- Fungsi Test Webhook
function Webhook:Test(webhookURL)
    if not webhookURL or webhookURL == "" then return false end
    local data = HttpService:JSONEncode({
        embeds = {{
            title = "✅ Webhook Test Successful!",
            description = "CatHUB is connected to this channel.",
            color = 32768 -- Hijau
        }}
    })
    local ok, err = pcall(function() HttpService:PostAsync(webhookURL, data) end)
    return ok
end

_G.Cat.Webhook = Webhook
return Webhook