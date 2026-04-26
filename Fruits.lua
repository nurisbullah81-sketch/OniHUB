-- CatHUB SUPREMACY: Fruits Module v9.0
local UI = _G.UI
local LP = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")

local Tab = UI:NewTab("Fruits")
UI:NewSwitch(Tab, "ESP_Fruits", "Enable Fruit ESP")
UI:NewSwitch(Tab, "AutoStore", "Auto Store to Inventory")

local function ApplyFruitESP(v)
    if v:FindFirstChild("Cat_ESP") then return end
    local Bb = Instance.new("BillboardGui", v)
    Bb.Name = "Cat_ESP"
    Bb.AlwaysOnTop = true
    Bb.Size = UDim2.new(0, 150, 0, 40)
    local T = Instance.new("TextLabel", Bb)
    T.Size = UDim2.new(1,0,1,0)
    T.BackgroundTransparency = 1
    T.TextColor3 = Color3.fromRGB(255, 255, 255)
    T.TextStrokeTransparency = 0
    T.Font = "SourceSansBold"
    T.TextSize = 18

    task.spawn(function()
        while v:IsDescendantOf(Workspace) do
            Bb.Enabled = UI.Settings.ESP_Fruits and not v:IsDescendantOf(LP.Character)
            if Bb.Enabled then
                local name = (v.Name == "Fruit " and "??? (System)" or v.Name)
                local dist = math.floor((v:GetModelCFrame().Position - LP.Character.PrimaryPart.Position).Magnitude)
                T.Text = name.."\n["..dist.."M]"
            end
            task.wait(0.3)
        end
    end)
end

-- Auto Store Logic
task.spawn(function()
    while task.wait(1) do
        if UI.Settings.AutoStore then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool and tool.Name:lower():find("fruit") then
                game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("StoreFruit", tool.Name, tool)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if UI.Settings.ESP_Fruits then
            for _,v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") or (v:IsA("Model") and v.Name == "Fruit ") then ApplyFruitESP(v) end
            end
        end
    end
end)