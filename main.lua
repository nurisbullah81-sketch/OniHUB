-- CatHUB FREEMIUM Logic Core
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local UI_URL = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/UI.lua"
local UI_Module = loadstring(game:HttpGet(UI_URL .. "?v=" .. math.random()))()

local function GetDist(obj)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local p = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChildOfClass("BasePart").Position) or (obj:IsA("BasePart") and obj.Position or obj.Handle.Position)
        return (p - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    end
    return 0
end

local function CreateESP(object)
    if not object:FindFirstChild("Cat_ESP") then
        local Bb = Instance.new("BillboardGui", object)
        Bb.Name = "Cat_ESP"
        Bb.AlwaysOnTop = true
        Bb.Size = UDim2.new(0, 200, 0, 50)
        
        local T = Instance.new("TextLabel", Bb)
        T.Size = UDim2.new(1, 0, 1, 0)
        T.BackgroundTransparency = 1
        T.TextColor3 = Color3.fromRGB(255, 255, 255)
        T.TextSize = 16 -- Optimized size for clarity
        T.Font = Enum.Font.SourceSansBold
        T.TextStrokeTransparency = 0.3
        T.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        task.spawn(function()
            while object:IsDescendantOf(Workspace) do
                Bb.Enabled = UI_Module.Settings.ESP_Enabled
                if Bb.Enabled then
                    local name = (object:IsA("Model") and object.Name == "Fruit ") and "??? (System)" or object.Name
                    T.Text = string.format("%s\n%dM", name, math.floor(GetDist(object)))
                end
                task.wait(0.2)
            end
        end)
    end
end

local function TweenTo(target)
    if not UI_Module.Settings.Tween_Enabled or not target then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if target:IsDescendantOf(char) then return end
        local dist = GetDist(target)
        if dist < 10 then return end
        local targetCF = target:IsA("Model") and target:GetModelCFrame() or (target:IsA("Tool") and target.Handle.CFrame or target.CFrame)
        local tInfo = TweenInfo.new(dist/UI_Module.Settings.Tween_Speed, Enum.EasingStyle.Sine)
        local t = TweenService:Create(char.HumanoidRootPart, tInfo, {CFrame = targetCF})
        
        task.spawn(function()
            while t.PlaybackState == Enum.PlaybackState.Playing do
                if not UI_Module.Settings.Tween_Enabled then t:Cancel() break end
                task.wait(0.1)
            end
        end)
        t:Play()
    end
end

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