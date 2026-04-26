-- CatHUB FREEMIUM: Teleport Module (No-Snap Back)
local UI = _G.CatHUB_UI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function SafeTP(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        
        -- Matikan Velocity
        hrp.Velocity = Vector3.new(0, 0, 0)
        
        -- Teleport
        hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
        
        -- Anchor Lock (Mencegah Snap Back)
        hrp.Anchored = true
        task.wait(0.2)
        hrp.Anchored = false
    end
end

local TPTab = UI:CreateTab("Teleport")
local function Refresh()
    for _, v in pairs(TPTab:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local C = Instance.new("Frame", TPTab)
            C.Size = UDim2.new(1, 0, 0, 35)
            C.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            Instance.new("UICorner", C)
            local B = Instance.new("TextButton", C)
            B.Size = UDim2.new(1, 0, 1, 0)
            B.Text = p.Name:upper()
            B.TextColor3 = Color3.fromRGB(200, 200, 200)
            B.BackgroundTransparency = 1
            B.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    SafeTP(p.Character.HumanoidRootPart.CFrame)
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(Refresh)
Refresh()