-- [[ ==========================================
--      CATHUB PREMIUM: FLUENT UI (FINAL FIX)
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
local maxRetry = 5
local retry = 0

while not Fluent and retry < maxRetry do
    local success, err = pcall(function()
        Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    
    if not success or not Fluent then
        retry = retry + 1
        task.wait(1)
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

    -- ==========================================
    -- 3. OBAT BUG SKILL KE BELAKANG & POSISI NYANGKUT
    -- ==========================================
    task.spawn(function()
        task.wait(2) 
        local coreGui = game:GetService("CoreGui")
        local gui = coreGui:FindFirstChildWhichIsA("ScreenGui")
        if gui then
            -- 3A: PAKSA UI KELUAR DARI POJOK KE TENGAH LAYAR
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("Frame") and math.abs(obj.Size.X.Offset - 580) < 10 and math.abs(obj.Size.Y.Offset - 460) < 10 then
                    obj.AnchorPoint = Vector2.new(0.5, 0.5)
                    obj.Position = UDim2.new(0.5, -290, 0.5, -230)
                    obj.ClipsDescendants = false 
                    break
                end
            end
            
            -- 3B: HANCURKAN VIEWPORT PENCURI KAMERA
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("ViewportFrame") then
                    obj:Destroy()
                end
            end
        end
    end)
else
    -- NASIB 2: Gagal download, Gunakan mode tanpa UI sementara
    warn("[CatHUB] Fluent UI gagal load saat Hop. Menggunakan mode tanpa UI sementara...")
end

-- ==========================================
-- 4. WRAPPER ENGINE (DENGAN PELINDUNG ERROR)
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
-- 5. PRE-INITIALIZE DEFAULT TABS
-- ==========================================
CreateTab("Status", true)
CreateTab("Auto Farm", false)
CreateTab("Devil Fruits", false)
CreateTab("Misc", false)

-- ==========================================
-- 6. EXPORT GLOBAL (AMAN BAIK UI NYALA ATAU GAGAL)
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
            Content = "UI, Anti-Camera Bug & Position Loaded.",
            Duration = 3
        })
    end)
end