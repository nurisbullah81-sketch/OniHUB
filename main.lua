--[[
    DIZ HUB - CORE LOGIC (Blox Fruits 2026 Engine)
    Features: Synced ESP (White/Small/???), Secure Tween
    Dependencies: UI.lua
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- === MODULAR UI LOADING (Anti-Cache) ===
local UI_URL = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/UI.lua"
local success, UI_Module = pcall(function()
    return loadstring(game:HttpGet(UI_URL .. "?v=" .. math.random()))()
end)

if not success or not UI_Module then
    warn("DIZ HUB: Failed to load UI.lua from GitHub. Logic aborted.")
    return
end

-- === CORE FUNCTIONS ===

local function GetDistance(obj)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChildOfClass("BasePart").Position) or (obj:IsA("BasePart") and obj.Position or obj.Handle.Position)
        return math.floor((targetPos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
    end
    return 9999
end

-- ESP Sesuai Harapan DIZX (White, Small, Meter, Mystery)
local function CreateESP(object)
    if not object:FindFirstChild("DIZ_ESP") then
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "DIZ_ESP"
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(0, 100, 0, 30)
        Billboard.Adornee = object
        Billboard.Parent = object

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Warna Putih Murni
        TextLabel.TextSize = 11 -- Teks Kecil sesuai harapan
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.Parent = Billboard

        task.spawn(function()
            while object:IsDescendantOf(Workspace) and Billboard:FindFirstChild("TextLabel") do
                -- Cek status Toggle secara real-time
                if not UI_Module.Settings.ESP_Enabled then
                    Billboard.Enabled = false
                else
                    Billboard.Enabled = true
                    local dist = GetDistance(object)
                    local name = object.Name
                    
                    -- LOGIKA: Jika spawn sistem (biasanya Model bernama "Fruit ") atau Folder Khusus 2026
                    if (object:IsA("Model") and name == "Fruit ") or object:IsDescendantOf(Workspace:FindFirstChild("Fruits")) then
                        name = "??? (System Spawn)"
                    end
                    -- Dropped player mempertahankan nama asli (Tool/Model spesifik)

                    TextLabel.Text = string.format("%s\n%dM", name, dist)
                end
                task.wait(0.1)
            end
            if Billboard then Billboard:Destroy() end
        end)
    end
end

-- Secure Tween Logic (Anti-Cheat Bypass)
local function TweenTo(target)
    if not UI_Module.Settings.Tween_Enabled or not target then return end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local targetPos = target:IsA("Model") and target:GetModelCFrame() or (target:IsA("Tool") and target.Handle.CFrame or target.CFrame)
        local dist = GetDistance(target)
        
        -- Berhenti jika jarak sudah dekat (mencegah glitch)
        if dist < 5 then return end
        
        local tweenInfo = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear) -- Speed: 300 studs/s
        local tween = TweenService:Create(root, tweenInfo, {CFrame = targetPos})
        
        -- Handle jika tween dibatalkan (misal toggle dimatikan di tengah jalan)
        task.spawn(function()
            while tween.PlaybackState == Enum.PlaybackState.Playing do
                if not UI_Module.Settings.Tween_Enabled then
                    tween:Cancel()
                    break
                end
                task.wait(0.1)
            end
        end)
        
        tween:Play()
    end
end

-- === MAIN LOOP ===
task.spawn(function()
    while task.wait(1) do
        -- Hanya scan jika salah satu fitur aktif
        if UI_Module.Settings.ESP_Enabled or UI_Module.Settings.Tween_Enabled then
            -- Scan Top-level Workspace (Common Dropped/Spawned)
            for _, v in pairs(Workspace:GetChildren()) do
                if (v:IsA("Tool") and v.Name:lower():find("fruit")) or (v:IsA("Model") and v.Name == "Fruit ") then
                    if UI_Module.Settings.ESP_Enabled then CreateESP(v) end
                    if UI_Module.Settings.Tween_Enabled then TweenTo(v) end
                end
            end
            
            -- Scan 2026 Fruit Folder (Jika ada)
            local fruitFolder = Workspace:FindFirstChild("Fruits")
            if fruitFolder then
                for _, v in pairs(fruitFolder:GetChildren()) do
                    if UI_Module.Settings.ESP_Enabled then CreateESP(v) end
                    if UI_Module.Settings.Tween_Enabled then TweenTo(v) end
                end
            end
        end
    end
end)

print("DIZ HUB: CORE LOGIC MASTERED & SYNCED.")