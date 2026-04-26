-- CatHUB SUPREMACY: Fruits Module v11.0
local UI = _G.UI_Lib
local LP = game:GetService("Players").LocalPlayer
local TS = game:GetService("TweenService")

local Tab = UI:NewTab("Fruits")
UI:NewSwitch(Tab, "ESP_Fruits", "Fruit ESP")
UI:NewSwitch(Tab, "AutoTweenFruit", "Auto Tween to Fruits")
UI:NewSwitch(Tab, "AutoStore", "Auto Store Fruit")

local function TweenToFruit(v)
    if not UI.Settings.AutoTweenFruit or _G.TPing then return end
    _G.TPing = true
    local dist = (v:GetModelCFrame().Position - LP.Character.PrimaryPart.Position).Magnitude
    local t = TS:Create(LP.Character.PrimaryPart, TweenInfo.new(dist/300, Enum.EasingStyle.Linear), {CFrame = v:GetModelCFrame()})
    t:Play()
    t.Completed:Wait()
    _G.TPing = false
end

task.spawn(function()
    while task.wait(1) do
        if UI.Settings.ESP_Fruits or UI.Settings.AutoTweenFruit then
            for _,v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") or (v:IsA("Model") and v.Name == "Fruit ") then
                    if UI.Settings.AutoTweenFruit then TweenToFruit(v) end
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