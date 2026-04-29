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
-- 2. ESP SYSTEM (ORIGINAL - JANGAN DIUTAK ATIK)
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
-- 3. TWEEN SMOOTH (ORIGINAL - JANGAN DIUTAK ATIK)
-- ==========================================
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

-- ==========================================
-- 4. AUTO STORE - EXTORIUS LOGIC (ORIGINAL - JANGAN DIUTAK ATIK)
-- ==========================================
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
                        if hum then hum:EquipTool(nil) end
                    end
                end
            end) 
            isStoring = false
        end 
    end 
end)

-- ==========================================
-- 5. HOP SERVER - SOVEREIGN V26 (ZERO BLINK)
-- ==========================================
local isHopping = false

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    task.spawn(function()
        warn("[CatHUB] [HOP] Menjalankan Sovereign V26...")
        
        while Settings.AutoHop do
            local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            
            -- AUTO-OPEN UI
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
                
                -- INVISIBLE SCROLL (ANTI-ZOOM)
                if dummyScroll and dummyScroll:IsA("ScrollingFrame") then
                    dummyScroll.CanvasPosition = Vector2.new(0, math.random(500, 2500))
                    task.wait(1) 
                end

                if not scrollFrame then task.wait(1) continue end

                -- TARGET ACQUISITION
                local buttons = {}
                local sPos, sSize = scrollFrame.AbsolutePosition, scrollFrame.AbsoluteSize
                for _, v in pairs(listArea:GetDescendants()) do
                    if v:IsA("TextButton") and v.Name == "Join" and v.Visible then 
                        if v.AbsolutePosition.Y > sPos.Y and v.AbsolutePosition.Y < (sPos.Y + sSize.Y - 30) then
                            table.insert(buttons, v)
                        end
                    end
                end

                -- STRIKE & FAILSAFE
                for _, target in pairs(buttons) do
                    if not Settings.AutoHop then break end
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
        
        -- Tutup UI kalau loop selesai/berhenti
        local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
        if browser then browser.Enabled = false end
        isHopping = false
    end)
end

-- CEK BUAH UNTUK HOP (Gue balikin loop ini karena di kode lu barusan ilang)
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
                    _G.Cat.HopServer()
                else
                    -- Kalau ada buah, hentikan loop V26 dan tutup UI
                    isHopping = false
                    local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                    if browser then browser.Enabled = false end
                end
            end)
        else
            -- Kalau AutoHop dimatiin, pastiin UI ketutup
            isHopping = false
            local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            if browser then browser.Enabled = false end
        end
    end
end)

function _G.Cat.GetFruitsList()
    local names = {}
    for f, _ in pairs(Data) do if f and f.Parent then table.insert(names, f.Name) end end
    return names
end