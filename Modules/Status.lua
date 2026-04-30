-- [[ ==========================================
--      MODULE: PLAYER & SERVER STATUS
--    ========================================== ]]

-- // Services
local Players  = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- // Wait for Core System Initialization
repeat 
    task.wait(0.1) 
until _G.Cat 
    and _G.Cat.UI 
    and _G.Cat.Settings

-- // Reference Global Components
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local Player   = _G.Cat.Player

-- ==========================================
-- 1. UI INITIALIZATION
-- ==========================================
local Page = UI.CreateTab("Status", true)

-- // 1.1: Player Status Section
UI.CreateSection(Page, "PLAYER STATUS")

_G.Cat.Labels.Level = UI.CreateLabel(
    Page, 
    "Level: ...", 
    "Current level progress"
)

_G.Cat.Labels.Money = UI.CreateLabel(
    Page, 
    "Money: ...", 
    "In-game currency balance"
)

_G.Cat.Labels.Fragments = UI.CreateLabel(
    Page, 
    "Fragments: ...", 
    "Used for awakening"
)

_G.Cat.Labels.Bounty = UI.CreateLabel(
    Page, 
    "Bounty/Honor: ...", 
    "PvP score tracking"
)

-- // 1.2: Server Status Section
UI.CreateSection(Page, "SERVER STATUS")

_G.Cat.Labels.Players = UI.CreateLabel(
    Page, 
    "Players: ...", 
    "Currently in this server"
)

_G.Cat.Labels.Time = UI.CreateLabel(
    Page, 
    "Time: ...", 
    "In-game day/night cycle"
)

_G.Cat.Labels.Moon = UI.CreateLabel(
    Page, 
    "Moon: ...", 
    "Affects certain bosses & events"
)

_G.Cat.Labels.Fruits = UI.CreateLabel(
    Page, 
    "Spawned Fruits: 0", 
    "Devil fruits on the map"
)

-- ==========================================
-- 2. UTILITY FUNCTIONS (FORMATTING)
-- ==========================================
local Labels = _G.Cat.Labels

-- // Function: Format number with commas (e.g., 1,000,000)
local function FormatNum(num)
    local value = tonumber(num) or 0
    value       = math.floor(value)
    
    local formatted = tostring(value)
    local k
    
    while true do 
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2') 
        if k == 0 then break end 
    end
    
    return formatted
end

-- // Function: Safely extract numeric value from ValueBase
local function ReadValue(obj)
    if not obj then return 0 end
    
    if obj:IsA("ValueBase") then 
        local val = obj.Value 
        
        -- Handle Number/Int types
        if type(val) == "number" then 
            return val 
        end 
        
        -- Handle String types (Extract first digits)
        if type(val) == "string" then 
            local match = string.match(val, "%d+") 
            return tonumber(match) or 0 
        end 
    end
    
    return 0
end

-- [[ ==========================================
--      3. BACKGROUND TASK: STATUS TRACKER
--    ========================================== ]]

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- // 3.1: Initialize Data Buffers
            local leaderstats = Player:FindFirstChild("leaderstats")
            local dataFolder  = Player:FindFirstChild("Data")
            
            local lvl, lvlName       = 0, "Level" 
            local money, moneyName   = 0, "Money" 
            local frag, fragName     = 0, "Fragments" 
            local bounty, bountyName = 0, "Bounty"

            -- // 3.2: Internal Scanner Function
            local function ScanFolder(folder)
                if not folder then return end
                
                for _, child in ipairs(folder:GetChildren()) do
                    if child:IsA("ValueBase") then 
                        local rawName = string.lower(child.Name) 
                        local clean   = string.gsub(rawName, "%W", "") 
                        local val     = ReadValue(child)
                        
                        -- Match Level/LVL
                        if string.find(clean, "level") or string.find(clean, "lvl") then 
                            lvl     = val
                            lvlName = child.Name
                        
                        -- Match Bounty/Honor
                        elseif string.find(clean, "bounty") or string.find(clean, "honor") then 
                            bounty     = val
                            bountyName = child.Name
                        
                        -- Match Fragments
                        elseif string.find(clean, "frag") then 
                            frag     = val
                            fragName = child.Name
                        
                        -- Match Money/Belly/Cash/$
                        elseif rawName == "$" 
                            or string.find(clean, "money") 
                            or string.find(clean, "belly") 
                            or string.find(clean, "cash") then 
                            
                            money     = val
                            moneyName = child.Name
                        
                        -- Fallback for generic money values
                        elseif val > 0 and money == 0 then 
                            money     = val
                            moneyName = child.Name 
                        end
                    end
                end
            end

            -- Execute Scanning
            ScanFolder(leaderstats) 
            ScanFolder(dataFolder)

            -- // 3.3: Update Player Labels
            Labels.Level.Text     = string.format("Level: %s", FormatNum(lvl))
            Labels.Fragments.Text = string.format("Fragments: %s", FormatNum(frag))
            Labels.Bounty.Text    = string.format("%s: %s", bountyName, FormatNum(bounty))

            local displayMoney    = (moneyName == "$" or string.lower(moneyName) == "money") 
                and "Money" 
                or moneyName
            
            Labels.Money.Text     = string.format("%s: $%s", displayMoney, FormatNum(money))

            -- // 3.4: Update Server & Environment Labels
            Labels.Players.Text   = string.format("Players: %d", #Players:GetPlayers())
            
            -- Time Calculation
            local clockTime = Lighting.ClockTime 
            local hours     = math.floor(clockTime) 
            local mins      = math.floor((clockTime % 1) * 60) 
            local timeStr   = string.format("%02d:%02d", hours, mins)
            
            if clockTime >= 18 or clockTime < 6 then
                -- Night Time Logic
                Labels.Time.Text = string.format("Time: %s (Night)", timeStr)
                
                local isFull = Lighting.Brightness >= 2 
                Labels.Moon.Text = isFull and "Moon: Full Moon" or "Moon: No Full Moon"
            else 
                -- Day Time Logic
                Labels.Time.Text = string.format("Time: %s (Day)", timeStr)
                Labels.Moon.Text = "Moon: -" 
            end

            -- // 3.5: Fruit ESP Sync
            local hasESP     = _G.Cat.ESP and _G.Cat.ESP.GetFruitsList
            local fruitList  = hasESP and _G.Cat.ESP.GetFruitsList() or {}
            
            if #fruitList > 0 then 
                local fruitText = table.concat(fruitList, ", ") 
                
                -- Truncate long strings to fit UI
                if string.len(fruitText) > 35 then 
                    fruitText = string.sub(fruitText, 1, 35) .. "..." 
                end 
                
                Labels.Fruits.Text = string.format("Fruits: %s", fruitText) 
            else 
                Labels.Fruits.Text = "Fruits: None" 
            end
        end)
    end
end)

-- ==========================================
-- 🔥 FITUR PLAYER SCANNER (X-RAY INVENTORY) 🔥
-- ==========================================

-- Bikin bagian baru di bawah Server Status
UI.CreateSection(Page, "PLAYER SCANNER")

-- 1. KOTAK INPUT NAMA TARGET
local ScanInputFrame = Instance.new("Frame", Page)
ScanInputFrame.LayoutOrder = #Page:GetChildren()
ScanInputFrame.Size = UDim2.new(1, 0, 0, 38)
ScanInputFrame.BackgroundColor3 = Theme.CardBG
ScanInputFrame.BorderSizePixel = 0
Instance.new("UICorner", ScanInputFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ScanInputFrame).Color = Theme.Line

local ScanTextBox = Instance.new("TextBox", ScanInputFrame)
ScanTextBox.Size = UDim2.new(1, -16, 1, 0)
ScanTextBox.Position = UDim2.new(0, 8, 0, 0)
ScanTextBox.BackgroundTransparency = 1
ScanTextBox.TextColor3 = Theme.Text
ScanTextBox.PlaceholderText = "Ketik nama/nickname player di sini..."
ScanTextBox.PlaceholderColor3 = Theme.TextDim
ScanTextBox.Font = Enum.Font.GothamMedium
ScanTextBox.TextSize = 11
ScanTextBox.TextXAlignment = Enum.TextXAlignment.Left
ScanTextBox.ClearTextOnFocus = false

-- 2. LAYAR MONITOR HASIL SCAN
local ScanResultFrame = Instance.new("Frame", Page)
ScanResultFrame.LayoutOrder = #Page:GetChildren()
ScanResultFrame.Size = UDim2.new(1, 0, 0, 140) -- Cukup buat nampung 6 baris
ScanResultFrame.BackgroundColor3 = Theme.CardBG
ScanResultFrame.BorderSizePixel = 0
Instance.new("UICorner", ScanResultFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ScanResultFrame).Color = Theme.Line

local ResultLayout = Instance.new("UIListLayout", ScanResultFrame)
ResultLayout.Padding = UDim.new(0, 4)
ResultLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ResultLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Fungsi bantu biar kodenya rapi bikin text
local function CreateResultLabel(text, color, font)
    local lbl = Instance.new("TextLabel", ScanResultFrame)
    lbl.Size = UDim2.new(1, -20, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Theme.TextDim
    lbl.Font = font or Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    return lbl
end

-- Bikin baris-baris datanya
local LblTarget = CreateResultLabel("🎯 Target: Belum ada", Theme.CatPurple, Enum.Font.GothamBold)
local LblRace   = CreateResultLabel("🧬 Race: -")
local LblMelee  = CreateResultLabel("👊 Melee: -")
local LblFruit  = CreateResultLabel("🍎 Fruit: -")
local LblSword  = CreateResultLabel("🗡️ Sword: -")
local LblGun    = CreateResultLabel("🔫 Gun: -")

-- 3. TOMBOL EKSEKUSI SCAN
local ScanBtn = Instance.new("TextButton", Page)
ScanBtn.LayoutOrder = #Page:GetChildren()
ScanBtn.Size = UDim2.new(1, 0, 0, 28)
ScanBtn.BackgroundColor3 = Theme.SideBG
ScanBtn.BorderSizePixel = 0
ScanBtn.Text = "🔍 Scan Player"
ScanBtn.TextColor3 = Theme.Text
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 11
ScanBtn.AutoButtonColor = false
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ScanBtn).Color = Theme.Line

-- 4. MESIN INTELIJENNYA (LOGIKA)
ScanBtn.MouseButton1Click:Connect(function()
    ScanBtn.Text = "Membobol Data..."
    local targetStr = string.lower(ScanTextBox.Text)
    local foundPlayer = nil
    
    -- Fitur Smart Search: Lu ngetik "brax" doang, script bakal nyari "Braxlaw50"
    if targetStr ~= "" then
        for _, p in pairs(Players:GetPlayers()) do
            if string.find(string.lower(p.Name), targetStr) or string.find(string.lower(p.DisplayName), targetStr) then
                foundPlayer = p
                break
            end
        end
    end
    
    if not foundPlayer then
        LblTarget.Text = "🎯 Target: Kaga Ketemu Bang!"
        LblRace.Text = "🧬 Race: -"
        LblMelee.Text = "👊 Melee: -"
        LblFruit.Text = "🍎 Fruit: -"
        LblSword.Text = "🗡️ Sword: -"
        LblGun.Text = "🔫 Gun: -"
        task.wait(1)
        ScanBtn.Text = "🔍 Scan Player"
        return
    end
    
    -- Siapin wadah kosong
    local pData = { Race = "Unknown", Melee = "Kopong", Fruit = "Kopong", Sword = "Kopong", Gun = "Kopong" }
    
    -- Nyadap Race dari folder Data (Tembus karena dikirim ke Client)
    if foundPlayer:FindFirstChild("Data") and foundPlayer.Data:FindFirstChild("Race") then
        pData.Race = foundPlayer.Data.Race.Value
    end
    
    -- Fungsi bongkar isi tas dan tangan pakai ToolTip
    local function BongkarTas(container)
        if not container then return end
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local tType = item.ToolTip
                if tType == "Melee" then pData.Melee = item.Name
                elseif tType == "Blox Fruit" then pData.Fruit = item.Name
                elseif tType == "Sword" then pData.Sword = item.Name
                elseif tType == "Gun" then pData.Gun = item.Name
                end
            end
        end
    end
    
    -- Eksekusi pembongkaran
    BongkarTas(foundPlayer:FindFirstChild("Backpack"))
    if foundPlayer.Character then
        BongkarTas(foundPlayer.Character)
    end
    
    -- Tembak ke Layar UI lu
    LblTarget.Text = "🎯 Target: " .. foundPlayer.Name
    LblRace.Text = "🧬 Race: " .. tostring(pData.Race)
    LblMelee.Text = "👊 Melee: " .. tostring(pData.Melee)
    LblFruit.Text = "🍎 Fruit: " .. tostring(pData.Fruit)
    LblSword.Text = "🗡️ Sword: " .. tostring(pData.Sword)
    LblGun.Text = "🔫 Gun: " .. tostring(pData.Gun)
    
    task.wait(0.5)
    ScanBtn.Text = "🔍 Scan Player"
end)