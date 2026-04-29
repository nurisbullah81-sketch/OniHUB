-- ==========================================
-- THE SHIELD (ANTI AUTO-EXECUTE CRASH)
-- ==========================================
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser") 

local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait(0.1) end
local Me = Players.LocalPlayer

-- Tunggu sampai _G.Cat siap
while not _G or not _G.Cat or not _G.Cat.Settings do task.wait(0.1) end
local Settings = _G.Cat.Settings

local Data = {}
local Mem = {}
local FC = 0
local SKIP = 10

-- ==========================================
-- 1. MASTER LOCK (EVENT-BASED - ANTI LAG FREEZE)
-- ==========================================
local IsGameReady = false

local function StopSmartTween() -- Di-deklarasiin dulu biar Master Lock ga error
    -- Logic ada di bawah
end

local function UpdateGameState()
    local isReady = (Me.Team ~= nil and Me.Character and Me.Character:FindFirstChild("HumanoidRootPart"))
    if isReady ~= IsGameReady then
        IsGameReady = isReady
        warn("[CatHUB] System State: " .. (IsGameReady and "UNLOCKED (Ready)" or "LOCKED (Loading/Dead)"))
        if not IsGameReady then 
            StopSmartTween() 
        end
    end
end

task.spawn(UpdateGameState)
Me:GetPropertyChangedSignal("Team"):Connect(UpdateGameState)
Me.CharacterAdded:Connect(function(char)
    IsGameReady = false
    task.spawn(function()
        char:WaitForChild("HumanoidRootPart", 15)
        UpdateGameState()
    end)
end)
Me.CharacterRemoving:Connect(function()
    IsGameReady = false
    UpdateGameState()
end)

-- ==========================================
-- 2. THE GUARDIAN V26 & ANTI-AFK
-- ==========================================
GuiService.ErrorMessageChanged:Connect(function()
    if Settings.AutoHop then pcall(function() GuiService:ClearError() end) end
end)

task.spawn(function()
    local promptGui = CoreGui:WaitForChild("RobloxPromptGui", 5)
    if promptGui then
        local overlay = promptGui:WaitForChild("promptOverlay", 5)
        if overlay then
            overlay.Visible = false
            overlay:GetPropertyChangedSignal("Visible"):Connect(function()
                if Settings.AutoHop then overlay.Visible = false end
            end)
        end
    end
end)

Me.Idled:Connect(function()
    if Settings.TweenFruit or Settings.AutoHop then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ==========================================
-- 3. ESP SYSTEM
-- ==========================================
local function Pos(f) if not f or not f.Parent then return nil end local ok,r=pcall(function() if f:IsA("Tool") then local h=f:FindFirstChild("Handle") if h then return h.Position end elseif f:IsA("Model") then if f.PrimaryPart then return f.PrimaryPart.Position end local root=f:FindFirstChild("HumanoidRootPart") or f:FindFirstChildWhichIsA("BasePart") if root then return root.Position end end end) return ok and r or nil end
local function IsF(o) if not o or not o.Parent then return false end local ok,r=pcall(function() if (o:IsA("Tool") or o:IsA("Model")) and o:FindFirstChild("Fruit") then return true end return false end) return ok and r end

local function Add(f) if not f or not f.Parent or Data[f] then return end pcall(function() local bb=Instance.new("BillboardGui",f) bb.Name="CatESP" bb.Size=UDim2.new(0,150,0,20) bb.AlwaysOnTop=true bb.StudsOffset=Vector3.new(0,3,0) bb.Enabled=false local txt=Instance.new("TextLabel",bb) txt.Size=UDim2.new(1,0,1,0) txt.BackgroundTransparency=1 txt.Text=f.Name.." []" txt.TextColor3=Color3.fromRGB(255,255,255) txt.TextStrokeTransparency=0.3 txt.TextStrokeColor3=Color3.fromRGB(0,0,0) txt.Font=Enum.Font.GothamBold txt.TextSize=13 txt.TextXAlignment="Left" Data[f]={bb=bb,txt=txt} Mem[f]=-1 end) end
local function Rem(f) if Data[f] then pcall(function() if Data[f].bb and Data[f].bb.Parent then Data[f].bb:Destroy() end end) Data[f]=nil Mem[f]=nil end end

for _, o in pairs(Workspace:GetChildren()) do if IsF(o) then Add(o) end end
Workspace.ChildAdded:Connect(function(o) task.wait(0.5) if IsF(o) then Add(o) end end)
Workspace.ChildRemoved:Connect(function(o) Rem(o) end)

RunService.RenderStepped:Connect(function() FC=FC+1 if FC%SKIP~=0 then return end pcall(function() if not Settings.FruitESP then for _,d in pairs(Data) do if d and d.bb then d.bb.Enabled=false end end return end local c=Me.Character if not c then return end local r=c:FindFirstChild("HumanoidRootPart") if not r then return end local mp=r.Position for f,d in pairs(Data) do if not f or not f.Parent or not d.bb or not d.bb.Parent then Rem(f) continue end local p=Pos(f) if not p then d.bb.Enabled=false continue end local dx,dy,dz=p.X-mp.X,p.Y-mp.Y,p.Z-mp.Z local m=math.floor(math.sqrt(dx*dx+dy*dy+dz*dz)) if math.abs(m-(Mem[f]or-1))>5 then Mem[f]=m d.txt.Text=f.Name.." ["..m.."m]" end d.bb.Enabled=true end end) end)

-- ==========================================
-- 4. PROXY TWEEN ENGINE (ANTI-FLING & KILL SWITCH)
-- ==========================================
local isTweening = false
local currentTarget = nil
local proxyPart = nil
local noclipConn = nil
local currentTween = nil
local originalCollisions = {} 
local TWEEN_SPEED = 300 

function StopSmartTween()
    if not isTweening then return end
    isTweening = false; currentTarget = nil
    if currentTween then pcall(function() currentTween:Cancel() end) currentTween = nil end
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if proxyPart then pcall(function() proxyPart:Destroy() end) proxyPart = nil end
    
    pcall(function()
        if Me.Character then
            local hrp = Me.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            for part, state in pairs(originalCollisions) do
                if part and part.Parent then part.CanCollide = state end
            end
        end
        table.clear(originalCollisions)
    end)
end

local function GetNearestFruit() local closest, minDist = nil, math.huge local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") if not hrp then return nil end for f, _ in pairs(Data) do if f and f.Parent == Workspace then local p = Pos(f) if p then local dist = (p - hrp.Position).Magnitude if dist < minDist then closest, minDist = f, dist end end else Rem(f) end end return closest end

task.spawn(function() 
    while task.wait(0.2) do 
        pcall(function() 
            if Settings.TweenFruit and IsGameReady then 
                local nearest = GetNearestFruit() 
                local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
                if nearest and hrp then 
                    local targetPos = Pos(nearest) 
                    if not targetPos then StopSmartTween() return end
                    local dist = (targetPos - hrp.Position).Magnitude 
                    if dist < 5 then StopSmartTween()
                    else
                        if currentTarget ~= nearest or not isTweening then
                            StopSmartTween() 
                            currentTarget = nearest; isTweening = true
                            table.clear(originalCollisions)
                            for _, part in pairs(Me.Character:GetDescendants()) do if part:IsA("BasePart") then originalCollisions[part] = part.CanCollide end end
                            local startCFrame = CFrame.lookAt(hrp.Position, targetPos)
                            proxyPart = Instance.new("Part") proxyPart.Name = "NomexyProxy" proxyPart.Transparency = 1 proxyPart.Anchored = true proxyPart.CanCollide = false proxyPart.Size = Vector3.new(1, 1, 1) proxyPart.CFrame = startCFrame proxyPart.Parent = workspace

                            noclipConn = RunService.Stepped:Connect(function()
                                if isTweening and Settings.TweenFruit and IsGameReady then
                                    local success, hrpCheck = pcall(function() return Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") end)
                                    if success and hrpCheck and proxyPart then
                                        for _, part in pairs(Me.Character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end
                                        hrpCheck.AssemblyLinearVelocity = Vector3.zero; hrpCheck.AssemblyAngularVelocity = Vector3.zero; hrpCheck.CFrame = proxyPart.CFrame
                                    end
                                else
                                    if not Settings.TweenFruit or not IsGameReady then StopSmartTween() end
                                end
                            end)
                            
                            local endPos = targetPos + Vector3.new(0, 2, 0) 
                            local endCFrame = CFrame.lookAt(endPos, endPos + startCFrame.LookVector)
                            currentTween = TweenService:Create(proxyPart, TweenInfo.new(dist / TWEEN_SPEED, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = endCFrame})
                            currentTween:Play()
                        end
                    end 
                else StopSmartTween() end 
            else StopSmartTween() end 
        end) 
    end 
end)

-- ==========================================
-- 5. AUTO STORE (STEALTH MODE)
-- ==========================================
local StoreBlacklist={}
local isStoring = false

local function SafeInvoke(remote, ...)
    local args = {...}
    local thread = coroutine.running()
    local isDone = false
    local returnData = {false, "Timeout"}

    task.spawn(function()
        local ok, res = pcall(function() return remote:InvokeServer(unpack(args)) end)
        if not isDone then isDone = true; returnData = {ok, res}; task.spawn(thread) end
    end)
    
    task.delay(3, function()
        if not isDone then isDone = true; returnData = {false, "Timeout"}; task.spawn(thread) end
    end)
    
    coroutine.yield()
    return unpack(returnData)
end

task.spawn(function() 
    while task.wait(1) do 
        if Settings.AutoStoreFruit and not isStoring and IsGameReady then 
            isStoring = true
            pcall(function() 
                local character = Me.Character
                if not character then isStoring = false return end 
                local fruitTool = nil
                if Me.Backpack then for _, v in pairs(Me.Backpack:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then fruitTool = v break end end end
                if not fruitTool then for _, v in pairs(character:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then fruitTool = v break end end end

                if fruitTool then
                    local fruitName = fruitTool.Name
                    local fruitVal = fruitTool:FindFirstChild("Fruit")
                    if fruitVal and fruitVal:IsA("StringValue") and fruitVal.Value ~= "" then fruitName = fruitVal.Value else fruitName = string.gsub(fruitTool.Name, " Fruit", "") fruitName = fruitName.."-"..fruitName end
                    
                    local storeSuccess = false
                    for _ = 1, 3 do 
                        if storeSuccess then break end
                        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                        if remote then local ok, result = SafeInvoke(remote, "StoreFruit", fruitName, fruitTool) if ok and result == true then storeSuccess = true end end
                        task.wait(0.5)
                    end
                    if not storeSuccess then table.insert(StoreBlacklist, fruitTool.Name) end
                end
            end) 
            isStoring = false
        end 
    end 
end)

-- ==========================================
-- 6. HOP SERVER - SOVEREIGN V26 (5K TP + 100% ACCURACY VIM)
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
        warn("[CatHUB] [HOP] Executing Sovereign V26 Engine (Stable)...")
        
        -- [1] SKY TP 5K
        pcall(function()
            if Me.Character then
                local hrp = Me.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(hrp.Position.X, 5000, hrp.Position.Z)
                    hrp.Anchored = true
                end
            end
        end)
        task.wait(0.5)
        
        while Settings.AutoHop do 
            local pg = Me:FindFirstChild("PlayerGui")
            if not pg then task.wait(1) continue end
            
            local browser = pg:FindFirstChild("ServerBrowser", true)
            local inset = GuiService:GetGuiInset().Y 
            
            -- [2] BUKA UI (HOVER + JEDA 0.05s)
            if not browser or not browser.Enabled then
                local openBtn = pg:FindFirstChild("ServerBrowserButton", true)
                if openBtn then
                    local p, s = openBtn.AbsolutePosition, openBtn.AbsoluteSize
                    local tx, ty = p.X + (s.X/2), p.Y + (s.Y/2) + inset
                    VIM:SendMouseMovementEvent(tx, ty)
                    task.wait(0.1)
                    VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                    task.wait(0.05)
                    VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                    task.wait(0.5) 
                end
            end

            browser = pg:FindFirstChild("ServerBrowser", true)
            if not browser then task.wait(1) continue end

            local listArea = browser:FindFirstChild("Inside", true)
            local count = 0
            repeat task.wait(0.5) count = count + 1 listArea = browser:FindFirstChild("Inside", true) until (listArea and #listArea:GetChildren() > 5) or count > 20

            if count > 20 then browser.Enabled = false task.wait(1) continue end

            if listArea then
                local scrollFrame = browser:FindFirstChild("FakeScroll", true)
                local dummyScroll = browser:FindFirstChild("ScrollingFrame", true)
                if dummyScroll and dummyScroll:IsA("ScrollingFrame") then dummyScroll.CanvasPosition = Vector2.new(0, math.random(500, 2500)) task.wait(1) end
                if not scrollFrame then continue end

                local buttons = {}
                local sTop = scrollFrame.AbsolutePosition.Y
                local sBottom = sTop + scrollFrame.AbsoluteSize.Y
                
                for _, v in pairs(listArea:GetDescendants()) do
                    if v:IsA("TextButton") and v.Name == "Join" and v.Visible then 
                        local btnTop = v.AbsolutePosition.Y
                        local btnBottom = btnTop + v.AbsoluteSize.Y
                        -- [3] STRICT BOUNDS
                        if btnTop > (sTop + 5) and btnBottom < (sBottom - 5) then table.insert(buttons, v) end
                    end
                end

                for _, target in pairs(buttons) do
                    if not Settings.AutoHop then break end 
                    local bp, bs = target.AbsolutePosition, target.AbsoluteSize
                    local tx = bp.X + (bs.X/2)
                    local ty = bp.Y + (bs.Y/2) + inset
                    
                    -- [4] JOIN CLICK
                    VIM:SendMouseMovementEvent(tx, ty)
                    task.wait(0.1)
                    VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0) 
                    task.wait(0.05)
                    VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0) 
                    break 
                end
                task.wait(5)
            end
            task.wait(1)
        end
        
        -- Cleanup
        local pg = Me:FindFirstChild("PlayerGui")
        if pg then local browser = pg:FindFirstChild("ServerBrowser", true) if browser then browser.Enabled = false end end
        pcall(function() if Me.Character then local hrp = Me.Character:FindFirstChild("HumanoidRootPart") if hrp and hrp.Anchored then hrp.Anchored = false end end end)
        isHopping = false
    end)
end

task.spawn(function()
    task.wait(10) 
    while task.wait(5) do
        if Settings.AutoHop and IsGameReady then
            pcall(function()
                local fruitCount = 0
                for f, _ in pairs(Data) do if f and f.Parent and f.Parent == Workspace then fruitCount = fruitCount + 1 else Rem(f) end
                if fruitCount == 0 then _G.Cat.HopServer() else isHopping = false local pg = Me:FindFirstChild("PlayerGui") if pg then local browser = pg:FindFirstChild("ServerBrowser", true) if browser and browser.Enabled then browser.Enabled = false end end end
            end)
        else
            if not Settings.AutoHop then isHopping = false local pg = Me:FindFirstChild("PlayerGui") if pg then local browser = pg:FindFirstChild("ServerBrowser", true) if browser then browser.Enabled = false end end end
        end
    end
end)

function _G.Cat.GetFruitsList() local names = {} for f, _ in pairs(Data) do if f and f.Parent then table.insert(names, f.Name) end end return names end

-- ==========================================
-- 7. GOD-TIER AUTO TEAM (MARINES)
-- ==========================================
local function GetMarineButton()
    for _, v in pairs(Me.PlayerGui:GetDescendants()) do
        if v.Name == "ChooseTeam" and v.Visible then
            local marineContainer = v:FindFirstChild("Marines", true)
            if marineContainer then
                local btn = marineContainer:FindFirstChildWhichIsA("TextButton", true)
                if btn and btn.AbsoluteSize.X > 0 and btn.AbsoluteSize.Y > 0 then return btn end
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
                    local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                    if remote then SafeInvoke(remote, "SetTeam", "Marines") end
                    task.wait(0.5)
                    pcall(function() btn.MouseButton1Click:Fire() end)
                    pcall(function() btn.Activated:Fire() end)
                    task.wait(1)
                    if Me.Team ~= nil then
                        local chooseTeamUI = btn:FindFirstAncestor("ChooseTeam") if chooseTeamUI then chooseTeamUI.Visible = false end
                        local cam = workspace.CurrentCamera cam.CameraType = Enum.CameraType.Custom
                        if Me.Character and Me.Character:FindFirstChild("Humanoid") then cam.CameraSubject = Me.Character.Humanoid end
                    end
                end
            end
        end)
    end
end)