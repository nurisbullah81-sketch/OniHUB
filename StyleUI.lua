-- StyleUI.lua
-- Desain Modern & Elegan terinspirasi dari Redz Hub (Darker Theme)

local StyleUI = {}

--// Services
local TweenService = game:GetService("TweenService")

--// Konfigurasi Tema (Berdasarkan parameter Redz Hub)
StyleUI.Theme = {
    MainBG = Color3.fromRGB(25, 25, 25),      -- Latar belakang utama (Darker)
    SecondaryBG = Color3.fromRGB(30, 30, 30), -- Latar belakang sidebar/panel
    Accent = Color3.fromRGB(88, 101, 242),    -- Warna Blurple khas Redz Hub
    Stroke = Color3.fromRGB(40, 40, 40),      -- Warna garis tepi (stroke)
    TextPrimary = Color3.fromRGB(243, 243, 243), -- Teks utama cerah
    TextSecondary = Color3.fromRGB(180, 180, 180), -- Teks sekunder redup
    
    -- Geometri [1, 2]
    CornerRadius = UDim.new(0, 8),            -- Radius sudut standar
    ButtonCorner = UDim.new(0, 6),            -- Radius sudut tombol
    CircleCorner = UDim.new(0, 35),          -- Radius tombol minimalisasi
    
    -- Animasi 
    TweenTime = 0.25,
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out
}

--// Helper: Animasi Transisi
local function PlayTween(instance, properties)
    local info = TweenInfo.new(StyleUI.Theme.TweenTime, StyleUI.Theme.EasingStyle, StyleUI.Theme.EasingDirection)
    TweenService:Create(instance, info, properties):Play()
end

--// Penerapan Gaya pada Main Frame
function StyleUI.ApplyMainStyle(frame)
    frame.BackgroundColor3 = StyleUI.Theme.MainBG
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = StyleUI.Theme.CornerRadius
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = StyleUI.Theme.Stroke
    stroke.Thickness = 1.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

--// Penerapan Gaya pada Sidebar [3]
function StyleUI.ApplySidebarStyle(sidebar)
    sidebar.BackgroundColor3 = StyleUI.Theme.SecondaryBG
    sidebar.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", sidebar)
    corner.CornerRadius = StyleUI.Theme.CornerRadius
end

--// Gaya Tab Button (Sidebar Item)
function StyleUI.ApplyTabButtonStyle(button, active)
    button.BackgroundColor3 = active and StyleUI.Theme.Accent or Color3.fromRGB(35, 35, 35)
    button.TextColor3 = active and StyleUI.Theme.TextPrimary or StyleUI.Theme.TextSecondary
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13
    
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = StyleUI.Theme.ButtonCorner

    -- Hover Interaction [3]
    button.MouseEnter:Connect(function()
        if not active then
            PlayTween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
        end
    end)
    button.MouseLeave:Connect(function()
        if not active then
            PlayTween(button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
        end
    end)
end

--// Gaya Toggle Switch (Kapsul Modern) [1, 4]
function StyleUI.ApplyToggleStyle(toggleFrame, active)
    local track = toggleFrame:FindFirstChild("Track") or toggleFrame
    local dot = track:FindFirstChild("Dot")
    
    if active then
        PlayTween(track, {BackgroundColor3 = StyleUI.Theme.Accent})
        if dot then PlayTween(dot, {Position = UDim2.new(1, -18, 0.5, 0)}) end
    else
        PlayTween(track, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
        if dot then PlayTween(dot, {Position = UDim2.new(0, 2, 0.5, 0)}) end
    end
end

--// Gaya Section Header 
function StyleUI.ApplySectionStyle(label)
    label.TextColor3 = StyleUI.Theme.TextSecondary
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
end

--// Gaya Tombol Interaktif (Standard Button)
function StyleUI.ApplyButtonStyle(button)
    button.BackgroundColor3 = StyleUI.Theme.SecondaryBG
    button.TextColor3 = StyleUI.Theme.TextPrimary
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = StyleUI.Theme.ButtonCorner
    
    local stroke = Instance.new("UIStroke", button)
    stroke.Color = StyleUI.Theme.Stroke
    stroke.Thickness = 1
end

return StyleUI