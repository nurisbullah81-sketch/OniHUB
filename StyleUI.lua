-- [[ ==========================================
--      CATHUB PREMIUM: REDZ HUB STYLE
--      100% PURE INSTANCE.NEW (ZERO LIBRARIES)
--    ========================================== ]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Pasang Rem: Tunggu karakter masuk server
repeat task.wait() until Players.LocalPlayer

-- Anti Numpuk (Hapus UI lama kalau di-execute ulang)
if CoreGui:FindFirstChild("CatHub_Redz") then
    CoreGui.CatHub_Redz:Destroy()
end

-- 1. BIKIN KANVAS UTAMA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatHub_Redz"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. BIKIN WINDOW UTAMA (RAMPING & COMPACT ALA REDZ)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 380, 0, 400) -- Ukuran ramping kaga nutupin map
MainWindow.Position = UDim2.new(0.5, -190, 0.5, -200)
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Hitam pekat elegan
MainWindow.BorderSizePixel = 0
MainWindow.Active = true
MainWindow.Draggable = true -- Langsung bisa digeser bebas
MainWindow.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainWindow

-- Aksen Garis Merah di sekeliling UI
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 40, 40) 
MainStroke.Thickness = 1.5
MainStroke.Parent = MainWindow

-- 3. BIKIN TOP BAR (TEMPAT JUDUL)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainWindow

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

-- Nambal sudut bawah TopBar biar nyatu sama bodi
local TopPatch = Instance.new("Frame")
TopPatch.Size = UDim2.new(1, 0, 0, 10)
TopPatch.Position = UDim2.new(0, 0, 1, -10)
TopPatch.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopPatch.BorderSizePixel = 0
TopPatch.Parent = TopBar

local GarisBatas = Instance.new("Frame")
GarisBatas.Size = UDim2.new(1, 0, 0, 1)
GarisBatas.Position = UDim2.new(0, 0, 1, 0)
GarisBatas.BackgroundColor3 = Color3.fromRGB(255, 40, 40) -- Garis merah pembatas
GarisBatas.BorderSizePixel = 0
GarisBatas.Parent = TopBar

-- 4. JUDUL UI (ENGLISH)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CATHUB PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold -- Font tebal modern
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- 5. BIKIN TEMPAT MENU SCROLL DI BAWAHNYA
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -20, 1, -60)
ContentScroll.Position = UDim2.new(0, 10, 0, 55)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 3
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 40, 40)
ContentScroll.Parent = MainWindow

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Padding = UDim.new(0, 10) -- Jarak antar tombol
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Parent = ContentScroll

-- ==========================================
--    FUNGSI PEMBUAT KOMPONEN (MILIK LU 100%)
-- ==========================================
local OniUI = {}

-- Fungsi bikin Label Text
function OniUI.CreateLabel(textValue)
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Size = UDim2.new(1, 0, 0, 25)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Parent = ContentScroll

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = textValue
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = LabelFrame
    return Label
end

-- Fungsi bikin Toggle Button (Tombol On/Off)
function OniUI.CreateToggle(name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ContentScroll

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame

    local ToggleText = Instance.new("TextLabel")
    ToggleText.Size = UDim2.new(1, -60, 1, 0)
    ToggleText.Position = UDim2.new(0, 12, 0, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = name
    ToggleText.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleText.Font = Enum.Font.GothamMedium
    ToggleText.TextSize = 13
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Parent = ToggleFrame

    local BtnOuter = Instance.new("TextButton")
    BtnOuter.Size = UDim2.new(0, 24, 0, 24)
    BtnOuter.Position = UDim2.new(1, -36, 0.5, -12)
    BtnOuter.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    BtnOuter.Text = ""
    BtnOuter.Parent = ToggleFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = BtnOuter

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(60, 60, 60)
    BtnStroke.Parent = BtnOuter

    local BtnInner = Instance.new("Frame")
    BtnInner.Size = UDim2.new(1, -6, 1, -6)
    BtnInner.Position = UDim2.new(0, 3, 0, 3)
    BtnInner.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
    BtnInner.BackgroundTransparency = 1 -- Default OFF (Transparan)
    BtnInner.Parent = BtnOuter

    local InnerCorner = Instance.new("UICorner")
    InnerCorner.CornerRadius = UDim.new(0, 2)
    InnerCorner.Parent = BtnInner

    local isToggled = false
    BtnOuter.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            BtnInner.BackgroundTransparency = 0 -- Nyala Merah
            BtnStroke.Color = Color3.fromRGB(255, 40, 40)
        else
            BtnInner.BackgroundTransparency = 1 -- Mati
            BtnStroke.Color = Color3.fromRGB(60, 60, 60)
        end
        callback(isToggled)
    end)
end

-- ==========================================
--    IMPLEMENTASI MENU LU
-- ==========================================

OniUI.CreateLabel("Player Information")

local LblLevel = OniUI.CreateLabel("Level: Waiting Data...")
local LblBeli  = OniUI.CreateLabel("Beli: Waiting Data...")

OniUI.CreateLabel("Main Farm Configuration")

OniUI.CreateToggle("Enable Auto Farm", function(state)
    print("Auto Farm is now: ", state)
    -- Masukin logic Auto Farm lu di sini
end)

OniUI.CreateToggle("Auto Store Fruit", function(state)
    print("Auto Store is now: ", state)
end)

-- Biar gampang dipanggil di file lain
_G.OniUI = OniUI