-- CatHUB SUPREMACY: ESP Module v8.0
local UI = _G.UI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

local function ApplyESP(obj, type)
    if obj:FindFirstChild("Cat_ESP") then return end
    local Bb = Instance.new("BillboardGui", obj)
    Bb.Name = "Cat_ESP"
    Bb.AlwaysOnTop = true
    Bb.Size = UDim2.new(0, 200, 0, 50)
    local T = Instance.new("TextLabel", Bb)
    T.Size = UDim2.new(1,0,1,0)
    T.BackgroundTransparency = 1
    T.TextColor3 = Color3.fromRGB(255, 255, 255)
    T.TextStrokeTransparency = 0
    T.Font = "SourceSansBold"
    T.TextSize = (type == "Fruit") and 18 or 14

    if type == "Player" then
        local Hl = Instance.new("Highlight", obj)
        Hl.Name = "Cat_Hl"
        task.spawn(function()
            while obj:IsDescendantOf(Workspace) do
                local p = Players:GetPlayerFromCharacter(obj)
                Hl.Enabled = UI.Settings.ESP_Players
                Bb.Enabled = UI.Settings.ESP_Players
                if p and Hl.Enabled then
                    local col = (p.Team == LP.Team and tostring(p.Team) == "Marines") and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 0, 0)
                    Hl.FillColor = col
                    T.TextColor3 = col
                    T.Text = p.Name.."\n["..math.floor((obj.PrimaryPart.Position - LP.Character.PrimaryPart.Position).Magnitude).."M]"
                end
                task.wait(0.3)
            end
        end)
    else
        task.spawn(function()
            while obj:IsDescendantOf(Workspace) do
                Bb.Enabled = UI.Settings.ESP_Fruits
                if Bb.Enabled then
                    T.Text = (obj.Name == "Fruit " and "??? (System)" or obj.Name).."\n["..math.floor((obj:GetModelCFrame().Position - LP.Character.PrimaryPart.Position).Magnitude).."M]"
                end
                task.wait(0.5)
            end
        end)
    end
end

task.spawn(function()
    while task.wait(1) do
        if UI.Settings.ESP_Fruits then
            for _,v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") or (v:IsA("Model") and v.Name == "Fruit ") then ApplyESP(v, "Fruit") end
            end
        end
        if UI.Settings.ESP_Players then
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then ApplyESP(p.Character, "Player") end
            end
        end
    end
end)