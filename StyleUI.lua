-- [[ REDZ HUB LIBRARY - PART 1 ]]
local Configs_HUB = {
  Cor_Hub = Color3.fromRGB(15, 15, 15),
  Cor_Options = Color3.fromRGB(15, 15, 15),
  Cor_Stroke = Color3.fromRGB(60, 60, 60),
  Cor_Text = Color3.fromRGB(240, 240, 240),
  Cor_DarkText = Color3.fromRGB(140, 140, 140),
  Corner_Radius = UDim.new(0, 4),
  Text_Font = Enum.Font.FredokaOne
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Setup Global CatHUB (Jangan dihapus, ini tugas background)
_G.Cat = _G.Cat or {}
_G.Cat.Player = Players.LocalPlayer
_G.Cat.Labels = _G.Cat.Labels or {}
if not _G.Cat.Settings then _G.Cat.Settings = {} end
local ConfigFile = "CatHUB_Config.json"
local function SaveSettings()
    pcall(function()
        writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings))
    end)
end
_G.Cat.SaveSettings = SaveSettings

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
  instance.MouseEnter:Connect(function() CreateTween(instance, "TextColor3", Color3.fromRGB(28, 120, 212), 0.4, true) end)
  instance.MouseLeave:Connect(function() CreateTween(instance, "TextColor3", Configs_HUB.Cor_Text, 0.4, false) end)
end

local ScreenGui = Create("ScreenGui", CoreGui, {Name = "CatUI", ResetOnSpawn = false})
if CoreGui:FindFirstChild(ScreenGui.Name) and CoreGui[ScreenGui.Name] ~= ScreenGui then CoreGui[ScreenGui.Name]:Destroy() end
function DestroyScript() ScreenGui:Destroy() end

local Menu_Notifi = Create("Frame", ScreenGui, {Size = UDim2.new(0, 300, 1, 0), Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1})
Create("UIPadding", Menu_Notifi, {PaddingLeft = UDim.new(0, 25), PaddingTop = UDim.new(0, 25), PaddingBottom = UDim.new(0, 50)})
Create("UIListLayout", Menu_Notifi, {Padding = UDim.new(0, 15), VerticalAlignment = "Bottom"})

function MakeNotifi(Configs)
  local Title, text, timewait = Configs.Title or "CatHUB", Configs.Text or "Notifikasi", Configs.Time or 5
  local Frame1 = Create("Frame", Menu_Notifi, {Size = UDim2.new(2, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = "Y", Name = "Title"})
  local Frame2 = Create("Frame", Frame1, {Size = UDim2.new(0, Menu_Notifi.Size.X.Offset - 50, 0, 0), BackgroundColor3 = Configs_HUB.Cor_Hub, Position = UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0), AutomaticSize = "Y"})Corner(Frame2)
  Create("TextLabel", Frame2, {Size = UDim2.new(1, 0, 0, 25), Font = Configs_HUB.Text_Font, BackgroundTransparency = 1, Text = Title, TextSize = 20, Position = UDim2.new(0, 20, 0, 5), TextXAlignment = "Left", TextColor3 = Configs_HUB.Cor_Text})
  local TextButton = Create("TextButton", Frame2, {Text = "X", Font = Configs_HUB.Text_Font, TextSize = 20, BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200, 200, 200), Position = UDim2.new(1, -5, 0, 5), AnchorPoint = Vector2.new(1, 0), Size = UDim2.new(0, 25, 0, 25)})
  Create("TextLabel", Frame2, {Size = UDim2.new(1, -30, 0, 0), Position = UDim2.new(0, 20, 0, TextButton.Size.Y.Offset + 10), TextSize = 15, TextColor3 = Configs_HUB.Cor_DarkText, TextXAlignment = "Left", TextYAlignment = "Top", AutomaticSize = "Y", Text = text, Font = Configs_HUB.Text_Font, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true})
  local FrameSize = Create("Frame", Frame2, {Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Configs_HUB.Cor_Stroke, Position = UDim2.new(0, 2, 0, 30), BorderSizePixel = 0})Corner(FrameSize)
  task.spawn(function() CreateTween(FrameSize, "Size", UDim2.new(0, 0, 0, 2), timewait, true) end)
  TextButton.MouseButton1Click:Connect(function() CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.1, true) CreateTween(Frame2, "Position", UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0), 0.5, true) Frame1:Destroy() end)
  task.spawn(function() CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.5, true) CreateTween(Frame2, "Position", UDim2.new(), 0.1, true) task.wait(timewait) if Frame2 then CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.1, true) CreateTween(Frame2, "Position", UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0), 0.5, true) Frame1:Destroy() end end)
end

function MakeWindow(Configs)
  local title = Configs.Hub.Title or "CatHUB"
  local Anim_Title = Configs.Hub.Animation or "by : CatHUB"
  local Menu = Create("Frame", ScreenGui, {BackgroundColor3 = Configs_HUB.Cor_Hub, Position = UDim2.new(0.5, -500/2, 0.5, -270/2), Active = true, Draggable = true})Corner(Menu)
  local TopBar = Create("Frame", Menu, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Visible = false})
  local ButtonsFrame = Create("Frame", TopBar, {Size = UDim2.new(0, 40, 1, -5), Position = UDim2.new(1, -10, 0, 2.5), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1})
  Create("TextLabel", TopBar, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 20, 0, 0), TextColor3 = Configs_HUB.Cor_Text, Font = Configs_HUB.Text_Font, TextXAlignment = "Left", Text = title, TextSize = 20, BackgroundTransparency = 1})
  
  local Minimize_BTN = Create("TextButton", ButtonsFrame, {Text = "-", TextColor3 = Configs_HUB.Cor_Text, Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Font = Configs_HUB.Text_Font, TextYAlignment = "Bottom", TextSize = 25})
  IsMinimized = false
  Minimize_BTN.MouseButton1Click:Connect(function()
    Minimize_BTN.Text = not IsMinimized and "+" or "-"
    if IsMinimized then IsMinimized = false CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.15, false) else IsMinimized = true CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 25), 0.15, true) end
  end)
  
  local Close_Button = Create("TextButton", ButtonsFrame, {Text = "×", TextYAlignment = "Bottom", TextColor3 = Configs_HUB.Cor_Text, Size = UDim2.new(0.5, 0, 1, 0), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Font = Configs_HUB.Text_Font, TextSize = 25})
  Close_Button.MouseButton1Click:Connect(function() CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 0), 0.3, true) task.wait(0.3) Menu.Visible = false Menu.Size = UDim2.new(0, 500, 0, 270) end)
  
  local AnimMenu = Create("Frame", ScreenGui, {Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Configs_HUB.Cor_Hub})Corner(AnimMenu, {CornerRadius = UDim.new(0, 6)})
  local Anim_Credits = Create("TextLabel", AnimMenu, {Text = Anim_Title, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, Font = Configs_HUB.Text_Font, TextTransparency = 1, TextColor3 = Configs_HUB.Cor_Text, Position = UDim2.new(0, 10, 0, 0), TextXAlignment = "Left", TextSize = 15})
  CreateTween(AnimMenu, "Size", UDim2.new(0, 0, 0, 35), 0.5, true) CreateTween(AnimMenu, "Size", UDim2.new(0, 150, 0, 35), 0.5, true) Anim_Credits.Visible = true task.wait(0.5)
  for i = 1, 0, -0.1 do task.wait() Anim_Credits.TextTransparency = i end task.wait(1) for i = 0, 1, 0.1 do task.wait() Anim_Credits.TextTransparency = i end
  Anim_Credits:Destroy() AnimMenu:Destroy()
  CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 35), 0.5, true) TopBar.Visible = true CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.3, true) Menu.Draggable = true
  
  local line_Containers = Create("Frame", Menu, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0)})
  local ScrollBar = Create("ScrollingFrame", Menu, {Size = UDim2.new(0, 140, 1, -tonumber(TopBar.Size.Y.Offset + 2)), Position = UDim2.new(0, 0, 1, 0), AnchorPoint = Vector2.new(0, 1), CanvasSize = UDim2.new(), ScrollingDirection = "Y", AutomaticCanvasSize = "Y", BackgroundTransparency = 1, ScrollBarThickness = 2})
  Create("UIPadding", ScrollBar, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
  Create("UIListLayout", ScrollBar, {Padding = UDim.new(0, 5)})
  local Containers = Create("Frame", Menu, {Size = UDim2.new(1, -tonumber(ScrollBar.Size.X.Offset + 2), 1, -tonumber(TopBar.Size.Y.Offset + 2)), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1})Corner(Containers)
  
  local function Add_Line(props) local line = Create("Frame", line_Containers, props) line.BackgroundColor3 = Configs_HUB.Cor_Stroke line.BorderSizePixel = 0 end
  Add_Line({Size = UDim2.new(1, 0, 0, 1),Position = UDim2.new(0, 0, 0, TopBar.Size.Y.Offset)})
  Add_Line({Size = UDim2.new(0, 1, 1, -tonumber(TopBar.Size.Y.Offset + 1)),Position = UDim2.new(0, ScrollBar.Size.X.Offset, 0, TopBar.Size.Y.Offset)})
  
  local firstVisible = true local textsize = 15 local textcolor = Configs_HUB.Cor_Text
  Menu:GetPropertyChangedSignal("Size"):Connect(function()
    if Menu.Size.Y.Offset > 70 then ScrollBar.Visible = true Containers.Visible = true line_Containers.Visible = true else ScrollBar.Visible = false Containers.Visible = false line_Containers.Visible = false end
  end)
  
  function MakeTab(Configs)
    local TabName = Configs.Name or "Tab"
    local Frame = Create("Frame", ScrollBar, {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1})Corner(Frame)Stroke(Frame)
    local TextButton = Create("TextButton", Frame, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""})
    local TextLabel = Create("TextLabel", Frame, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = Configs_HUB.Text_Font, TextColor3 = textcolor, TextSize = textsize, Text = TabName})
    local Container = Create("ScrollingFrame", Containers, {Size = UDim2.new(1, 0, 1, 0), ScrollingDirection = "Y", AutomaticCanvasSize = "Y", CanvasSize = UDim2.new(), BackgroundTransparency = 1, ScrollBarThickness = 2, Visible = firstVisible})
    Create("UIPadding", Container, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
    Create("UIListLayout", Container, {Padding = UDim.new(0, 5)})
    TextButton.MouseButton1Click:Connect(function()
      for _,container in pairs(Containers:GetChildren()) do if container:IsA("ScrollingFrame") then container.Visible = false end end
      for _,frame in pairs(ScrollBar:GetChildren()) do if frame:IsA("Frame") and frame:FindFirstChild("TextLabel") and frame.TextLabel ~= TextLabel then CreateTween(frame.TextLabel, "TextColor3", Configs_HUB.Cor_DarkText, 0.3, false) frame.TextLabel.TextSize = 14 end end
      Container.Visible = true CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.3, false) TextLabel.TextSize = 15
    end)
    firstVisible = false textsize = 14 textcolor = Configs_HUB.Cor_DarkText
    return Container
  end

  function AddButton(parent, Configs)
    local ButtonName = Configs.Name or "Button!!"
    local Callback = Configs.Callback or function() end
    local TextButton = Create("TextButton", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame", Text = "", AutoButtonColor = false})Corner(TextButton)Stroke(TextButton)
    local TextLabel = Create("TextLabel", TextButton, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = ButtonName, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 35, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})
    local ImageLabel = Create("ImageLabel", TextButton, {Image = "rbxassetid://15155219405", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 5, 0, 2.5), BackgroundTransparency = 1, ImageColor3 = Configs_HUB.Cor_Stroke})
    TextButton.MouseButton1Click:Connect(function() Callback("Click!!") CreateTween(ImageLabel, "ImageColor3", Color3.fromRGB(28, 120, 212), 0.2, true) CreateTween(ImageLabel, "ImageColor3", Configs_HUB.Cor_Stroke, 0.2, false) end)
    TextSetColor(TextLabel)
  end

  function AddToggle(parent, Configs)
    local ToggleName = Configs.Name or "Toggle!!"
    local Default = Configs.Default or false
    local Callback = Configs.Callback or function() end
    local TextButton = Create("TextButton", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame", Text = "", AutoButtonColor = false})Corner(TextButton)Stroke(TextButton)
    local TextLabel = Create("TextLabel", TextButton, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = ToggleName, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 35, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})
    local Frame1 = Create("Frame", TextButton, {Size = UDim2.new(0, 25, 0, 15), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1,})Corner(Frame1, {CornerRadius = UDim.new(1, 0)})
    local Stroke = Stroke(Frame1, {Thickness = 2})
    local Frame2 = Create("Frame", Frame1, {Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(0, 2, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Configs_HUB.Cor_Stroke})Corner(Frame2, {CornerRadius = UDim.new(1, 0)})
    local OnOff = false
    if Default then OnOff = true CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false) CreateTween(Frame2, "BackgroundColor3", Color3.fromRGB(28, 120, 212), 0.2, false) CreateTween(Stroke, "Color", Color3.fromRGB(28, 120, 212), 0.2, false) CreateTween(TextLabel, "TextColor3", Color3.fromRGB(28, 120, 212), 0.2, false) end
    Callback(OnOff)
    TextButton.MouseButton1Click:Connect(function()
      if Frame2.Position.X.Offset < 5 then OnOff = true CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false) CreateTween(Frame2, "BackgroundColor3", Color3.fromRGB(28, 120, 212), 0.2, false) CreateTween(Stroke, "Color", Color3.fromRGB(28, 120, 212), 0.2, false) CreateTween(TextLabel, "TextColor3", Color3.fromRGB(28, 120, 212), 0.2, false) Callback(true)
      else OnOff = false CreateTween(Frame2, "Position", UDim2.new(0, 2, 0.5, 0), 0.2, false) CreateTween(Frame2, "BackgroundColor3", Configs_HUB.Cor_Stroke, 0.2, false) CreateTween(Stroke, "Color", Configs_HUB.Cor_Stroke, 0.2, false) CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.2, false) Callback(false) end
    end)
    return {Frame2, Stroke, OnOff, Callback}
  end

  function AddMobileToggle(Configs)
    local name, Callback, visible = Configs.Name or "Atalho", Configs.Callback or function() end, Configs.Visible or false
    local Toggle_Atalho = Create("Frame", ScreenGui, {Size = UDim2.new(0, 100, 0, 60), Position = UDim2.new(0.8, 0, 0.8, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Configs_HUB.Cor_Hub, Draggable = true, Active = true, Visible = visible})Corner(Toggle_Atalho)
    Create("TextLabel", Toggle_Atalho, {Size = UDim2.new(1, 0, 0, 20), TextSize = 20, Font = Configs_HUB.Text_Font, TextColor3 = Configs_HUB.Cor_Text, Text = name, BackgroundTransparency = 1})
    local Button = Create("TextButton", Toggle_Atalho, {Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 20), BackgroundTransparency = 1, Text = ""})
    local Frame = Create("Frame", Button, {Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, -40, 1, -15), BackgroundTransparency = 1})Corner(Frame, {CornerRadius = UDim.new(2, 0)})
    local Frame2 = Create("Frame", Frame, {Position = UDim2.new(0, 5, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 17, 0, 17), BackgroundTransparency = 1})Corner(Frame2, {CornerRadius = UDim.new(5, 0)})
    Stroke(Frame, {Color = Color3.fromRGB(100, 100, 100), Thickness = 3}) Stroke(Frame2, {Color = Color3.fromRGB(100, 100, 100), Thickness = 3})
    local OnOff = false Callback(OnOff)
    Button.MouseButton1Click:Connect(function() if OnOff == false then CreateTween(Frame2, "Position", UDim2.new(1, -22, 0.5, 0), 0.2, false) else CreateTween(Frame2, "Position", UDim2.new(0, 5, 0.5, 0), 0.2, false) end OnOff = not OnOff Callback(OnOff) end)
    return Toggle_Atalho
  end

  function UpdateToggle(toggle, value)
    local Frame2, Stroke, OnOff, Callback = toggle[1], toggle[2], value, toggle[4]
    if OnOff then Callback(true) CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false) CreateTween(Frame2, "BackgroundColor3", Color3.fromRGB(28, 120, 212), 0.2, false) CreateTween(Stroke, "Color", Color3.fromRGB(28, 120, 212), 0.2, false)
    else Callback(false) CreateTween(Frame2, "Position", UDim2.new(0, 2, 0.5, 0), 0.2, false) CreateTween(Frame2, "BackgroundColor3", Configs_HUB.Cor_Stroke, 0.2, false) CreateTween(Stroke, "Color", Configs_HUB.Cor_Stroke, 0.2, false) end
  end

  function AddSlider(parent, Configs)
    local SliderName, Increase = Configs.Name or "Slider!!", Configs.Increase or 1
    local MinValue, MaxValue = Configs.MinValue / Increase or 10 / Increase, Configs.MaxValue / Increase or 100 / Increase
    local Default, Callback = Configs.Default or 25, Configs.Callback or function() end
    local Frame = Create("TextButton", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame", Text = 0})Corner(Frame)Stroke(Frame)
    local TextLabel = Create("TextButton", Frame, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = SliderName, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 150, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})TextSetColor(TextLabel)
    local TextLabelNumber = Create("TextLabel", Frame, {Font = Configs_HUB.Text_Font, Size = UDim2.new(0, 20, 0, 20), Text = "...", Position = UDim2.new(0, 5, 0, 2.5), TextScaled = true, TextColor3 = Configs_HUB.Cor_Text, BackgroundTransparency = 1})
    local SliderBar1 = Create("TextLabel", Frame, {Size = UDim2.new(0, 100, 0, 7.5), Position = UDim2.new(0, 35, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Configs_HUB.Cor_Stroke, Text = ""})Corner(SliderBar1)
    local SavePos = Create("Frame", SliderBar1, {Size = UDim2.new(0, 1, 0, 0), Visible = false})
    local Slider = Create("Frame", SliderBar1, {BackgroundColor3 = Configs_HUB.Cor_Text, Size = UDim2.new(0, 7.5, 0, 15), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), Active = true, Draggable = true})Corner(Slider)
    local SliderBar2 = Create("Frame", SliderBar1, {BackgroundColor3 = Color3.fromRGB(28, 120, 212), Size = UDim2.new(0, Slider.Position.X.Offset, 1, 0)})Corner(SliderBar2)
    local function UpdCounter(Value) local String = tostring(Value * Increase) if string.find(String, ".") then String = String:sub(1, 5) end TextLabelNumber.Text = String Callback(Value * Increase) end
    local MouseEnterOrLeave = false
    Frame.MouseButton1Down:Connect(function() MouseEnterOrLeave = true while MouseEnterOrLeave do task.wait() local MousePos = UserInputService:GetMouseLocation().X - SavePos.AbsolutePosition.X Slider.Position = UDim2.new(0, MousePos, 0.5, 0) end end)
    Frame.MouseLeave:Connect(function() MouseEnterOrLeave = false end)
    local function SliderSet(NewValue) local max, min = MaxValue * Increase, MinValue * Increase local SliderPos = (NewValue - min) / (max - min) local X_Offset = SliderPos * 100 CreateTween(Slider, "Position", UDim2.new(0, X_Offset + 1, 0, 0), 0.5, false) end SliderSet(Default)
    Slider.Changed:Connect(function(prop) if prop == "Position" then Slider.Position = UDim2.new(0, math.clamp(Slider.Position.X.Offset, 0, 100), 0.5, 0) SliderBar2.Size = UDim2.new(0, Slider.Position.X.Offset, 1, 0) local SliderPos = Slider.Position.X.Offset / 100 local A_1 = math.floor(((SliderPos * MaxValue) / MaxValue) * (MaxValue - MinValue) + MinValue) UpdCounter(A_1) end end)
    return {Slider, Increase, MaxValue, MinValue}
  end

  function UpdateSlider(Slider, NewValue)
    local Frame, Increase = Slider[1], Slider[2] local Max, Min = Slider[3] * Increase, Slider[4] * Increase
    local SliderPos = (NewValue - Min) / (Max - Min) local X_Offset = SliderPos * 100 CreateTween(Frame, "Position", UDim2.new(0, X_Offset + 1, 0, 0), 0.5, false)
  end

  function AddKeybind(parent, Configs)
    local KeybindName, KeyCode = Configs.Name or "Keybind!!", Configs.KeyCode or "E"
    local Default, Callback = Configs.Default or false, Configs.Callback or function() end
    local Frame = Create("Frame", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame"})Corner(Frame)Stroke(Frame)
    local TextLabel = Create("TextButton", Frame, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = KeybindName, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 35, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})
    local Keybind = Create("TextLabel", Frame, {Font = Configs_HUB.Text_Font, Size = UDim2.new(0, 18, 0, 18), Text = KeyCode, Position = UDim2.new(0, 5, 0, 3.5), TextScaled = true, TextColor3 = Configs_HUB.Cor_Text, BackgroundTransparency = 1})Corner(Keybind)Stroke(Keybind)
    local OnOff = Default
    UserInputService.InputBegan:Connect(function(input) if input.KeyCode == Enum.KeyCode[KeyCode] then OnOff = not OnOff Callback(OnOff) end end) TextSetColor(TextLabel)
  end

  function AddTextBox(parent, Configs)
    local TextBoxName, Default = Configs.Name or "TextBox!!", Configs.Default or "TextBox"
    local placeholderText, ClearText, Callback = Configs.PlaceholderText or "TextBox", Configs.ClearText or false, Configs.Callback or function() end
    local Frame = Create("Frame", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame"})Corner(Frame)Stroke(Frame)
    local TextLabel = Create("TextButton", Frame, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = TextBoxName, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 150, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})TextSetColor(TextLabel)
    local TextBox = Create("TextBox", Frame, {Size = UDim2.new(0, 120, 0, 20), Position = UDim2.new(0, 15, 0, 2.5), TextColor3 = Configs_HUB.Cor_Text, Text = Default, ClearTextOnFocus = ClearText, PlaceholderText = placeholderText, TextScaled = true, Font = Configs_HUB.Text_Font, BackgroundTransparency = 1})
    local Line = Create("Frame", TextBox, {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0.5, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Configs_HUB.Cor_Stroke, BorderSizePixel = 0})
    TextBox.MouseEnter:Connect(function() CreateTween(Line, "Size", UDim2.new(0, 0, 0, 1), 0.3, true) CreateTween(Line, "Size", UDim2.new(1, 0, 0, 1), 0.3, true) end)
    TextBox.FocusLost:Connect(function() Callback(TextBox.Text) end)
  end

  function AddColorPicker(parent, Configs)
    local name = Configs.Name or "Color Picker"
    local Default = Configs.Default or Color3.fromRGB(0, 0, 200)
    local Callback = Configs.Callback or function() end
    local ColorH, ColorS, ColorV = 1, 1, 1
    Callback(Default)
    local TextButton = Create("Frame", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options}) Stroke(TextButton) Corner(TextButton)
    local click = Create("TextButton", TextButton, {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, AutoButtonColor = false, Text = ""})
    Create("TextLabel", TextButton, {Size = UDim2.new(1, -10, 0, 25), Position = UDim2.new(0, 35, 0, 0), TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, TextXAlignment = "Left", Text = name, Font = Configs_HUB.Text_Font, BackgroundTransparency = 1})
    local picker = Create("Frame", TextButton, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 5, 0, 2.5), BackgroundColor3 = Default}) Corner(picker) Stroke(picker)
    local UI_Grade = Create("ImageButton", TextButton, {Size = UDim2.new(1, -100, 1, tonumber(-TextButton.Size.Y.Offset - 20)), Position = UDim2.new(0, 10, 0, tonumber(TextButton.Size.Y.Offset + 12.5)), Visible = false, Image = "rbxassetid://4155801252"}) Corner(UI_Grade) Stroke(UI_Grade) local SavePos = Create("Frame", UI_Grade, {Visible = false})
    local grade = Create("TextButton", TextButton, {Size = UDim2.new(0, 30, 1, tonumber(-TextButton.Size.Y.Offset - 20)), Position = UDim2.new(1, -10, 0, tonumber(TextButton.Size.Y.Offset + 12.5)), AnchorPoint = Vector2.new(1, 0), Visible = false, Text = ""}) Corner(grade) Stroke(grade)
    Create("UIGradient", grade, {Rotation = 90, Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))})}) local SavePos2 = Create("Frame", grade, {Visible = false, Size = UDim2.new(1, 0, 0, 0)})
    local A_1 = Create("Frame", TextButton, {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 30), Visible = false}) Stroke(A_1)
    local Select1 = Create("Frame", grade, {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 0, select(3, Color3.toHSV(Default))), BackgroundTransparency = 1, Active = true, Draggable = true}) Corner(Select1, {CornerRadius = UDim.new(2, 0)}) Stroke(Select1, {Color = Color3.fromRGB(255, 255, 255)})
    local Select2 = Create("Frame", UI_Grade, {Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(0, select(2, Color3.toHSV(Default)), 0, select(1, Color3.toHSV(Default))), BackgroundTransparency = 1, Active = true, Draggable = true}) Corner(Select2, {CornerRadius = UDim.new(2, 0)}) Stroke(Select2, {Color = Color3.fromRGB(255, 255, 255)})
    UI_Grade.MouseButton1Click:Connect(function() local mouse = UserInputService:GetMouseLocation() local savepos = SavePos.AbsolutePosition CreateTween(Select2, "Position", UDim2.new(0, mouse.X - savepos.X, 0, tonumber(mouse.Y - savepos.Y) - 35), 0.3, false) end)
    grade.MouseButton1Click:Connect(function() local mouse = UserInputService:GetMouseLocation().Y - 35 local savepos = SavePos2.AbsolutePosition.Y CreateTween(Select1, "Position", UDim2.new(0, 0, 0, mouse - savepos), 0.3, false) end)
    local function callback() Callback(Color3.fromHSV(ColorH, ColorS, ColorV)) end
    local function updcolorpicker() ColorH = tonumber(Select1.Position.Y.Offset) / 80 ColorS = tonumber(215 - Select2.Position.X.Offset) / 215 ColorV = tonumber(75 - Select2.Position.Y.Offset) / 75 UI_Grade.ImageColor3 = Color3.fromHSV(ColorH, 1, 1) picker.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV) callback() end
    updcolorpicker()
    Select1.Changed:Connect(function(prop) if prop == "Position" then Select1.Position = UDim2.new(0, 0, 0, math.clamp(Select1.Position.Y.Offset, 0, 80)) updcolorpicker() end end)
    Select2.Changed:Connect(function(prop) if prop == "Position" then Select2.Position = UDim2.new(0, math.clamp(Select2.Position.X.Offset, 0, 222), 0, math.clamp(Select2.Position.Y.Offset, 0, 75)) updcolorpicker() end end)
    TextButton.Changed:Connect(function(prop) if prop == "Size" then if TextButton.Size.Y.Offset >= 60 then picker.Position = UDim2.new(0, 5, 0, 5) UI_Grade.Visible = true A_1.Visible = true grade.Visible = true else picker.Position = UDim2.new(0, 5, 0, 2.5) UI_Grade.Visible = false A_1.Visible = false grade.Visible = false end end end)
    local onoff = false
    click.MouseButton1Click:Connect(function() onoff = not onoff if onoff == true then local tween = TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 140)}) tween:play() tween.Completed:Wait() else local tween = TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 25)}) tween:play() tween.Completed:Wait() end end)
  end

  function AddDropdown(parent, Configs)
    local DropdownName = Configs.Name or "Dropdown!!"
    local Options = Configs.Options or {"1", "2", "3"}
    local Default = Configs.Default or "2"
    local Callback = Configs.Callback or function() end
    local TextButton = Create("TextButton", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame", Text = "", AutoButtonColor = false}) Corner(TextButton) Stroke(TextButton)
    Create("TextLabel", TextButton, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = DropdownName, Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 35, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})
    local Line = Create("Frame", TextButton, {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 25), BorderSizePixel = 0, BackgroundColor3 = Configs_HUB.Cor_Stroke, Visible = false})
    local Arrow = Create("ImageLabel", TextButton, {Image = "rbxassetid://6031090990", Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1})
    local DefaultText = Create("TextLabel", TextButton, {BackgroundColor3 = Configs_HUB.Cor_Hub, BackgroundTransparency = 0.1, Position = UDim2.new(1, -20, 0, 2.5), AnchorPoint = Vector2.new(1, 0), Size = UDim2.new(0, 100, 0, 20), TextColor3 = Configs_HUB.Cor_DarkText, TextScaled = true, Font = Configs_HUB.Text_Font, Text = "..."}) Corner(DefaultText) Stroke(DefaultText)
    local ScrollBar = Create("ScrollingFrame", TextButton, {Size = UDim2.new(1, 0, 1, -25), Position = UDim2.new(0, 0, 0, 25), CanvasSize = UDim2.new(), ScrollingDirection = "Y", AutomaticCanvasSize = "Y", BackgroundTransparency = 1, ScrollBarThickness = 2})
    Create("UIPadding", ScrollBar, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
    Create("UIListLayout", ScrollBar, {Padding = UDim.new(0, 5)})
    local function AddOption(OptionName)
      local TextButton = Create("TextButton", ScrollBar, {Size = UDim2.new(1, 0, 0, 15), Text = OptionName, Font = Configs_HUB.Text_Font, TextSize = 12, TextColor3 = Color3.fromRGB(180, 180, 180), BackgroundTransparency = 1}) Corner(TextButton)
      if OptionName == Default then TextButton.BackgroundTransparency = 0.8 TextButton.TextColor3 = Configs_HUB.Cor_Text DefaultText.Text = OptionName Callback(OptionName) end
      TextButton.MouseButton1Click:Connect(function() for _,v in pairs(ScrollBar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundTransparency = 1 v.TextColor3 = Color3.fromRGB(180, 180, 180) end end DefaultText.Text = OptionName Callback(OptionName) TextButton.BackgroundTransparency = 0.8 TextButton.TextColor3 = Configs_HUB.Cor_Text end)
    end
    for _,v in pairs(Options) do AddOption(v) end
    local DropOnOff = false
    TextButton.MouseButton1Click:Connect(function()
      local OptionSize, OptionsNumber = 25, 0
      for _,v in pairs(ScrollBar:GetChildren()) do if v:IsA("TextButton") and OptionsNumber < 5 then OptionsNumber = OptionsNumber + 1 OptionSize = OptionSize + tonumber(v.Size.Y.Offset + 10) end end
      if not DropOnOff then CreateTween(TextButton, "Size", UDim2.new(1, 0, 0, OptionSize), 0.3, false) CreateTween(Arrow, "Rotation", 180, 0.3, false) DropOnOff = true Line.Visible = true
      else CreateTween(TextButton, "Size", UDim2.new(1, 0, 0, 25), 0.3, false) CreateTween(Arrow, "Rotation", 0, 0.3, true) DropOnOff = false Line.Visible = false end
    end)
    return {ScrollBar, Default, Callback, DefaultText}
  end

  function UpdateDropdown(Dropdown, NewOptions)
    local ScrollBar, Default, Callback, DefaultText = Dropdown[1], Dropdown[2], Dropdown[3], Dropdown[4]
    for _,v in pairs(ScrollBar:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local function AddOption(OptionName)
      local TextButton = Create("TextButton", ScrollBar, {Size = UDim2.new(1, 0, 0, 15), Text = OptionName, Font = Configs_HUB.Text_Font, TextSize = 12, TextColor3 = Color3.fromRGB(180, 180, 180), BackgroundTransparency = 1}) Corner(TextButton)
      if OptionName == Default then TextButton.BackgroundTransparency = 0.8 TextButton.TextColor3 = Configs_HUB.Cor_Text DefaultText.Text = OptionName Callback(OptionName) else DefaultText.Text = "..." end
      TextButton.MouseButton1Click:Connect(function() for _,v in pairs(ScrollBar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundTransparency = 1 v.TextColor3 = Color3.fromRGB(180, 180, 180) end end DefaultText.Text = OptionName Callback(OptionName) TextButton.BackgroundTransparency = 0.8 TextButton.TextColor3 = Configs_HUB.Cor_Text end)
    end
    for _,v in pairs(NewOptions) do AddOption(v) end
  end

  function AddTextLabel(parent, Configs)
    local LabelName = Configs[1] or Configs.Name or "Text Label!!"
    local Frame = Create("Frame", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame"}) Corner(Frame) Stroke(Frame)
    local TextButton = Create("TextButton", Frame, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = LabelName, Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})
    TextSetColor(TextButton)
    return TextButton
  end

  function SetLabel(label, NewValue) label.Text = NewValue end

  function AddImageLabel(parent, Configs)
    local LabelName = Configs[1] or Configs.Name or ""
    local LabelImage = Configs[2] or Configs.Image or "Image Label"
    local Frame = Create("Frame", parent, {Size = UDim2.new(0, 95, 0, 110), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame"}) Corner(Frame) Stroke(Frame)
    Create("TextButton", Frame, {TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = LabelName, Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, Font = Configs_HUB.Text_Font})
    local ImageLabel = Create("ImageLabel", Frame, {Image = LabelImage, Size = UDim2.new(0, 75, 0, 75), Position = UDim2.new(0, 10, 0, 25)})
    return ImageLabel
  end

  function SetImage(label, NewImage) label.Image = NewImage end

  function AddParagraph(parent, Configs)
    local ParagraphName1 = Configs[1] or Configs.Title or "Paragraph!!"
    local ParagraphName2 = Configs[1] or Configs.Text or "Paragraph!!"
    local Frame = Create("Frame", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Options, Name = "Frame", AutomaticSize = "Y"}) Corner(Frame) Stroke(Frame)
    Create("UIListLayout", Frame) Create("UIPadding", Frame, {PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
    local TextButton = Create("TextButton", Frame, {Name = "Frame", TextSize = 12, TextColor3 = Configs_HUB.Cor_Text, Text = ParagraphName1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = "Y", BackgroundTransparency = 1, TextXAlignment = "Left", TextYAlignment = "Top", Font = Configs_HUB.Text_Font, TextWrapped = true}) TextSetColor(TextButton)
    local TextLabel = Create("TextLabel", Frame, {Name = "Frame", Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = "Y", TextXAlignment = "Left", TextYAlignment = "Top", TextColor3 = Configs_HUB.Cor_DarkText, TextSize = 11, Text = ParagraphName2, Font = Configs_HUB.Text_Font, TextWrapped = true})
    return {TextButton, TextLabel}
  end

return Menu, MakeTab, AddToggle, AddButton, AddSlider, AddDropdown, AddTextLabel -- TUTUP MAKEWINDOW
end

-- ==========================================
-- FUNGSI TAMBAHAN REDZ (DI LUAR MAKEWINDOW)
-- ==========================================
function AddSection(parent, Configs)
  local SectionName = Configs.Name or Configs[1] or "Section!!"
  local Frame = Create("Frame", parent, {Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Configs_HUB.Cor_Hub, Name = "Frame", Transparency = 1}) Corner(Frame)
  Create("TextButton", Frame, {TextSize = 12, TextColor3 = Configs_HUB.Cor_DarkText, Text = string.upper(SectionName), Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextXAlignment = "Left", Font = Configs_HUB.Text_Font})
  return Frame
end

-- [[ PART 3: INISIALISASI WINDOW & KABEL SAMBUNGAN TERAKHIR ]]

-- 1. Nyalakan UI Redz Hub (Ubah judulnya sesuka lu)
local Menu, MakeTab, AddToggle, AddButton, AddSlider, AddDropdown, AddTextLabel = MakeWindow({
    Hub = {
        Title = "CatHUB | Blox Fruits",
        Animation = "by : CatHUB"
    }
})

-- 2. Theme Wajib (Buat X-Ray manual di Status.lua lu biar kaga error warna putih)
local Theme = {
    CardBG = Color3.fromRGB(30, 30, 30),
    SideBG = Color3.fromRGB(40, 40, 40),
    Line   = Color3.fromRGB(60, 60, 60),
    Text   = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 150),
    CatPurple = Color3.fromRGB(170, 85, 255)
}

-- 3. KABEL SAMBUNGAN (Menerjemahkan bahasa lama CatHUB ke bahasa Redz)
_G.Cat.UI = {
    Theme = Theme,
    SaveSettings = SaveSettings,
    
    CreateTab = function(name, isFirst)
        -- Redz otomatis handle tab pertama, jadi parameter 'isFirst' kita abaikan
        return MakeTab({Name = name})
    end,
    
    CreateSection = function(parent, text)
        return AddSection(parent, {Name = text})
    end,
    
    CreateToggle = function(parent, text, desc, stateRef, callback)
        -- Redz tidak pakai deskripsi toggle, jadi kita abaikan 'desc'
        local wrappedCallback = function(state)
            if callback then callback(state) end
            SaveSettings() -- Otomatis save setiap kali toggle diklik
        end
        return AddToggle(parent, {
            Name = text,
            Default = stateRef or false,
            Callback = wrappedCallback
        })
    end,
    
    CreateLabel = function(parent, text, desc)
        -- AddTextLabel Redz mengembalikan TextButton yang punya .Text
        -- Ini SANGAT PENTING supaya _G.Cat.Labels.Fruits.Text = "..." tetap bisa jalan
        return AddTextLabel(parent, {text})
    end
}

warn("[CatHUB] 100% Pure Redz UI Successfully Integrated!")