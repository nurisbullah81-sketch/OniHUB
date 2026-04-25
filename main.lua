-- OniHUB PRO V9: FINAL STABLE (SINGLE FILE)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "OniHUB PRO", HidePremium = false, SaveConfig = true, IntroText = "OniHUB Loading..."})

-- [[ TAB VISUALS ]]
local Tab1 = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483345998"})

_G.ESP = false
Tab1:AddToggle({
    Name = "Fruit ESP (Jarak Jauh)",
    Default = false,
    Callback = function(v) _G.ESP = v end
})

-- LOGIKA ESP ANTI-BUG (Highlight Tembus Tembok)
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

-- [[ TAB SETTINGS ]]
local Tab2 = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://4483345998"})
Tab2:AddLabel("Tekan G untuk Buka/Tutup Menu")

OrionLib:Init()