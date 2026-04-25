-- OniHUB V5: INTERNAL UI + MAX ESP
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleESP = Instance.new("TextButton")

-- [UI SETUP - BIAR GA DOWNLOAD DARI LUAR]
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "OniHUB_Menu"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "OniHUB PRO"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

ToggleESP.Parent = MainFrame
ToggleESP.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleESP.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleESP.Text = "ENABLE ESP"
ToggleESP.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- [ESP JARAK JAUH TANPA BUG]
local ESP_Active = false
local function CreateAdvancedESP(obj)
    if obj:IsA("Tool") and (obj.Name:find("Fruit") or obj:FindFirstChild("Handle")) then
        local highlight = obj:FindFirstChild("OniHigh") or Instance.new("Highlight")
        highlight.Name = "OniHigh"
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- INI BIAR JARAK JAUH TEMBUS
        highlight.Enabled = ESP_Active
        highlight.Parent = obj
    end
end

ToggleESP.MouseButton1Click:Connect(function()
    ESP_Active = not ESP_Active
    ToggleESP.Text = ESP_Active and "ESP: ON" or "ESP: OFF"
    for _, v in pairs(game.Workspace:GetChildren()) do
        CreateAdvancedESP(v)
    end
end)

-- Auto-detect buat buah baru yang muncul
game.Workspace.ChildAdded:Connect(function(child)
    task.wait(0.5)
    CreateAdvancedESP(child)
end)

print("OniHUB V5 Loaded - No More Downgrade!")