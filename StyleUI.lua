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
    Acrylic     = true, -- Biarkan true biar efek kacanya tetap ada
    Theme       = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ==========================================
-- 3. OBAT BUG SKILL KE BELAKANG (MENGHANCURKAN VIEWPORT PENCURI KAMERA)
-- ==========================================
task.spawn(function()
    task.wait(3) -- Wajib tunggu 3 detik biar Fluent selesai bikin UI 3D-nya dulu
    local coreGui = game:GetService("CoreGui")
    local gui = coreGui:FindFirstChildWhichIsA("ScreenGui")
    if gui then
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("ViewportFrame") then
                obj:Destroy() -- Hancurkan si pencuri kamera
            end
        end
    end
end)

-- ==========================================
-- 4. WRAPPER ENGINE (PENERJEMAH SCRIPT LAMA LU)
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

    -- Magic Trick Meta-table biar Status.lua tetap bisa pakai .Text = "..."
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
-- 5. PRE-INITIALIZE DEFAULT TABS
-- ==========================================
CreateTab("Status", true)
CreateTab("Auto Farm", false)
CreateTab("Devil Fruits", false)
CreateTab("Misc", false)

-- ==========================================
-- 6. EXPORT TO GLOBAL FRAMEWORK
-- ==========================================
_G.Cat.UI = {
    CreateTab     = CreateTab,
    CreateSection = CreateSection,
    CreateToggle  = CreateToggle,
    CreateLabel   = CreateLabel,
    Theme         = {},
    SaveSettings  = SaveSettings
}

-- Notifikasi kalau berhasil
Fluent:Notify({
    Title   = "CatHUB Premium",
    Content = "UI Framework Loaded Successfully.",
    Duration = 5
})