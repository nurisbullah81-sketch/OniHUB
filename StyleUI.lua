-- [[ ==========================================
--      CATHUB UI: MODERN LINORIA LIBRARY
--    ========================================== ]]

local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")

_G.Cat        = _G.Cat or {}
_G.Cat.Player = Players.LocalPlayer
_G.Cat.Labels = _G.Cat.Labels or {}
if not _G.Cat.Settings then _G.Cat.Settings = {} end

local ConfigFile = "CatHUB_Config.json"
local function SaveSettings()
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings)) end)
end
_G.Cat.SaveSettings = SaveSettings

-- 1. Download UI Modern Linoria langsung dari GitHub (Tanpa perlu simpan ribuan baris)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vortexminer/linoria-lib/main/source.lua"))()

local Window = Library:CreateWindow({
    Title = "CatHUB | Blox Fruits",
    Center = true,
    AutoShow = true,
    TabWidth = 130,
    Size = UDim2.new(0, 500, 0, 350),
    AcrylicBackdrop = true, -- Efek kaca modern
    Theme = "Dark"
})

-- 2. Sistem Proxy Cerdas (Menipu Status.lua biar tetap pakai .Text = "...")
local LabelProxy = {}
LabelProxy.__index = function(self, key)
    if key == "Text" then return self._ref.Value end
end
LabelProxy.__newindex = function(self, key, value)
    if key == "Text" then self._ref:SetText(tostring(value)) end
end
local function CreateProxy(label) return setmetatable({_ref = label}, LabelProxy) end

-- 3. Dummy Theme (Khusus buat X-Ray manual di Status.lua)
local Theme = {
    CardBG = Color3.fromRGB(30, 30, 30),
    SideBG = Color3.fromRGB(40, 40, 40),
    Line   = Color3.fromRGB(60, 60, 60),
    Text   = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 150),
    CatPurple = Color3.fromRGB(170, 85, 255)
}

-- 4. KABEL SAMBUNGAN (Menerjemahkan perintah lama ke mesin baru Linoria)
_G.Cat.UI = {
    Theme = Theme,
    SaveSettings = SaveSettings,
    
    CreateTab = function(name, isFirst)
        return Window:AddTab(name)
    end,
    
    CreateSection = function(parent, text)
        return parent:AddSection(text)
    end,
    
    CreateToggle = function(parent, text, desc, stateRef, callback)
        return parent:AddToggle(text, {
            Default = stateRef or false,
            Tooltip = desc or ""
        }, function(state)
            if callback then callback(state) end
            SaveSettings()
        end)
    end,
    
    CreateLabel = function(parent, text, desc)
        -- Linoria mengembalikan objek unik, jadi kita bungkus dengan Proxy
        local label = parent:AddLabel(text or "")
        return CreateProxy(label) 
    end
}

warn("[CatHUB] Modern Linoria UI Integrated.")