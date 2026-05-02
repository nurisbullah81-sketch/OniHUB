-- [[ ==========================================
--      CATHUB PREMIUM: FLUENT UI (DIRECT EMBED)
--    ========================================== ]]

local HttpService = game:GetService("HttpService")
local ConfigFile  = "CatHUB_Config.json"

_G.Cat = _G.Cat or {}
_G.Cat.Settings = _G.Cat.Settings or {}

local function SaveSettings()
    pcall(function()
        writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings))
    end)
end
_G.Cat.SaveSettings = SaveSettings

-- ==========================================
-- 1. EMBED FLUENT LANGSUNG DI DALAM FILE INI
-- ==========================================
local Fluent = loadstring(readfile("Fluent.lua"))()

-- ==========================================
-- 2. BUAT WINDOW FLUENT
-- ==========================================
local Window = nil

if Fluent then
    Window = Fluent:CreateWindow({
        Title       = "CatHUB",
        SubTitle    = "[Freemium] Blox Fruits",
        TabWidth    = 160,
        Size        = UDim2.fromOffset(580, 460),
        Acrylic     = true, -- Biarkan true, efek kacanya tetap ada
        Theme       = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- ==========================================
    -- 3. OBAT RAHASIA (FIX POSISI POJOK & SKILL NYANGKUK)
    -- ==========================================
    task.spawn(function()
        task.wait(2) -- Wajib tunggu 2 detik
        
        -- OBAT A: HANCURKAN DepthOfField PENCURI KAMERA
        -- Fluent bikin ini di Lighting. Ini yang bikin skill lu nembak ke belakang.
        for _, obj in pairs(game:GetService("Lighting"):GetChildren()) do
            if obj:IsA("DepthOfFieldEffect") then
                obj:Destroy()
            end
        end
        
        -- OBAT B: PAKSA UI KE TENGAH LAYAR
        -- Pintu belakang Fluent menyimpan Frame utama (WindowFrame)
        local FluentGlobal = getfenv(0).Fluent or getgenv().Fluent
        if FluentGlobal and FluentGlobal.WindowFrame then
            local Root = FluentGlobal.WindowFrame
            Root.AnchorPoint = Vector2.new(0.5, 0.5)
            Root.Position = UDim2.fromScale(0.5, 0.5)
        end
    end)
end

-- ==========================================
-- 4. WRAPPER ENGINE (JEMBATAN KE SCRIPT LAMA)
-- ==========================================
local Tabs = {}

local function CreateTab(name, isFirst)
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
        return { Text = text or "" } -- Dummy biar ga error
    end

    local paragraph = parentTab:AddParagraph({
        Title   = text,
        Content = description or ""
    })

    -- Meta-table magic biar script lama bisa nulis label.Text = "..."
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
-- 5. PRE-INITIALIZE TABS & EXPORT GLOBAL
-- ==========================================
CreateTab("Status", true)
CreateTab("Auto Farm", false)
CreateTab("Devil Fruits", false)
CreateTab("Misc", false)

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
            Content = "UI Embedded & Loaded.",
            Duration = 3
        })
    end)
end