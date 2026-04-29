local HttpService = game:GetService("HttpService")

local Webhook = {}

Webhook.Rarities = {
    Mythical = {"Kitsune", "Leopard", "T-Rex", "Dragon", "Venom", "Shadow", "Spirit", "Control", "Gravity", "Dough"},
    Legendary = {"Quake", "Buddha", "Rumble", "Phoenix", "String", "Dark", "Ice", "Light", "Magma", "Flame"}
}

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

-- FUNGSI HTTP EXECUTOR (INI YANG BENER, DIPAKE THAN/NAT HUB)
local function sendRequest(url, data)
    local json = HttpService:JSONEncode(data)
    
    -- Deteksi fungsi request bawaan executor (Solara, Xeno, Fluxus, etc)
    local reqFunc = http_request or request or HttpPost or syn.request or fluxus.request
    
    if reqFunc then
        -- PAKAI INI: Bisa kirim Content-Type: application/json, Discord pasti terima!
        reqFunc({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    else
        -- FALLBACK: Kalau executor blok semua, coba pakai HttpService biasa (Kemungkinan besar gagal ke Discord)
        pcall(function()
            HttpService:PostAsync(url, json, Enum.HttpPriority.Default, false, {["Content-Type"] = "application/json"})
        end)
    end
end

function Webhook:Send(fruitName, jobId, raritySetting, webhookURL)
    if not webhookURL or webhookURL == "" then return end
    
    local fruitRarity = GetRarity(fruitName)
    local shouldSend = false
    
    if raritySetting == "All Fruits" then shouldSend = true
    elseif raritySetting == "Legendary & Mythical" then if fruitRarity == "Legendary" or fruitRarity == "Mythical" then shouldSend = true end
    elseif raritySetting == "Mythical Only" then if fruitRarity == "Mythical" then shouldSend = true end
    end
    
    if not shouldSend then return end
    
    local embedColor = 16777215
    if fruitRarity == "Legendary" then embedColor = 16753920
    elseif fruitRarity == "Mythical" then embedColor = 16711935
    end
    
    local data = {
        embeds = {{
            title = "🚨 " .. fruitRarity .. " Fruit Detected! 🚨",
            description = "**Fruit:** " .. fruitName .. "\n**JobID:** `" .. jobId .. "`\n\nUse this JobID to teleport!",
            color = embedColor,
            footer = { text = "CatHUB Premium Scanner" }
        }}
    }
    
    pcall(function() sendRequest(webhookURL, data) end)
end

function Webhook:Test(webhookURL)
    if not webhookURL or webhookURL == "" then return false, "No URL" end
    local data = {
        embeds = {{
            title = "✅ Webhook Test Successful!",
            description = "CatHUB is connected to this channel.",
            color = 32768
        }}
    }
    local ok, err = pcall(function() sendRequest(webhookURL, data) end)
    return ok, tostring(err)
end

_G.Cat.Webhook = Webhook
return Webhook