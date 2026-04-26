-- CatHUB SUPREMACY: ESP Module v10.0
local UI = _G.UI_Lib
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function CreatePlayerESP(p)
    p.CharacterAdded:Connect(function(char)
        if not char:FindFirstChild("Cat_Hl") then
            local hl = Instance.new("Highlight", char); hl.Name = "Cat_Hl"; hl.FillTransparency = 0.4; hl.OutlineTransparency = 0
            local bb = Instance.new("BillboardGui", char.PrimaryPart); bb.Name = "Cat_Bb"; bb.AlwaysOnTop = true; bb.Size = UDim2.new(0, 200, 0, 50)
            local t = Instance.new("TextLabel", bb); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255,255,255); t.TextStrokeTransparency = 0; t.Font = "SourceSansBold"; t.TextSize = 14
            
            task.spawn(function()
                while char:IsDescendantOf(workspace) do
                    hl.Enabled = UI.Settings.ESP_Players
                    bb.Enabled = UI.Settings.ESP_Players
                    if hl.Enabled then
                        local col = (p.Team == LP.Team and tostring(p.Team) == "Marines") and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 0, 0)
                        hl.FillColor = col; t.TextColor3 = col; t.Text = p.Name .. "\n[" .. math.floor((char.PrimaryPart.Position - LP.Character.PrimaryPart.Position).Magnitude) .. "M]"
                    end
                    task.wait(0.3)
                end
            end)
        end
    end)
end

for _,p in pairs(Players:GetPlayers()) do if p ~= LP then CreatePlayerESP(p) end end
Players.PlayerAdded:Connect(CreatePlayerESP)