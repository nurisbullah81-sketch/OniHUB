-- [[ ==========================================
--      ONIHUB: STYLE UI (OBSIDIAN FRAMEWORK)
--    ========================================== ]]

-- 1. Sedot Mesin Obsidian (Nebeng mesinnya doang, script tetep milik lu)
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- Matikan kursor bawaan UI biar aim skill buah kaga nyangkut
Library.ShowCustomCursor = false 

-- 2. Bikin Window Utama ONIHUB
local Window = Library:CreateWindow({
    Title = "ONIHUB [Freemium]",
    Center = true,
    AutoShow = true,
    Resizable = true,
    NotifySide = "Right",
    ShowCustomCursor = false
})

-- 3. Bikin Tab Utama
local Tabs = {
    Status      = Window:AddTab("Status"),
    AutoFarm    = Window:AddTab("Auto Farm"),
    DevilFruits = Window:AddTab("Devil Fruits"),
    Misc        = Window:AddTab("Misc", "settings") -- Pake icon gear dari lucide.dev
}

-- 4. DAFTARIN KE GLOBAL (INI YANG PALING PENTING BUAT VSCODE LU)
-- Biar file lain kayak Status.lua dan Main.lua bisa manggil UI ini
_G.Oni = _G.Oni or {}
_G.Oni.UI = {
    Library = Library,
    Window  = Window,
    Tabs    = Tabs,
    Options = Library.Options,
    Toggles = Library.Toggles
}

-- 5. Build Theme & Save Manager di Tab Misc
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()

ThemeManager:SetFolder("ONIHUB")
SaveManager:SetFolder("ONIHUB/main")

SaveManager:BuildConfigSection(Tabs.Misc)
ThemeManager:BuildThemeSection(Tabs.Misc)