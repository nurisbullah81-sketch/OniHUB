-- [[ CATHUB PREMIUM: FLUENT (FINAL FIX) ]]

local HttpService = game:GetService("HttpService")
local ConfigFile = "CatHUB_Config.json"

_G.Cat = _G.Cat or {}
_G.Cat.Settings = _G.Cat.Settings or {}

local function SaveSettings()
    pcall(function()
        writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings))
    end)
end
_G.Cat.SaveSettings = SaveSettings

-- 1. Load Fluent dari web
loadstring(game:HttpGet("https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/StyleUI.lua"))()

-- 2. Buat Window (TANPA Acrylic = TANPA BUG KAMERA)
local Window = Fluent:CreateWindow({
    Title = "CatHUB",
    SubTitle = "Blox Fruits",
    TabWidth = 160,
    Size = UDim2.new(0, 580, 0, 460),
    Theme = "Dark",
    Acrylic = false, -- MATIKAN INI. Ini akar masalahnya. Dengan false, skill lu dijamin ga nyangkuk.
    MinimizeKey = Enum.KeyCode.RightControl
})

-- 3. Obat Mutlak Camera (Kunci Permainan PvP)
-- Ini memaksa kamera untuk selalu fokus ke karakter lu, tidak ketipu ke UI
game:GetService("RunService").RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    local char = game:GetService("Players").LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if cam.CameraType ~= Enum.CameraType.Custom then
            cam.CameraType = Enum.CameraType.Custom
        end
        if cam.CameraSubject ~= char:FindFirstChild("Humanoid") then
            cam.CameraSubject = char:FindFirstChild("Humanoid")
        end
    end
end)

-- 4. Wrapper Engine
local Tabs = {}
local function CreateTab(name, isFirst)
    if not Window then return {} end
    if not Tabs[name] then
        Tabs[name] = Window:AddTab(name)
    end
    if isFirst then Window:SelectTab(1) end
    return Tabs[name]
end

local function CreateSection(parentTab, text)
    if not Window then return end
    parentTab:AddSection(text)
end

local function CreateToggle(parentTab, text, desc, stateRef, callback)
    if not Window then return end
    local toggle = parentTab:AddToggle(text, {
        Description = desc or "",
        Default = stateRef or false,
        Callback = function(state)
            if callback then callback(state) end
            SaveSettings()
        end
    })
    return toggle
end

local function CreateLabel(parentTab, text, desc)
    if not Window then return {Text = text or ""} end
    local p = parentTab:AddParagraph({Title = text, Content = desc or ""})
    local proxy = setmetatable({}, {
        __newindex = function(t, k, v)
            if k == "Text" then p:SetTitle(v) end
        end
    })
    return proxy
end

-- 5. Init Tabs
CreateTab("Status", true)
CreateTab("Auto Farm", false)
CreateTab("Devil Fruits", false)
CreateTab("Misc", false)

-- 6. Export
_G.Cat.UI = {
    CreateTab = CreateTab,
    CreateSection = CreateSection,
    CreateToggle = CreateToggle,
    CreateLabel = CreateLabel,
    Theme = {},
    SaveSettings = SaveSettings
}

Fluent:Notify({
    Title = "CatHUB Loaded",
    Content = "Acrylic dimatikan. Skill dijamin normal.",
    Duration = 5
})