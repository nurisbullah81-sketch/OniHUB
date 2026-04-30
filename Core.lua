-- [[ ==========================================
--      MODULE: CORE SYSTEM - STATE HANDLER
--    ========================================== ]]

-- // Initialize Game Loading State
if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

-- // Services
local GuiService    = game:GetService("GuiService")
local CoreGui       = game:GetService("CoreGui")
local VirtualUser   = game:GetService("VirtualUser")
local Players       = game:GetService("Players")

-- // Initial Wait for LocalPlayer
repeat 
    task.wait(0.1) 
until Players.LocalPlayer

local Me = Players.LocalPlayer

-- // Wait for Global CatHub Framework
repeat 
    task.wait(0.1) 
until _G.Cat 
    and _G.Cat.Settings

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
-- 2. LOGIC: GAME READINESS MONITOR
-- ==========================================

-- // Function: Update the readiness state of the script
local function UpdateGameState()
    local isReady = false
    
    pcall(function()
        -- STRICT VALIDATION: Team selected, Character exists, HRP present, and Alive
        local char = Me.Character
        local hum  = char and char:FindFirstChild("Humanoid")
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        
        isReady = (
            Me.Team ~= nil 
            and char ~= nil 
            and hrp ~= nil 
            and hum ~= nil 
            and hum.Health > 0
        )
    end)
    
    -- Update Global State only on change
    if isReady ~= IsGameReady then
        IsGameReady = isReady
        _G.Cat.State.IsGameReady = isReady
        
        -- Safety: Kill active tweens if game is no longer ready
        if not IsGameReady then 
            _G.Cat.State.StopSmartTween() 
        end
    end
end

-- ==========================================
-- 3. EVENT CONNECTIONS
-- ==========================================

-- Trigger initial check
task.spawn(UpdateGameState)

-- Monitor Team Changes
Me:GetPropertyChangedSignal("Team"):Connect(UpdateGameState)

-- Monitor Character Respawn
Me.CharacterAdded:Connect(function(char)
    -- Reset state immediately upon death/respawn
    IsGameReady = false
    _G.Cat.State.IsGameReady = false
    
    -- Wait for Humanoid components
    local human = char:WaitForChild("Humanoid", 15)
    if human then
        human.HealthChanged:Connect(function() 
            UpdateGameState() 
        end)
    end
    
    -- Wait for physics components
    task.spawn(function() 
        char:WaitForChild("HumanoidRootPart", 15) 
        UpdateGameState() 
    end)
end)

-- Handle Character Removal
Me.CharacterRemoving:Connect(function() 
    IsGameReady = false
    _G.Cat.State.IsGameReady = false 
end)

-- ==========================================
-- 4. PUBLIC API FUNCTIONS
-- ==========================================

-- // Method: Yields the script until the game is fully ready for automation
function _G.Cat.WaitUntilReady()
    while not _G.Cat.State.IsGameReady do 
        task.wait(0.5) 
    end
end

-- [[ ==========================================
--      2. THE GUARDIAN V26 (PROMPT PROTECTION)
--    ========================================== ]]

-- // Automatic Error Clearing
GuiService.ErrorMessageChanged:Connect(function() 
    pcall(function() 
        GuiService:ClearError() 
    end) 
end)

-- // Background Task: UI Prompt Protection
task.spawn(function()
    local promptGui = CoreGui:WaitForChild("RobloxPromptGui", 5)
    if not promptGui then return end

    local overlay = promptGui:WaitForChild("promptOverlay", 5)
    if not overlay then return end

    -- Force visibility to false whenever a prompt appears
    overlay:GetPropertyChangedSignal("Visible"):Connect(function() 
        if overlay.Visible then 
            overlay.Visible = false 
        end 
    end)
end)

-- // Logic: Integrated Anti-AFK (State Dependent)
Me.Idled:Connect(function()
    -- Only active if script is operational and performing automation
    local isAutomating = Settings.TweenFruit 
        or Settings.AutoHop 
        or Settings.InstantTPFruit

    if _G.Cat.State.IsGameReady and isAutomating then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- ==========================================
-- 3. UTILITIES: SAFE INVOKE & RELEASE
-- ==========================================

-- // Function: Safe Remote Invocation with Timeout
function _G.Cat.SafeInvoke(remote, ...)
    local args      = {...}
    local thread    = coroutine.running()
    local completed = false
    
    -- // Execution Thread
    task.spawn(function() 
        local ok, res = pcall(function() 
            return remote:InvokeServer(unpack(args)) 
        end) 
        
        if not completed then 
            completed = true
            task.spawn(thread, ok, res) 
        end 
    end)
    
    -- // Timeout Thread (3 Second Limit)
    task.delay(3, function() 
        if not completed then 
            completed = true
            task.spawn(thread, false, nil) 
        end 
    end)
    
    return coroutine.yield()
end

-- // Function: Release Character Physics (Unanchor)
function _G.Cat.ReleaseCharacter()
    pcall(function()
        local char = Me.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp and hrp.Anchored then 
            hrp.Anchored = false 
        end
    end)
end