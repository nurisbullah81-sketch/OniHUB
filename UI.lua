-- UI Module for Blox Hub
-- Theme: Dark Minimalist, White Accent
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("DIZ_UI") then CoreGui.DIZ_UI:Destroy() end

local UI = {}

function UI:Init()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DIZ_UI"
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 200, 0, 60)
    MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "BLOX HUB | ESP ACTIVE"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.Parent = MainFrame
    
    return ScreenGui
end

return UI:Init()