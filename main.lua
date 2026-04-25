-- FILE: Main.lua
local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/nurisnullah81-sketch/OniHUB/main/Gui.lua"))()

-- LOGIKA ESP ANTI-BUG (Jarak Jauh & Tembus Tembok)
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
                    end
                end
            end
        else
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:FindFirstChild("OniHigh") then v.OniHigh:Destroy() end
            end
        end
    end
end)