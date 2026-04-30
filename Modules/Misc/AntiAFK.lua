-- [[ ==========================================
--      MODULE: MISC - ANTI-AFK & AUTO-TEAM
--    ========================================== ]]

-- // Services
local VirtualUser       = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

-- // Variables
local Me = Players.LocalPlayer

-- // Wait for Core System Initialization
repeat 
    task.wait(0.1) 
until _G.Cat 
    and _G.Cat.UI 
    and _G.Cat.Settings

-- // Reference Global Components
local UI         = _G.Cat.UI
local Settings   = _G.Cat.Settings
local SafeInvoke = _G.Cat.SafeInvoke

-- ==========================================
-- 1. UI INITIALIZATION (MISC TAB)
-- ==========================================
local Page = UI.CreateTab("Misc", false)

-- // Toggle: Anti-AFK System
UI.CreateToggle(
    Page, 
    "Anti AFK", 
    "Prevents 20-minute idle kick", 
    Settings.AntiAFK, 
    function(state) 
        Settings.AntiAFK = state 
    end
)

-- // Toggle: Auto Team (Marines Selection)
UI.CreateToggle(
    Page, 
    "Auto Team Marines", 
    "Automatically picks Marines on join", 
    Settings.AutoTeam or false, 
    function(state) 
        Settings.AutoTeam = state 
    end
)

-- ==========================================
-- 2. LOGIC: ANTI-IDLE SYSTEM
-- ==========================================

-- // Event: Prevents the 20-minute AFK kick
Me.Idled:Connect(function()
    if Settings.AntiAFK then
        pcall(function()
            -- Bypasses idle detection via virtual input simulation
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- [[ ==========================================
--      3. LOGIC: AUTO TEAM SELECTION
--    ========================================== ]]

-- // Helper: Scan UI for the Marine Recruitment Button
local function GetMarineButton()
    local playerGui = Me.PlayerGui
    
    for _, ui in ipairs(playerGui:GetDescendants()) do
        -- Search for the Team Choice container
        if ui.Name == "ChooseTeam" and ui.Visible then
            local marineFrame = ui:FindFirstChild("Marines", true)
            
            if marineFrame then
                local btn = marineFrame:FindFirstChildWhichIsA("TextButton", true)
                
                -- Validate button dimensions to ensure it's clickable
                if btn then
                    local isVisible = btn.AbsoluteSize.X > 0 
                        and btn.AbsoluteSize.Y > 0
                    
                    if isVisible then 
                        return btn 
                    end
                end
            end
        end
    end
    return nil
end

-- // Background Task: Auto Team Monitor
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- Activation Condition: Toggle is ON and Player has no team
            local shouldJoin = Settings.AutoTeam and Me.Team == nil
            
            if shouldJoin then
                local btn = GetMarineButton()
                
                if btn then
                    -- // STEP 1: Remote Invocation (Silent Join)
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local commF   = remotes and remotes:FindFirstChild("CommF_")
                    
                    if commF then 
                        SafeInvoke(commF, "SetTeam", "Marines") 
                    end
                    
                    task.wait(0.5)
                    
                    -- // STEP 2: Fallback (Force UI Activation)
                    -- Used if Remote method is patched or fails
                    pcall(function() btn.MouseButton1Click:Fire() end)
                    pcall(function() btn.Activated:Fire() end)
                    
                    task.wait(1)
                    
                    -- // STEP 3: Post-Join Environment Fix
                    if Me.Team ~= nil then
                        -- Hide UI if it gets stuck
                        local rootUI = btn:FindFirstAncestor("ChooseTeam")
                        if rootUI then 
                            rootUI.Visible = false 
                        end
                        
                        -- Restore Camera Control
                        local camera = workspace.CurrentCamera
                        camera.CameraType = Enum.CameraType.Custom
                        
                        -- Re-focus Camera on Character
                        local char = Me.Character
                        local hum  = char and char:FindFirstChild("Humanoid")
                        
                        if hum then 
                            camera.CameraSubject = hum 
                        end
                    end
                end
            end
        end)
    end
end)