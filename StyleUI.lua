-- [[ ==========================================
--      CATHUB PREMIUM: MODULAR UI FRAMEWORK
--    ========================================== ]]

-- // Services
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput    = game:GetService("UserInputService")
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")

-- // UI Cleanup (Anti-Duplicate)
if CoreGui:FindFirstChild("CatUI") then
    CoreGui.CatUI:Destroy()
end

-- ==========================================
-- 1. SYSTEM CONFIGURATION
-- ==========================================

local ConfigFile = "CatHUB_Config.json"

-- // Global Initialization
_G.Cat        = _G.Cat or {}
_G.Cat.Player = Players.LocalPlayer
_G.Cat.Labels = _G.Cat.Labels or {}

-- // Settings Protection
if not _G.Cat.Settings then
    _G.Cat.Settings = {}
end

-- ==========================================
-- 2. UTILITY FUNCTIONS
-- ==========================================

-- // Function: Save Settings
local function SaveSettings()
    pcall(function()
        local settings = _G.Cat.Settings
        local payload  = HttpService:JSONEncode(settings)
        writefile(ConfigFile, payload)
    end)
end

-- Export Global
_G.Cat.SaveSettings = SaveSettings

-- ==========================================
-- 3. UI RENDERING: ROOT ELEMENTS
-- ==========================================

-- // Main Screen Container
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name           = "CatUI"
Gui.ResetOnSpawn   = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- //! Pengaturan Warna UI
local Theme = {
    -- Background
    MainBG = Color3.fromRGB(19, 19, 19), -- !background tengah kanan
    SideBG = Color3.fromRGB(24, 24, 24),
    TopBG  = Color3.fromRGB(17, 17, 17),
    PageBG = Color3.fromRGB(12, 0, 36),

    -- Navigation
    TabOn   = Color3.fromRGB(255, 0, 0),
    TabOff  = Color3.fromRGB(0, 68, 255),
    CardBG  = Color3.fromRGB(0, 255, 42),
    CardHov = Color3.fromRGB(204, 0, 255),

    -- Typography
    Text    = Color3.fromRGB(250, 250, 250),
    TextDim = Color3.fromRGB(140, 140, 145),

    -- Accents
    ToggleOn  = Color3.fromRGB(132, 0, 255),
    ToggleOff = Color3.fromRGB(37, 37, 37),
    CatPurple = Color3.fromRGB(160, 100, 255),
    Gold      = Color3.fromRGB(255, 187, 0),
    Accent    = Color3.fromRGB(132, 0, 255),
    Line      = Color3.fromRGB(31, 31, 34)
}

-- Export Theme
_G.Cat.Theme = Theme

-- [[ ==========================================
--      FLOATING BUTTON (MOBILE/PC TOGGLE)
--    ========================================== ]]

-- // 1. MAIN CONTAINER
local FloatCont = Instance.new("Frame", Gui)
FloatCont.Name                  = "FloatContainer"
FloatCont.Size                  = UDim2.new(0, 70, 0, 40)
FloatCont.Position              = UDim2.new(0, 20, 0.5, -20)
FloatCont.BackgroundTransparency = 1
FloatCont.ZIndex                = 99999

-- // 2. THE MAIN "CAT" BUTTON
local FloatBtn = Instance.new("TextButton", FloatCont)
FloatBtn.Name             = "MainButton"
FloatBtn.Size             = UDim2.new(0, 40, 1, 0)
FloatBtn.Position         = UDim2.new(0, 30, 0, 0)
FloatBtn.BackgroundColor3 = Theme.CardBG
FloatBtn.Text             = "Cat"
FloatBtn.TextColor3       = Theme.CatPurple
FloatBtn.Font             = Enum.Font.GothamBold
FloatBtn.TextSize         = 16
FloatBtn.BorderSizePixel  = 0
FloatBtn.AutoButtonColor  = false

-- Decorations
local FloatCorner = Instance.new("UICorner", FloatBtn)
FloatCorner.CornerRadius = UDim.new(0, 8)

local FloatStroke = Instance.new("UIStroke", FloatBtn)
FloatStroke.Color = Theme.Line

-- // 3. DRAG HANDLE (INVISIBLE)
local FloatDrag = Instance.new("TextButton", FloatCont)
FloatDrag.Name                  = "DragArea"
FloatDrag.Size                  = UDim2.new(0, 30, 1, 0)
FloatDrag.Position              = UDim2.new(0, 0, 0, 0)
FloatDrag.BackgroundTransparency = 1
FloatDrag.Text                  = ""

-- // 4. DRAGGING LOGIC
local draggingFloat  = false
local dragStartFloat = nil
local startPosFloat  = nil

-- Start Dragging
FloatDrag.InputBegan:Connect(function(input)
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    if isMouse or isTouch then
        draggingFloat  = true
        dragStartFloat = input.Position
        startPosFloat  = FloatCont.Position
    end
end)

-- Stop Dragging
FloatDrag.InputEnded:Connect(function(input)
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    if isMouse or isTouch then
        draggingFloat = false
    end
end)

-- Handle Movement
UserInput.InputChanged:Connect(function(input)
    local isMouseMove = input.UserInputType == Enum.UserInputType.MouseMovement
    local isTouchMove = input.UserInputType == Enum.UserInputType.Touch

    if draggingFloat and (isMouseMove or isTouchMove) then
        local delta = input.Position - dragStartFloat

        -- Update Position (Pecah biar ga panjang)
        FloatCont.Position = UDim2.new(
            startPosFloat.X.Scale,
            startPosFloat.X.Offset + delta.X,
            startPosFloat.Y.Scale,
            startPosFloat.Y.Offset + delta.Y
        )
    end
end)

-- [[ ==========================================
--      4. MAIN INTERFACE: FRAME & TOP BAR
--    ========================================== ]]

-- // 4.1: Main Frame Setup
local Main = Instance.new("Frame", Gui)
Main.Name             = "MainFrame"
Main.Size             = UDim2.new(0, 550, 0, 340)
Main.Position         = UDim2.new(0.5, -275, 0.5, -170)
Main.BackgroundColor3 = Theme.MainBG
Main.BorderSizePixel  = 0
Main.ClipsDescendants = true

-- Decorations
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 6)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.Line

-- // Toggle Logic
FloatBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- // 4.2: Top Bar Construction
local Top = Instance.new("Frame", Main)
Top.Name              = "TopBar"
Top.Size              = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3  = Theme.TopBG
Top.BorderSizePixel   = 0

local TopCorner = Instance.new("UICorner", Top)
TopCorner.CornerRadius = UDim.new(0, 6)

-- TopFix: Biar sudut bawah top bar kotak (ga usah bulatan)
local TopFix = Instance.new("Frame", Top)
TopFix.Name              = "TopFix"
TopFix.Size              = UDim2.new(1, 0, 0, 10)
TopFix.Position          = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3  = Theme.TopBG
TopFix.BorderSizePixel   = 0

-- // 4.3: Title Engine
local TitleContainer = Instance.new("Frame", Top)
TitleContainer.Name                  = "TitleContainer"
TitleContainer.Size                  = UDim2.new(0, 350, 1, 0)
TitleContainer.Position              = UDim2.new(0, 15, 0, 0)
TitleContainer.BackgroundTransparency = 1

local TitleList = Instance.new("UIListLayout", TitleContainer)
TitleList.FillDirection     = Enum.FillDirection.Horizontal
TitleList.VerticalAlignment = Enum.VerticalAlignment.Center
TitleList.Padding           = UDim.new(0, 4)

-- Helper Function: Buat Bagian Judul
local function CreateTitlePart(text, color, font)
    local label = Instance.new("TextLabel", TitleContainer)
    label.Text                  = text
    label.TextColor3            = color
    label.Font                  = font
    label.TextSize              = 13
    label.BackgroundTransparency = 1
    label.AutomaticSize         = Enum.AutomaticSize.XY
end

-- Generate Title
CreateTitlePart("CatHUB", Theme.CatPurple, Enum.Font.GothamBold)
CreateTitlePart("Blox Fruits", Theme.Text, Enum.Font.GothamMedium)
CreateTitlePart("[Freemium]", Theme.Gold, Enum.Font.GothamMedium)

-- [[ ==========================================
--      5. WINDOW CONTROLS & DRAGGING LOGIC
--    ========================================== ]]

-- // 5.1: Close Button (X)
local BtnX = Instance.new("TextButton", Top)
BtnX.Name                   = "CloseBtn"
BtnX.Size                   = UDim2.new(0, 35, 0, 35)
BtnX.Position               = UDim2.new(1, -35, 0, 0)
BtnX.Text                   = "X"
BtnX.TextColor3             = Theme.TextDim
BtnX.BackgroundTransparency = 1
BtnX.Font                   = Enum.Font.Gotham
BtnX.TextSize               = 15
BtnX.AutoButtonColor        = false

-- // 5.2: Minimize Button (—)
local BtnM = Instance.new("TextButton", Top)
BtnM.Name                   = "MinBtn"
BtnM.Size                   = UDim2.new(0, 35, 0, 35)
BtnM.Position               = UDim2.new(1, -70, 0, 0)
BtnM.Text                   = "—"
BtnM.TextColor3             = Theme.TextDim
BtnM.BackgroundTransparency = 1
BtnM.Font                   = Enum.Font.GothamBold
BtnM.TextSize               = 13
BtnM.AutoButtonColor        = false

-- // 5.3: Actions
-- Close UI
BtnX.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Minimize UI (Animated)
local isMinimized = false
local lastSize    = Main.Size

BtnM.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    local targetHeight = isMinimized and 35 or lastSize.Y.Offset
    local targetSize   = UDim2.new(0, Main.Size.X.Offset, 0, targetHeight)

    if isMinimized then
        lastSize = Main.Size
    end

    -- Smooth Resize Tween
    TweenService:Create(
        Main,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = targetSize }
    ):Play()
end)

-- // 5.4: Main Frame Dragging
local draggingMain  = false
local dragStartMain = nil
local startPosMain  = nil

-- Start Drag
Top.InputBegan:Connect(function(input)
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    if isMouse or isTouch then
        draggingMain  = true
        dragStartMain = input.Position
        startPosMain  = Main.Position
    end
end)

-- End Drag
Top.InputEnded:Connect(function(input)
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    if isMouse or isTouch then
        draggingMain = false
    end
end)

-- Movement Processor
UserInput.InputChanged:Connect(function(input)
    local isMoving = input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch

    if draggingMain and isMoving then
        local delta = input.Position - dragStartMain

        -- Update Position (Vertical)
        Main.Position = UDim2.new(
            startPosMain.X.Scale,
            startPosMain.X.Offset + delta.X,
            startPosMain.Y.Scale,
            startPosMain.Y.Offset + delta.Y
        )
    end
end)

-- [[ ==========================================
--      6. DYNAMIC WINDOW RESIZER ENGINE
--    ========================================== ]]

-- // 6.1: Resizer UI Element
local Resizer = Instance.new("TextButton", Main)
Resizer.Name                   = "WindowResizer"
Resizer.Size                   = UDim2.new(0, 35, 0, 35)
Resizer.Position               = UDim2.new(1, -35, 1, -35)
Resizer.BackgroundTransparency = 1
Resizer.Text                   = "⌟"
Resizer.TextColor3             = Theme.CatPurple
Resizer.TextSize               = 25
Resizer.Font                   = Enum.Font.Gotham
Resizer.ZIndex                 = 99999
Resizer.AutoButtonColor        = false

-- // 6.2: State Variables
local isResizing     = false
local resizeStartPos = nil
local startSizeR     = nil

-- // 6.3: Resizing Logic

-- Start Resizing
Resizer.InputBegan:Connect(function(input)
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    -- Cegah resize kalo lagi minimize
    if (isMouse or isTouch) and not isMinimized then
        isResizing     = true
        resizeStartPos = UserInput:GetMouseLocation()
        startSizeR     = Main.Size
    end
end)

-- Stop Resizing
UserInput.InputEnded:Connect(function(input)
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    if isMouse or isTouch then
        isResizing = false
    end
end)

-- Execute Resizing
UserInput.InputChanged:Connect(function(input)
    local isMoving = input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch

    if isResizing and isMoving then
        local currentMousePos = UserInput:GetMouseLocation()
        local delta           = currentMousePos - resizeStartPos

        -- Calculate Width (Pecah biar rapi)
        local newWidth = math.clamp(
            startSizeR.X.Offset + delta.X,
            350, -- Min Width
            900  -- Max Width
        )

        -- Calculate Height
        local newHeight = math.clamp(
            startSizeR.Y.Offset + delta.Y,
            220, -- Min Height
            700  -- Max Height
        )

        -- Apply Size
        Main.Size = UDim2.new(0, newWidth, 0, newHeight)

        -- Sync biar ga bug pas restore
        lastSize = Main.Size
    end
end)

-- [[ ==========================================
--      7. CONTENT ARCHITECTURE
--    ========================================== ]]

-- // 7.1: Main Content Wrapper
local ContentContainer = Instance.new("Frame", Main)
ContentContainer.Name                  = "ContentContainer"
ContentContainer.Size                  = UDim2.new(1, 0, 1, -35)
ContentContainer.Position              = UDim2.new(0, 0, 0, 35)
ContentContainer.BackgroundTransparency = 1

-- // 7.2: Sidebar System
local Side = Instance.new("Frame", ContentContainer)
Side.Name              = "Sidebar"
Side.Size              = UDim2.new(0.28, 0, 1, 0)
Side.BackgroundColor3  = Theme.SideBG
Side.BorderSizePixel   = 0

-- Vertical Separator
local SideLine = Instance.new("Frame", Side)
SideLine.Name              = "SideLine"
SideLine.Size              = UDim2.new(0, 1, 1, 0)
SideLine.Position          = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3  = Theme.Line
SideLine.BorderSizePixel   = 0

-- // 7.3: Search Navigation UI
local SearchFrame = Instance.new("Frame", Side)
SearchFrame.Name              = "SearchFrame"
SearchFrame.Size              = UDim2.new(1, -16, 0, 30)
SearchFrame.Position          = UDim2.new(0, 8, 0, 10)
SearchFrame.BackgroundColor3  = Theme.CardBG
SearchFrame.BorderSizePixel   = 0

local SearchCorner = Instance.new("UICorner", SearchFrame)
SearchCorner.CornerRadius = UDim.new(0, 6)

local SearchStroke = Instance.new("UIStroke", SearchFrame)
SearchStroke.Color = Theme.Line

-- Search Input Field
local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Name                  = "SearchBox"
SearchBox.Size                  = UDim2.new(1, -16, 1, 0)
SearchBox.Position              = UDim2.new(0, 8, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text                  = ""
SearchBox.PlaceholderText       = "Search..."
SearchBox.TextColor3            = Theme.Text
SearchBox.PlaceholderColor3     = Theme.TextDim
SearchBox.Font                  = Enum.Font.GothamMedium
SearchBox.TextSize              = 12
SearchBox.TextXAlignment        = Enum.TextXAlignment.Left

-- // 7.4: Sidebar Tab Scrolling
local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Name                  = "SideScroll"
SideScroll.Size                  = UDim2.new(1, 0, 1, -50)
SideScroll.Position              = UDim2.new(0, 0, 0, 50)
SideScroll.BackgroundTransparency = 1
SideScroll.ScrollBarThickness    = 0
SideScroll.BorderSizePixel       = 0

local SideList = Instance.new("UIListLayout", SideScroll)
SideList.Padding   = UDim.new(0, 4)
SideList.SortOrder = Enum.SortOrder.LayoutOrder

local SidePad = Instance.new("UIPadding", SideScroll)
SidePad.PaddingLeft  = UDim.new(0, 8)
SidePad.PaddingRight = UDim.new(0, 8)

-- // 7.5: Main Content Area
local ContentArea = Instance.new("Frame", ContentContainer)
ContentArea.Name                  = "ContentArea"
ContentArea.Size                  = UDim2.new(0.72, 0, 1, 0)
ContentArea.Position              = UDim2.new(0.28, 0, 0, 0)
ContentArea.BackgroundTransparency = 1

-- [[ ==========================================
--      8. UI TOOLS: TAB & PAGE GENERATOR
--    ========================================== ]]

local Pages      = {}
local AllToggles = {}

-- Sidebar Priority
local TabPriority = {
    ["Status"]       = 1,
    ["Auto Farm"]    = 2,
    ["Devil Fruits"] = 3,
    ["Misc"]         = 4
}

-- // Function: Create Tab & Page
local function CreateTab(name, isFirst)
    -- Cek duplikat
    if Pages[name] then
        return Pages[name].Page
    end

    -- // 8.1: Sidebar Button
    local Btn = Instance.new("TextButton", SideScroll)
    Btn.Name             = name .. "_TabBtn"
    Btn.LayoutOrder      = TabPriority[name] or 99
    Btn.Size             = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = isFirst and Theme.TabOn or Theme.TabOff
    Btn.Text             = "    " .. name
    Btn.TextColor3       = isFirst and Theme.Text or Theme.TextDim
    Btn.Font             = Enum.Font.GothamMedium
    Btn.TextSize         = 12
    Btn.BorderSizePixel  = 0
    Btn.TextXAlignment   = Enum.TextXAlignment.Left
    Btn.AutoButtonColor  = false

    local BtnCorner = Instance.new("UICorner", Btn)
    BtnCorner.CornerRadius = UDim.new(0, 6)

    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Name        = "TabStroke"
    BtnStroke.Color       = Color3.fromRGB(65, 65, 70)
    BtnStroke.Thickness   = 1
    BtnStroke.Transparency = isFirst and 0 or 0.3

    -- Selection Indicator
    local Indicator = Instance.new("Frame", Btn)
    Indicator.Name               = "Indicator"
    Indicator.Size               = UDim2.new(0, 3, 0, 14)
    Indicator.Position           = UDim2.new(0, 4, 0.5, -7)
    Indicator.BackgroundColor3   = Theme.Accent
    Indicator.BorderSizePixel    = 0
    Indicator.Visible            = isFirst

    local IndicatorCorner = Instance.new("UICorner", Indicator)
    IndicatorCorner.CornerRadius = UDim.new(1, 0)

    -- // 8.2: Content Page
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Name                 = name .. "_Page"
    Page.Size                 = UDim2.new(1, -16, 1, -16)
    Page.Position             = UDim2.new(0, 8, 0, 8)
    Page.BackgroundColor3     = Theme.PageBG
    Page.BackgroundTransparency = 0
    Page.ScrollBarThickness   = 2
    Page.ScrollBarImageColor3 = Theme.TextDim
    Page.Visible              = isFirst
    Page.BorderSizePixel      = 0
    Page.CanvasSize           = UDim2.new(0, 0, 0, 0)

    local PageCorner = Instance.new("UICorner", Page)
    PageCorner.CornerRadius = UDim.new(0, 6)

    local PageStroke = Instance.new("UIStroke", Page)
    PageStroke.Color = Theme.Line

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding   = UDim.new(0, 6)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local PagePad = Instance.new("UIPadding", Page)
    PagePad.PaddingTop    = UDim.new(0, 10)
    PagePad.PaddingLeft   = UDim.new(0, 10)
    PagePad.PaddingRight  = UDim.new(0, 14)
    PagePad.PaddingBottom = UDim.new(0, 12)

    -- Auto Canvas Size
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local sizeY = PageLayout.AbsoluteContentSize.Y + 24
        Page.CanvasSize = UDim2.new(0, 0, 0, sizeY)
    end)

    -- // 8.3: Tab Switching Logic
    Btn.MouseButton1Click:Connect(function()
        if Page.Visible then return end

        for tName, data in pairs(Pages) do
            local isActive = (tName == name)

            -- Update Visibility
            data.Page.Visible = isActive
            data.Ind.Visible  = isActive

            -- Tween Button Color
            TweenService:Create(
                data.Btn,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = isActive and Theme.TabOn or Theme.TabOff,
                    TextColor3       = isActive and Theme.Text or Theme.TextDim
                }
            ):Play()

            -- Tween Stroke
            TweenService:Create(
                data.Stroke,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Transparency = isActive and 0 or 0.3 }
            ):Play()
        end
    end)

    -- Register Data
    Pages[name] = {
        Btn    = Btn,
        Page   = Page,
        Ind    = Indicator,
        Stroke = BtnStroke
    }

    return Page
end

-- [[ ==========================================
--      9. UI COMPONENTS
--    ========================================== ]]

-- // 9.1: Create Section Header
local function CreateSection(parent, text)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Name                  = "Section_" .. text
    SectionFrame.LayoutOrder           = #parent:GetChildren()
    SectionFrame.Size                  = UDim2.new(1, 0, 0, 36)
    SectionFrame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", SectionFrame)
    Label.Size               = UDim2.new(1, 0, 0, 14)
    Label.Position           = UDim2.new(0, 4, 0, 16)
    Label.Text               = string.upper(text)
    Label.TextColor3         = Theme.TextDim
    Label.Font               = Enum.Font.GothamBold
    Label.TextSize           = 11
    Label.TextXAlignment     = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
end

-- // 9.2: Create Toggle Switch
local function CreateToggle(parent, text, description, stateRef, callback)
    local frameHeight = description and 52 or 36

    local ToggleBtn = Instance.new("TextButton", parent)
    ToggleBtn.Name              = text .. "_Toggle"
    ToggleBtn.LayoutOrder       = #parent:GetChildren()
    ToggleBtn.Size              = UDim2.new(1, 0, 0, frameHeight)
    ToggleBtn.BackgroundColor3  = Theme.CardBG
    ToggleBtn.BorderSizePixel   = 0
    ToggleBtn.Text              = ""
    ToggleBtn.AutoButtonColor   = false

    local Corner = Instance.new("UICorner", ToggleBtn)
    Corner.CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", ToggleBtn)
    Stroke.Color = Theme.Line

    -- Main Title
    local Title = Instance.new("TextLabel", ToggleBtn)
    Title.Size               = UDim2.new(1, -60, 0, 20)
    Title.Position           = UDim2.new(0, 12, 0, description and 6 or 8)
    Title.Text               = text
    Title.TextColor3         = Theme.Text
    Title.Font               = Enum.Font.GothamMedium
    Title.TextSize           = 12
    Title.TextXAlignment     = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Description
    if description then
        local Desc = Instance.new("TextLabel", ToggleBtn)
        Desc.Size               = UDim2.new(1, -60, 0, 14)
        Desc.Position           = UDim2.new(0, 12, 0, 26)
        Desc.Text               = description
        Desc.TextColor3         = Theme.TextDim
        Desc.Font               = Enum.Font.Gotham
        Desc.TextSize           = 10
        Desc.TextXAlignment     = Enum.TextXAlignment.Left
        Desc.BackgroundTransparency = 1
    end

    -- Switch Outer Frame
    local Sw = Instance.new("Frame", ToggleBtn)
    Sw.Size              = UDim2.new(0, 36, 0, 18)
    Sw.Position          = UDim2.new(1, -48, 0.5, -9)
    Sw.BackgroundColor3  = stateRef and Theme.Accent or Theme.ToggleOff
    Sw.BorderSizePixel   = 0

    local SwCorner = Instance.new("UICorner", Sw)
    SwCorner.CornerRadius = UDim.new(1, 0)

    -- Switch Inner Dot
    local Dot = Instance.new("Frame", Sw)
    Dot.Size             = UDim2.new(0, 14, 0, 14)
    Dot.Position         = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel  = 0

    local DotCorner = Instance.new("UICorner", Dot)
    DotCorner.CornerRadius = UDim.new(1, 0)

    -- Toggle Click Logic
    ToggleBtn.MouseButton1Click:Connect(function()
        stateRef = not stateRef

        -- Tween Switch Color
        TweenService:Create(
            Sw,
            TweenInfo.new(0.2),
            { BackgroundColor3 = stateRef and Theme.Accent or Theme.ToggleOff }
        ):Play()

        -- Tween Dot Position
        local dotPos = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        TweenService:Create(
            Dot,
            TweenInfo.new(0.25),
            { Position = dotPos }
        ):Play()

        if callback then
            callback(stateRef)
        end

        SaveSettings()
    end)

    -- Register Search
    table.insert(AllToggles, {Btn = ToggleBtn, Label = Title})
end

-- // 9.3: Create Information Label
local function CreateLabel(parent, text, description)
    local frameHeight = description and 45 or 30

    local LabelFrame = Instance.new("Frame", parent)
    LabelFrame.LayoutOrder       = #parent:GetChildren()
    LabelFrame.Size              = UDim2.new(1, 0, 0, frameHeight)
    LabelFrame.BackgroundColor3  = Theme.CardBG
    LabelFrame.BorderSizePixel   = 0

    local Corner = Instance.new("UICorner", LabelFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", LabelFrame)
    Stroke.Color = Theme.Line

    -- Primary Text
    local MainLabel = Instance.new("TextLabel", LabelFrame)
    MainLabel.Size               = UDim2.new(1, -20, 0, 20)
    MainLabel.Position           = UDim2.new(0, 12, 0, description and 4 or 5)
    MainLabel.Text               = text
    MainLabel.TextColor3         = Theme.Text
    MainLabel.Font               = Enum.Font.GothamMedium
    MainLabel.TextSize           = 12
    MainLabel.TextXAlignment     = Enum.TextXAlignment.Left
    MainLabel.BackgroundTransparency = 1

    -- Secondary Text
    if description then
        local SubLabel = Instance.new("TextLabel", LabelFrame)
        SubLabel.Size               = UDim2.new(1, -20, 0, 14)
        SubLabel.Position           = UDim2.new(0, 12, 0, 22)
        SubLabel.Text               = description
        SubLabel.TextColor3         = Theme.TextDim
        SubLabel.Font               = Enum.Font.Gotham
        SubLabel.TextSize           = 10
        SubLabel.TextXAlignment     = Enum.TextXAlignment.Left
        SubLabel.BackgroundTransparency = 1
    end

    return MainLabel
end

-- [[ ==========================================
--      10. SEARCH ENGINE LOGIC
--    ========================================== ]]

-- Filter tombol berdasarkan text search
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchBox.Text)

    for _, toggle in ipairs(AllToggles) do
        local labelText = string.lower(toggle.Label.Text)
        
        -- Pecah logika pencarian biar ga panjang
        local isEmpty = (query == "")
        local isFound = (string.find(labelText, query) ~= nil)
        local isMatch = isEmpty or isFound

        -- Tunjukin / sembunyiin tombol
        toggle.Btn.Visible = isMatch
    end
end)

-- ==========================================
-- 11. PRE-INITIALIZE DEFAULT TABS
-- ==========================================

CreateTab("Status", true)        -- Halaman utama
CreateTab("Auto Farm", false)
CreateTab("Devil Fruits", false)
CreateTab("Misc", false)

-- ==========================================
-- 12. GLOBAL FRAMEWORK EXPORT
-- ==========================================

-- Daftarin fungsi UI ke Global biar bisa dipake modul lain
_G.Cat.UI = {
    -- UI Builders
    CreateTab     = CreateTab,
    CreateSection = CreateSection,
    CreateToggle  = CreateToggle,
    CreateLabel   = CreateLabel,

    -- Framework Data
    Theme         = Theme,
    SaveSettings  = SaveSettings
}

-- Pesan sukses di console
warn("[CatHUB] UI Framework Loaded Successfully.")