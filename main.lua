-- OniHUB V4: MODULAR UI + ADVANCED ESP
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "OniHUB | Blox Fruits",
    SubTitle = "by SHEGUN RBLX",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" })
}

-- [[ SETTINGS ]]
local Options = Fluent.Options
local ESP_Enabled = false

-- [[ VISUALS TAB - ESP JARAK JAUH ]]
Tabs.Visuals:AddToggle("FruitESP", {Title = "Fruit ESP (Global)", Default = false}):OnChanged(function(Value)
    ESP_Enabled = Value
end)

-- Fungsi ESP Jarak Jauh (Pake Highlight biar Tembus Tembok)
local function ApplyESP(v)
    if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
        if not v:FindFirstChild("OniHighlight") then
            local hl = Instance.new("Highlight")
            hl.Name = "OniHighlight"
            hl.FillColor = Color3.fromRGB(0, 255, 255)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = v
            
            local bill = Instance.new("BillboardGui", v)
            bill.AlwaysOnTop = true
            bill.Size = UDim2.new(0, 200, 0, 50)
            bill.StudsOffset = Vector3.new(0, 2, 0)
            local lbl = Instance.new("TextLabel", bill)
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.Text = "🍎 " .. v.Name
            lbl.TextColor3 = Color3.new(1, 1, 1)
            lbl.BackgroundTransparency = 1
            lbl.TextStrokeTransparency = 0
        end
        v.OniHighlight.Enabled = ESP_Enabled
        v.BillboardGui.Enabled = ESP_Enabled
    end
end

-- Looping Jarak Jauh
task.spawn(function()
    while task.wait(1) do
        for _, v in pairs(game.Workspace:GetChildren()) do
            ApplyESP(v)
        end
    end
end)

-- [[ MAIN TAB - MISC ]]
Tabs.Main:AddButton({
    Title = "Join Pirates",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end
})

Window:SelectTab(1)
Fluent:Notify({
    Title = "OniHUB",
    Content = "Script Loaded Successfully!",
    Duration = 5
})