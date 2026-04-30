-- [[ ==========================================
--      MODULE: AUTO TEAM MARINES
--    ========================================== ]]

-- // Services
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
-- 1. UI INITIALIZATION
-- ==========================================
local Page = UI.CreateTab("Misc", false)

-- // Toggle: Auto Join Marines
UI.CreateToggle(
    Page, 
    "Auto Team Marines", 
    "Automatically picks Marines on join", 
    Settings.AutoTeam or false, 
    function(state) 
        Settings.AutoTeam = state 
        UI.SaveSettings() 
    end
)

-- ==========================================
-- 2. LOGIC: INTERFACE SEARCHER
-- ==========================================

-- // Function: Locate the Marine Selection Button
local function GetMarineButton()
    local playerGui = Me.PlayerGui
    
    for _, ui in ipairs(playerGui:GetDescendants()) do
        -- Check for the specific team selection frame
        if ui.Name == "ChooseTeam" and ui.Visible then
            local container = ui:FindFirstChild("Marines", true)
            
            if container then
                local btn = container:FindFirstChildWhichIsA("TextButton", true)
                
                -- Validate button presence and visibility
                if btn then
                    local isClickable = btn.AbsoluteSize.X > 0 
                        and btn.AbsoluteSize.Y > 0
                    
                    if isClickable then 
                        return btn 
                    end
                end
            end
        end
    end
    return nil
end

-- ==========================================
-- 3. MAIN EXECUTION HANDLER
-- ==========================================

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- Activation: Setting is ON and Player is teamless
            local shouldProcess = Settings.AutoTeam 
                and Me.Team == nil
            
            if shouldProcess then
                local targetBtn = GetMarineButton()
                
                if targetBtn then
                    -- // STEP 3.1: Remote Method (Standard)
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local commF   = remotes and remotes:FindFirstChild("CommF_")
                    
                    if commF then 
                        SafeInvoke(commF, "SetTeam", "Marines") 
                    end
                    
                    task.wait(0.5)
                    
                    -- // STEP 3.2: Fallback Method (UI Interaction)
                    pcall(function() targetBtn.MouseButton1Click:Fire() end)
                    pcall(function() targetBtn.Activated:Fire() end)
                    
                    task.wait(1)
                    
                    -- // STEP 3.3: Post-Execution Cleanup
                    if Me.Team ~= nil then
                        -- Manually close the UI if still visible
                        local rootUI = targetBtn:FindFirstAncestor("ChooseTeam")
                        if rootUI then 
                            rootUI.Visible = false 
                        end
                        
                        -- Re-initialize Camera State
                        local camera     = workspace.CurrentCamera
                        camera.CameraType = Enum.CameraType.Custom
                        
                        -- Focus camera on player's humanoid
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