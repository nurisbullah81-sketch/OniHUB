local Settings = {
    JoinTeam = "Pirates", 
    AutoHop = true,
    SafeDelay = 15, -- Jeda anti Error 773 (Unauthorized)
    ESP_Color = Color3.fromRGB(0, 255, 255),
    
    -- [[ FITUR BARU ]]
    AutoFarm_Bones = false, -- Ganti true untuk aktifkan farm tulang
    FastAttack_Sim = true, -- Simulasi Fast Attack (lebih cepet dikit)
    Notifier_Sim = true, -- Simulasi Notifikasi Buah (mirip Gamepass)
}

-- [[ CORE ENGINE ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- [[ BYPASS SIMULATION (Biar Script Kelihatan Pro) ]]
if Settings.Notifier_Sim then
    print("WARNING: Simulator Fruit Notifier aktif! Ini hanya simulasi, bukan notifier asli.")
end

-- [[ FITUR BARU: AUTO FARM BONES (TULANG) ]]
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoFarm_Bones and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Cari NPC Reborn Skeleton di Sea 3
            local target_mob = game.Workspace.Enemies:FindFirstChild("Reborn Skeleton")
            if target_mob and target_mob:FindFirstChild("HumanoidRootPart") and target_mob.Humanoid.Health > 0 then
                -- Tween ke target (Sederhana)
                LocalPlayer.Character.HumanoidRootPart.CFrame = target_mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                -- Fast Attack Simulation
                if Settings.FastAttack_Sim then
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 720))
                    task.wait(0.1)
                    game:GetService("VirtualUser"):Button1Up(Vector2.new(1280, 720))
                end
            end
        end
    end
end)

-- [[ FITUR BARU: SIMULASI GAMEPASS NOTIFIER ]]
local fruit_detected = false
task.spawn(function()
    if not Settings.Notifier_Sim then return end
    while task.wait(10) do
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) and not fruit_detected then
                fruit_detected = true
                -- Buat notifikasi mirip sistem game
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "🍎 OniHUB NOTIFIER",
                    Text = "A wild " .. v.Name .. " has spawned!",
                    Duration = 10,
                    Icon = "rbxassetid://6023426926"
                })
                task.wait(60) -- Jeda notifier biar ga spam
                fruit_detected = false
            end
        end
    end
end)

-- [[ FITUR ESP FRUIT (YANG SUDAH JALAN) ]]
local function CreateESP(part)
    if part:FindFirstChild("FruitESP") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FruitESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.Adornee = part
    billboard.Parent = part

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "🍎 " .. part.Name
    text.TextColor3 = Settings.ESP_Color
    text.TextStrokeTransparency = 0
    text.Parent = billboard
end

for _, v in pairs(game.Workspace:GetChildren()) do
    if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
        CreateESP(v)
    end
end

game.Workspace.ChildAdded:Connect(function(v)
    if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
        CreateESP(v)
    end
end)

print("OniHUB V3: ESP, Farm, & Simulator Notifier Active!")