-- [[ ==========================================
--      ONIHUB: REDZLIB V5 CLONE (CORE ENGINE)
--      100% HAK MILIK SENDIRI - ZERO LOADSTRING
--    ========================================== ]]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local RedzLib = {}
local WindowInstance = nil
local ActiveTab = nil
local TabsContainer = nil
local ContentContainer = nil

-- Warna Tema Redz Hub (Dark/Red)
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    TopBar = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(255, 40, 40),
    Text = Color3.fromRGB(220, 220, 220),
    SubText = Color3.fromRGB(150, 150, 150),
    ElementBg = Color3.fromRGB(25, 25, 25)
}

function RedzLib:MakeWindow(Settings)
    if CoreGui:FindFirstChild("OniHub_Redz") then
        CoreGui.OniHub_Redz:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OniHub_Redz"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300) -- Ukuran Compact Redz
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    WindowInstance = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Accent
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.TopBar
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 6)
    TopCorner.Parent = TopBar
    
    local TopPatch = Instance.new("Frame")
    TopPatch.Size = UDim2.new(1, 0, 0, 10)
    TopPatch.Position = UDim2.new(0, 0, 1, -10)
    TopPatch.BackgroundColor3 = Theme.TopBar
    TopPatch.BorderSizePixel = 0
    TopPatch.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Settings.Title or "REDZ HUB"
    TitleLabel.TextColor3 = Theme.Accent
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Size = UDim2.new(1, -20, 1, 0)
    SubTitleLabel.Position = UDim2.new(0, 15, 0, 0)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = Settings.SubTitle or ""
    SubTitleLabel.TextColor3 = Theme.SubText
    SubTitleLabel.Font = Enum.Font.Gotham
    SubTitleLabel.TextSize = 12
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Right
    SubTitleLabel.Parent = TopBar

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.new(0, 0, 1, 0)
    Divider.BackgroundColor3 = Theme.Accent
    Divider.BorderSizePixel = 0
    Divider.Parent = TopBar

    -- Tabs Container (Kiri)
    TabsContainer = Instance.new("ScrollingFrame")
    TabsContainer.Size = UDim2.new(0, 120, 1, -41)
    TabsContainer.Position = UDim2.new(0, 0, 0, 41)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.BorderSizePixel = 0
    TabsContainer.ScrollBarThickness = 0
    TabsContainer.Parent = MainFrame

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Parent = TabsContainer

    local TabsDivider = Instance.new("Frame")
    TabsDivider.Size = UDim2.new(0, 1, 1, -41)
    TabsDivider.Position = UDim2.new(0, 120, 0, 41)
    TabsDivider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabsDivider.BorderSizePixel = 0
    TabsDivider.Parent = MainFrame

    -- Content Container (Kanan)
    ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -121, 1, -41)
    ContentContainer.Position = UDim2.new(0, 121, 0, 41)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local WindowObj = {}

    function WindowObj:MakeTab(TabData)
        local TabName = TabData[1]
        local TabIconId = TabData[2] -- Belum dipake di mockup ini

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Theme.Background
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = "  " .. TabName
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = TabsContainer

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.Visible = false
        TabPage.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = TabPage

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.Parent = TabPage

        TabBtn.MouseButton1Click:Connect(function()
            if ActiveTab then
                ActiveTab.Btn.TextColor3 = Theme.SubText
                ActiveTab.Page.Visible = false
            end
            TabBtn.TextColor3 = Theme.Accent
            TabPage.Visible = true
            ActiveTab = {Btn = TabBtn, Page = TabPage}
        end)

        local TabObj = {}
        
        function TabObj:AddSection(SecData)
            local SecName = SecData[1]
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 20)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = SecName
            SecLabel.TextColor3 = Theme.Accent
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextSize = 12
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = TabPage
            return SecLabel
        end

        function TabObj:AddParagraph(ParaData)
            local PTitle = ParaData[1]
            local PText = ParaData[2]
            
            local PFrame = Instance.new("Frame")
            PFrame.Size = UDim2.new(1, 0, 0, 45)
            PFrame.BackgroundColor3 = Theme.ElementBg
            PFrame.BorderSizePixel = 0
            PFrame.Parent = TabPage
            
            local PCorner = Instance.new("UICorner")
            PCorner.CornerRadius = UDim.new(0, 4)
            PCorner.Parent = PFrame
            
            local LblTitle = Instance.new("TextLabel")
            LblTitle.Size = UDim2.new(1, -10, 0, 20)
            LblTitle.Position = UDim2.new(0, 10, 0, 5)
            LblTitle.BackgroundTransparency = 1
            LblTitle.Text = PTitle
            LblTitle.TextColor3 = Theme.Text
            LblTitle.Font = Enum.Font.GothamBold
            LblTitle.TextSize = 13
            LblTitle.TextXAlignment = Enum.TextXAlignment.Left
            LblTitle.Parent = PFrame

            local LblText = Instance.new("TextLabel")
            LblText.Size = UDim2.new(1, -10, 0, 20)
            LblText.Position = UDim2.new(0, 10, 0, 20)
            LblText.BackgroundTransparency = 1
            LblText.Text = PText
            LblText.TextColor3 = Theme.SubText
            LblText.Font = Enum.Font.Gotham
            LblText.TextSize = 11
            LblText.TextXAlignment = Enum.TextXAlignment.Left
            LblText.Parent = PFrame

            return PFrame
        end

        function TabObj:AddToggle(ToggleSettings)
            local TFrame = Instance.new("Frame")
            TFrame.Size = UDim2.new(1, 0, 0, 35)
            TFrame.BackgroundColor3 = Theme.ElementBg
            TFrame.BorderSizePixel = 0
            TFrame.Parent = TabPage

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 4)
            TCorner.Parent = TFrame

            local TText = Instance.new("TextLabel")
            TText.Size = UDim2.new(1, -50, 1, 0)
            TText.Position = UDim2.new(0, 10, 0, 0)
            TText.BackgroundTransparency = 1
            TText.Text = ToggleSettings.Name
            TText.TextColor3 = Theme.Text
            TText.Font = Enum.Font.GothamMedium
            TText.TextSize = 12
            TText.TextXAlignment = Enum.TextXAlignment.Left
            TText.Parent = TFrame

            local BtnOuter = Instance.new("TextButton")
            BtnOuter.Size = UDim2.new(0, 20, 0, 20)
            BtnOuter.Position = UDim2.new(1, -30, 0.5, -10)
            BtnOuter.BackgroundColor3 = Theme.Background
            BtnOuter.Text = ""
            BtnOuter.Parent = TFrame

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 4)
            BCorner.Parent = BtnOuter
            
            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Color3.fromRGB(50, 50, 50)
            BtnStroke.Parent = BtnOuter

            local BtnInner = Instance.new("Frame")
            BtnInner.Size = UDim2.new(1, -4, 1, -4)
            BtnInner.Position = UDim2.new(0, 2, 0, 2)
            BtnInner.BackgroundColor3 = Theme.Accent
            BtnInner.BackgroundTransparency = ToggleSettings.Default and 0 or 1
            BtnInner.Parent = BtnOuter

            local ICorner = Instance.new("UICorner")
            ICorner.CornerRadius = UDim.new(0, 2)
            ICorner.Parent = BtnInner

            local isToggled = ToggleSettings.Default or false
            BtnOuter.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                BtnInner.BackgroundTransparency = isToggled and 0 or 1
                BtnStroke.Color = isToggled and Theme.Accent or Color3.fromRGB(50, 50, 50)
                if ToggleSettings.Callback then
                    ToggleSettings.Callback(isToggled)
                end
            end)

            local RetObj = {}
            function RetObj:Callback(cb)
                ToggleSettings.Callback = cb
            end
            return RetObj
        end

        function TabObj:AddSlider(SliderSettings)
            local SFrame = Instance.new("Frame")
            SFrame.Size = UDim2.new(1, 0, 0, 45)
            SFrame.BackgroundColor3 = Theme.ElementBg
            SFrame.BorderSizePixel = 0
            SFrame.Parent = TabPage

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(0, 4)
            SCorner.Parent = SFrame

            local SText = Instance.new("TextLabel")
            SText.Size = UDim2.new(1, -10, 0, 20)
            SText.Position = UDim2.new(0, 10, 0, 5)
            SText.BackgroundTransparency = 1
            SText.Text = SliderSettings.Name
            SText.TextColor3 = Theme.Text
            SText.Font = Enum.Font.GothamMedium
            SText.TextSize = 12
            SText.TextXAlignment = Enum.TextXAlignment.Left
            SText.Parent = SFrame

            local SVal = Instance.new("TextLabel")
            SVal.Size = UDim2.new(0, 30, 0, 20)
            SVal.Position = UDim2.new(1, -40, 0, 5)
            SVal.BackgroundTransparency = 1
            SVal.Text = tostring(SliderSettings.Default or SliderSettings.Min)
            SVal.TextColor3 = Theme.Accent
            SVal.Font = Enum.Font.GothamBold
            SVal.TextSize = 12
            SVal.TextXAlignment = Enum.TextXAlignment.Right
            SVal.Parent = SFrame

            -- Implementasi Slider geser dikosongin dulu biar simpel, ini cuma mock UI
            return SFrame
        end

        return TabObj
    end

    function WindowObj:SelectTab(TabObj)
        -- Simulasi select tab
    end

    return WindowObj
end

return RedzLib