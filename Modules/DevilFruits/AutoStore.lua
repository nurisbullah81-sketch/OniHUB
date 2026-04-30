-- [[ ==========================================
--      MODULE: DEVIL FRUITS - AUTO STORE (ZERO-LAG EDITION)
--      Status: Event-Driven, No Loops
--    ========================================== ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local Me = Players.LocalPlayer

repeat task.wait(0.1) until _G.Cat and _G.Cat.UI and _G.Cat.Settings and _G.Cat.State

local UI         = _G.Cat.UI
local Settings   = _G.Cat.Settings
local State      = _G.Cat.State
local SafeInvoke = _G.Cat.SafeInvoke

-- Default Fallback
if type(Settings.AutoStoreFruit) ~= "boolean" then Settings.AutoStoreFruit = false end

local Page = UI.CreateTab("Devil Fruits", false)
UI.CreateSection(Page, "INVENTORY MANAGEMENT")

UI.CreateToggle(Page, "Auto Store Fruits", "Otomatis simpan buah ke tas (0% Lag)", Settings.AutoStoreFruit, function(state) 
    Settings.AutoStoreFruit = state 
end)

-- ==========================================
-- 2. LOGIC CONFIGURATION (CCTV SYSTEM)
-- ==========================================
local StoreBlacklist = {}
local isStoring      = false

local function AttemptStore(fruitTool)
    if isStoring or not Settings.AutoStoreFruit or not State.IsGameReady then return end
    if table.find(StoreBlacklist, fruitTool.Name) then return end
    
    isStoring = true
    
    task.spawn(function()
        pcall(function()
            local fruitName = fruitTool.Name
            local fruitVal  = fruitTool:FindFirstChild("Fruit")
            
            if fruitVal and fruitVal:IsA("StringValue") and fruitVal.Value ~= "" then 
                fruitName = fruitVal.Value 
            else 
                local rawName = string.gsub(fruitTool.Name, " Fruit", "") 
                fruitName     = string.format("%s-%s", rawName, rawName)
            end
            
            local storeSuccess = false
            local remoteParent = ReplicatedStorage:FindFirstChild("Remotes")
            local storeRemote  = remoteParent and remoteParent:FindFirstChild("CommF_")

            if storeRemote then 
                for attempt = 1, 3 do 
                    if storeSuccess then break end
                    
                    local ok, result = SafeInvoke(storeRemote, "StoreFruit", fruitName, fruitTool) 
                    if ok and result == true then 
                        storeSuccess = true 
                        warn("[CatHUB] Berhasil nyimpen buah: " .. fruitName)
                    else
                        task.wait(0.5)
                    end 
                end 
            end
            
            if not storeSuccess then 
                table.insert(StoreBlacklist, fruitTool.Name) 
            end
        end)
        isStoring = false
    end)
end

-- // Pasang CCTV di Tas dan Tangan (KAGA PAKE LOOPING!)
local function CheckTool(item)
    if item:IsA("Tool") and typeof(item.Name) == "string" and string.match(item.Name, "Fruit$") then
        task.delay(0.2, function() -- Jeda dikit biar toolnya kelar kerender
            AttemptStore(item)
        end)
    end
end

-- CCTV 1: Tas Backpack
Me.Backpack.ChildAdded:Connect(CheckTool)

-- CCTV 2: Tangan Karakter (Buat antisipasi buah yang langsung masuk tangan)
Me.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(CheckTool)
end)
if Me.Character then
    Me.Character.ChildAdded:Connect(CheckTool)
end

-- // Geledah awal 1x pas script baru di-run
task.spawn(function()
    if Me.Backpack then
        for _, item in ipairs(Me.Backpack:GetChildren()) do CheckTool(item) end
    end
    if Me.Character then
        for _, item in ipairs(Me.Character:GetChildren()) do CheckTool(item) end
    end
end)