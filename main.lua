local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "OniHUB | Blox Fruits", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "OniHUB_Configs",
    IntroText = "Welcome to OniHUB PRO"
})

-- [[ TAB MAIN ]]
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

-- [[ TAB VISUALS ]]
local VisualTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    Premium = false
})

_G.ESP_Fruit = false
VisualTab:AddToggle({
    Name = "Fruit ESP (Global)",
    Default = false,
    Callback = function(Value)
        _G.ESP_Fruit = Value
    end    
})

-- [[ LOGIKA ESP TEMBUS PANDANG ]]
task.spawn(function()
    while task.wait(1) do
        if _G.ESP_Fruit then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                    if not v:FindFirstChild("OniHigh") then
                        local hl = Instance.new("Highlight", v)
                        hl.Name = "OniHigh"
                        hl.FillColor = Color3.fromRGB(0, 255, 255)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        
                        local bill = Instance.new("BillboardGui", v)
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
            -- Hapus ESP kalau dimatiin
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:FindFirstChild("OniHigh") then v.OniHigh:Destroy() end
                if v:FindFirstChild("BillboardGui") then v.BillboardGui:Destroy() end
            end
        end
    end
end)

-- [[ SETTINGS & KEYBIND ]]
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    Premium = false
})

SettingsTab:AddBind({
    Name = "Open/Close Menu",
    Default = Enum.KeyCode.G, -- Lu tinggal tekan G atau kombinasi Ctrl+G di executor lu
    Hold = false,
    Callback = function()
        -- Library Orion otomatis handle hide/show pake Bind ini
    end    
})

OrionLib:Init()