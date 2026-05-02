-- [[ ==========================================
--      ONIHUB: STYLE UI (MACLIB FRAMEWORK)
--      100% INDIE - NO NEBENG LINK ORANG!
--    ========================================== ]]

-- Sedot mesin Maclib dari GitHub lu sendiri!
-- Ganti "UsernameLu" pake nama GitHub lu beneran
local MyRepo = "https://raw.githubusercontent.com/UsernameLu/ONIHUB/main/Modules/"
local MacLib = loadstring(game:HttpGet(MyRepo .. "Maclib.lua"))()

-- 1. BIKIN WINDOW UTAMA (Ala MacOS)
local Window = MacLib:Window({
    Title = "ONIHUB",
    Subtitle = "Freemium Edition",
    Size = UDim2.fromOffset(600, 400),
    DragAuto = true, -- Biar bisa digeser-geser mulus
    Theme = MacLib.Themes.Default -- Tema bawaan Maclib yang aesthetic
})

-- 2. BIKIN GRUP TAB
local MainGroup = Window:TabGroup()

-- 3. BIKIN TAB MENU LU
local TabStatus   = MainGroup:Tab({ Name = "Status" })
local TabAutoFarm = MainGroup:Tab({ Name = "Auto Farm" })
local TabFruits   = MainGroup:Tab({ Name = "Devil Fruits" })
local TabMisc     = MainGroup:Tab({ Name = "Misc" })

-- 4. CONTOH ISI TAB AUTO FARM (Sesuai Gambar Dokumentasi Lu)
local FarmSection = TabAutoFarm:Section({ Name = "Main Farm Configuration" })

FarmSection:Toggle({
    Name = "Master switch (Auto Farm)",
    Default = false,
    Callback = function(State)
        print("Auto Farm Nyala?: ", State)
        -- Logic Auto Farm lu masuk sini nanti
    end
})

FarmSection:Slider({
    Name = "Hit Distance",
    Default = 10,
    Min = 5,
    Max = 20,
    Callback = function(Value)
        print("Jarak Hit: ", Value)
    end
})

-- 5. DAFTARIN KE GLOBAL BIAR BISA DIPANGGIL FILE LAIN DI VSCODE
_G.Oni = _G.Oni or {}
_G.Oni.UI = {
    Library = MacLib,
    Window  = Window,
    Tabs    = {
        Status   = TabStatus,
        AutoFarm = TabAutoFarm,
        Fruits   = TabFruits,
        Misc     = TabMisc
    }
}