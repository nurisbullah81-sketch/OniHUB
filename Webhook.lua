-- ==========================================
-- BUILD TABS & ISI KONTEN
-- ==========================================
local StatusTab = CreateTab("Status", true) 
local AutoFarmTab = CreateTab("Auto Farm", false) 
local DevilFruitsTab = CreateTab("Devil Fruits", false) 
local MiscTab = CreateTab("Misc", false) 

-- STATUS TAB
CreateSection(StatusTab, "PLAYER STATUS")
_G.Cat.Labels.Level = CreateLabel(StatusTab, "Level: ...", "Current level progress")
_G.Cat.Labels.Money = CreateLabel(StatusTab, "Money: ...", "In-game currency balance")
_G.Cat.Labels.Fragments = CreateLabel(StatusTab, "Fragments: ...", "Used for awakening")
_G.Cat.Labels.Bounty = CreateLabel(StatusTab, "Bounty/Honor: ...", "PvP score tracking")

CreateSection(StatusTab, "SERVER STATUS")
_G.Cat.Labels.Players = CreateLabel(StatusTab, "Players: ...", "Currently in this server")
_G.Cat.Labels.Time = CreateLabel(StatusTab, "Time: ...", "In-game day/night cycle")
_G.Cat.Labels.Moon = CreateLabel(StatusTab, "Moon: ...", "Affects certain bosses & events")
_G.Cat.Labels.Fruits = CreateLabel(StatusTab, "Spawned Fruits: 0", "Devil fruits on the map")

-- AUTO FARM TAB
CreateSection(AutoFarmTab, "COMBAT SYSTEM")
CreateToggle(AutoFarmTab, "Auto Attack", "Automatically swing weapon / fight", _G.Cat.Settings.AutoAttack, function(state) _G.Cat.Settings.AutoAttack = state end)

-- DEVIL FRUITS TAB
CreateSection(DevilFruitsTab, "FRUIT FINDER")
CreateToggle(DevilFruitsTab, "Fruit ESP", "Show text on any spawned fruits", _G.Cat.Settings.FruitESP, function(state) _G.Cat.Settings.FruitESP = state end)
CreateToggle(DevilFruitsTab, "Tween to Fruits", "Smoothly fly to collect fruits", _G.Cat.Settings.TweenFruit, function(state) _G.Cat.Settings.TweenFruit = state end)
CreateToggle(DevilFruitsTab, "TP Fruits", "Instant teleport to spawned fruits", _G.Cat.Settings.InstantTPFruit, function(state) _G.Cat.Settings.InstantTPFruit = state end)
CreateToggle(DevilFruitsTab, "Auto Store Fruits", "Store collected fruits to inventory", _G.Cat.Settings.AutoStoreFruit, function(state) _G.Cat.Settings.AutoStoreFruit = state end)
CreateToggle(DevilFruitsTab, "Auto Hop Server", "Hop if no fruits or inventory full", _G.Cat.Settings.AutoHop, function(state) _G.Cat.Settings.AutoHop = state end)

-- DISCORD WEBHOOK SECTION
CreateSection(DevilFruitsTab, "DISCORD WEBHOOK")
CreateToggle(DevilFruitsTab, "Fruit Webhook", "Send alerts to Discord on spawn", _G.Cat.Settings.FruitWebhook, function(state) _G.Cat.Settings.FruitWebhook = state end)

-- Webhook URL Box
local WHURLFrame = Instance.new("Frame", DevilFruitsTab)
WHURLFrame.Size = UDim2.new(1, 0, 0, 32); WHURLFrame.BackgroundColor3 = Theme.CardBG; WHURLFrame.BorderSizePixel = 0
Instance.new("UICorner", WHURLFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WHURLFrame).Color = Theme.Line
local WHURLBox = Instance.new("TextBox", WHURLFrame)
WHURLBox.Size = UDim2.new(1, -16, 1, 0); WHURLBox.Position = UDim2.new(0, 8, 0, 0); WHURLBox.BackgroundTransparency = 1
WHURLBox.Text = _G.Cat.Settings.FruitWebhookURL ~= "" and _G.Cat.Settings.FruitWebhookURL or "Paste Discord Webhook URL here..."
WHURLBox.TextColor3 = Theme.Text; WHURLBox.PlaceholderText = "Paste Discord Webhook URL here..."; WHURLBox.PlaceholderColor3 = Theme.TextDim
WHURLBox.Font = Enum.Font.GothamMedium; WHURLBox.TextSize = 11; WHURLBox.TextXAlignment = Enum.TextXAlignment.Left; WHURLBox.ClearTextOnFocus = false
WHURLBox.FocusLost:Connect(function() _G.Cat.Settings.FruitWebhookURL = WHURLBox.Text SaveSettings() end)

-- Webhook Rarity Cycle Button
local WHRarityBtn = Instance.new("TextButton", DevilFruitsTab)
WHRarityBtn.Size = UDim2.new(1, 0, 0, 28); WHRarityBtn.BackgroundColor3 = Theme.SideBG; WHRarityBtn.BorderSizePixel = 0; WHRarityBtn.Text = "Rarity: " .. _G.Cat.Settings.FruitWebhookRarity; WHRarityBtn.TextColor3 = Theme.Text; WHRarityBtn.Font = Enum.Font.GothamMedium; WHRarityBtn.TextSize = 11; WHRarityBtn.AutoButtonColor = false
Instance.new("UICorner", WHRarityBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WHRarityBtn).Color = Theme.Line

local rarityOptions = {"All Fruits", "Legendary & Mythical", "Mythical Only"}
WHRarityBtn.MouseButton1Click:Connect(function()
    local current = _G.Cat.Settings.FruitWebhookRarity
    local nextIndex = 1
    for i, v in ipairs(rarityOptions) do
        if v == current then nextIndex = (i % #rarityOptions) + 1 break end
    end
    _G.Cat.Settings.FruitWebhookRarity = rarityOptions[nextIndex]
    WHRarityBtn.Text = "Rarity: " .. rarityOptions[nextIndex]
    SaveSettings()
end)

-- Webhook Test Button
local WHTestBtn = Instance.new("TextButton", DevilFruitsTab)
WHTestBtn.Size = UDim2.new(1, 0, 0, 28); WHTestBtn.BackgroundColor3 = Theme.SideBG; WHTestBtn.BorderSizePixel = 0; WHTestBtn.Text = "Test Webhook"; WHTestBtn.TextColor3 = Theme.CatPurple; WHTestBtn.Font = Enum.Font.GothamBold; WHTestBtn.TextSize = 11; WHTestBtn.AutoButtonColor = false
Instance.new("UICorner", WHTestBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WHTestBtn).Color = Theme.Line
WHTestBtn.MouseButton1Click:Connect(function()
    WHTestBtn.Text = "Sending..."
    if _G.Cat.Webhook then
        local ok, err = _G.Cat.Webhook:Test(_G.Cat.Settings.FruitWebhookURL)
        if ok then
            WHTestBtn.Text = "Test Sent!"
        else
            -- TAMPILIN KENAPA GAGAL BIAR LU TAU
            WHTestBtn.Text = "Fail: " .. string.sub(tostring(err), 1, 20)
        end
    else
        WHTestBtn.Text = "Module Missing!"
    end
    task.wait(3)
    WHTestBtn.Text = "Test Webhook"
end)

-- MISC TAB
CreateToggle(MiscTab, "Anti AFK", "Prevents 20-minute idle kick", _G.Cat.Settings.AntiAFK, function(state) _G.Cat.Settings.AntiAFK = state end)