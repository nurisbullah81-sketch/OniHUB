-- [[ ==========================================
--      ONIHUB: STYLE UI (MACLIB FRAMEWORK)
--      100% HAK MILIK SENDIRI - ANTI NEBENG
--    ========================================== ]]

-- Path udah gue samain persis sama gaya loadstring lu!
local MyRepo = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"

-- Bikin Safe Loader biar ketauan errornya kalo gagal narik
local success, response = pcall(function()
    return game:HttpGet(MyRepo .. "Maclib.lua")
end)

if not success or string.find(response, "404: Not Found") then
    warn("[ONIHUB ERROR]: DAPET 404! Pastiin Maclib.lua beneran udah di-Push ke GitHub lu bang!")
    return
end

-- Jalanin Mesin Maclib
local Maclib = loadstring(response)()

-- BIKIN WINDOW UTAMA
local Window = Maclib:Window({
    Title = "ONIHUB",
    Subtitle = "Freemium Edition",
    Size = UDim2.fromOffset(600, 400),
    DragStyle = 1, 
    DisabledWindowControls = {},
    ShowUserInfo = true, 
    Keybind = Enum.KeyCode.RightControl, 
    AcrylicBlur = true, 
})

local MainGroup = Window:TabGroup()

local TabStatus   = MainGroup:Tab({ Name = "Status" })
local TabAutoFarm = MainGroup:Tab({ Name = "Auto Farm" })
local TabFruits   = MainGroup:Tab({ Name = "Devil Fruits" })
local TabMisc     = MainGroup:Tab({ Name = "Misc" })

_G.Oni = _G.Oni or {}
_G.Oni.UI = {
    Library = Maclib,
    Window  = Window,
    Tabs    = {
        Status   = TabStatus,
        AutoFarm = TabAutoFarm,
        DevilFruits = TabFruits,
        Misc     = TabMisc
    }
}

TabStatus:Select()