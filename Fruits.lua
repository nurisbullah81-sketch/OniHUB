-- CatHUB SUPREMACY: Fruits Module v13.0
local UI = _G.UI
local LP = game:GetService("Players").LocalPlayer
local TS = game:GetService("TweenService")

local Tab = UI:NewTab("Fruits")
UI:NewSwitch(Tab, "ESP_Fruits", "Enable Fruit ESP")
UI:NewSwitch(Tab, "AutoTweenFruit", "Linear Tween to Fruits")
UI:NewSwitch(Tab, "AutoStore", "Auto Store to Treasure")

local function ApplyFruitESP(v)
    if v:FindFirstChild("Cat_ESP") then return end
    local Bb = Instance.new("BillboardGui", v); Bb.Name = "Cat_ESP"; Bb.AlwaysOnTop = true; Bb.Size = UDim2.new(0, 150, 0, 40)
    local T = Instance.new("TextLabel", Bb); T.Size = UDim2.new(1,0,1,0); T.BackgroundTransparency = 1; T.TextColor3 = Color3.fromRGB(255,255,255); T.TextStrokeTransparency = 0; T.Font = "SourceSansBold"; T.TextSize = 18
    task.spawn(function()
        while v:IsDescendantOf(workspace) do
            Bb.Enabled = UI.Settings.ESP_Fruits and not v:IsDescendantOf(LP.Character)
            if Bb.Enabled then
                local dist = math.floor((v:GetModelCFrame().Position - LP.Character.PrimaryPart.Position).Magnitude)
                T.Text = (v.Name == "Fruit " and "??? (System)" or v.Name) .. "\n[" .. dist .. "M]"
            end
            task.wait(0.3)
        end
    end)
end

task.spawn(function()
    while task.wait(1) do
        if UI.Settings.ESP_Fruits or UI.Settings.AutoTweenFruit then
            for _,v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") or (v:IsA("Model") and v.Name == "Fruit ") then
                    if UI.Settings.ESP_Fruits then ApplyFruitESP(v) end
                    if UI.Settings.AutoTweenFruit and not _G.TPing then
                        _G.TPing = true
                        local dist = (v:GetModelCFrame().Position - LP.Character.PrimaryPart.Position).Magnitude
                        local t = TS:Create(LP.Character.PrimaryPart, TweenInfo.new(dist/UI.Settings.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = v:GetModelCFrame()})
                        t:Play(); t.Completed:Wait(); _G.TPing = false
                    end
                end
            end
        end
        if UI.Settings.AutoStore then
            local t = LP.Character:FindFirstChildOfClass("Tool")
            if t and t.Name:lower():find("fruit") then
                game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("StoreFruit", t.Name, t)
            end
        end
    end
end)