-- [[ ==========================================
--      MODULE: AUTO FARM - COMBAT SYSTEM (OPTIMIZED)
--      Status: 0% Lag, Anti-Crash UI, Smart Click
--    ========================================== ]]

-- // Services
local VIM     = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

-- // Variables
local Me = Players.LocalPlayer

-- // Wait for Core System Initialization
repeat 
    task.wait(0.1) 
until _G.Cat and _G.Cat.UI and _G.Cat.Settings

-- FIX UI GAIB 1: Bikin fallback kalau State belum ada di Core.lua
if not _G.Cat.State then _G.Cat.State = { IsGameReady = true } end

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State

-- FIX UI GAIB 2: Pastiin settingan boolean aman kaga kosong
if type(Settings.AutoAttack) ~= "boolean" then Settings.AutoAttack = false end

-- ==========================================
-- 1. UI INITIALIZATION (AUTO FARM TAB)
-- ==========================================
local Page = UI.CreateTab("Auto Farm", false)

UI.CreateSection(Page, "COMBAT SYSTEM")

UI.CreateToggle(
    Page, 
    "Auto Attack", 
    "Automatically swing weapon / fight (0% LAG)", 
    Settings.AutoAttack, 
    function(state) 
        Settings.AutoAttack = state 
        -- FIX UI GAIB 3: Cuma jalanin SaveSettings KALAU fungsinya udah ada!
        if UI.SaveSettings then 
            pcall(function() UI.SaveSettings() end) 
        end
    end
)

-- ==========================================
-- 2. LOGIC: AUTO ATTACK ENGINE (FPS BOOSTER APPROVED)
-- ==========================================

task.spawn(function()
    while task.wait(0.15) do -- Mundurin dikit ke 0.15s biar CPU bisa napas
        if Settings.AutoAttack and State.IsGameReady then
            local char = Me.Character
            local hum  = char and char:FindFirstChild("Humanoid")
            
            if hum and hum.Health > 0 then
                -- FIX LAG MUTLAK: Script cuma bakal nge-klik KALAU lu lagi megang senjata!
                -- Kalau tangan kosong, script istirahat, jadi kaga ada lag!
                local weapon = char:FindFirstChildOfClass("Tool")
                
                if weapon then
                    -- Klik dipisah dari loop pcall biar kaga numpuk sampah memori
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.05) -- Kasih jeda mencet mouse biar kaga ke-detect spam
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end
        end
    end
end)