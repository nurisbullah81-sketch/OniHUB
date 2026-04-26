-- Main Logic Module
-- Feature: Fruit Finder with Distance (Meters)
-- Color: White, Small Text

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Memanggil UI.lua dari GitHub
local function LoadUI()
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/UI.lua"
    loadstring(game:HttpGet(url .. "?v=" .. tostring(math.random(1, 100000))))()
end

pcall(LoadUI)

local function GetDistance(obj)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return math.floor((obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
    end
    return 0
end

local function CreateESP(object)
    if not object:FindFirstChild("DIZ_ESP") then
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "DIZ_ESP"
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(0, 100, 0, 40)
        Billboard.Adornee = object
        Billboard.Parent = object

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "ESPText"
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 12 -- Ukuran teks lebih kecil sesuai permintaan
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.Parent = Billboard

        -- Update Jarak secara Real-time
        task.spawn(function()
            while object:IsDescendantOf(Workspace) and Billboard:FindFirstChild("ESPText") do
                local dist = GetDistance(object:IsA("Model") and object.PrimaryPart or object:FindFirstChild("Handle") or object)
                TextLabel.Text = string.format("%s\n[%dm]", object.Name, dist)
                task.wait(0.5)
            end
        end)
    end
end

local function Scan()
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:lower():find("fruit") or v:FindFirstChild("Handle")) then
            CreateESP(v)
        end
    end
    
    local fruitFolder = Workspace:FindFirstChild("Fruits")
    if fruitFolder then
        for _, v in pairs(fruitFolder:GetChildren()) do
            CreateESP(v)
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        pcall(Scan)
    end
end)

print("DIZ HUB: Modular System Loaded.")