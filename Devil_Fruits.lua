local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
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
-- BLOX FRUITS PRECISION UI HOPPER
-- ==========================================
local isHopping = false

local function ClickBtn(btn)
    if not btn then return end
    local pos = btn.AbsolutePosition
    local size = btn.AbsoluteSize
    local x = pos.X + (size.X / 2)
    local y = pos.Y + (size.Y / 2)
    
    -- Simulasi klik mouse (Only if button is visible on screen)
    if x > 0 and y > 0 and btn.Visible and btn.Active then
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        task.wait(0.3)
    end
end

local function FindButton(parent, text)
    for _, child in pairs(parent:GetDescendants()) do
        if child:IsA("TextButton") and child.Visible then
            if string.find(string.lower(child.Text), string.lower(text)) then
                return child
            end
        end
    end
    return nil
end

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    pcall(function()
        local pGui = Me:FindFirstChild("PlayerGui")
        if not pGui then isHopping = false return end

        -- 1. Cari dan klik tombol Menu (Blox Fruits letakin di kiri layar)
        -- Biasanya namanya "Menu" atau ikon garis tiga
        local menuBtn = nil
        for _, gui in pairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                menuBtn = FindButton(gui, "Menu")
                if menuBtn then break end
            end
        end
        
        if menuBtn then
            ClickBtn(menuBtn)
            task.wait(1)
        else
            -- Fallback: Coba tekan M di keyboard (banyak game pakai ini)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.M, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.M, false, game)
            task.wait(1)
        end

        -- 2. Cari dan klik tombol Server
        local serverBtn = nil
        for _, gui in pairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                serverBtn = FindButton(gui, "Server")
                if serverBtn then break end
            end
        end
        
        if not serverBtn then
            -- Kalau ga nemu, tutup menu dan stop
            local closeBtn = nil
            for _, gui in pairs(pGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    closeBtn = FindButton(gui, "Close") or FindButton(gui, "X")
                    if closeBtn then break end
                end
            end
            if closeBtn then ClickBtn(closeBtn) end
            isHopping = false
            return
        end
        
        ClickBtn(serverBtn)
        task.wait(1.5)

        -- 3. Cari tombol Join yang servernya belum penuh
        local joined = false
        for scroll = 1, 10 do
            for _, gui in pairs(pGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    for _, btn in pairs(gui:GetDescendants()) do
                        if btn:IsA("TextButton") and btn.Visible and string.find(string.lower(btn.Text), "join") then
                            -- Cek jumlah pemain di sebelahnya
                            local parent = btn.Parent
                            if parent then
                                for _, label in pairs(parent:GetDescendants()) do
                                    if label:IsA("TextLabel") then
                                        local current, max = string.match(label.Text, "(%d+)/(%d+)")
                                        if current and max then
                                            current = tonumber(current)
                                            max = tonumber(max)
                                            if current and max and current > 2 and current < max then
                                                ClickBtn(btn)
                                                joined = true
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                            if joined then break end
                        end
                    end
                end
                if joined then break end
            end
            
            if joined then break end
            
            -- Scroll ke bawah kalau server di atas penuh
            VirtualInputManager:SendMouseWheelEvent(0, -3, false, game)
            task.wait(0.5)
        end

        -- 4. Tutup UI kalau udah selesai
        if not joined then
            for _, gui in pairs(pGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    local closeBtn = FindButton(gui, "Close") or FindButton(gui, "X")
                    if closeBtn then ClickBtn(closeBtn); break end
                end
            end
        end
    end)
    
    task.wait(15)
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