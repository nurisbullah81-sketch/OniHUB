-- [[ ==========================================
--      CATHUB PREMIUM: FLUENT UI (FIX FINAL)
--    ========================================== ]]

local HttpService = game:GetService("HttpService")
local RunService  = game:GetService("RunService")
local Players     = game:GetService("Players")
local ConfigFile  = "CatHUB_Config.json"

_G.Cat = _G.Cat or {}
_G.Cat.Player = Players.LocalPlayer
_G.Cat.Labels = _G.Cat.Labels or {}
if not _G.Cat.Settings then _G.Cat.Settings = {} end

local function SaveSettings()
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings)) end)
end
_G.Cat.SaveSettings = SaveSettings

_G.Cat.Theme = {
    CardBG = Color3.fromRGB(30, 30, 30), SideBG = Color3.fromRGB(40, 40, 40), Line = Color3.fromRGB(60, 60, 60),
    Text = Color3.fromRGB(240, 240, 240), TextDim = Color3.fromRGB(150, 150, 150), CatPurple = Color3.fromRGB(170, 85, 255)
}

-- ==========================================
-- 1. LOAD FLUENT DARI GITHUB LU SENDIRI
-- ==========================================
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/main/Fluent.lua"))()

if not Fluent then
    warn("[CatHUB] Gagal load Fluent dari GitHub!")
    return
end

-- ==========================================
-- 2. BUAT WINDOW & PATCH
-- ==========================================
local Window = Fluent:CreateWindow({
    Title = "CatHUB",
    SubTitle = "[Freemium] Blox Fruits",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Obat Posisi Nyangkuk
task.spawn(function()
    task.wait(1)
    for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, obj in ipairs(gui:GetChildren()) do
                if obj:IsA("Frame") and math.abs(obj.Size.X.Offset - 580) < 10 and math.abs(obj.Size.Y.Offset - 460) < 10 then
                    obj.AnchorPoint = Vector2.new(0.5, 0.5)
                    obj.Position = UDim2.new(0.5, 0, 0.5, 0)
                    break
                end
            end
        end
    end
end)

-- Obat Skill Nyangkuk
RunService:BindToRenderStep("CatHUB_CameraFix", Enum.RenderPriority.Camera.Value + 1, function()
    if not _G.Cat.State or not _G.Cat.State.IsGameReady then return end
    local cam = workspace.CurrentCamera
    local char = Players.LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            if cam.CameraType ~= Enum.CameraType.Custom then cam.CameraType = Enum.CameraType.Custom end
            if cam.CameraSubject ~= hum then cam.CameraSubject = hum end
        end
    end
end)

-- ==========================================
-- 3. WRAPPER ENGINE
-- ==========================================
local Tabs = {}
local function CreateTab(name, isFirst)
    if not Window then return {} end
    if not Tabs[name] then Tabs[name] = Window:AddTab({ Title = name, Icon = "" }) end
    if isFirst then pcall(function() Window:SelectTab(1) end) end
    return Tabs[name]
end

local function CreateSection(parentTab, text)
    if not Window then return end
    parentTab:AddSection(text)
end

local function CreateToggle(parentTab, text, description, stateRef, callback)
    if not Window then return end
    parentTab:AddToggle("T_"..text, {
        Title = text, Description = description or "", Default = stateRef or false,
        Callback = function(state) if callback then callback(state) end; SaveSettings() end
    })
end

local function CreateLabel(parentTab, text, description)
    if not Window then return { Text = text or "" } end
    local p = parentTab:AddParagraph({ Title = text, Content = description or "" })
    local fakeLabel = {}
    setmetatable(fakeLabel, { __newindex = function(t, k, v) if k == "Text" then p:SetTitle(v) end end })
    return fakeLabel
end

-- ==========================================
-- 4. INIT & EXPORT
-- ==========================================
CreateTab("Status", true)
CreateTab("Auto Farm", false)
CreateTab("Devil Fruits", false)
CreateTab("Misc", false)

_G.Cat.UI = {
    CreateTab = CreateTab, CreateSection = CreateSection,
    CreateToggle = CreateToggle, CreateLabel = CreateLabel,
    Theme = _G.Cat.Theme, SaveSettings = SaveSettings
}

Fluent:Notify({ Title = "CatHUB", Content = "UI Loaded!", Duration = 3 })