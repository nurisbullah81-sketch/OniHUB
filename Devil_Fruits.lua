local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Me = _G.Cat.Player
local Settings = _G.Cat.Settings

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
        -- Blox Fruits buah bisa bertipe Tool atau Model
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

-- [TWEEN]
local fruitTween=nil
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
    while task.wait(0.3) do 
        pcall(function() 
            if Settings.TweenFruit then 
                local nearest=GetNearestFruit() 
                local hrp=Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
                if nearest and hrp then 
                    local pos=Pos(nearest) 
                    if pos then 
                        local dist=(pos-hrp.Position).Magnitude 
                        if dist>5 then 
                            if fruitTween then fruitTween:Cancel() end 
                            local speed=250 
                            local timeToTween=dist/speed 
                            local targetCFrame=CFrame.new(pos+Vector3.new(0,1.5,0)) 
                            fruitTween=TweenService:Create(hrp,TweenInfo.new(timeToTween,Enum.EasingStyle.Linear),{CFrame=targetCFrame}) 
                            fruitTween:Play() 
                        else 
                            if fruitTween then fruitTween:Cancel() fruitTween=nil end 
                        end 
                    end 
                else 
                    if fruitTween then fruitTween:Cancel() fruitTween=nil end 
                end 
            else 
                if fruitTween then fruitTween:Cancel() fruitTween=nil end 
            end 
        end) 
    end 
end)

-- [AUTO STORE + INVENTORY PENUH = HOP]
local StoreBlacklist={}
local function GetFruitRealName(tool) 
    if not tool then return nil end 
    local fruitVal=tool:FindFirstChild("Fruit") 
    if fruitVal and fruitVal:IsA("StringValue") then return fruitVal.Value end 
    return tool.Name 
end

task.spawn(function() 
    while task.wait(0.5) do 
        if Settings.AutoStoreFruit then 
            pcall(function() 
                local remote=ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") 
                if not remote then return end 
                local function TryStore(tool) 
                    if tool:IsA("Tool") and tool:FindFirstChild("Fruit") then 
                        if not table.find(StoreBlacklist,tool.Name) then 
                            -- BF Sering musti di equip dulu biar ke store
                            if tool.Parent == Me.Backpack and Me.Character and Me.Character:FindFirstChild("Humanoid") then
                                Me.Character.Humanoid:EquipTool(tool)
                                task.wait(0.3)
                            end
                            
                            local realName=GetFruitRealName(tool) 
                            local success=remote:InvokeServer("StoreFruit",realName) 
                            if success == true then
                                warn("[CatHUB] [STORE] Berhasil simpan: " .. realName)
                            else
                                -- KALO GAGAL (INVENTORY PENUH / DUPLICATE)
                                warn("[CatHUB] [STORE] Gagal simpan (Inventory Penuh/Duplikat?): " .. realName)
                                table.insert(StoreBlacklist,tool.Name) 
                                if Settings.AutoHop then 
                                    task.wait(1) 
                                    _G.Cat.HopServer() 
                                end 
                            end
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

-- [MACRO HOPPER - THUNDER STYLE (BYPASS DELTA SEA 2/3)]
local isHopping = false
local VIM = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local function clickElement(element)
    local pos = element.AbsolutePosition
    local size = element.AbsoluteSize
    local x = pos.X + size.X / 2
    local y = pos.Y + size.Y / 2
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(0.1)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
    task.wait(0.5)
end

local function findAndClickText(textToFind)
    local RobloxGui = CoreGui:FindFirstChild("RobloxGui")
    if not RobloxGui then return false end
    
    for _, obj in ipairs(RobloxGui:GetDescendants()) do
        if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Visible and obj.AbsoluteSize.X > 5 then
            local txt = ""
            pcall(function() txt = obj.Text or "" end)
            if string.find(string.lower(txt), string.lower(textToFind)) then
                clickElement(obj)
                return true
            end
        end
    end
    return false
end

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    warn("[CatHUB] [MACRO] Mulai Macro Hop (Thunder Style)...")
    
    -- 1. Buka Menu ESC
    VIM:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
    VIM:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
    task.wait(1.5)
    
    -- 2. Klik Tab "Servers" / "Server"
    if findAndClickText("server") then
        warn("[CatHUB] [MACRO] Tab Servers diklik.")
        task.wait(1.5)
        
        -- 3. Cari daftar server dan klik server pertama (Tebalan frame)
        local RobloxGui = CoreGui:FindFirstChild("RobloxGui")
        local clickedServer = false
        if RobloxGui then
            for _, obj in ipairs(RobloxGui:GetDescendants()) do
                if obj:IsA("ScrollingFrame") and string.find(string.lower(obj.Name), "server") then
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("Frame") and child.Visible then
                            warn("[CatHUB] [MACRO] Klik server pertama di list...")
                            clickElement(child)
                            clickedServer = true
                            break
                        end
                    end
                    if clickedServer then break end
                end
            end
        end
        
        task.wait(1)
        
        -- 4. Klik Tombol "Join" / "Join Server"
        if findAndClickText("join") then
            warn("[CatHUB] [MACRO] Tombol Join diklik! Menunggu teleport...")
            task.wait(5)
        else
            warn("[CatHUB] [MACRO] Gagal nemu tombol Join.")
        end
    else
        warn("[CatHUB] [MACRO] Gagal nemu tab Server di menu.")
    end
    
    -- 5. Tutup menu kalau masih kebuka
    VIM:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
    VIM:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
    
    task.wait(10)
    isHopping = false
end

-- CEK BUAH DI MAP
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
                    warn("[CatHUB] [HOP] Ga ada buah di map. Auto Macro Hop nyala...")
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