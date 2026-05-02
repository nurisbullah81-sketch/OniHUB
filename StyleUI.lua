-- [[ ==========================================
--      ONIHUB: REDZLIB V5 STYLE UI
--      100% HAK MILIK SENDIRI - MENGGUNAKAN MESIN LOKAL
--    ========================================== ]]

local Players = game:GetService("Players")
repeat task.wait() until Players.LocalPlayer

-- Panggil mesin dari GitHub lu sendiri
local MyRepo = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"
local success, response = pcall(function()
    return game:HttpGet(MyRepo .. "RedzLib.lua")
end)

if not success or string.find(response, "404: Not Found") then
    warn("[ONIHUB ERROR]: DAPET 404! Pastiin file RedzLib.lua udah di-Push ke GitHub!")
    return
end

local redzlib = loadstring(response)()

-- BIKIN WINDOW UTAMA (Syntax persis RedzLib V5)
local Window = redzlib:MakeWindow({
    Title = "ONIHUB : Blox Fruits",
    SubTitle = "by VirusTrojan",
    SaveFolder = "OniHubConfig"
})

-- BIKIN TAB MENU
local TabStatus   = Window:MakeTab({"Status", "info"})
local TabAutoFarm = Window:MakeTab({"Auto Farm", "swords"})
local TabMisc     = Window:MakeTab({"Misc", "settings"})

-- ISI TAB STATUS
TabStatus:AddSection({"Player Information"})

local LblLevel = TabStatus:AddParagraph({"Level", "Waiting for Data..."})
local LblBeli  = TabStatus:AddParagraph({"Beli", "Waiting for Data..."})

-- ISI TAB AUTO FARM
TabAutoFarm:AddSection({"Main Farm Configuration"})

local ToggleFarm = TabAutoFarm:AddToggle({
    Name = "Enable Auto Farm",
    Description = "Turn ON to start farming",
    Default = false
})

ToggleFarm:Callback(function(State)
    print("Auto Farm is now:", State)
    -- Logic Auto Farm lu taruh sini ntar
end)

TabAutoFarm:AddSlider({
    Name = "Hit Distance",
    Min = 5,
    Max = 20,
    Increase = 1,
    Default = 10,
    Callback = function(Value)
        print("Distance:", Value)
    end
})

-- DAFTARIN KE GLOBAL (_G) BIAR BISA DIAKSES FILE LAIN
_G.Oni = _G.Oni or {}
_G.Oni.UI = {
    Library = redzlib,
    Window  = Window,
    Tabs    = {
        Status   = TabStatus,
        AutoFarm = TabAutoFarm,
        Misc     = TabMisc
    },
    Labels = {
        Level = LblLevel,
        Beli  = LblBeli
    },
    Toggles = {
        AutoFarm = ToggleFarm
    }
}