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

-- FUNGSI PINTER: Baca stat berdasarkan keyword, ga peduli nama aslinya apa
local function GetStat(ls, keywords)
    if not ls then return 0, "Unknown" end
    for _, child in pairs(ls:GetChildren()) do
        if child:IsA("IntValue") or child:IsA("NumberValue") then
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

local hasPrinted = false

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            
            -- DEBUG: Print isi leaderstats 1 kali aja biar lu tau isinya apa
            if ls and not hasPrinted then
                hasPrinted = true
                print("[CatHUB DEBUG] Leaderstats ditemukan:")
                for _, child in pairs(ls:GetChildren()) do
                    print(" -> " .. child.Name .. " (Tipe: " .. child.ClassName .. ") = " .. tostring(child.Value))
                end
            end
            
            -- Scan Level (Cari kata "level" atau "lvl")
            local lvl, lvlName = GetStat(ls, {"Level", "Lvl"})
            
            -- Scan Uang (Cari kata "$", "money", "belly", "cash")
            local money, moneyName = GetStat(ls, {"$", "Money", "Belly", "Cash"})
            
            -- Scan Fragment (Cari kata "fragment" atau "frag")
            local frag, fragName = GetStat(ls, {"Fragment", "Frag"})
            
            -- Scan Bounty/Honor (Cari kata "bounty" atau "honor")
            local bounty, bountyName = GetStat(ls, {"Bounty", "Honor"})
            
            -- Update UI Labels
            Labels.Level.Text = "Level: " .. FormatNum(lvl)
            
            -- Rapihin nama uang kalau ketemu simbol aneh
            local displayMoneyName = (moneyName == "$" or string.lower(moneyName) == "money") and "Money" or moneyName
            Labels.Money.Text = displayMoneyName .. ": $" .. FormatNum(money)
            
            local displayFragName = (fragName ~= "Unknown" and fragName or "Fragments")
            Labels.Fragments.Text = displayFragName .. ": " .. FormatNum(frag)
            
            local displayBountyName = (bountyName ~= "Unknown" and bountyName or "Bounty")
            Labels.Bounty.Text = displayBountyName .. ": " .. FormatNum(bounty)
            
            Labels.Players.Text = "Players: " .. #Players:GetPlayers()
            
            -- Logic Waktu & Cuaca
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
            
            -- Logic Hitung Buah
            local count = 0
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and v.Name:lower():find("fruit") then
                    count = count + 1
                end
            end
            Labels.Fruits.Text = "Spawned Fruits: " .. count
        end)
    end
end)