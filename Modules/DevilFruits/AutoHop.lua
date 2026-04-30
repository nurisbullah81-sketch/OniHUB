-- ==========================================
-- MODULE: DEVIL FRUITS - AUTO HOP SERVER
-- ==========================================

-- Services
local HttpService = game:GetService("HttpService")
local VIM         = game:GetService("VirtualInputManager")
local Players     = game:GetService("Players")

-- Variables
local Me = Players.LocalPlayer

-- Wait for UI & Core Components
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings or not _G.Cat.State or not _G.Cat.ESP do 
    task.wait(0.1) 
end

local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State
local ESP      = _G.Cat.ESP

-- ==========================================
-- 1. UI SETUP (Devil Fruits Tab)
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)

UI.CreateToggle(
    Page, 
    "Auto Hop Server", 
    "Hop if no fruits or inventory full", 
    Settings.AutoHop, 
    function(s) 
        Settings.AutoHop = s 
    end
)

-- ==========================================
-- 2. LOGIC: SERVER HOPPING ENGINE
-- ==========================================
local isHopping = false

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    -- Save settings before hopping
    pcall(function() 
        writefile("CatHUB_Config.json", HttpService:JSONEncode(Settings)) 
    end)
    
    task.spawn(function()
        -- STEP 1: SKY TP (Safety measure to prevent dying/lag during hop)
        pcall(function()
            if Me.Character then 
                local hrp = Me.Character:FindFirstChild("HumanoidRootPart") 
                if hrp then 
                    hrp.CFrame = CFrame.new(hrp.Position.X, 5000, hrp.Position.Z)
                    hrp.Anchored = true 
                end 
            end
        end)
        task.wait(0.3) 
        
        -- MAIN LOOP: Finding a new server
        while Settings.AutoHop do 
            local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            
            -- Open Browser if not visible
            if not browser or not browser.Enabled then
                local openBtn = Me.PlayerGui:FindFirstChild("ServerBrowserButton", true)
                
                if openBtn then 
                    local p, s = openBtn.AbsolutePosition, openBtn.AbsoluteSize
                    local tx, ty = p.X + (s.X/2), p.Y + (s.Y/2) + 58
                    
                    VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                    task.wait(0.05)
                    VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                end
            end

            browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            if not browser then 
                task.wait(0.5) 
                continue 
            end

            -- Wait for server list to load
            local listArea = browser:FindFirstChild("Inside", true)
            local count = 0
            
            repeat
                task.wait(0.2)
                count = count + 1
                listArea = browser:FindFirstChild("Inside", true)
            until (listArea and #listArea:GetChildren() > 5) or count > 15

            if listArea then
                local scrollFrame = browser:FindFirstChild("FakeScroll", true)
                local dummyScroll = browser:FindFirstChild("ScrollingFrame", true)
                
                -- Randomize Scroll Position
                if dummyScroll and dummyScroll:IsA("ScrollingFrame") then
                    dummyScroll.CanvasPosition = Vector2.new(0, math.random(500, 2500))
                    task.wait(0.5)
                end

                if not scrollFrame then continue end

                -- Scan for "Join" buttons within viewport
                local buttons = {}
                local sPos, sSize = scrollFrame.AbsolutePosition, scrollFrame.AbsoluteSize
                
                for _, v in pairs(listArea:GetDescendants()) do
                    if v:IsA("TextButton") and v.Name == "Join" and v.Visible then
                        local vy = v.AbsolutePosition.Y
                        
                        -- Only click buttons that are actually visible on screen
                        if vy > sPos.Y and vy < (sPos.Y + sSize.Y - 30) then
                            table.insert(buttons, v)
                        end
                    end
                end

                -- Attempt to Join
                for _, target in pairs(buttons) do
                    if not Settings.AutoHop then break end
                    
                    local bp, bs = target.AbsolutePosition, target.AbsoluteSize
                    local tx, ty = bp.X + (bs.X/2), bp.Y + (bs.Y/2) + 58
                    
                    -- Click and Confirm (Return Key)
                    VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait(0.05)
                    
                    VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    
                    task.wait(0.05)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    task.wait(0.3)
                end
            end
            task.wait(0.5)
        end
        
        -- Cleanup if hopping is cancelled
        local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
        if browser then 
            browser.Enabled = false 
        end
        
        if _G.Cat.ReleaseCharacter then 
            _G.Cat.ReleaseCharacter() 
        end
        
        isHopping = false
    end)
end