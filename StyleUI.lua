--]

local StyleUI = {}

--// Services
local TweenService = game:GetService("TweenService")

--// Theme Configuration (Derived from Redz Hub Research )
StyleUI.Theme = {
    -- Background Colors
    MainBG = Color3.fromRGB(25, 25, 25),      -- Darker Theme Background
    SecondaryBG = Color3.fromRGB(30, 30, 30), -- Panel/Section Background
    TopBarBG = Color3.fromRGB(32, 32, 32),    -- Subtle Top Gradient
    
    -- Accent & Interactive
    Accent = Color3.fromRGB(88, 101, 242),    -- Classic Blurple Accent
    AccentSoft = Color3.fromRGB(65, 150, 255),-- Secondary Blue Accent
    Stroke = Color3.fromRGB(40, 40, 40),      -- Standard Border Color
    StrokeHighlight = Color3.fromRGB(88, 101, 242), -- Active Border
    
    -- Text Colors
    TextPrimary = Color3.fromRGB(243, 243, 243),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    TextDim = Color3.fromRGB(120, 120, 120),
    
    -- Geometry & Physics
    CornerRadius = UDim.new(0, 8),            -- Consistent Modern Curve
    ButtonCorner = UDim.new(0, 6),            -- Tighter Curvature for Buttons
    TransitionSpeed = 0.25,                   -- Smooth Response Time
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out
}

--// Animation Helper
local function PlayTween(instance, properties)
    local tweenInfo = TweenInfo.new(
        StyleUI.Theme.TransitionSpeed, 
        StyleUI.Theme.EasingStyle, 
        StyleUI.Theme.EasingDirection
    )
    TweenService:Create(instance, tweenInfo, properties):Play()
end

--// Styling Functions
function StyleUI.StyleMainFrame(frame)
    frame.BackgroundColor3 = StyleUI.Theme.MainBG
    frame.BorderSizePixel = 0
    
    -- Apply UICorner 
    local corner = Instance.new("UICorner")
    corner.CornerRadius = StyleUI.Theme.CornerRadius
    corner.Parent = frame
    
    -- Apply UIStroke for Depth 
    local stroke = Instance.new("UIStroke")
    stroke.Color = StyleUI.Theme.Stroke
    stroke.Thickness = 1.2
    stroke.Transparency = 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame

    -- Subtle Gradient for Elegance 
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, StyleUI.Theme.TopBarBG),
        ColorSequenceKeypoint.new(1, StyleUI.Theme.MainBG)
    })
    gradient.Rotation = 90
    gradient.Parent = frame
end

function StyleUI.StyleSidebar(sidebar)
    sidebar.BackgroundColor3 = StyleUI.Theme.SecondaryBG
    sidebar.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = StyleUI.Theme.CornerRadius
    corner.Parent = sidebar
end

function StyleUI.StyleTabButton(button, isSelected)
    button.BackgroundColor3 = isSelected and StyleUI.Theme.Accent or Color3.fromRGB(35, 35, 35)
    button.TextColor3 = isSelected and StyleUI.Theme.TextPrimary or StyleUI.Theme.TextSecondary
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = StyleUI.Theme.ButtonCorner
    corner.Parent = button

    -- Interaction 
    button.MouseEnter:Connect(function()
        if not isSelected then
            PlayTween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
        end
    end)
    button.MouseLeave:Connect(function()
        if not isSelected then
            PlayTween(button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
        end
    end)
end

function StyleUI.StyleToggle(toggleContainer, state)
    local track = toggleContainer:FindFirstChild("Track") or toggleContainer
    local dot = track:FindFirstChild("Dot")
    
    if state then
        PlayTween(track, {BackgroundColor3 = StyleUI.Theme.Accent})
        if dot then PlayTween(dot, {Position = UDim2.new(1, -18, 0.5, 0)}) end
    else
        PlayTween(track, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
        if dot then PlayTween(dot, {Position = UDim2.new(0, 2, 0.5, 0)}) end
    end
end

function StyleUI.StyleButton(button)
    button.BackgroundColor3 = StyleUI.Theme.SecondaryBG
    button.TextColor3 = StyleUI.Theme.TextPrimary
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = StyleUI.Theme.ButtonCorner
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = StyleUI.Theme.Stroke
    stroke.Thickness = 1
    stroke.Parent = button

    button.MouseEnter:Connect(function()
        PlayTween(button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        PlayTween(stroke, {Color = StyleUI.Theme.Accent})
    end)
    button.MouseLeave:Connect(function()
        PlayTween(button, {BackgroundColor3 = StyleUI.Theme.SecondaryBG})
        PlayTween(stroke, {Color = StyleUI.Theme.Stroke})
    end)
end

function StyleUI.StyleSlider(sliderFrame, percentage)
    local bar = sliderFrame:FindFirstChild("Bar")
    local fill = bar and bar:FindFirstChild("Fill")
    
    if fill then
        PlayTween(fill, {Size = UDim2.new(percentage, 0, 1, 0)})
    end
end

return StyleUI