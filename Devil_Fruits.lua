local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Me = _G.Cat.Player
local Settings = _G.Cat.Settings

local Data = {}
local Mem = {}
local FC = 0
local SKIP = 10 

local function Pos(f)
    if not f or not f.Parent then return nil end
    local ok, r = pcall(function()
        if f:IsA("Tool") then local h = f:FindFirstChild("Handle") if h then return h.Position end
        elseif f:IsA("Model") then if f.PrimaryPart then return f.PrimaryPart.Position end local root = f:FindFirstChild("HumanoidRootPart") or f:FindFirstChildWhichIsA("BasePart") if root then return root.Position end end
    end)
    return ok and r or nil
end

local function IsF(o)
    if not o or not o.Parent then return false end
    local ok, r = pcall(function()
        if o:IsA("Tool") and o:FindFirstChild("Fruit") then return true end
        return false
    end)
    return ok and r
end

local function Add(f)
    if not f or not f.Parent or Data[f] then return end
    pcall(function()
        local bb = Instance.new("BillboardGui", f)
        bb.Name = "CatESP"; bb.Size = UDim2.new(0, 150, 0, 20); bb.AlwaysOnTop = true; bb.StudsOffset = Vector3.new(0, 3, 0); bb.Enabled = false
        local txt = Instance.new("TextLabel", bb)
        txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1; txt.Text = f.Name .. " []"; txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.TextStrokeTransparency = 0.3; txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); txt.Font = Enum.Font.GothamBold; txt.TextSize = 13; txt.TextXAlignment = "Left"
        Data[f] = { bb = bb, txt = txt }; Mem[f] = -1
    end)
end

local function Rem(f) 
    if Data[f] then pcall(function() if Data[f].bb and Data[f].bb.Parent then Data[f].bb:Destroy() end end) Data[f] = nil; Mem[f] = nil end 
end

for _, o in pairs(Workspace:GetChildren()) do if IsF(o) then Add(o) end end
Workspace.ChildAdded:Connect(function(o) task.wait(0.5) if IsF(o) then Add(o) end end)
Workspace.ChildRemoved:Connect(function(o) Rem(o) end)

-- ESP LOGIC
RunService.RenderStepped:Connect(function()
    FC = FC + 1; if FC % SKIP ~= 0 then return end
    pcall(function()
        if not Settings.FruitESP then for _, d in pairs(Data) do if d and d.bb then d.bb.Enabled = false end end return end
        local c = Me.Character; if not c then return end; local r = c:FindFirstChild("HumanoidRootPart"); if not r then return end; local mp = r.Position
        for f, d in pairs(Data) do
            if not f or not f.Parent or not d.bb or not d.bb.Parent then Rem(f) continue end
            local p = Pos(f); if not p then d.bb.Enabled = false continue end
            local dx, dy, dz = p.X - mp.X, p.Y - mp.Y, p.Z - mp.Z; local m = math.floor(math.sqrt(dx*dx + dy*dy + dz*dz))
            if math.abs(m - (Mem[f] or -1)) > 5 then Mem[f] = m; d.txt.Text = f.Name .. " [" .. m .. "m]" end
            d.bb.Enabled = true
        end
    end)
end)

-- SMOOTH TWEEN LOGIC
local fruitTween = nil

local function GetNearestFruit()
    local closest, minDist = nil, math.huge
    local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for f, _ in pairs(Data) do
        if f and f.Parent then local p = Pos(f) if p then local dist = (p - hrp.Position).Magnitude if dist < minDist then closest = f; minDist = dist end end end
    end
    return closest
end

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.TweenFruit then
                local nearest = GetNearestFruit()
                local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart")
                if nearest and hrp then
                    local pos = Pos(nearest)
                    if pos then
                        local dist = (pos - hrp.Position).Magnitude
                        if dist > 5 then
                            if fruitTween then fruitTween:Cancel() end
                            local speed = 250 
                            local timeToTween = dist / speed
                            local targetCFrame = CFrame.new(pos + Vector3.new(0, 1.5, 0)) 
                            fruitTween = TweenService:Create(hrp, TweenInfo.new(timeToTween, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                            fruitTween:Play()
                        else
                            if fruitTween then fruitTween:Cancel(); fruitTween = nil end
                        end
                    end
                else
                    if fruitTween then fruitTween:Cancel(); fruitTween = nil end
                end
            else
                if fruitTween then fruitTween:Cancel(); fruitTween = nil end
            end
        end)
    end
end)

-- ==========================================
-- AUTO STORE FRUITS
-- ==========================================
local StoreBlacklist = {}

local function GetFruitRealName(tool)
    if not tool then return nil end
    local fruitVal = tool:FindFirstChild("Fruit")
    if fruitVal and fruitVal:IsA("StringValue") then return fruitVal.Value end
    return tool.Name
end

task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoStoreFruit then
            pcall(function()
                local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                if not remote then return end
                
                local function TryStore(tool)
                    if tool:IsA("Tool") and tool:FindFirstChild("Fruit") then
                        if not table.find(StoreBlacklist, tool.Name) then
                            local realName = GetFruitRealName(tool)
                            local success = remote:InvokeServer("StoreFruit", realName, tool)
                            if success ~= true then
                                table.insert(StoreBlacklist, tool.Name)
                                if Settings.AutoHop then
                                    task.wait(1)
                                    _G.Cat.HopServer()
                                end
                            end
                        end
                    end
                end

                local backpack = Me.Backpack
                local char = Me.Character
                if backpack then for _, tool in pairs(backpack:GetChildren()) do TryStore(tool) end end
                if char then for _, tool in pairs(char:GetChildren()) do TryStore(tool) end end
            end)
        end
    end
end)

-- ==========================================
-- UI SERVER HOPPER (REDZHUB STYLE)
-- ==========================================
local isHopping = false

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    pcall(function()
        local pGui = Me.PlayerGui
        if not pGui then return end
        
        local function getDescendants(parent)
            local list = {}
            for _, child in pairs(parent:GetChildren()) do
                table.insert(list, child)
                for _, desc in pairs(getDescendants(child)) do table.insert(list, desc) end
            end
            return list
        end

        -- 1. Cari tombol Server Browser (Biasanya ada tulisan "Server" atau di namanya "Server")
        local browserBtn = nil
        for _, obj in pairs(getDescendants(pGui)) do
            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) then
                local text = obj.Text or ""
                local name = obj.Name or ""
                if string.find(string.lower(text), "server") or string.find(string.lower(name), "server") then
                    browserBtn = obj
                    break
                end
            end
        end

        if not browserBtn then
            warn("[CatHUB] Tombol Server Browser tidak ditemukan!")
            isHopping = false
            return
        end

        -- Klik tombol buka UI Server
        firesignal(browserBtn.MouseButton1Click)
        task.wait(1.5)

        -- 2. Cari server yang cocok (Tidak penuh, >2 pemain biar bukan bot)
        local joined = false
        for attempt = 1, 15 do -- Coba scroll 15 kali
            for _, obj in pairs(getDescendants(pGui)) do
                if obj:IsA("TextButton") and obj.Visible then
                    local text = obj.Text or ""
                    if string.find(string.lower(text), "join") then
                        -- Cek jumlah pemain di sibling label (Biasanya format "X/Y")
                        local parent = obj.Parent
                        if parent then
                            for _, sibling in pairs(parent:GetDescendants()) do
                                if sibling:IsA("TextLabel") and sibling.Text then
                                    local current, max = string.match(sibling.Text, "(%d+)/(%d+)")
                                    if current and max then
                                        current = tonumber(current)
                                        max = tonumber(max)
                                        -- Filter: Harus ada orang (>2), dan belum penuh
                                        if current and max and current > 2 and current < max then
                                            firesignal(obj.MouseButton1Click)
                                            joined = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if joined then break end
            end
            
            if joined then break end
            
            -- Scroll ke bawah kalau ga nemu
            for _, obj in pairs(getDescendants(pGui)) do
                if obj:IsA("ScrollingFrame") and obj.Visible then
                    obj.CanvasPosition = Vector2.new(0, obj.CanvasPosition.Y + 300)
                    break
                end
            end
            task.wait(0.5)
        end

        -- 3. Tutup UI Server kalau udah selesai/ketemu
        if not joined then
            for _, obj in pairs(getDescendants(pGui)) do
                if obj:IsA("TextButton") and (string.find(string.lower(obj.Text), "close") or string.find(string.lower(obj.Text), "x")) then
                    firesignal(obj.MouseButton1Click)
                    break
                end
            end
        end
    end)
    
    task.wait(10) -- Cooldown abis klik join biar ga spam
    isHopping = false
end

-- CEK BUAH DI MAP UNTUK HOP
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