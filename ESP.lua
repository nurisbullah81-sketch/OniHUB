-- CatHUB v8.9: Fruit ESP (Clear Text + Background Box)
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local S = _G.Cat.Settings
local Me = _G.Cat.Player

local Data = {}
local Mem = {}
local FC = 0
local SKIP = 10 

local function Pos(f)
    if not f or not f.Parent then return nil end
    local success, result = pcall(function()
        if f:IsA("Tool") then
            local h = f:FindFirstChild("Handle")
            if h and h:IsA("BasePart") then return h.Position end
        elseif f:IsA("Model") then
            if f.PrimaryPart and f.PrimaryPart:IsA("BasePart") then return f.PrimaryPart.Position end
            local root = f:FindFirstChild("HumanoidRootPart") or f:FindFirstChildWhichIsA("BasePart")
            if root then return root.Position end
        end
        return nil
    end)
    return success and result or nil
end

local function IsF(o)
    if not o or not o.Parent then return false end
    local success, isFruit = pcall(function()
        local n = o.Name:lower()
        return (o:IsA("Tool") or o:IsA("Model")) and n:find("fruit")
    end)
    return success and isFruit
end

-- Buat ESP dengan Kotak Background
local function Add(f)
    if not f or not f.Parent then return end
    if Data[f] then return end
    
    local success, err = pcall(function()
        local bb = Instance.new("BillboardGui", f)
        bb.Name = "CatESP"
        bb.Size = UDim2.new(0, 140, 0, 40)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.Enabled = false
        
        -- KOTAK BACKGROUND BIAR KELIATAN
        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        bg.BackgroundTransparency = 0.2
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
        
        -- Border kotak
        local stroke = Instance.new("UIStroke", bg)
        stroke.Color = Color3.fromRGB(120, 80, 210)
        stroke.Thickness = 0.8
        
        local nm = Instance.new("TextLabel", bg)
        nm.Size = UDim2.new(1, -10, 0, 20)
        nm.Position = UDim2.new(0, 5, 0, 2)
        nm.BackgroundTransparency = 1
        nm.Text = "🍇 " .. f.Name
        nm.TextColor3 = Color3.fromRGB(230, 230, 255)
        nm.TextStrokeTransparency = 0.5
        nm.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nm.Font = Enum.Font.GothamBold
        nm.TextSize = 13
        nm.TextXAlignment = "Left"
        
        local dt = Instance.new("TextLabel", bg)
        dt.Size = UDim2.new(1, -10, 0, 14)
        dt.Position = UDim2.new(0, 5, 0, 22)
        dt.BackgroundTransparency = 1
        dt.Text = ""
        dt.TextColor3 = Color3.fromRGB(180, 180, 200)
        dt.TextStrokeTransparency = 0.6
        dt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        dt.Font = Enum.Font.Gotham
        dt.TextSize = 11
        dt.TextXAlignment = "Left"
        
        Data[f] = { bb = bb, nm = nm, dt = dt, bg = bg }
        Mem[f] = -1
    end)
end

local function Rem(f)
    local d = Data[f]
    if d then
        pcall(function() if d.bb and d.bb.Parent then d.bb:Destroy() end end)
        Data[f] = nil; Mem[f] = nil
    end
end

for _, o in pairs(Workspace:GetChildren()) do if IsF(o) then Add(o) end end

Workspace.ChildAdded:Connect(function(o)
    task.wait(0.5)
    if IsF(o) then Add(o) end
end)

Workspace.ChildRemoved:Connect(function(o) Rem(o) end)

RunService.RenderStepped:Connect(function()
    FC = FC + 1
    if FC % SKIP ~= 0 then return end
    
    pcall(function()
        if not S.FruitESP then
            for _, d in pairs(Data) do if d and d.bb then d.bb.Enabled = false end end
            return
        end
        
        local c = Me.Character
        if not c or not c.Parent then return end
        local r = c:FindFirstChild("HumanoidRootPart")
        if not r or not r.Parent then return end
        local mp = r.Position
        
        for f, d in pairs(Data) do
            if not f or not f.Parent or not d.bb or not d.bb.Parent then Rem(f) continue end
            
            local p = Pos(f)
            if not p then d.bb.Enabled = false continue end
            
            local dx, dy, dz = p.X - mp.X, p.Y - mp.Y, p.Z - mp.Z
            local m = math.floor(math.sqrt(dx*dx + dy*dy + dz*dz))
            
            if math.abs(m - (Mem[f] or -1)) > 5 then
                Mem[f] = m
                d.dt.Text = "Distance: " .. m .. "m"
                
                if m < 300 then
                    d.bg.BackgroundColor3 = Color3.fromRGB(10, 40, 10) -- Hijau
                    d.nm.TextColor3 = Color3.fromRGB(100, 255, 100)
                elseif m < 1000 then
                    d.bg.BackgroundColor3 = Color3.fromRGB(40, 40, 10) -- Kuning
                    d.nm.TextColor3 = Color3.fromRGB(255, 255, 100)
                else
                    d.bg.BackgroundColor3 = Color3.fromRGB(40, 10, 10) -- Merah
                    d.nm.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
            end
            d.bb.Enabled = true
        end
    end)
end)