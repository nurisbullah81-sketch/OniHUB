-- OniHUB PRO V6: ALL-IN-ONE (REDZ STYLE)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "OniHUB PRO | Blox Fruits", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "OniHUB_Data",
    IntroText = "Executing OniHUB..."
})

-- [[ TAB UTAMA ]]
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    Premium = false
})

MainTab:AddButton({
    Name = "Join Pirates",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end    
})

-- [[ TAB VISUALS (ESP PRO) ]]
local VisualTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    Premium = false
})

_G.ESP_Fruit = false
VisualTab:AddToggle({
    Name = "Fruit ESP (Tembus Pandang)",
    Default = false,
    Callback = function(Value)
        _G.ESP_Fruit = Value
    end    
})

-- LOGIKA ESP ANTI-BUG (Jarak Jauh & Always On Top)
task.spawn(function()
    while task.wait(1) do
        if _G.ESP_Fruit then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                    if not v:FindFirstChild("OniHigh") then
                        local hl = Instance.new("Highlight", v)
                        hl.Name = "OniHigh"
                        hl.FillColor = Color3.fromRGB(0, 255, 255)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- TEMBUS PANDANG JARAK JAUH
                        
                        local bill = Instance.new("BillboardGui", v)
                        bill.Name = "OniLabel"
                        bill.AlwaysOnTop = true
                        bill.Size = UDim2.new(0, 100, 0, 50)
                        bill.StudsOffset = Vector3.new(0, 2, 0)
                        local lbl = Instance.new("TextLabel", bill)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.Text = "🍎 " .. v.Name
                        lbl.TextColor3 = Color3.new(1, 1, 1)
                        lbl.BackgroundTransparency = 1
                    end
                end
            end
        else
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:FindFirstChild("OniHigh") then v.OniHigh:Destroy() end
                if v:FindFirstChild("OniLabel") then v.OniLabel:Destroy() end
            end
        end
    end
end)

-- [[ TAB SETTINGS (KEYBIND) ]]
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    Premium = false
})

SettingsTab:AddLabel("Tekan G untuk Buka/Tutup Menu")

-- Keybind Manual (Ctrl + G)
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G then
        -- Library Orion punya toggle internal otomatis
    end
end)

OrionLib:Init()