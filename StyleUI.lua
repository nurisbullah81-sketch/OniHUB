-- [[ ==========================================
--      CATHUB PREMIUM: FLUENT UI (ANTI-HOP CRASH)
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
-- 1. LOAD FLUENT DENGAN SISTEM PAKSAAN (ANTI GAGAL)
-- ==========================================
local Fluent = nil
local maxRetry = 5 -- Coba download maksimal 5 kali
local retry = 0

while not Fluent and retry < maxRetry do
    local success, err = pcall(function()
        Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    
    if not success or not Fluent then
        retry = retry + 1
        task.wait(1) -- Tunggu 1 detik, coba lagi
    end
end

-- ==========================================
-- 2. PENENTUAN NASIB UI
-- ==========================================
local Window = nil

if Fluent then
    -- NASIB 1: Berhasil download, UI Mewah nyala
    Window = Fluent:CreateWindow({
        Title       = "CatHUB",
        SubTitle    = "[Freemium] Blox Fruits",
        TabWidth    = 160,
        Size        = UDim2.fromOffset(580, 460),
        Acrylic     = true, 
        Theme       = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- Obat Bug Skill ke belakang
    task.spawn(function()
        task.wait(3)
        local coreGui = game:GetService("CoreGui")
        local gui = coreGui:FindFirstChildWhichIsA("ScreenGui")
        if gui then
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("ViewportFrame") then
                    obj:Destroy()
                end
            end
        end
    end)
else
    -- NASIB 2: Gagal download karena lag Hop, Gunakan UI Dummy
    -- Tujuannya: MEMBIARKAN ESP DAN AUTO HOP TETAP JALAN WALAUPUN TANPA LAYAR UI
    warn("[CatHUB] Fluent UI gagal load saat Hop. Menggunakan mode tanpa UI sementara...")
end

-- ==========================================
-- 3. WRAPPER ENGINE (DENGAN PELINDUNG ERROR)
-- ==========================================
local Tabs = {}

local function CreateTab(name, isFirst)
    -- Cegah error kalau UI memang gagal load
    if not Window then return {} end
    
    if not Tabs[name] then
        Tabs[name] = Window:AddTab({ Title = name, Icon = "" })
    end
    if isFirst then
        pcall(function() Window:SelectTab(1) end)
    end
    return Tabs[name]
end

local function CreateSection(parentTab, text)
    if not Window then return end
    parentTab:AddSection(text)
end

local function CreateToggle(parentTab, text, description, stateRef, callback)
    if not Window then return end
    
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
    if not Window then 
        -- Kembalikan objek palsu yang bisa ditulis .Text supaya Status.lua kaga error
        return { Text = text or "" } 
    end

    local paragraph = parentTab:AddParagraph({
        Title   = text,
        Content = description or ""
    })

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
-- 5. EXPORT GLOBAL (AMAN BAIK UI NYALA ATAU GAGAL)
-- ==========================================
_G.Cat.UI = {
    CreateTab     = CreateTab,
    CreateSection = CreateSection,
    CreateToggle  = CreateToggle,
    CreateLabel   = CreateLabel,
    Theme         = {},
    SaveSettings  = SaveSettings
}

if Fluent then
    pcall(function()
        Fluent:Notify({
            Title   = "CatHUB Premium",
            Content = "UI & Anti-Camera Bug Loaded.",
            Duration = 3
        })
    end)
end