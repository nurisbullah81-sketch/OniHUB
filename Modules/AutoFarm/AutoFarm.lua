-- Modules/AutoFarm/AutoFarm.lua
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local Me = Players.LocalPlayer
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings or not _G.Cat.State do task.wait(0.1) end
local UI = _G.Cat.UI
local Settings = _G.Cat.Settings
local State = _G.Cat.State

-- 1. PASANG UI (Minta Kamar Auto Farm)
local Page = UI.CreateTab("Auto Farm", false)

UI.CreateSection(Page, "COMBAT SYSTEM")
UI.CreateToggle(Page, "Auto Attack", "Automatically swing weapon / fight", Settings.AutoAttack, function(s) Settings.AutoAttack = s UI.SaveSettings() end)

-- 2. LOGIC AUTO ATTACK
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoAttack and State.IsGameReady then
            pcall(function()
                local character = Me.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
        end
    end
end)