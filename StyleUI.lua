-- [[ ==========================================
--      CATHUB PREMIUM: FLUENT UI WRAPPER
--    ========================================== ]]

local HttpService = game:GetService("HttpService")
local ConfigFile  = "CatHUB_Config.json"

_G.Cat = _G.Cat or {}
_G.Cat.Settings = _G.Cat.Settings or {}

-- // Function: Save Settings
local function SaveSettings()
    pcall(function()
        writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings))
    end)
end
_G.Cat.SaveSettings = SaveSettings

-- ==========================================
-- 1. LOAD FLUENT UI LIBRARY
-- ==========================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- ==========================================
-- 2. CREATE MAIN WINDOW
-- ==========================================
local Window = Fluent:CreateWindow({
    Title       = "CatHUB",
    SubTitle    = "[Freemium] Blox Fruits",
    TabWidth    = 160,
    Size        = UDim2.fromOffset(580, 460),
    Acrylic     = true, -- 🚨 INI KUNCI EFEK GLASSMORPHISM / BLUR TEMBUS PANDANG 🚨
    Theme       = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Pencet CTRL Kiri buat hide/show UI
})

-- ==========================================
-- 3. WRAPPER ENGINE (PENERJEMAH SCRIPT LAMA LU)
-- ==========================================
local Tabs = {}

local function CreateTab(name, isFirst)
    if not Tabs[name] then
        Tabs[name] = Window:AddTab({ Title = name, Icon = "" })
    end
    if isFirst then
        Window:SelectTab(1)
    end
    return Tabs[name]
end

local function CreateSection(parentTab, text)
    parentTab:AddSection(text)
end

local function CreateToggle(parentTab, text, description, stateRef, callback)
    local toggle = parentTab:AddToggle("T_"..text, {
        Title       = text,
        Description = description or "",
        Default     = stateRef or false,
        Callback    = function(state)
            if callback then callback(state) end
            SaveSettings()
        end
    })
    return toggle
end

local function CreateLabel(parentTab, text, description)
    local paragraph = parentTab:AddParagraph({
        Title   = text,
        Content = description or ""
    })

    -- 🚨 MAGIC TRICK (META-TABLE) 🚨
    -- Script lama lu update text pake cara: Label.Text = "..."
    -- Fluent UI update text pake cara: Paragraph:SetTitle("...")
    -- Biar lu ga usah capek ubah Status.lua, gue bikin jembatan gaib ini:
    local fakeLabel = {}
    setmetatable(fakeLabel, {
        __newindex = function(t, k, v)
            if k == "Text" then
                paragraph:SetTitle(v)
            end
        end
    })
    
    return fakeLabel
end

-- ==========================================
-- 4. PRE-INITIALIZE DEFAULT TABS
-- ==========================================
CreateTab("Status", true)
CreateTab("Auto Farm", false)
CreateTab("Devil Fruits", false)
CreateTab("Misc", false)

-- ==========================================
-- 5. EXPORT TO GLOBAL FRAMEWORK
-- ==========================================
_G.Cat.UI = {
    CreateTab     = CreateTab,
    CreateSection = CreateSection,
    CreateToggle  = CreateToggle,
    CreateLabel   = CreateLabel,
    Theme         = {}, -- Dikosongin karena Fluent udah punya tema sendiri
    SaveSettings  = SaveSettings
}

-- Notifikasi kalau berhasil
Fluent:Notify({
    Title   = "CatHUB Premium",
    Content = "UI Framework Loaded Successfully.",
    Duration = 5
})