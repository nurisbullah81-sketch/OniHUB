-- Core.lua
if not game:IsLoaded() then game.Loaded:Wait() end

local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")

while not Players.LocalPlayer do task.wait(0.1) end
local Me = Players.LocalPlayer
while not _G or not _G.Cat or not _G.Cat.Settings do task.wait(0.1) end
local Settings = _G.Cat.Settings

-- ==========================================
-- 1. MASTER LOCK & STATE GLOBAL
-- ==========================================
_G.Cat.State = { IsGameReady = false, StopSmartTween = function() end }

local IsGameReady = false
local function UpdateGameState()
    -- SYARAT KETAT: Harus ada Team, Karakter, HRP, dan HIDUP!
    local isReady = false
    pcall(function()
        isReady = (Me.Team ~= nil and Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") and Me.Character:FindFirstChild("Humanoid") and Me.Character.Humanoid.Health > 0)
    end)
    
    if isReady ~= IsGameReady then
        IsGameReady = isReady; _G.Cat.State.IsGameReady = isReady
        if not IsGameReady then _G.Cat.State.StopSmartTween() end
    end
end

task.spawn(UpdateGameState)
Me:GetPropertyChangedSignal("Team"):Connect(UpdateGameState)
Me.CharacterAdded:Connect(function(char)
    IsGameReady = false; _G.Cat.State.IsGameReady = false
    local human = char:WaitForChild("Humanoid", 15)
    if human then
        human.HealthChanged:Connect(function() UpdateGameState() end)
    end
    task.spawn(function() char:WaitForChild("HumanoidRootPart", 15) UpdateGameState() end)
end)
Me.CharacterRemoving:Connect(function() IsGameReady = false; _G.Cat.State.IsGameReady = false end)

-- FUNGSI TIDUR NYENYAK: Module lain pake ini biar kagak makan FPS pas loading
function _G.Cat.WaitUntilReady()
    while not _G.Cat.State.IsGameReady do task.wait(0.5) end
end

-- ==========================================
-- 2. THE GUARDIAN V26
-- ==========================================
GuiService.ErrorMessageChanged:Connect(function() pcall(function() GuiService:ClearError() end) end)
task.spawn(function()
    local promptGui = CoreGui:WaitForChild("RobloxPromptGui", 5)
    if promptGui then local overlay = promptGui:WaitForChild("promptOverlay", 5)
        if overlay then overlay:GetPropertyChangedSignal("Visible"):Connect(function() if overlay.Visible then overlay.Visible = false end end) end
    end
end)

-- ANTI AFK CUMA JALAN KALO SUDAH READY
Me.Idled:Connect(function()
    if _G.Cat.State.IsGameReady and (Settings.TweenFruit or Settings.AutoHop or Settings.InstantTPFruit) then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ==========================================
-- 3. SAFE INVOKE & RELEASE
-- ==========================================
function _G.Cat.SafeInvoke(remote, ...)
    local args = {...}; local thread = coroutine.running(); local completed = false
    task.spawn(function() local ok, res = pcall(function() return remote:InvokeServer(unpack(args)) end) if not completed then completed = true; task.spawn(thread, ok, res) end end)
    task.delay(3, function() if not completed then completed = true; task.spawn(thread, false, nil) end end)
    return coroutine.yield()
end

function _G.Cat.ReleaseCharacter()
    pcall(function()
        if Me.Character then
            local hrp = Me.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Anchored then hrp.Anchored = false end
        end
    end)
end