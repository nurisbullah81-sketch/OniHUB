-- ==========================================
-- MODULE: PLAYER & SERVER STATUS
-- ==========================================

-- Services
-- Modules/Status/Status.lua
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do task.wait(0.1) end
local UI = _G.Cat.UI
local Settings = _G.Cat.Settings
local LocalPlayer = _G.Cat.Player

-- 1. PASANG UI (Variabel harus konsisten pakai 'Page')
local Page = UI.CreateTab("Status", true)

UI.CreateSection(Page, "PLAYER STATUS")
_G.Cat.Labels.Level = UI.CreateLabel(Page, "Level: ...", "Current level progress")
_G.Cat.Labels.Money = UI.CreateLabel(Page, "Money: ...", "In-game currency balance")
_G.Cat.Labels.Fragments = UI.CreateLabel(Page, "Fragments: ...", "Used for awakening")
_G.Cat.Labels.Bounty = UI.CreateLabel(Page, "Bounty/Honor: ...", "PvP score tracking")

UI.CreateSection(Page, "SERVER STATUS")
_G.Cat.Labels.Players = UI.CreateLabel(Page, "Players: ...", "Currently in this server")
_G.Cat.Labels.Time = UI.CreateLabel(Page, "Time: ...", "In-game day/night cycle")
_G.Cat.Labels.Moon = UI.CreateLabel(Page, "Moon: ...", "Affects certain bosses & events")
_G.Cat.Labels.Fruits = UI.CreateLabel(Page, "Spawned Fruits: 0", "Devil fruits on the map")

-- 2. LOGIC UPDATE
local Labels = _G.Cat.Labels
local function FormatNum(num)
    if typeof(num) ~= "number" then num = 0 end num = math.floor(num) local formatted = tostring(num)
    while true do formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2') if k == 0 then break end end
    return formatted
end
local function ReadValue(obj)
    if not obj then return 0 end
    if obj:IsA("ValueBase") then local val = obj.Value if type(val) == "number" then return val end if type(val) == "string" then local num = string.match(val, "%d+") return tonumber(num) or 0 end end
    return 0
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            local dataFolder = LocalPlayer:FindFirstChild("Data")
            local lvl, lvlName = 0, "Level" local money, moneyName = 0, "Money" local frag, fragName = 0, "Fragments" local bounty, bountyName = 0, "Bounty"
            local function ScanFolder(folder)
                if not folder then return end
                for _, child in pairs(folder:GetChildren()) do
                    if child:IsA("ValueBase") then local rawName = string.lower(child.Name) local n = string.gsub(rawName, "%W", "") local val = ReadValue(child)
                        if string.find(n, "level") or string.find(n, "lvl") then lvl = val; lvlName = child.Name
                        elseif string.find(n, "bounty") or string.find(n, "honor") then bounty = val; bountyName = child.Name
                        elseif string.find(n, "frag") then frag = val; fragName = child.Name
                        elseif rawName == "$" or string.find(n, "money") or string.find(n, "belly") or string.find(n, "cash") then money = val; moneyName = child.Name
                        else if val > 0 and money == 0 then money = val; moneyName = child.Name end end
                    end
                end
            end
            ScanFolder(ls) ScanFolder(dataFolder)
            Labels.Level.Text = "Level: " .. FormatNum(lvl)
            local displayMoney = (moneyName == "$" or string.lower(moneyName) == "money") and "Money" or moneyName
            Labels.Money.Text = displayMoney .. ": $" .. FormatNum(money)
            Labels.Fragments.Text = "Fragments: " .. FormatNum(frag)
            Labels.Bounty.Text = bountyName .. ": " .. FormatNum(bounty)
            Labels.Players.Text = "Players: " .. #Players:GetPlayers()
            local clockTime = Lighting.ClockTime local h = math.floor(clockTime) local m = math.floor((clockTime % 1) * 60) local timeStr = string.format("%02d:%02d", h, m)
            if clockTime >= 18 or clockTime < 6 then
                Labels.Time.Text = "Time: " .. timeStr .. " (Night)" local isFull = Lighting.Brightness >= 2 Labels.Moon.Text = isFull and "Moon: Full Moon" or "Moon: Not Full Moon"
            else Labels.Time.Text = "Time: " .. timeStr .. " (Day)" Labels.Moon.Text = "Moon: -" end
            local fruitList = (_G.Cat.ESP and _G.Cat.ESP.GetFruitsList) and _G.Cat.ESP.GetFruitsList() or {}
            if #fruitList > 0 then local fruitText = table.concat(fruitList, ", ") if string.len(fruitText) > 35 then fruitText = string.sub(fruitText, 1, 35) .. "..." end Labels.Fruits.Text = "Fruits: " .. fruitText else Labels.Fruits.Text = "Fruits: None" end
        end)
    end
end)