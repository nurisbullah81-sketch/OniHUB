-- [[ ==========================================
--      CATHUB PREMIUM · REDZ HUB REPLICA v3.0
--      Part 1/5: Core Shell, Window, Tabs
--      Exact replica of original redzlib
--    ========================================== ]]

local Services = {
    CoreGui           = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
    TweenService      = game:GetService("TweenService"),
    UserInputService  = game:GetService("UserInputService"),
    HttpService       = game:GetService("HttpService"),
    RunService        = game:GetService("RunService"),
    Players           = game:GetService("Players"),
    MarketplaceService= game:GetService("MarketplaceService"),
    ClipboardService  = game:GetService("ClipboardService"),
}

local CoreGui         = Services.CoreGui
local TweenService    = Services.TweenService
local UserInputService= Services.UserInputService
local HttpService     = Services.HttpService
local RunService      = Services.RunService
local Players         = Services.Players
local Player          = Players.LocalPlayer

-- ==========================================
-- LIBRARY CONFIG
-- ==========================================
local CatHUB = {
    Themes = {
        Darker = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
            }),
            ["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"] = Color3.fromRGB(88, 101, 242),
            ["Color Text"] = Color3.fromRGB(243, 243, 243),
            ["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
        },
        Dark = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 40, 40)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(47.5, 47.5, 47.5)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 40))
            }),
            ["Color Hub 2"] = Color3.fromRGB(45, 45, 45),
            ["Color Stroke"] = Color3.fromRGB(65, 65, 65),
            ["Color Theme"] = Color3.fromRGB(65, 150, 255),
            ["Color Text"] = Color3.fromRGB(245, 245, 245),
            ["Color Dark Text"] = Color3.fromRGB(190, 190, 190)
        },
    },
    Save = {
        UISize = {550, 380},
        TabSize = 160,
        Theme = "Darker"
    },
    Settings = {},
    Connection = {},
    Instances = {},
    Elements = {},
    Options = {},
    Flags = {},
    Tabs = {},
}

local redzlib = CatHUB  -- Alias for internal use
local Theme = redzlib.Themes[redzlib.Save.Theme]

-- Viewport scale
local ViewportSize = workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 450

-- ==========================================
-- UTILITY FUNCTIONS
-- ==========================================
local function Create(className, parent, props, children)
    local obj = Instance.new(className)
    if parent then obj.Parent = parent end
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = obj
        end
    end
    return obj
end

local function Tween(obj, props, duration, easing, waitFlag)
    local info = TweenInfo.new(duration or 0.25, easing or Enum.EasingStyle.Quint)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    if waitFlag then
        tween.Completed:Wait()
    end
    return tween
end

local function MakeDrag(object)
    object.Active = true
    object.AutoButtonColor = false
    local dragStart, startPos, inputOn
    
    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X / UIScale,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y / UIScale
        )
        Tween(object, {Position = newPos}, 0.35)
    end
    
    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startPos = object.Position
            dragStart = input.Position
            inputOn = true
            while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                RunService.Heartbeat:Wait()
                if inputOn then update(input) end
            end
            inputOn = false
        end
    end)
    return object
end

local function ConnectSave(object, func)
    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do task.wait() end
            func()
        end
    end)
end

-- ==========================================
-- SCREEN GUI
-- ==========================================
local ScreenGui = Create("ScreenGui", CoreGui, {
    Name = "CatHUB",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, {
    Create("UIScale", { Scale = UIScale, Name = "Scale" })
})

-- Anti-duplicate
if CoreGui:FindFirstChild(ScreenGui.Name) and CoreGui:FindFirstChild(ScreenGui.Name) ~= ScreenGui then
    CoreGui:FindFirstChild(ScreenGui.Name):Destroy()
end

-- ==========================================
-- WINDOW BUILDER
-- ==========================================
local function MakeWindow(configs)
    local TitleText = configs[1] or configs.Name or configs.Title or "CatHUB"
    local SubTitleText = configs[2] or configs.SubTitle or ""
    local SaveFile = configs[3] or configs.SaveFolder or false
    
    redzlib.Settings.ScriptFile = SaveFile
    
    local UISizeX, UISizeY = unpack(redzlib.Save.UISize)
    
    -- Main frame with gradient
    local MainFrame = Create("ImageButton", ScreenGui, {
        Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2),
        BackgroundTransparency = 0.03,
        Name = "Hub",
        AutoButtonColor = false,
    }, {
        Create("UIGradient", {
            Color = Theme["Color Hub 1"],
            Rotation = 45,
            Name = "Gradient"
        })
    })
    MakeDrag(MainFrame)
    
    local MainCorner = Create("UICorner", MainFrame, {
        CornerRadius = UDim.new(0, 7)
    })
    
    local Components = Create("Folder", MainFrame, { Name = "Components" })
    local DropdownHolder = Create("Folder", ScreenGui, { Name = "Dropdown" })
    
    -- Top Bar
    local TopBar = Create("Frame", Components, {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Name = "Top Bar"
    })
    
    local Title = Create("TextLabel", TopBar, {
        Position = UDim2.new(0, 15, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        AutomaticSize = "XY",
        Text = TitleText,
        TextXAlignment = "Left",
        TextSize = 12,
        TextColor3 = Theme["Color Text"],
        BackgroundTransparency = 1,
        Font = Enum.Font.BuilderSansBold,
        Name = "Title"
    })
    local SubTitle = Create("TextLabel", {
        Size = UDim2.fromScale(0, 1),
        AutomaticSize = "X",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(1, 5, 0.9),
        Text = SubTitleText,
        TextColor3 = Theme["Color Dark Text"],
        BackgroundTransparency = 1,
        TextXAlignment = "Left",
        TextYAlignment = "Bottom",
        TextSize = 8,
        Font = Enum.Font.Gotham,
        Name = "SubTitle",
        Parent = Title
    })
    
    -- Sidebar (Tab Scroll)
    local TabScroll = Create("ScrollingFrame", Components, {
        Size = UDim2.new(0, redzlib.Save.TabSize, 1, -TopBar.Size.Y.Offset),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        ScrollBarThickness = 1.5,
        BackgroundTransparency = 1,
        ScrollBarImageColor3 = Theme["Color Theme"],
        ScrollBarImageTransparency = 0.2,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y",
        BorderSizePixel = 0,
        Name = "Tab Scroll",
    }, {
        Create("UIPadding", { PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8), PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10) }),
        Create("UIListLayout", { Padding = UDim.new(0,5) })
    })
    
    -- Content Area
    local Containers = Create("Frame", Components, {
        Size = UDim2.new(1, -TabScroll.Size.X.Offset, 1, -TopBar.Size.Y.Offset),
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Name = "Containers"
    })
    
    -- Resize handles
    local ResizeWindow = MakeDrag(Create("ImageButton", MainFrame, {
        Size = UDim2.new(0, 35, 0, 35),
        Position = MainFrame.Size,
        AnchorPoint = Vector2.new(0.8, 0.8),
        BackgroundTransparency = 1,
        Active = true,
        Name = "Control Hub Size"
    }))
    local ResizeTab = MakeDrag(Create("ImageButton", MainFrame, {
        Size = UDim2.new(0, 20, 1, -30),
        Position = UDim2.new(0, TabScroll.Size.X.Offset, 1, 0),
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Active = true,
        Name = "Control Tab Size"
    }))
    
    local function UpdateSizes()
        local newTabSize = math.clamp(ResizeTab.Position.X.Offset, 135, 250)
        local newWindowX = math.clamp(ResizeWindow.Position.X.Offset, 430, 1000)
        local newWindowY = math.clamp(ResizeWindow.Position.Y.Offset, 200, 500)
        
        TabScroll.Size = UDim2.new(0, newTabSize, 1, -TopBar.Size.Y.Offset)
        Containers.Size = UDim2.new(1, -newTabSize, 1, -TopBar.Size.Y.Offset)
        MainFrame.Size = UDim2.fromOffset(newWindowX, newWindowY)
    end
    
    ResizeWindow:GetPropertyChangedSignal("Position"):Connect(UpdateSizes)
    ResizeTab:GetPropertyChangedSignal("Position"):Connect(UpdateSizes)
    
    ConnectSave(ResizeWindow, function() 
        if not Minimized then
            redzlib.Save.UISize = {MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset}
        end
    end)
    ConnectSave(ResizeTab, function() 
        redzlib.Save.TabSize = TabScroll.Size.X.Offset
    end)
    
    -- Control buttons
    local CloseButton = Create("ImageButton", TopBar, {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(1, -10, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10747384394", -- X icon
        AutoButtonColor = false,
        Name = "Close"
    })
    local MinimizeButton = Create("ImageButton", TopBar, {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(1, -35, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10734896206", -- minus icon
        AutoButtonColor = false,
        Name = "Minimize"
    })
    
    local Minimized, SaveSize, WaitClick = false, nil, false
    
    local function MinimizeToggle()
        if WaitClick then return end
        WaitClick = true
        if Minimized then
            MinimizeButton.Image = "rbxassetid://10734896206"
            Tween(MainFrame, {Size = SaveSize}, 0.25, nil, true)
            ResizeWindow.Visible = true
            ResizeTab.Visible = true
            Minimized = false
        else
            MinimizeButton.Image = "rbxassetid://10734924532" -- plus icon
            SaveSize = MainFrame.Size
            ResizeWindow.Visible = false
            ResizeTab.Visible = false
            Tween(MainFrame, {Size = UDim2.fromOffset(MainFrame.Size.X.Offset, 28)}, 0.25, nil, true)
            Minimized = true
        end
        WaitClick = false
    end
    MinimizeButton.Activated:Connect(MinimizeToggle)
    
    -- Dialog system
    local function ShowDialog(configs)
        local DTitle = configs[1] or configs.Title or "Dialog"
        local DText = configs[2] or configs.Text or "This is a dialog"
        local DOptions = configs[3] or configs.Options or {}
        
        local Screen = Create("Frame", MainFrame, {
            BackgroundTransparency = 0.6,
            Active = true,
            BackgroundColor3 = Color3.fromRGB(0,0,0),
            Size = UDim2.new(1,0,1,0),
            Name = "Dialog",
        })
        MainCorner:Clone().Parent = Screen
        
        local Frame = Create("Frame", Screen, {
            Size = UDim2.fromOffset(250,150),
            Position = UDim2.fromScale(0.5,0.5),
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 0,
            BackgroundColor3 = Theme["Color Hub 2"]
        }, {
            Create("UIGradient", { Color = Theme["Color Hub 1"], Rotation = 270 }),
            Create("UICorner", { CornerRadius = UDim.new(0,6) }),
            Create("TextLabel", {
                Font = Enum.Font.GothamBold,
                Size = UDim2.new(1,0,0,20),
                Text = DTitle,
                TextXAlignment = "Left",
                TextColor3 = Theme["Color Text"],
                TextSize = 15,
                Position = UDim2.fromOffset(15,5),
                BackgroundTransparency = 1
            }),
            Create("TextLabel", {
                Font = Enum.Font.GothamMedium,
                Size = UDim2.new(1,-25),
                AutomaticSize = "Y",
                Text = DText,
                TextXAlignment = "Left",
                TextColor3 = Theme["Color Dark Text"],
                TextSize = 12,
                Position = UDim2.fromOffset(15,25),
                BackgroundTransparency = 1,
                TextWrapped = true
            }),
            Create("Frame", {
                Size = UDim2.fromScale(1,0.35),
                Position = UDim2.fromScale(0,1),
                AnchorPoint = Vector2.new(0,1),
                BackgroundColor3 = Theme["Color Hub 2"],
                BackgroundTransparency = 1,
                Name = "ButtonsHolder"
            })
        })
        
        local ButtonsHolder = Frame.ButtonsHolder
        local ButtonCount = 0
        
        -- Fill buttons
        for _, opt in ipairs(DOptions) do
            local name, callback = opt[1], opt[2] or function()end
            ButtonCount = ButtonCount + 1
            local btn = Create("TextButton", ButtonsHolder, {
                Text = name,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme["Color Text"],
                TextSize = 12,
                BackgroundColor3 = Theme["Color Hub 2"],
                AutoButtonColor = false
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0,4) })
            })
            btn.MouseButton1Click:Connect(function()
                Screen:Destroy()
                callback()
            end)
        end
        
        -- Adjust button sizes
        for _, btn in ipairs(ButtonsHolder:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.Size = UDim2.new(1/ButtonCount - ((ButtonCount-1)*10)/ButtonCount, 0, 0, 32)
            end
        end
        Create("UIListLayout", ButtonsHolder, {
            Padding = UDim.new(0,10),
            VerticalAlignment = "Center",
            FillDirection = "Horizontal",
            HorizontalAlignment = "Center"
        })
        
        -- Show animation
        Tween(Frame, {Size = UDim2.fromOffset(200,120)}, 0.2)
        Tween(Frame, {Size = UDim2.fromOffset(250,150)}, 0.15)
        
        return {
            Close = function() Screen:Destroy() end
        }
    end
    
    -- Window methods
    local Window = {}
    local FirstTab = false
    
    function Window:Minimize()
        MainFrame.Visible = not MainFrame.Visible
    end
    function Window:CloseBtn()
        ShowDialog({
            Title = "Close",
            Text = "Do you want to close the UI?",
            Options = {
                {"Yes", function() ScreenGui:Destroy() end},
                {"No", function() end}
            }
        })
    end
    function Window:AddMinimizeButton(configs)
        local btn = MakeDrag(Create("ImageButton", ScreenGui, {
            Size = UDim2.fromOffset(35,35),
            Position = UDim2.fromScale(0.15,0.15),
            BackgroundTransparency = 1,
            BackgroundColor3 = Theme["Color Hub 2"],
            AutoButtonColor = false,
            Image = configs.Image or ""
        }, {
            configs.Corner and Create("UICorner", configs.Corner),
            configs.Stroke and Create("UIStroke", configs.Stroke)
        }))
        btn.Activated:Connect(Window.Minimize)
        return { Button = btn }
    end
    function Window:MakeTab(configs)
        local TabName = configs[1] or configs.Title or "Tab"
        local TabIcon = configs[2] or configs.Icon or ""
        
        if not TabIcon:find("rbxassetid://") or #TabIcon:gsub("rbxassetid://","") < 6 then
            TabIcon = false
        end
        
        -- Sidebar button
        local TabBtn = Create("TextButton", TabScroll, {
            Size = UDim2.new(1,0,0,24),
            Text = "",
            BackgroundColor3 = Theme["Color Hub 2"],
            AutoButtonColor = false,
            Name = TabName.."_TabBtn"
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0,6) })
        })
        local TabIconImg = Create("ImageLabel", TabBtn, {
            Position = UDim2.new(0, 8, 0.5),
            Size = UDim2.new(0, 13, 0, 13),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = TabIcon or "",
            BackgroundTransparency = 1,
            ImageTransparency = FirstTab and 0.3 or 0
        })
        local TabTitle = Create("TextLabel", TabBtn, {
            Size = UDim2.new(1, TabIcon and -25 or -15, 1),
            Position = UDim2.fromOffset(TabIcon and 25 or 15),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = Theme["Color Text"],
            TextSize = 10,
            TextXAlignment = "Left",
            TextTransparency = FirstTab and 0.3 or 0,
            TextTruncate = "AtEnd"
        })
        local Selected = Create("Frame", TabBtn, {
            Size = FirstTab and UDim2.new(0,4,0,4) or UDim2.new(0,4,0,13),
            Position = UDim2.new(0,1,0.5),
            AnchorPoint = Vector2.new(0,0.5),
            BackgroundColor3 = Theme["Color Theme"],
            BackgroundTransparency = FirstTab and 1 or 0,
            Name = "Indicator"
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0.5,0) })
        })
        
        -- Container page
        local Container = Create("ScrollingFrame", {
            Size = UDim2.new(1,0,1,0),
            Position = UDim2.new(0,0,1),
            AnchorPoint = Vector2.new(0,1),
            ScrollBarThickness = 1.5,
            BackgroundTransparency = 1,
            ScrollBarImageColor3 = Theme["Color Theme"],
            ScrollBarImageTransparency = 0.2,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = "Y",
            ScrollingDirection = "Y",
            BorderSizePixel = 0,
            Name = TabName.."_Page",
        }, {
            Create("UIPadding", {
                PaddingLeft = UDim.new(0,10),
                PaddingRight = UDim.new(0,10),
                PaddingTop = UDim.new(0,10),
                PaddingBottom = UDim.new(0,10)
            }),
            Create("UIListLayout", { Padding = UDim.new(0,5) })
        })
        
        if not FirstTab then Container.Parent = Containers end
        FirstTab = true
        
        table.insert(redzlib.Tabs, {Cont = Container, func = { Enable = function() end, Disable = function() end }})
        
        -- Tab switching logic
        local function EnableTab()
            for _, otherTab in pairs(redzlib.Tabs) do
                if otherTab.Cont ~= Container and otherTab.Cont.Parent then
                    otherTab.Cont.Parent = nil
                end
            end
            Container.Parent = Containers
            Container.Size = UDim2.new(1,0,1,150)
            Tween(Container, {Size = UDim2.new(1,0,1,0)}, 0.3)
            Tween(TabTitle, {TextTransparency = 0}, 0.35)
            Tween(TabIconImg, {ImageTransparency = 0}, 0.35)
            Tween(Selected, {Size = UDim2.new(0,4,0,13), BackgroundTransparency = 0}, 0.35)
        end
        TabBtn.Activated:Connect(EnableTab)
        
        if #redzlib.Tabs == 1 then EnableTab() end
        
        local Tab = {
            Cont = Container,
            Enable = EnableTab,
            Disable = function() Container.Parent = nil end
        }
        return Tab
    end
    
    -- Assign events
    CloseButton.Activated:Connect(Window.CloseBtn)
    
    -- Store to global for later parts
    _G.CatHUB = {
        Window = Window,
        Theme = Theme,
        Utilities = {
            Create = Create,
            Tween = Tween,
            MakeDrag = MakeDrag,
            ConnectSave = ConnectSave,
        },
        Core = {
            ScreenGui = ScreenGui,
            MainFrame = MainFrame,
            Containers = Containers,
            TabScroll = TabScroll,
        },
        Data = {
            Flags = redzlib.Flags,
            Settings = redzlib.Settings,
        }
    }
    
    return Window
end

-- ==========================================
-- EXPORT
-- ==========================================
return {
    MakeWindow = MakeWindow,
    Themes = CatHUB.Themes,
}



-- [[ ==========================================
--      CATHUB PREMIUM · REDZ HUB REPLICA v3.0
--      Part 2/5: Component Builders
--      ========================================== ]]

local CatHUB = _G.CatHUB
local Window = CatHUB.Window
local Theme = CatHUB.Theme
local Create = CatHUB.Utilities.Create
local Tween = CatHUB.Utilities.Tween
local MakeDrag = CatHUB.Utilities.MakeDrag

-- Local references to services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- ==========================================
-- COMPONENT BUILDERS
-- ==========================================

local function CreateSection(parent, Title)
    local frame = Create("Frame", parent, {
        Size = UDim2.new(1,0,0,20),
        BackgroundTransparency = 1,
        Name = "Option"
    })
    Create("TextLabel", frame, {
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme["Color Text"],
        Size = UDim2.new(1,-25,1,0),
        Position = UDim2.new(0,5),
        BackgroundTransparency = 1,
        TextTruncate = "AtEnd",
        TextSize = 14,
        TextXAlignment = "Left"
    })
    return frame
end

local function CreateParagraph(parent, Title, Description)
    local frame = Create("TextButton", parent, {
        Size = UDim2.new(1,0,0,25),
        AutomaticSize = "Y",
        BackgroundColor3 = Theme["Color Hub 2"],
        AutoButtonColor = false,
        Text = "",
        Name = "Option"
    })
    Create("UICorner", frame, { CornerRadius = UDim.new(0,6) })
    
    local labelHolder = Create("Frame", frame, {
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-20),
        Position = UDim2.new(0,10,0),
        AnchorPoint = Vector2.new(0,0),
    }, {
        Create("UIListLayout", {
            SortOrder = "LayoutOrder",
            VerticalAlignment = "Center",
            Padding = UDim.new(0,2)
        }),
        Create("UIPadding", {
            PaddingBottom = UDim.new(0,5),
            PaddingTop = UDim.new(0,5)
        }),
        Create("TextLabel", {
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme["Color Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Title,
            TextSize = 10,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true
        }),
        Create("TextLabel", {
            Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Dark Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Description or "",
            TextSize = 8,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true,
            TextWrapped = true
        })
    })
    
    return frame
end

local function CreateToggle(parent, Title, Description, Default, Flag, Callback)
    local frame = Create("TextButton", parent, {
        Size = UDim2.new(1,0,0,25),
        AutomaticSize = "Y",
        BackgroundColor3 = Theme["Color Hub 2"],
        AutoButtonColor = false,
        Text = "",
        Name = Title.."_Toggle"
    })
    Create("UICorner", frame, { CornerRadius = UDim.new(0,6) })
    
    -- Label holder
    local labelHolder = Create("Frame", frame, {
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-38),
        Position = UDim2.new(0,10,0),
        AnchorPoint = Vector2.new(0,0),
    }, {
        Create("UIListLayout", {
            SortOrder = "LayoutOrder",
            VerticalAlignment = "Center",
            Padding = UDim.new(0,2)
        }),
        Create("UIPadding", {
            PaddingBottom = UDim.new(0,5),
            PaddingTop = UDim.new(0,5)
        }),
        Create("TextLabel", {
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme["Color Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Title,
            TextSize = 10,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true
        }),
        Description and Create("TextLabel", {
            Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Dark Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Description,
            TextSize = 8,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true,
            TextWrapped = true
        }) or nil
    })
    
    -- Toggle track
    local track = Create("Frame", frame, {
        Size = UDim2.new(0,35,0,18),
        Position = UDim2.new(1,-10,0.5),
        AnchorPoint = Vector2.new(1,0.5),
        BackgroundColor3 = Theme["Color Stroke"],
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0.5,0) })
    })
    local slider = Create("Frame", track, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8,0,0.8,0),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5)
    })
    local dot = Create("Frame", slider, {
        Size = UDim2.new(0,12,0,12),
        Position = UDim2.new(0,0,0.5),
        AnchorPoint = Vector2.new(0,0.5),
        BackgroundColor3 = Theme["Color Theme"],
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0.5,0) })
    })
    
    -- State
    local state = Default or false
    local waitClick = false
    local function setState(newState)
        if waitClick then return end
        waitClick = true
        state = newState
        if state then
            Tween(dot, {Position = UDim2.new(1,0,0.5), BackgroundTransparency = 0, AnchorPoint = Vector2.new(1,0.5)}, 0.25, nil, false)
        else
            Tween(dot, {Position = UDim2.new(0,0,0.5), BackgroundTransparency = 0.8, AnchorPoint = Vector2.new(0,0.5)}, 0.25, nil, false)
        end
        if Flag then redzlib.Flags[Flag] = state end
        if Callback then Callback(state) end
        waitClick = false
    end
    setState(state)
    
    frame.MouseButton1Click:Connect(function()
        setState(not state)
    end)
    
    return frame
end

local function CreateButton(parent, Title, Description, Callback)
    local frame = Create("TextButton", parent, {
        Size = UDim2.new(1,0,0,25),
        AutomaticSize = "Y",
        BackgroundColor3 = Theme["Color Hub 2"],
        AutoButtonColor = false,
        Text = "",
        Name = Title.."_Btn"
    })
    Create("UICorner", frame, { CornerRadius = UDim.new(0,6) })
    
    -- Label
    local labelHolder = Create("Frame", frame, {
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-20),
        Position = UDim2.new(0,10,0),
        AnchorPoint = Vector2.new(0,0),
    }, {
        Create("UIListLayout", {
            SortOrder = "LayoutOrder",
            VerticalAlignment = "Center",
            Padding = UDim.new(0,2)
        }),
        Create("UIPadding", {
            PaddingBottom = UDim.new(0,5),
            PaddingTop = UDim.new(0,5)
        }),
        Create("TextLabel", {
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme["Color Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Title,
            TextSize = 10,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true
        }),
        Description and Create("TextLabel", {
            Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Dark Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Description,
            TextSize = 8,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true,
            TextWrapped = true
        }) or nil
    })
    
    -- Arrow icon
    Create("ImageLabel", frame, {
        Size = UDim2.new(0,14,0,14),
        Position = UDim2.new(1,-10,0.5),
        AnchorPoint = Vector2.new(1,0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10709791437" -- arrow right
    })
    
    frame.MouseButton1Click:Connect(Callback or function() end)
    return frame
end

local function CreateDropdown(parent, Title, Description, Options, Default, MultiSelect, Flag, Callback)
    local Multi = MultiSelect or false
    local Selected = Multi and {} or (type(Default) == "table" and Default[1] or Default or Options[1])
    if Multi and type(Default) == "table" then
        for _, val in pairs(Default) do
            Selected[val] = true
        end
    end
    
    -- Main button
    local frame = Create("TextButton", parent, {
        Size = UDim2.new(1,0,0,25),
        AutomaticSize = "Y",
        BackgroundColor3 = Theme["Color Hub 2"],
        AutoButtonColor = false,
        Text = "",
        Name = Title.."_Dropdown"
    })
    Create("UICorner", frame, { CornerRadius = UDim.new(0,6) })
    
    -- Label left
    local labelHolder = Create("Frame", frame, {
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-180),
        Position = UDim2.new(0,10,0),
        AnchorPoint = Vector2.new(0,0),
    }, {
        Create("UIListLayout", {
            SortOrder = "LayoutOrder",
            VerticalAlignment = "Center",
            Padding = UDim.new(0,2)
        }),
        Create("UIPadding", {
            PaddingBottom = UDim.new(0,5),
            PaddingTop = UDim.new(0,5)
        }),
        Create("TextLabel", {
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme["Color Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Title,
            TextSize = 10,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true
        }),
        Description and Create("TextLabel", {
            Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Dark Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Description,
            TextSize = 8,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true,
            TextWrapped = true
        }) or nil
    })
    
    -- Display selected value
    local display = Create("TextLabel", frame, {
        Size = UDim2.new(0,150,0,18),
        Position = UDim2.new(1,-10,0.5),
        AnchorPoint = Vector2.new(1,0.5),
        BackgroundColor3 = Theme["Color Stroke"],
        Font = Enum.Font.GothamBold,
        TextScaled = true,
        TextColor3 = Theme["Color Text"],
        Text = "...",
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0,4) }),
        Create("ImageLabel", {
            Size = UDim2.new(0,15,0,15),
            Position = UDim2.new(0,-5,0.5),
            AnchorPoint = Vector2.new(1,0.5),
            Image = "rbxassetid://10709791523", -- up arrow
            BackgroundTransparency = 1,
            Name = "Arrow"
        })
    })
    
    -- Dropdown options container (floating)
    local dropFrame = Create("Frame", nil, {
        Size = UDim2.new(0,152,0,0),
        BackgroundTransparency = 0.1,
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        ClipsDescendants = true,
        Active = true,
        Name = "DropdownFrame",
        Visible = false,
        Parent = (function()
            local holder = Create("Folder", ScreenGui, { Name = "DropdownHolder" })
            return holder
        end)(),
    })
    Create("UICorner", dropFrame, { CornerRadius = UDim.new(0,4) })
    Create("UIStroke", dropFrame, { Color = Theme["Color Stroke"] })
    Create("UIGradient", dropFrame, { Color = Theme["Color Hub 1"], Rotation = 60 })
    
    local scroll = Create("ScrollingFrame", dropFrame, {
        Size = UDim2.new(1,0,1,0),
        ScrollBarThickness = 1.5,
        BackgroundTransparency = 1,
        ScrollBarImageColor3 = Theme["Color Theme"],
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(),
        ScrollingDirection = "Y",
        AutomaticCanvasSize = "Y",
    }, {
        Create("UIPadding", {
            PaddingLeft = UDim.new(0,8),
            PaddingRight = UDim.new(0,8),
            PaddingTop = UDim.new(0,5),
            PaddingBottom = UDim.new(0,5)
        }),
        Create("UIListLayout", { Padding = UDim.new(0,4) })
    })
    
    local optionsCache = {}
    local function updateDisplay()
        if Multi then
            local list = {}
            for name, val in pairs(Selected) do
                if val then table.insert(list, name) end
            end
            display.Text = #list > 0 and table.concat(list, ", ") or "..."
        else
            display.Text = tostring(Selected or "...")
        end
    end
    
    local function selectOption(name, value)
        if Multi then
            Selected[name] = not Selected[name]
        else
            Selected = value
        end
        if Flag then redzlib.Flags[Flag] = Selected end
        if Callback then Callback(Selected) end
        updateDisplay()
        -- Highlight option
        for _, opt in pairs(optionsCache) do
            local isSelected = Multi and Selected[opt.name] or (Selected == opt.value)
            opt.dot.BackgroundTransparency = isSelected and 0 or 1
            opt.dot.Size = isSelected and UDim2.new(0,4,0,14) or UDim2.new(0,4,0,4)
            opt.text.TextTransparency = isSelected and 0 or 0.4
        end
    end
    
    local function openDropdown()
        if dropFrame.Visible then
            dropFrame.Visible = false
            Tween(dropFrame, { Size = UDim2.new(0,152,0,0) }, 0.2)
        else
            dropFrame.Visible = true
            Tween(dropFrame, { Size = UDim2.new(0,152,0, (#optionsCache * 25 + 10) ) }, 0.2)
        end
    end
    
    -- Build options
    for _, opt in ipairs(Options) do
        local name = tostring(opt)
        local value = opt
        local selectedNow = Multi and Selected[name] or (Selected == value)
        local optBtn = Create("TextButton", scroll, {
            Size = UDim2.new(1,0,0,21),
            Name = "Option",
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
        })
        local dot = Create("Frame", optBtn, {
            Position = UDim2.new(0,1,0.5),
            Size = UDim2.new(0,4,0,4),
            BackgroundColor3 = Theme["Color Theme"],
            BackgroundTransparency = selectedNow and 0 or 1,
            AnchorPoint = Vector2.new(0,0.5),
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0.5,0) })
        })
        local label = Create("TextLabel", optBtn, {
            Size = UDim2.new(1,0,1),
            Position = UDim2.new(0,10),
            Text = name,
            TextColor3 = Theme["Color Text"],
            Font = Enum.Font.GothamBold,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            TextTransparency = selectedNow and 0 or 0.4,
        })
        optBtn.MouseButton1Click:Connect(function()
            selectOption(name, value)
            openDropdown()
        end)
        table.insert(optionsCache, {name = name, value = value, dot = dot, text = label})
    end
    
    -- Position dropdown below the main button
    local function repositionDropdown()
        local absPos = display.AbsolutePosition
        local screenSize = ScreenGui.AbsoluteSize
        dropFrame.Position = UDim2.fromOffset(absPos.X / UIScale, (absPos.Y + display.AbsoluteSize.Y) / UIScale)
    end
    display:GetPropertyChangedSignal("AbsolutePosition"):Connect(repositionDropdown)
    repositionDropdown()
    
    -- Close on click outside
    local antiClick = Create("TextButton", nil, {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = "",
        Visible = false,
        Parent = ScreenGui,
        Name = "DropdownAntiClick",
    })
    antiClick.MouseButton1Click:Connect(function()
        dropFrame.Visible = false
        antiClick.Visible = false
    end)
    
    frame.MouseButton1Click:Connect(function()
        if dropFrame.Visible then
            dropFrame.Visible = false
            antiClick.Visible = false
            Tween(dropFrame, { Size = UDim2.new(0,152,0,0) }, 0.2)
        else
            dropFrame.Visible = true
            antiClick.Visible = true
            Tween(dropFrame, { Size = UDim2.new(0,152,0, (#optionsCache * 25 + 10) ) }, 0.2)
        end
    end)
    
    updateDisplay()
    return frame
end

local function CreateSlider(parent, Title, Description, Min, Max, Default, Step, Flag, Callback)
    local frame = Create("TextButton", parent, {
        Size = UDim2.new(1,0,0,25),
        AutomaticSize = "Y",
        BackgroundColor3 = Theme["Color Hub 2"],
        AutoButtonColor = false,
        Text = "",
        Name = Title.."_Slider"
    })
    Create("UICorner", frame, { CornerRadius = UDim.new(0,6) })
    
    -- Label left
    local labelHolder = Create("Frame", frame, {
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-180),
        Position = UDim2.new(0,10,0),
        AnchorPoint = Vector2.new(0,0),
    }, {
        Create("UIListLayout", {
            SortOrder = "LayoutOrder",
            VerticalAlignment = "Center",
            Padding = UDim.new(0,2)
        }),
        Create("UIPadding", {
            PaddingBottom = UDim.new(0,5),
            PaddingTop = UDim.new(0,5)
        }),
        Create("TextLabel", {
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme["Color Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Title,
            TextSize = 10,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true
        }),
        Description and Create("TextLabel", {
            Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Dark Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Description,
            TextSize = 8,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true,
            TextWrapped = true
        }) or nil
    })
    
    -- Slider track
    local sliderHolder = Create("TextButton", frame, {
        Size = UDim2.new(0.45,0,1),
        Position = UDim2.new(1,0),
        AnchorPoint = Vector2.new(1,0),
        AutoButtonColor = false,
        Text = "",
        BackgroundTransparency = 1,
    })
    local sliderBar = Create("Frame", sliderHolder, {
        BackgroundColor3 = Theme["Color Stroke"],
        Size = UDim2.new(1,-20,0,6),
        Position = UDim2.new(0.5,0,0.5),
        AnchorPoint = Vector2.new(0.5,0.5),
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0,3) })
    })
    local indicator = Create("Frame", sliderBar, {
        BackgroundColor3 = Theme["Color Theme"],
        Size = UDim2.fromScale(0.3,1),
        BorderSizePixel = 0,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0,3) })
    })
    local dotSlider = Create("Frame", sliderBar, {
        Size = UDim2.new(0,6,0,12),
        BackgroundColor3 = Color3.fromRGB(220,220,220),
        Position = UDim2.fromScale(0.3,0.5),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 0.2,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0,3) })
    })
    local valueLabel = Create("TextLabel", sliderHolder, {
        Size = UDim2.new(0,14,0,14),
        AnchorPoint = Vector2.new(1,0.5),
        Position = UDim2.new(0,0,0.5),
        BackgroundTransparency = 1,
        TextColor3 = Theme["Color Text"],
        Font = Enum.Font.FredokaOne,
        TextSize = 12,
        Text = tostring(Default)
    })
    
    local currentValue = Default
    local function updateValue()
        local scale = dotSlider.Position.X.Scale
        local val = math.floor((scale * (Max - Min) + Min) / Step + 0.5) * Step
        currentValue = val
        valueLabel.Text = tostring(val)
        indicator.Size = UDim2.new(scale,0,1,0)
        if Callback then Callback(val) end
    end
    
    local function setSlider(input)
        local mousePos = Player:GetMouse()
        local relX = (mousePos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
        relX = math.clamp(relX, 0, 1)
        dotSlider.Position = UDim2.fromScale(relX, 0.5)
    end
    
    sliderHolder.MouseButton1Down:Connect(function()
        Tween(dotSlider, {Transparency = 0}, 0.3)
        local scrOld = parent.ScrollingEnabled
        parent.ScrollingEnabled = false
        while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            setSlider()
            updateValue()
            task.wait()
        end
        Tween(dotSlider, {Transparency = 0.2}, 0.3)
        parent.ScrollingEnabled = scrOld
        if Flag then redzlib.Flags[Flag] = currentValue end
    end)
    
    -- Initialize
    local initScale = (Default - Min) / (Max - Min)
    dotSlider.Position = UDim2.fromScale(initScale, 0.5)
    updateValue()
    
    return frame
end

local function CreateTextBox(parent, Title, Description, Placeholder, ClearOnFocus, Flag, Callback)
    local frame = Create("TextButton", parent, {
        Size = UDim2.new(1,0,0,25),
        AutomaticSize = "Y",
        BackgroundColor3 = Theme["Color Hub 2"],
        AutoButtonColor = false,
        Text = "",
        Name = Title.."_TextBox"
    })
    Create("UICorner", frame, { CornerRadius = UDim.new(0,6) })
    
    -- Label left
    local labelHolder = Create("Frame", frame, {
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-38),
        Position = UDim2.new(0,10,0),
        AnchorPoint = Vector2.new(0,0),
    }, {
        Create("UIListLayout", {
            SortOrder = "LayoutOrder",
            VerticalAlignment = "Center",
            Padding = UDim.new(0,2)
        }),
        Create("UIPadding", {
            PaddingBottom = UDim.new(0,5),
            PaddingTop = UDim.new(0,5)
        }),
        Create("TextLabel", {
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme["Color Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Title,
            TextSize = 10,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true
        }),
        Description and Create("TextLabel", {
            Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Dark Text"],
            AutomaticSize = "Y",
            Size = UDim2.new(1,0),
            Text = Description,
            TextSize = 8,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            RichText = true,
            TextWrapped = true
        }) or nil
    })
    
    -- Input area
    local inputFrame = Create("Frame", frame, {
        Size = UDim2.new(0,150,0,18),
        Position = UDim2.new(1,-10,0.5),
        AnchorPoint = Vector2.new(1,0.5),
        BackgroundColor3 = Theme["Color Stroke"],
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0,4) }),
        Create("ImageLabel", {
            Size = UDim2.new(0,12,0,12),
            Position = UDim2.new(0,-5,0.5),
            AnchorPoint = Vector2.new(1,0.5),
            Image = "rbxassetid://15637081879", -- pencil
            BackgroundTransparency = 1,
        })
    })
    local textBox = Create("TextBox", inputFrame, {
        Size = UDim2.new(0.85,0,0.85,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(0.5,0,0.5,0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextScaled = true,
        TextColor3 = Theme["Color Text"],
        ClearTextOnFocus = ClearOnFocus,
        PlaceholderText = Placeholder or "",
        Text = "",
    })
    
    local function onInput()
        local text = textBox.Text
        if text:gsub(" ",""):len() > 0 then
            if Flag then redzlib.Flags[Flag] = text end
            if Callback then Callback(text) end
        end
    end
    textBox.FocusLost:Connect(onInput)
    onInput()
    
    textBox.FocusLost:Connect(function()
        Tween(inputFrame.ImageLabel, {ImageColor3 = Color3.fromRGB(255,255,255)}, 0.2)
    end)
    textBox.Focused:Connect(function()
        Tween(inputFrame.ImageLabel, {ImageColor3 = Theme["Color Theme"]}, 0.2)
    end)
    
    return frame
end

-- ==========================================
-- EXTEND TAB OBJECT WITH BUILDERS
-- ==========================================
-- Since the existing Tab object returned by MakeTab currently only has {Cont, Enable, Disable},
-- we need to add these builders to that object. We'll do it by modifying the original MakeTab function.
-- But for Part 2, we'll monkey-patch the Tab returned by the last call or override Window:MakeTab.
-- Better: rewrite MakeTab to include these methods. However, to avoid conflict, we'll just provide
-- a function that takes a Tab and adds the builders. But the user expects to call Tab:AddSection etc.
-- So we need to modify the Tab prototype.

-- The original MakeTab in Part 1 creates a Tab table and returns it. We'll capture that function
-- and wrap it to add our builders. That's the clean approach.

-- Save original MakeTab
local originalMakeTab = Window.MakeTab

function Window:MakeTab(configs)
    local Tab = originalMakeTab(self, configs)  -- Get the base Tab
    
    -- Now add our builders
    Tab.AddSection = function(self, title) return CreateSection(self.Cont, title) end
    Tab.AddParagraph = function(self, title, desc) return CreateParagraph(self.Cont, title, desc) end
    Tab.AddToggle = function(self, title, desc, default, flag, callback)
        return CreateToggle(self.Cont, title, desc, default, flag, callback)
    end
    Tab.AddButton = function(self, title, desc, callback)
        return CreateButton(self.Cont, title, desc, callback)
    end
    Tab.AddDropdown = function(self, title, desc, options, default, multiselect, flag, callback)
        return CreateDropdown(self.Cont, title, desc, options, default, multiselect, flag, callback)
    end
    Tab.AddSlider = function(self, title, desc, min, max, default, step, flag, callback)
        return CreateSlider(self.Cont, title, desc, min, max, default, step, flag, callback)
    end
    Tab.AddTextBox = function(self, title, desc, placeholder, cleartext, flag, callback)
        return CreateTextBox(self.Cont, title, desc, placeholder, cleartext, flag, callback)
    end
    Tab.AddWebhookBox = function(self, title, desc, placeholder, flag)
        -- Same as textbox, used for webhook URL input
        return CreateTextBox(self.Cont, title, desc, placeholder, false, flag)
    end
    
    return Tab
end

warn("[CatHUB v2.0] Part 2 loaded: All component builders attached to Tab.")

-- [[ ==========================================
--      CATHUB PREMIUM · REDZ HUB REPLICA v3.0
--      Part 3/3: Global API, Invite, Save/Load
--      ========================================== ]]

-- Part 3 ini melengkapi library dengan:
-- - Fungsi global (GetIcon, SetTheme, SetScale)
-- - Sistem penyimpanan flag/theme otomatis ke file
-- - Komponen DiscordInvite
-- - Koneksi event (FlagsChanged, ThemeChanged, dll.)

-- Pastikan Part 1 dan Part 2 sudah dijalankan lebih dulu
local CatHUB = _G.CatHUB
local redzlib = CatHUB  -- Tabel utama
local Theme = CatHUB.Theme
local Create = CatHUB.Utilities.Create
local Tween = CatHUB.Utilities.Tween
local MakeDrag = CatHUB.Utilities.MakeDrag

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- ==========================================
-- SIMPAN & MUAT SETTING
-- ==========================================
local Flags, Settings = redzlib.Flags, redzlib.Settings

-- Daftar koneksi event (global)
local Connections = {
    FlagsChanged = {},
    ThemeChanged = {},
    FileSaved = {},
    ThemeChanging = {},
    OptionAdded = {}
}

-- Fungsi untuk memicu event
function redzlib:FireConnection(name, ...)
    if Connections[name] then
        for _, func in ipairs(Connections[name]) do
            task.spawn(func, ...)
        end
    end
end

-- Simpan flags ke file saat ada perubahan
local lastWrite = 0
local function saveFlags()
    if not Settings.ScriptFile or not writefile then return end
    if tick() - lastWrite < 0.5 then return end -- debounce
    lastWrite = tick()
    pcall(function()
        writefile(Settings.ScriptFile, HttpService:JSONEncode(Flags))
        redzlib:FireConnection("FileSaved", "Flags", Settings.ScriptFile)
    end)
end

-- Muat flags dari file
local function loadFlags()
    if not Settings.ScriptFile or not isfile or not readfile then return end
    local file = Settings.ScriptFile
    if isfile(file) then
        pcall(function()
            local data = readfile(file)
            local decoded = HttpService:JSONDecode(data)
            if type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    Flags[k] = v
                end
            end
        end)
    end
end
loadFlags()

-- Sambungkan ke event FlagsChanged untuk auto-save
table.insert(Connections.FlagsChanged, function(flag, value)
    saveFlags()
end)

-- ==========================================
-- SIMPAN/MUAT TEMA & UKURAN
-- ==========================================
local function saveConfig()
    if not writefile then return end
    pcall(function()
        writefile("redz library V5.json", HttpService:JSONEncode({
            UISize = redzlib.Save.UISize,
            TabSize = redzlib.Save.TabSize,
            Theme = redzlib.Save.Theme,
        }))
    end)
end

local function loadConfig()
    if not readfile or not isfile then return end
    local file = "redz library V5.json"
    if isfile(file) then
        pcall(function()
            local data = readfile(file)
            local decoded = HttpService:JSONDecode(data)
            if type(decoded) == "table" then
                if decoded.UISize then redzlib.Save.UISize = decoded.UISize end
                if decoded.TabSize then redzlib.Save.TabSize = decoded.TabSize end
                if decoded.Theme and VerifyTheme(decoded.Theme) then redzlib.Save.Theme = decoded.Theme end
            end
        end)
    end
end
loadConfig()

-- Sambungkan event ThemeChanged untuk simpan
table.insert(Connections.ThemeChanged, function(newTheme)
    if VerifyTheme(newTheme) then
        redzlib.Save.Theme = newTheme
        saveConfig()
    end
end)

-- ==========================================
-- VERIFIKASI TEMA
-- ==========================================
function redzlib:VerifyTheme(name)
    for themeName, _ in pairs(self.Themes) do
        if themeName == name then return true end
    end
    return false
end

-- ==========================================
-- FITUR GLOBAL
-- ==========================================

-- Dapatkan icon berdasarkan nama (mirip Google Material Icons)
function redzlib:GetIcon(name)
    local Icons = self.Icons or {}
    if not name or name:find("rbxassetid://") or #name == 0 then
        return name
    end
    local search = name:lower():gsub("lucide", ""):gsub("-", "")
    if Icons[search] then return Icons[search] end
    for iconName, id in pairs(Icons) do
        if iconName == search or iconName:find(search, 1, true) then
            return id
        end
    end
    return name -- fallback
end

-- Ganti tema
function redzlib:SetTheme(newTheme)
    if not redzlib:VerifyTheme(newTheme) then return end
    Theme = self.Themes[newTheme]
    redzlib:FireConnection("ThemeChanging", newTheme)
    for _, instanceData in ipairs(self.Instances) do
        local instance = instanceData.Instance
        local t = instanceData.Type
        if t == "Gradient" then
            instance.Color = Theme["Color Hub 1"]
        elseif t == "Frame" then
            instance.BackgroundColor3 = Theme["Color Hub 2"]
        elseif t == "Stroke" then
            instance[instance:IsA("UIStroke") and "Color" or "ImageColor3"] = Theme["Color Stroke"]
        elseif t == "Theme" then
            instance[instance:IsA("Frame") and "BackgroundColor3" or "ImageColor3" or "TextColor3"] = Theme["Color Theme"]
        elseif t == "Text" then
            instance.TextColor3 = Theme["Color Text"]
        elseif t == "DarkText" then
            instance.TextColor3 = Theme["Color Dark Text"]
        elseif t == "ScrollBar" then
            instance.ScrollBarImageColor3 = Theme["Color Theme"]
        end
    end
    redzlib:FireConnection("ThemeChanged", newTheme)
end

-- Ubah skala UI
function redzlib:SetScale(newScale)
    local viewportY = workspace.CurrentCamera.ViewportSize.Y
    newScale = viewportY / math.clamp(newScale, 300, 2000)
    UIScale = newScale
    ScreenGui.Scale.Scale = newScale
end

-- ==========================================
-- KOMPONEN DISCORD INVITE CARD
-- ==========================================
function Window:AddDiscordInvite(configs)
    local title = configs[1] or configs.Title or "Discord"
    local desc = configs[2] or configs.Description or "Join our server"
    local logo = configs.Logo or ""
    local invite = configs.Invite or ""
    
    -- Butuh akses ke Container dari Tab aktif? Karena dipanggil dari Tab, namun kita tambahkan sebagai metode Window sementara
    -- Seharusnya ini adalah metode Tab, tapi bisa juga sebagai bagian dari Window. Agar sesuai aslinya, kita letakkan sebagai method Tab.
    -- Namun karena di sini kode terpisah, kita definisikan sebagai method Window lalu nanti ditempel ke Tab.
    local container = parent  -- nanti akan diisi dari Tab.Cont
    local frame = Create("Frame", container, {
        Size = UDim2.new(1,0,0,80),
        BackgroundTransparency = 1,
        Name = "Option"
    })
    local inviteLabel = Create("TextLabel", frame, {
        Size = UDim2.new(1,0,0,15),
        Position = UDim2.new(0,5),
        TextColor3 = Color3.fromRGB(40,150,255),
        Font = Enum.Font.GothamBold,
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 10,
        Text = invite
    })
    local cardFrame = Create("Frame", frame, {
        Size = UDim2.new(1,0,0,65),
        AnchorPoint = Vector2.new(0,1),
        Position = UDim2.new(0,0,1),
        BackgroundColor3 = Theme["Color Hub 2"],
    })
    Create("UICorner", cardFrame, { CornerRadius = UDim.new(0,6) })
    
    if logo ~= "" then
        local logoImg = Create("ImageLabel", cardFrame, {
            Size = UDim2.new(0,30,0,30),
            Position = UDim2.new(0,7,0,7),
            Image = logo,
            BackgroundTransparency = 1,
        })
        Create("UICorner", logoImg, { CornerRadius = UDim.new(0,4) })
    end
    
    Create("TextLabel", cardFrame, {
        Size = UDim2.new(1,-52,0,15),
        Position = UDim2.new(0,44,0,7),
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme["Color Text"],
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 10,
        Text = title,
    })
    Create("TextLabel", cardFrame, {
        Size = UDim2.new(1,-52,0,0),
        Position = UDim2.new(0,44,0,22),
        TextWrapped = true,
        AutomaticSize = "Y",
        Font = Enum.Font.Gotham,
        TextColor3 = Theme["Color Dark Text"],
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 8,
        Text = desc,
    })
    
    local joinBtn = Create("TextButton", cardFrame, {
        Size = UDim2.new(1,-14,0,16),
        AnchorPoint = Vector2.new(0.5,1),
        Position = UDim2.new(0.5,0,1,-7),
        Text = "Join",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(220,220,220),
        BackgroundColor3 = Color3.fromRGB(50,150,50),
    })
    Create("UICorner", joinBtn, { CornerRadius = UDim.new(0,5) })
    
    local clickDelay = false
    joinBtn.MouseButton1Click:Connect(function()
        if invite ~= "" then
            pcall(function()
                setclipboard(invite)
            end)
            if not clickDelay then
                clickDelay = true
                joinBtn.Text = "Copied!"
                joinBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
                task.wait(2)
                joinBtn.Text = "Join"
                joinBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
                clickDelay = false
            end
        end
    end)
    return frame
end

-- ==========================================
-- SAMBUNGKAN AddDiscordInvite KE TAB
-- ==========================================
-- Karena Part 2 sudah mendefinisikan Tab, kita perlu menambahkan metode ini ke setiap Tab.
-- Asumsi Window:MakeTab sudah di-wrap, jadi kita tambahkan saja di bagian setelah MakeTab di-override.
-- Namun di Part 2 kita sudah override dan tidak ada method ini. Kita akan patch ulang di sini.

local originalMakeTab = Window.MakeTab

Window.MakeTab = function(self, configs)
    local Tab = originalMakeTab(self, configs)
    -- Tambahkan DiscordInvite
    local container = Tab.Cont
    function Tab:AddDiscordInvite(configs)
        return AddDiscordInviteToTab(container, configs)
    end
    return Tab
end

function AddDiscordInviteToTab(container, configs)
    -- Replikasi kode yang sama seperti di atas, tapi dengan container sebagai parent
    local frame = Create("Frame", container, {
        Size = UDim2.new(1,0,0,80),
        BackgroundTransparency = 1,
        Name = "Option"
    })
    local title = configs[1] or configs.Title or "Discord"
    local desc = configs[2] or configs.Description or "Join our server"
    local logo = configs.Logo or ""
    local invite = configs.Invite or ""
    
    Create("TextLabel", frame, {
        Size = UDim2.new(1,0,0,15),
        Position = UDim2.new(0,5),
        TextColor3 = Color3.fromRGB(40,150,255),
        Font = Enum.Font.GothamBold,
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 10,
        Text = invite
    })
    local cardFrame = Create("Frame", frame, {
        Size = UDim2.new(1,0,0,65),
        AnchorPoint = Vector2.new(0,1),
        Position = UDim2.new(0,0,1),
        BackgroundColor3 = Theme["Color Hub 2"],
    })
    Create("UICorner", cardFrame, { CornerRadius = UDim.new(0,6) })
    
    if logo ~= "" then
        local logoImg = Create("ImageLabel", cardFrame, {
            Size = UDim2.new(0,30,0,30),
            Position = UDim2.new(0,7,0,7),
            Image = logo,
            BackgroundTransparency = 1,
        })
        Create("UICorner", logoImg, { CornerRadius = UDim.new(0,4) })
    end
    
    Create("TextLabel", cardFrame, {
        Size = UDim2.new(1,-52,0,15),
        Position = UDim2.new(0,44,0,7),
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme["Color Text"],
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 10,
        Text = title,
    })
    Create("TextLabel", cardFrame, {
        Size = UDim2.new(1,-52,0,0),
        Position = UDim2.new(0,44,0,22),
        TextWrapped = true,
        AutomaticSize = "Y",
        Font = Enum.Font.Gotham,
        TextColor3 = Theme["Color Dark Text"],
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 8,
        Text = desc,
    })
    
    local joinBtn = Create("TextButton", cardFrame, {
        Size = UDim2.new(1,-14,0,16),
        AnchorPoint = Vector2.new(0.5,1),
        Position = UDim2.new(0.5,0,1,-7),
        Text = "Join",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(220,220,220),
        BackgroundColor3 = Color3.fromRGB(50,150,50),
    })
    Create("UICorner", joinBtn, { CornerRadius = UDim.new(0,5) })
    
    local clickDelay = false
    joinBtn.MouseButton1Click:Connect(function()
        if invite ~= "" then
            pcall(function()
                setclipboard(invite)
            end)
            if not clickDelay then
                clickDelay = true
                joinBtn.Text = "Copied!"
                joinBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
                task.wait(2)
                joinBtn.Text = "Join"
                joinBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
                clickDelay = false
            end
        end
    end)
    return frame
end

-- ==========================================
-- EKSPOR LIBRARY FINAL
-- ==========================================
-- Kembalikan redzlib sebagai hasil akhir (ini untuk dimasukkan ke script)
warn("[CatHUB v3.0] Full library replica loaded: all features ready.")
return redzlib