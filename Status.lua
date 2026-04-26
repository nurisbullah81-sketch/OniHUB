local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
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

-- SUPER SCANNER: Baca angka dari StringValue maupun IntValue
local function GetStat(parent, keywords)
    if not parent then return 0, "Unknown" end
    for _, child in pairs(parent:GetChildren()) do
        local nameLower = string.lower(child.Name)
        for _, keyword in pairs(keywords) do
            if string.find(nameLower, string.lower(keyword)) then
                local val = 0
                
                -- Kalau IntValue langsung baca
                if child:IsA("IntValue") or child:IsA("NumberValue") then
                    val = child.Value
                -- Kalau StringValue, extract angkanya (contoh: "Level: 2679" atau "2679")
                elseif child:IsA("StringValue") then
                    local numStr = string.match(child.Value, "%d+")
                    if numStr then val = tonumber(numStr) or 0 end
                end
                
                return val, child.Name
            end
        end
    end
    return 0, "Unknown"
end

-- Fungsi cari lebih dalam kalau tidak ada di leaderstats
local function DeepSearchStat(player, keywords)
    local foldersToSearch = {"leaderstats", "Data", "Stats", "Values"}
    for _, folderName in pairs(foldersToSearch) do
        local folder = player:FindFirstChild(folderName)
        if folder then
            local val, name = GetStat(folder, keywords)
            if val > 0 then return val, name end -- Hanya return kalau ketemu angkanya
        end
    end
    
    -- Terakhir, scan semua child dari Player
    for _, child in pairs(player:GetChildren()) do
        local val, name = GetStat(child, keywords)
        if val > 0 then return val, name end
    end
    
    return 0, "Unknown"
end

local hasPrinted = false

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- DEBUG CONSOLE: Print semua data 1 kali biar lu tau datanya ketemu apa kagak
            if not hasPrinted then
                hasPrinted = true
                print("[CatHUB] === SCANNING PLAYER DATA ===")
                local ls = LocalPlayer:FindFirstChild("leaderstats")
                if ls then
                    for _, child in pairs(ls:GetChildren()) do
                        print(" -> " .. child.Name .. " (" .. child.ClassName .. ") = " .. tostring(child.Value))
                    end
                else
                    print(" -> Leaderstats not found!")
                end
            end
            
            -- Scan Level (Cari Level, Lvl, atau angka besar)
            local lvl, lvlName = DeepSearchStat(LocalPlayer, {"Level", "Lvl", "Exp"})
            
            -- Scan Uang 
            local money, moneyName = DeepSearchStat(LocalPlayer, {"$", "Money", "Belly", "Cash"})
            
            -- Scan Fragment 
            local frag, fragName = DeepSearchStat(LocalPlayer, {"Fragment", "Frag"})
            
            -- Scan Bounty/Honor 
            local bounty, bountyName = DeepSearchStat(LocalPlayer, {"Bounty", "Honor"})
            
            -- Update UI
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