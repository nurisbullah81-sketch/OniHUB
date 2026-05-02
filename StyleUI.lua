-- [[ ==========================================
--      CATHUB PREMIUM: OBSIDIAN UI (TEMPLATE)
--    ========================================== ]]

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- ==========================================
-- 1. BIKIN WINDOW UTAMA
-- ==========================================
local Window = Library:CreateWindow({
    Title = "CatHUB [Freemium]",
    Center = true, -- Otomatis di tengah layar
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = false -- Dimatiin biar kaga ganggu aim skill
})

-- ==========================================
-- 2. BIKIN TAB MENU
-- ==========================================
local Tabs = {
    Status      = Window:AddTab('Status'),
    AutoFarm    = Window:AddTab('Auto Farm'),
    DevilFruits = Window:AddTab('Devil Fruits'),
    Misc        = Window:AddTab('Misc')
}

-- ==========================================
-- 3. CONTOH ISI KOSONGAN (BISA LU UBAH/HAPUS NANTI)
-- ==========================================

-- Bikin Kotak (Groupbox) di Tab Status bagian KIRI
local StatusBox = Tabs.Status:AddLeftGroupbox('Player Status')

-- Nambahin Teks (Label)
StatusBox:AddLabel('Level: Menunggu...')
StatusBox:AddLabel('Money: Menunggu...')

-- Bikin Kotak di Tab Auto Farm
local FarmBox = Tabs.AutoFarm:AddLeftGroupbox('Main Farm')

-- Nambahin Tombol On/Off (Toggle)
FarmBox:AddToggle('Toggle_AutoFarm', {
    Text = 'Enable Auto Farm',
    Default = false,
    Tooltip = 'Nyalakan untuk auto pukul NPC',
    Callback = function(Value)
        print("Auto Farm nyala?: ", Value)
        -- Logic auto farm lu masukin sini nanti
    end
})

-- ==========================================
-- 4. SETTING WATERMARK & THEME BAWAAN OBSIDIAN
-- ==========================================
Library:SetWatermark('CatHUB Premium | v1.0')

-- Fitur Dewa: Otomatis bikin menu Setting Warna & Save Data di Tab Misc
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()

ThemeManager:SetFolder('CatHUB')
SaveManager:SetFolder('CatHUB/main')

SaveManager:BuildConfigSection(Tabs.Misc)
ThemeManager:BuildThemeSection(Tabs.Misc)