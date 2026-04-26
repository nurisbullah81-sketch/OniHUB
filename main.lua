-- Main Logic: Blox Fruits 2026 Engine
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local UI_URL = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/UI.lua"
local UI_Module = loadstring(game:HttpGet(UI_URL .. "?v=" .. math.random()))()

local function GetDistance(obj)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChildOfClass("BasePart").Position) or obj.Position
        return math.floor((targetPos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
    end
    return 0
end

local function CreateESP(object)
    if not UI_Module.ESP_Enabled then 
        if object:FindFirstChild("DIZ_ESP") then object.DIZ_ESP:Destroy() end
        return 
    end

    if not object:FindFirstChild("DIZ_ESP") then
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "DIZ_ESP"
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(0, 100, 0, 30)
        Billboard.Adornee = object
        Billboard.Parent = object

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 11
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.Parent = Billboard

        task.spawn(function()
            while object:IsDescendantOf(Workspace) and UI_Module.ESP_Enabled do
                local dist = GetDistance(object)
                local name = object.Name
                
                -- LOGIKA: Jika spawn sistem (biasanya bernama "Fruit " atau Model tanpa owner)
                -- Jika dropped player (biasanya Tool dengan nama spesifik)
                if object:IsA("Model") and (name == "Fruit " or not object:FindFirstChild("Handle")) then
                    name = "??? (System Spawn)"
                end

                TextLabel.Text = string.format("%s\n%dM", name, dist)
                task.wait(0.1)
            end
            Billboard:Destroy()
        end)
    end
end

-- Tween Logic
local function TweenTo(target)
    if not UI_Module.Tween_Enabled or not target then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local targetPos = target:IsA("Model") and target:GetModelCFrame() or target.CFrame
        local dist = GetDistance(target)
        local tweenInfo = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(char.HumanoidRootPart, tweenInfo, {CFrame = targetPos})
        tween:Play()
    end
end

-- Main Loop
task.spawn(function()
    while task.wait(1) do
        if UI_Module.ESP_Enabled or UI_Module.Tween_Enabled then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and v.Name:lower():find("fruit") or (v:IsA("Model") and v.Name == "Fruit ") then
                    if UI_Module.ESP_Enabled then CreateESP(v) end
                    if UI_Module.Tween_Enabled then TweenTo(v) end
                end
            end
        end
    end
end)

print("DIZ HUB: REDZ-EDITION LOADED.")