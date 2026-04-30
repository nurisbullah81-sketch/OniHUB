-- ==========================================
-- MODULE: ANTI-AFK & AUTO TEAM
-- ==========================================

-- Services
local VirtualUser      = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

-- Variables
local Me = Players.LocalPlayer

-- Wait for UI & Settings Core
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings do 
    task.wait(0.1) 
end

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local SafeInvoke = _G.Cat.SafeInvoke

-- ==========================================
-- 1. UI SETUP (Tab Misc)
-- ==========================================
local Page = UI.CreateTab("Misc", false)

-- Anti AFK Toggle
UI.CreateToggle(
    Page, 
    "Anti AFK", 
    "Prevents 20-minute idle kick", 
    Settings.AntiAFK, 
    function(s) 
        Settings.AntiAFK = s 
    end
)

-- Auto Team Toggle
UI.CreateToggle(
    Page, 
    "Auto Team Marines", 
    "Automatically picks Marines on join", 
    Settings.AutoTeam or false, 
    function(s) 
        Settings.AutoTeam = s 
    end
)

-- ==========================================
-- 2. LOGIC: ANTI AFK
-- ==========================================
Me.Idled:Connect(function()
    if Settings.AntiAFK then
        -- Simulates user input to prevent idle kick
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ==========================================
-- 3. LOGIC: AUTO TEAM
-- ==========================================

-- Helper: Finding the Marine Button in UI
local function GetMarineButton()
    for _, v in pairs(Me.PlayerGui:GetDescendants()) do
        if v.Name == "ChooseTeam" and v.Visible then
            local marineContainer = v:FindFirstChild("Marines", true)
            
            if marineContainer then
                local btn = marineContainer:FindFirstChildWhichIsA("TextButton", true)
                
                -- Ensure button is valid and visible
                if btn and btn.AbsoluteSize.X > 0 and btn.AbsoluteSize.Y > 0 then 
                    return btn 
                end
            end
        end
    end
    return nil
end

-- Auto Team Loop
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if Settings.AutoTeam and Me.Team == nil then
                local btn = GetMarineButton()
                
                if btn then
                    -- 1. Try Remote Method (Faster)
                    local remotePath = ReplicatedStorage:FindFirstChild("Remotes")
                    local commF      = remotePath and remotePath:FindFirstChild("CommF_")
                    
                    if commF then 
                        SafeInvoke(commF, "SetTeam", "Marines") 
                    end
                    
                    task.wait(0.5)
                    
                    -- 2. Fallback: Force Click Button
                    pcall(function() btn.MouseButton1Click:Fire() end)
                    pcall(function() btn.Activated:Fire() end)
                    
                    task.wait(1)
                    
                    -- 3. Camera Fix after joining
                    if Me.Team ~= nil then
                        local chooseTeamUI = btn:FindFirstAncestor("ChooseTeam")
                        if chooseTeamUI then 
                            chooseTeamUI.Visible = false 
                        end
                        
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