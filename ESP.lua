-- CatHUB FREEMIUM: ESP Module
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local function GetColor(p)
    if not p.Team then return Color3.fromRGB(255, 255, 255) end
    local team = tostring(p.Team)
    if team == "Marines" then return Color3.fromRGB(0, 150, 255) end
    if team == "Pirates" then return Color3.fromRGB(255, 50, 50) end
    return Color3.fromRGB(255, 255, 255)
end

local function CreateESP(obj, type)
    if not obj:FindFirstChild("Cat_ESP") then
        local Bb = Instance.new("BillboardGui", obj)
        Bb.Name = "Cat_ESP"
        Bb.AlwaysOnTop = true
        Bb.Size = UDim2.new(0, 200, 0, 50)
        
        local T = Instance.new("TextLabel", Bb)
        T.Size = UDim2.new(1, 0, 1, 0)
        T.BackgroundTransparency = 1
        T.TextColor3 = Color3.fromRGB(255, 255, 255)
        T.TextSize = (type == "Fruit") and 18 or 14
        T.Font = Enum.Font.SourceSansBold
        T.TextStrokeTransparency = 0
        T.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        task.spawn(function()
            while obj:IsDescendantOf(Workspace) do
                local enabled = (type == "Fruit") and UI.Settings.ESP_Enabled or UI.Settings.PlayerESP_Enabled
                Bb.Enabled = enabled and not obj:IsDescendantOf(LocalPlayer.Character)
                
                if Bb.Enabled then
                    local name = obj.Name == "Fruit " and "??? (System)" or obj.Name
                    local pos = obj:IsA("Model") and obj:GetModelCFrame().Position or obj.Position
                    local dist = math.floor((pos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    
                    if type == "Player" then
                        local p = Players:GetPlayerFromCharacter(obj)
                        if p then T.TextColor3 = GetColor(p) end
                    end
                    T.Text = string.format("%s\n[%dM]", name, dist)
                end
                task.wait(0.2)
            end
            if Bb then Bb:Destroy() end
        end)
    end
end

task.spawn(function()
    while task.wait(1) do
        if UI.Settings.ESP_Enabled then
            for _, v in pairs(Workspace:GetChildren()) do
                if (v:IsA("Tool") and v.Name:lower():find("fruit")) or (v:IsA("Model") and v.Name == "Fruit ") then
                    CreateESP(v, "Fruit")
                end
            end
        end
        if UI.Settings.PlayerESP_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    CreateESP(p.Character, "Player")
                end
            end
        end
    end
end)