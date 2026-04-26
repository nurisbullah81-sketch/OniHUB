-- CatHUB v13.0 SUPREME: Global Search, English UI, Fixed Resizer, Dark Modern BG
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CatUI") then 
    CoreGui.CatUI:Destroy() 
end

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ==========================================
-- PALETTE: MODERN DARK (17, 18, 22)
-- ==========================================
local Theme = {
    MainBG      = Color3.fromRGB(10, 10, 10),   
    SideBG      = Color3.fromRGB(14, 14, 16),   
    TopBG       = Color3.fromRGB(10, 10, 10),
    TabOn       = Color3.fromRGB(38, 38, 42),   
    TabOff      = Color3.fromRGB(14, 14, 16),   
    PageBG      = Color3.fromRGB(17, 18, 22), -- WARNA HITAM ABU MODERN LU
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

-- ==========================================
-- WIDGET "Cat" (FIX: ALL-DIRECTION DRAG)
-- ==========================================
local FloatCont = Instance.new("Frame", Gui)
FloatCont.Size = UDim2.new(0, 65, 0, 65) 
FloatCont.Position = UDim2.new(0, 20, 0.5, -32)
FloatCont.BackgroundTransparency = 1
FloatCont.ZIndex = 99999 

local FloatBtn = Instance.new("TextButton", FloatCont)
FloatBtn.Size = UDim2.new(0, 45, 0, 45)
FloatBtn.Position = UDim2.new(0.5, -22, 0.5, -22)
FloatBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FloatBtn.BackgroundTransparency = 0.3
FloatBtn.Text = "Cat"
FloatBtn.TextColor3 = Theme.CatPurple 
FloatBtn.Font = Enum.Font.GothamBold 
FloatBtn.TextSize = 16
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatBtn).Color = Theme.Line

local dragFloat = false
local dragStartF, startPosF
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragFloat = true; dragStartF = input.Position; startPosF = FloatCont.Position
    end
end)
UserInput.InputChanged:Connect(function(input)
    if dragFloat and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartF
        FloatCont.Position = UDim2.new(startPosF.X.Scale, startPosF.X.Offset + delta.X, startPosF.Y.Scale, startPosF.Y.Offset + delta.Y)
    end
end)
FloatBtn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragFloat = false end end)

-- ==========================================
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 550, 0, 340)
Main.Position = UDim2.new(0.5, -275, 0.5, -170)
Main.BackgroundColor3 = Theme.MainBG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true 
Main.Visible = true 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", Main).Color = Theme.Line

FloatBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Topbar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35); Top.BackgroundColor3 = Theme.TopBG; Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 6)

local TitleCont = Instance.new("Frame", Top)
TitleCont.Size = UDim2.new(0, 400, 1, 0); TitleCont.Position = UDim2.new(0, 15, 0, 0); TitleCont.BackgroundTransparency = 1
local TitleList = Instance.new("UIListLayout", TitleCont); TitleList.FillDirection = "Horizontal"; TitleList.VerticalAlignment = "Center"; TitleList.Padding = UDim.new(0, 5)

local function AddTitle(t, c, f)
    local l = Instance.new("TextLabel", TitleCont); l.Text = t; l.TextColor3 = c; l.Font = f; l.TextSize = 13; l.BackgroundTransparency = 1; l.AutomaticSize = "XY"
end
AddTitle("CatHUB", Theme.CatPurple, "GothamBold")
AddTitle("Blox Fruits", Theme.Text, "GothamMedium")
AddTitle("[Freemium]", Theme.Gold, "GothamMedium")

local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 35, 0, 35); BtnX.Position = UDim2.new(1, -35, 0, 0); BtnX.Text = "X"; BtnX.TextColor3 = Theme.TextDim; BtnX.BackgroundTransparency = 1; BtnX.Font = "GothamBold"
BtnX.MouseButton1Click:Connect(function() Main.Visible = false end)

-- ==========================================
-- RESIZER (FIXED: GET MOUSE LOCATION)
-- ==========================================
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 20, 0, 20); Resizer.Position = UDim2.new(1, -20, 1, -20); Resizer.BackgroundTransparency = 1; Resizer.Text = "⌟"; Resizer.TextColor3 = Theme.TextDim; Resizer.ZIndex = 100

local resizing = false
local resStartSize, resStartPos
Resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true; resStartPos = UserInput:GetMouseLocation(); resStartSize = Main.Size
    end
end)
UserInput.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = UserInput:GetMouseLocation()
        local delta = mouse - resStartPos
        Main.Size = UDim2.new(0, math.clamp(resStartSize.X.Offset + delta.X, 480, 950), 0, math.clamp(resStartSize.Y.Offset + delta.Y, 280, 750))
    end
end)
UserInput.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end end)

-- ==========================================
-- SIDEBAR, SEARCH & PAGES
-- ==========================================
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 150, 1, -35); Side.Position = UDim2.new(0, 0, 0, 35); Side.BackgroundColor3 = Theme.SideBG; Side.BorderSizePixel = 0

local SearchFrame = Instance.new("Frame", Side)
SearchFrame.Size = UDim2.new(1, -16, 0, 28); SearchFrame.Position = UDim2.new(0, 8, 0, 10); SearchFrame.BackgroundColor3 = Theme.CardBG
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 6)
local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Size = UDim2.new(1, -10, 1, 0); SearchBox.Position = UDim2.new(0, 5, 0, 0); SearchBox.BackgroundTransparency = 1; SearchBox.PlaceholderText = "Search..."; SearchBox.Text = ""; SearchBox.TextColor3 = Theme.Text; SearchBox.TextSize = 12; SearchBox.Font = "Gotham"

local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Size = UDim2.new(1, 0, 1, -50); SideScroll.Position = UDim2.new(0, 0, 0, 45); SideScroll.BackgroundTransparency = 1; SideScroll.ScrollBarThickness = 0
local SideList = Instance.new("UIListLayout", SideScroll); SideList.Padding = UDim.new(0, 4); SideList.HorizontalAlignment = "Center"

local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -150, 1, -35); ContentArea.Position = UDim2.new(0, 150, 0, 35); ContentArea.BackgroundTransparency = 1

local Pages = {}
local AllFitur = {}
local lastTab = "Status"

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", SideScroll)
    Btn.Size = UDim2.new(0.9, 0, 0, 32); Btn.BackgroundColor3 = isFirst and Theme.TabOn or Theme.TabOff; Btn.Text = "  " .. name; Btn.TextColor3 = Theme.Text; Btn.Font = "GothamMedium"; Btn.TextSize = 12; Btn.AutoButtonColor = false; Btn.TextXAlignment = "Left"
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Btn).Color = Theme.Line
    
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, -16, 1, -16); Page.Position = UDim2.new(0, 8, 0, 8); Page.BackgroundColor3 = Theme.PageBG; Page.Visible = isFirst; Page.ScrollBarThickness = 0; Page.BorderSizePixel = 0
    Instance.new("UICorner", Page).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Page).Color = Theme.Line
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 6)
    Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 10); Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0, 10); Instance.new("UIPadding", Page).PaddingRight = UDim.new(0, 10)

    Pages[name] = {Btn = Btn, Page = Page}
    Btn.MouseButton1Click:Connect(function()
        lastTab = name
        for k, v in pairs(Pages) do v.Page.Visible = (k == name); v.Btn.BackgroundColor3 = (k == name) and Theme.TabOn or Theme.TabOff end
    end)
    return Page
end

-- ==========================================
-- SEARCH PAGE (GLOBAL RESULTS)
-- ==========================================
local SearchPage = CreateTab("Search Results", false)
Pages["Search Results"].Btn.Visible = false -- Sembunyiin tombol search results di sidebar

local function CreateToggle(parent, tabName, text, callback)
    local F = Instance.new("TextButton", parent)
    F.Size = UDim2.new(1, 0, 0, 36); F.BackgroundColor3 = Theme.CardBG; F.Text = ""; F.AutoButtonColor = false
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, -50, 1, 0); L.Position = UDim2.new(0, 12, 0, 0); L.Text = text; L.TextColor3 = Theme.Text; L.Font = "Gotham"; L.TextSize = 12; L.BackgroundTransparency = 1; L.TextXAlignment = "Left"
    local Sw = Instance.new("Frame", F); Sw.Size = UDim2.new(0, 34, 0, 18); Sw.Position = UDim2.new(1, -44, 0.5, -9); Sw.BackgroundColor3 = Theme.ToggleOff
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame", Sw); Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    local state = false
    F.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        callback(state)
    end)
    table.insert(AllFitur, {Obj = F, Name = text:lower(), Tab = tabName, Label = L})
end

-- GLOBAL SEARCH LOGIC
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local s = SearchBox.Text:lower()
    if s ~= "" then
        Pages["Search Results"].Btn.MouseButton1Click:Fire()
        for _, v in pairs(AllFitur) do
            if v.Name:find(s) then
                v.Obj.Parent = Pages["Search Results"].Page
                v.Obj.Visible = true
            else
                v.Obj.Visible = false
            end
        end
    else
        Pages[lastTab].Btn.MouseButton1Click:Fire()
        for _, v in pairs(AllFitur) do
            v.Obj.Parent = Pages[v.Tab].Page
            v.Obj.Visible = true
        end
    end
end)

-- ==========================================
-- BUILD INTERFACE (ENGLISH)
-- ==========================================
local Status = CreateTab("Status", true)
local Fruits = CreateTab("Devil Fruits", false)
local Misc = CreateTab("Misc", false)

CreateToggle(Status, "Status", "Show Player Stats", function() end)
CreateToggle(Fruits, "Devil Fruits", "Fruit ESP (Text Only)", function() end)
CreateToggle(Misc, "Misc", "Auto Rejoin", function() end)
CreateToggle(Misc, "Misc", "Anti-AFK System", function() end)

-- Drag Main
local dragM = false; local dragSM, startPM
Top.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragM = true; dragSM = UserInput:GetMouseLocation(); startPM = Main.Position end end)
UserInput.InputChanged:Connect(function(input) if dragM and input.UserInputType == Enum.UserInputType.MouseMovement then local d = UserInput:GetMouseLocation() - dragSM; Main.Position = UDim2.new(startPM.X.Scale, startPM.X.Offset + d.X, startPM.Y.Scale, startPM.Y.Offset + delta.Y); Main.Position = UDim2.new(startPM.X.Scale, startPM.X.Offset + d.X, startPM.Y.Scale, startPM.Y.Offset + d.Y) end end)
UserInput.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragM = false end end)