-- DIZ AI - Blox Fruits Finder & ESP (BULLETPROOF EDITION)
-- No custom fonts, No cache, No errors.

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Proteksi agar script tidak dijalankan dua kali
if CoreGui:FindFirstChild("DIZ_Hub") then CoreGui.DIZ_Hub:Destroy() end

local function CreateUI()
    local success, err = pcall(function()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "DIZ_Hub"
        ScreenGui.Parent = CoreGui

        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 220, 0, 80) -- Lebih kecil dan compact
        MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
        MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        MainFrame.BorderSizePixel = 0
        MainFrame.Active = true
        MainFrame.Draggable = true
        MainFrame.Parent = ScreenGui

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = MainFrame

        local Status = Instance.new("TextLabel")
        Status.Size = UDim2.new(1, 0, 1, 0)
        Status.BackgroundTransparency = 1
        Status.Text = "DIZ HUB: ESP ACTIVE"
        Status.TextColor3 = Color3.fromRGB(0, 255, 100)
        Status.TextSize = 14
        -- Tanpa setting font manual untuk menghindari error Solara
        Status.Parent = MainFrame
    end)
    if not success then warn("UI Error but script continues: " .. err) end
end

local function CreateESP(object)
    if not object:FindFirstChild("DIZ_ESP") then
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "DIZ_ESP"
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(0, 150, 0, 50)
        Billboard.Adornee = object
        Billboard.Parent = object

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = "[ FRUIT: " .. object.Name .. " ]"
        TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Merah agar mencolok
        TextLabel.TextSize = 16
        TextLabel.Parent = Billboard
    end
end

local function Scan()
    -- Deteksi buah yang jatuh di Workspace (Metode Umum)
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:lower():find("fruit") or v:FindFirstChild("Handle")) then
            CreateESP(v)
        end
    end
    
    -- Deteksi buah di folder khusus (Update 2026)
    local fruitFolder = Workspace:FindFirstChild("Fruits") or Workspace:FindFirstChild("FruitFolder")
    if fruitFolder then
        for _, v in pairs(fruitFolder:GetChildren()) do
            CreateESP(v)
        end
    end
end

-- Eksekusi
CreateUI()
task.spawn(function()
    while task.wait(1) do
        local success, err = pcall(Scan)
        if not success then print("Scan error: " .. err) end
    end
end)

print("DIZ HUB: FORCE LOADED.")