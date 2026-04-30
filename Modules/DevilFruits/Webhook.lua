-- [[ ==========================================
--      MODULE: DEVIL FRUIT WEBHOOK ALERT
--    ========================================== ]]

-- // Services
local HttpService = game:GetService("HttpService")
local RS          = game:GetService("ReplicatedStorage")
local Players     = game:GetService("Players")

-- // Variables
local Me = Players.LocalPlayer

-- // Wait for Core System Initialization
repeat 
    task.wait(0.1) 
until _G.Cat 
    and _G.Cat.UI 
    and _G.Cat.Settings

-- // Reference Global Components
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local Theme    = UI.Theme

-- ==========================================
-- 1. UI INITIALIZATION
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)

UI.CreateSection(Page, "DISCORD WEBHOOK")

-- // Main Webhook Toggle
UI.CreateToggle(
    Page, 
    "Fruit Webhook", 
    "Send alerts to Discord on spawn", 
    Settings.FruitWebhook, 
    function(state) 
        Settings.FruitWebhook = state 
    end
)

-- ==========================================
-- 2. WEBHOOK CONFIGURATION UI
-- ==========================================

-- // Main Container Frame
local WHConfig             = Instance.new("Frame", Page)
WHConfig.LayoutOrder       = #Page:GetChildren()
WHConfig.Size              = UDim2.new(1, 0, 0, 106)
WHConfig.BackgroundTransparency = 1

local WHConfigLayout       = Instance.new("UIListLayout", WHConfig)
WHConfigLayout.Padding     = UDim.new(0, 6)
WHConfigLayout.SortOrder   = Enum.SortOrder.LayoutOrder

-- // 2.1: Webhook URL Input Field
local WHURLFrame           = Instance.new("Frame", WHConfig)
WHURLFrame.LayoutOrder     = 1
WHURLFrame.Size            = UDim2.new(1, 0, 0, 38)
WHURLFrame.BackgroundColor3 = Theme.CardBG
WHURLFrame.BorderSizePixel  = 0
Instance.new("UICorner", WHURLFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WHURLFrame).Color        = Theme.Line

local WHURLBox             = Instance.new("TextBox", WHURLFrame)
WHURLBox.Size              = UDim2.new(1, -16, 1, 0)
WHURLBox.Position          = UDim2.new(0, 8, 0, 0)
WHURLBox.BackgroundTransparency = 1
WHURLBox.Text              = Settings.FruitWebhookURL or ""
WHURLBox.TextColor3        = Theme.Text
WHURLBox.PlaceholderText   = "Paste Webhook URL..."
WHURLBox.PlaceholderColor3 = Theme.TextDim
WHURLBox.Font              = Enum.Font.GothamMedium
WHURLBox.TextSize          = 11
WHURLBox.TextXAlignment    = Enum.TextXAlignment.Left
WHURLBox.TextYAlignment    = Enum.TextYAlignment.Center
WHURLBox.ClearTextOnFocus  = false
WHURLBox.ClipsDescendants  = true

WHURLBox.FocusLost:Connect(function() 
    Settings.FruitWebhookURL = WHURLBox.Text 
    UI.SaveSettings() 
end)

-- // 2.2: Rarity Filter Selector
local WHRarityBtn           = Instance.new("TextButton", WHConfig)
WHRarityBtn.LayoutOrder     = 2
WHRarityBtn.Size            = UDim2.new(1, 0, 0, 28)
WHRarityBtn.BackgroundColor3 = Theme.SideBG
WHRarityBtn.BorderSizePixel  = 0
WHRarityBtn.Text            = "Rarity: " .. Settings.FruitWebhookRarity
WHRarityBtn.TextColor3      = Theme.Text
WHRarityBtn.Font            = Enum.Font.GothamMedium
WHRarityBtn.TextSize        = 11
WHRarityBtn.AutoButtonColor = false
Instance.new("UICorner", WHRarityBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WHRarityBtn).Color        = Theme.Line

local rarityOptions = {
    "All Fruits", 
    "Legendary & Mythical", 
    "Mythical Only"
}

WHRarityBtn.MouseButton1Click:Connect(function()
    local current   = Settings.FruitWebhookRarity
    local nextIndex = 1
    
    for i, v in ipairs(rarityOptions) do 
        if v == current then 
            nextIndex = (i % #rarityOptions) + 1 
            break 
        end 
    end
    
    local newRarity = rarityOptions[nextIndex]
    Settings.FruitWebhookRarity = newRarity
    WHRarityBtn.Text            = "Rarity: " .. newRarity
    UI.SaveSettings()
end)

-- // 2.3: Test Webhook Button
local WHTestBtn           = Instance.new("TextButton", WHConfig)
WHTestBtn.LayoutOrder     = 3
WHTestBtn.Size            = UDim2.new(1, 0, 0, 28)
WHTestBtn.BackgroundColor3 = Theme.SideBG
WHTestBtn.BorderSizePixel  = 0
WHTestBtn.Text            = "Test Webhook"
WHTestBtn.TextColor3      = Theme.CatPurple
WHTestBtn.Font            = Enum.Font.GothamBold
WHTestBtn.TextSize        = 11
WHTestBtn.AutoButtonColor = false
Instance.new("UICorner", WHTestBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WHTestBtn).Color        = Theme.Line

-- [[ ==========================================
--      2. WEBHOOK LOGIC (SILENT HANDLER)
--    ========================================== ]]

local Webhook = {}

-- // Function: Determine Fruit Rarity from Name
local function GetDynamicRarity(rawName)
    local name = string.lower(string.gsub(rawName, " Fruit", ""))
    
    local mythical = {
        "kitsune", "tiger", "leopard", "dragon", "venom", 
        "dough", "t-rex", "trex", "mammoth", "spirit", 
        "control", "gravity"
    }
    
    local legendary = {
        "blizzard", "portal", "lightning", "rumble", "pain", 
        "buddha", "quake", "sound", "spider", "string", 
        "love", "phoenix"
    }
    
    -- Check Mythical
    for _, keyword in ipairs(mythical) do 
        if string.find(name, keyword) then return "Mythical" end 
    end
    
    -- Check Legendary
    for _, keyword in ipairs(legendary) do 
        if string.find(name, keyword) then return "Legendary" end 
    end
    
    return "Common"
end

-- // Function: Send Alert to Discord
function Webhook:Send(fruitName, jobId, raritySetting, webhookURL)
    if not (webhookURL and webhookURL ~= "") then return end
    
    -- // 2.1: URL Cleaning & Proxy Injection
    webhookURL = string.gsub(webhookURL, "^%s*(.-)%s*$", "%1") 
    webhookURL = string.gsub(webhookURL, "discord%.com", "webhook.lewisakura.moe")
    
    -- // 2.2: Rarity Filtering Logic
    local fruitRarity = GetDynamicRarity(fruitName) 
    local shouldSend  = false
    
    if raritySetting == "All Fruits" then 
        shouldSend = true 
    elseif raritySetting == "Legendary & Mythical" then 
        if fruitRarity == "Legendary" or fruitRarity == "Mythical" then 
            shouldSend = true 
        end 
    elseif raritySetting == "Mythical Only" then 
        if fruitRarity == "Mythical" then 
            shouldSend = true 
        end 
    end
    
    if not shouldSend then return end
    
    -- // 2.3: Visual Customization (Embed Color)
    local embedColor = 16777215 -- White (Default)
    if fruitRarity == "Legendary" then 
        embedColor = 16753920 -- Orange
    elseif fruitRarity == "Mythical" then 
        embedColor = 16711935 -- Purple/Pink
    end
    
    -- // 2.4: Construct Payload
    local payload = HttpService:JSONEncode({ 
        content = "🚨 **FRUIT SPAWN DETECTED** 🚨", 
        embeds  = {{ 
            title       = string.format("%s Fruit: %s", fruitRarity, fruitName), 
            description = string.format("**JobID:** `%s`\n\nJoin this server to collect!", jobId), 
            color       = embedColor, 
            footer      = { text = "CatHUB Premium Scanner" } 
        }} 
    })
    
    -- // 2.5: Execute HTTP Request
    local requestFunc = (syn and syn.request) 
        or (http and http.request) 
        or http_request 
        or (fluxus and fluxus.request) 
        or request

    if requestFunc then 
        task.spawn(function() 
            pcall(function() 
                return requestFunc({
                    Url     = webhookURL, 
                    Method  = "POST", 
                    Headers = { ["Content-Type"] = "application/json" }, 
                    Body    = payload
                }) 
            end) 
        end) 
    end
end

-- // Function: Test Webhook Connection
function Webhook:Test(webhookURL)
    if not (webhookURL and webhookURL ~= "") then 
        return false, "No URL Provided" 
    end

    webhookURL = string.gsub(webhookURL, "^%s*(.-)%s*$", "%1") 
    webhookURL = string.gsub(webhookURL, "discord%.com", "webhook.lewisakura.moe")
    
    local payload = HttpService:JSONEncode({ 
        content = "✅ **CatHUB Webhook Active!**", 
        embeds  = {{ 
            title       = "Connection Success", 
            description = "Your script is now connected via Proxy to this channel.", 
            color       = 32768, 
            footer      = { text = "CatHUB Diagnostic" } 
        }} 
    })

    local requestFunc = (syn and syn.request) 
        or (http and http.request) 
        or http_request 
        or (fluxus and fluxus.request) 
        or request

    if not requestFunc then return false, "Executor Not Supported" end

    local ok, res = pcall(function() 
        return requestFunc({
            Url     = webhookURL, 
            Method  = "POST", 
            Headers = { ["Content-Type"] = "application/json" }, 
            Body    = payload
        }) 
    end)

    if not ok then return false, "Pcall Internal Error" end
    
    local isSuccess = res and (res.StatusCode == 200 or res.StatusCode == 204)
    if isSuccess then 
        return true, "Success" 
    end

    return false, "HTTP " .. tostring(res.StatusCode)
end

-- // Export to Global
_G.Cat.Webhook = Webhook

-- ==========================================
-- 3. UI CALLBACKS
-- ==========================================
WHTestBtn.MouseButton1Click:Connect(function()
    WHTestBtn.Text = "Sending..." 
    
    local ok, err = Webhook:Test(Settings.FruitWebhookURL) 
    
    if ok then 
        WHTestBtn.Text = "Test Sent!" 
    else 
        WHTestBtn.Text = "Fail: " .. string.sub(tostring(err), 1, 15) 
    end 
    
    task.wait(2) 
    WHTestBtn.Text = "Test Webhook"
end)

-- [[ ==========================================
--      3. CCTV TITANIUM V7 (THE ULTIMATE HANDLE CHECK)
--    ========================================== ]]
task.spawn(function()
    local player = Players.LocalPlayer or Players.PlayerAdded:Wait() 
    
    while not player do 
        task.wait(0.5) 
        player = Players.LocalPlayer 
    end
    
    -- // Variables & Anti-Spam Memory
    local fruitCooldowns = {} 
    
    -- // Function: Core Fruit Identification Logic
    local function CheckForFruit(item)
        if not item:IsA("Tool") then return end 
        
        -- // Validation Gate
        if not Settings.FruitWebhook then return end 
        
        -- // FILTER DEWA 1: Engine Handle Check (Pemisah Kekuatan vs Buah Fisik)
        -- Kasih jeda dikit biar Roblox sempet nge-load isi Tool-nya secara penuh
        task.wait(0.1) 
        if not item:FindFirstChild("Handle") then 
            return -- Fix ini cuma kekuatan/ability lu, buang!
        end
        
        local rawName   = item.Name
        local lowerName = string.lower(rawName)
        
        -- // FILTER 2: Pattern Check
        local hasFruitWord = string.find(lowerName, "fruit")
        local hasHyphen    = string.find(lowerName, "-")
        
        if not (hasFruitWord or hasHyphen) then 
            return 
        end
        
        -- // FILTER 3: Clean Name
        local cleanFruitName = rawName
        
        if hasHyphen then
            local split = string.split(rawName, "-")
            if #split >= 2 and split[1] == split[2] then
                cleanFruitName = split[1]
            end
        elseif hasFruitWord then
            cleanFruitName = string.gsub(rawName, "(%s?)[Ff][Rr][Uu][Ii][Tt]", "")
        end
        
        -- // FILTER 4: Name-Based Cooldown (Anti 3x Notification)
        -- Obat buat nahan notif "Ice" biar kaga ngirim 3 kali pas sistem nge-clone item
        if fruitCooldowns[cleanFruitName] then return end 
        fruitCooldowns[cleanFruitName] = true 
        
        task.delay(15, function() 
            fruitCooldowns[cleanFruitName] = nil 
        end)
        
        -- // EXECUTION: Trigger Webhook
        if _G.Cat.Webhook then 
            local jobId = game.JobId 
            if jobId == "" then jobId = "Local-Server/Studio" end 
            
            _G.Cat.Webhook:Send(
                cleanFruitName, 
                jobId, 
                Settings.FruitWebhookRarity, 
                Settings.FruitWebhookURL
            ) 
        end
    end
    
    -- // 3.1: Event Listeners (Backpack & Character)
    local function ConnectListeners(char)
        -- Track items added to character (Equipped)
        char.ChildAdded:Connect(CheckForFruit) 
        
        -- Track items added to backpack
        local backpack = player:WaitForChild("Backpack", 5) 
        if backpack then 
            backpack.ChildAdded:Connect(CheckForFruit) 
        end 
    end
    
    player.CharacterAdded:Connect(ConnectListeners)
    
    -- // Initial connection for current session
    if player.Character then 
        ConnectListeners(player.Character) 
    end
end)