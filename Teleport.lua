-- CatHUB FREEMIUM: Teleport Module
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TPTab = UI:CreateTab("Teleport")

local function CreateTP(p)
    if p == LocalPlayer then return end
    local C = Instance.new("Frame", TPTab)
    C.Size = UDim2.new(1, 0, 0, 35)
    C.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Instance.new("UICorner", C)

    local L = Instance.new("TextLabel", C)
    L.Size = UDim2.new(1, -70, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = p.Name:upper()
    L.TextColor3 = Color3.fromRGB(200, 200, 200)
    L.Font = Enum.Font.SourceSansBold
    L.TextSize = 10
    L.TextXAlignment = "Left"
    L.BackgroundTransparency = 1

    local B = Instance.new("TextButton", C)
    B.Size = UDim2.new(0, 50, 0, 20)
    B.Position = UDim2.new(1, -60, 0.5, -10)
    B.BackgroundColor3 = UI.AccentColor
    B.Text = "TP"
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", B)

    B.MouseButton1Click:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end)
end

local function Refresh()
    for _, v in pairs(TPTab:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do CreateTP(p) end
end

Players.PlayerAdded:Connect(Refresh)
Players.PlayerRemoving:Connect(RefreshList)
Refresh()