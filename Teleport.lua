-- CatHUB v7.0: Teleport
local UI = _G.CatHUB_UI
local Cache = _G.CatCache
local TweenService = game:GetService("TweenService")

local Tab = UI:CreateTab("🏝️ Teleport")
UI:CreateSlider(Tab, "TweenSpeed", "Tween Speed", 200, 800, nil)

local Islands = {
    {"Pirate Village", CFrame.new(1045, 15, 1585)},
    {"Marine Fortress", CFrame.new(-2550, 73, 2040)},
    {"Jungle", CFrame.new(-1180, 15, 3800)},
    {"Skylands", CFrame.new(-4850, 750, -2600)},
    {"Colosseum", CFrame.new(-1450, 50, -300)},
    {"Magma Village", CFrame.new(-5500, 60, 600)},
    {"Fishman Island", CFrame.new(61000, 5, 1500)},
    {"Dressrosa", CFrame.new(6400, 100, -200)},
    {"Green Zone", CFrame.new(-2400, 70, -3100)},
    {"Kingdom of Rose", CFrame.new(-2300, 100, -7350)},
    {"Graveyard", CFrame.new(-5400, 200, -800)},
    {"Snow Mountain", CFrame.new(1300, 400, -5200)},
    {"Hot and Cold", CFrame.new(-6000, 100, -5000)},
    {"Sea of Treats", CFrame.new(-1000, 40, 6800)},
    {"Tiki Outpost", CFrame.new(-16500, 50, -50)},
    {"Great Tree", CFrame.new(2100, 1600, -6200)},
    {"Port Town", CFrame.new(-300, 50, -10500)},
    {"Hydra Island", CFrame.new(-4950, 500, -7200)},
    {"Floating Turtle", CFrame.new(-13000, 200, -8500)},
    {"Cake Island", CFrame.new(-1900, 40, -11000)},
    {"Prehistoric Island", CFrame.new(-1200, 80, -17500)},
    {"Mystic Island", CFrame.new(-6500, 200, -17500)},
}

UI:CreateSection(Tab, "ISLANDS")

local scroll = Instance.new("ScrollingFrame", Tab)
scroll.Size = UDim2.new(1, 0, 1, -80)
scroll.Position = UDim2.new(0, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 2)

for _, island in pairs(Islands) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    btn.Text = "⚡ " .. island[1]
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.TextXAlignment = "Left"
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 8)

    local teleporting = false
    btn.MouseButton1Click:Connect(function()
        if teleporting then return end
        teleporting = true
        btn.Text = "TELEPORTING..."
        pcall(function()
            local hrp = Cache.HumanoidRootPart
            local dist = (island[2].Position - hrp.Position).Magnitude
            local speed = math.clamp(UI.Settings.TweenSpeed or 350, 200, 800)
            TweenService:Create(hrp, TweenInfo.new(dist / speed, Enum.EasingStyle.Linear), {CFrame = island[2]}):Play()
            task.wait(dist / speed + 0.5)
        end)
        btn.Text = "⚡ " .. island[1]
        teleporting = false
    end)
end

print("[CatHUB] Teleport loaded")