-- CatHUB FREEMIUM: Logic Core (ESP Bug Fixed)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local UI_URL = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/UI.lua"
local UI_Module = loadstring(game:HttpGet(UI_URL .. "?v=" .. math.random()))()

local currentTween = nil

-- Noclip Logic
RunService.Stepped:Connect(function()
    if UI_Module.Settings.Tween_Enabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local function GetDist(obj)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local p = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChildOfClass("BasePart").Position) or (obj:IsA("BasePart") and obj.Position or obj.Handle.Position)
        return (p - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    end
    return 0
end

-- FIXED ESP LOGIC
local function CreateESP(object)
    if not object:FindFirstChild("Cat_ESP") then
        -- Initial Name Determination
        local initialName = object.Name
        if object:IsA("Model") and initialName == "Fruit " then
            initialName = "??? (System)"
        end

        local Bb = Instance.new("BillboardGui", object)
        Bb.Name = "Cat_ESP"
        Bb.AlwaysOnTop = true
        Bb.Size = UDim2.new(0, 200, 0, 50)
        
        local T = Instance.new("TextLabel", Bb)
        T.Size = UDim2.new(1, 0, 1, 0)
        T.BackgroundTransparency = 1
        T.TextColor3 = Color3.fromRGB(255, 255, 255)
        T.TextSize = 16
        T.Font = Enum.Font.SourceSansBold
        T.Text = initialName -- NO MORE "LABEL" DEFAULT
        T.TextStrokeTransparency = 0.3

        task.spawn(function()
            while object:IsDescendantOf(Workspace) and Bb do
                -- Mencegah ESP muncul jika buah di tangan pemain
                if object:IsDescendantOf(LocalPlayer.Character) then
                    Bb.Enabled = false
                else
                    Bb.Enabled = UI_Module.Settings.ESP_Enabled
                end

                if Bb.Enabled then
                    local name = object.Name
                    if object:IsA("Model") and name == "Fruit " then
                        name = "??? (System)"
                    end
                    T.Text = string.format("%s\n%dM", name, math.floor(GetDist(object)))
                end
                task.wait(0.2)
            end
            if Bb then Bb:Destroy() end
        end)
    end
end

-- Auto Store & Tween Logic
local function AutoStore()
    if not UI_Module.Settings.AutoStore then return end
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool.Name:lower():find("fruit") then
            game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("StoreFruit", tool.Name, tool)
        end
    end
end

local function TweenTo(target)
    if not UI_Module.Settings.Tween_Enabled or not target then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if target:IsDescendantOf(char) or target:IsDescendantOf(Workspace.Characters) then return end
        local dist = GetDist(target)
        if dist < 5 then return end
        local targetCF = target:IsA("Model") and target:GetModelCFrame() or (target:IsA("Tool") and target.Handle.CFrame or target.CFrame)
        if currentTween then currentTween:Cancel() end
        currentTween = TweenService:Create(char.HumanoidRootPart, TweenInfo.new(dist/UI_Module.Settings.Tween_Speed, Enum.EasingStyle.Linear), {CFrame = targetCF})
        currentTween:Play()
    end
end

-- Logic Monitor
task.spawn(function()
    while task.wait(0.1) do
        if not UI_Module.Settings.Tween_Enabled and currentTween then currentTween:Cancel() currentTween = nil end
        if UI_Module.Settings.AutoStore then AutoStore() end
    end
end)

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