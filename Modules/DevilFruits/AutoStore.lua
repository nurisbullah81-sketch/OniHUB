-- Modules/DevilFruits/AutoStore.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Me = Players.LocalPlayer
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings or not _G.Cat.State do task.wait(0.1) end
local UI = _G.Cat.UI
local Settings = _G.Cat.Settings
local State = _G.Cat.State
local SafeInvoke = _G.Cat.SafeInvoke

-- FIX: Masuk ke kamar yang sama
local Page = UI.CreateTab("Devil Fruits", false)

-- 1. PASANG UI
UI.CreateToggle(Page, "Auto Store Fruits", "Store collected fruits to inventory", Settings.AutoStoreFruit, function(s) Settings.AutoStoreFruit = s UI.SaveSettings() end)

-- 2. LOGIC AUTO STORE
local StoreBlacklist={}
local isStoring = false

task.spawn(function() 
    while task.wait(1) do 
        if Settings.AutoStoreFruit and not isStoring and State.IsGameReady then 
            isStoring = true
            pcall(function() 
                local character = Me.Character
                if not character then isStoring = false return end 
                local fruitTool = nil
                if Me.Backpack then for _, v in pairs(Me.Backpack:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then fruitTool = v break end end end
                if not fruitTool then for _, v in pairs(character:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") and not table.find(StoreBlacklist, v.Name) then fruitTool = v break end end end

                if fruitTool then
                    local fruitName = fruitTool.Name
                    local fruitVal = fruitTool:FindFirstChild("Fruit")
                    if fruitVal and fruitVal:IsA("StringValue") and fruitVal.Value ~= "" then fruitName = fruitVal.Value else fruitName = string.gsub(fruitTool.Name, " Fruit", "") fruitName = fruitName.."-"..fruitName end
                    local storeSuccess = false
                    for _ = 1, 3 do 
                        if storeSuccess then break end
                        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                        if remote then local ok, result = SafeInvoke(remote, "StoreFruit", fruitName, fruitTool) if ok and result == true then storeSuccess = true end end
                        task.wait(0.5)
                    end
                    if not storeSuccess then table.insert(StoreBlacklist, fruitTool.Name) end
                end
            end) 
            isStoring = false
        end 
    end 
end)