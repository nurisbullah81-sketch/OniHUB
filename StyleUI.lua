-- [[ ==========================================
--      ONIHUB: STYLE UI (MACLIB FRAMEWORK)
--      100% HAK MILIK SENDIRI - ANTI NEBENG
--    ========================================== ]]

-- Path udah gue samain persis sama gaya loadstring lu!
local MyRepo = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/"

-- Bikin Safe Loader biar ketauan errornya kalo gagal narik
local success, response = pcall(function()
    return game:HttpGet(MyRepo .. "Maclib.lua")
end)

if not success or string.find(response, "404: Not Found") then
    warn("[ONIHUB ERROR]: DAPET 404! Pastiin Maclib.lua beneran udah di-Push ke GitHub lu bang!")
    return
end

-- Jalanin Mesin Maclib
local Maclib = loadstring(response)()

-- BIKIN WINDOW UTAMA
local Window = Maclib:Window({
    Title = "ONIHUB",
    Subtitle = "Freemium Edition",
    Size = UDim2.fromOffset(600, 400),
    DragStyle = 1, 
    DisabledWindowControls = {},
    ShowUserInfo = true, 
    Keybind = Enum.KeyCode.RightControl, 
    AcrylicBlur = true, 
})

-- 3. BIKIN GRUP TAB & MENU SAMPING (Pake Icon biar Aesthetic!)
local MainGroup = Window:TabGroup()

-- Pake icon bawaan Maclib biar cakep
local TabStatus   = MainGroup:Tab({ Name = "Status", Image = "rbxassetid://18821914323" })
local TabAutoFarm = MainGroup:Tab({ Name = "Auto Farm", Image = "rbxassetid://108952102602834" }) 
local TabFruits   = MainGroup:Tab({ Name = "Devil Fruits", Image = "rbxassetid://18865373378" })
local TabMisc     = MainGroup:Tab({ Name = "Misc", Image = "rbxassetid://10734950309" })

-- =============================================
-- STEP 3: BIKIN KOTAK (SECTION) & ISI MENU
-- =============================================

-- A. Isi Tab Status
local StatusLeft = TabStatus:Section({ Side = "Left" })
StatusLeft:Header({ Text = "Informasi Player" })

local LabelLevel = StatusLeft:Label({ Text = "Level: Menunggu Data..." })
local LabelBeli  = StatusLeft:Label({ Text = "Beli: Menunggu Data..." })

-- B. Isi Tab Auto Farm
local FarmLeft = TabAutoFarm:Section({ Side = "Left" })
FarmLeft:Header({ Text = "Main Auto Farm" })

local ToggleFarm = FarmLeft:Toggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(State)
        print("Auto Farm nyala?: ", State)
        -- Nanti logic script auto farm lu nyambung ke sini
    end
})

FarmLeft:Slider({
    Name = "Jarak Pukul",
    Default = 10,
    Minimum = 5,
    Maximum = 20,
    DisplayMethod = "Value", 
    Callback = function(Value)
        print("Jarak diubah jadi: ", Value)
    end
})

-- 4. DAFTARIN UI KE GLOBAL ENVIRONMENT (_G)
_G.Oni = _G.Oni or {}
_G.Oni.UI = {
    Library = Maclib,
    Window  = Window,
    Tabs    = {
        Status   = TabStatus,
        AutoFarm = TabAutoFarm,
        DevilFruits = TabFruits,
        Misc     = TabMisc
    },
    -- Daftarin Label & Toggle biar bisa di-update dari Status.lua
    Labels = {
        Level = LabelLevel,
        Beli  = LabelBeli
    },
    Toggles = {
        AutoFarm = ToggleFarm
    }
}

-- Pilih Tab Status otomatis pas pertama buka
TabStatus:Select()