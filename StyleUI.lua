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

-- // Variables
local ConfigFile = "CatHUB_Config.json"

-- // Global Initialization
_G.Cat        = _G.Cat or {}
_G.Cat.Player = Players.LocalPlayer
_G.Cat.Labels = _G.Cat.Labels or {}

-- // Settings Protection
-- Ensures settings are only initialized if not already handled by Main.lua
if not _G.Cat.Settings then
    _G.Cat.Settings = {}
end

-- ==========================================
-- 2. UTILITY FUNCTIONS
-- ==========================================

-- // Function: Persistent Data Storage (Save Only)
local function SaveSettings()
    pcall(function() 
        local settings = _G.Cat.Settings
        local payload  = HttpService:JSONEncode(settings)
        
        writefile(ConfigFile, payload) 
    end)
end

-- // Export to Global for Module Access
_G.Cat.SaveSettings = SaveSettings

-- ==========================================
-- 3. UI RENDERING: ROOT ELEMENTS
-- ==========================================

-- // Main Screen Container
local Gui            = Instance.new("ScreenGui", CoreGui)
Gui.Name             = "CatUI"
Gui.ResetOnSpawn     = false
Gui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling

-- // Color Palette & Theme Engine
local Theme = {
    -- Background Layers
    MainBG    = Color3.fromRGB(10, 10, 10),
    SideBG    = Color3.fromRGB(14, 14, 16),
    TopBG     = Color3.fromRGB(10, 10, 10),
    PageBG    = Color3.fromRGB(17, 18, 22),
    
    -- Navigation & Containers
    TabOn     = Color3.fromRGB(38, 38, 42),
    TabOff    = Color3.fromRGB(25, 25, 30),
    CardBG    = Color3.fromRGB(28, 28, 32),
    CardHov   = Color3.fromRGB(36, 36, 42),
    
    -- Typography
    Text      = Color3.fromRGB(250, 250, 250),
    TextDim   = Color3.fromRGB(140, 140, 145),
    
    -- Accents & Interactivity
    ToggleOn  = Color3.fromRGB(138, 43, 226),
    ToggleOff = Color3.fromRGB(75, 75, 80),
    CatPurple = Color3.fromRGB(160, 100, 255),
    Gold      = Color3.fromRGB(255, 200, 50),
    Accent    = Color3.fromRGB(138, 43, 226),
    Line      = Color3.fromRGB(40, 40, 45)
}

-- // Export Theme to Global
_G.Cat.Theme = Theme

-- [[ ==========================================
--      FLOATING BUTTON (MOBILE/PC TOGGLE)
--    ========================================== ]]

-- // 1. MAIN CONTAINER
local FloatCont             = Instance.new("Frame", Gui)
FloatCont.Name              = "FloatContainer"
FloatCont.Size              = UDim2.new(0, 70, 0, 40)
FloatCont.Position          = UDim2.new(0, 20, 0.5, -20)
FloatCont.BackgroundTransparency = 1
FloatCont.ZIndex            = 99999

-- // 2. THE MAIN "CAT" BUTTON
local FloatBtn              = Instance.new("TextButton", FloatCont)
FloatBtn.Name               = "MainButton"
FloatBtn.Size               = UDim2.new(0, 40, 1, 0)
FloatBtn.Position           = UDim2.new(0, 30, 0, 0)
FloatBtn.BackgroundColor3   = Theme.CardBG
FloatBtn.Text               = "Cat"
FloatBtn.TextColor3         = Theme.CatPurple
FloatBtn.Font               = Enum.Font.GothamBold
FloatBtn.TextSize           = 16
FloatBtn.BorderSizePixel    = 0
FloatBtn.AutoButtonColor    = false

-- Decorations
local FloatCorner           = Instance.new("UICorner", FloatBtn)
FloatCorner.CornerRadius    = UDim.new(0, 8)

local FloatStroke           = Instance.new("UIStroke", FloatBtn)
FloatStroke.Color           = Theme.Line

-- // 3. DRAG HANDLE (INVISIBLE)
local FloatDrag             = Instance.new("TextButton", FloatCont)
FloatDrag.Name              = "DragArea"
FloatDrag.Size              = UDim2.new(0, 30, 1, 0)
FloatDrag.Position          = UDim2.new(0, 0, 0, 0)
FloatDrag.BackgroundTransparency = 1
FloatDrag.Text              = ""

-- // 4. DRAGGING LOGIC (DYNAMIC POSITIONING)
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
    local isMoving = input.UserInputType == Enum.UserInputType.MouseMovement 
        or input.UserInputType == Enum.UserInputType.Touch
    
    if draggingFloat and isMoving then
        local delta = input.Position - dragStartFloat
        
        -- // Update Position (Broken down for scannability)
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

-- // 4.1: MAIN FRAME SETUP
local Main                  = Instance.new("Frame", Gui)
Main.Name                   = "MainFrame"
Main.Size                   = UDim2.new(0, 550, 0, 340)
Main.Position               = UDim2.new(0.5, -275, 0.5, -170)
Main.BackgroundColor3       = Theme.MainBG
Main.BorderSizePixel        = 0
Main.ClipsDescendants       = true 

-- Decorations
local MainCorner            = Instance.new("UICorner", Main)
MainCorner.CornerRadius     = UDim.new(0, 6)

local MainStroke            = Instance.new("UIStroke", Main)
MainStroke.Color            = Theme.Line

-- // Toggle Logic: Link Floating Button to UI Visibility
FloatBtn.MouseButton1Click:Connect(function() 
    Main.Visible = not Main.Visible 
end)

-- // 4.2: TOP BAR CONSTRUCTION
local Top                   = Instance.new("Frame", Main)
Top.Name                    = "TopBar"
Top.Size                    = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3        = Theme.TopBG
Top.BorderSizePixel         = 0

local TopCorner             = Instance.new("UICorner", Top)
TopCorner.CornerRadius      = UDim.new(0, 6)

-- TopFix: Overlays the bottom corners to remove rounding on the lower side
local TopFix                = Instance.new("Frame", Top)
TopFix.Name                 = "TopFix"
TopFix.Size                 = UDim2.new(1, 0, 0, 10)
TopFix.Position             = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3     = Theme.TopBG
TopFix.BorderSizePixel      = 0

-- // 4.3: TITLE ENGINE
local TitleContainer        = Instance.new("Frame", Top)
TitleContainer.Name         = "TitleContainer"
TitleContainer.Size         = UDim2.new(0, 350, 1, 0)
TitleContainer.Position     = UDim2.new(0, 15, 0, 0)
TitleContainer.BackgroundTransparency = 1

local TitleList             = Instance.new("UIListLayout", TitleContainer)
TitleList.FillDirection     = Enum.FillDirection.Horizontal
TitleList.VerticalAlignment = Enum.VerticalAlignment.Center
TitleList.Padding           = UDim.new(0, 4) 

-- Helper Function: Construct Title Segments
local function CreateTitlePart(text, color, font) 
    local label             = Instance.new("TextLabel", TitleContainer)
    label.Text              = text
    label.TextColor3        = color
    label.Font              = font
    label.TextSize          = 13
    label.BackgroundTransparency = 1
    label.AutomaticSize     = Enum.AutomaticSize.XY 
end

-- // Execute Title Generation
CreateTitlePart(
    "CatHUB", 
    Theme.CatPurple, 
    Enum.Font.GothamBold
) 

CreateTitlePart(
    "Blox Fruits", 
    Theme.Text, 
    Enum.Font.GothamMedium
)

CreateTitlePart(
    "[Freemium]", 
    Theme.Gold, 
    Enum.Font.GothamMedium
)

-- [[ ==========================================
--      5. WINDOW CONTROLS & DRAGGING LOGIC
--    ========================================== ]]

-- // 5.1: CLOSE BUTTON (X)
local BtnX                  = Instance.new("TextButton", Top)
BtnX.Name                   = "CloseBtn"
BtnX.Size                   = UDim2.new(0, 35, 0, 35)
BtnX.Position               = UDim2.new(1, -35, 0, 0)
BtnX.Text                   = "X"
BtnX.TextColor3             = Theme.TextDim
BtnX.BackgroundTransparency = 1
BtnX.Font                   = Enum.Font.Gotham
BtnX.TextSize               = 15
BtnX.AutoButtonColor        = false

-- // 5.2: MINIMIZE BUTTON (—)
local BtnM                  = Instance.new("TextButton", Top)
BtnM.Name                   = "MinBtn"
BtnM.Size                   = UDim2.new(0, 35, 0, 35)
BtnM.Position               = UDim2.new(1, -70, 0, 0)
BtnM.Text                   = "—"
BtnM.TextColor3             = Theme.TextDim
BtnM.BackgroundTransparency = 1
BtnM.Font                   = Enum.Font.GothamBold
BtnM.TextSize               = 13
BtnM.AutoButtonColor        = false

-- // 5.3: WINDOW CONTROL ACTIONS
-- Handle Close Action
BtnX.MouseButton1Click:Connect(function() 
    Main.Visible = false 
end)

-- Handle Minimize Action (Animated)
local isMinimized = false 
local lastSize    = Main.Size

BtnM.MouseButton1Click:Connect(function() 
    isMinimized = not isMinimized 
    
    local targetHeight = isMinimized and 35 or lastSize.Y.Offset
    local targetSize   = UDim2.new(0, Main.Size.X.Offset, 0, targetHeight)
    
    if isMinimized then 
        lastSize = Main.Size
    end
    
    -- Execute Smooth Resize Tween
    TweenService:Create(
        Main, 
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        { Size = targetSize }
    ):Play() 
end)

-- // 5.4: MAIN FRAME DRAGGING ENGINE
local draggingMain  = false
local dragStartMain = nil
local startPosMain  = nil

-- Start Dragging Handler
Top.InputBegan:Connect(function(input) 
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    
    if isMouse or isTouch then 
        draggingMain  = true
        dragStartMain = input.Position
        startPosMain  = Main.Position 
    end 
end)

-- End Dragging Handler
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
        
        -- // Update Frame Position (Vertical Construction)
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

-- // 6.1: RESIZER UI ELEMENT (CORNER HANDLE)
local Resizer               = Instance.new("TextButton", Main)
Resizer.Name                = "WindowResizer"
Resizer.Size                = UDim2.new(0, 35, 0, 35)
Resizer.Position            = UDim2.new(1, -35, 1, -35)
Resizer.BackgroundTransparency = 1
Resizer.Text                = "⌟"
Resizer.TextColor3          = Theme.CatPurple
Resizer.TextSize            = 25
Resizer.Font                = Enum.Font.Gotham
Resizer.ZIndex              = 99999
Resizer.AutoButtonColor     = false

-- // 6.2: RESIZING STATE VARIABLES
local isResizing            = false
local resizeStartPos        = nil
local startSizeR            = nil

-- // 6.3: RESIZING LOGIC (INPUT HANDLERS)

-- Start Resizing
Resizer.InputBegan:Connect(function(input)
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    
    -- Prevent resizing while window is minimized
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

-- Execute Resizing Process
UserInput.InputChanged:Connect(function(input)
    local isMoving = input.UserInputType == Enum.UserInputType.MouseMovement 
        or input.UserInputType == Enum.UserInputType.Touch
        
    if isResizing and isMoving then
        local currentMousePos = UserInput:GetMouseLocation()
        local delta           = currentMousePos - resizeStartPos
        
        -- // Calculate Clamped Sizes (Vertical Construction)
        local newWidth = math.clamp(
            startSizeR.X.Offset + delta.X, 
            350, -- Min Width
            900  -- Max Width
        )
        
        local newHeight = math.clamp(
            startSizeR.Y.Offset + delta.Y, 
            220, -- Min Height
            700  -- Max Height
        )
        
        -- Apply Size Update
        Main.Size = UDim2.new(0, newWidth, 0, newHeight)
        
        -- Sync with Minimize Logic to prevent restore bugs
        lastSize = Main.Size
    end
end)

-- ==========================================
-- 7. CONTENT CONTAINER & SIDEBAR
-- ==========================================
-- Wrapper for Sidebar and Content Area
local ContentContainer = Instance.new("Frame", Main)
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, 0, 1, -35)
ContentContainer.Position = UDim2.new(0, 0, 0, 35)
ContentContainer.BackgroundTransparency = 1

-- Sidebar Background
local Side = Instance.new("Frame", ContentContainer)
Side.Name = "Sidebar"
Side.Size = UDim2.new(0.28, 0, 1, 0)
Side.BackgroundColor3 = Theme.SideBG
Side.BorderSizePixel = 0

-- Vertical Line Separator
local SideLine = Instance.new("Frame", Side)
SideLine.Name = "SideLine"
SideLine.Size = UDim2.new(0, 1, 1, 0)
SideLine.Position = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3 = Theme.Line
SideLine.BorderSizePixel = 0

-- Search Bar Frame
local SearchFrame = Instance.new("Frame", Side)
SearchFrame.Name = "SearchFrame"
SearchFrame.Size = UDim2.new(1, -16, 0, 30)
SearchFrame.Position = UDim2.new(0, 8, 0, 10)
SearchFrame.BackgroundColor3 = Theme.CardBG
SearchFrame.BorderSizePixel = 0

local SearchCorner = Instance.new("UICorner", SearchFrame)
SearchCorner.CornerRadius = UDim.new(0, 6)

local SearchStroke = Instance.new("UIStroke", SearchFrame)
SearchStroke.Color = Theme.Line

-- Actual Search Input
local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -16, 1, 0)
SearchBox.Position = UDim2.new(0, 8, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Search..."
SearchBox.TextColor3 = Theme.Text
SearchBox.PlaceholderColor3 = Theme.TextDim
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left

-- Sidebar Scrolling Container
local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Name = "SideScroll"
SideScroll.Size = UDim2.new(1, 0, 1, -50)
SideScroll.Position = UDim2.new(0, 0, 0, 50)
SideScroll.BackgroundTransparency = 1
SideScroll.ScrollBarThickness = 0
SideScroll.BorderSizePixel = 0

-- Sidebar Layouts
local SideList = Instance.new("UIListLayout", SideScroll)
SideList.Padding = UDim.new(0, 4)
SideList.SortOrder = Enum.SortOrder.LayoutOrder -- <--- TAMBAHKAN INI

local SidePad = Instance.new("UIPadding", SideScroll)
SidePad.PaddingLeft = UDim.new(0, 8)
SidePad.PaddingRight = UDim.new(0, 8)

-- Main Content Area (Where the pages are)
local ContentArea = Instance.new("Frame", ContentContainer)
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(0.72, 0, 1, 0)
ContentArea.Position = UDim2.new(0.28, 0, 0, 0)
ContentArea.BackgroundTransparency = 1

-- ==========================================
-- PERKAKAS UI (UNTUK DIPAKE FILE LOGIC)
-- ==========================================

local Pages = {}
local AllToggles = {}

-- Tabel prioritas urutan Sidebar (Makin kecil makin di atas)
local TabPriority = {
    ["Status"] = 1,
    ["Auto Farm"] = 2,
    ["Devil Fruits"] = 3,
    ["Misc"] = 4
}

local function CreateTab(name, isFirst)
    -- PENCEGAH DUPLIKAT: Kalau tab nya udah ada, cukup return Page nya doang
    if Pages[name] then 
        return Pages[name].Page 
    end
    
    -- Tab Button
    local Btn = Instance.new("TextButton", SideScroll)
    Btn.Name = name .. "_TabBtn"
    Btn.LayoutOrder = TabPriority[name] or 99 -- Ini yang ngatur urutan
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = isFirst and Theme.TabOn or Theme.TabOff
    Btn.Text = "    " .. name 
    Btn.TextColor3 = isFirst and Theme.Text or Theme.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false
    
    -- Button Corner
    local BtnCorner = Instance.new("UICorner", Btn)
    BtnCorner.CornerRadius = UDim.new(0, 6)
    
    -- Button Stroke
    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Name = "TabStroke"
    BtnStroke.Color = Color3.fromRGB(65, 65, 70)
    BtnStroke.Thickness = 1
    BtnStroke.Transparency = isFirst and 0 or 0.3 
    
    -- Selection Indicator (Garis kecil di samping kiri)
    local Indicator = Instance.new("Frame", Btn)
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 0, 14)
    Indicator.Position = UDim2.new(0, 4, 0.5, -7)
    Indicator.BackgroundColor3 = Theme.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Visible = isFirst

    local IndicatorCorner = Instance.new("UICorner", Indicator)
    IndicatorCorner.CornerRadius = UDim.new(1, 0)

-- ==========================================
    -- PAGE CREATION (Scrolling Area)
    -- ==========================================
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Name = name .. "_Page"
    Page.Size = UDim2.new(1, -16, 1, -16)
    Page.Position = UDim2.new(0, 8, 0, 8)
    Page.BackgroundColor3 = Theme.PageBG
    Page.BackgroundTransparency = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Theme.TextDim
    Page.Visible = isFirst
    Page.BorderSizePixel = 0

    -- Page Decorations
    local PageCorner = Instance.new("UICorner", Page)
    PageCorner.CornerRadius = UDim.new(0, 6)

    local PageStroke = Instance.new("UIStroke", Page)
    PageStroke.Color = Theme.Line

    -- Layout & Padding
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 6)
    List.SortOrder = Enum.SortOrder.LayoutOrder

    local Pad = Instance.new("UIPadding", Page)
    Pad.PaddingTop = UDim.new(0, 10)
    Pad.PaddingLeft = UDim.new(0, 10)
    Pad.PaddingRight = UDim.new(0, 14)
    Pad.PaddingBottom = UDim.new(0, 10)
    
    -- Store Data for Management
    Pages[name] = {
        Btn = Btn, 
        Page = Page, 
        Ind = Indicator, 
        Stroke = BtnStroke
    }

    -- ==========================================
    -- TAB SWITCHING LOGIC
    -- ==========================================
    Btn.MouseButton1Click:Connect(function()
        for tName, data in pairs(Pages) do 
            local active = (tName == name)
            
            -- Visibility Toggle
            data.Page.Visible = active
            data.Ind.Visible = active
            
            -- Color Transition (Tweens)
            TweenService:Create(data.Btn, TweenInfo.new(0.15), {
                BackgroundColor3 = active and Theme.TabOn or Theme.TabOff, 
                TextColor3 = active and Theme.Text or Theme.TextDim
            }):Play()

            -- Stroke Transparency Transition
            TweenService:Create(data.Stroke, TweenInfo.new(0.15), {
                Transparency = active and 0 or 0.3
            }):Play()
        end
    end)

    return Page
end

-- ==========================================
-- 8. UI COMPONENTS (SECTION, TOGGLE, LABEL)
-- ==========================================

-- Function: Create Section Header
local function CreateSection(parent, text)
    local F = Instance.new("Frame", parent)
    F.Name = "Section_" .. text
    F.LayoutOrder = #parent:GetChildren()
    F.Size = UDim2.new(1, 0, 0, 36)
    F.BackgroundTransparency = 1

    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 0, 14)
    L.Position = UDim2.new(0, 4, 0, 16)
    L.Text = text
    L.TextColor3 = Theme.TextDim
    L.Font = Enum.Font.GothamBold
    L.TextSize = 11
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
end

-- Function: Create Toggle Switch
local function CreateToggle(parent, text, description, stateRef, callback)
    local frameHeight = description and 52 or 36
    
    local F = Instance.new("TextButton", parent)
    F.Name = text .. "_Toggle"
    F.LayoutOrder = #parent:GetChildren()
    F.Size = UDim2.new(1, 0, 0, frameHeight)
    F.BackgroundColor3 = Theme.CardBG
    F.BorderSizePixel = 0
    F.Text = ""
    F.AutoButtonColor = false

    local FCorner = Instance.new("UICorner", F)
    FCorner.CornerRadius = UDim.new(0, 6)

    local FStroke = Instance.new("UIStroke", F)
    FStroke.Color = Theme.Line

    -- Toggle Title
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -60, 0, 20)
    L.Position = UDim2.new(0, 12, 0, description and 6 or 8)
    L.Text = text
    L.TextColor3 = Theme.Text
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1

    -- Toggle Description (If exists)
    if description then 
        local D = Instance.new("TextLabel", F)
        D.Size = UDim2.new(1, -60, 0, 14)
        D.Position = UDim2.new(0, 12, 0, 26)
        D.Text = description
        D.TextColor3 = Theme.TextDim
        D.Font = Enum.Font.Gotham
        D.TextSize = 10
        D.TextXAlignment = Enum.TextXAlignment.Left
        D.BackgroundTransparency = 1 
    end

    -- Switch Background
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 36, 0, 18)
    Sw.Position = UDim2.new(1, -48, 0.5, -9)
    Sw.BackgroundColor3 = stateRef and Theme.Accent or Theme.ToggleOff
    Sw.BorderSizePixel = 0
    
    local SwCorner = Instance.new("UICorner", Sw)
    SwCorner.CornerRadius = UDim.new(1, 0) 

    -- Switch Dot (Circle)
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    
    local DotCorner = Instance.new("UICorner", Dot)
    DotCorner.CornerRadius = UDim.new(1, 0) 

    -- Toggle Click Logic
    F.MouseButton1Click:Connect(function() 
        stateRef = not stateRef 
        
        -- Animate Switch Background
        TweenService:Create(Sw, TweenInfo.new(0.2), {
            BackgroundColor3 = stateRef and Theme.Accent or Theme.ToggleOff
        }):Play() 
        
        -- Animate Dot Position
        TweenService:Create(Dot, TweenInfo.new(0.25), {
            Position = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play() 
        
        if callback then 
            callback(stateRef) 
        end 
        
        SaveSettings() 
    end)

    -- Register for Search Feature
    table.insert(AllToggles, {Btn = F, Label = L})
end

-- Function: Create Information Label
local function CreateLabel(parent, text, description)
    local frameHeight = description and 45 or 30
    
    local F = Instance.new("Frame", parent)
    F.LayoutOrder = #parent:GetChildren()
    F.Size = UDim2.new(1, 0, 0, frameHeight)
    F.BackgroundColor3 = Theme.CardBG
    F.BorderSizePixel = 0
    
    local FCorner = Instance.new("UICorner", F)
    FCorner.CornerRadius = UDim.new(0, 6)

    local FStroke = Instance.new("UIStroke", F)
    FStroke.Color = Theme.Line

    -- Label Main Text
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -20, 0, 20)
    L.Position = UDim2.new(0, 12, 0, description and 4 or 5)
    L.Text = text
    L.TextColor3 = Theme.Text
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1

    -- Label Description (If exists)
    if description then 
        local D = Instance.new("TextLabel", F)
        D.Size = UDim2.new(1, -20, 0, 14)
        D.Position = UDim2.new(0, 12, 0, 22)
        D.Text = description
        D.TextColor3 = Theme.TextDim
        D.Font = Enum.Font.Gotham
        D.TextSize = 10
        D.TextXAlignment = Enum.TextXAlignment.Left
        D.BackgroundTransparency = 1 
    end
    
    return L
end

-- ==========================================
-- SEARCH ENGINE LOGIC
-- ==========================================
-- ... (Kode pembuatan fungsi CreateTab, CreateToggle, dll ada di atas) ...

SearchBox:GetPropertyChangedSignal("Text"):Connect(function() 
    local query = string.lower(SearchBox.Text)
    for _, toggle in ipairs(AllToggles) do local text = string.lower(toggle.Label.Text) toggle.Btn.Visible = query == "" or string.find(text, query) ~= nil end 
end)

-- ==========================================
-- PRE-CREATE TABS (HARUS ADA DI SINI, SETELAH FUNGSI DIBUAT)
-- ==========================================
CreateTab("Status", true)
CreateTab("Auto Farm", false)
CreateTab("Devil Fruits", false)
CreateTab("Misc", false)

-- ==========================================
-- EXPORT PERKAKAS KE GLOBAL
-- ==========================================
_G.Cat.UI = {
    CreateTab = CreateTab,
    CreateSection = CreateSection,
    CreateToggle = CreateToggle,
    CreateLabel = CreateLabel,
    Theme = Theme,
    SaveSettings = SaveSettings
}