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
-- 2. GAME READINESS MONITOR (THE THUNDERZ FIX)
-- ==========================================
local function UpdateGameState()
    local isReady = false
    
    pcall(function()
        local char = Me.Character
        local hum  = char and char:FindFirstChild("Humanoid")
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        
        -- Validasi: Team, Char, HRP, dan Hidup
        local baseReady = (
            Me.Team ~= nil and char ~= nil and 
            hrp ~= nil and hum ~= nil and hum.Health > 0
        )
        
        if baseReady then
            -- 🚨 SENSOR THUNDERZ: CEK UI CHOOSE TEAM
            local gui = Me:FindFirstChild("PlayerGui")
            local mainGui = gui and gui:FindFirstChild("Main")
            local chooseTeam = mainGui and mainGui:FindFirstChild("ChooseTeam")

            -- Kalo UI ChooseTeam masih ada, tahan mesinnya!
            if chooseTeam and chooseTeam.Visible then
                isReady = false
            else
                isReady = true
            end
        end
    end)
    
    -- Update state kalo berubah
    if isReady ~= IsGameReady then
        IsGameReady = isReady
        _G.Cat.State.IsGameReady = isReady
        
        -- Stop tween kalo mati/loading/masih di menu team
        if not IsGameReady then 
            if _G.Cat.State.StopSmartTween then
                _G.Cat.State.StopSmartTween() 
            end
        end
    end
end

-- ==========================================
-- 3. EVENT CONNECTIONS
-- ==========================================
-- Trigger Awal (Posisinya WAJIB di sini, di bawah fungsi)
task.spawn(UpdateGameState)

-- Monitor Team
Me:GetPropertyChangedSignal("Team"):Connect(UpdateGameState)

-- Monitor Respawn
Me.CharacterAdded:Connect(function(char)
    IsGameReady = false
    _G.Cat.State.IsGameReady = false
    
    local human = char:WaitForChild("Humanoid", 15)
    if human then
        human.Died:Connect(UpdateGameState)
    end
    
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
function _G.Cat.WaitUntilReady()
    while not _G.Cat.State.IsGameReady do 
        task.wait(0.5) 
    end
end

-- [[ ==========================================
--      2. THE GUARDIAN V26
--    ========================================== ]]
GuiService.ErrorMessageChanged:Connect(function()
    pcall(function() GuiService:ClearError() end)
end)

task.spawn(function()
    local promptGui = CoreGui:WaitForChild("RobloxPromptGui", 5)
    if not promptGui then return end

    local overlay = promptGui:WaitForChild("promptOverlay", 5)
    if not overlay then return end

    overlay:GetPropertyChangedSignal("Visible"):Connect(function()
        if overlay.Visible then
            overlay.Visible = false
        end
    end)
end)

Me.Idled:Connect(function()
    local isAutomating = Settings.TweenFruit or Settings.AutoHop or Settings.InstantTPFruit
    if _G.Cat.State.IsGameReady and isAutomating then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- ==========================================
-- 3. UTILITIES
-- ==========================================
function _G.Cat.SafeInvoke(remote, ...)
    local args      = {...}
    local thread    = coroutine.running()
    local completed = false

    task.spawn(function()
        local ok, res = pcall(function()
            return remote:InvokeServer(unpack(args))
        end)

        if not completed then
            completed = true
            task.spawn(thread, ok, res)
        end
    end)

    task.delay(3, function()
        if not completed then
            completed = true
            task.spawn(thread, false, nil)
        end
    end)

    return coroutine.yield()
end

function _G.Cat.ReleaseCharacter()
    pcall(function()
        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")

        if hrp and hrp.Anchored then
            hrp.Anchored = false
        end
    end)
end