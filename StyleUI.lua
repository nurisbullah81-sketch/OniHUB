-- StyleUI.lua
local StyleUI = {}
local TweenService = game:GetService("TweenService")

-- Palette Warna Redz Hub (Clean Dark Mode)
StyleUI.Theme = {
    MainBG      = Color3.fromRGB(15, 15, 17),   -- Background utama (sangat gelap)
    SidebarBG   = Color3.fromRGB(20, 20, 23),   -- Background sidebar
    ElementBG   = Color3.fromRGB(28, 28, 32),   -- Background tombol/toggle mati
    ElementHov  = Color3.fromRGB(35, 35, 40),   -- Background saat di-hover
    Accent      = Color3.fromRGB(115, 95, 235), -- Warna nyala (Purple/Blue modern)
    Text        = Color3.fromRGB(240, 240, 245),-- Teks utama
    TextDim     = Color3.fromRGB(140, 140, 150),-- Teks sekunder/mati
    Border      = Color3.fromRGB(35, 35, 42)    -- Garis batas halus
}

StyleUI.Font = {
    Regular = Enum.Font.Gotham,
    Bold    = Enum.Font.GothamBold
}

-- Fungsi internal untuk bikin corner mulus
local function ApplyCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

-- 1. Bikin Frame Utama
function StyleUI.CreateMainFrame(parent, size, position)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = StyleUI.Theme.MainBG
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = parent
    
    ApplyCorner(frame, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = StyleUI.Theme.Border
    stroke.Thickness = 1
    stroke.Parent = frame

    return frame
end

-- 2. Bikin Sidebar
function StyleUI.CreateSidebar(parent, width)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, width, 1, 0)
    sidebar.BackgroundColor3 = StyleUI.Theme.SidebarBG
    sidebar.BorderSizePixel = 0
    sidebar.Parent = parent
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = StyleUI.Theme.Border
    stroke.Thickness = 1
    stroke.Parent = sidebar

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = sidebar

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = sidebar

    return sidebar
end

-- 3. Bikin Tab Button di Sidebar
function StyleUI.CreateTabButton(parent, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = StyleUI.Theme.SidebarBG
    btn.Text = "  " .. text
    btn.TextColor3 = StyleUI.Theme.TextDim
    btn.Font = StyleUI.Font.Regular
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent

    ApplyCorner(btn, 6)

    -- Animasi Visual Murni
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = StyleUI.Theme.ElementHov,
            TextColor3 = StyleUI.Theme.Text
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = StyleUI.Theme.SidebarBG,
            TextColor3 = StyleUI.Theme.TextDim
        }):Play()
    end)

    return btn
end

-- 4. Bikin Section Header (Teks kategori dalam tab)
function StyleUI.CreateSectionHeader(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = StyleUI.Theme.Text
    label.Font = StyleUI.Font.Bold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    return label
end

-- 5. Bikin Toggle (Gaya Redz Hub Modern)
function StyleUI.CreateToggle(parent, text, defaultState, callback)
    local state = defaultState or false

    local container = Instance.new("TextButton")
    container.Size = UDim2.new(1, 0, 0, 38)
    container.BackgroundColor3 = StyleUI.Theme.ElementBG
    container.Text = ""
    container.AutoButtonColor = false
    container.BorderSizePixel = 0
    container.Parent = parent

    ApplyCorner(container, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = StyleUI.Theme.Text
    label.Font = StyleUI.Font.Regular
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local switchBG = Instance.new("Frame")
    switchBG.Size = UDim2.new(0, 40, 0, 20)
    switchBG.Position = UDim2.new(1, -50, 0.5, -10)
    switchBG.BackgroundColor3 = state and StyleUI.Theme.Accent or StyleUI.Theme.Border
    switchBG.BorderSizePixel = 0
    switchBG.Parent = container

    ApplyCorner(switchBG, 10) -- Pil penuh

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Parent = switchBG

    ApplyCorner(indicator, 8)

    -- Animasi Visual Hover & Click
    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundColor3 = StyleUI.Theme.ElementHov}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundColor3 = StyleUI.Theme.ElementBG}):Play()
    end)

    container.MouseButton1Click:Connect(function()
        state = not state
        -- Animasi UI
        TweenService:Create(switchBG, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = state and StyleUI.Theme.Accent or StyleUI.Theme.Border
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        -- Panggil fungsi dari main.lua jika ada
        if callback then
            callback(state)
        end
    end)

    return container
end

return StyleUI