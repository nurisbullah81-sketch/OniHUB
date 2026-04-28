local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
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

-- [[ AUTO STORE - NOMEXY LOGIC (DETAILED LOG) ]]
local StoreBlacklist={}
local isStoring = false

task.spawn(function() 
    while task.wait(1) do 
        if Settings.AutoStoreFruit and not isStoring then 
            isStoring = true
            pcall(function() 
                local character = Me.Character
                if not character then isStoring = false return end 
                
                local fruit = nil
                if Me.Backpack then
                    for _, v in pairs(Me.Backpack:GetChildren()) do
                        if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then
                            fruit = v
                            break
                        end
                    end
                end
                
                if not fruit then
                    for _, v in pairs(character:GetChildren()) do
                        if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then
                            fruit = v
                            break
                        end
                    end
                end

                if fruit then
                    if fruit.Parent ~= character then
                        local hum = character:FindFirstChild("Humanoid")
                        if hum then
                            hum:EquipTool(fruit)
                            task.wait(0.3)
                        end
                    end
                    
                    local success, result = pcall(function()
                        return ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", fruit.Name)
                    end)
                    
                    if success and result == true then
                        warn("[CatHUB] " .. fruit.Name .. " berhasil disimpan!")
                    else
                        -- Print persis apa yang server jawab biar kita tau kenapa gagal
                        warn("[CatHUB] Gagal simpan " .. fruit.Name .. ". Respon Server: " .. tostring(result) .. ". Auto Blacklist & Hop!")
                        table.insert(StoreBlacklist, fruit.Name) 
                    end
                end
            end) 
            isStoring = false
        end 
    end 
end)

-- [[ HOP SERVER - PREMIUM STABLE V2 (NO ZOOM, NO STUCK) ]]
_G.NomexyHopper = true 
_G.DeepDiveDepth = 150 -- Cukup 150, ntar kebanyakan malah masuk server mati 0 pemain

task.spawn(function()
    while _G.NomexyHopper do
        task.wait(2) -- Jeda antar siklus biar ga makan CPU
        
        if Settings.AutoHop then
            local fruitCount = 0
            
            -- 1. Cek Map
            for f, _ in pairs(Data) do
                if f and f.Parent and f.Parent == Workspace then fruitCount = fruitCount + 1 end
            end
            -- 2. Cek Tangan & Backpack (Abaikan yang di Blacklist / Penuh)
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
                continue -- Masih ada buah, diam
            end

            -- KALO GAADA BUAH, GAS!
            local hopOk, hopErr = pcall(function()
                -- STEP 1: Tutup popup sisa siklus sebelumnya biar bersih
                local coreGui = game:GetService("CoreGui"):FindFirstChild("ErrorPrompt", true)
                local playerGui = Me.PlayerGui:FindFirstChild("ErrorPrompt", true) or Me.PlayerGui:FindFirstChild("MessagePrompt", true)
                if (coreGui and coreGui.Visible) or (playerGui and playerGui.Visible) then
                    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait(0.02)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                end

                warn("[HOP V2] Engine Nyala! Mencari server...")
                
                -- STEP 2: Buka UI
                local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                if not (browser and browser.Enabled) then
                    local openBtn = Me.PlayerGui:FindFirstChild("ServerBrowserButton", true)
                    if openBtn then
                        local p, s = openBtn.AbsolutePosition, openBtn.AbsoluteSize
                        VIM:SendMouseButtonEvent(p.X + (s.X/2), p.Y + (s.Y/2) + 58, 0, true, game, 0)
                        task.wait(0.1)
                        VIM:SendMouseButtonEvent(p.X + (s.X/2), p.Y + (s.Y/2) + 58, 0, false, game, 0)
                        task.wait(2.5) -- Kasih waktu UI loading
                    end
                end

                -- STEP 3: Cari Area Scroll & Lock Focus (RAHASIA ANTI ZOOM)
                browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                local scrollFrame = browser and browser:FindFirstChild("FakeScroll", true)
                
                if scrollFrame then
                    local sP, sS = scrollFrame.AbsolutePosition, scrollFrame.AbsoluteSize
                    -- Hitung tengah Scroll Frame
                    local cX = sP.X + (sS.X / 2)
                    local cY = sP.Y + (sS.Y / 2) + 58

                    -- PAKSA FOCUS: Hover, Klik Tahan, Lepas. Ini lock mouse ke UI.
                    VIM:SendMouseMoveEvent(cX, cY, game)
                    task.wait(0.2)
                    VIM:SendMouseButtonEvent(cX, cY, 0, true, game, 0)
                    task.wait(0.1)
                    VIM:SendMouseButtonEvent(cX, cY, 0, false, game, 0)
                    task.wait(0.5) -- Kasih waktu Roblox ngeresepi fokus

                    -- STEP 4: Deep Scroll (Mouse dikunci di area UI)
                    warn("[HOP V2] Scrolling... (Mouse Locked)")
                    for i = 1, _G.DeepDiveDepth do
                        -- Setiap scroll, pastiin mouse tetep di area UI
                        VIM:SendMouseMoveEvent(cX, cY, game)
                        VIM:SendMouseWheelEvent(cX, cY, false, game)
                        if i % 30 == 0 then task.wait() end 
                    end
                    task.wait(1.5) -- Nunggu list render tombol Join

                    -- STEP 5: Snipe SEMUA tombol Join yang keliatan
                    local insideFrame = browser:FindFirstChild("Inside", true)
                    if insideFrame then
                        local targets = {}
                        for _, v in pairs(insideFrame:GetDescendants()) do
                            if v:IsA("TextButton") and v.Text == "Join" and v.Visible then
                                -- Pastikan tombol ada di area scroll yang keliatan
                                if v.AbsolutePosition.Y > sP.Y and v.AbsolutePosition.Y < (sP.Y + sS.Y) then
                                    table.insert(targets, v)
                                end
                            end
                        end

                        if #targets > 0 then
                            warn("[HOP V2] Menemukan " .. #targets .. " server! Spam klik semua...")
                            for _, target in pairs(targets) do
                                local bp, bs = target.AbsolutePosition, target.AbsoluteSize
                                local tx = bp.X + (bs.X/2)
                                local ty = bp.Y + (bs.Y/2) + 58
                                
                                -- Klik 3x + Enter
                                for i = 1, 3 do
                                    VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                                    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                    task.wait(0.02)
                                    VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                                    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                end
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end)

            if not hopOk then
                warn("[HOP V2] Error tertangkap: " .. tostring(hopErr))
            end
        end
    end
end)

-- [[ SENTINEL V2: HYPER AGGRESSIVE POPUP KILLER (ANTI-STUCK) ]]
task.spawn(function()
    while true do
        task.wait(0.1) -- Cek super cepat
        pcall(function()
            local coreGui = game:GetService("CoreGui"):FindFirstChild("ErrorPrompt", true)
            local playerGui = Me.PlayerGui:FindFirstChild("ErrorPrompt", true) or Me.PlayerGui:FindFirstChild("MessagePrompt", true)
            
            if (coreGui and coreGui.Visible) or (playerGui and playerGui.Visible) then
                -- Hajar Enter & Klik tengah layar berkali-kali
                for i = 1, 3 do
                    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait(0.01)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    
                    local vp = workspace.CurrentCamera.ViewportSize
                    VIM:SendMouseButtonEvent(vp.X/2, vp.Y/2, 0, true, game, 0)
                    task.wait(0.01)
                    VIM:SendMouseButtonEvent(vp.X/2, vp.Y/2, 0, false, game, 0)
                end
            end
        end)
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