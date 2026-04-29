local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")

-- SERVICES UNTUK SOVEREIGN V26
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser") -- TAMBAHAN: Bukan buat macro, tapi buat anti-kick AFK!

local Me = _G.Cat.Player
local Settings = _G.Cat.Settings

local Data = {}
local Mem = {}
local FC = 0
local SKIP = 10

-- ==========================================
-- 1. THE GUARDIAN V26 (ZERO-BLINK TECHNOLOGY)
-- ==========================================
GuiService.ErrorMessageChanged:Connect(function()
    if Settings.AutoHop then
        pcall(function() GuiService:ClearError() end)
    end
end)

task.spawn(function()
    local promptGui = CoreGui:WaitForChild("RobloxPromptGui", 5)
    if promptGui then
        local overlay = promptGui:WaitForChild("promptOverlay", 5)
        if overlay then
            overlay.Visible = false
            overlay:GetPropertyChangedSignal("Visible"):Connect(function()
                if Settings.AutoHop then
                    overlay.Visible = false
                end
            end)
        end
    end
end)

-- ==========================================
-- 1.5. ANTI-AFK IMMORTALITY (AFK 24/7 FIX)
-- ==========================================
-- Roblox nge-kick lu kalau lu ga ngirim input apapun selama 20 menit.
-- Ini bikin lu tetep "hidup" di mata server walau PC lu ngadep kipas.
Me.Idled:Connect(function()
    if Settings.TweenFruit or Settings.AutoHop then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ==========================================
-- 2. ESP SYSTEM (ORIGINAL - UNTOUCHED)
-- ==========================================
local function Pos(f) 
    if not f or not f.Parent then return nil end 
    local ok,r=pcall(function() 
        if f:IsA("Tool") then 
            local h=f:FindFirstChild("Handle") 
            if h then return h.Position end 
        elseif f:IsA("Model") then 
            if f.PrimaryPart then return f.PrimaryPart.Position end 
            local root=f:FindFirstChild("HumanoidRootPart") or f:FindFirstChildWhichIsA("BasePart") 
            if root then return root.Position end 
        end 
    end) 
    return ok and r or nil 
end

local function IsF(o) 
    if not o or not o.Parent then return false end 
    local ok,r=pcall(function() 
        if (o:IsA("Tool") or o:IsA("Model")) and o:FindFirstChild("Fruit") then 
            return true 
        end 
        return false 
    end) 
    return ok and r 
end

local function Add(f) 
    if not f or not f.Parent or Data[f] then return end 
    pcall(function() 
        local bb=Instance.new("BillboardGui",f) 
        bb.Name="CatESP" 
        bb.Size=UDim2.new(0,150,0,20) 
        bb.AlwaysOnTop=true 
        bb.StudsOffset=Vector3.new(0,3,0) 
        bb.Enabled=false 
        local txt=Instance.new("TextLabel",bb) 
        txt.Size=UDim2.new(1,0,1,0) 
        txt.BackgroundTransparency=1 
        txt.Text=f.Name.." []" 
        txt.TextColor3=Color3.fromRGB(255,255,255) 
        txt.TextStrokeTransparency=0.3 
        txt.TextStrokeColor3=Color3.fromRGB(0,0,0) 
        txt.Font=Enum.Font.GothamBold 
        txt.TextSize=13 
        txt.TextXAlignment="Left" 
        Data[f]={bb=bb,txt=txt} 
        Mem[f]=-1 
    end) 
end

local function Rem(f) 
    if Data[f] then 
        pcall(function() 
            if Data[f].bb and Data[f].bb.Parent then Data[f].bb:Destroy() end 
        end) 
        Data[f]=nil 
        Mem[f]=nil 
    end 
end

for _, o in pairs(Workspace:GetChildren()) do if IsF(o) then Add(o) end end
Workspace.ChildAdded:Connect(function(o) task.wait(0.5) if IsF(o) then Add(o) end end)
Workspace.ChildRemoved:Connect(function(o) Rem(o) end)

RunService.RenderStepped:Connect(function() 
    FC=FC+1 
    if FC%SKIP~=0 then return end 
    pcall(function() 
        if not Settings.FruitESP then 
            for _,d in pairs(Data) do if d and d.bb then d.bb.Enabled=false end end 
            return 
        end 
        local c=Me.Character 
        if not c then return end 
        local r=c:FindFirstChild("HumanoidRootPart") 
        if not r then return end 
        local mp=r.Position 
        for f,d in pairs(Data) do 
            if not f or not f.Parent or not d.bb or not d.bb.Parent then Rem(f) continue end 
            local p=Pos(f) 
            if not p then d.bb.Enabled=false continue end 
            local dx,dy,dz=p.X-mp.X,p.Y-mp.Y,p.Z-mp.Z 
            local m=math.floor(math.sqrt(dx*dx+dy*dy+dz*dz)) 
            if math.abs(m-(Mem[f]or-1))>5 then 
                Mem[f]=m 
                d.txt.Text=f.Name.." ["..m.."m]" 
            end 
            d.bb.Enabled=true 
        end 
    end) 
end)

-- ==========================================
-- 3. PROXY TWEEN ENGINE (ANTI-FLING & INSTANT KILL SWITCH)
-- ==========================================
local isTweening = false
local currentTarget = nil
local proxyPart = nil
local noclipConn = nil
local currentTween = nil
local originalCollisions = {} 

local TWEEN_SPEED = 300 

local function StopSmartTween()
    -- Cegah double stop yang bikin bug
    if not isTweening then return end
    isTweening = false
    currentTarget = nil
    
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    
    -- ANTI-FLING/NINJUTSU FIX:
    -- Pas tween berhenti, kita matiin fisika sebentar, reset velocity bersih, baru nyalain lagi.
    -- Ini biar server Roblox ga ngeresync karakter lu ke langit/laut.
    pcall(function()
        if Me.Character then
            local hrp = Me.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = true
                task.wait(0.05) -- Kasih jeda server nangkap posisi terakhir
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                hrp.Anchored = false
            end
            
            for part, state in pairs(originalCollisions) do
                if part and part.Parent then
                    part.CanCollide = state
                end
            end
        end
        table.clear(originalCollisions)
    end)
    
    if proxyPart then
        proxyPart:Destroy()
        proxyPart = nil
    end
end

local function GetNearestFruit() 
    local closest, minDist = nil, math.huge 
    local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
    if not hrp then return nil end 
    for f, _ in pairs(Data) do 
        if f and f.Parent == Workspace then 
            local p = Pos(f) 
            if p then 
                local dist = (p - hrp.Position).Magnitude 
                if dist < minDist then 
                    closest, minDist = f, dist 
                end 
            end 
        else
            Rem(f)
        end 
    end 
    return closest 
end

task.spawn(function() 
    while task.wait(0.2) do 
        pcall(function() 
            if Settings.TweenFruit then 
                local nearest = GetNearestFruit() 
                local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
                
                if nearest and hrp then 
                    local targetPos = Pos(nearest) 
                    if not targetPos then StopSmartTween() return end
                    
                    local dist = (targetPos - hrp.Position).Magnitude 
                    
                    if dist < 5 then
                        StopSmartTween()
                    else
                        if currentTarget ~= nearest or not isTweening then
                            StopSmartTween() 
                            currentTarget = nearest
                            isTweening = true
                            
                            table.clear(originalCollisions)
                            for _, part in pairs(Me.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    originalCollisions[part] = part.CanCollide
                                end
                            end
                            
                            local startCFrame = CFrame.lookAt(hrp.Position, targetPos)
                            proxyPart = Instance.new("Part")
                            proxyPart.Name = "NomexyProxy"
                            proxyPart.Transparency = 1
                            proxyPart.Anchored = true
                            proxyPart.CanCollide = false
                            proxyPart.Size = Vector3.new(1, 1, 1)
                            proxyPart.CFrame = startCFrame
                            proxyPart.Parent = workspace

                            -- INSTANT KILL SWITCH FIX:
                            -- Noclip sekarang ngecek Settings.TweenFruit tiap frame!
                            noclipConn = RunService.Stepped:Connect(function()
                                if isTweening and Settings.TweenFruit and Me.Character and hrp and hrp.Parent and proxyPart then
                                    for _, part in pairs(Me.Character:GetDescendants()) do
                                        if part:IsA("BasePart") and part.CanCollide then 
                                            part.CanCollide = false 
                                        end
                                    end
                                    -- Ganti Velocity -> AssemblyLinearVelocity (Fisika modern, ga bikin desync)
                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    hrp.AssemblyAngularVelocity = Vector3.zero
                                    hrp.CFrame = proxyPart.CFrame
                                else
                                    -- Kalau lu pencet OFF, atau karakter mati, langsung hancurin prosesnya!
                                    StopSmartTween()
                                end
                            end)
                            
                            local endPos = targetPos + Vector3.new(0, 2, 0) 
                            local endCFrame = CFrame.lookAt(endPos, endPos + startCFrame.LookVector)
                            local timeToTravel = dist / TWEEN_SPEED
                            
                            local tweenInfo = TweenInfo.new(timeToTravel, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                            currentTween = TweenService:Create(proxyPart, tweenInfo, {CFrame = endCFrame})
                            currentTween:Play()
                        end
                    end 
                else 
                    StopSmartTween()
                end 
            else 
                StopSmartTween()
            end 
        end) 
    end 
end)

-- ==========================================
-- 4. AUTO STORE (ANTI-FREEZE INVOKE)
-- ==========================================
local StoreBlacklist={}
local isStoring = false

-- Fungsi pembantu biar InvokeServer ga nge-freeze loop utama kalau server lag
local function SafeInvoke(remote, ...)
    local args = {...}
    local result = nil
    local thread = coroutine.running()
    
    local co = task.spawn(function()
        local ok, res = pcall(function()
            return remote:InvokeServer(unpack(args))
        end)
        if ok then result = res end
        task.spawn(thread, true)
    end)
    
    -- Kalau lebih dari 5 detik ga ada jawaban, bypass dan lanjut!
    task.delay(5, function()
        if result == nil then
            task.spawn(thread, false) 
        end
    end)
    
    coroutine.yield()
    return result
end

task.spawn(function() 
    while task.wait(1) do 
        if Settings.AutoStoreFruit and not isStoring then 
            isStoring = true
            pcall(function() 
                local character = Me.Character
                if not character then isStoring = false return end 
                
                local fruitTool = nil
                if Me.Backpack then
                    for _, v in pairs(Me.Backpack:GetChildren()) do
                        if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then
                            fruitTool = v
                            break
                        end
                    end
                end
                
                if not fruitTool then
                    for _, v in pairs(character:GetChildren()) do
                        if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then
                            fruitTool = v
                            break
                        end
                    end
                end

                if fruitTool then
                    local hum = character:FindFirstChild("Humanoid")
                    if hum and fruitTool.Parent ~= character then
                        hum:EquipTool(fruitTool)
                        task.wait(0.5)
                    end
                    
                    local fruitName = fruitTool.Name
                    local fruitVal = fruitTool:FindFirstChild("Fruit")
                    if fruitVal and fruitVal:IsA("StringValue") and fruitVal.Value ~= "" then
                        fruitName = fruitVal.Value
                    else
                        fruitName = string.gsub(fruitTool.Name, " Fruit", "")
                        fruitName = fruitName.."-"..fruitName 
                    end
                    
                    local storeSuccess = false
                    for _ = 1, 3 do -- Turunin jadi 3x percobaan, lagipake SafeInvoke
                        if storeSuccess then break end
                        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                        if remote then
                            local result = SafeInvoke(remote, "StoreFruit", fruitName, fruitTool)
                            if result == true then storeSuccess = true end
                        end
                        task.wait(0.5)
                    end
                    
                    if not storeSuccess then
                        table.insert(StoreBlacklist, fruitTool.Name) 
                        if hum then hum:EquipTool(nil) end
                    end
                end
            end) 
            isStoring = false
        end 
    end 
end)

-- ==========================================
-- 5. HOP SERVER - SOVEREIGN V26 (TOGGLE FIX)
-- ==========================================
local isHopping = false

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    pcall(function()
        local ConfigFile = "CatHUB_Config.json"
        writefile(ConfigFile, HttpService:JSONEncode(Settings))
    end)
    
    task.spawn(function()
        warn("[CatHUB] [HOP] Executing Sovereign V26 Engine...")
        
        while Settings.AutoHop do -- Loop ini langsung berhenti kalau lu pencet OFF
            local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            
            if not browser or not browser.Enabled then
                local openBtn = Me.PlayerGui:FindFirstChild("ServerBrowserButton", true)
                if openBtn then
                    local p, s = openBtn.AbsolutePosition, openBtn.AbsoluteSize
                    VIM:SendMouseButtonEvent(p.X + (s.X/2), p.Y + (s.Y/2) + 58, 0, true, game, 0)
                    task.wait(0.1)
                    VIM:SendMouseButtonEvent(p.X + (s.X/2), p.Y + (s.Y/2) + 58, 0, false, game, 0)
                end
            end

            browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            if not browser then task.wait(1) continue end

            local listArea = browser:FindFirstChild("Inside", true)
            local count = 0
            repeat
                task.wait(0.5)
                count = count + 1
                listArea = browser:FindFirstChild("Inside", true)
            until (listArea and #listArea:GetChildren() > 5) or count > 20

            if listArea then
                local scrollFrame = browser:FindFirstChild("FakeScroll", true)
                local dummyScroll = browser:FindFirstChild("ScrollingFrame", true)
                
                if dummyScroll and dummyScroll:IsA("ScrollingFrame") then
                    dummyScroll.CanvasPosition = Vector2.new(0, math.random(500, 2500))
                    task.wait(1) 
                end

                if not scrollFrame then continue end

                local buttons = {}
                local sPos, sSize = scrollFrame.AbsolutePosition, scrollFrame.AbsoluteSize
                for _, v in pairs(listArea:GetDescendants()) do
                    if v:IsA("TextButton") and v.Name == "Join" and v.Visible then 
                        if v.AbsolutePosition.Y > sPos.Y and v.AbsolutePosition.Y < (sPos.Y + sSize.Y - 30) then
                            table.insert(buttons, v)
                        end
                    end
                end

                for _, target in pairs(buttons) do
                    if not Settings.AutoHop then break end -- Fix: Langsung berhenti klik kalau di OFF
                    local bp, bs = target.AbsolutePosition, target.AbsoluteSize
                    local tx, ty = bp.X + (bs.X/2), bp.Y + (bs.Y/2) + 58
                    
                    VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    
                    task.wait(0.05) 
                    
                    VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    
                    task.wait(0.1)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)

                    task.wait(0.5) 
                end
            end
            task.wait(1)
        end
        
        -- Failsafe: Kalau keluar loop karena di OFF, bersih-bersih
        local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
        if browser then browser.Enabled = false end
        isHopping = false
    end)
end

task.spawn(function()
    task.wait(10) 
    
    while task.wait(5) do
        if Settings.AutoHop and Me.Team ~= nil and Me.Character then
            pcall(function()
                local fruitCount = 0
                for f, _ in pairs(Data) do
                    if f and f.Parent and f.Parent == Workspace then 
                        fruitCount = fruitCount + 1 
                    else
                        Rem(f)
                    end
                end
                
                if fruitCount == 0 then
                    warn("[CatHUB] No fruits found in map. Initiating server hop...")
                    _G.Cat.HopServer()
                else
                    isHopping = false
                    local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                    if browser and browser.Enabled then 
                        browser.Enabled = false 
                    end
                end
            end)
        else
            if not Settings.AutoHop then
                -- Fix: Kalau AutoHop dimatiin tengah jalan, bersihkan state
                isHopping = false
                local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                if browser then browser.Enabled = false end
            end
        end
    end
end)

function _G.Cat.GetFruitsList()
    local names = {}
    for f, _ in pairs(Data) do if f and f.Parent then table.insert(names, f.Name) end end
    return names
end

-- ==========================================
-- 6. GOD-TIER AUTO TEAM (MARINES) - ANTI FREEZE
-- ==========================================
local function GetMarineButton()
    for _, v in pairs(Me.PlayerGui:GetDescendants()) do
        if v.Name == "ChooseTeam" and v.Visible then
            local marineContainer = v:FindFirstChild("Marines", true)
            if marineContainer then
                return marineContainer:FindFirstChildWhichIsA("TextButton", true)
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if Me.Team == nil then
                local btn = GetMarineButton()
                
                if btn then
                    warn("[CatHUB] Team selection detected. Forcing Marines...")
                    
                    local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                    if remote then
                        -- Pake SafeInvoke biar ga nge-freeze kalau server lag pas milih team
                        SafeInvoke(remote, "SetTeam", "Marines")
                    end
                    
                    task.wait(0.5)
                    
                    pcall(function() btn.MouseButton1Click:Fire() end)
                    pcall(function() btn.Activated:Fire() end)
                    
                    task.wait(1)
                    if Me.Team ~= nil then
                        local chooseTeamUI = btn:FindFirstAncestor("ChooseTeam")
                        if chooseTeamUI then chooseTeamUI.Visible = false end
                        
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