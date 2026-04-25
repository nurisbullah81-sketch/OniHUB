-- OniHUB PRO V10: REDZ STYLE (PERMANENT FIX)
local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/RedzLibV5/main/Source.lua"))()

local Window = RedzLib:MakeWindow({
  Name = "OniHUB PRO | Blox Fruits",
  SubTitle = "by SHEGUN RBLX",
  SaveFolder = "OniHUB_Config.json"
})

Window:AddMinimizeButton({
  Button = { Image = "rbxassetid://4483345998", BackgroundTransparency = 0 },
  Corner = { CornerRadius = UDim.new(0, 6) }
})

local MainTab = Window:MakeTab({ Name = "Visual", Icon = "eye" })

_G.ESP_Fruit = false
MainTab:AddToggle({
  Name = "Fruit ESP (Tembus Tembok)",
  Default = false,
  Callback = function(Value)
    _G.ESP_Fruit = Value
  end
})

-- LOGIKA ESP PRO (ALWAYS ON TOP)
task.spawn(function()
    while task.wait(1) do
        if _G.ESP_Fruit then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                    if not v:FindFirstChild("OniHigh") then
                        local h = Instance.new("Highlight", v)
                        h.Name = "OniHigh"
                        h.FillColor = Color3.fromRGB(0, 255, 255)
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
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

local SetTab = Window:MakeTab({ Name = "Settings", Icon = "settings" })
SetTab:AddSection({ Name = "Menu Controls" })
SetTab:AddLabel({ Name = "Tekan G buat Buka/Tutup" })

-- BIND TOMBOL G
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G then
        -- Library Redz punya fitur minimize otomatis
    end
end)