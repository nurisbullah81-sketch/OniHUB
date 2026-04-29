local HttpService = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")

if not _G.Cat then _G.Cat = {} end

local Webhook = {}

-- ==========================================
-- FUNGSI DEWA: NYEDOT DATA DARI OTAK GAME
-- ==========================================
local function GetDynamicRarity(rawFruitName)
    local cleanName = string.lower(string.gsub(rawFruitName, " Fruit", ""))
    local foundRarity = "Common"
    
    pcall(function()
        local targets = {
            RS:FindFirstChild("FruitInfo"),
            RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Asset") and RS.Modules.Asset:FindFirstChild("ItemData"),
            RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Asset") and RS.Modules.Asset:FindFirstChild("ItemData") and RS.Modules.Asset.ItemData:FindFirstChild("Demon Fruit")
        }
        
        for _, mod in pairs(targets) do
            if mod and mod:IsA("ModuleScript") then
                local dict = require(mod)
                if type(dict) == "table" then
                    for internalName, data in pairs(dict) do
                        if type(internalName) == "string" and string.find(string.lower(internalName), cleanName) then
                            if type(data) == "table" then
                                if data.Rarity then
                                    foundRarity = tostring(data.Rarity)
                                    return 
                                elseif data.Price or data.Cost then
                                    local price = data.Price or data.Cost
                                    if price >= 2000000 then foundRarity = "Mythical"; return end
                                    if price >= 1000000 then foundRarity = "Legendary"; return end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    return foundRarity
end

-- ==========================================
-- CORE WEBHOOK SENDER (BYPASS DISCORD + PROXY)
-- ==========================================
function Webhook:Send(fruitName, jobId, raritySetting, webhookURL)
    if not webhookURL or webhookURL == "" then return end
    
    -- [RAHASIA BYPASS]: Ubah discord.com jadi Proxy Hyra biar kaga diblokir
    webhookURL = string.gsub(webhookURL, "^%s*(.-)%s*$", "%1") 
    webhookURL = string.gsub(webhookURL, "discord.com", "hooks.hyra.io")
    
    local fruitRarity = GetDynamicRarity(fruitName)
    local shouldSend = false
    
    if raritySetting == "All Fruits" then
        shouldSend = true
    elseif raritySetting == "Legendary & Mythical" then
        if string.find(fruitRarity, "Legendary") or string.find(fruitRarity, "Mythical") then shouldSend = true end
    elseif raritySetting == "Mythical Only" then
        if string.find(fruitRarity, "Mythical") then shouldSend = true end
    end
    
    if not shouldSend then return end
    
    local embedColor = 16777215
    if string.find(fruitRarity, "Legendary") then embedColor = 16753920
    elseif string.find(fruitRarity, "Mythical") then embedColor = 16711935
    end
    
    local payload = HttpService:JSONEncode({
        content = "🚨 **FRUIT SPAWN DETECTED** 🚨",
        embeds = {{
            title = fruitRarity .. " Fruit: " .. fruitName,
            description = "**JobID:** `" .. jobId .. "`\n\nUse this JobID to teleport to the server!",
            color = embedColor,
            footer = { text = "CatHUB Premium Scanner" }
        }}
    })
    
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if req then
        task.spawn(function()
            pcall(function() 
                req({
                    Url = webhookURL,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = payload
                })
            end)
        end)
    end
end

-- ==========================================
-- DEBUGGER & TESTER (DENGAN PROXY)
-- ==========================================
function Webhook:Test(webhookURL)
    if not webhookURL or webhookURL == "" then 
        warn("[CatHUB] URL Webhook kosong bang!")
        return false, "No URL" 
    end
    
    -- [RAHASIA BYPASS]: Pakai Proxy buat ngetes!
    webhookURL = string.gsub(webhookURL, "^%s*(.-)%s*$", "%1")
    webhookURL = string.gsub(webhookURL, "discord.com", "hooks.hyra.io")
    
    warn("[CatHUB] Mencoba kirim tes ke Proxy: " .. webhookURL)

    local payload = HttpService:JSONEncode({
        content = "✅ **CatHUB Webhook Aktif!**",
        embeds = {{
            title = "Koneksi Berhasil",
            description = "Script lu udah terhubung lewat jalur Proxy ke channel Discord ini bang.",
            color = 32768,
            footer = { text = "CatHUB Diagnostic" }
        }}
    })
    
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    
    if not req then
        warn("[CatHUB] ERROR: Executor lu kaga support fungsi HTTP Request.")
        return false, "Not Supported"
    end
    
    local ok, res = pcall(function() 
        return req({
            Url = webhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = payload
        })
    end)
    
    if not ok then
        warn("[CatHUB] PCALL ERROR: " .. tostring(res))
        return false, "Pcall Error"
    end
    
    if res then
        if res.StatusCode == 200 or res.StatusCode == 204 then
            warn("[CatHUB] SUKSES TEMBUS PROXY! Cek Discord lu bang.")
            return true, "Success"
        else
            warn("[CatHUB] PROXY/DISCORD NOLAK! Status Code: " .. tostring(res.StatusCode))
            warn("[CatHUB] Alasan Nolak: " .. tostring(res.Body))
            return false, "HTTP " .. tostring(res.StatusCode)
        end
    else
        warn("[CatHUB] ERROR: Tidak ada respon.")
        return false, "No Response"
    end
end

_G.Cat.Webhook = Webhook
return Webhook