-- CatHUB FREEMIUM: ESP Module (v5.0 Fix)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local function CreatePlayerESP(char)
    if not char:FindFirstChild("Cat_Hl") then
        local hl = Instance.new("Highlight", char)
        hl.Name = "Cat_Hl"
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        
        task.spawn(function()
            while char:IsDescendantOf(Workspace) do
                local p = Players:GetPlayerFromCharacter(char)
                if p then
                    hl.Enabled = UI.Settings.PlayerESP_Enabled
                    hl.FillColor = (p.Team == LocalPlayer.Team and tostring(p.Team) == "Marines") and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 0, 0)
                end
                task.wait(0.5)
            end
        end)
    end
end

local function CreateFruitESP(v)
    if not v:FindFirstChild("Cat_Fruit") then
        local b = Instance.new("BillboardGui", v)
        b.Name = "Cat_Fruit"
        b.AlwaysOnTop = true
        b.Size = UDim2.new(0, 150, 0, 40)
        local t = Instance.new("TextLabel", b)
        t.Size = UDim2.new(1, 0, 1, 0)
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.TextStrokeTransparency = 0
        t.TextSize = 16
        t.Font = Enum.Font.SourceSansBold
        
        task.spawn(function()
            while v:IsDescendantOf(Workspace) do
                b.Enabled = UI.Settings.ESP_Enabled and not v:IsDescendantOf(LocalPlayer.Character)
                if b.Enabled then
                    local name = v.Name == "Fruit " and "??? (System)" or v.Name
                    local dist = math.floor((v:GetModelCFrame().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    t.Text = string.format("%s\n[%dM]", name, dist)
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
                if (v:IsA("Tool") and v.Name:lower():find("fruit")) or (v:IsA("Model") and v.Name == "Fruit ") then CreateFruitESP(v) end
            end
        end
        if UI.Settings.PlayerESP_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then CreatePlayerESP(p.Character) end
            end
        end
    end
end)