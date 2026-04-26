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

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            local dataFolder = LocalPlayer:FindFirstChild("Data")
            
            local lvl, lvlName = 0, "Level"
            local money, moneyName = 0, "Money"
            local frag, fragName = 0, "Fragments"
            local bounty, bountyName = 0, "Bounty"
            
            if ls then
                for _, child in pairs(ls:GetChildren()) do
                    if child:IsA("ValueBase") then
                        local n = string.lower(child.Name)
                        local val = child.Value
                        if typeof(val) ~= "number" then val = 0 end
                        
                        if string.find(n, "level") or string.find(n, "lvl") then
                            lvl = val; lvlName = child.Name
                        elseif string.find(n, "bounty") or string.find(n, "honor") then
                            bounty = val; bountyName = child.Name
                        elseif string.find(n, "frag") then
                            frag = val; fragName = child.Name
                        elseif string.find(n, "%%$") or string.find(n, "money") or string.find(n, "belly") or string.find(n, "cash") then
                            money = val; moneyName = child.Name
                        else
                            if val > 0 and money == 0 then
                                money = val; moneyName = child.Name
                            end
                        end
                    end
                end
            end
            
            if dataFolder then
                for _, child in pairs(dataFolder:GetChildren()) do
                    if child:IsA("ValueBase") then
                        local n = string.lower(child.Name)
                        if string.find(n, "frag") then
                            frag = child.Value; fragName = child.Name
                        end
                    end
                end
            end
            
            Labels.Level.Text = "Level: " .. FormatNum(lvl)
            
            local displayMoney = (moneyName == "$" or string.lower(moneyName) == "money") and "Money" or moneyName
            Labels.Money.Text = displayMoney .. ": $" .. FormatNum(money)
            
            Labels.Fragments.Text = "Fragments: " .. FormatNum(frag)
            
            Labels.Bounty.Text = bountyName .. ": " .. FormatNum(bounty)
            
            Labels.Players.Text = "Players: " .. #Players:GetPlayers()
            
            -- LOGIC WAKTU & CUACA (Blox Fruits Standard)
            local clockTime = Lighting.ClockTime
            local h = math.floor(clockTime)
            local m = math.floor((clockTime % 1) * 60)
            local timeStr = string.format("%02d:%02d", h, m)
            
            -- Di Blox Fruits, malem itu ClockTime antara 19 sampai 5 pagi
            if clockTime >= 19 or clockTime < 5 then
                Labels.Time.Text = "Time: " .. timeStr .. " (Night)"
                
                -- FULL MOON DETECTION UNTUK RACE V4
                -- Pas Full Moon, game otomatis naikin Brightness Lighting jadi di atas 2
                -- Malem biasa cuma 0.5 - 1.2
                local isFull = Lighting.Brightness >= 2
                Labels.Moon.Text = isFull and "Moon: Full Moon 🌕" or "Moon: Normal 🌑"
            else
                Labels.Time.Text = "Time: " .. timeStr .. " (Day)"
                Labels.Moon.Text = "Moon: -"
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