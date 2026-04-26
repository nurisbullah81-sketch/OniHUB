-- UI Module: Redz-Style Minimalist
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local UI = {
    ESP_Enabled = false,
    Tween_Enabled = false,
    Visible = true
}

if CoreGui:FindFirstChild("DIZ_Redz") then CoreGui.DIZ_Redz:Destroy() end

function UI:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DIZ_Redz"
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 280, 0, 180)
    MainFrame.Position = UDim2.new(0.5, -140, 0.4, -90)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "BLOX HUB | PREMIUM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = MainFrame

    local function CreateToggle(name, pos, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 240, 0, 35)
        Btn.Position = pos
        Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Btn.Text = name .. " : OFF"
        Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.Parent = MainFrame
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

        local enabled = false
        Btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            Btn.Text = name .. " : " .. (enabled and "ON" or "OFF")
            Btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(200, 200, 200)
            callback(enabled)
        end)
    end

    CreateToggle("ESP FRUITS", UDim2.new(0, 20, 0, 50), function(val) self.ESP_Enabled = val end)
    CreateToggle("AUTO TWEEN FRUIT", UDim2.new(0, 20, 0, 95), function(val) self.Tween_Enabled = val end)

    local Footer = Instance.new("TextLabel")
    Footer.Size = UDim2.new(1, 0, 0, 30)
    Footer.Position = UDim2.new(0, 0, 1, -30)
    Footer.BackgroundTransparency = 1
    Footer.Text = "[ CTRL + G ] TO TOGGLE UI"
    Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
    Footer.TextSize = 11
    Footer.Font = Enum.Font.SourceSans
    Footer.Parent = MainFrame

    -- Keybind Logic
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            self.Visible = not self.Visible
            MainFrame.Visible = self.Visible
        end
    end)
end

UI:Create()
return UI