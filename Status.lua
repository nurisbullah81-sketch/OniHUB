local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = _G.Cat.Player
local UI = _G.Cat.Funcs
local Tab = _G.Cat.Tabs["Status"]

-- Format Angka Biar Keren (1000000 -> 1,000,000)
local function FormatNum(num)
    num = math.floor(num)
    local formatted = tostring(num)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- BUILD UI
UI:Section(Tab, "PLAYER STATUS")
local LvlLabel = UI:Label(Tab, "Level: ...")
local MoneyLabel = UI:Label(Tab, "Money: ...")
local FragLabel = UI:Label(Tab, "Fragments: ...")
local BountyLabel = UI:Label(Tab, "Bounty/Honor: ...")

UI:Section(Tab, "SERVER STATUS")
local PlayersLabel = UI:Label(Tab, "Players: ...")
local TimeLabel = UI:Label(Tab, "Time: ...")
local MoonLabel = UI:Label(Tab, "Moon: ...")
local FruitCountLabel = UI:Label(Tab, "Spawned Fruits: 0")

-- LOGIC UPDATE (Smart & Pcall)
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ls = LocalPlayer.leaderstats
            
            -- Player Stats
            local lvl = ls:FindFirstChild("Level") and ls.Level.Value or 0
            local money = ls:FindFirstChild("$") and ls["$"].Value or 0
            local frag = ls:FindFirstChild("Fragments") and ls.Fragments.Value or 0
            local bounty = ls:FindFirstChild("Bounty") or ls:FindFirstChild("Honor")
            local bountyVal = bounty and bounty.Value or 0
            
            LvlLabel.Text = "Level: " .. FormatNum(lvl)
            MoneyLabel.Text = "Money: $" .. FormatNum(money)
            FragLabel.Text = "Fragments: " .. FormatNum(frag)
            BountyLabel.Text = (bounty and bounty.Name or "Bounty") .. ": " .. FormatNum(bountyVal)
            
            -- Server Stats
            PlayersLabel.Text = "Players: " .. #Players:GetPlayers()
            
            local clockTime = Lighting.ClockTime
            local h = math.floor(clockTime)
            local m = math.floor((clockTime % 1) * 60)
            local timeStr = string.format("%02d:%02d", h, m)
            
            if clockTime >= 6 and clockTime < 18 then
                TimeLabel.Text = "Time: " .. timeStr .. " (Day)"
                MoonLabel.Text = "Moon: -"
            else
                TimeLabel.Text = "Time: " .. timeStr .. " (Night)"
                -- Deteksi Full Moon (Blox Fruits biasanya ganti Lighting)
                local isFull = Lighting.Ambient.r > 0.3 or Lighting.OutdoorAmbient.r > 0.3
                MoonLabel.Text = isFull and "Moon: Full Moon" or "Moon: Normal"
            end
            
            -- Hitung Buah Spawn
            local count = 0
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and v.Name:lower():find("fruit") then
                    count = count + 1
                end
            end
            FruitCountLabel.Text = "Spawned Fruits: " .. count
        end)
    end
end)