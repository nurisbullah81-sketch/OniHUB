-- [[ ==========================================
--      MODULE: PLAYER & SERVER STATUS
--    ========================================== ]]

local Players  = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- // Framework Initialization
repeat
    task.wait(0.1)
until _G.Cat and _G.Cat.UI and _G.Cat.Settings

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local Player   = _G.Cat.Player

-- ==========================================
-- 1. UI INITIALIZATION
-- ==========================================
local Page = UI.CreateTab("Status", true)

UI.CreateSection(Page, "PLAYER STATUS")

_G.Cat.Labels = _G.Cat.Labels or {}

_G.Cat.Labels.Level     = UI.CreateLabel(Page, "Level: ...", "Current level")
_G.Cat.Labels.Money     = UI.CreateLabel(Page, "Money: ...", "Currency balance")
_G.Cat.Labels.Fragments = UI.CreateLabel(Page, "Fragments: ...", "Awakening mats")
_G.Cat.Labels.Bounty    = UI.CreateLabel(Page, "Bounty/Honor: ...", "PvP score")

UI.CreateSection(Page, "SERVER STATUS")

_G.Cat.Labels.Players = UI.CreateLabel(Page, "Players: ...", "Server population")
_G.Cat.Labels.Time    = UI.CreateLabel(Page, "Time: ...", "Day/Night cycle")
_G.Cat.Labels.Moon    = UI.CreateLabel(Page, "Moon: ...", "Boss trigger")
_G.Cat.Labels.Fruits  = UI.CreateLabel(Page, "Spawned Fruits: 0", "Devil fruits")

-- ==========================================
-- 2. UTILITY FUNCTIONS
-- ==========================================
local Labels = _G.Cat.Labels

-- // Function: Number Formatting (Math Based)
local function FormatNum(num)
    local n = tonumber(num) or 0
    local formatted = tostring(n)
    local k

    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end

    return formatted
end

-- // Function: Read ValueBase Safely
local function ReadValue(obj)
    if not obj then return 0 end

    if obj:IsA("ValueBase") then
        local val = obj.Value

        if type(val) == "number" then
            return val
        end

        if type(val) == "string" then
            local cleanNum = string.gsub(val, ",", "")
            cleanNum = string.match(cleanNum, "%d+")
            return tonumber(cleanNum) or 0
        end
    end

    return 0
end

-- ==========================================
-- 3. BACKGROUND TASK
-- ==========================================
task.spawn(function()
    local LocalPlayer = Players.LocalPlayer

    while task.wait(1) do
        pcall(function()
            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            local dataFolder  = LocalPlayer:FindFirstChild("Data")

            -- Default Values
            local lvl, money, frag, bounty = 0, 0, 0, 0

            -- Read Player Data
            if dataFolder then
                lvl   = ReadValue(dataFolder:FindFirstChild("Level"))
                money = ReadValue(dataFolder:FindFirstChild("Beli"))
                frag  = ReadValue(dataFolder:FindFirstChild("Fragments"))
            end

            -- Read Bounty/Honor
            if leaderstats then
                for _, child in ipairs(leaderstats:GetChildren()) do
                    local isBounty = child.Name == "Bounty"
                    local isHonor  = child.Name == "Honor"
                    local isFound  = string.find(child.Name, "Bounty")

                    if isBounty or isHonor or isFound then
                        bounty = ReadValue(child)
                        break
                    end
                end
            end

            -- Update Player Labels
            Labels.Level.Text     = "Level: " .. FormatNum(lvl)
            Labels.Fragments.Text = "Fragments: " .. FormatNum(frag)
            Labels.Bounty.Text    = "Bounty/Honor: " .. FormatNum(bounty)
            Labels.Money.Text     = "Money: $" .. FormatNum(money)

            -- Update Server Labels
            Labels.Players.Text   = "Players: " .. tostring(#Players:GetPlayers())

            -- Time Calculation
            local clockTime = Lighting.ClockTime
            local hours     = math.floor(clockTime)
            local mins      = math.floor((clockTime % 1) * 60)
            local timeStr   = string.format("%02d:%02d", hours, mins)

            -- Time State Logic
            if clockTime >= 18 or clockTime < 6 then
                Labels.Time.Text = "Time: " .. timeStr .. " (Night)"
                
                local isFull = Lighting.Brightness >= 2
                if isFull then
                    Labels.Moon.Text = "Moon: Full Moon"
                else
                    Labels.Moon.Text = "Moon: No Full Moon"
                end
            else
                Labels.Time.Text = "Time: " .. timeStr .. " (Day)"
                Labels.Moon.Text = "Moon: -"
            end

                        -- Fruit Count Sync
            if _G.Cat.ESP and _G.Cat.ESP.Data then
                local count = 0
                for fruit, _ in pairs(_G.Cat.ESP.Data) do
                    -- FILTER CERDAS: Hanya itung buah yang VALID dan nggak dipegang player lain
                    if fruit and fruit.Parent and _G.Cat.ESP.IsHeldByPlayer and not _G.Cat.ESP.IsHeldByPlayer(fruit) then
                        count = count + 1
                    end
                end
                Labels.Fruits.Text = "Spawned Fruits: " .. tostring(count)
            else
                Labels.Fruits.Text = "Fruits: Wait..."
            end
        end)
    end
end)

-- [[ ==========================================
--      MODULE: LIVE PLAYER SCANNER (X-RAY)
--    ========================================== ]]

local TabKita = Page
local Theme   = UI and UI.Theme or {}

-- // Color References
local cCard = Theme.CardBG or Color3.fromRGB(30, 30, 30)
local cSide = Theme.SideBG or Color3.fromRGB(40, 40, 40)
local cLine = Theme.Line   or Color3.fromRGB(60, 60, 60)
local cText = Theme.Text   or Color3.fromRGB(240, 240, 240)
local cDim  = Theme.TextDim or Color3.fromRGB(150, 150, 150)
local cPurp = Theme.CatPurple or Color3.fromRGB(170, 85, 255)

-- ==========================================
-- 1. UI HEADER
-- ==========================================
local SectionTitle = Instance.new("TextLabel", TabKita)
SectionTitle.LayoutOrder            = #TabKita:GetChildren()
SectionTitle.Size                   = UDim2.new(1, 0, 0, 25)
SectionTitle.BackgroundTransparency = 1
SectionTitle.Text                   = " PLAYER X-RAY (ON-DEMAND)"
SectionTitle.TextColor3             = cPurp
SectionTitle.Font                   = Enum.Font.GothamBold
SectionTitle.TextSize               = 11
SectionTitle.TextXAlignment         = Enum.TextXAlignment.Left

-- ==========================================
-- 2. REFRESH BUTTON
-- ==========================================
local RefreshBtn = Instance.new("TextButton", TabKita)
RefreshBtn.LayoutOrder       = #TabKita:GetChildren()
RefreshBtn.Size              = UDim2.new(1, 0, 0, 30)
RefreshBtn.BackgroundColor3  = cSide
RefreshBtn.BorderSizePixel   = 0
RefreshBtn.Text              = "Refresh Player List"
RefreshBtn.TextColor3        = cText
RefreshBtn.Font              = Enum.Font.GothamBold
RefreshBtn.TextSize          = 11
RefreshBtn.AutoButtonColor   = false

Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", RefreshBtn).Color        = cLine

-- ==========================================
-- 3. LIST CONTAINER
-- ==========================================
local ListContainer = Instance.new("Frame", TabKita)
ListContainer.LayoutOrder      = #TabKita:GetChildren()
ListContainer.Size             = UDim2.new(1, 0, 0, 290)
ListContainer.BackgroundColor3 = cCard
ListContainer.BorderSizePixel  = 0
ListContainer.ClipsDescendants = true

Instance.new("UICorner", ListContainer).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ListContainer).Color        = cLine

-- // Scroll List
local ScrollList = Instance.new("ScrollingFrame", ListContainer)
ScrollList.Size                  = UDim2.new(1, -10, 1, -10)
ScrollList.Position              = UDim2.new(0, 5, 0, 5)
ScrollList.BackgroundTransparency = 1
ScrollList.BorderSizePixel       = 0
ScrollList.ScrollBarThickness    = 2
ScrollList.ScrollBarImageColor3  = cLine
ScrollList.AutomaticCanvasSize   = Enum.AutomaticSize.Y
ScrollList.CanvasSize            = UDim2.new(0, 0, 0, 0)

local ListLayout = Instance.new("UIListLayout", ScrollList)
ListLayout.Padding   = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ==========================================
-- 4. WEAPON SCANNER LOGIC
-- ==========================================
local function ScanSenjata(folder, eq)
    if not folder then return end

    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Tool") then
            local name  = item.Name
            local lower = string.lower(name)

            -- Filter: Ability / Fruit items
            local isAbility = string.find(lower, "awaken")
                or string.find(lower, "summon")
                or string.find(lower, "ribbon")

            local isFruit = string.find(lower, "fruit")
                or string.find(lower, "-")

            if isAbility or isFruit then continue end

            -- Determine Weapon Type
            local tType = ""
            local ttObj = item:FindFirstChild("ToolTip")

            if ttObj and ttObj:IsA("StringValue") then
                tType = ttObj.Value
            else
                pcall(function() tType = item.ToolTip end)
            end

            -- Fallback: Name Detection
            if type(tType) ~= "string" or tType == "" then
                -- Check Gun Keywords
                local isGun = string.find(lower, "gun")
                    or string.find(lower, "rifle")
                    or string.find(lower, "bow")
                    or string.find(lower, "guitar")
                    or string.find(lower, "kabucha")
                    or string.find(lower, "cannon")
                    or string.find(lower, "slingshot")
                    or string.find(lower, "musket")

                -- Check Sword Keywords
                local isSword = string.find(lower, "sword")
                    or string.find(lower, "blade")
                    or string.find(lower, "katana")
                    or string.find(lower, "saber")
                    or string.find(lower, "anchor")
                    or string.find(lower, "tushita")
                    or string.find(lower, "yama")
                    or string.find(lower, "dagger")
                    or string.find(lower, "bisento")
                    or string.find(lower, "trident")
                    or string.find(lower, "canvander")

                -- Check Melee Keywords
                local isMelee = string.find(lower, "human")
                    or string.find(lower, "claw")
                    or string.find(lower, "talon")
                    or string.find(lower, "karate")
                    or string.find(lower, "step")
                    or string.find(lower, "art")

                if isGun then
                    tType = "Gun"
                elseif isSword then
                    tType = "Sword"
                elseif isMelee then
                    tType = "Melee"
                else
                    tType = "Melee"
                end
            end

            -- Assign to Table
            if tType == "Melee" then
                eq.Melee = name
            elseif tType == "Sword" then
                eq.Sword = name
            elseif tType == "Gun" then
                eq.Gun = name
            end
        end
    end
end

local function CreatePlayerCard(target, index)
    -- // Card Container
    local Card = Instance.new("Frame", ScrollList)
    Card.LayoutOrder      = index
    Card.Size             = UDim2.new(1, -4, 0, 42)
    Card.BackgroundColor3 = cSide
    Card.BorderSizePixel  = 0
    Card.ClipsDescendants = true

    local CardCorner = Instance.new("UICorner", Card)
    CardCorner.CornerRadius = UDim.new(0, 6)

    -- // Header Section
    local Header = Instance.new("Frame", Card)
    Header.Size                  = UDim2.new(1, 0, 0, 42)
    Header.BackgroundTransparency = 1

    -- Name Label
    local NameLbl = Instance.new("TextLabel", Header)
    NameLbl.Position           = UDim2.new(0, 12, 0, 0)
    NameLbl.Size               = UDim2.new(0.6, 0, 1, 0)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Text               = target.DisplayName
    NameLbl.TextColor3         = cPurp
    NameLbl.Font               = Enum.Font.GothamBold
    NameLbl.TextSize           = 12
    NameLbl.TextXAlignment     = Enum.TextXAlignment.Left

    -- Inspect Button
    local InspectBtn = Instance.new("TextButton", Header)
    InspectBtn.Size             = UDim2.new(0, 65, 0, 24)
    InspectBtn.Position         = UDim2.new(1, -75, 0.5, -12)
    InspectBtn.BackgroundColor3 = cCard
    InspectBtn.Text             = "Inspect"
    InspectBtn.TextColor3       = cText
    InspectBtn.Font             = Enum.Font.GothamMedium
    InspectBtn.TextSize         = 10
    InspectBtn.AutoButtonColor  = false

    local BtnCorner = Instance.new("UICorner", InspectBtn)
    BtnCorner.CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", InspectBtn).Color = cLine

    -- // Details Section (Hidden by default)
    local Details = Instance.new("Frame", Card)
    Details.Position            = UDim2.new(0, 12, 0, 45)
    Details.Size                = UDim2.new(1, -24, 0, 75)
    Details.BackgroundTransparency = 1

    local DetLayout = Instance.new("UIListLayout", Details)
    DetLayout.Padding = UDim.new(0, 4)

    -- Helper: Create Detail Label
    local function AddDetailLabel()
        local lbl = Instance.new("TextLabel", Details)
        lbl.Size                  = UDim2.new(1, 0, 0, 14)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3            = cDim
        lbl.Font                  = Enum.Font.Gotham
        lbl.TextSize              = 11
        lbl.TextXAlignment        = Enum.TextXAlignment.Left
        return lbl
    end

    local LblRace    = AddDetailLabel()
    local LblFruit   = AddDetailLabel()
    local LblMelee   = AddDetailLabel()
    local LblWeapons = AddDetailLabel()

    -- // State Variables
    local isExpanded = false
    local isScanned  = false

    -- // Button Logic
    InspectBtn.MouseButton1Click:Connect(function()
        if not isExpanded then
            -- Expand Card
            isExpanded = true
            InspectBtn.Text       = "Close"
            InspectBtn.TextColor3 = cPurp
            Card.Size             = UDim2.new(1, -4, 0, 120)

            -- Run Scan Once
            if not isScanned then
                isScanned = true
                LblRace.Text = "Scanning data..."

                task.spawn(function()
                    local cleanRace = "Unknown"
                    local eatenFruit = "None"
                    local eq = {
                        Melee = "None",
                        Sword = "None",
                        Gun   = "None"
                    }

                    -- Fetch Data
                    pcall(function()
                        if target:FindFirstChild("Data") then
                            local data = target.Data
                            
                            if data:FindFirstChild("Race") then
                                cleanRace = data.Race.Value
                            end

                            if data:FindFirstChild("DevilFruit") then
                                local fruitVal = data.DevilFruit.Value
                                if fruitVal ~= "" then
                                    eatenFruit = fruitVal
                                end
                            end
                        end
                    end)

                    -- Scan Inventory
                    pcall(function()
                        ScanSenjata(target:FindFirstChild("Backpack"), eq)
                        ScanSenjata(target.Character, eq)
                    end)

                    -- Update UI
                    LblRace.Text    = "Race : " .. cleanRace
                    LblFruit.Text   = "Fruit : " .. eatenFruit
                    LblMelee.Text   = "Style : " .. eq.Melee
                    LblWeapons.Text = "Weapons : " .. eq.Sword .. " / " .. eq.Gun
                end)
            end
        else
            -- Collapse Card
            isExpanded = false
            InspectBtn.Text       = "Inspect"
            InspectBtn.TextColor3 = cText
            Card.Size             = UDim2.new(1, -4, 0, 42)
        end
    end)
end

-- ==========================================
-- 6. LIST REFRESH ENGINE
-- ==========================================
local function RefreshList()
    -- Clear Existing List
    for _, child in ipairs(ScrollList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Generate New Cards
    for i, target in ipairs(Players:GetPlayers()) do
        CreatePlayerCard(target, i)
    end
end

-- // Button Connection
RefreshBtn.MouseButton1Click:Connect(RefreshList)

-- // Initial Load
task.spawn(function()
    task.wait(1)
    RefreshList()
end)