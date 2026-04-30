-- ==========================================
-- CORE INITIALIZATION
-- ==========================================

-- 1. Wait for Game to Load
if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

-- 2. Services Initialization
local GuiService  = game:GetService("GuiService")
local CoreGui     = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local Players     = game:GetService("Players")

-- 3. Wait for LocalPlayer
while not Players.LocalPlayer do 
    task.wait(0.1) 
end
local Me = Players.LocalPlayer

-- 4. Wait for Global CatHUB Data (Safety Check)
while not _G or not _G.Cat or not _G.Cat.Settings do 
    task.wait(0.1) 
end

-- Localize Settings for faster access
local Settings = _G.Cat.Settings

-- ==========================================
-- 1. MASTER LOCK & STATE GLOBAL
-- ==========================================
_G.Cat.State = { IsGameReady = false, StopSmartTween = function() end }

local IsGameReady = false
local function UpdateGameState()
    local isReady = (Me.Team ~= nil and Me.Character and Me.Character:FindFirstChild("HumanoidRootPart"))
    if isReady ~= IsGameReady then
        IsGameReady = isReady; _G.Cat.State.IsGameReady = isReady
        if not IsGameReady then _G.Cat.State.StopSmartTween() end
    end
end

task.spawn(UpdateGameState)
Me:GetPropertyChangedSignal("Team"):Connect(UpdateGameState)
Me.CharacterAdded:Connect(function(char)
    IsGameReady = false
    task.spawn(function() char:WaitForChild("HumanoidRootPart", 15) UpdateGameState() end)
end)
Me.CharacterRemoving:Connect(function() IsGameReady = false; UpdateGameState() end)

-- ==========================================
-- 2. THE GUARDIAN V26
-- ==========================================
GuiService.ErrorMessageChanged:Connect(function()
    pcall(function() GuiService:ClearError() end)
end)

task.spawn(function()
    local promptGui = CoreGui:WaitForChild("RobloxPromptGui", 5)
    if promptGui then
        local overlay = promptGui:WaitForChild("promptOverlay", 5)
        if overlay then
            overlay:GetPropertyChangedSignal("Visible"):Connect(function()
                if overlay.Visible then overlay.Visible = false end
            end)
        end
    end
end)

Me.Idled:Connect(function()
    if Settings.TweenFruit or Settings.AutoHop or Settings.InstantTPFruit then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ==========================================
-- 3. SAFE INVOKE & RELEASE CHARACTER
-- ==========================================
function _G.Cat.SafeInvoke(remote, ...)
    local args = {...}
    local thread = coroutine.running()
    local completed = false
    task.spawn(function()
        local ok, res = pcall(function() return remote:InvokeServer(unpack(args)) end)
        if not completed then completed = true; task.spawn(thread, ok, res) end
    end)
    task.delay(3, function()
        if not completed then completed = true; task.spawn(thread, false, nil) end
    end)
    local ok, res = coroutine.yield()
    return ok, res
end

function _G.Cat.ReleaseCharacter()
    pcall(function()
        if Me.Character then
            local hrp = Me.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Anchored then hrp.Anchored = false end
        end
    end)
end