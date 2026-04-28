local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")
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

-- [TWEEN SMOOTH]
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
    while task.wait(1) do 
        pcall(function() 
            if Settings.TweenFruit then 
                local nearest=GetNearestFruit() 
                local hrp=Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
                if nearest and hrp then 
                    local pos=Pos(nearest) 
                    if pos then 
                        local dist=(pos-hrp.Position).Magnitude 
                        if dist>5 then
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

-- [[ AUTO STORE - EXTORIUS LOGIC (BRUTEFORCE + UNEQUIP) ]]
local StoreBlacklist={}
local isStoring = false

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
                    for _ = 1, 10 do
                        if storeSuccess then break end
                        local ok, result = pcall(function()
                            return ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", fruitName, fruitTool)
                        end)
                        
                        if ok and result == true then
                            storeSuccess = true
                        end
                        task.wait(0.1)
                    end
                    
                    if not storeSuccess then
                        table.insert(StoreBlacklist, fruitTool.Name) 
                        -- PENTING: Turunin buah biar Context Menu (Eat/Drop) ga muncul & ga ganggu Hopper
                        if hum then hum:EquipTool(nil) end
                    end
                end
            end) 
            isStoring = false
        end 
    end 
end)

-- [[ SENTINEL V14: HANYA ENTER (JANGAN ESCAPE) ]]
-- Kalau kena 772, tekan Enter buat tutup popup. Jangan Escape karena nutup UI Server juga!
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

-- [[ HOP SERVER - V14 STABLE GEMINI LOGIC ]]
_G.NomexyHopper = true 
_G.DeepDiveDepth = 250 
_G.MinServerLoad = 25  

task.spawn(function()
    while _G.NomexyHopper do
        task.wait(1)
        
        if Settings.AutoHop then
            local fruitCount = 0
            
            -- 1. Cek Map
            for f, _ in pairs(Data) do
                if f and f.Parent and f.Parent == Workspace then fruitCount = fruitCount + 1 end
            end
            -- 2. Cek Tangan & Backpack (Abaikan yang udah di Blacklist / Penuh)
            if Me.Backpack then 
                for _, tool in pairs(Me.Backpack:GetChildren()) do 
                    if tool:IsA("Tool") and string.find(tool.Name, "Fruit") and not table.find(StoreBlacklist, tool.Name) then 
                        fruitCount = fruitCount + 1 
                    end 
                end 
            end
            if Me.Character then 
                for _, tool in pairs(Me.Character:GetChildren()) do 
                    if tool:IsA("Tool") and string.find(tool.Name, "Fruit") and not table.find(StoreBlacklist, tool.Name) then 
                        fruitCount = fruitCount + 1 
                    end 
                end 
            end
            
            if fruitCount > 0 then
                continue -- Masih ada buah, nunggu
            end

            -- KALO GAADA BUAH, GAS ENGINE GEMINI!
            pcall(function()
                warn("Nomexy Engine: Ga ada buah! Menyiapkan amunisi...")

                local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                if not (browser and browser.Enabled) then
                    local openBtn = Me.PlayerGui:FindFirstChild("ServerBrowserButton", true)
                    if openBtn then
                        local p, s = openBtn.AbsolutePosition, openBtn.AbsoluteSize
                        VIM:SendMouseButtonEvent(p.X + (s.X/2), p.Y + (s.Y/2) + 58, 0, true, game, 0)
                        task.wait(0.1)
                        VIM:SendMouseButtonEvent(p.X + (s.X/2), p.Y + (s.Y/2) + 58, 0, false, game, 0)
                    end
                end

                local listArea
                local loadTimeout = 0
                
                repeat 
                    task.wait(0.5)
                    loadTimeout = loadTimeout + 1
                    browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                    listArea = browser and browser:FindFirstChild("Inside", true)
                    
                    local currentLoad = 0
                    if listArea then
                        for _, v in pairs(listArea:GetChildren()) do
                            if v:FindFirstChild("Join") then currentLoad = currentLoad + 1 end
                        end
                    end
                until (currentLoad >= _G.MinServerLoad) or loadTimeout > 20

                if listArea then
                    local scrollFrame = browser:FindFirstChild("FakeScroll", true)
                    local sP, sS = scrollFrame.AbsolutePosition, scrollFrame.AbsoluteSize
                    local cX, cY = sP.X + (sS.X / 2), sP.Y + (sS.Y / 2) + 58-- [[ HOP SERVER - KOMUNITAS LOGIC (CLEAN API + ANTI 772) ]]
-- Logika ini jauh lebih stabil karena pakai API excludeFullGames=true.
-- PERINGATAN: Kalau di Sea 2/3 Xeno/Delta lu kena 773, itu limitasi executor, bukan salah kode.

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local ServerHopConfig = {
    MaxStore = 3600, -- Simpan history server selama 1 jam
    CheckInterval = 2, -- Jeda antar cek API
    TeleportInterval = 1 -- Jeda antar teleport
}

function _G.Cat.HopServer()
    local PlaceId = game.PlaceId
    local JobId = game.JobId

    local RootFolder = "CatHUB_ServerHop"
    local StorageFile = RootFolder .. "/" .. tostring(PlaceId) .. ".json"
    local Data = {
        Start = tick(),
        Jobs = {},
    }

    -- Load history biar ga balik ke server yang sama
    if not isfolder(RootFolder) then makefolder(RootFolder) end
    if isfile(StorageFile) then
        local Success, NewData = pcall(function() return HttpService:JSONDecode(readfile(StorageFile)) end)
        if Success and tick() - NewData.Start < ServerHopConfig.MaxStore then
            Data = NewData
        end
    end

    -- Masukin server sekarang ke history
    if not table.find(Data.Jobs, JobId) then
        table.insert(Data.Jobs, JobId)
    end
    writefile(StorageFile, HttpService:JSONEncode(Data))

    local Servers = {}
    local Cursor = ""

    -- CARI SERVER VIA API (excludeFullGames=true biar ga kena 772)
    warn("[CatHUB] [HOP] Mencari server yang tidak penuh...")
    while Cursor and #Servers <= 0 and task.wait(ServerHopConfig.CheckInterval) do
        local RequestFunc = request or (syn and syn.request)
        if not RequestFunc then
            warn("[CatHUB] [HOP] Executor ga support request. Gagal cari server.")
            break
        end

        local Success, Response = pcall(function()
            return RequestFunc({
                Url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true&cursor=" .. Cursor,
                Method = "GET",
            })
        end)

        if not Success or not Response or not Response.Body then continue end
        
        local BodySuccess, Body = pcall(function() return HttpService:JSONDecode(Response.Body) end)

        if not BodySuccess or not Body or not Body.data then continue end

        for _, Server in pairs(Body.data) do
            if typeof(Server) == "table" and Server.id and tonumber(Server.playing) and tonumber(Server.maxPlayers) then
                -- Cuma masukin server yang ada orang & belum dikunjungi
                if Server.playing > 0 and Server.playing < Server.maxPlayers and not table.find(Data.Jobs, Server.id) then
                    table.insert(Servers, 1, Server.id)
                end
            end
        end

        if Body.nextPageCursor then
            Cursor = Body.nextPageCursor
        else
            Cursor = nil
        end
    end

    -- TELEPORT KE SERVER YANG KETEMU
    while #Servers > 0 and task.wait(ServerHopConfig.TeleportInterval) do
        local Server = Servers[math.random(1, #Servers)]
        warn("[CatHUB] [HOP] Gas Teleport ke server: " .. Server)
        TeleportService:TeleportToPlaceInstance(PlaceId, Server, Me)
    end
end

-- Sentinel tetap dipertahankan buat nutup popup 772 kalau tetep kejadian
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

function _G.Cat.GetFruitsList()
    local names = {}
    for f, _ in pairs(Data) do if f and f.Parent then table.insert(names, f.Name) end end
    return names
end