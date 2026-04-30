-- Modules/DevilFruits/Webhook.lua
local HttpService = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Me = Players.LocalPlayer
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do task.wait(0.1) end
local UI = _G.Cat.UI
local Settings = _G.Cat.Settings
local Page = UI.TabFrames["Devil Fruits"] -- Numpang di kamar Devil Fruits
local Theme = UI.Theme

-- 1. PASANG UI WEBHOOK
UI.CreateSection(Page, "DISCORD WEBHOOK")
UI.CreateToggle(Page, "Fruit Webhook", "Send alerts to Discord on spawn", Settings.FruitWebhook, function(s) Settings.FruitWebhook = s UI.SaveSettings() end)

local WHConfig = Instance.new("Frame", Page)
WHConfig.LayoutOrder = #Page:GetChildren()
WHConfig.Size = UDim2.new(1, 0, 0, 106)
WHConfig.BackgroundTransparency = 1
local WHConfigLayout = Instance.new("UIListLayout", WHConfig)
WHConfigLayout.Padding = UDim.new(0, 6)
WHConfigLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- URL Box
local WHURLFrame = Instance.new("Frame", WHConfig) WHURLFrame.LayoutOrder = 1 WHURLFrame.Size = UDim2.new(1, 0, 0, 32) WHURLFrame.BackgroundColor3 = Theme.CardBG WHURLFrame.BorderSizePixel = 0
Instance.new("UICorner", WHURLFrame).CornerRadius = UDim.new(0, 6) Instance.new("UIStroke", WHURLFrame).Color = Theme.Line
local WHURLBox = Instance.new("TextBox", WHURLFrame) WHURLBox.Size = UDim2.new(1, -16, 1, 0) WHURLBox.Position = UDim2.new(0, 8, 0, 0) WHURLBox.BackgroundTransparency = 1
WHURLBox.Text = Settings.FruitWebhookURL ~= "" and Settings.FruitWebhookURL or "" WHURLBox.TextColor3 = Theme.Text WHURLBox.PlaceholderText = "Paste Discord Webhook URL here..." WHURLBox.PlaceholderColor3 = Theme.TextDim
WHURLBox.Font = Enum.Font.GothamMedium WHURLBox.TextSize = 11 WHURLBox.TextXAlignment = Enum.TextXAlignment.Left WHURLBox.ClearTextOnFocus = false
WHURLBox.FocusLost:Connect(function() Settings.FruitWebhookURL = WHURLBox.Text UI.SaveSettings() end)

-- Rarity Cycle Button
local WHRarityBtn = Instance.new("TextButton", WHConfig) WHRarityBtn.LayoutOrder = 2 WHRarityBtn.Size = UDim2.new(1, 0, 0, 28) WHRarityBtn.BackgroundColor3 = Theme.SideBG WHRarityBtn.BorderSizePixel = 0
WHRarityBtn.Text = "Rarity: " .. Settings.FruitWebhookRarity WHRarityBtn.TextColor3 = Theme.Text WHRarityBtn.Font = Enum.Font.GothamMedium WHRarityBtn.TextSize = 11 WHRarityBtn.AutoButtonColor = false
Instance.new("UICorner", WHRarityBtn).CornerRadius = UDim.new(0, 6) Instance.new("UIStroke", WHRarityBtn).Color = Theme.Line
local rarityOptions = {"All Fruits", "Legendary & Mythical", "Mythical Only"}
WHRarityBtn.MouseButton1Click:Connect(function()
    local current = Settings.FruitWebhookRarity local nextIndex = 1
    for i, v in ipairs(rarityOptions) do if v == current then nextIndex = (i % #rarityOptions) + 1 break end end
    Settings.FruitWebhookRarity = rarityOptions[nextIndex] WHRarityBtn.Text = "Rarity: " .. rarityOptions[nextIndex] UI.SaveSettings()
end)

-- Test Webhook Button
local WHTestBtn = Instance.new("TextButton", WHConfig) WHTestBtn.LayoutOrder = 3 WHTestBtn.Size = UDim2.new(1, 0, 0, 28) WHTestBtn.BackgroundColor3 = Theme.SideBG WHTestBtn.BorderSizePixel = 0
WHTestBtn.Text = "Test Webhook" WHTestBtn.TextColor3 = Theme.CatPurple WHTestBtn.Font = Enum.Font.GothamBold WHTestBtn.TextSize = 11 WHTestBtn.AutoButtonColor = false
Instance.new("UICorner", WHTestBtn).CornerRadius = UDim.new(0, 6) Instance.new("UIStroke", WHTestBtn).Color = Theme.Line

-- 2. LOGIC WEBHOOK (MURNI DARI CODE LU)
local Webhook = {}

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
                                if data.Rarity then foundRarity = tostring(data.Rarity); return 
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

function Webhook:Send(fruitName, jobId, raritySetting, webhookURL)
    if not webhookURL or webhookURL == "" then return end
    webhookURL = string.gsub(webhookURL, "^%s*(.-)%s*$", "%1") 
    webhookURL = string.gsub(webhookURL, "discord.com", "hooks.hyra.io") -- Proxy Hyra lu
    
    local fruitRarity = GetDynamicRarity(fruitName)
    local shouldSend = false
    if raritySetting == "All Fruits" then shouldSend = true
    elseif raritySetting == "Legendary & Mythical" then if string.find(fruitRarity, "Legendary") or string.find(fruitRarity, "Mythical") then shouldSend = true end
    elseif raritySetting == "Mythical Only" then if string.find(fruitRarity, "Mythical") then shouldSend = true end end
    if not shouldSend then return end
    
    local embedColor = 16777215
    if string.find(fruitRarity, "Legendary") then embedColor = 16753920 elseif string.find(fruitRarity, "Mythical") then embedColor = 16711935 end
    local payload = HttpService:JSONEncode({
        content = "🚨 **FRUIT SPAWN DETECTED** 🚨",
        embeds = {{ title = fruitRarity .. " Fruit: " .. fruitName, description = "**JobID:** `" .. jobId .. "`\n\nUse this JobID to teleport to the server!", color = embedColor, footer = { text = "CatHUB Premium Scanner" } }}
    })
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if req then task.spawn(function() pcall(function() req({Url = webhookURL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload}) end) end) end
end

function Webhook:Test(webhookURL)
    if not webhookURL or webhookURL == "" then return false, "No URL" end
    webhookURL = string.gsub(webhookURL, "^%s*(.-)%s*$", "%1")
    webhookURL = string.gsub(webhookURL, "discord.com", "hooks.hyra.io")
    local payload = HttpService:JSONEncode({
        content = "✅ **CatHUB Webhook Aktif!**",
        embeds = {{ title = "Koneksi Berhasil", description = "Script lu udah terhubung lewat jalur Proxy ke channel Discord ini bang.", color = 32768, footer = { text = "CatHUB Diagnostic" } }}
    })
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not req then return false, "Not Supported" end
    local ok, res = pcall(function() return req({Url = webhookURL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload}) end)
    if not ok then return false, "Pcall Error" end
    if res and (res.StatusCode == 200 or res.StatusCode == 204) then return true, "Success" end
    return false, "HTTP " .. tostring(res.StatusCode)
end

_G.Cat.Webhook = Webhook

-- 3. LOGIC TOMBOL TEST
WHTestBtn.MouseButton1Click:Connect(function()
    WHTestBtn.Text = "Sending..."
    local ok, err = Webhook:Test(Settings.FruitWebhookURL)
    if ok then WHTestBtn.Text = "Test Sent!" else WHTestBtn.Text = "Fail: " .. string.sub(tostring(err), 1, 15) end
    task.wait(2) WHTestBtn.Text = "Test Webhook"
end)

-- 4. CCTV TITANIUM V2 (MURNI DARI CODE LU)
task.spawn(function()
    local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
    while not player do task.wait(0.5) player = Players.LocalPlayer end
    local sentFruits = {}
    local isScannerReady = false
    task.delay(5, function() isScannerReady = true end)
    
    local function CheckForFruit(item)
        if not isScannerReady then return end
        if not Settings.FruitWebhook then return end 
        if item:IsA("Tool") then
            if not item.CanBeDropped then return end 
            local isFruit = false
            local fruitName = item.Name
            local len = string.len(item.Name) local half = math.floor(len / 2)
            if half > 0 then local part1 = string.sub(item.Name, 1, half) local part2 = string.sub(item.Name, half + 2, len) local mid = string.sub(item.Name, half + 1, half + 1) if mid == "-" and part1 == part2 then isFruit = true; fruitName = part1 end end
            if not isFruit and string.find(string.lower(item.Name), "fruit") then isFruit = true; fruitName = string.gsub(item.Name, " Fruit", "") end
            if isFruit then
                if sentFruits[fruitName] then return end
                sentFruits[fruitName] = true
                task.delay(30, function() sentFruits[fruitName] = nil end)
                if _G.Cat.Webhook then local jobId = game.JobId if jobId == "" then jobId = "Singleplayer/Test-Server" end _G.Cat.Webhook:Send(fruitName, jobId, Settings.FruitWebhookRarity, Settings.FruitWebhookURL) end
            end
        end
    end
    player.CharacterAdded:Connect(function(char) char.ChildAdded:Connect(CheckForFruit) local backpack = player:WaitForChild("Backpack", 5) if backpack then backpack.ChildAdded:Connect(CheckForFruit) end end)
    if player.Character then player.Character.ChildAdded:Connect(CheckForFruit) end
    local currentBackpack = player:WaitForChild("Backpack", 5)
    if currentBackpack then currentBackpack.ChildAdded:Connect(CheckForFruit) end
end)