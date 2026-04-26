local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = _G.Cat.Player
local Labels = _G.Cat.Labels

local function FormatNum(num)
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
            local ls = LocalPlayer.leaderstats
            
            local lvl = ls:FindFirstChild("Level") and ls.Level.Value or 0
            local money = ls:FindFirstChild("$") and ls["$"].Value or 0
            local frag = ls:FindFirstChild("Fragments") and ls.Fragments.Value or 0
            local bounty = ls:FindFirstChild("Bounty") or ls:FindFirstChild("Honor")
            local bountyVal = bounty and bounty.Value or 0
            
            Labels.Level.Text = "Level: " .. FormatNum(lvl)
            Labels.Money.Text = "Money: $" .. FormatNum(money)
            Labels.Fragments.Text = "Fragments: " .. FormatNum(frag)
            Labels.Bounty.Text = (bounty and bounty.Name or "Bounty") .. ": " .. FormatNum(bountyVal)
            
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