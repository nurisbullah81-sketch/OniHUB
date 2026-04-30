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
--      Status: Premium Expandable UI & Anti-Ping Spike
--    ========================================== ]]
local Players = game:GetService("Players")

local TabKita = Page 

local UI    = _G.Cat.UI
local Theme = UI and UI.Theme or {}

local cCard = Theme.CardBG or Color3.fromRGB(30, 30, 30)
local cSide = Theme.SideBG or Color3.fromRGB(40, 40, 40)
local cLine = Theme.Line or Color3.fromRGB(60, 60, 60)
local cText = Theme.Text or Color3.fromRGB(240, 240, 240)
local cDim  = Theme.TextDim or Color3.fromRGB(150, 150, 150)
local cPurp = Theme.CatPurple or Color3.fromRGB(170, 85, 255)

-- // 1. BIKIN JUDUL MANUAL
local SectionTitle = Instance.new("TextLabel", TabKita)
SectionTitle.LayoutOrder = #TabKita:GetChildren()
SectionTitle.Size = UDim2.new(1, 0, 0, 25)
SectionTitle.BackgroundTransparency = 1
SectionTitle.Text = " PLAYER X-RAY (ON-DEMAND)"
SectionTitle.TextColor3 = cPurp
SectionTitle.Font = Enum.Font.GothamBold
SectionTitle.TextSize = 11
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

-- // 2. KOMPONEN UI UTAMA
local RefreshBtn = Instance.new("TextButton", TabKita)
RefreshBtn.LayoutOrder = #TabKita:GetChildren()
RefreshBtn.Size = UDim2.new(1, 0, 0, 30)
RefreshBtn.BackgroundColor3 = cSide
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Text = "Refresh Player List"
RefreshBtn.TextColor3 = cText
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 11
RefreshBtn.AutoButtonColor = false
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", RefreshBtn).Color = cLine

local ListContainer = Instance.new("Frame", TabKita)
ListContainer.LayoutOrder = #TabKita:GetChildren()
ListContainer.Size = UDim2.new(1, 0, 0, 290)
ListContainer.BackgroundColor3 = cCard
ListContainer.BorderSizePixel = 0
ListContainer.ClipsDescendants = true
Instance.new("UICorner", ListContainer).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ListContainer).Color = cLine

local ScrollList = Instance.new("ScrollingFrame", ListContainer)
ScrollList.Size = UDim2.new(1, -10, 1, -10)
ScrollList.Position = UDim2.new(0, 5, 0, 5)
ScrollList.BackgroundTransparency = 1
ScrollList.BorderSizePixel = 0
ScrollList.ScrollBarThickness = 2
ScrollList.ScrollBarImageColor3 = cLine
ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)

local ListLayout = Instance.new("UIListLayout", ScrollList)
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- // 3. MESIN SCANNER (TETAP SAMA)
local function ScanSenjata(folder, eq)
    if not folder then return end
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name
            local lower = string.lower(name)
            
            if string.find(lower, "awaken") or string.find(lower, "summon") or string.find(lower, "ribbon") then continue end
            if string.find(lower, "fruit") or string.find(lower, "-") then continue end
            
            local tType = ""
            local ttObj = item:FindFirstChild("ToolTip")
            if ttObj and ttObj:IsA("StringValue") then
                tType = ttObj.Value
            else
                pcall(function() tType = item.ToolTip end)
            end
            
            if type(tType) ~= "string" or tType == "" then
                if string.find(lower, "gun") or string.find(lower, "rifle") or string.find(lower, "bow") or string.find(lower, "guitar") or string.find(lower, "kabucha") or string.find(lower, "cannon") or string.find(lower, "slingshot") or string.find(lower, "musket") then 
                    tType = "Gun"
                elseif string.find(lower, "sword") or string.find(lower, "blade") or string.find(lower, "katana") or string.find(lower, "saber") or string.find(lower, "anchor") or string.find(lower, "tushita") or string.find(lower, "yama") or string.find(lower, "dagger") or string.find(lower, "bisento") or string.find(lower, "trident") or string.find(lower, "canvander") then 
                    tType = "Sword"
                elseif string.find(lower, "human") or string.find(lower, "claw") or string.find(lower, "talon") or string.find(lower, "karate") or string.find(lower, "step") or string.find(lower, "art") then
                    tType = "Melee"
                else 
                    tType = "Melee" 
                end
            end
            
            if tType == "Melee" then eq.Melee = name
            elseif tType == "Sword" then eq.Sword = name
            elseif tType == "Gun" then eq.Gun = name
            end
        end
    end
end

-- // 4. PEMBUAT KARTU PREMIUM (LAZY LOAD)
local function CreatePlayerCard(target, index)
    -- Kartu Utama
    local Card = Instance.new("Frame", ScrollList)
    Card.LayoutOrder = index
    Card.Size = UDim2.new(1, -4, 0, 42) -- Tinggi awal (Menciut)
    Card.BackgroundColor3 = cSide
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = true
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
    
    -- Bagian Atas (Header)
    local Header = Instance.new("Frame", Card)
    Header.Size = UDim2.new(1, 0, 0, 42)
    Header.BackgroundTransparency = 1
    
    local NameLbl = Instance.new("TextLabel", Header)
    NameLbl.Position = UDim2.new(0, 12, 0, 0)
    NameLbl.Size = UDim2.new(0.6, 0, 1, 0)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Text = target.DisplayName
    NameLbl.TextColor3 = cPurp
    NameLbl.Font = Enum.Font.GothamBold
    NameLbl.TextSize = 12
    NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Tombol Inspect
    local InspectBtn = Instance.new("TextButton", Header)
    InspectBtn.Size = UDim2.new(0, 65, 0, 24)
    InspectBtn.Position = UDim2.new(1, -75, 0.5, -12)
    InspectBtn.BackgroundColor3 = cCard
    InspectBtn.Text = "Inspect"
    InspectBtn.TextColor3 = cText
    InspectBtn.Font = Enum.Font.GothamMedium
    InspectBtn.TextSize = 10
    InspectBtn.AutoButtonColor = false
    Instance.new("UICorner", InspectBtn).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", InspectBtn).Color = cLine
    
    -- Wadah Data (Sembunyi di bawah)
    local Details = Instance.new("Frame", Card)
    Details.Position = UDim2.new(0, 12, 0, 45)
    Details.Size = UDim2.new(1, -24, 0, 75)
    Details.BackgroundTransparency = 1
    
    local DetLayout = Instance.new("UIListLayout", Details)
    DetLayout.Padding = UDim.new(0, 4)
    
    local function AddDetailLabel()
        local lbl = Instance.new("TextLabel", Details)
        lbl.Size = UDim2.new(1, 0, 0, 14)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = cDim
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        return lbl
    end
    
    local LblRace = AddDetailLabel()
    local LblFruit = AddDetailLabel()
    local LblMelee = AddDetailLabel()
    local LblWeapons = AddDetailLabel()
    
    -- Logika Expand/Collapse & Lazy Load
    local isExpanded = false
    local isScanned = false
    
    InspectBtn.MouseButton1Click:Connect(function()
        if not isExpanded then
            -- Buka Kartu
            isExpanded = true
            InspectBtn.Text = "Close"
            InspectBtn.TextColor3 = cPurp
            Card.Size = UDim2.new(1, -4, 0, 120) -- Mekar
            
            -- Baru Scan Data kalau belum pernah di-scan
            if not isScanned then
                isScanned = true
                LblRace.Text = "Scanning data..."
                
                task.spawn(function()
                    local cleanRace = "Unknown"
                    local eatenFruit = "None"
                    local eq = { Melee = "None", Sword = "None", Gun = "None" }
                    
                    pcall(function()
                        if target:FindFirstChild("Data") then
                            if target.Data:FindFirstChild("Race") then cleanRace = target.Data.Race.Value end
                            if target.Data:FindFirstChild("DevilFruit") and target.Data.DevilFruit.Value ~= "" then eatenFruit = target.Data.DevilFruit.Value end
                        end
                    end)
                    
                    pcall(function()
                        ScanSenjata(target:FindFirstChild("Backpack"), eq)
                        ScanSenjata(target.Character, eq)
                    end)
                    
                    LblRace.Text    = "Race : " .. cleanRace
                    LblFruit.Text   = "Fruit : " .. eatenFruit
                    LblMelee.Text   = "Style : " .. eq.Melee
                    LblWeapons.Text = "Weapons : " .. eq.Sword .. " / " .. eq.Gun
                end)
            end
        else
            -- Tutup Kartu
            isExpanded = false
            InspectBtn.Text = "Inspect"
            InspectBtn.TextColor3 = cText
            Card.Size = UDim2.new(1, -4, 0, 42) -- Menciut
        end
    end)
end

-- // 5. SISTEM REFRESH (ANTI-LAG)
local function RefreshList()
    for _, child in ipairs(ScrollList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    -- Cuma bikin wadahnya doang, kaga nge-scan apa-apa!
    for i, target in ipairs(Players:GetPlayers()) do
        CreatePlayerCard(target, i)
    end
end

RefreshBtn.MouseButton1Click:Connect(RefreshList)

-- Cuma dijalanin 1x pas awal
task.spawn(function()
    task.wait(1)
    RefreshList()
end)