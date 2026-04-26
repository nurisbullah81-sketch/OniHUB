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

-- Fungsi aman baca value (Bisa angka atau teks yang isinya angka)
local function ReadValue(obj)
    if not obj then return 0 end
    if obj:IsA("IntValue") or obj:IsA("NumberValue") then return obj.Value end
    if obj:IsA("StringValue") then
        local num = string.match(obj.Value, "%d+")
        return tonumber(num) or 0
    end
    return 0
end

local hasPrinted = false

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            local dataFolder = LocalPlayer:FindFirstChild("Data")
            
            -- DEBUG: Print 1 kali aja biar lu tau isinya apa
            if not hasPrinted and ls then
                hasPrinted = true
                print("[CatHUB] === SCANNING LEADERSTATS ===")
                for _, child in pairs(ls:GetChildren()) do
                    print(" -> Nama: '" .. child.Name .. "' | Tipe: " .. child.ClassName .. " | Value: " .. tostring(child.Value))
                end
                if dataFolder then
                    print("[CatHUB] === SCANNING DATA FOLDER ===")
                    for _, child in pairs(dataFolder:GetChildren()) do
                        print(" -> Nama: '" .. child.Name .. "' | Tipe: " .. child.ClassName .. " | Value: " .. tostring(child.Value))
                    end
                end
            end
            
            -- 1. LEVEL (Pasti di leaderstats)
            local lvlObj = ls and (ls:FindFirstChild("Level") or ls:FindFirstChild("Lvl"))
            local lvl = ReadValue(lvlObj)
            
            -- 2. MONEY (Cari nama aneh atau simbol $)
            local moneyObj = ls and (ls:FindFirstChild("$") or ls:FindFirstChild("Money") or ls:FindFirstChild("Belly") or ls:FindFirstChild("Cash"))
            -- Fallback kalau ga ketemu, cari IntValue lain yang bukan Level/Bounty
            if not moneyObj and ls then
                for _, child in pairs(ls:GetChildren()) do
                    local n = string.lower(child.Name)
                    if child:IsA("IntValue") and n ~= "level" and n ~= "lvl" and n ~= "bounty" and n ~= "honor" and n ~= "fragments" then
                        moneyObj = child
                    end
                end
            end
            local money = ReadValue(moneyObj)
            local moneyName = moneyObj and moneyObj.Name or "Money"
            
            -- 3. FRAGMENTS (Di Blox Fruits, ini ada di FOLDER DATA, bukan leaderstats!)
            local fragObj = dataFolder and (dataFolder:FindFirstChild("Fragments") or dataFolder:FindFirstChild("Fragment"))
            if not fragObj and ls then fragObj = ls:FindFirstChild("Fragments") or ls:FindFirstChild("Fragment") end
            local frag = ReadValue(fragObj)
            
            -- 4. BOUNTY / HONOR (Dinamis, tergantung Pirate/Marine)
            local bountyObj = ls and (ls:FindFirstChild("Bounty") or ls:FindFirstChild("Honor"))
            local bounty = ReadValue(bountyObj)
            local bountyName = bountyObj and bountyObj.Name or "Bounty"
            
            -- UPDATE UI
            Labels.Level.Text = "Level: " .. FormatNum(lvl)
            
            local displayMoney = (moneyName == "$") and "Money" or moneyName
            Labels.Money.Text = displayMoney .. ": $" .. FormatNum(money)
            
            Labels.Fragments.Text = "Fragments: " .. FormatNum(frag)
            
            Labels.Bounty.Text = bountyName .. ": " .. FormatNum(bounty)
            
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