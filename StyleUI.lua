-- [[ ==========================================
--      CATHUB PREMIUM: REDZ UI ADAPTER ENGINE
--    ========================================== ]]

-- // Services
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")

-- // Anti-Duplicate UI Lama
if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

-- ==========================================
-- 1. CAT HUB CORE SYSTEMS (WAJIB DIPERTAHANKAN)
-- ==========================================
local ConfigFile = "CatHUB_Config.json"

_G.Cat        = _G.Cat or {}
_G.Cat.Player = Players.LocalPlayer
_G.Cat.Labels = _G.Cat.Labels or {}

if not _G.Cat.Settings then
    _G.Cat.Settings = {}
end

local function SaveSettings()
    pcall(function()
        local payload = HttpService:JSONEncode(_G.Cat.Settings)
        writefile(ConfigFile, payload)
    end)
end
_G.Cat.SaveSettings = SaveSettings

-- // Theme khusus buat X-Ray Manual di Status.lua (Jangan dihapus)
local Theme = {
    MainBG = Color3.fromRGB(17, 17, 17), 
    SideBG = Color3.fromRGB(15, 15, 15), 
    TopBG  = Color3.fromRGB(15, 15, 15), 
    PageBG = Color3.fromRGB(8, 8, 8),    
    CardBG  = Color3.fromRGB(39, 37, 37),
    Text    = Color3.fromRGB(250, 250, 250),
    TextDim = Color3.fromRGB(140, 140, 145),
    CatPurple = Color3.fromRGB(160, 100, 255),
    Gold      = Color3.fromRGB(255, 187, 0),
    Line      = Color3.fromRGB(31, 31, 34)
}

-- ==========================================
-- 2. REDZ HUB LIBRARY (CORE UI ENGINE)
-- ==========================================

local Configs_HUB = {
  Cor_Hub = Color3.fromRGB(15, 15, 15),
  Cor_Options = Color3.fromRGB(20, 20, 20),
  Cor_Stroke = Color3.fromRGB(40, 40, 40),
  Cor_Text = Color3.fromRGB(240, 240, 240),
  Cor_DarkText = Color3.fromRGB(120, 120, 120),
  Cor_Accent = Color3.fromRGB(132, 0, 255), -- Gue ganti jadi warna Ungu CatHUB asli
  Corner_Radius = UDim.new(0, 4),
  Text_Font = Enum.Font.FredokaOne
}

local function Create(instance, parent, props)
  local new = Instance.new(instance, parent)
  if props then table.foreach(props, function(prop, value) new[prop] = value end) end
  return new
end

local function SetProps(instance, props)
  if instance and props then table.foreach(props, function(prop, value) instance[prop] = value end) end
  return instance
end

local function Corner(parent, props)
  local new = Create("UICorner", parent)
  new.CornerRadius = Configs_HUB.Corner_Radius
  if props then SetProps(new, props) end
  return new
end

local function Stroke(parent, props)
  local new = Create("UIStroke", parent)
  new.Color = Configs_HUB.Cor_Stroke
  new.ApplyStrokeMode = "Border"
  if props then SetProps(new, props) end
  return new
end

local function CreateTween(instance, prop, value, time, tweenWait)
  local tween = TweenService:Create(instance, TweenInfo.new(time, Enum.EasingStyle.Linear), {[prop] = value})
  tween:Play()
  if tweenWait then tween.Completed:Wait() end
end

local function TextSetColor(instance)
  instance.MouseEnter:Connect(function()
    CreateTween(instance, "TextColor3", Configs_HUB.Cor_Accent, 0.4, true)
  end)
  instance.MouseLeave:Connect(function()
    CreateTween(instance, "TextColor3", Configs_HUB.Cor_Text, 0.4, false)
  end)
end

local ScreenGui = Create("ScreenGui", CoreGui, {Name = "CatUI", ResetOnSpawn = false})
local ScreenFind = CoreGui:FindFirstChild(ScreenGui.Name)
if ScreenFind and ScreenFind ~= ScreenGui then ScreenFind:Destroy() end

function DestroyScript() ScreenGui:Destroy() end

-- Notifikasi System (Disembunyikan di background, dipakai kalau lu butuh nanti)
local Menu_Notifi = Create("Frame", ScreenGui, {Size = UDim2.new(0, 300, 1, 0), Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Visible = false})
Create("UIPadding", Menu_Notifi, {PaddingLeft = UDim.new(0, 25), PaddingTop = UDim.new(0, 25), PaddingBottom = UDim.new(0, 50)})
Create("UIListLayout", Menu_Notifi, {Padding = UDim.new(0, 15), VerticalAlignment = "Bottom"})

function MakeNotifi(Configs)
    -- Notifikasi system ready tapi tidak dipaksa muncul
end

-- Main Window Initialization
local Menu = Create("Frame", ScreenGui, {
  BackgroundColor3 = Configs_HUB.Cor_Hub,
  Position = UDim2.new(0.5, -250, 0.5, -135),
  Active = true,
  Draggable = true
}) Corner(Menu)

local TopBar = Create("Frame", Menu, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Visible = false})
local ButtonsFrame = Create("Frame", TopBar, {Size = UDim2.new(0, 40, 1, -5), Position = UDim2.new(1, -10, 0, 2.5), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1})

local Title = Create("TextLabel", TopBar, {
  Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 20, 0, 0),
  TextColor3 = Configs_HUB.Cor_Accent, Font = Configs_HUB.Text_Font, TextXAlignment = "Left",
  Text = "CatHUB | Blox Fruits", TextSize = 18, BackgroundTransparency = 1
})

local Minimize_BTN = Create("TextButton", ButtonsFrame, {Text = "-", TextColor3 = Configs_HUB.Cor_Text, Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Font = Configs_HUB.Text_Font, TextYAlignment = "Bottom", TextSize = 25})
IsMinimized = false
Minimize_BTN.MouseButton1Click:Connect(function()
  Minimize_BTN.Text = not IsMinimized and "+" or "-"
  if IsMinimized then
    IsMinimized = false
    CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.15, false)
  else
    IsMinimized = true
    CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 25), 0.15, true)
  end
end)

local Close_Button = Create("TextButton", ButtonsFrame, {Text = "×", TextYAlignment = "Bottom", TextColor3 = Configs_HUB.Cor_Text, Size = UDim2.new(0.5, 0, 1, 0), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Font = Configs_HUB.Text_Font, TextSize = 25})
Close_Button.MouseButton1Click:Connect(function()
    CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 0), 0.3, true)
    task.wait(0.3)
    Menu.Visible = false
    Menu.Size = UDim2.new(0, 500, 0, 270)
end)

-- Window Animation
local AnimMenu = Create("Frame", ScreenGui, {Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Configs_HUB.Cor_Hub}) Corner(AnimMenu, {CornerRadius = UDim.new(0, 6)})
CreateTween(AnimMenu, "Size", UDim2.new(0, 0, 0, 35), 0.4, true)
CreateTween(AnimMenu, "Size", UDim2.new(0, 150, 0, 35), 0.4, true)
task.wait(0.8)
CreateTween(AnimMenu, "Size", UDim2.new(0, 0, 0, 35), 0.3, true)
AnimMenu:Destroy()

CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 35), 0.4, true)
TopBar.Visible = true
CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.3, true)

local line_Containers = Create("Frame", Menu, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0)})
local ScrollBar = Create("ScrollingFrame", Menu, {
  Size = UDim2.new(0, 140, 1, -tonumber(TopBar.Size.Y.Offset + 2)),
  Position = UDim2.new(0, 0, 1, 0), AnchorPoint = Vector2.new(0, 1),
  CanvasSize = UDim2.new(), ScrollingDirection = "Y", AutomaticCanvasSize = "Y",
  BackgroundTransparency = 1, ScrollBarThickness = 2
})
Create("UIPadding", ScrollBar, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
Create("UIListLayout", ScrollBar, {Padding = UDim.new(0, 5)})

local Containers = Create("Frame", Menu, {
  Size = UDim2.new(1, -tonumber(ScrollBar.Size.X.Offset + 2), 1, -tonumber(TopBar.Size.Y.Offset + 2)),
  AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1
}) Corner(Containers)

local function Add_Line(props)
  local line = Create("Frame", line_Containers, props)
  line.BackgroundColor3 = Configs_HUB.Cor_Stroke
  line.BorderSizePixel = 0
end
Add_Line({Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, TopBar.Size.Y.Offset)})
Add_Line({Size = UDim2.new(0, 1, 1, -tonumber(TopBar.Size.Y.Offset + 1)), Position = UDim2.new(0, ScrollBar.Size.X.Offset, 0, TopBar.Size.Y.Offset)})

local firstVisible = true
local textsize = 15
local textcolor = Configs_HUB.Cor_Text

Menu:GetPropertyChangedSignal("Size"):Connect(function()
  if Menu.Size.Y.Offset > 70 then
    ScrollBar.Visible = true; Containers.Visible = true; line_Containers.Visible = true
  else
    ScrollBar.Visible = false; Containers.Visible = false; line_Containers.Visible = false
  end
end)

function MakeTab(Configs)
  local TabName = Configs.Name or "Tab"
  local Frame = Create("Frame", ScrollBar, {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1}) Corner(Frame) Stroke(Frame)
  local TextButton = Create("TextButton", Frame, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""})
  local TextLabel = Create("TextLabel", Frame, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = Configs_HUB.Text_Font, TextColor3 = textcolor, TextSize = textsize, Text = TabName})
  
  local Container = Create("ScrollingFrame", Containers, {
    Size = UDim2.new(1, 0, 1, 0), ScrollingDirection = "Y", AutomaticCanvasSize = "Y",
    CanvasSize = UDim2.new(), BackgroundTransparency = 1, ScrollBarThickness = 2, Visible = firstVisible
  })
  Create("UIPadding", Container, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
  Create("UIListLayout", Container, {Padding = UDim.new(0, 5)})

  TextButton.MouseButton1Click:Connect(function()
    for _,container in pairs(Containers:GetChildren()) do
      if container:IsA("ScrollingFrame") then container.Visible = false end
    end
    for _,frame in pairs(ScrollBar:GetChildren()) do
      if frame:IsA("Frame") and frame:FindFirstChild("TextLabel") and frame.TextLabel ~= TextLabel then
        CreateTween(frame.TextLabel, "TextColor3", Configs_HUB.Cor_DarkText, 0.3, false)
        frame.TextLabel.TextSize = 14
      end
    end
    Container.Visible = true
    CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.3, false)
    TextLabel.TextSize = 15
  end)
  
  firstVisible = false
  textsize = 14
  textcolor = Configs_HUB.Cor_DarkText
  return Container
end

function AddToggle(parent, Configs)
  local ToggleName = Configs.Name or "Toggle!!"
  local Default = Configs.Default or false
  local Callback = Configs.Callback or function() end
  
  local TextButton = Create("TextButton", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame", Text = "", AutoButtonColor = false}) Corner(TextButton) Stroke(TextButton)
  local TextLabel = Create("TextLabel", TextButton, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = ToggleName, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 35, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})
  
  local Frame1 = Create("Frame", TextButton, {Size = UDim2.new(0, 25, 0, 15), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1}) Corner(Frame1, {CornerRadius = UDim.new(1, 0)})
  local Stroke = Stroke(Frame1, {Thickness = 2})
  local Frame2 = Create("Frame", Frame1, {Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(0, 2, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Configs_HUB.Cor_Stroke}) Corner(Frame2, {CornerRadius = UDim.new(1, 0)})
  
  local OnOff = false
  if Default then
    OnOff = true
    CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false)
    CreateTween(Frame2, "BackgroundColor3", Configs_HUB.Cor_Accent, 0.2, false)
    CreateTween(Stroke, "Color", Configs_HUB.Cor_Accent, 0.2, false)
    CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Accent, 0.2, false)
  end
  Callback(OnOff)
  
  TextButton.MouseButton1Click:Connect(function()
    if Frame2.Position.X.Offset < 5 then
      OnOff = true
      CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false)
      CreateTween(Frame2, "BackgroundColor3", Configs_HUB.Cor_Accent, 0.2, false)
      CreateTween(Stroke, "Color", Configs_HUB.Cor_Accent, 0.2, false)
      CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Accent, 0.2, false)
      Callback(true)
    else
      OnOff = false
      CreateTween(Frame2, "Position", UDim2.new(0, 2, 0.5, 0), 0.2, false)
      CreateTween(Frame2, "BackgroundColor3", Configs_HUB.Cor_Stroke, 0.2, false)
      CreateTween(Stroke, "Color", Configs_HUB.Cor_Stroke, 0.2, false)
      CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.2, false)
      Callback(false)
    end
  end)
  return {Frame2, Stroke, OnOff, Callback}
end

function AddTextLabel(parent, Configs)
  local LabelName = Configs[1] or Configs.Name or "Text Label!!"
  local Frame = Create("Frame", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame"}) Corner(Frame) Stroke(Frame)
  local TextButton = Create("TextButton", Frame, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = LabelName, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})
  TextSetColor(TextButton)
  return TextButton
end

function AddSection(parent, Configs)
  local SectionName = Configs.Name or Configs[1] or "Section!!"
  local Frame = Create("Frame", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Hub, Name = "Frame", Transparency = 1}) Corner(Frame)
  local TextButton = Create("TextButton", Frame, {TextSize = 12, TextColor3 = Configs_HUB.Cor_DarkText, Text = string.upper(SectionName), Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})
  return TextButton
end

-- ==========================================
-- 3. THE BRIDGE ADAPTER (JEMBATAN SUCI)
-- ==========================================

local function Adapter_CreateTab(name, isFirst)
    -- Redz otomatis handle tab pertama, jadi parameter 'isFirst' kita abaikan
    return MakeTab({Name = name})
end

local function Adapter_CreateSection(parent, text)
    -- Redz butuh format table, kita konversi dari string CatHUB
    AddSection(parent, {Name = text})
end

local function Adapter_CreateToggle(parent, text, description, stateRef, callback)
    -- Jembatan menyembunyikan 'description' (karena UI Redz lebih clean tanpa deskripsi toggle)
    -- Lalu membungkus callback agar otomatis nge-Save
    local originalCallback = callback or function() end
    local wrappedCallback = function(state)
        originalCallback(state)
        SaveSettings() -- Otomatis save setiap klik!
    end
    
    AddToggle(parent, {
        Name = text,
        Default = stateRef or false,
        Callback = wrappedCallback
    })
end

local function Adapter_CreateLabel(parent, text, description)
    -- Redz mengembalikan TextButton yang punya .Text, sama persis seperti TextLabel CatHUB
    -- Jadi _G.Cat.Labels.Fruits.Text = "..." akan tetap berhasil!
    return AddTextLabel(parent, {text, description})
end

-- ==========================================
-- 4. GLOBAL EXPORT (PINTU MASUK MODUL LAIN)
-- ==========================================

_G.Cat.UI = {
    CreateTab     = Adapter_CreateTab,
    CreateSection = Adapter_CreateSection,
    CreateToggle  = Adapter_CreateToggle,
    CreateLabel   = Adapter_CreateLabel,
    
    -- Fallback buat fitur lain yang butuh akses Theme/Save
    Theme         = Theme,
    SaveSettings  = SaveSettings
}

warn("[CatHUB] Premium Redz UI Engine Loaded Successfully.")