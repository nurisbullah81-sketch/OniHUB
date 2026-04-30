-- ==========================================
-- MODULE: PLAYER & SERVER STATUS
-- ==========================================

-- Services
local Players  = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- Wait for Core
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do 
    task.wait(0.1) 
end

local UI           = _G.Cat.UI
local Settings     = _G.Cat.Settings
local LocalPlayer  = _G.Cat.Player
local Labels       = _G.Cat.Labels

-- ==========================================
-- 1. UI SETUP (Status Tab)
-- ==========================================
local StatusTab = UI.CreateTab("Status", true) 

-- Player Status Section
UI.CreateSection(StatusTab, "PLAYER STATUS")

Labels.Level = UI.CreateLabel(
    StatusTab, 
    "Level: ...", 
    "Current level progress"
)
Labels.Money = UI.CreateLabel(
    StatusTab, 
    "Money: ...", 
    "In-game currency balance"
)
Labels.Fragments = UI.CreateLabel(
    StatusTab, 
    "Fragments: ...", 
    "Used for awakening"
)
Labels.Bounty = UI.CreateLabel(
    StatusTab, 
    "Bounty/Honor: ...", 
    "PvP score tracking"
)

-- Server Status Section
UI.CreateSection(StatusTab, "SERVER STATUS")

Labels.Players = UI.CreateLabel(
    StatusTab, 
    "Players: ...", 
    "Currently in this server"
)
Labels.Time = UI.CreateLabel(
    StatusTab, 
    "Time: ...", 
    "In-game day/night cycle"
)
Labels.Moon = UI.CreateLabel(
    StatusTab, 
    "Moon: ...", 
    "Affects certain bosses & events"
)
Labels.Fruits = UI.CreateLabel(
    StatusTab, 
    "Spawned Fruits: 0", 
    "Devil fruits on the map"
)

-- ==========================================
-- 2. HELPER FUNCTIONS
-- ==========================================

-- Adds commas to numbers (e.g., 1,000,000)
local function FormatNum(num)
    if typeof(num) ~= "number" then num = 0 end 
    num = math.floor(num) 
    
    local formatted = tostring(num)
    while true do 
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2') 
        if k == 0 then break end 
    end 
    return formatted
end

-- Safely reads value from ValueBase
local function ReadValue(obj)
    if not obj then return 0 end
    
    if obj:IsA("ValueBase") then 
        local val = obj.Value 
        if type(val) == "number" then 
            return val 
        end 
        
        if type(val) == "string" then 
            local num = string.match(val, "%d+") 
            return tonumber(num) or 0 
        end 
    end 
    return 0
end

-- ==========================================
-- 3. MAIN UPDATE LOOP
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- Folders
            local ls         = LocalPlayer:FindFirstChild("leaderstats")
            local dataFolder = LocalPlayer:FindFirstChild("Data")
            
            -- Defaults
            local lvl, lvlName       = 0, "Level" 
            local money, moneyName   = 0, "Money" 
            local frag, fragName     = 0, "Fragments" 
            local bounty, bountyName = 0, "Bounty"
            
            -- Local Scan Function
            local function ScanFolder(folder)
                if not folder then return end
                
                for _, child in pairs(folder:GetChildren()) do
                    if child:IsA("ValueBase") then 
                        local rawName = string.lower(child.Name) 
                        local n       = string.gsub(rawName, "%W", "") 
                        local val     = ReadValue(child)
                        
                        if string.find(n, "level") or string.find(n, "lvl") then 
                            lvl = val
                            lvlName = child.Name
                        elseif string.find(n, "bounty") or string.find(n, "honor") then 
                            bounty = val
                            bountyName = child.Name
                        elseif string.find(n, "frag") then 
                            frag = val
                            fragName = child.Name
                        elseif rawName == "$" or string.find(n, "money") or string.find(n, "belly") or string.find(n, "cash") then 
                            money = val
                            moneyName = child.Name
                        else 
                            -- Fallback for unknown currency folders
                            if val > 0 and money == 0 then 
                                money = val
                                moneyName = child.Name 
                            end 
                        end
                    end
                end
            end
            
            ScanFolder(ls) 
            ScanFolder(dataFolder)
            
            -- UI Rendering (Numbers)
            Labels.Level.Text = "Level: " .. FormatNum(lvl)
            
            local displayMoney = (moneyName == "$" or string.lower(moneyName) == "money") and "Money" or moneyName
            Labels.Money.Text = displayMoney .. ": $" .. FormatNum(money)
            
            Labels.Fragments.Text = "Fragments: " .. FormatNum(frag)
            Labels.Bounty.Text = bountyName .. ": " .. FormatNum(bounty)
            Labels.Players.Text = "Players: " .. #Players:GetPlayers()
            
            -- Time & Moon Calculation
            local clockTime = Lighting.ClockTime 
            local h = math.floor(clockTime) 
            local m = math.floor((clockTime % 1) * 60) 
            local timeStr = string.format("%02d:%02d", h, m)
            
            if clockTime >= 18 or clockTime < 6 then
                Labels.Time.Text = "Time: " .. timeStr .. " (Night)" 
                
                local isFull = Lighting.Brightness >= 2 
                Labels.Moon.Text = isFull and "Moon: Full Moon" or "Moon: Not Full Moon"
            else 
                Labels.Time.Text = "Time: " .. timeStr .. " (Day)" 
                Labels.Moon.Text = "Moon: -" 
            end
            
            -- Fruit Data (Integrated from ESP Module)
            local espData   = _G.Cat.ESP
            local fruitList = (espData and espData.GetFruitsList) and espData.GetFruitsList() or {}
            
            if #fruitList > 0 then 
                local fruitText = table.concat(fruitList, ", ") 
                
                -- Trim string if too long for UI
                if string.len(fruitText) > 35 then 
                    fruitText = string.sub(fruitText, 1, 35) .. "..." 
                end 
                
                Labels.Fruits.Text = "Fruits: " .. fruitText 
            else 
                Labels.Fruits.Text = "Fruits: None" 
            end
        end)
    end
end)