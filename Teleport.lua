-- CatHUB SUPREMACY: Teleport Module v8.0
local UI = _G.UI
local LP = game:GetService("Players").LocalPlayer
local TS = game:GetService("TweenService")

local Tab = UI:NewTab("Teleport")
UI:NewSlider(Tab, "TweenSpeed", "TP Speed", 100, 1000)

local function TP(cf)
    local dist = (cf.Position - LP.Character.PrimaryPart.Position).Magnitude
    local t = TS:Create(LP.Character.PrimaryPart, TweenInfo.new(dist/UI.Settings.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = cf * CFrame.new(0,5,0)})
    t:Play()
    _G.TPing = true
    t.Completed:Connect(function() _G.TPing = false end)
end

local function Refresh()
    for _,v in pairs(Tab:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _,p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LP then
            local F = Instance.new("Frame", Tab)
            F.Size = UDim2.new(1, 0, 0, 35)
            F.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", F)
            local B = Instance.new("TextButton", F)
            B.Size = UDim2.new(1, 0, 1, 0)
            B.Text = p.Name:upper()
            B.TextColor3 = Color3.fromRGB(200, 200, 200)
            B.BackgroundTransparency = 1
            B.MouseButton1Click:Connect(function() if p.Character then TP(p.Character.PrimaryPart.CFrame) end end)
        end
    end
end

game:GetService("Players").PlayerAdded:Connect(Refresh)
Refresh()