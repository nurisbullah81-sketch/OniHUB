-- CatHUB Core Engine
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local UI_URL = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/UI.lua"
local UI_Module = loadstring(game:HttpGet(UI_URL .. "?v=" .. math.random()))()

local function GetDistance(obj)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChildOfClass("BasePart").Position) or (obj:IsA("BasePart") and obj.Position or obj.Handle.Position)
        return math.floor((pos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
    end
    return 0
end

local function CreateESP(object)
    if not object:FindFirstChild("Cat_ESP") then
        local Billboard = Instance.new("BillboardGui", object)
        Billboard.Name = "Cat_ESP"
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(0, 100, 0, 30)
        
        local TextLabel = Instance.new("TextLabel", Billboard)
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 11
        TextLabel.Font = Enum.Font.SourceSansBold

        task.spawn(function()
            while object:IsDescendantOf(Workspace) do
                if not UI_Module.Settings.ESP_Enabled then
                    Billboard.Enabled = false
                else
                    Billboard.Enabled = true
                    local name = (object:IsA("Model") and object.Name == "Fruit ") and "??? (System Spawn)" or object.Name
                    TextLabel.Text = string.format("%s\n%dM", name, GetDistance(object))
                end
                task.wait(0.2)
            end
            Billboard:Destroy()
        end)
    end
end

-- Tween to Fruit
local function TweenTo(target)
    if not UI_Module.Settings.Tween_Enabled or not target then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local dist = GetDistance(target)
        if dist < 10 then return end
        local targetPos = target:IsA("Model") and target:GetModelCFrame() or (target:IsA("Tool") and target.Handle.CFrame or target.CFrame)
        local tween = TweenService:Create(char.HumanoidRootPart, TweenInfo.new(dist/300, Enum.EasingStyle.Linear), {CFrame = targetPos})
        
        task.spawn(function()
            while tween.PlaybackState == Enum.PlaybackState.Playing do
                if not UI_Module.Settings.Tween_Enabled then tween:Cancel() break end
                task.wait(0.1)
            end
        end)
        tween:Play()
    end
end

-- Main Loop
task.spawn(function()
    while task.wait(1) do
        if UI_Module.Settings.ESP_Enabled or UI_Module.Settings.Tween_Enabled then
            for _, v in pairs(Workspace:GetChildren()) do
                if (v:IsA("Tool") and v.Name:lower():find("fruit")) or (v:IsA("Model") and v.Name == "Fruit ") then
                    if UI_Module.Settings.ESP_Enabled then CreateESP(v) end
                    if UI_Module.Settings.Tween_Enabled then TweenTo(v) end
                end
            end
        end
    end
end)

print("CatHUB Logic Loaded.")