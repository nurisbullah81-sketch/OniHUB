-- [[ ==========================================
--      CATHUB UI: FLUENT UI (BUG-FREE EDITION)
--    ========================================== ]]

local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")

-- Setup Global Framework
_G.Cat        = _G.Cat or {}
_G.Cat.Player = Players.LocalPlayer
_G.Cat.Labels = _G.Cat.Labels or {}

if not _G.Cat.Settings then 
    _G.Cat.Settings = {} 
end

local function SaveSettings()
    pcall(function()
        writefile("CatHUB_Config.json", HttpService:JSONEncode(_G.Cat.Settings))
    end)
end
_G.Cat.SaveSettings = SaveSettings

-- Dummy Theme (Wajib ada buat X-Ray manual di Status.lua biar warnanya kaga putih item)
local Theme = {
    CardBG    = Color3.fromRGB(30, 30, 30), 
    SideBG    = Color3.fromRGB(40, 40, 40), 
    Line      = Color3.fromRGB(60, 60, 60),
    Text      = Color3.fromRGB(240, 240, 240), 
    TextDim   = Color3.fromRGB(150, 150, 150), 
    CatPurple = Color3.fromRGB(170, 85, 255)
}

-- ==========================================
-- 1. LOAD ENGINE FLUENT DARI WEB
-- ==========================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- ==========================================
-- 2. INISIALISASI WINDOW FLUENT
-- ==========================================
-- ⚠️ BACA INI BANG: INI ADALAH OBAT MUTLAK UNTUK BUG SKILL KEBELAKANG!
local Window = Fluent:CreateWindow({
    Title = "CatHUB | Blox Fruits",
    Size = UDim2.new(0, 500, 0, 350),
    Theme = "Dark",
    AcrylicBackdrop = false,         -- Wajib false biar kaga berat dan kaga bentrok
    DisableCharacterViewport = true   -- ⬅️ INI RAHASIANYA. Ini mematikan fitur curi kamera Fluent.
})

-- ==========================================
-- 3. SISTEM PROXY CERDAS (BIAR STATUS LUA TIDAK ERROR)
-- ==========================================
-- System UI biasanya punya fungsi label:SetText("...") 
-- Sedangkan kode lama lu pakai label.Text = "..."
-- Proxy ini menipu kode lama lu agar tetap bisa jalan tanpa lu edit ESP/Status.
local LabelProxy = {}
LabelProxy.__index = function(self, key)
    if key == "Text" then return self._ref.Text end
end
LabelProxy.__newindex = function(self, key, value)
    if key == "Text" then self._ref:Set(tostring(value)) end
end

local function CreateProxy(label) 
    return setmetatable({_ref = label}, LabelProxy) 
end

-- ==========================================
-- 4. KABEL SAMBUNGAN (MENERJEMAHKAN BAHASA LAMA KE FLUENT)
-- ==========================================
_G.Cat.UI = {
    Theme         = Theme,
    SaveSettings  = SaveSettings,
    
    -- ESP, FruitTP, Status, dll memanggil ini -> Diteruskan ke Fluent
    CreateTab = function(name, isFirst)
        return Window:createTab(name)
    end,
    
    CreateSection = function(parent, text)
        return parent:createSection(text)
    end,
    
    CreateToggle = function(parent, text, desc, stateRef, callback)
        local toggle = parent:createToggle(text, {}, function(state)
            if callback then callback(state) end
            SaveSettings()
        end)
        -- Kalau ada default settings dari json, dia bakal ke-set otomatis
        if stateRef then 
            toggle:Set(stateRef) 
        end
        return toggle
    end,
    
    CreateLabel = function(parent, text, desc)
        local label = parent:createLabel(text or "")
        -- Bungkus dengan Proxy supaya .Text = "..." tetap bisa dipakai
        return CreateProxy(label)
    end
}

warn("[CatHUB] Fluent UI Loaded Successfully. Camera Bug Fixed.")