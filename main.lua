local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "OniHUB PRO | Blox Fruits",
   LoadingTitle = "Executing OniHUB...",
   LoadingSubtitle = "by SHEGUN RBLX",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "OniHUB_Data",
      FileName = "Config"
   }
})

local MainTab = Window:CreateTab("Main Features", 4483362458) -- Icon ID
local VisualTab = Window:CreateTab("Visuals", 4483345998)

-- [[ VARIABLE ESP ]]
local ESP_Enabled = false

-- [[ TAB VISUALS - ESP JARAK JAUH ]]
VisualTab:CreateToggle({
   Name = "Fruit ESP (Full Bright)",
   CurrentValue = false,
   Flag = "FruitESP",
   Callback = function(Value)
      ESP_Enabled = Value
   end,
})

-- SCRIPT ESP ANTI BUG
task.spawn(function()
    while task.wait(1) do
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                local hl = v:FindFirstChild("OniHighlight") or Instance.new("Highlight")
                hl.Name = "OniHighlight"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = v
                hl.Enabled = ESP_Enabled
                
                -- Tambah Label Nama
                if not v:FindFirstChild("OniLabel") then
                    local bill = Instance.new("BillboardGui", v)
                    bill.Name = "OniLabel"
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 200, 0, 50)
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    local lbl = Instance.new("TextLabel", bill)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.Text = "🍎 " .. v.Name
                    lbl.TextColor3 = Color3.new(1, 1, 1)
                    lbl.BackgroundTransparency = 1
                    lbl.TextStrokeTransparency = 0
                end
                v.OniLabel.Enabled = ESP_Enabled
            end
        end
    end
end)

-- [[ TAB MAIN - MISC ]]
MainTab:CreateButton({
   Name = "Join Pirates Team",
   Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
   end,
})

Rayfield:Notify({
   Title = "OniHUB Ready!",
   Content = "ESP and UI loaded successfully.",
   Duration = 5,
   Image = 4483345998,
})