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

-- Super Reader: Baca IntValue, NumberValue, StringValue, IntConstrainedValue
local function ReadValue(obj)
    if not obj then return 0 end
    if obj:IsA("ValueBase") then
        local val = obj.Value
        if type(val) == "number" then return val end
        if type(val) == "string" then
            local num = string.match(val, "%d+")
            return tonumber(num) or 0
        end
    end
    return 0
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
            
            local function ScanFolder(folder)
                if not folder then return end
                for _, child in pairs(folder:GetChildren()) do
                    if child:IsA("ValueBase") then
                        local rawName = string.lower(child.Name)
                        -- ANTI-CHEAT BYPASS: Hapus semua spasi/simbol aneh (misal "Level " jadi "level")
                        local n = string.gsub(rawName, "%W", "") 
                        local val = ReadValue(child)
                        
                        if string.find(n, "level") or string.find(n, "lvl") then
                            lvl = val; lvlName = child.Name
                        elseif string.find(n, "bounty") or string.find(n, "honor") then
                            bounty = val; bountyName = child.Name
                        elseif string.find(n, "frag") then
                            frag = val; fragName = child.Name
                        elseif rawName == "$" or string.find(n, "money") or string.find(n, "belly") or string.find(n, "cash") then
                            money = val; moneyName = child.Name
                        else
                            -- Jika ada angka lain yang belum kekategori, pasti itu uang
                            if val > 0 and money == 0 then
                                money = val; moneyName = child.Name
                            end
                        end
                    end
                end
            end
            
            ScanFolder(ls)
            ScanFolder(dataFolder)
            
            -- Update UI
            Labels.Level.Text = "Level: " .. FormatNum(lvl)
            
            local displayMoney = (moneyName == "$" or string.lower(moneyName) == "money") and "Money" or moneyName
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