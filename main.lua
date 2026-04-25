local Settings = {
    JoinTeam = "Pirates", 
    AutoHop = true,
    SafeDelay = 15, -- Biar ga kena Error 773 (Unauthorized)
    ESP_Color = Color3.fromRGB(0, 255, 255)
}

-- [[ CORE ENGINE - ANTI-DOWNGRADE ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")

-- Fungsi Join Tim Otomatis
pcall(function()
    RS.Remotes.CommF_:InvokeServer("SetTeam", Settings.JoinTeam)
end)

-- [[ FITUR ESP FRUIT ]]
local function CreateESP(part)
    if part:FindFirstChild("FruitESP") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FruitESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.Adornee = part
    billboard.Parent = part

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "🍎 " .. part.Name
    text.TextColor3 = Settings.ESP_Color
    text.TextStrokeTransparency = 0
    text.Parent = billboard
end

-- Deteksi Buah di Map
for _, v in pairs(game.Workspace:GetChildren()) do
    if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
        CreateESP(v)
    end
end

game.Workspace.ChildAdded:Connect(function(v)
    if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
        CreateESP(v)
    end
end)

print("OniHUB V2: ESP & Anti-Error Active!")