-- [[ ==========================================
--      MODULE: GAME SETTINGS - NATIVE SYNC
--      Status: Auto-Scan, Zero Lag, 100% Native
--    ========================================== ]]

local Players = game:GetService("Players")
local Me = Players.LocalPlayer

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings

-- // 1. UI REGISTRATION (Masuk ke Tab Misc Biar Rapi)
local Page = UI.CreateTab("Misc", false)
UI.CreateSection(Page, "NATIVE GAME SETTINGS")

-- // 2. SMART AUTO-SCANNER ENGINE
-- Fungsi buat nyari tombol "Off" bawaan game tanpa bikin lag
local function SetNativeSetting(settingName, state)
    pcall(function()
        local menu = Me.PlayerGui:FindFirstChild("SettingsMenu", true)
        local content = menu and menu:FindFirstChild("ScrollingFrame", true)
        
        if content then
            local targetFrame = content:FindFirstChild(settingName)
            if targetFrame then
                -- Cari tombol "Off" atau "On" di dalem frame bawaan game
                local btnName = state and "On" or "Off"
                local btn = targetFrame:FindFirstChild(btnName) or targetFrame:FindFirstChildWhichIsA("GuiButton", true)
                
                if btn then
                    -- Simulasi klik tanpa suara (Silent Click)
                    for _, connection in pairs(getconnections(btn.MouseButton1Click)) do
                        connection:Fire()
                    end
                    for _, connection in pairs(getconnections(btn.Activated)) do
                        connection:Fire()
                    end
                end
            end
        end
    end)
end

-- // 3. TOGGLES (CatHUB UI)
-- Mute Background Music
if type(Settings.MuteMusic) ~= "boolean" then Settings.MuteMusic = false end
UI.CreateToggle(Page, "Mute Native Music", "Sync with game's background music setting", Settings.MuteMusic, function(state)
    Settings.MuteMusic = state
    -- Jika toggle "Mute" ON, maka kita set settingan game ke "Off"
    SetNativeSetting("BackgroundMusic", not state)
end)

-- Disable Camera Shake
if type(Settings.NoShake) ~= "boolean" then Settings.NoShake = false end
UI.CreateToggle(Page, "Disable Native Shake", "Sync with game's camera shake setting", Settings.NoShake, function(state)
    Settings.NoShake = state
    -- Jika toggle "No Shake" ON, maka kita set settingan game ke "Off"
    SetNativeSetting("CameraShake", not state)
end)

-- Fast Mode (Bonus buat ngurangin lag lebih dalam)
if type(Settings.FastMode) ~= "boolean" then Settings.FastMode = false end
UI.CreateToggle(Page, "Native Fast Mode", "Sync with game's internal fast mode", Settings.FastMode, function(state)
    Settings.FastMode = state
    SetNativeSetting("FastMode", state)
end)

-- // 4. INITIAL SYNC (Pas baru execute langsung nyamain)
task.spawn(function()
    task.wait(2) -- Tunggu UI game bener-bener ke-render
    if Settings.MuteMusic then SetNativeSetting("BackgroundMusic", false) end
    if Settings.NoShake then SetNativeSetting("CameraShake", false) end
    if Settings.FastMode then SetNativeSetting("FastMode", true) end
end)