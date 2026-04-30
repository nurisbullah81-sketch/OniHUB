-- ==========================================
-- MODULE: AUTO TEAM MARINES
-- ==========================================

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Variables
local Me = Players.LocalPlayer

-- Wait for UI & Core Data
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do 
    task.wait(0.1) 
end

local UI         = _G.Cat.UI
local Settings   = _G.Cat.Settings
local SafeInvoke = _G.Cat.SafeInvoke

-- ==========================================
-- 1. UI SETUP
-- ==========================================
local Page = UI.CreateTab("Misc", false)

UI.CreateToggle(
    Page, 
    "Auto Team Marines", 
    "Automatically picks Marines on join", 
    Settings.AutoTeam or false, 
    function(s) 
        Settings.AutoTeam = s 
        UI.SaveSettings() -- Manual save triggered on change
    end
)

-- ==========================================
-- 2. LOGIC: FIND MARINE BUTTON
-- ==========================================
local function GetMarineButton()
    -- Scan through PlayerGui for the Team Selection UI
    for _, v in pairs(Me.PlayerGui:GetDescendants()) do
        if v.Name == "ChooseTeam" and v.Visible then
            local marineContainer = v:FindFirstChild("Marines", true)
            
            if marineContainer then
                local btn = marineContainer:FindFirstChildWhichIsA("TextButton", true)
                
                -- Ensure button is valid and visible in-game
                if btn and btn.AbsoluteSize.X > 0 and btn.AbsoluteSize.Y > 0 then 
                    return btn 
                end
            end
        end
    end
    return nil
end

-- ==========================================
-- 3. MAIN EXECUTION LOOP
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- Only run if setting is ON and player is still teamless
            if Settings.AutoTeam and Me.Team == nil then
                local btn = GetMarineButton()
                
                if btn then
                    -- Step 1: Remote Invocation (Standard Method)
                    local remotePath = ReplicatedStorage:FindFirstChild("Remotes")
                    local commF      = remotePath and remotePath:FindFirstChild("CommF_")
                    
                    if commF then 
                        SafeInvoke(commF, "SetTeam", "Marines") 
                    end
                    
                    task.wait(0.5)
                    
                    -- Step 2: Fallback (Fire Button Events)
                    pcall(function() btn.MouseButton1Click:Fire() end)
                    pcall(function() btn.Activated:Fire() end)
                    
                    task.wait(1)
                    
                    -- Step 3: Cleanup & Camera Correction
                    if Me.Team ~= nil then
                        -- Hide the UI manually if it stays stuck
                        local chooseTeamUI = btn:FindFirstAncestor("ChooseTeam")
                        if chooseTeamUI then 
                            chooseTeamUI.Visible = false 
                        end
                        
                        -- Reset camera to follow character
                        local cam = workspace.CurrentCamera
                        cam.CameraType = Enum.CameraType.Custom
                        
                        if Me.Character and Me.Character:FindFirstChild("Humanoid") then 
                            cam.CameraSubject = Me.Character.Humanoid 
                        end
                    end
                end
            end
        end)
    end
end)