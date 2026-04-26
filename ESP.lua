-- CatHUB v8.4: Fruit ESP (Clean)
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local S = _G.Cat.Settings
local Me = _G.Cat.Player

local Data = {}
local Mem = {}
local FC = 0
local SKIP = 10

local function Pos(f)
    if f:IsA("Tool") then
        local h = f:FindFirstChild("Handle")
        if h then return h.Position end
    end
    if f:IsA("Model") then
        local p = f.PrimaryPart
        if p then return p.Position end
    end
    return nil
end

local function IsF(o)
    return (o:IsA("Tool") or o:IsA("Model")) and o.Name:lower():find("fruit")
end

local function Add(f)
    if Data[f] then return end
    
    local bb = Instance.new("BillboardGui", f)
    bb.Name = "CatESP"
    bb.Size = UDim2.new(0, 120, 0, 32)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.Enabled = false
    
    local nm = Instance.new("TextLabel", bb)
    nm.Size = UDim2.new(1, 0, 0, 18)
    nm.Position = UDim2.new(0, 0, 0, 0)
    nm.BackgroundTransparency = 1
    nm.Text = f.Name
    nm.TextColor3 = Color3.new(1, 1, 1)
    nm.TextStrokeTransparency = 0.8
    nm.TextStrokeColor3 = Color3.new(0, 0, 0)
    nm.Font = Enum.Font.GothamMedium
    nm.TextSize = 12
    
    local dt = Instance.new("TextLabel", bb)
    dt.Size = UDim2.new(1, 0, 0, 12)
    dt.Position = UDim2.new(0, 0, 0, 18)
    dt.BackgroundTransparency = 1
    dt.Text = ""
    dt.TextColor3 = Color3.fromRGB(170, 170, 180)
    dt.TextStrokeTransparency = 0.9
    dt.TextStrokeColor3 = Color3.new(0, 0, 0)
    dt.Font = Enum.Font.Gotham
    dt.TextSize = 10
    
    Data[f] = { bb = bb, nm = nm, dt = dt }
    Mem[f] = -1
end

local function Rem(f)
    local d = Data[f]
    if d then
        d.bb:Destroy()
        Data[f] = nil
        Mem[f] = nil
    end
end

for _, o in pairs(Workspace:GetChildren()) do
    if IsF(o) then Add(o) end
end

Workspace.ChildAdded:Connect(function(o)
    if IsF(o) then Add(o) end
end)

Workspace.ChildRemoved:Connect(function(o)
    Rem(o)
end)

RunService.RenderStepped:Connect(function()
    FC = FC + 1
    if FC % SKIP ~= 0 then return end
    
    if not S.FruitESP then
        for _, d in pairs(Data) do
            d.bb.Enabled = false
        end
        return
    end
    
    local c = Me.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local mp = r.Position
    
    for f, d in pairs(Data) do
        if not f.Parent then
            Rem(f)
            continue
        end
        
        local p = Pos(f)
        if not p then
            d.bb.Enabled = false
            continue
        end
        
        local dx = p.X - mp.X
        local dy = p.Y - mp.Y
        local dz = p.Z - mp.Z
        local m = math.floor(math.sqrt(dx*dx + dy*dy + dz*dz))
        
        local last = Mem[f] or -1
        if math.abs(m - last) > 6 then
            Mem[f] = m
            d.dt.Text = m .. "m"
            
            if m < 300 then
                d.nm.TextColor3 = Color3.fromRGB(140, 255, 140)
                d.dt.TextColor3 = Color3.fromRGB(110, 200, 110)
            elseif m < 1000 then
                d.nm.TextColor3 = Color3.fromRGB(255, 255, 160)
                d.dt.TextColor3 = Color3.fromRGB(200, 200, 120)
            else
                d.nm.TextColor3 = Color3.fromRGB(255, 170, 150)
                d.dt.TextColor3 = Color3.fromRGB(200, 130, 110)
            end
        end
        
        d.bb.Enabled = true
    end
end)