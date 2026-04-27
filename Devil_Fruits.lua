local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local Me = _G.Cat.Player
local Settings = _G.Cat.Settings
local TopBarOffset = GuiService:GetGuiInset().Y 

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

-- [TWEEN SMOOTH - FIXED GLITCH]
local fruitTween=nil
local lastTweenTarget=nil

local function GetNearestFruit() 
    local closest,minDist=nil,math.huge 
    local hrp=Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
    if not hrp then return nil end 
    for f,_ in pairs(Data) do 
        if f and f.Parent then 
            local p=Pos(f) 
            if p then 
                local dist=(p-hrp.Position).Magnitude 
                if dist<minDist then 
                    closest,minDist=f,dist 
                end 
            end 
        end 
    end 
    return closest 
end

task.spawn(function() 
    while task.wait(1) do -- Cek tiap 1 detik biar ga beban CPU, tapi tetep mulus
        pcall(function() 
            if Settings.TweenFruit then 
                local nearest=GetNearestFruit() 
                local hrp=Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
                if nearest and hrp then 
                    local pos=Pos(nearest) 
                    if pos then 
                        local dist=(pos-hrp.Position).Magnitude 
                        if dist>5 then
                            -- Hanya bikin tween baru kalau target berganti ATAU tween selesai
                            if nearest ~= lastTweenTarget or (fruitTween and fruitTween.PlaybackState ~= Enum.PlaybackState.Playing) then
                                if fruitTween then fruitTween:Cancel() end 
                                local speed=250 
                                local timeToTween=dist/speed 
                                local targetCFrame=CFrame.new(pos+Vector3.new(0,1.5,0)) 
                                fruitTween=TweenService:Create(hrp,TweenInfo.new(timeToTween,Enum.EasingStyle.Linear),{CFrame=targetCFrame}) 
                                fruitTween:Play()
                                lastTweenTarget = nearest
                            end
                        else 
                            if fruitTween then fruitTween:Cancel() fruitTween=nil end 
                            lastTweenTarget = nil
                        end 
                    end 
                else 
                    if fruitTween then fruitTween:Cancel() fruitTween=nil end 
                    lastTweenTarget = nil
                end 
            else 
                if fruitTween then fruitTween:Cancel() fruitTween=nil end 
                lastTweenTarget = nil
            end 
        end) 
    end 
end)

-- [AUTO STORE - FIXED SPAM DIALOGUE]
local StoreBlacklist={}
local function GetFruitRealName(tool) 
    if not tool then return nil end 
    local fruitVal=tool:FindFirstChild("Fruit") 
    if fruitVal and fruitVal:IsA("StringValue") then return fruitVal.Value end 
    return tool.Name 
end

task.spawn(function() 
    while task.wait(2) do -- Cek tiap 2 detik (ngga terlalu spam)
        if Settings.AutoStoreFruit then 
            pcall(function() 
                local remote=ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") 
                if not remote then return end 
                
                local function TryStore(tool) 
                    if tool:IsA("Tool") and tool:FindFirstChild("Fruit") and not table.find(StoreBlacklist, tool) then 
                        -- Equip dulu biar kebaca
                        if tool.Parent == Me.Backpack and Me.Character and Me.Character:FindFirstChild("Humanoid") then
                            Me.Character.Humanoid:EquipTool(tool)
                            task.wait(0.5)
                        end
                        
                        local realName=GetFruitRealName(tool) 
                        -- Pake pcall biar kalo server nolak, script ga error
                        local ok, result = pcall(function()
                            return remote:InvokeServer("StoreFruit", realName, tool) 
                        end)
                        
                        -- Kalau server nolak (return string / nil / false), langsung blacklist & hop!
                        if not ok or result ~= true then
                            warn("[CatHUB] Store gagal (Penuh/Error). Blacklist & Hop!")
                            table.insert(StoreBlacklist, tool) 
                            if Settings.AutoHop then task.wait(1) _G.Cat.HopServer() end 
                        else
                            warn("[CatHUB] Berhasil store: " .. realName)
                        end
                    end 
                end 
                
                local backpack=Me.Backpack 
                local char=Me.Character 
                if backpack then for _,tool in pairs(backpack:GetChildren()) do TryStore(tool) end end 
                if char then for _,tool in pairs(char:GetChildren()) do TryStore(tool) end end 
            end) 
        end 
    end 
end)

-- [HOP SERVER - NO SCROLL, NO CAMERA ZOOM]
local isHopping = false

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    pcall(function()
        local char = Me.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if not char or not char:FindFirstChild("HumanoidRootPart") or (hum and hum.Health <= 0) then
            isHopping = false
            return
        end

        warn("[CatHUB] [HOP] Mencari server via VIM (No Scroll)...")
        
        -- 1. Buka UI
        local openBtn = nil
        for _, obj in ipairs(Me.PlayerGui:GetDescendants()) do
            if obj.Name == "ServerBrowserButton" and (obj:IsA("TextButton") or obj:IsA("ImageButton")) then
                openBtn = obj
                break
            end
        end

        if openBtn then
            local op, os = openBtn.AbsolutePosition, openBtn.AbsoluteSize
            VIM:SendMouseButtonEvent(op.X + (os.X/2), op.Y + (os.Y/2) + TopBarOffset, 0, true, game, 0)
            task.wait(0.1)
            VIM:SendMouseButtonEvent(op.X + (os.X/2), op.Y + (os.Y/2) + TopBarOffset, 0, false, game, 0)
            task.wait(2) 
            
            -- 2. Cari tombol Join di halaman pertama (Tanpa Scroll)
            local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            local insideFrame = browser and browser:FindFirstChild("Inside", true)
            
            if insideFrame then
                local joinTarget = nil
                for _, v in pairs(insideFrame:GetDescendants()) do
                    if v:IsA("TextButton") and v.Text == "Join" and v.Visible and v.AbsolutePosition.Y > 0 then
                        joinTarget = v
                        break -- Ambil server paling atas
                    end
                end
                
                if joinTarget then
                    warn("[CatHUB] [HOP] Target Join ketemu! Tembak...")
                    local bp, bs = joinTarget.AbsolutePosition, joinTarget.AbsoluteSize
                    local tx, ty = bp.X + (bs.X/2), bp.Y + (bs.Y/2) + TopBarOffset
                    
                    -- Spam klik 3x
                    for i = 1, 3 do
                        VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                        task.wait(0.01)
                        VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                        task.wait(0.2)
                    end
                    warn("[CatHUB] [HOP] Ditembak! Menunggu teleport...")
                else
                    warn("[CatHUB] [HOP] Ga ada Join di halaman 1.")
                end
            end
        end
    end)
    
    task.wait(15)
    isHopping = false
end

-- SENTINEL: Auto close Error 773 biar ngga nyangkut
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local errPrompt = game.CoreGui:FindFirstChild("ErrorPrompt", true) 
            if errPrompt and errPrompt.Visible then
                VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end)
    end
end)

-- CEK BUAH DI MAP: Kalau ada buah, DILARANG HOP
task.spawn(function()
    while task.wait(10) do
        if Settings.AutoHop then
            pcall(function()
                if not game:IsLoaded() then return end
                local char = Me.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health <= 0 then return end
                
                local fruitCount = 0
                for f, _ in pairs(Data) do
                    if f and f.Parent and f.Parent == Workspace then 
                        fruitCount = fruitCount + 1 
                    else
                        Rem(f)
                    end
                end
                
                if fruitCount == 0 then
                    warn("[CatHUB] Ga ada buah. Auto Hop...")
                    _G.Cat.HopServer()
                end
            end)
        end
    end
end)

function _G.Cat.GetFruitsList()
    local names = {}
    for f, _ in pairs(Data) do if f and f.Parent then table.insert(names, f.Name) end end
    return names
end