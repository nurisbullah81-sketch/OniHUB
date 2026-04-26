-- CatHUB v8.3: Fruit ESP (Ultra Minimal)
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local S = _G.Cat.Settings
local Me = _G.Cat.Player

local Data = {}
local Cache = {}
local FC = 0
local SKIP = 12

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
    bb.Size = UDim2.new(0, 100, 0, 30)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.Enabled = false
    
    -- Nama buah
    local name = Instance.new("TextLabel", bb)
    name.Size = UDim2.new(1, 0, 0, 16)
    name.Position = UDim2.new(0, 0, 0, 0)
    name.BackgroundTransparency = 1
    name.Text = f.Name
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextStrokeTransparency = 0.7
    name.TextStrokeColor3 = Color3.new(0, 0, 0)
    name.Font = Enum.Font.GothamBold
    name.TextSize = 12
    
    -- Jarak kecil di bawah
    local dist = Instance.new("TextLabel", bb)
    dist.Size = UDim2.new(1, 0, 0, 12)
    dist.Position = UDim2.new(0, 0, 0, 16)
    dist.BackgroundTransparency = 1
    dist.Text = ""
    dist.TextColor3 = Color3.fromRGB(180, 180, 180)
    dist.TextStrokeTransparency = 0.8
    dist.TextStrokeColor3 = Color3.new(0, 0, 0)
    dist.Font = Enum.Font.Gotham
    dist.TextSize = 9
    
    Data[f] = { bb = bb, name = name, dist = dist }
    Cache[f] = -1
end

local function Rem(f)
    local d = Data[f]
    if d then
        d.bb:Destroy()
        Data[f] = nil
        Cache[f] = nil
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
        
        local last = Cache[f] or -1
        if math.abs(m - last) > 8 then
            Cache[f] = m
            d.dist.Text = m .. "m"
            
            if m < 300 then
                d.name.TextColor3 = Color3.fromRGB(130, 255, 130)
                d.dist.TextColor3 = Color3.fromRGB(100, 200, 100)
            elseif m < 1000 then
                d.name.TextColor3 = Color3.fromRGB(255, 255, 150)
                d.dist.TextColor3 = Color3.fromRGB(200, 200, 100)
            else
                d.name.TextColor3 = Color3.fromRGB(255, 160, 140)
                d.dist.TextColor3 = Color3.fromRGB(200, 120, 100)
            end
        end
        
        d.bb.Enabled = true
    end
end)