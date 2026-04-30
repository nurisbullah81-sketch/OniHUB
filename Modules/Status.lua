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

-- [[ ==========================================
--      MODULE: LIVE PLAYER SCANNER (FAIL-SAFE)
--    ========================================== ]]
local Players = game:GetService("Players")

-- 1. Siapin Theme dengan Fallback (Biar Kaga Error Nabrak)
local UI = _G.Cat.UI
local Theme = UI and UI.Theme or {}

local cCard = Theme.CardBG or Color3.fromRGB(30, 30, 30)
local cSide = Theme.SideBG or Color3.fromRGB(40, 40, 40)
local cLine = Theme.Line or Color3.fromRGB(60, 60, 60)
local cText = Theme.Text or Color3.fromRGB(240, 240, 240)
local cDim  = Theme.TextDim or Color3.fromRGB(150, 150, 150)
local cPurp = Theme.CatPurple or Color3.fromRGB(170, 85, 255)

-- 2. Bikin Bagian UI
UI.CreateSection(Page, "SERVER PLAYER LIST")

local RefreshBtn = Instance.new("TextButton", Page)
RefreshBtn.LayoutOrder = #Page:GetChildren()
RefreshBtn.Size = UDim2.new(1, 0, 0, 28)
RefreshBtn.BackgroundColor3 = cSide
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Text = "🔄 Refresh Player Data"
RefreshBtn.TextColor3 = cPurp
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 11
RefreshBtn.AutoButtonColor = false
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", RefreshBtn).Color = cLine

local ListContainer = Instance.new("Frame", Page)
ListContainer.LayoutOrder = #Page:GetChildren()
ListContainer.Size = UDim2.new(1, 0, 0, 220)
ListContainer.BackgroundColor3 = cCard
ListContainer.BorderSizePixel = 0
ListContainer.ClipsDescendants = true
Instance.new("UICorner", ListContainer).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ListContainer).Color = cLine

-- Bikin list yang bisa di-scroll
local ScrollList = Instance.new("ScrollingFrame", ListContainer)
ScrollList.Size = UDim2.new(1, -8, 1, -8)
ScrollList.Position = UDim2.new(0, 4, 0, 4)
ScrollList.BackgroundTransparency = 1
ScrollList.BorderSizePixel = 0
ScrollList.ScrollBarThickness = 3
ScrollList.ScrollBarImageColor3 = cLine
ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y -- FIX MUTLAK BIAR BISA SCROLL
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)

local ListLayout = Instance.new("UIListLayout", ScrollList)
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 3. Mesin Intelijen (Aman dari error nil)
local function GetPlayerEquipment(player)
    local eq = { Race = "Unknown", Melee = "None", Fruit = "None", Sword = "None", Gun = "None" }
    
    pcall(function()
        if player:FindFirstChild("Data") and player.Data:FindFirstChild("Race") then
            eq.Race = player.Data.Race.Value
        end
    end)
    
    local function ScanFolder(folder)
        if not folder then return end
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("Tool") then
                local tType = ""
                pcall(function() tType = item.ToolTip end) -- Amanin error tooltip
                
                if tType == "Melee" then eq.Melee = item.Name
                elseif tType == "Blox Fruit" then eq.Fruit = item.Name
                elseif tType == "Sword" then eq.Sword = item.Name
                elseif tType == "Gun" then eq.Gun = item.Name
                end
            end
        end
    end
    
    pcall(function()
        ScanFolder(player:FindFirstChild("Backpack"))
        ScanFolder(player.Character)
    end)
    
    return eq
end

-- 4. Mesin Render UI
local function RefreshList()
    RefreshBtn.Text = "⏳ Scanning Server..."
    
    -- Hapus kartu lama
    for _, child in ipairs(ScrollList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    -- Looping semua orang
    for i, target in ipairs(Players:GetPlayers()) do
        local eq = GetPlayerEquipment(target)
        
        local Card = Instance.new("Frame", ScrollList)
        Card.LayoutOrder = i
        Card.Size = UDim2.new(1, -8, 0, 56)
        Card.BackgroundColor3 = cSide
        Card.BorderSizePixel = 0
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)
        
        local CardLayout = Instance.new("UIListLayout", Card)
        CardLayout.Padding = UDim.new(0, 3)
        CardLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        
        local UIPad = Instance.new("UIPadding", Card)
        UIPad.PaddingLeft = UDim.new(0, 8)
        
        -- Helper buat teks
        local function MakeText(txt, font, color)
            local lbl = Instance.new("TextLabel", Card)
            lbl.Size = UDim2.new(1, -10, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = txt
            lbl.TextColor3 = color or cText
            lbl.Font = font or Enum.Font.Gotham
            lbl.TextSize = 10
            lbl.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        MakeText("👤 " .. target.DisplayName .. " (@" .. target.Name .. ")", Enum.Font.GothamBold, cPurp)
        MakeText("⚡ Race: " .. tostring(eq.Race) .. "   |   🥊 Melee: " .. tostring(eq.Melee), Enum.Font.GothamMedium, cText)
        MakeText("🍇 Fruit: " .. tostring(eq.Fruit) .. "  |  ⚔️ Sword: " .. tostring(eq.Sword) .. "  |  🎯 Gun: " .. tostring(eq.Gun), Enum.Font.Gotham, cDim)
    end
    
    task.wait(0.5)
    RefreshBtn.Text = "🔄 Refresh Player Data"
end

RefreshBtn.MouseButton1Click:Connect(RefreshList)

-- Auto-scan pas baru di-load
task.spawn(RefreshList)