-- [[ ==========================================
--      MODULE: DEVIL FRUITS - AUTO HOP SERVER
--    ========================================== ]]

-- // Services
local HttpService = game:GetService("HttpService")
local VIM         = game:GetService("VirtualInputManager")
local Players     = game:GetService("Players")

-- // Variables
local Me = Players.LocalPlayer

-- // Wait for UI & Core Components
while not (_G.Cat and _G.Cat.UI and _G.Cat.Settings and _G.Cat.State and _G.Cat.ESP) do 
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
        local encoded = HttpService:JSONEncode(Settings)
        writefile("CatHUB_Config.json", encoded) 
    end)
    
    task.spawn(function()
        -- STEP 1: 5K SKY TP (Safety measure)
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
        
        -- MAIN HOP LOOP
        while Settings.AutoHop do 
            local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            
            -- Open Browser if hidden
            if not browser or not browser.Enabled then
                local openBtn = Me.PlayerGui:FindFirstChild("ServerBrowserButton", true)
                
                if openBtn then 
                    local pos  = openBtn.AbsolutePosition
                    local size = openBtn.AbsoluteSize
                    local tx   = pos.X + (size.X / 2)
                    local ty   = pos.Y + (size.Y / 2) + 58
                    
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

            -- Wait for list loading
            local listArea = browser:FindFirstChild("Inside", true)
            local count    = 0
            
            repeat
                task.wait(0.2)
                count = count + 1
                listArea = browser:FindFirstChild("Inside", true)
            until (listArea and #listArea:GetChildren() > 5) or count > 15

            if listArea then
                local scrollFrame = browser:FindFirstChild("FakeScroll", true)
                local dummyScroll = browser:FindFirstChild("ScrollingFrame", true)
                
                -- Randomize Scroll
                if dummyScroll and dummyScroll:IsA("ScrollingFrame") then
                    dummyScroll.CanvasPosition = Vector2.new(0, math.random(500, 2500))
                    task.wait(0.5)
                end

                if not scrollFrame then continue end

                local buttons = {}
                local sPos    = scrollFrame.AbsolutePosition
                local sSize   = scrollFrame.AbsoluteSize
                
                for _, v in pairs(listArea:GetDescendants()) do
                    if v:IsA("TextButton") and v.Name == "Join" and v.Visible then
                        local vy = v.AbsolutePosition.Y
                        -- Check if button is within the visible scroll area
                        if vy > sPos.Y and vy < (sPos.Y + sSize.Y - 30) then
                            table.insert(buttons, v)
                        end
                    end
                end

                -- Attempt to Join buttons
                for _, target in pairs(buttons) do
                    if not Settings.AutoHop then break end
                    
                    local bp = target.AbsolutePosition
                    local bs = target.AbsoluteSize
                    local tx = bp.X + (bs.X / 2)
                    local ty = bp.Y + (bs.Y / 2) + 58
                    
                    -- Click Join & Press Enter
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
        
        -- Cleanup
        local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
        if browser then browser.Enabled = false end
        
        if _G.Cat.ReleaseCharacter then 
            _G.Cat.ReleaseCharacter() 
        end
        
        isHopping = false
    end)
end

-- ==========================================
-- 3. TRIGGER LOOP: AUTO SCAN & HOP (PINTER & ANTI-STUCK)
-- ==========================================
task.spawn(function()
    task.wait(10) -- Jeda awal pas baru inject script, biar game stabil
    
    while task.wait(2) do
        -- KALO LAGI LOADING / MATI / LAG, SCRIPT TIDUR TOTAL DI SINI!
        -- Dia kagak bakal ngulik data ESP atau apapun yang bikin FPS drop.
        if not State.IsGameReady then
            _G.Cat.WaitUntilReady() -- Tunggu sampai game beneran aman (Ada Team, HRD, Health > 0)
            
            -- [OBAT STUCK HOP] Setelah game ready (misal baru selesai milih team), 
            -- kasih jeda 10 detik biar server stabil & buah sempat spawn ke workspace.
            -- Ini ngebunuh bug "langsung hop lagi pas baru masuk server"
            task.wait(10) 
        end
        
        if Settings.AutoHop and State.IsGameReady then
            pcall(function()
                local fruitCount = 0
                
                -- Count active fruits from ESP Data
                for f, _ in pairs(ESP.Data) do
                    if f and f.Parent and f.Parent == workspace then
                        fruitCount = fruitCount + 1
                    end
                end
                
                -- If no fruits found, execute hop
                if fruitCount == 0 then
                    _G.Cat.HopServer()
                end
            end)
        else
            -- Reset state if toggle turned off during hopping
            if isHopping and not Settings.AutoHop then
                isHopping = false
                if _G.Cat.ReleaseCharacter then 
                    _G.Cat.ReleaseCharacter() 
                end
            end
        end
    end
end)