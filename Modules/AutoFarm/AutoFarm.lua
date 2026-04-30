-- [[ ==========================================
--      MODULE: AUTO FARM - COMBAT SYSTEM
--    ========================================== ]]

-- // Services
local VIM     = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

-- // Variables
local Me = Players.LocalPlayer

-- // Wait for Core System Initialization
repeat 
    task.wait(0.1) 
until _G.Cat 
    and _G.Cat.UI 
    and _G.Cat.Settings 
    and _G.Cat.State

-- // Reference Global Components
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State

-- ==========================================
-- 1. UI INITIALIZATION (AUTO FARM TAB)
-- ==========================================
local Page = UI.CreateTab("Auto Farm", false)

-- // Section: Basic Combat
UI.CreateSection(Page, "COMBAT SYSTEM")

-- // Toggle: Universal Auto Attack
UI.CreateToggle(
    Page, 
    "Auto Attack", 
    "Automatically swing weapon / fight", 
    Settings.AutoAttack, 
    function(state) 
        Settings.AutoAttack = state 
        UI.SaveSettings() 
    end
)

-- ==========================================
-- 2. LOGIC: AUTO ATTACK ENGINE
-- ==========================================

task.spawn(function()
    while task.wait(0.1) do
        -- Only execute if toggle is ON and game state is READY
        local canAttack = Settings.AutoAttack 
            and State.IsGameReady
        
        if canAttack then
            pcall(function()
                local char = Me.Character
                local hum  = char and char:FindFirstChild("Humanoid")
                
                -- Ensure character is valid and alive before clicking
                if hum and hum.Health > 0 then
                    -- Simulate Left Mouse Button Click (Down & Up)
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
        end
    end
end)