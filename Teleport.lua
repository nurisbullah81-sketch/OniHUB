-- CatHUB FREEMIUM: Teleport Module (v5.0 Smooth Tween)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local TPTab = UI:CreateTab("Teleport")

local function TweenTP(targetCF)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    _G.CatHUB_TPing = true
    local dist = (targetCF.Position - hrp.Position).Magnitude
    local tInfo = TweenInfo.new(dist/300, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tInfo, {CFrame = targetCF * CFrame.new(0, 5, 0)})
    
    tween:Play()
    tween.Completed:Wait()
    _G.CatHUB_TPing = false
end

local function Refresh()
    for _, v in pairs(TPTab:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local C = Instance.new("Frame", TPTab)
            C.Size = UDim2.new(1, 0, 0, 35)
            C.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", C)
            local B = Instance.new("TextButton", C)
            B.Size = UDim2.new(1, -60, 1, 0)
            B.Text = p.Name:upper()
            B.TextColor3 = Color3.fromRGB(200, 200, 200)
            B.BackgroundTransparency = 1
            local TP = Instance.new("TextButton", C)
            TP.Size = UDim2.new(0, 50, 0, 22)
            TP.Position = UDim2.new(1, -55, 0.5, -11)
            TP.BackgroundColor3 = UI.AccentColor
            TP.Text = "TWEEN"
            TP.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", TP)
            
            TP.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    TweenTP(p.Character.HumanoidRootPart.CFrame)
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(Refresh)
Refresh()