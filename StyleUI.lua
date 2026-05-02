-- [[ ==========================================
--      ONIHUB: STYLE UI (MACLIB FRAMEWORK)
--      100% HAK MILIK SENDIRI - ANTI NEBENG
--    ========================================== ]]

-- 1. PANGGIL MESIN DARI GITHUB LU SENDIRI (ONIHUB)
local MyRepo = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/main/"
local Maclib = loadstring(game:HttpGet(MyRepo .. "Maclib.lua"))()

-- 2. BIKIN WINDOW UTAMA ONIHUB (Bodi dasar Apple/Mac)
local Window = Maclib:Window({
    Title = "ONIHUB",
    Subtitle = "Freemium Edition",
    Size = UDim2.fromOffset(600, 400),
    DragStyle = 1, -- Biar jendelanya bisa digeser-geser mulus
    DisabledWindowControls = {},
    ShowUserInfo = true, -- Nampilin foto profil Roblox lu di kiri atas
    Keybind = Enum.KeyCode.RightControl, -- Tombol buat hide/unhide UI
    AcrylicBlur = true, -- Nyalain efek kaca transparan blur
})

-- 3. BIKIN GRUP TAB & MENU SAMPING
local MainGroup = Window:TabGroup()

-- Bikin Menu Tab sesuai sistem lama lu
local TabStatus   = MainGroup:Tab({ Name = "Status" })
local TabAutoFarm = MainGroup:Tab({ Name = "Auto Farm" })
local TabFruits   = MainGroup:Tab({ Name = "Devil Fruits" })
local TabMisc     = MainGroup:Tab({ Name = "Misc" })

-- 4. DAFTARIN UI KE GLOBAL ENVIRONMENT (_G)
-- Biar Status.lua dan Main.lua tetep bisa kerja tanpa keganggu
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

-- Pilih Tab Status otomatis pas pertama buka
TabStatus:Select()

-- Notifikasi kalau sukses nge-load dari server sendiri
Window:Notify({
    Title = "ONIHUB System",
    Description = "UI Berhasil Dimuat dari GitHub Sendiri!",
    Lifetime = 5
})