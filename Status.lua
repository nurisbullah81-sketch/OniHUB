local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = _G.Cat.Player
local Labels = _G.Cat.Labels

local function FormatNum(num)
    if typeof(num) ~= "number" then num = 0 end
    num = math.floor(num)
    local formatted = tostring(num)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

local function GetStat(ls, keywords)
    if not ls then return 0, "Unknown" end
    for _, child in pairs(ls:GetChildren()) do
        if child:IsA("IntValue") or child:IsA("NumberValue") or child:IsA("IntConstrainedValue") then
            local nameLower = string.lower(child.Name)
            for _, keyword in pairs(keywords) do
                if string.find(nameLower, string.lower(keyword)) then
                    return child.Value, child.Name
                end
            end
        end
    end
    return 0, "Unknown"
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            
            -- Scan Level (Cari kata level, lvl, atau exp)
            local lvl, lvlName = GetStat(ls, {"Level", "Lvl", "Exp", "Xp"})
            
            -- Scan Uang 
            local money, moneyName = GetStat(ls, {"$", "Money", "Belly", "Cash"})
            
            -- Scan Fragment 
            local frag, fragName = GetStat(ls, {"Fragment", "Frag"})
            
            -- Scan Bounty/Honor 
            local bounty, bountyName = GetStat(ls, {"Bounty", "Honor"})
            
            Labels.Level.Text = "Level: " .. FormatNum(lvl)
            
            local displayMoneyName = (moneyName == "$" or string.lower(moneyName) == "money") and "Money" or moneyName
            Labels.Money.Text = displayMoneyName .. ": $" .. FormatNum(money)
            
            local displayFragName = (fragName ~= "Unknown" and fragName or "Fragments")
            Labels.Fragments.Text = displayFragName .. ": " .. FormatNum(frag)
            
            local displayBountyName = (bountyName ~= "Unknown" and bountyName or "Bounty")
            Labels.Bounty.Text = displayBountyName .. ": " .. FormatNum(bounty)
            
            Labels.Players.Text = "Players: " .. #Players:GetPlayers()
            
            local clockTime = Lighting.ClockTime
            local h = math.floor(clockTime)
            local m = math.floor((clockTime % 1) * 60)
            local timeStr = string.format("%02d:%02d", h, m)
            
            if clockTime >= 6 and clockTime < 18 then
                Labels.Time.Text = "Time: " .. timeStr .. " (Day)"
                Labels.Moon.Text = "Moon: -"
            else
                Labels.Time.Text = "Time: " .. timeStr .. " (Night)"
                local isFull = Lighting.Ambient.r > 0.3 or Lighting.OutdoorAmbient.r > 0.3
                Labels.Moon.Text = isFull and "Moon: Full Moon" or "Moon: Normal"
            end
            
            -- LOGIC NAMA BUAH
            local fruitList = _G.Cat.GetFruitsList and _G.Cat.GetFruitsList() or {}
            if #fruitList > 0 then
                local fruitText = table.concat(fruitList, ", ")
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