-- OniHUB FINAL TEST | REDZ STYLE
local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/RedzLibV5/main/Source.lua"))()

local Window = RedzLib:MakeWindow({
  Name = "OniHUB PRO",
  SubTitle = "by SHEGUN RBLX",
  SaveFolder = "OniHUB_Config.json"
})

local MainTab = Window:MakeTab({ Name = "Visual", Icon = "eye" })

_G.ESP = false
MainTab:AddToggle({
  Name = "Fruit ESP (Tembus Pandang)",
  Default = false,
  Callback = function(v) 
    _G.ESP = v 
    if v then
       print("ESP Aktif, Sir!")
    end
  end
})

-- LOGIKA ESP ANTI-BUG
task.spawn(function()
    while task.wait(1) do
        if _G.ESP then
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