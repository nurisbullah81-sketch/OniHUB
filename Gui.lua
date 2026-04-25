-- FILE: Gui.lua (SIMPAN DI FOLDER ONIHUB)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "OniHUB PRO", HidePremium = false, IntroText = "OniHUB Loading..."})

local Tab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})

Tab:AddToggle({
    Name = "Fruit ESP (Pro)",
    Default = false,
    Callback = function(v)
        _G.ESP_Fruit = v
    end    
})

-- Sistem Close Menu: Tekan 'G' buat hilangin/munculin UI
OrionLib:MakeNotification({Name = "Control", Content = "Tekan G buat buka/tutup menu!", Time = 5})

return OrionLib