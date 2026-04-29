local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local Me = _G.Cat.Player
local Settings = _G.Cat.Settings

local Data = {}
local Mem = {}
local FC = 0
local SKIP = 10

-- ==========================================
-- 1. GUARDIAN (DIBUNGUS PCALL BIAR GA CRASH)
-- ==========================================
pcall(function()
    GuiService.ErrorMessageChanged:Connect(function()
        if Settings.AutoHop then
            pcall(function() GuiService:ClearError() end)
        end
    end)
end)

pcall(function()
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

-- ==========================================
-- 2. ESP SYSTEM (ORIGINAL)
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
-- 3. TWEEN DENGAN OVERSHOOT
-- ==========================================
local isTweening = false
local currentTarget = nil

local function GetNearestFruit()
    local closest, minDist = nil, math.huge
    local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local heldFruit = nil
    if Me.Character then
        for _, tool in pairs(Me.Character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Fruit") then
                heldFruit = tool
                break
            end
        end
    end
    
    for f, _ in pairs(Data) do
        if f and f.Parent and f ~= heldFruit then
            local p = Pos(f)
            if p then
                local dist = (p - hrp.Position).Magnitude
                if dist < minDist then
                    closest, minDist = f, dist
                end
            end
        end
    end
    return closest, minDist
end

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not Settings.TweenFruit then
                isTweening = false
                currentTarget = nil
                return
            end
            
            local fruit, dist = GetNearestFruit()
            
            if fruit and dist > 3 then
                currentTarget = fruit
                isTweening = true
            elseif not fruit or dist <= 3 then
                if dist and dist <= 3 then
                    local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart")
                    local fruitPos = Pos(fruit)
                    if hrp and fruitPos then
                        local dir = (fruitPos - hrp.Position).Unit
                        hrp.CFrame = CFrame.new(fruitPos + (dir * 3))
                    end
                end
                isTweening = false
                currentTarget = nil
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if not isTweening or not currentTarget or not currentTarget.Parent then
        isTweening = false
        currentTarget = nil
        return
    end
    
    pcall(function()
        local char = Me.Character
        if not char then isTweening = false return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then isTweening = false return end
        
        local fruitPos = Pos(currentTarget)
        if not fruitPos then
            isTweening = false
            currentTarget = nil
            return
        end
        
        local currentPos = hrp.Position
        local dist = (fruitPos - currentPos).Magnitude
        
        if dist < 10 then
            local dir = (fruitPos - currentPos).Unit
            hrp.CFrame = CFrame.new(fruitPos + (dir * 3))
            hrp.Velocity = Vector3.zero
            isTweening = false
            currentTarget = nil
            return
        end
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        
        hrp.Velocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
        
        local speed = 350
        local moveAmount = math.min(speed * dt, dist)
        local direction = (fruitPos - currentPos).Unit
        local newPos = currentPos + direction * moveAmount
        local targetCFrame = CFrame.new(newPos, fruitPos)
        hrp.CFrame = CFrame.new(newPos) * CFrame.Angles(0, targetCFrame.Yaw, 0)
    end)
end)

-- ==========================================
-- 4. AUTO STORE (ORIGINAL)
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
-- 5. HOP SERVER (ORIGINAL + DEBUG)
-- ==========================================
local isHopping = false

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    task.spawn(function()
        while Settings.AutoHop do
            pcall(function()
                local char = Me.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if not char or not char:FindFirstChild("HumanoidRootPart") or (hum and hum.Health <= 0) then
                    task.wait(1)
                    return
                end

                local fruitCount = 0
                for f, _ in pairs(Data) do
                    if f and f.Parent then
                        local isHeld = false
                        if Me.Character then
                            for _, tool in pairs(Me.Character:GetChildren()) do
                                if tool == f then isHeld = true break end
                            end
                        end
                        if not isHeld then fruitCount = fruitCount + 1 end
                    end
                end

                warn("[CatHUB] Buah di map: "..fruitCount)

                if fruitCount > 0 then
                    local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                    if browser and browser.Enabled then
                        browser.Enabled = false
                    end
                    task.wait(3)
                    return
                end

                warn("[CatHUB] Tidak ada buah. Memulai hop...")
                
                local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                if not browser or not browser.Enabled then
                    local openBtn = Me.PlayerGui:FindFirstChild("ServerBrowserButton", true)
                    if openBtn then
                        local p, s = openBtn.AbsolutePosition, openBtn.AbsoluteSize
                        local bX, bY = p.X + (s.X/2), p.Y + (s.Y/2) + 58
                        VIM:SendMouseButtonEvent(bX, bY, 0, true, game, 0)
                        task.wait(0.1)
                        VIM:SendMouseButtonEvent(bX, bY, 0, false, game, 0)
                    end
                end

                browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
                if not browser then task.wait(1) return end

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

                    if not scrollFrame then task.wait(1) return end

                    local buttons = {}
                    local sPos, sSize = scrollFrame.AbsolutePosition, scrollFrame.AbsoluteSize
                    for _, v in pairs(listArea:GetDescendants()) do
                        if v:IsA("TextButton") and v.Name == "Join" and v.Visible then 
                            if v.AbsolutePosition.Y > sPos.Y and v.AbsolutePosition.Y < (sPos.Y + sSize.Y - 30) then
                                table.insert(buttons, v)
                            end
                        end
                    end

                    warn("[CatHUB] Ditemukan "..#buttons.." tombol Join")

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
            end)
            task.wait(1)
        end
        isHopping = false
    end)
end

task.spawn(function()
    while task.wait(5) do
        warn("[CatHUB] Hop Loop Check - AutoHop: "..tostring(Settings.AutoHop))
        if Settings.AutoHop then
            _G.Cat.HopServer()
        end
    end
end)

function _G.Cat.GetFruitsList()
    local names = {}
    for f, _ in pairs(Data) do if f and f.Parent then table.insert(names, f.Name) end end
    return names
end