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
        
        if type(val) == "number" then 
            return val 
        end 
        
        if type(val) == "string" then 
            -- Hapus koma dan karakter aneh, murni ambil angkanya aja
            local cleanNum = string.gsub(val, ",", "")
            cleanNum = string.match(cleanNum, "%d+")
            return tonumber(cleanNum) or 0 
        end 
    end
    
    return 0
end

-- [[ ==========================================
--      3. BACKGROUND TASK: STATUS TRACKER (ULTRA OPTIMIZED)
--    ========================================== ]]

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- // 3.1: Initialize Data Buffers
            local leaderstats = Player:FindFirstChild("leaderstats")
            local dataFolder  = Player:FindFirstChild("Data")
            
            local lvl, money, frag, bounty = 0, 0, 0, 0
            
            -- // 3.2: OPTIMIZED SCANNER (ANTI-0 BOUNTY)
            if dataFolder then
                lvl    = ReadValue(dataFolder:FindFirstChild("Level"))
                money  = ReadValue(dataFolder:FindFirstChild("Beli"))
                frag   = ReadValue(dataFolder:FindFirstChild("Fragments"))
            end
            
            if leaderstats then
                -- Cari manual tanpa regex berat, dijamin nemu biarpun Marine/Pirate
                for _, child in ipairs(leaderstats:GetChildren()) do
                    if child.Name == "Bounty" or child.Name == "Honor" or string.find(child.Name, "Bounty") then
                        bounty = ReadValue(child)
                        break
                    end
                end
            end

            -- // 3.3: Update Player Labels
            Labels.Level.Text     = string.format("Level: %s", FormatNum(lvl))
            Labels.Fragments.Text = string.format("Fragments: %s", FormatNum(frag))
            Labels.Bounty.Text    = string.format("Bounty/Honor: %s", FormatNum(bounty))
            Labels.Money.Text     = string.format("Money: $%s", FormatNum(money))

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
--      MODULE: LIVE PLAYER SCANNER (X-RAY)
--      Status: Clean Vertical UI & Smart DB
--    ========================================== ]]
local Players = game:GetService("Players")

-- 🔥 Pastikan variabel ini sesuai sama nama tab lu di atas!
local TabKita = Page 

-- // 1. Trik Aman Tarik Tema UI
local UI    = _G.Cat.UI
local Theme = UI and UI.Theme or {}

local cCard = Theme.CardBG or Color3.fromRGB(30, 30, 30)
local cSide = Theme.SideBG or Color3.fromRGB(40, 40, 40)
local cLine = Theme.Line or Color3.fromRGB(60, 60, 60)
local cText = Theme.Text or Color3.fromRGB(240, 240, 240)
local cDim  = Theme.TextDim or Color3.fromRGB(150, 150, 150)
local cPurp = Theme.CatPurple or Color3.fromRGB(170, 85, 255)

-- // 2. BIKIN JUDUL MANUAL
local SectionTitle = Instance.new("TextLabel", TabKita)
SectionTitle.LayoutOrder = #TabKita:GetChildren()
SectionTitle.Size = UDim2.new(1, 0, 0, 25)
SectionTitle.BackgroundTransparency = 1
SectionTitle.Text = " SERVER PLAYER LIST (X-RAY)"
SectionTitle.TextColor3 = cPurp
SectionTitle.Font = Enum.Font.GothamBold
SectionTitle.TextSize = 11
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

-- // 3. Komponen UI Utama (Wadah List)
local RefreshBtn = Instance.new("TextButton", TabKita)
RefreshBtn.LayoutOrder = #TabKita:GetChildren()
RefreshBtn.Size = UDim2.new(1, 0, 0, 28)
RefreshBtn.BackgroundColor3 = cSide
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Text = "Refresh Player Data"
RefreshBtn.TextColor3 = cText
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 11
RefreshBtn.AutoButtonColor = false
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", RefreshBtn).Color = cLine

local ListContainer = Instance.new("Frame", TabKita)
ListContainer.LayoutOrder = #TabKita:GetChildren()
ListContainer.Size = UDim2.new(1, 0, 0, 280) -- Ditinggiin dikit biar enak nge-scrollnya
ListContainer.BackgroundColor3 = cCard
ListContainer.BorderSizePixel = 0
ListContainer.ClipsDescendants = true
Instance.new("UICorner", ListContainer).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ListContainer).Color = cLine

local ScrollList = Instance.new("ScrollingFrame", ListContainer)
ScrollList.Size = UDim2.new(1, -8, 1, -8)
ScrollList.Position = UDim2.new(0, 4, 0, 4)
ScrollList.BackgroundTransparency = 1
ScrollList.BorderSizePixel = 0
ScrollList.ScrollBarThickness = 3
ScrollList.ScrollBarImageColor3 = cLine
ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)

local ListLayout = Instance.new("UIListLayout", ScrollList)
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- // 4. Mesin Inti X-Ray (Udah di-upgrade anti-miss)
local function ScanSenjata(folder, eq)
    if not folder then return end
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name
            local lower = string.lower(name)
            
            -- Filter sampah
            if string.find(lower, "awaken") or string.find(lower, "summon") or string.find(lower, "ribbon") then continue end
            if string.find(lower, "fruit") or string.find(lower, "-") then continue end
            
            local tType = ""
            -- Cek ToolTip yang bentuknya StringValue
            local ttObj = item:FindFirstChild("ToolTip")
            if ttObj and ttObj:IsA("StringValue") then
                tType = ttObj.Value
            else
                -- Fallback cek ToolTip biasa
                pcall(function() tType = item.ToolTip end)
            end
            
            -- Kamus Super Lengkap Blox Fruits (Kalau ToolTip disensor)
            if type(tType) ~= "string" or tType == "" then
                if string.find(lower, "gun") or string.find(lower, "rifle") or string.find(lower, "bow") or string.find(lower, "guitar") or string.find(lower, "kabucha") or string.find(lower, "cannon") or string.find(lower, "slingshot") or string.find(lower, "musket") or string.find(lower, "flintlock") then 
                    tType = "Gun"
                elseif string.find(lower, "sword") or string.find(lower, "blade") or string.find(lower, "katana") or string.find(lower, "saber") or string.find(lower, "anchor") or string.find(lower, "tushita") or string.find(lower, "yama") or string.find(lower, "dagger") or string.find(lower, "bisento") or string.find(lower, "pole") or string.find(lower, "trident") or string.find(lower, "mace") or string.find(lower, "canvander") or string.find(lower, "jitte") or string.find(lower, "warden") then 
                    tType = "Sword"
                elseif string.find(lower, "human") or string.find(lower, "claw") or string.find(lower, "talon") or string.find(lower, "karate") or string.find(lower, "step") or string.find(lower, "breath") or string.find(lower, "combat") or string.find(lower, "art") then
                    tType = "Melee"
                else 
                    tType = "Melee" -- Default terburuk
                end
            end
            
            if tType == "Melee" then eq.Melee = name
            elseif tType == "Sword" then eq.Sword = name
            elseif tType == "Gun" then eq.Gun = name
            end
        end
    end
end

local function RefreshList()
    RefreshBtn.Text = "Scanning Server..."
    
    for _, child in ipairs(ScrollList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for i, target in ipairs(Players:GetPlayers()) do
        local cleanRace = "Unknown"
        local eatenFruit = "None"
        local eq = { Melee = "None", Sword = "None", Gun = "None" }
        
        -- Bongkar folder rahasia lambung (Buah & Ras)
        pcall(function()
            if target:FindFirstChild("Data") then
                if target.Data:FindFirstChild("Race") then
                    cleanRace = target.Data.Race.Value
                end
                if target.Data:FindFirstChild("DevilFruit") and target.Data.DevilFruit.Value ~= "" then
                    eatenFruit = target.Data.DevilFruit.Value
                end
            end
        end)
        
        -- Bongkar Tas & Tangan instan
        pcall(function()
            ScanSenjata(target:FindFirstChild("Backpack"), eq)
            ScanSenjata(target.Character, eq)
        end)
        
        -- // BIKIN KARTU VERTIKAL (Tinggi 110 biar muat 6 baris)
        local Card = Instance.new("Frame", ScrollList)
        Card.LayoutOrder = i
        Card.Size = UDim2.new(1, -8, 0, 115) 
        Card.BackgroundColor3 = cSide
        Card.BorderSizePixel = 0
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)
        
        local CardLayout = Instance.new("UIListLayout", Card)
        CardLayout.Padding = UDim.new(0, 3)
        CardLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        
        local UIPad = Instance.new("UIPadding", Card)
        UIPad.PaddingLeft = UDim.new(0, 10)
        
        local function MakeText(txt, font, color, isTitle)
            local lbl = Instance.new("TextLabel", Card)
            lbl.Size = UDim2.new(1, -10, 0, isTitle and 16 or 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = txt
            lbl.TextColor3 = color
            lbl.Font = font
            lbl.TextSize = isTitle and 11 or 10
            lbl.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        -- URUTAN TEKS SESUAI REQUEST LU (VERTIKAL & RAPIH)
        MakeText(target.DisplayName, Enum.Font.GothamBold, cPurp, true) -- Murni DisplayName
        MakeText("Race : " .. cleanRace, Enum.Font.Gotham, cText, false)
        MakeText("Fruit : " .. eatenFruit, Enum.Font.Gotham, cText, false)
        MakeText("FightingStyle : " .. eq.Melee, Enum.Font.Gotham, cText, false)
        MakeText("Sword : " .. eq.Sword, Enum.Font.Gotham, cText, false)
        MakeText("Gun : " .. eq.Gun, Enum.Font.Gotham, cText, false)
    end
    
    task.wait(0.2)
    RefreshBtn.Text = "Refresh Player Data"
end

RefreshBtn.MouseButton1Click:Connect(RefreshList)

task.spawn(function()
    task.wait(1)
    RefreshList()
end)