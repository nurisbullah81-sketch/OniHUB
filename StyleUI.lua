-- StyleUI.lua
local StyleUI = {}

-- Tema Utama (Mengikuti referensi Redz Hub)
StyleUI.Theme = {
    -- Backgrounds
    MainBG = Color3.fromRGB(15, 15, 18),       -- Latar belakang utama (paling gelap)
    SidebarBG = Color3.fromRGB(22, 22, 26),    -- Latar belakang navigasi samping
    TopbarBG = Color3.fromRGB(22, 22, 26),     -- Latar belakang bagian atas
    
    -- Element Backgrounds
    ElementBG = Color3.fromRGB(32, 32, 38),    -- Background untuk Toggle/Button
    ElementHover = Color3.fromRGB(42, 42, 48), -- Background saat kursor di atas elemen
    ElementActive = Color3.fromRGB(45, 45, 55),-- Background saat tab menu ditekan
    
    -- Accents (Warna nyala Redz Hub)
    Accent = Color3.fromRGB(100, 100, 220),    -- Ungu/Biru (Indigo) untuk toggle ON
    ToggleOff = Color3.fromRGB(50, 50, 58),    -- Abu-abu untuk toggle OFF
    
    -- Texts
    TextPrimary = Color3.fromRGB(235, 235, 240),   -- Teks utama yang sedang menyala/dipilih
    TextSecondary = Color3.fromRGB(150, 150, 160), -- Teks pasif atau judul kategori
    TextDark = Color3.fromRGB(90, 90, 100),        -- Teks placeholder atau ikon pasif
    
    -- Geometri
    CornerRadius = UDim.new(0, 6),             -- Radius standar untuk kotak
    PillRadius = UDim.new(1, 0),               -- Radius bulat penuh untuk toggle
    
    -- Tipografi
    FontNormal = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    TextSizeLarge = 14,
    TextSizeNormal = 13,
    TextSizeSmall = 12
}

-- Fungsi untuk Menerapkan Gaya pada Main Frame
function StyleUI.ApplyMainFrameStyle(frame)
    frame.BackgroundColor3 = StyleUI.Theme.MainBG
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = StyleUI.Theme.CornerRadius
    corner.Parent = frame
end

-- Fungsi untuk Menerapkan Gaya pada Sidebar/Topbar Frame
function StyleUI.ApplyBarFrameStyle(frame)
    frame.BackgroundColor3 = StyleUI.Theme.SidebarBG
    frame.BorderSizePixel = 0
end

-- Fungsi untuk Menerapkan Gaya pada Section Label (Teks Kategori)
function StyleUI.ApplySectionLabelStyle(label)
    label.BackgroundTransparency = 1
    label.TextColor3 = StyleUI.Theme.TextSecondary
    label.Font = StyleUI.Theme.FontBold
    label.TextSize = StyleUI.Theme.TextSizeSmall
    label.TextXAlignment = Enum.TextXAlignment.Left
end

-- Fungsi untuk Menerapkan Gaya pada Tab Button (Di Sidebar)
function StyleUI.ApplyTabButtonStyle(button, isActive)
    button.BackgroundColor3 = isActive and StyleUI.Theme.ElementActive or StyleUI.Theme.SidebarBG
    button.TextColor3 = isActive and StyleUI.Theme.TextPrimary or StyleUI.Theme.TextSecondary
    button.Font = StyleUI.Theme.FontNormal
    button.TextSize = StyleUI.Theme.TextSizeNormal
    button.BorderSizePixel = 0
    
    local corner = button:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    corner.CornerRadius = StyleUI.Theme.CornerRadius
    corner.Parent = button
end

-- Fungsi untuk Menerapkan Gaya pada Base Toggle (Container Toggle)
function StyleUI.ApplyToggleContainerStyle(button)
    button.BackgroundColor3 = StyleUI.Theme.ElementBG
    button.BorderSizePixel = 0
    
    local corner = button:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    corner.CornerRadius = StyleUI.Theme.CornerRadius
    corner.Parent = button
end

-- Fungsi untuk Menerapkan Gaya pada Teks dalam Toggle
function StyleUI.ApplyToggleTextStyle(label)
    label.BackgroundTransparency = 1
    label.TextColor3 = StyleUI.Theme.TextPrimary
    label.Font = StyleUI.Theme.FontNormal
    label.TextSize = StyleUI.Theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left
end

-- Fungsi untuk Menerapkan Gaya pada Switch (Indikator Pil)
function StyleUI.ApplySwitchIndicatorStyle(switchFrame, isStateOn)
    switchFrame.BackgroundColor3 = isStateOn and StyleUI.Theme.Accent or StyleUI.Theme.ToggleOff
    switchFrame.BorderSizePixel = 0
    
    local corner = switchFrame:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    corner.CornerRadius = StyleUI.Theme.PillRadius
    corner.Parent = switchFrame
end

-- Fungsi untuk Menerapkan Gaya pada Dot (Titik di dalam Switch)
function StyleUI.ApplySwitchDotStyle(dotFrame)
    dotFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dotFrame.BorderSizePixel = 0
    
    local corner = dotFrame:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    corner.CornerRadius = StyleUI.Theme.PillRadius
    corner.Parent = dotFrame
end

return StyleUI