-- ==========================================
-- CATHUB PREMIUM: FULL RESTORE + LEWISAKURA PROXY
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")

if CoreGui:FindFirstChild("CatUI") then CoreGui.CatUI:Destroy() end

-- ==========================================
-- 1. CONFIG & SYSTEM
-- ==========================================
local ConfigFile = "CatHUB_Config.json"
local DefaultSettings = {
    FruitESP = false, TweenFruit = false, InstantTPFruit = false,
    AutoStoreFruit = false, AutoHop = false, AntiAFK = true, AutoAttack = false,
    FruitWebhook = false, FruitWebhookURL = "", FruitWebhookRarity = "Mythical Only",
}

local function LoadSettings()
    local settings = {}
    for k, v in pairs(DefaultSettings) do settings[k] = v end
    pcall(function()
        if isfile(ConfigFile) then
            local saved = HttpService:JSONDecode(readfile(ConfigFile))
            for key, value in pairs(saved) do if settings[key] ~= nil then settings[key] = value end end
        end
    end)
    return settings
end

local function SaveSettings()
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(_G.Cat.Settings)) end)
end

if not _G.Cat then 
    _G.Cat = { Player = game:GetService("Players").LocalPlayer, Settings = LoadSettings(), Labels = {} }
else 
    _G.Cat.Player = game:GetService("Players").LocalPlayer
    if not _G.Cat.Labels then _G.Cat.Labels = {} end
    _G.Cat.Settings = LoadSettings() 
end

-- ==========================================
-- 2. WEBHOOK ENGINE (PROXY LEWISAKURA + ANTI-FREEZE RARITY)
-- ==========================================
local Webhook = {}

-- Fungsi ini kaga bakal ngubah nama asli dari game. 
-- Cuma buat nentuin kasta buahnya biar lolos filter UI lu.
local function GetDynamicRarity(rawFruitName)
    local cleanName = string.lower(rawFruitName)
    
    local mythical = {"kitsune", "tiger", "leopard", "dragon", "venom", "dough", "t-rex", "trex", "mammoth", "spirit", "control", "gravity"}
    local legendary = {"blizzard", "portal", "lightning", "rumble", "pain", "buddha", "quake", "sound", "spider", "string", "love", "phoenix"}
    
    for _, kw in pairs(mythical) do
        if string.find(cleanName, kw) then return "Mythical" end
    end
    for _, kw in pairs(legendary) do
        if string.find(cleanName, kw) then return "Legendary" end
    end
    
    return "Common" -- Kalau kaga masuk list dewa di atas
end

function Webhook:Test(webhookURL)
    if not webhookURL or webhookURL == "" then return false, "No URL" end
    
    webhookURL = string.gsub(webhookURL, "^%s*(.-)%s*$", "%1")
    webhookURL = string.gsub(webhookURL, "discord%.com", "webhook.lewisakura.moe")

    local payload = HttpService:JSONEncode({
        content = "✅ **CatHUB Webhook Aktif!**",
        embeds = {{
            title = "Koneksi Berhasil (Lewisakura Proxy)",
            description = "Script lu udah terhubung 100% ke channel Discord ini bang.",
            color = 32768,
            footer = { text = "CatHUB Diagnostic" }
        }}
    })
    
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not req then return false, "No HTTP Req" end
    
    local ok, res = pcall(function() return req({ Url = webhookURL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload }) end)
    
    if ok and res and (res.StatusCode == 200 or res.StatusCode == 204) then return true, "Success" end
    return false, "Pcall Error"
end

function Webhook:Send(fruitName, jobId, raritySetting, webhookURL)
    warn("[CatHUB] Menganalisa buah: " .. tostring(fruitName))
    if not webhookURL or webhookURL == "" then return end
    
    webhookURL = string.gsub(webhookURL, "^%s*(.-)%s*$", "%1")
    webhookURL = string.gsub(webhookURL, "discord%.com", "webhook.lewisakura.moe")
    
    -- Ambil rarity pakai sistem detektor, kaga nge-require game lagi!
    local fruitRarity = GetDynamicRarity(fruitName)
    warn("[CatHUB] Rarity buah ini adalah: " .. fruitRarity)
    
    local shouldSend = false
    if raritySetting == "All Fruits" then
        shouldSend = true
    elseif raritySetting == "Legendary & Mythical" then
        if string.find(fruitRarity, "Legendary") or string.find(fruitRarity, "Mythical") then shouldSend = true end
    elseif raritySetting == "Mythical Only" then
        if string.find(fruitRarity, "Mythical") then shouldSend = true end
    end
    
    if not shouldSend then 
        warn("[CatHUB] BATAL KIRIM! Buah kerendahan buat filter UI lu.")
        return 
    end
    
    local embedColor = 16777215
    if string.find(fruitRarity, "Legendary") then embedColor = 16753920
    elseif string.find(fruitRarity, "Mythical") then embedColor = 16711935 end
    
    local payload = HttpService:JSONEncode({
        content = "🚨 **FRUIT SPAWN DETECTED** 🚨",
        embeds = {{
            title = fruitRarity .. " Fruit: " .. fruitName,
            description = "**JobID:** `" .. jobId .. "`\n\nUse this JobID to teleport to the server!",
            color = embedColor,
            footer = { text = "CatHUB Premium Scanner" }
        }}
    })
    
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if req then
        task.spawn(function()
            pcall(function() req({Url = webhookURL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload}) end)
            warn("[CatHUB] Sukses ditembak ke Discord!")
        end)
    end
end

_G.Cat.Webhook = Webhook

-- ==========================================
-- 3. UI RENDERING (MURNI DARI BACKUP LU)
-- ==========================================
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "CatUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Theme = {
    MainBG = Color3.fromRGB(10, 10, 10), SideBG = Color3.fromRGB(14, 14, 16), TopBG = Color3.fromRGB(10, 10, 10),
    TabOn = Color3.fromRGB(38, 38, 42), TabOff = Color3.fromRGB(25, 25, 30), PageBG = Color3.fromRGB(17, 18, 22),
    CardBG = Color3.fromRGB(28, 28, 32), CardHov = Color3.fromRGB(36, 36, 42), Text = Color3.fromRGB(250, 250, 250),
    TextDim = Color3.fromRGB(140, 140, 145), ToggleOn = Color3.fromRGB(138, 43, 226), ToggleOff = Color3.fromRGB(75, 75, 80),
    CatPurple = Color3.fromRGB(160, 100, 255), Gold = Color3.fromRGB(255, 200, 50), Accent = Color3.fromRGB(138, 43, 226),
    Line = Color3.fromRGB(40, 40, 45)
}

-- Floating Button
local FloatCont = Instance.new("Frame", Gui)
FloatCont.Size = UDim2.new(0, 70, 0, 40) 
FloatCont.Position = UDim2.new(0, 20, 0.5, -20)
FloatCont.BackgroundTransparency = 1
FloatCont.ZIndex = 99999 

local FloatBtn = Instance.new("TextButton", FloatCont)
FloatBtn.Size = UDim2.new(0, 40, 1, 0)
FloatBtn.Position = UDim2.new(0, 30, 0, 0) 
FloatBtn.BackgroundColor3 = Theme.CardBG
FloatBtn.Text = "Cat"
FloatBtn.TextColor3 = Theme.CatPurple 
FloatBtn.Font = Enum.Font.GothamBold 
FloatBtn.TextSize = 16
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", FloatBtn).Color = Theme.Line

local FloatDrag = Instance.new("TextButton", FloatCont)
FloatDrag.Size = UDim2.new(0, 30, 1, 0)
FloatDrag.Position = UDim2.new(0, 0, 0, 0)
FloatDrag.BackgroundTransparency = 1 
FloatDrag.Text = ""

local draggingFloat, dragStartFloat, startPosFloat
FloatDrag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFloat = true; dragStartFloat = input.Position; startPosFloat = FloatCont.Position
    end
end)
FloatDrag.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingFloat = false end end)
UserInput.InputChanged:Connect(function(input)
    if draggingFloat and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartFloat
        FloatCont.Position = UDim2.new(startPosFloat.X.Scale, startPosFloat.X.Offset + delta.X, startPosFloat.Y.Scale, startPosFloat.Y.Offset + delta.Y)
    end
end)

-- Main Frame
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 550, 0, 340)
Main.Position = UDim2.new(0.5, -275, 0.5, -170)
Main.BackgroundColor3 = Theme.MainBG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", Main).Color = Theme.Line

FloatBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = Theme.TopBG
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 6)

local TopFix = Instance.new("Frame", Top)
TopFix.Size = UDim2.new(1, 0, 0, 10)
TopFix.Position = UDim2.new(0, 0, 1, -10)
TopFix.BackgroundColor3 = Theme.TopBG
TopFix.BorderSizePixel = 0

local TitleContainer = Instance.new("Frame", Top)
TitleContainer.Size = UDim2.new(0, 350, 1, 0)
TitleContainer.Position = UDim2.new(0, 15, 0, 0)
TitleContainer.BackgroundTransparency = 1

local TitleList = Instance.new("UIListLayout", TitleContainer)
TitleList.FillDirection = Enum.FillDirection.Horizontal
TitleList.VerticalAlignment = Enum.VerticalAlignment.Center
TitleList.Padding = UDim.new(0, 4) 

local function CreateTitlePart(text, color, font)
    local label = Instance.new("TextLabel", TitleContainer)
    label.Text = text; label.TextColor3 = color; label.Font = font; label.TextSize = 13; 
    label.BackgroundTransparency = 1; label.AutomaticSize = Enum.AutomaticSize.XY
end

CreateTitlePart("CatHUB", Theme.CatPurple, Enum.Font.GothamBold) 
CreateTitlePart("Blox Fruits", Theme.Text, Enum.Font.GothamMedium)
CreateTitlePart("[Freemium]", Theme.Gold, Enum.Font.GothamMedium) 

local BtnX = Instance.new("TextButton", Top)
BtnX.Size = UDim2.new(0, 35, 0, 35); BtnX.Position = UDim2.new(1, -35, 0, 0); BtnX.Text = "X"; 
BtnX.TextColor3 = Theme.TextDim; BtnX.BackgroundTransparency = 1; BtnX.Font = Enum.Font.Gotham; BtnX.TextSize = 15; BtnX.AutoButtonColor = false

local BtnM = Instance.new("TextButton", Top)
BtnM.Size = UDim2.new(0, 35, 0, 35); BtnM.Position = UDim2.new(1, -70, 0, 0); BtnM.Text = "—"; 
BtnM.TextColor3 = Theme.TextDim; BtnM.BackgroundTransparency = 1; BtnM.Font = Enum.Font.GothamBold; BtnM.TextSize = 13; BtnM.AutoButtonColor = false

BtnX.MouseButton1Click:Connect(function() Main.Visible = false end)

local isMin = false
local lastSize = Main.Size
BtnM.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then lastSize = Main.Size; TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, Main.Size.X.Offset, 0, 35)}):Play()
    else TweenService:Create(Main, TweenInfo.new(0.3), {Size = lastSize}):Play() end
end)

local draggingMain, dragStartMain, startPosMain
Top.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingMain = true; dragStartMain = input.Position; startPosMain = Main.Position end end)
Top.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingMain = false end end)
UserInput.InputChanged:Connect(function(input)
    if draggingMain and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStartMain; Main.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y) end
end)

-- ==========================================
-- TOMBOL TARIK UI (RESIZER) - UDAH DI-FIX
-- ==========================================
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 35, 0, 35) -- Hitbox digedein biar gampang diklik jari/mouse
Resizer.Position = UDim2.new(1, -35, 1, -35) -- POJOK KANAN BAWAH
Resizer.BackgroundTransparency = 1
Resizer.Text = "⌟"
Resizer.TextColor3 = Theme.CatPurple -- Warnanya ungu biar lu gampang nyarinya
Resizer.TextSize = 25
Resizer.Font = Enum.Font.Gotham
Resizer.ZIndex = 99999 -- Anti ketiban elemen lain
Resizer.AutoButtonColor = false

local isResizing, resizeStartPos, startSizeR
Resizer.InputBegan:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not isMin then 
        isResizing = true
        resizeStartPos = UserInput:GetMouseLocation()
        startSizeR = Main.Size 
    end 
end)

UserInput.InputEnded:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        isResizing = false 
    end 
end)

UserInput.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then 
        local delta = UserInput:GetMouseLocation() - resizeStartPos
        -- Batas minimal gue kecilin jadi 350x220 biar lu bisa ciutin UI nya sempit banget
        Main.Size = UDim2.new(0, math.clamp(startSizeR.X.Offset + delta.X, 350, 900), 0, math.clamp(startSizeR.Y.Offset + delta.Y, 220, 700))
        lastSize = Main.Size 
    end
end)

local ContentContainer = Instance.new("Frame", Main)
ContentContainer.Size = UDim2.new(1, 0, 1, -35); ContentContainer.Position = UDim2.new(0, 0, 0, 35); ContentContainer.BackgroundTransparency = 1

local Side = Instance.new("Frame", ContentContainer)
Side.Size = UDim2.new(0.28, 0, 1, 0); Side.BackgroundColor3 = Theme.SideBG; Side.BorderSizePixel = 0
local SideLine = Instance.new("Frame", Side)
SideLine.Size = UDim2.new(0, 1, 1, 0); SideLine.Position = UDim2.new(1, -1, 0, 0); SideLine.BackgroundColor3 = Theme.Line; SideLine.BorderSizePixel = 0

local SearchFrame = Instance.new("Frame", Side)
SearchFrame.Size = UDim2.new(1, -16, 0, 30); SearchFrame.Position = UDim2.new(0, 8, 0, 10); SearchFrame.BackgroundColor3 = Theme.CardBG; SearchFrame.BorderSizePixel = 0
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", SearchFrame).Color = Theme.Line

local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Size = UDim2.new(1, -16, 1, 0); SearchBox.Position = UDim2.new(0, 8, 0, 0); SearchBox.BackgroundTransparency = 1; 
SearchBox.Text = ""; SearchBox.PlaceholderText = "Search..."; SearchBox.TextColor3 = Theme.Text; SearchBox.PlaceholderColor3 = Theme.TextDim; 
SearchBox.Font = Enum.Font.GothamMedium; SearchBox.TextSize = 12; SearchBox.TextXAlignment = Enum.TextXAlignment.Left

local SideScroll = Instance.new("ScrollingFrame", Side)
SideScroll.Size = UDim2.new(1, 0, 1, -50); SideScroll.Position = UDim2.new(0, 0, 0, 50); SideScroll.BackgroundTransparency = 1; SideScroll.ScrollBarThickness = 0; SideScroll.BorderSizePixel = 0
local SideList = Instance.new("UIListLayout", SideScroll); SideList.Padding = UDim.new(0, 4)
local SidePad = Instance.new("UIPadding", SideScroll); SidePad.PaddingLeft = UDim.new(0, 8); SidePad.PaddingRight = UDim.new(0, 8)

local ContentArea = Instance.new("Frame", ContentContainer)
ContentArea.Size = UDim2.new(0.72, 0, 1, 0); ContentArea.Position = UDim2.new(0.28, 0, 0, 0); ContentArea.BackgroundTransparency = 1

local Pages = {}
local AllToggles = {}

local function CreateTab(name, isFirst)
    local Btn = Instance.new("TextButton", SideScroll)
    Btn.Size = UDim2.new(1, 0, 0, 32); Btn.BackgroundColor3 = isFirst and Theme.TabOn or Theme.TabOff; Btn.Text = "    " .. name; 
    Btn.TextColor3 = isFirst and Theme.Text or Theme.TextDim; Btn.Font = Enum.Font.GothamMedium; Btn.TextSize = 12; Btn.BorderSizePixel = 0; 
    Btn.TextXAlignment = Enum.TextXAlignment.Left; Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Color = Color3.fromRGB(65, 65, 70); BtnStroke.Thickness = 1; BtnStroke.Transparency = isFirst and 0 or 0.3 
    
    local Indicator = Instance.new("Frame", Btn)
    Indicator.Size = UDim2.new(0, 3, 0, 14); Indicator.Position = UDim2.new(0, 4, 0.5, -7); Indicator.BackgroundColor3 = Theme.Accent; Indicator.BorderSizePixel = 0
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0); Indicator.Visible = isFirst
    
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, -16, 1, -16); Page.Position = UDim2.new(0, 8, 0, 8); Page.BackgroundColor3 = Theme.PageBG; Page.BackgroundTransparency = 0; 
    Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.TextDim; Page.Visible = isFirst; Page.BorderSizePixel = 0
    Instance.new("UICorner", Page).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Page).Color = Theme.Line
    
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 6)
    List.SortOrder = Enum.SortOrder.LayoutOrder -- [ANTI BERANTAKAN]
    
    local Pad = Instance.new("UIPadding", Page)
    Pad.PaddingTop = UDim.new(0, 10); Pad.PaddingLeft = UDim.new(0, 10); Pad.PaddingRight = UDim.new(0, 14); Pad.PaddingBottom = UDim.new(0, 10)
    
    Pages[name] = {Btn = Btn, Page = Page, Ind = Indicator, Stroke = BtnStroke}
    Btn.MouseButton1Click:Connect(function()
        for tName, data in pairs(Pages) do 
            local active = (tName == name)
            data.Page.Visible = active
            data.Ind.Visible = active
            TweenService:Create(data.Btn, TweenInfo.new(0.15), {BackgroundColor3 = active and Theme.TabOn or Theme.TabOff, TextColor3 = active and Theme.Text or Theme.TextDim}):Play()
            TweenService:Create(data.Stroke, TweenInfo.new(0.15), {Transparency = active and 0 or 0.3}):Play()
        end
    end)
    return Page
end

local function CreateSection(parent, text)
    local F = Instance.new("Frame", parent)
    F.LayoutOrder = #parent:GetChildren() 
    F.Size = UDim2.new(1, 0, 0, 36) -- [REGANGAN TEKS]
    F.BackgroundTransparency = 1
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 0, 14) 
    L.Position = UDim2.new(0, 4, 0, 16) 
    L.Text = text
    L.TextColor3 = Theme.TextDim
    L.Font = Enum.Font.GothamBold
    L.TextSize = 11
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
end

local function CreateToggle(parent, text, description, stateRef, callback)
    local frameHeight = description and 52 or 36
    local F = Instance.new("TextButton", parent)
    F.LayoutOrder = #parent:GetChildren()
    F.Size = UDim2.new(1, 0, 0, frameHeight)
    F.BackgroundColor3 = Theme.CardBG
    F.BorderSizePixel = 0
    F.Text = ""
    F.AutoButtonColor = false
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", F).Color = Theme.Line
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -60, 0, 20)
    L.Position = UDim2.new(0, 12, 0, description and 6 or 8)
    L.Text = text
    L.TextColor3 = Theme.Text
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    
    if description then 
        local D = Instance.new("TextLabel", F)
        D.Size = UDim2.new(1, -60, 0, 14)
        D.Position = UDim2.new(0, 12, 0, 26)
        D.Text = description
        D.TextColor3 = Theme.TextDim
        D.Font = Enum.Font.Gotham
        D.TextSize = 10
        D.TextXAlignment = Enum.TextXAlignment.Left
        D.BackgroundTransparency = 1 
    end
    
    local Sw = Instance.new("Frame", F)
    Sw.Size = UDim2.new(0, 36, 0, 18)
    Sw.Position = UDim2.new(1, -48, 0.5, -9)
    Sw.BackgroundColor3 = stateRef and Theme.Accent or Theme.ToggleOff
    Sw.BorderSizePixel = 0
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0) 
    
    local Dot = Instance.new("Frame", Sw)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0) 
    
    F.MouseButton1Click:Connect(function() 
        stateRef = not stateRef
        TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = stateRef and Theme.Accent or Theme.ToggleOff}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.25), {Position = stateRef and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        if callback then callback(stateRef) end
        SaveSettings() 
    end)
    table.insert(AllToggles, {Btn = F, Label = L})
end

local function CreateLabel(parent, text, description)
    local frameHeight = description and 45 or 30
    local F = Instance.new("Frame", parent)
    F.LayoutOrder = #parent:GetChildren() 
    F.Size = UDim2.new(1, 0, 0, frameHeight)
    F.BackgroundColor3 = Theme.CardBG
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", F).Color = Theme.Line
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -20, 0, 20)
    L.Position = UDim2.new(0, 12, 0, description and 4 or 5)
    L.Text = text
    L.TextColor3 = Theme.Text
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    
    if description then 
        local D = Instance.new("TextLabel", F)
        D.Size = UDim2.new(1, -20, 0, 14)
        D.Position = UDim2.new(0, 12, 0, 22)
        D.Text = description
        D.TextColor3 = Theme.TextDim
        D.Font = Enum.Font.Gotham
        D.TextSize = 10
        D.TextXAlignment = Enum.TextXAlignment.Left
        D.BackgroundTransparency = 1 
    end
    return L
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function() 
    local query = string.lower(SearchBox.Text)
    for _, toggle in ipairs(AllToggles) do 
        local text = string.lower(toggle.Label.Text)
        toggle.Btn.Visible = query == "" or string.find(text, query) ~= nil 
    end 
end)

-- ==========================================
-- BUILD TABS & KONTEN UI (MURNI DARI BACKUP)
-- ==========================================
local StatusTab = CreateTab("Status", true) 
local AutoFarmTab = CreateTab("Auto Farm", false) 
local DevilFruitsTab = CreateTab("Devil Fruits", false) 
local MiscTab = CreateTab("Misc", false) 

-- STATUS TAB
CreateSection(StatusTab, "PLAYER STATUS")
_G.Cat.Labels.Level = CreateLabel(StatusTab, "Level: ...", "Current level progress")
_G.Cat.Labels.Money = CreateLabel(StatusTab, "Money: ...", "In-game currency balance")
_G.Cat.Labels.Fragments = CreateLabel(StatusTab, "Fragments: ...", "Used for awakening")
_G.Cat.Labels.Bounty = CreateLabel(StatusTab, "Bounty/Honor: ...", "PvP score tracking")

CreateSection(StatusTab, "SERVER STATUS")
_G.Cat.Labels.Players = CreateLabel(StatusTab, "Players: ...", "Currently in this server")
_G.Cat.Labels.Time = CreateLabel(StatusTab, "Time: ...", "In-game day/night cycle")
_G.Cat.Labels.Moon = CreateLabel(StatusTab, "Moon: ...", "Affects certain bosses & events")
_G.Cat.Labels.Fruits = CreateLabel(StatusTab, "Spawned Fruits: 0", "Devil fruits on the map")

-- AUTO FARM TAB
CreateSection(AutoFarmTab, "COMBAT SYSTEM")
CreateToggle(AutoFarmTab, "Auto Attack", "Automatically swing weapon / fight", _G.Cat.Settings.AutoAttack, function(state) _G.Cat.Settings.AutoAttack = state end)

-- DEVIL FRUITS TAB
CreateSection(DevilFruitsTab, "FRUIT FINDER")
CreateToggle(DevilFruitsTab, "Fruit ESP", "Show text on any spawned fruits", _G.Cat.Settings.FruitESP, function(state) _G.Cat.Settings.FruitESP = state end)
CreateToggle(DevilFruitsTab, "Tween to Fruits", "Smoothly fly to collect fruits", _G.Cat.Settings.TweenFruit, function(state) _G.Cat.Settings.TweenFruit = state end)
CreateToggle(DevilFruitsTab, "TP Fruits", "Instant teleport to spawned fruits", _G.Cat.Settings.InstantTPFruit, function(state) _G.Cat.Settings.InstantTPFruit = state end)
CreateToggle(DevilFruitsTab, "Auto Store Fruits", "Store collected fruits to inventory", _G.Cat.Settings.AutoStoreFruit, function(state) _G.Cat.Settings.AutoStoreFruit = state end)
CreateToggle(DevilFruitsTab, "Auto Hop Server", "Hop if no fruits or inventory full", _G.Cat.Settings.AutoHop, function(state) _G.Cat.Settings.AutoHop = state end)

-- DISCORD WEBHOOK SECTION
CreateSection(DevilFruitsTab, "DISCORD WEBHOOK")
CreateToggle(DevilFruitsTab, "Fruit Webhook", "Send alerts to Discord on spawn", _G.Cat.Settings.FruitWebhook, function(state) _G.Cat.Settings.FruitWebhook = state end)

local WHConfig = Instance.new("Frame", DevilFruitsTab)
WHConfig.LayoutOrder = #DevilFruitsTab:GetChildren()
WHConfig.Size = UDim2.new(1, 0, 0, 106)
WHConfig.BackgroundTransparency = 1
local WHConfigLayout = Instance.new("UIListLayout", WHConfig)
WHConfigLayout.Padding = UDim.new(0, 6)
WHConfigLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 1. URL Box
local WHURLFrame = Instance.new("Frame", WHConfig)
WHURLFrame.LayoutOrder = 1
WHURLFrame.Size = UDim2.new(1, 0, 0, 32)
WHURLFrame.BackgroundColor3 = Theme.CardBG
WHURLFrame.BorderSizePixel = 0
Instance.new("UICorner", WHURLFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WHURLFrame).Color = Theme.Line

local WHURLBox = Instance.new("TextBox", WHURLFrame)
WHURLBox.Size = UDim2.new(1, -16, 1, 0)
WHURLBox.Position = UDim2.new(0, 8, 0, 0)
WHURLBox.BackgroundTransparency = 1
WHURLBox.Text = _G.Cat.Settings.FruitWebhookURL ~= "" and _G.Cat.Settings.FruitWebhookURL or ""
WHURLBox.TextColor3 = Theme.Text
WHURLBox.PlaceholderText = "Paste Discord Webhook URL here..."
WHURLBox.PlaceholderColor3 = Theme.TextDim
WHURLBox.Font = Enum.Font.GothamMedium
WHURLBox.TextSize = 11
WHURLBox.TextXAlignment = Enum.TextXAlignment.Left
WHURLBox.ClearTextOnFocus = false
WHURLBox.FocusLost:Connect(function() _G.Cat.Settings.FruitWebhookURL = WHURLBox.Text SaveSettings() end)

-- 2. Rarity Cycle Button
local WHRarityBtn = Instance.new("TextButton", WHConfig)
WHRarityBtn.LayoutOrder = 2
WHRarityBtn.Size = UDim2.new(1, 0, 0, 28)
WHRarityBtn.BackgroundColor3 = Theme.SideBG
WHRarityBtn.BorderSizePixel = 0
WHRarityBtn.Text = "Rarity: " .. _G.Cat.Settings.FruitWebhookRarity
WHRarityBtn.TextColor3 = Theme.Text
WHRarityBtn.Font = Enum.Font.GothamMedium
WHRarityBtn.TextSize = 11
WHRarityBtn.AutoButtonColor = false
Instance.new("UICorner", WHRarityBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WHRarityBtn).Color = Theme.Line

local rarityOptions = {"All Fruits", "Legendary & Mythical", "Mythical Only"}
WHRarityBtn.MouseButton1Click:Connect(function()
    local current = _G.Cat.Settings.FruitWebhookRarity
    local nextIndex = 1
    for i, v in ipairs(rarityOptions) do
        if v == current then nextIndex = (i % #rarityOptions) + 1 break end
    end
    _G.Cat.Settings.FruitWebhookRarity = rarityOptions[nextIndex]
    WHRarityBtn.Text = "Rarity: " .. rarityOptions[nextIndex]
    SaveSettings()
end)

-- 3. Test Webhook Button
local WHTestBtn = Instance.new("TextButton", WHConfig)
WHTestBtn.LayoutOrder = 3
WHTestBtn.Size = UDim2.new(1, 0, 0, 28)
WHTestBtn.BackgroundColor3 = Theme.SideBG
WHTestBtn.BorderSizePixel = 0
WHTestBtn.Text = "Test Webhook"
WHTestBtn.TextColor3 = Theme.CatPurple
WHTestBtn.Font = Enum.Font.GothamBold
WHTestBtn.TextSize = 11
WHTestBtn.AutoButtonColor = false
Instance.new("UICorner", WHTestBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", WHTestBtn).Color = Theme.Line

WHTestBtn.MouseButton1Click:Connect(function()
    WHTestBtn.Text = "Sending..."
    if _G.Cat.Webhook then
        local ok, err = _G.Cat.Webhook:Test(_G.Cat.Settings.FruitWebhookURL)
        if ok then
            WHTestBtn.Text = "Test Sent!"
        else
            WHTestBtn.Text = "Fail: " .. string.sub(tostring(err), 1, 15)
        end
    else
        WHTestBtn.Text = "Module Missing!"
    end
    task.wait(2)
    WHTestBtn.Text = "Test Webhook"
end)

-- MISC TAB
CreateToggle(MiscTab, "Anti AFK", "Prevents 20-minute idle kick", _G.Cat.Settings.AntiAFK, function(state) _G.Cat.Settings.AntiAFK = state end)

-- ==========================================
-- 4. CCTV DETEKTIF (MODE DEBUGGING F9)
-- ==========================================
task.spawn(function()
    local player = game:GetService("Players").LocalPlayer
    local sentFruits = {}
    
    local function CheckForFruit(item)
        if item:IsA("Tool") then
            -- MATIKAN FILTER SEMENTARA! Kita bongkar nama asli itemnya
            warn("------------------------------------------------")
            warn("[CCTV DETEKTIF] Lu lagi megang / masukin ke tas: " .. tostring(item.Name))
            warn("------------------------------------------------")
            
            if not _G.Cat.Settings.FruitWebhook then 
                warn("[CCTV DETEKTIF] Gagal ngirim! Toggle 'Fruit Webhook' di UI lu masih MATI (belum ungu)!")
                return 
            end 
            
            local isFruit = false
            local fruitName = item.Name
            
            -- Cek Pola 1: "Kitsune-Kitsune"
            local len = string.len(item.Name)
            local half = math.floor(len / 2)
            if half > 0 then
                local part1 = string.sub(item.Name, 1, half)
                local part2 = string.sub(item.Name, half + 2, len)
                local mid = string.sub(item.Name, half + 1, half + 1)
                
                if mid == "-" and part1 == part2 then
                    isFruit = true
                    fruitName = part1
                end
            end
            
            -- Cek Pola 2: Ada kata "Fruit"
            if not isFruit and string.find(string.lower(item.Name), "fruit") then
                isFruit = true
                fruitName = string.gsub(item.Name, " Fruit", "")
            end
            
            -- Cek Pola 3: Physical Fruit (Biasa developer ngasih tag/class begini)
            if not isFruit and item:GetAttribute("Fruit") then
                isFruit = true
                fruitName = item.Name
            end
            
            if isFruit then
                warn("[CCTV DETEKTIF] Item ini VALID dianggap BUAH! Namanya: " .. fruitName)
                
                if sentFruits[fruitName] then 
                    warn("[CCTV DETEKTIF] Notif ditahan karena Anti-Spam (biar ga double pas lu pindah ke tangan).")
                    return 
                end
                
                sentFruits[fruitName] = true
                task.delay(15, function() sentFruits[fruitName] = nil end)
                
                if _G.Cat.Webhook then
                    warn("[CCTV DETEKTIF] MESIN WEBHOOK SEKARANG SEDANG MENGIRIM KE DISCORD...")
                    local jobId = game.JobId
                    if jobId == "" then jobId = "Singleplayer/Test-Server" end
                    
                    _G.Cat.Webhook:Send(
                        fruitName, 
                        jobId, 
                        _G.Cat.Settings.FruitWebhookRarity, 
                        _G.Cat.Settings.FruitWebhookURL
                    )
                end
            else
                warn("[CCTV DETEKTIF] Item ini BUKAN dianggap buah sama script. Kalau ini beneran buah, laporin ke gue bang!")
            end
        end
    end

    -- Pantau Tas
    player.Backpack.ChildAdded:Connect(CheckForFruit)

    -- Pantau Tangan
    if player.Character then
        player.Character.ChildAdded:Connect(CheckForFruit)
    end
    
    player.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(CheckForFruit)
    end)
    
    -- JAGA-JAGA: Kalau lu UDAH megang buahnya duluan pas script jalan
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") then CheckForFruit(item) end
        end
    end
end)