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

-- [HOP SERVER - TARGET 2-10 PEMAIN, DITOLAK 0-1 PEMAIN]
local isHopping = false

local Proxies = {
    "https://games.roblox.com",
    "https://games.api.hyra.io",
    "https://roproxy.com"
}

local Headers = {
    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    ["Content-Type"] = "application/json",
    ["Accept"] = "application/json"
}

local function FetchUrl(url)
    local s, r = pcall(function() return http_request({Url = url, Method = "GET", Headers = Headers}).Body end)
    if s and type(r) == "string" and #r > 0 then return r end
    s, r = pcall(function() return request({Url = url, Method = "GET", Headers = Headers}).Body end)
    if s and type(r) == "string" and #r > 0 then return r end
    s, r = pcall(function() return game:HttpGet(url, true) end)
    if s and type(r) == "string" and #r > 0 then return r end
    return nil
end

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    pcall(function()
        local PlaceID = game.PlaceId
        local JobID = tostring(game.JobId)
        
        local targetServers = {}
        local fallbackServers = {}
        
        warn("[CatHUB] [HOP] Mulai cari server (Target: 2-10 pemain)...")
        
        for _, proxy in pairs(Proxies) do
            local ApiUrl = proxy .. "/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
            
            local body = FetchUrl(ApiUrl)
            
            if not body then continue end
            if body:find("<!DOCTYPE") or body:find("<html") or body:find("cloudflare") then continue end
            if not body:find('^{') then continue end
            
            local success, result = pcall(function() return HttpService:JSONDecode(body) end)
            if not success then continue end
            if type(result) ~= "table" or not result.data then continue end
            
            for i, v in pairs(result.data) do
                if type(v) == "table" and v.playing and v.maxPlayers and v.id then
                    if tostring(v.id) ~= JobID then
                        -- PRIORITAS 1: 2 sampai 10 pemain (Sweet spot)
                        if v.playing >= 2 and v.playing <= 10 then
                            table.insert(targetServers, v)
                        -- PRIORITAS 2 (FALLBACK): 11 sampai maxPlayers (biar ga kesepi)
                        elseif v.playing >= 11 and v.playing < v.maxPlayers then
                            table.insert(fallbackServers, v)
                        end
                        -- 0 ATAU 1 PEMAIN DITOLAK KERAS, GA USAH MASUK LIST
                    end
                end
            end
            
            if #targetServers > 0 then break end
        end
        
        local chosen = nil
        local chosenType = ""
        
        if #targetServers > 0 then
            for i = #targetServers, 2, -1 do
                local j = math.random(1, i)
                targetServers[i], targetServers[j] = targetServers[j], targetServers[i]
            end
            chosen = targetServers[1]
            chosenType = "TARGET (2-10 pemain)"
        elseif #fallbackServers > 0 then
            for i = #fallbackServers, 2, -1 do
                local j = math.random(1, i)
                fallbackServers[i], fallbackServers[j] = fallbackServers[j], fallbackServers[i]
            end
            chosen = fallbackServers[1]
            chosenType = "FALLBACK (>10 pemain)"
        end
        
        if chosen then
            warn("[CatHUB] [HOP] Gas Teleport! Ke server " .. tostring(chosen.id) .. " (" .. chosen.playing .. "/" .. chosen.maxPlayers .. ") [" .. chosenType .. "]")
            task.wait(2)
            TeleportService:TeleportToPlaceInstance(PlaceID, chosen.id, Me)
        else
            warn("[CatHUB] [HOP] Semua proxy gagal / Ga ada server dengan 2+ pemain. Fallback ke random...")
            task.wait(2)
            TeleportService:Teleport(PlaceID, Me)
        end
    end)
    
    task.wait(15)
    isHopping = false
end

-- CEK BUAH DI MAP: Kalau ada buah, DILARANG HOP. Kalau gaada baru hop.
task.spawn(function()
    while task.wait(10) do
        if Settings.AutoHop then
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
                    warn("[CatHUB] [HOP] Ga ada buah di map. Auto Hop nyala...")
                    _G.Cat.HopServer()
                else
                    warn("[CatHUB] [HOP] Masih ada " .. fruitCount .. " buah di map. Tetap disini.")
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