-- Modules/DevilFruits/ESP.lua
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Me = Players.LocalPlayer
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings or not _G.Cat.State do task.wait(0.1) end
local UI = _G.Cat.UI
local Settings = _G.Cat.Settings
local State = _G.Cat.State

-- 1. PASANG UI
local Page = UI.CreateTab("Devil Fruits", false)
UI.CreateSection(Page, "FRUIT FINDER")
UI.CreateToggle(Page, "Fruit ESP", "Show text on any spawned fruits", Settings.FruitESP, function(s) Settings.FruitESP = s end)

-- 2. LOGIC ESP (MURNI DARI CODE LU)
local Data = {}
local Mem = {}
local FC = 0
local SKIP = 10

local function Pos(f) if not f or not f.Parent then return nil end local ok,r=pcall(function() if f:IsA("Tool") then local h=f:FindFirstChild("Handle") if h then return h.Position end elseif f:IsA("Model") then if f.PrimaryPart then return f.PrimaryPart.Position end local root=f:FindFirstChild("HumanoidRootPart") or f:FindFirstChildWhichIsA("BasePart") if root then return root.Position end end end) return ok and r or nil end
local function IsF(o) if not o or not o.Parent then return false end local ok,r=pcall(function() if (o:IsA("Tool") or o:IsA("Model")) and o:FindFirstChild("Fruit") then return true end return false end) return ok and r end

local function Add(f) if not f or not f.Parent or Data[f] then return end pcall(function() local bb=Instance.new("BillboardGui",f) bb.Name="CatESP" bb.Size=UDim2.new(0,150,0,20) bb.AlwaysOnTop=true bb.StudsOffset=Vector3.new(0,3,0) bb.Enabled=false local txt=Instance.new("TextLabel",bb) txt.Size=UDim2.new(1,0,1,0) txt.BackgroundTransparency=1 txt.Text=f.Name.." []" txt.TextColor3=Color3.fromRGB(255,255,255) txt.TextStrokeTransparency=0.3 txt.TextStrokeColor3=Color3.fromRGB(0,0,0) txt.Font=Enum.Font.GothamBold txt.TextSize=13 txt.TextXAlignment="Left" Data[f]={bb=bb,txt=txt} Mem[f]=-1 end) end
local function Rem(f) if Data[f] then pcall(function() if Data[f].bb and Data[f].bb.Parent then Data[f].bb:Destroy() end end) Data[f]=nil Mem[f]=nil end end

for _, o in pairs(Workspace:GetChildren()) do if IsF(o) then Add(o) end end
Workspace.ChildAdded:Connect(function(o) 
    task.wait(0.5) 
    if IsF(o) then 
        Add(o) 
        if Settings.FruitWebhook and _G.Cat.Webhook and State.IsGameReady then
            _G.Cat.Webhook:Send(o.Name, game.JobId, Settings.FruitWebhookRarity, Settings.FruitWebhookURL)
        end
    end 
end)
Workspace.ChildRemoved:Connect(function(o) Rem(o) end)

-- Export Data & Fungsi buat dipake module lain
_G.Cat.ESP = {
    Data = Data,
    Pos = Pos,
    GetNearestFruit = function() 
        local closest, minDist = nil, math.huge 
        local hrp = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart") 
        if not hrp then return nil end 
        for f, _ in pairs(Data) do if f and f.Parent == Workspace then local p = Pos(f) if p then local dist = (p - hrp.Position).Magnitude if dist < minDist then closest, minDist = f, dist end end else Rem(f) end end 
        return closest 
    end,
    GetFruitsList = function() local names = {} for f, _ in pairs(Data) do if f and f.Parent then table.insert(names, f.Name) end end return names end
}

RunService.RenderStepped:Connect(function() FC=FC+1 if FC%SKIP~=0 then return end pcall(function() if not Settings.FruitESP then for _,d in pairs(Data) do if d and d.bb then d.bb.Enabled=false end end return end local c=Me.Character if not c then return end local r=c:FindFirstChild("HumanoidRootPart") if not r then return end local mp=r.Position for f,d in pairs(Data) do if not f or not f.Parent or not d.bb or not d.bb.Parent then Rem(f) continue end local p=Pos(f) if not p then d.bb.Enabled=false continue end local dx,dy,dz=p.X-mp.X,p.Y-mp.Y,p.Z-mp.Z local m=math.floor(math.sqrt(dx*dx+dy*dy+dz*dz)) if math.abs(m-(Mem[f]or-1))>5 then Mem[f]=m d.txt.Text=f.Name.." ["..m.."m]" end d.bb.Enabled=true end end) end)