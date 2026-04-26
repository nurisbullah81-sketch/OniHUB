-- CatHUB v10.0: Anti-Crash & Full RedzHub Clone
-- Perbaikan total buat error StyleUI.lua

local function SafeExecute()
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local UserInput = game:GetService("UserInputService")

    -- Hapus UI lama biar gak bentrok
    if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

    -- Bikin ScreenGui dengan proteksi Parent
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "CatUI"
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Coba taruh di CoreGui, kalau gagal taruh di PlayerGui
    local success, err = pcall(function()
        Gui.Parent = CoreGui
    end)
    if not success then
        Gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    local S = {FruitESP = false, ChestESP = false}
    local C = {
        Base = Color3.fromRGB(15, 15, 17),
        Side = Color3.fromRGB(20, 20, 22),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(255, 255, 255),
        Stroke = Color3.fromRGB(45, 45, 50)
    }

    -- Tombol Buka (Logo Redz)
    local OpenBtn = Instance.new("ImageButton", Gui)
    OpenBtn.Size = UDim2.new(0, 45, 0, 45)
    OpenBtn.Position = UDim2.new(0, 10, 0, 10)
    OpenBtn.Visible = false
    OpenBtn.BackgroundColor3 = C.Base
    OpenBtn.Image = "rbxassetid://6023426915"
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
    local OBStroke = Instance.new("UIStroke", OpenBtn)
    OBStroke.Color = C.Accent
    OBStroke.Thickness = 2

    -- Frame Utama
    local Main = Instance.new("Frame", Gui)
    Main.Size = UDim2.new(0, 560, 0, 360)
    Main.Position = UDim2.new(0.5, -280, 0.5, -180)
    Main.BackgroundColor3 = C.Base
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local MStroke = Instance.new("UIStroke", Main)
    MStroke.Color = C.Stroke

    -- Top Bar
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 35)
    Top.BackgroundColor3 = C.Side
    Top.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel", Top)
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "redz Hub : Visuals [ CatHub ]"
    Title.TextColor3 = C.Text
    Title.Font = Enum.Font.Gotham
    Title.TextSize = 12
    Title.TextXAlignment = "Left"
    Title.BackgroundTransparency = 1

    local Close = Instance.new("TextButton", Top)
    Close.Size = UDim2.new(0, 35, 1, 0)
    Close.Position = UDim2.new(1, -35, 0, 0)
    Close.Text = "✕"
    Close.TextColor3 = C.Text
    Close.Font = Enum.Font.GothamBold
    Close.BackgroundTransparency = 1

    -- Sidebar (Cuma 1 Tab)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = C.Side

    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(1, -20, 0, 35)
    Tab.Position = UDim2.new(0, 10, 0, 10)
    Tab.BackgroundColor3 = C.Accent
    Tab.Text = "      ESP"
    Tab.TextColor3 = C.Text
    Tab.Font = Enum.Font.GothamMedium
    Tab.TextSize = 13
    Tab.TextXAlignment = "Left"
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 6)

    -- Container
    local Container = Instance.new("ScrollingFrame", Main)
    Container.Size = UDim2.new(1, -160, 1, -45)
    Container.Position = UDim2.new(0, 150, 0, 40)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local List = Instance.new("UIListLayout", Container)
    List.Padding = UDim.new(0, 10)

    -- Toggle Logic
    local function Toggle(key, txt)
        local f = Instance.new("TextButton", Container)
        f.Size = UDim2.new(1, 0, 0, 40)
        f.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        f.Text = ""
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -60, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(200, 200, 200)
        l.Font = Enum.Font.Gotham
        l.TextSize = 13
        l.TextXAlignment = "Left"
        l.BackgroundTransparency = 1
        
        local sw = Instance.new("Frame", f)
        sw.Size = UDim2.new(0, 34, 0, 18)
        sw.Position = UDim2.new(1, -46, 0.5, -9)
        sw.BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(60, 60, 65)
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
        
        f.MouseButton1Click:Connect(function()
            S[key] = not S[key]
            TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = S[key] and C.Accent or Color3.fromRGB(60, 60, 65)}):Play()
        end)
    end

    Toggle("FruitESP", "Enable Fruit ESP")
    Toggle("ChestESP", "Auto Chest Finder")

    -- Hide & Open Logic
    Close.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenBtn.Visible = true
    end)
    OpenBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        OpenBtn.Visible = false
    end)

    -- Simple Drag
    local drag, dStart, sPos
    Top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dStart = i.Position; sPos = Main.Position end end)
    UserInput.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dStart
            Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
        end
    end)
    Top.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
end

-- Jalankan dengan proteksi terakhir
pcall(SafeExecute)