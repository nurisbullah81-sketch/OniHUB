-- CatHUB FREEMIUM: ESP Module (v6.2 - Player Only)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPTab = UI:CreateTab("ESP")

UI:CreateLabel(ESPTab, "━━ PLAYER ESP ━━")
UI:CreateSwitch(ESPTab, "PlayerESP_Enabled", "Enable Player ESP")

local PlayerEspData = {}

local function CreatePlayerESP(player)
    if PlayerEspData[player] then return end
    if not player.Character then return end
    
    local char = player.Character
    local data = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight", char)
    highlight.Name = "CatPlayerESP"
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.5
    highlight.Enabled = false
    data.Highlight = highlight
    
    -- Billboard
    local billboard = Instance.new("BillboardGui", char)
    billboard.Name = "CatPlayerBillboard"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Enabled = false
    
    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    data.NameLabel = nameLabel
    
    local infoLabel = Instance.new("TextLabel", billboard)
    infoLabel.Size = UDim2.new(1, 0, 0, 16)
    infoLabel.Position = UDim2.new(0, 0, 0, 20)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = ""
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextStrokeTransparency = 0.3
    infoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextSize = 11
    data.InfoLabel = infoLabel
    
    data.Billboard = billboard
    PlayerEspData[player] = data
end

-- Character Added
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        CreatePlayerESP(player)
    end)
end)

-- Initial Setup
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            CreatePlayerESP(player)
        end
        player.CharacterAdded:Connect(function()
            task.wait(1)
            CreatePlayerESP(player)
        end)
    end
end

-- Update Loop
RunService.RenderStepped:Connect(function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    for player, data in pairs(PlayerEspData) do
        local shouldShow = UI.Settings.PlayerESP_Enabled
        local isValid = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid")
        
        if not isValid then
            pcall(function()
                if data.Highlight then data.Highlight:Destroy() end
                if data.Billboard then data.Billboard:Destroy() end
            end)
            PlayerEspData[player] = nil
            continue
        end
        
        data.Highlight.Enabled = shouldShow
        data.Billboard.Enabled = shouldShow
        
        if shouldShow and hrp then
            pcall(function()
                local char = player.Character
                local dist = math.floor((char.HumanoidRootPart.Position - hrp.Position).Magnitude)
                local hp = math.floor(char.Humanoid.Health)
                local maxHp = math.floor(char.Humanoid.MaxHealth)
                
                -- Team color
                local isEnemy = true
                pcall(function()
                    if player.Team and LocalPlayer.Team then
                        isEnemy = player.Team ~= LocalPlayer.Team
                    end
                end)
                
                local color = isEnemy and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 150, 255)
                data.Highlight.OutlineColor = color
                data.NameLabel.TextColor3 = color
                data.NameLabel.Text = player.DisplayName
                data.InfoLabel.Text = string.format("[%dm] HP: %d/%d", dist, hp, maxHp)
            end)
        end
    end
end)

print("[CatHUB]: ESP Module Loaded.")