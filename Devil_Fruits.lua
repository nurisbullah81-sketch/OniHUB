local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")
local Me = _G.Cat.Player
local Settings = _G.Cat.Settings
local TopBarOffset = game:GetService("GuiService"):GetGuiInset().Y

local Data = {}
local Mem = {}
local FC = 0
local SKIP = 10

-- [ESP]
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
        if (o:IsA("Tool") or obj:IsA("Model")) and o:FindFirstChild("Fruit") then return true end 
        return false 
    end) 
    return ok and r 
end

local function Add(f) 
    if not f or not f.Parent or Data[f] then return end 
    pcall(function() 
        local bb=Instance.new("BillboardGui",f) 
        bb.Name="CatESP" bb.Size=UDim2.new(0,150,0,20) bb.AlwaysOnTop=true bb.StudsOffset=Vector3.new(0,3,0) bb.Enabled=false 
        local txt=Instance.new("TextLabel",bb) 
        txt.Size=UDim2.new(1,0,1,0) txt.BackgroundTransparency=1 txt.Text=f.Name.." []" txt.TextColor3=Color3.fromRGB(255,255,255) 
        txt.TextStrokeTransparency=0.3 txt.TextStrokeColor3=Color3.fromRGB(0,0,0) txt.Font=Enum.Font.GothamBold txt.TextSize=13 txt.TextXAlignment="Left" 
        Data[f]={bb=bb,txt=txt} Mem[f]=-1 
    end) 
end

local function Rem(f) 
    if Data[f] then pcall(function() if Data[f].bb and Data[f].bb.Parent then Data[f].bb:Destroy() end end) Data[f]=nil Mem[f]=nil end 
end

for _, o in pairs(Workspace:GetChildren()) do if IsF(o) then Add(o) end end
Workspace.ChildAdded:Connect(function(o) task.wait(0.5) if IsF(o) then Add(o) end end)
Workspace.ChildRemoved:Connect(function(o) Rem(o) end)

RunService.RenderStepped:Connect(function() 
    FC=FC+1 if FC%SKIP~=0 then return end 
    pcall(function() 
        if not Settings.FruitESP then for _,d in pairs(Data) do if d and d.bb then d.bb.Enabled=false end end return end 
        local c=Me.Character if not c then return end local r=c:FindFirstChild("HumanoidRootPart") if not r then return end local mp=r.Position 
        for f,d in pairs(Data) do 
            if not f or not f.Parent or not d.bb or not d.bb.Parent then Rem(f) continue end 
            local p=Pos(f) if not p then d.bb.Enabled=false continue end 
            local dx,dy,dz=p.X-mp.X,p.Y-mp.Y,p.Z-mp.Z local m=math.floor(math.sqrt(dx*dx+dy*dy+dz*dz)) 
            if math.abs(m-(Mem[f]or-1))>5 then Mem[f]=m d.txt.Text=f.Name.." ["..m.."m]" end d.bb.Enabled=true 
        end 
    end) 
end)

-- [TWEEN SMOOTH]
local fruitTween=nil local lastTweenTarget=nil
local function GetNearestFruit() 
    local closest,minDist=nil,math.huge local hrp=Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") if not hrp then return nil end 
    for f,_ in pairs(Data) do if f and f.Parent then local p=Pos(f) if p then local dist=(p-hrp.Position).Magnitude if dist<minDist then closest,minDist=f,dist end end end end return closest 
end

task.spawn(function() 
    while task.wait(1) do 
        pcall(function() 
            if Settings.TweenFruit then 
                local nearest=GetNearestFruit() local hrp=Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
                if nearest and hrp then 
                    local pos=Pos(nearest) if pos then local dist=(pos-hrp.Position).Magnitude 
                        if dist>5 then
                            if nearest ~= lastTweenTarget or (fruitTween and fruitTween.PlaybackState ~= Enum.PlaybackState.Playing) then
                                if fruitTween then fruitTween:Cancel() end local speed=250 local timeToTween=dist/speed local targetCFrame=CFrame.new(pos+Vector3.new(0,1.5,0)) fruitTween=TweenService:Create(hrp,TweenInfo.new(timeToTween,Enum.EasingStyle.Linear),{CFrame=targetCFrame}) fruitTween:Play() lastTweenTarget=nearest end
                        else if fruitTween then fruitTween:Cancel() fruitTween=nil end lastTweenTarget=nil end 
                    end 
                else if fruitTween then fruitTween:Cancel() fruitTween=nil end lastTweenTarget=nil end 
            else if fruitTween then fruitTween:Cancel() fruitTween=nil end lastTweenTarget=nil end 
        end) 
    end 
end)

-- [[ AUTO STORE - EXTORIUS LOGIC (BRUTEFORCE + UNEQUIP) ]]
local StoreBlacklist={}
local isStoring = false
task.spawn(function() 
    while task.wait(1) do 
        if Settings.AutoStoreFruit and not isStoring then 
            isStoring = true
            pcall(function() 
                local character = Me.Character if not character then isStoring = false return end 
                local fruitTool = nil
                if Me.Backpack then for _, v in pairs(Me.Backpack:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then fruitTool = v break end end end
                if not fruitTool then for _, v in pairs(character:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then fruitTool = v break end end end

                if fruitTool then
                    local hum = character:FindFirstChild("Humanoid")
                    if hum and fruitTool.Parent ~= character then hum:EquipTool(fruitTool) task.wait(0.5) end
                    local fruitName = fruitTool.Name
                    local fruitVal = fruitTool:FindFirstChild("Fruit")
                    if fruitVal and fruitVal:IsA("StringValue") and fruitVal.Value ~= "" then fruitName = fruitVal.Value else fruitName = string.gsub(fruitTool.Name, " Fruit", "") fruitName = fruitName.."-"..fruitName end
                    local storeSuccess = false
                    for _ = 1, 10 do if storeSuccess then break end
                        local ok, result = pcall(function() return ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", fruitName, fruitTool) end)
                        if ok and result == true then storeSuccess = true end task.wait(0.1)
                    end
                    if not storeSuccess then table.insert(StoreBlacklist, fruitTool.Name) if hum then hum:EquipTool(nil) end end
                end
            end) isStoring = false
        end 
    end 
end)

-- [[ SENTINEL V9: KEYBOARD ONLY (NO MOUSE HIJACK) ]]
TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player == Me then
        task.spawn(function()
            for i = 1, 5 do
                VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game) task.wait(0.02) VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                task.wait(0.02)
            end
        end)
    end
end)

-- [[ HOP SERVER - V9 HYBRID GHOST (MOUSE SNAP + FIRESIGNAL) ]]
_G.NomexyHopper = true 
local UserInput = game:GetService("UserInputService")
local TopBarOffset = game:GetService("GuiService"):GetGuiInset().Y

task.spawn(function()
    while _G.NomexyHopper do
        task.wait(2)
        
        if Settings.AutoHop then
            local fruitCount = 0
            for f, _ in pairs(Data) do if f and f.Parent and f.Parent == Workspace then fruitCount = fruitCount + 1 end end
            if Me.Backpack then for _, tool in pairs(Me.Backpack:GetChildren()) do if tool:IsA("Tool") and string.find(tool.Name, "Fruit") and not table.find(StoreBlacklist, tool.Name) then fruitCount = fruitCount + 1 end end end
            if Me.Character then for _, tool in pairs(Me.Character:GetChildren()) do if tool:IsA("Tool") and string.find(tool.Name, "Fruit") and not table.find(StoreBlacklist, tool.Name) then fruitCount = fruitCount + 1 end end end
            
            if fruitCount > 0 then continue end

            local hopOk, hopErr = pcall(function()
                local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                
                -- STEP 1: BUKA UI PAKAI FIRESIGNAL + POSITION HACK
                if not (browser and browser.Enabled) then
                    local openBtn = Me.PlayerGui:FindFirstChild("ServerBrowserButton", true)
                    if openBtn then
                        local origPos = openBtn.Position
                        local origAnchor = openBtn.AnchorPoint
                        openBtn.AnchorPoint = Vector2.new(0.5, 0.5)
                        openBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
                        task.wait(0.1)
                        
                        -- Tembak semua sinyal klik
                        for _, conn in pairs(getconnections(openBtn.Activated)) do conn:Fire() end
                        for _, conn in pairs(getconnections(openBtn.MouseButton1Click)) do conn:Fire() end
                        
                        openBtn.Position = origPos
                        openBtn.AnchorPoint = origAnchor
                        task.wait(2.5)
                    end
                end

                browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                local fakeScroll = browser and browser:FindFirstChild("FakeScroll", true)
                local insideFrame = fakeScroll and fakeScroll:FindFirstChild("Inside", true)

                if fakeScroll and insideFrame then
                    local fsP, fsS = fakeScroll.AbsolutePosition, fakeScroll.AbsoluteSize
                    local scrollCenterX = fsP.X + (fsS.X / 2)
                    local scrollCenterY = fsP.Y + (fsS.Y / 2) + TopBarOffset

                    -- STEP 2: MOUSE SNAP (Simpen posisi mouse lu, lompat ke UI, scroll, balikin)
                    local myMouseX, myMouseY = UserInput:GetMouseLocation().X, UserInput:GetMouseLocation().Y
                    
                    -- Lompatin mouse ke tengah scroll
                    VIM:SendMouseMoveEvent(scrollCenterX, scrollCenterY, game) task.wait(0.05)
                    
                    -- Scroll 15x (Super cepat)
                    for i = 1, 15 do
                        VIM:SendMouseWheelEvent(scrollCenterX, scrollCenterY, false, game)
                        if i % 5 == 0 then task.wait() end 
                    end
                    
                    -- Balikin mouse ke posisi lu main (biar kamera ga nge-zoom)
                    VIM:SendMouseMoveEvent(myMouseX, myMouseY, game)
                    task.wait(1.5) -- Nunggu UI render

                    -- STEP 3: SPAM KLIK JOIN PAKAI FIRESIGNAL
                    local clickedCount = 0
                    for _, template in pairs(insideFrame:GetChildren()) do
                        if template.Name == "Template" then
                            local joinBtn = template:FindFirstChild("Join")
                            if joinBtn and joinBtn:IsA("TextButton") and joinBtn.Text == "Join" and joinBtn.Visible then
                                local jP, jS = joinBtn.AbsolutePosition, joinBtn.AbsoluteSize
                                
                                if jP.Y > fsP.Y and (jP.Y + jS.Y) < (fsP.Y + fsS.Y) then
                                    -- Tembak sinyal klik
                                    for _, conn in pairs(getconnections(joinBtn.Activated)) do conn:Fire() end
                                    for _, conn in pairs(getconnections(joinBtn.MouseButton1Click)) do conn:Fire() end
                                    clickedCount = clickedCount + 1
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                    
                    if clickedCount > 0 then
                        warn("[HOP V9] Firesignal " .. clickedCount .. " server! (Mouse lu aman)")
                    end
                end
            end)
        end
    end
end)

function _G.Cat.HopServer()
    _G.NomexyHopper = true
end

function _G.Cat.GetFruitsList()
    local names = {}
    for f, _ in pairs(Data) do if f and f.Parent then table.insert(names, f.Name) end end
    return names
end