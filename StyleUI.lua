-- [[ CATHUB PREMIUM: KAVO UI INTEGRATION ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

_G.Cat = _G.Cat or {}
_G.Cat.Player = Players.LocalPlayer
_G.Cat.Labels = _G.Cat.Labels or {}
if not _G.Cat.Settings then _G.Cat.Settings = {} end

local function SaveSettings()
    pcall(function()
        writefile("CatHUB_Config.json", HttpService:JSONEncode(_G.Cat.Settings))
    end)
end
_G.Cat.SaveSettings = SaveSettings

-- Theme dummy (Wajib ada buat X-Ray manual di Status.lua)
local Theme = {
    CardBG = Color3.fromRGB(30, 30, 30), SideBG = Color3.fromRGB(40, 40, 40), Line = Color3.fromRGB(60, 60, 60),
    Text = Color3.fromRGB(240, 240, 240), TextDim = Color3.fromRGB(150, 150, 150), CatPurple = Color3.fromRGB(170, 85, 255)
}

-- 1. Load Engine Kavo UI langsung dari web (Aman dari Cloudflare)
local Kavo = loadstring(game:HttpGet("https://github.com/xHeptc/Kavo-UI-Library/blob/main/source.lua"))()

-- 2. Bikin Window Kavo (Ubah HeaderColor kalau mau ganti warna tema)
local Window = Kavo.CreateWindow({
    Title = "CatHUB | Blox Fruits",
    HeaderColor = Color3.fromRGB(100, 149, 237), -- Biru Premium
    Color = Color3.fromRGB(25, 25, 25),
    HideKey = Enum.KeyCode.RightControl
})

-- 3. Proxy System Cerdas (Menipu Status.lua supaya .Text = "..." tetap jalan)
local LabelProxy = {}
LabelProxy.__index = function(self, key)
    if key == "Text" then return self._ref.Text end
end
LabelProxy.__newindex = function(self, key, value)
    if key == "Text" then self._ref:Set(tostring(value)) end
end
local function CreateProxy(label) return setmetatable({_ref = label}, LabelProxy) end

-- 4. KABEL SAMBUNGAN (Menerjemahkan bahasa CatHUB ke Kavo)
_G.Cat.UI = {
    Theme = Theme,
    SaveSettings = SaveSettings,
    
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
        if stateRef then toggle:Set(stateRef) end
        return toggle
    end,
    
    CreateLabel = function(parent, text, desc)
        local label = parent:createLabel(text or "")
        return CreateProxy(label)
    end
}

warn("[CatHUB] Premium Kavo UI Successfully Loaded.")