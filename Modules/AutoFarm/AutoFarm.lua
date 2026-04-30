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
-- 2. LOGIC: AUTO ATTACK ENGINE (DIRECT METHOD)
-- ==========================================

task.spawn(function()
    while task.wait(0.1) do -- Speed serangan dikit dinaikin, 0.1 udah cukup cepat
        -- Cek State yang ASLI, jangan pake fallback palsu
        local isReady = _G.Cat.State and _G.Cat.State.IsGameReady
        
        if Settings.AutoAttack and isReady then
            local char = Me.Character
            -- Cek Humanoid sekali aja biar efisien
            if not (char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0) then 
                continue 
            end

            -- Logic Cari Senjata
            local weapon = char:FindFirstChildOfClass("Tool")
            
            if weapon then
                -- GUE PAKAI :Activate() BIAR LEBIH CLEAN DARI VIM
                -- Ini nggak bakal ganggu input mouse lu pas PVP
                pcall(function()
                    weapon:Activate()
                end)
            end
        end
    end
end)