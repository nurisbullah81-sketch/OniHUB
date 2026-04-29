-- CatHUB vFINAL PREMIUM: English UI, Search Bar, Dark Inner BG, Fixed Resizer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then 
    CoreGui.CatUI:Destroy() 
end

if not _G.Cat then
    _G.Cat = {
        Player = game:GetService("Players").LocalPlayer,
        Settings = { 
            FruitESP = false, 
            TweenFruit = false,
            AutoStoreFruit = false,
            AutoHop = false,
            AntiAFK = true
        },
        Labels = {}
    }
else
    _G.Cat.Player = game:GetService("Players").LocalPlayer
    if not _G.Cat.Labels then _G.Cat.Labels = {} end
end

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Theme = {
    MainBG      = Color3.fromRGB(10, 10, 10),   
    SideBG      = Color3.fromRGB(14, 14, 16),   
    TopBG       = Color3.fromRGB(10, 10, 10),
    TabOn       = Color3.fromRGB(38, 38, 42),   
    TabOff      = Color3.fromRGB(25, 25, 30), 
    PageBG      = Color3.fromRGB(17, 18, 22),   
    CardBG      = Color3.fromRGB(28, 28, 32),   
    CardHov     = Color3.fromRGB(36, 36, 42),
    Text        = Color3.fromRGB(250, 250, 250),
    TextDim     = Color3.fromRGB(140, 140, 145),
    ToggleOn    = Color3.fromRGB(138, 43, 226), 
    ToggleOff   = Color3.fromRGB(75, 75, 80),
    CatPurple   = Color3.fromRGB(160, 100, 255),
    Gold        = Color3.fromRGB(255, 200, 50), 
    Accent      = Color3.fromRGB(138, 43, 226), 
    Line        = Color3.fromRGB(40, 40, 45)    
}

local FloatCont = Instance.new("Frame", Gui)
FloatCont.Size = UDim2.new(0, 70, 0, 40) 
FloatCont.Position = UDim2.new(0, 20, 0.5, -20)
FloatCont.BackgroundTransparency = 1
FloatCont.ZIndex = 99999 

local FloatBtn = Instance.new("TextButton", FloatCont)
FloatBtn.Size = UDim2.new(0, 40, 1, 0)
FloatBtn.Position = UDim2.new(0, 30, 0, 0) 
FloatBtn.BackgroundColor3 = Theme.CardBG
FloatBtn.Text = "Cat"
FloatBtn.TextColor3 = Theme.CatPurple 
FloatBtn.Font = Enum.Font.GothamBold 
FloatBtn.TextSize = 16
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 8)
local FloatStroke = Instance.new("UIStroke", FloatBtn)
FloatStroke.Color = Theme.Line

local FloatDrag = Instance.new("TextButton", FloatCont)
FloatDrag.Size = UDim2.new(0, 30, 1, 0)
FloatDrag.Position = UDim2.new(0, 0, 0, 0)
FloatDrag.BackgroundTransparency = 1 
FloatDrag.Text = ""

local draggingFloat, dragStartFloat, startPosFloat
FloatDrag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFloat = true; dragStartFloat = input.Position; startPosFloat = FloatCont.Position
    end
end)
FloatDrag.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingFloat = false end end)
UserInput.InputChanged:Connect(function(input)
    if draggingFloat and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartFloat
        FloatCont.Position = UDim2.new(startPosFloat.X.Scale, startPosFloat.X.Offset + delta.X, startPosFloat.Y.Scale, startPosFloat.Y.Offset + delta.Y)
    end
end)

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 550, 0, 340)
Main.Position = UDim2.new(0.5, -275, 0.5, -170)
Main.BackgroundColor3 = Theme.MainBG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true 
Main.Visible = true 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.Line
MainStroke.Thickness = 1

FloatBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = Theme.TopBG
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 6)

local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 10)
TopFix.Position = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3 = Theme.TopBG
TopFix.BorderSizePixel = 0

local TitleContainer = Instance.new("Frame", Top)
TitleContainer.Size = UDim2.new(0, 350, 1, 0)
TitleContainer.Position = UDim2.new(0, 15, 0, 0)
TitleContainer.BackgroundTransparency = 1

local TitleList = Instance.new("UIListLayout", TitleContainer)
TitleList.FillDirection = Enum.FillDirection.Horizontal
TitleList.VerticalAlignment = Enum.VerticalAlignment.Center
TitleList.Padding = UDim.new(0, 4) 

local function CreateTitlePart(text, color, font)
    local label = Instance.new("TextLabel", TitleContainer)
    label.Text = text; label.TextColor3 = color; label.Font = font; label.TextSize = 13; label.BackgroundTransparency = 1; label.AutomaticSize = Enum.AutomaticSize.XY
end

CreateTitlePart("CatHUB", Theme.CatPurple, Enum.Font.GothamBold) 
CreateTitlePart("Blox Fruits", Theme.Text, Enum.Font.GothamMedium)
CreateTitlePart("[Freemium]", Theme.Gold, Enum.Font.GothamMedium) 

local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 35, 0, 35); BtnX.Position = UDim2.new(1, -35, 0, 0); BtnX.Text = "X"; BtnX.TextColor3 = Theme.TextDim; BtnX.BackgroundTransparency = 1; BtnX.Font = Enum.Font.Gotham; BtnX.TextSize = 15; BtnX.AutoButtonColor = false
local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 35, 0, 35); BtnM.Position = UDim2.new(1, -70, 0, 0); BtnM.Text = "—"; BtnM.TextColor3 = Theme.TextDim; BtnM.BackgroundTransparency = 1; BtnM.Font = Enum.Font.GothamBold; BtnM.TextSize = 13; BtnM.AutoButtonColor = false

BtnX.MouseEnter:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play() end)
BtnX.MouseLeave:Connect(function() TweenService:Create(BtnX, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play() end)
BtnM.MouseEnter:Connect(function() TweenService:Create(BtnM, TweenInfo.new(0.15), {TextColor3 = Theme.Text}):Play() end)
BtnM.MouseLeave:Connect(function() TweenService:Create(BtnM, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play() end)

BtnX.MouseButton1Click:Connect(function() Main.Visible = false end)

local isMin = false
local lastSize = Main.Size
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then lastSize = Main.Size; TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, Main.Size.X.Offset, 0, 35)}):Play()
    else TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = lastSize}):Play() end
end)

local draggingMain, dragStartMain, startPosMain
Top.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingMain = true; dragStartMain = input.Position; startPosMain = Main.Position end end)
Top.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingMain = false end end)
UserInput.InputChanged:Connect(function(input)
    if draggingMain and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStartMain; Main.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y) end
end)

local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 20, 0, 20); Resizer.Position = UDim2.new(1, -20, 1, -20); Resizer.BackgroundTransparency = 1; Resizer.Text = "⌟"; Resizer.TextColor3 = Theme.TextDim; Resizer.TextSize = 16; Resizer.Font = Enum.Font.Gotham; Resizer.ZIndex = 50; Resizer.AutoButtonColor = false
local isResizing, resizeStartPos, startSizeR
Resizer.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 and not isMin then isResizing = true; resizeStartPos = UserInput:GetMouseLocation(); startSizeR = Main.Size end end)
UserInput.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end end)
UserInput.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = UserInput:GetMouseLocation() - resizeStartPos; Main.Size = UDim2.new(0, math.clamp(startSizeR.X.Offset + delta.X, 480, 900), 0, math.clamp(startSizeR.Y.Offset + delta.Y, 280, 700)); lastSize = Main.Size end
end)

local ContentContainer = Instance.new("Frame", Main)
ContentContainer.Size = UDim2.new(1, 0, 1, -35); ContentContainer.Position = UDim2.new(0, 0, 0, 35); ContentContainer.BackgroundTransparency = 1
local Side = Instance.new("Frame", ContentContainer)
Side.Size = UDim2.new(0.28, 0, 1, 0); Side.BackgroundColor3 = Theme.SideBG; Side.BorderSizePixel = 0
local SideLine = Instance.new("Frame", Side)
SideLine.Size = UDim2.new(0, 1, 1, 0); SideLine.Position = UDim2.new(1, -1, 0, 0); SideLine.BackgroundColor3 = Theme.Line; SideLine.BorderSizePixel = 0

local SearchFrame = Instance.new("Frame", Side)
SearchFrame.Size = UDim2.new(1, -16, 0, 30); SearchFrame.Position = UDim2.new(0, 8, 0, 10); SearchFrame.BackgroundColor3 = Theme.CardBG; SearchFrame.BorderSizePixel = 0
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", SearchFrame).Color = Theme.Line
local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Size = UDim2.new(1, -16, 1, 0); SearchBox.Position = UDim2.new(0, 8, 0, 0); SearchBox.BackgroundTransparency = 1; SearchBox.Text = ""; SearchBox.PlaceholderText = "Search..."; SearchBox.TextColor3 = Theme.Text; SearchBox.PlaceholderColor3 = Theme.TextDim; SearchBox.Font = Enum.Font.GothamMedium; SearchBox.TextSize = 12; SearchBox.TextXAlignment = Enum.TextXAlignment.Left

local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Size = UDim2.new(1, 0, 1, -50); SideScroll.Position = UDim2.new(0, 0, 0, 50); SideScroll.BackgroundTransparency = 1; SideScroll.ScrollBarThickness = 0; SideScroll.BorderSizePixel = 0
local SideList = Instance.new("UIListLayout", SideScroll); SideList.Padding = UDim.new(0, 4)
local SidePad = Instance.new("UIPadding", SideScroll); SidePad.PaddingLeft = UDim.new(0, 8); SidePad.PaddingRight = UDim.new(0, 8)

local ContentArea = Instance.new("Frame", ContentContainer)
ContentArea.Size = UDim2.new(0.72, 0, 1, 0); ContentArea.Position = UDim2.new(0.28, 0, 0, 0); ContentArea.BackgroundTransparency = 1

local Pages = {}
local AllToggles = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", SideScroll)
    Btn.Size = UDim2.new(1, 0, 0, 32); Btn.BackgroundColor3 = isFirst and Theme.TabOn or Theme.TabOff; Btn.Text = "    " .. name; Btn.TextColor3 = isFirst and Theme.Text or Theme.TextDim; Btn.Font = Enum.Font.GothamMedium; Btn.TextSize = 12; Btn.BorderSizePixel = 0; Btn.TextXAlignment = Enum.TextXAlignment.Left; Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local BtnStroke = Instance.new("UIStroke", Btn); BtnStroke.Color = Color3.fromRGB(65, 65, 70); BtnStroke.Thickness = 1; BtnStroke.Transparency = isFirst and 0 or 0.3 
    local Indicator = Instance.new("Frame", Btn)
    Indicator.Size = UDim2.new(0, 3, 0, 14); Indicator.Position = UDim2.new(0, 4, 0.5, -7); Indicator.BackgroundColor3 = Theme.Accent; Indicator.BorderSizePixel = 0
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0); Indicator.Visible = isFirst
    
    Btn.MouseEnter:Connect(function() if not Indicator.Visible then TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardHov}):Play() end end)
    Btn.MouseLeave:Connect(function() if not Indicator.Visible then TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabOff}):Play() end end)
    
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, -16, 1, -16); Page.Position = UDim2.new(0, 8, 0, 8); Page.BackgroundColor3 = Theme.PageBG; Page.BackgroundTransparency = 0; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.TextDim; Page.Visible = isFirst; Page.BorderSizePixel = 0
    Instance.new("UICorner", Page).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Page).Color = Theme.Line
    local List = Instance.new("UIListLayout", Page); List.Padding = UDim.new(0, 6)
    local Pad = Instance.new("UIPadding", Page); Pad.PaddingTop = UDim.new(0, 10); Pad.PaddingLeft = UDim.new(0, 10); Pad.PaddingRight = UDim.new(0, 14); Pad.PaddingBottom = UDim.new(0, 10)
    
    Pages[name] = {Btn = Btn, Page = Page, Ind = Indicator, Stroke = BtnStroke}
    Btn.MouseButton1Click:Connect(function()
        for tName, data in pairs(Pages) do local active = (tName == name); data.Page.Visible = active; data.Ind.Visible = active
            TweenService:Create(data.Btn, TweenInfo.new(0.15), {BackgroundColor3 = active and Theme.TabOn or Theme.TabOff, TextColor3 = active and Theme.Text or Theme.TextDim}):Play()
            TweenService:Create(data.Stroke, TweenInfo.new(0.15), {Transparency = active and 0 or 0.3}):Play()
        end
    end)
    return Page
end

local function CreateSection(parent, text)
    local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, 24); F.BackgroundTransparency = 1
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 1, 0); L.Position = UDim2.new(0, 4, 0, 0); L.Text = text; L.TextColor3 = Theme.TextDim; L.Font = Enum.Font.GothamBold; L.TextSize = 11; L.TextXAlignment = Enum.TextXAlignment.Left; L.BackgroundTransparency = 1
end

local function CreateToggle(parent, text, description, stateRef, callback)
    local frameHeight = description and 52 or 36
    local F = Instance.new("TextButton", parent); F.Size = UDim2.new(1, 0, 0, frameHeight); F.BackgroundColor3 = Theme.CardBG; F.BorderSizePixel = 0; F.Text = ""; F.AutoButtonColor = false
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", F).Color = Theme.Line
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, -60, 0, 20); L.Position = UDim2.new(0, 12, 0, description and 6 or 8); L.Text = text; L.TextColor3 = Theme.Text; L.Font = Enum.Font.GothamMedium; L.TextSize = 12; L.TextXAlignment = Enum.TextXAlignment.Left; L.BackgroundTransparency = 1
    if description then local D = Instance.new("TextLabel", F); D.Size = UDim2.new(1, -60, 0, 14); D.Position = UDim2.new(0, 12, 0, 26); D.Text = description; D.TextColor3 = Theme.TextDim; D.Font = Enum.Font.Gotham; D.TextSize = 10; D.TextXAlignment = Enum.TextXAlignment.Left; D.BackgroundTransparency = 1 end
    local Sw = Instance.new("Frame", F); Sw.Size = UDim2.new(0, 36, 0, 18); Sw.Position = UDim2.new(1, -48, 0.5, -9); Sw.BackgroundColor3 = stateRef and Theme.Accent or Theme.ToggleOff; Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0) 
    local Dot = Instance.new("Frame", Sw); Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0) 
    
    F.MouseEnter:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardHov}):Play() end)
    F.MouseLeave:Connect(function() TweenService:Create(F, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardBG}):Play() end)
    F.MouseButton1Click:Connect(function()
        stateRef = not stateRef
        TweenService:Create(Sw, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = stateRef and Theme.Accent or Theme.ToggleOff}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        if callback then callback(stateRef) end
    end)
    table.insert(AllToggles, {Btn = F, Label = L})
end

local function CreateLabel(parent, text, description)
    local frameHeight = description and 45 or 30
    local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, frameHeight); F.BackgroundColor3 = Theme.CardBG; F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", F).Color = Theme.Line
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, -20, 0, 20); L.Position = UDim2.new(0, 12, 0, description and 4 or 5); L.Text = text; L.TextColor3 = Theme.Text; L.Font = Enum.Font.GothamMedium; L.TextSize = 12; L.TextXAlignment = Enum.TextXAlignment.Left; L.BackgroundTransparency = 1
    if description then local D = Instance.new("TextLabel", F); D.Size = UDim2.new(1, -20, 0, 14); D.Position = UDim2.new(0, 12, 0, 22); D.Text = description; D.TextColor3 = Theme.TextDim; D.Font = Enum.Font.Gotham; D.TextSize = 10; D.TextXAlignment = Enum.TextXAlignment.Left; D.BackgroundTransparency = 1 end
    return L
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchBox.Text)
    for _, toggle in ipairs(AllToggles) do local text = string.lower(toggle.Label.Text); toggle.Btn.Visible = query == "" or string.find(text, query) ~= nil end
end)

-- Di bagian atas UI lu, tambahin ini biar setting ga nil
if _G.Cat.Settings.AutoAttack == nil then _G.Cat.Settings.AutoAttack = false end
if _G.Cat.Settings.WebhookEnabled == nil then _G.Cat.Settings.WebhookEnabled = false end
if _G.Cat.Settings.WebhookURL == nil then _G.Cat.Settings.WebhookURL = "" end

-- ==========================================
-- BUILD TABS & ISI KONTEN (URUTAN BARU)
-- ==========================================
local StatusTab = CreateTab("Status", true) 
local AutoFarmTab = CreateTab("Auto Farm", false) -- TAB BARU DI ATAS DEVIL FRUITS
local DevilFruitsTab = CreateTab("Devil Fruits", false) 
local MiscTab = CreateTab("Misc", false) 

-- STATUS TAB
CreateSection(StatusTab, "PLAYER STATUS")
_G.Cat.Labels.Level = CreateLabel(StatusTab, "Level: ...", "Current level progress")
_G.Cat.Labels.Money = CreateLabel(StatusTab, "Money: ...", "In-game currency balance")
_G.Cat.Labels.Fragments = CreateLabel(StatusTab, "Fragments: ...", "Used for awakening")
_G.Cat.Labels.Bounty = CreateLabel(StatusTab, "Bounty/Honor: ...", "PvP score tracking")

CreateSection(StatusTab, "SERVER STATUS")
_G.Cat.Labels.Players = CreateLabel(StatusTab, "Players: ...", "Currently in this server")
_G.Cat.Labels.Time = CreateLabel(StatusTab, "Time: ...", "In-game day/night cycle")
_G.Cat.Labels.Moon = CreateLabel(StatusTab, "Moon: ...", "Affects certain bosses & events")
_G.Cat.Labels.Fruits = CreateLabel(StatusTab, "Spawned Fruits: 0", "Devil fruits on the map")

-- AUTO FARM TAB (ISINYA COMBAT DOANG)
CreateSection(AutoFarmTab, "COMBAT SYSTEM")
CreateToggle(AutoFarmTab, "Auto Attack", "Automatically swing weapon / fight", _G.Cat.Settings.AutoAttack, function(state) _G.Cat.Settings.AutoAttack = state end)

-- DEVIL FRUITS TAB (MURNI BUAH)
CreateSection(DevilFruitsTab, "FRUIT FINDER")
CreateToggle(DevilFruitsTab, "Fruit ESP", "Show text on any spawned fruits", _G.Cat.Settings.FruitESP, function(state) _G.Cat.Settings.FruitESP = state end)
CreateToggle(DevilFruitsTab, "Tween to Fruits", "Smoothly fly to collect fruits", _G.Cat.Settings.TweenFruit, function(state) _G.Cat.Settings.TweenFruit = state end)
CreateToggle(DevilFruitsTab, "Auto Store Fruits", "Store collected fruits to inventory", _G.Cat.Settings.AutoStoreFruit, function(state) _G.Cat.Settings.AutoStoreFruit = state end)
CreateToggle(DevilFruitsTab, "Auto Hop Server", "Hop if no fruits or inventory full", _G.Cat.Settings.AutoHop, function(state) _G.Cat.Settings.AutoHop = state end)

-- MISC TAB (WEBHOOK PINDAH KESINI)
CreateToggle(MiscTab, "Anti AFK", "Prevents 20-minute idle kick", _G.Cat.Settings.AntiAFK, function(state) _G.Cat.Settings.AntiAFK = state end)

CreateSection(MiscTab, "NETWORK SCANNER (MYTHICAL HUNTER)")
CreateToggle(MiscTab, "Mythical Webhook", "Send JobID to Discord when found", _G.Cat.Settings.WebhookEnabled, function(state) _G.Cat.Settings.WebhookEnabled = state end)

-- Input Box Webhook URL
local WebhookFrame = Instance.new("Frame", MiscTab)
WebhookFrame.Size = UDim2.new(1, 0, 0, 36); WebhookFrame.BackgroundColor3 = Theme.CardBG; WebhookFrame.BorderSizePixel = 0
Instance.new("UICorner", WebhookFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WebhookFrame).Color = Theme.Line
local WebhookBox = Instance.new("TextBox", WebhookFrame)
WebhookBox.Size = UDim2.new(1, -16, 1, 0); WebhookBox.Position = UDim2.new(0, 8, 0, 0); WebhookBox.BackgroundTransparency = 1
WebhookBox.Text = _G.Cat.Settings.WebhookURL ~= "" and _G.Cat.Settings.WebhookURL or "Paste Discord Webhook URL here..."
WebhookBox.TextColor3 = Theme.Text; WebhookBox.PlaceholderText = "Paste Discord Webhook URL here..."; WebhookBox.PlaceholderColor3 = Theme.TextDim
WebhookBox.Font = Enum.Font.GothamMedium; WebhookBox.TextSize = 11; WebhookBox.TextXAlignment = Enum.TextXAlignment.Left; WebhookBox.ClearTextOnFocus = false
WebhookBox.FocusLost:Connect(function() _G.Cat.Settings.WebhookURL = WebhookBox.Text end)