-- CatHUB v7.0: ESP (Lightweight)
local UI = _G.CatHUB_UI
local Cache = _G.CatCache
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Tab = UI:CreateTab("👥 ESP")
UI:CreateSwitch(Tab, "PlayerESP", "Player ESP")

local espData = {}

local function AddESP(player)
    if espData[player] then return end
    if not player.Character then return end
    local char = player.Character
    local data = {}

    local hl = Instance.new("Highlight", char)
    hl.Name = "CatPlrESP"
    hl.FillTransparency = 0.75
    hl.OutlineTransparency = 0.5
    hl.Enabled = false
    data.Highlight = hl

    local bb = Instance.new("BillboardGui", char)
    bb.Name = "CatPlrBB"
    bb.Size = UDim2.new(0, 180, 0, 45)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.Enabled = false

    local nameL = Instance.new("TextLabel", bb)
    nameL.Size = UDim2.new(1, 0, 0, 20)
    nameL.BackgroundTransparency = 1
    nameL.Text = player.DisplayName
    nameL.TextColor3 = Color3.new(1, 1, 1)
    nameL.TextStrokeTransparency = 0
    nameL.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 13

    local infoL = Instance.new("TextLabel", bb)
    infoL.Size = UDim2.new(1, 0, 0, 16)
    infoL.Position = UDim2.new(0, 0, 0, 22)
    infoL.BackgroundTransparency = 1
    infoL.Text = ""
    infoL.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoL.TextStrokeTransparency = 0.4
    infoL.TextStrokeColor3 = Color3.new(0, 0, 0)
    infoL.Font = Enum.Font.Gotham
    infoL.TextSize = 10

    data.Billboard = bb
    data.NameLabel = nameL
    data.InfoLabel = infoL
    espData[player] = data
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        AddESP(p)
    end)
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= Cache.LocalPlayer then
        if p.Character then AddESP(p) end
        p.CharacterAdded:Connect(function()
            task.wait(1)
            AddESP(p)
        end)
    end
end

-- Update every 0.3s (not every frame!)
task.spawn(function()
    while task.wait(0.3) do
        local show = UI.Settings.PlayerESP
        for player, data in pairs(espData) do
            local valid = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid")
            if not valid or not player.Character:IsDescendantOf(game:GetService("Workspace")) then
                pcall(function()
                    data.Highlight:Destroy()
                    data.Billboard:Destroy()
                end)
                espData[player] = nil
                continue
            end

            data.Highlight.Enabled = show
            data.Billboard.Enabled = show

            if show and Cache.IsValid then
                pcall(function()
                    local char = player.Character
                    local dist = math.floor((char.HumanoidRootPart.Position - Cache.Position).Magnitude)
                    local hp = math.floor(char.Humanoid.Health)
                    local maxHp = math.floor(char.Humanoid.MaxHealth)
                    
                    local isEnemy = true
                    if player.Team and Cache.LocalPlayer.Team then
                        isEnemy = player.Team ~= Cache.LocalPlayer.Team
                    end
                    
                    local color = isEnemy and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(70, 150, 255)
                    data.Highlight.OutlineColor = color
                    data.NameLabel.TextColor3 = color
                    data.NameLabel.Text = player.DisplayName
                    data.InfoLabel.Text = "[" .. dist .. "m] " .. hp .. "/" .. maxHp
                end)
            end
        end
    end
end)

print("[CatHUB] ESP loaded")