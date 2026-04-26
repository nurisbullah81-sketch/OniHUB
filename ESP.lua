-- CatHUB FREEMIUM: ESP Module (Highlight Update)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local function CreatePlayerHighlight(char)
    if not char:FindFirstChild("Cat_Highlight") then
        local Hl = Instance.new("Highlight", char)
        Hl.Name = "Cat_Highlight"
        Hl.FillColor = Color3.fromRGB(255, 0, 0) -- Merah untuk musuh
        Hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        Hl.FillTransparency = 0.5
        Hl.OutlineTransparency = 0
        
        task.spawn(function()
            while char:IsDescendantOf(Workspace) do
                Hl.Enabled = UI.Settings.PlayerESP_Enabled
                task.wait(0.5)
            end
        end)
    end
end

local function CreateFruitESP(obj)
    if not obj:FindFirstChild("Cat_ESP") then
        local Bb = Instance.new("BillboardGui", obj)
        Bb.Name = "Cat_ESP"
        Bb.AlwaysOnTop = true
        Bb.Size = UDim2.new(0, 200, 0, 50)
        
        local T = Instance.new("TextLabel", Bb)
        T.Size = UDim2.new(1, 0, 1, 0)
        T.BackgroundTransparency = 1
        T.TextColor3 = Color3.fromRGB(255, 255, 255)
        T.TextSize = 18
        T.Font = Enum.Font.SourceSansBold
        T.TextStrokeTransparency = 0
        T.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        task.spawn(function()
            while obj:IsDescendantOf(Workspace) do
                Bb.Enabled = UI.Settings.ESP_Enabled
                if Bb.Enabled then
                    local name = obj.Name == "Fruit " and "??? (System)" or obj.Name
                    local pos = obj:IsA("Model") and obj:GetModelCFrame().Position or obj.Position
                    local dist = math.floor((pos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    T.Text = string.format("%s\n[%dM]", name, dist)
                end
                task.wait(0.2)
            end
        end)
    end
end

task.spawn(function()
    while task.wait(1) do
        if UI.Settings.ESP_Enabled then
            for _, v in pairs(Workspace:GetChildren()) do
                if (v:IsA("Tool") and v.Name:lower():find("fruit")) or (v:IsA("Model") and v.Name == "Fruit ") then
                    CreateFruitESP(v)
                end
            end
        end
        if UI.Settings.PlayerESP_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    CreatePlayerHighlight(p.Character)
                end
            end
        end
    end
end)