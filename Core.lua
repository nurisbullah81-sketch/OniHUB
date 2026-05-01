-- [[ ==========================================
--      MODULE: CORE SYSTEM - STATE HANDLER
--    ========================================== ]]

-- // Game Loading
if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

-- // Services
local GuiService  = game:GetService("GuiService")
local CoreGui     = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local Players     = game:GetService("Players")

-- // Wait LocalPlayer
repeat task.wait(0.1) until Players.LocalPlayer
local Me = Players.LocalPlayer

-- // Wait Global Framework
repeat task.wait(0.1) until _G.Cat and _G.Cat.Settings
local Settings = _G.Cat.Settings

-- ==========================================
-- 1. GLOBAL STATE INITIALIZATION
-- ==========================================
_G.Cat.State = { 
    IsGameReady    = false, 
    StopSmartTween = function() end 
}

local IsGameReady = false

-- ==========================================
-- 2. GAME READINESS MONITOR
-- ==========================================

-- // Cek status karakter (Ready/Death)
local function UpdateGameState()
    local isReady = false
    
    pcall(function()
        local char = Me.Character
        local hum  = char and char:FindFirstChild("Humanoid")
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        
        -- Validasi: Team, Char, HRP, dan Hidup
        isReady = (
            Me.Team ~= nil and char ~= nil and 
            hrp ~= nil and hum ~= nil and hum.Health > 0
        )
    end)
    
    -- Update state kalo berubah
    if isReady ~= IsGameReady then
        IsGameReady = isReady
        _G.Cat.State.IsGameReady = isReady
        
        -- Stop tween kalo mati/loading
        if not IsGameReady then 
            _G.Cat.State.StopSmartTween() 
        end
    end
end

-- ==========================================
-- 3. EVENT CONNECTIONS
-- ==========================================

-- Trigger Awal
task.spawn(UpdateGameState)

-- Monitor Team
Me:GetPropertyChangedSignal("Team"):Connect(UpdateGameState)

-- Monitor Respawn
Me.CharacterAdded:Connect(function(char)
    -- Reset state
    IsGameReady = false
    _G.Cat.State.IsGameReady = false
    
    local human = char:WaitForChild("Humanoid", 15)
    if human then
        -- Update pas mati (efisien)
        human.Died:Connect(UpdateGameState)
    end
    
    -- Wait Physics
    task.spawn(function()
        char:WaitForChild("HumanoidRootPart", 15)
        UpdateGameState()
    end)
end)

-- Monitor Removal
Me.CharacterRemoving:Connect(function()
    IsGameReady = false
    _G.Cat.State.IsGameReady = false 
end)

-- ==========================================
-- 4. PUBLIC API FUNCTIONS
-- ==========================================

-- Tunggu sampai game siap
function _G.Cat.WaitUntilReady()
    while not _G.Cat.State.IsGameReady do 
        task.wait(0.5) 
    end
end

-- [[ ==========================================
--      2. THE GUARDIAN V26
--    ========================================== ]]

-- Auto clear error biar ga nge-block screen
GuiService.ErrorMessageChanged:Connect(function()
    pcall(function()
        GuiService:ClearError()
    end)
end)

-- Proteksi UI (Tutup prompt paksa)
task.spawn(function()
    local promptGui = CoreGui:WaitForChild("RobloxPromptGui", 5)
    if not promptGui then return end

    local overlay = promptGui:WaitForChild("promptOverlay", 5)
    if not overlay then return end

    -- Trigger pas visible
    overlay:GetPropertyChangedSignal("Visible"):Connect(function()
        if overlay.Visible then
            overlay.Visible = false
        end
    end)
end)

-- Anti AFK (Cuma jalan kalo lagi bot)
Me.Idled:Connect(function()
    -- Cek fitur auto yang nyala
    local isAutomating = Settings.TweenFruit 
        or Settings.AutoHop 
        or Settings.InstantTPFruit

    -- Pecah kondisi biar ga panjang
    if _G.Cat.State.IsGameReady 
       and isAutomating 
    then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- ==========================================
-- 3. UTILITIES
-- ==========================================

-- Invoke remote pake timeout (biar ga nge-freeze)
function _G.Cat.SafeInvoke(remote, ...)
    local args      = {...}
    local thread    = coroutine.running()
    local completed = false

    -- Thread utama eksekusi
    task.spawn(function()
        -- Pecah InvokeServer biar rapi
        local ok, res = pcall(function()
            return remote:InvokeServer(unpack(args))
        end)

        if not completed then
            completed = true
            task.spawn(thread, ok, res)
        end
    end)

    -- Thread timeout (3 detik)
    task.delay(3, function()
        if not completed then
            completed = true
            task.spawn(thread, false, nil)
        end
    end)

    return coroutine.yield()
end

-- Lepas anchor karakter
function _G.Cat.ReleaseCharacter()
    pcall(function()
        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")

        if hrp and hrp.Anchored then
            hrp.Anchored = false
        end
    end)
end