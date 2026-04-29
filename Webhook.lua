local HttpService = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")

local Webhook = {}

-- ==========================================
-- FUNGSI DEWA: NYEDOT DATA DARI OTAK GAME
-- ==========================================
local function GetDynamicRarity(rawFruitName)
    -- Bersihin embel-embel " Fruit" biar gampang dicocokin (misal: "Tiger Fruit" -> "tiger")
    local cleanName = string.lower(string.gsub(rawFruitName, " Fruit", ""))
    
    local foundRarity = "Common" -- Default kalau apes ga nemu
    
    pcall(function()
        -- 3 Jalur Jackpot dari hasil scan lu:
        local targets = {
            RS:FindFirstChild("FruitInfo"),
            RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Asset") and RS.Modules.Asset:FindFirstChild("ItemData"),
            RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Asset") and RS.Modules.Asset:FindFirstChild("ItemData") and RS.Modules.Asset.ItemData:FindFirstChild("Demon Fruit")
        }
        
        for _, mod in pairs(targets) do
            if mod and mod:IsA("ModuleScript") then
                local dict = require(mod)
                if type(dict) == "table" then
                    -- Bedah isi modulnya
                    for internalName, data in pairs(dict) do
                        if type(internalName) == "string" and string.find(string.lower(internalName), cleanName) then
                            if type(data) == "table" then
                                -- Kalau developer nulis Rarity secara gamblang
                                if data.Rarity then
                                    foundRarity = tostring(data.Rarity)
                                    return -- Stop looping, target udah dapet!
                                    
                                -- Kalau Rarity dienkripsi, kita baca Harganya buat nentuin kasta
                                elseif data.Price or data.Cost then
                                    local price = data.Price or data.Cost
                                    if price >= 2000000 then 
                                        foundRarity = "Mythical" 
                                        return 
                                    end
                                    if price >= 1000000 then 
                                        foundRarity = "Legendary" 
                                        return 
                                    end
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
-- CORE WEBHOOK SENDER (BYPASS DISCORD)
-- ==========================================
function Webhook:Send(fruitName, jobId, raritySetting, webhookURL)
    if not webhookURL or webhookURL == "" then return end
    
    -- Proses deteksi Rarity pakai fungsi dewa
    local fruitRarity = GetDynamicRarity(fruitName)
    local shouldSend = false
    
    -- Filter logika dari UI lu
    if raritySetting == "All Fruits" then
        shouldSend = true
    elseif raritySetting == "Legendary & Mythical" then
        if string.find(fruitRarity, "Legendary") or string.find(fruitRarity, "Mythical") then shouldSend = true end
    elseif raritySetting == "Mythical Only" then
        if string.find(fruitRarity, "Mythical") then shouldSend = true end
    end
    
    if not shouldSend then return end
    
    -- Atur warna Embed Discord
    local embedColor = 16777215 -- Putih (Common/Rare)
    if string.find(fruitRarity, "Legendary") then embedColor = 16753920 -- Oranye
    elseif string.find(fruitRarity, "Mythical") then embedColor = 16711935 -- Pink/Ungu
    end
    
    local payload = HttpService:JSONEncode({
        embeds = {{
            title = "🚨 " .. fruitRarity .. " Fruit Detected! 🚨",
            description = "**Fruit:** " .. fruitName .. "\n**JobID:** `" .. jobId .. "`\n\nUse this JobID to teleport!",
            color = embedColor,
            footer = { text = "CatHUB Premium Scanner" }
        }}
    })
    
    -- BACKDOOR EXECUTOR: Nembus blokiran API Discord
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
    else
        warn("[CatHUB] Executor lu kaga support HTTP Request bang!")
    end
end

-- ==========================================
-- TESTER KONEKSI
-- ==========================================
function Webhook:Test(webhookURL)
    if not webhookURL or webhookURL == "" then return false, "No URL" end
    
    local payload = HttpService:JSONEncode({
        embeds = {{
            title = "✅ Webhook Test Successful!",
            description = "CatHUB is perfectly connected to this channel.",
            color = 32768
        }}
    })
    
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if req then
        local ok, res = pcall(function() 
            return req({
                Url = webhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = payload
            })
        end)
        
        if ok and res and (res.StatusCode == 200 or res.StatusCode == 204) then
            return true, "Success"
        end
    end
    
    return false, "Failed"
end

_G.Cat.Webhook = Webhook
return Webhook