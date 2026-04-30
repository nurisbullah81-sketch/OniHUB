-- [[ ==========================================
--      MODULE: DEVIL FRUITS - AUTO STORE
--    ========================================== ]]

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

-- // Variables
local Me = Players.LocalPlayer

-- // Wait for Core System Initialization
repeat 
    task.wait(0.1) 
until _G.Cat 
    and _G.Cat.UI 
    and _G.Cat.Settings 
    and _G.Cat.State

-- // Reference Global Components
local UI         = _G.Cat.UI
local Settings   = _G.Cat.Settings
local State      = _G.Cat.State
local SafeInvoke = _G.Cat.SafeInvoke

-- ==========================================
-- 1. UI INITIALIZATION
-- ==========================================
local Page = UI.CreateTab("Devil Fruits", false)

-- // Auto Store Toggle
UI.CreateToggle(
    Page, 
    "Auto Store Fruits", 
    "Store collected fruits to inventory", 
    Settings.AutoStoreFruit, 
    function(state) 
        Settings.AutoStoreFruit = state 
    end
)

-- ==========================================
-- 2. LOGIC CONFIGURATION
-- ==========================================
local StoreBlacklist = {}
local isStoring      = false

task.spawn(function() 
    while task.wait(1) do 
        -- // Validate Activation Conditions
        local canProcess = Settings.AutoStoreFruit 
            and not isStoring 
            and State.IsGameReady

        if canProcess then 
            isStoring = true

            pcall(function() 
                local character = Me.Character
                if not character then 
                    isStoring = false 
                    return 
                end 
                
                local fruitTool  = nil
                local containers = {Me.Backpack, character}
                
                -- // Step 3.1: Search Backpack and Character for Fruits
                for _, container in ipairs(containers) do
                    if not container then continue end
                    
                    for _, item in ipairs(container:GetChildren()) do
                        local isValidFruit = item:IsA("Tool") 
                            and string.find(item.Name, "Fruit") 
                            and not table.find(StoreBlacklist, item.Name)
                        
                        if isValidFruit then
                            fruitTool = item
                            break
                        end
                    end
                    if fruitTool then break end
                end
                
                -- // Step 3.2: Process Found Fruit
                if fruitTool then
                    local fruitName = fruitTool.Name
                    local fruitVal  = fruitTool:FindFirstChild("Fruit")
                    
                    -- Determine internal fruit identifier
                    if fruitVal and fruitVal:IsA("StringValue") and fruitVal.Value ~= "" then 
                        fruitName = fruitVal.Value 
                    else 
                        local rawName = string.gsub(fruitTool.Name, " Fruit", "") 
                        fruitName     = string.format("%s-%s", rawName, rawName)
                    end
                    
                    -- // Step 3.3: Storage Execution (3 Retry Limit)
                    local storeSuccess = false
                    local remoteParent = ReplicatedStorage:FindFirstChild("Remotes")
                    local storeRemote  = remoteParent and remoteParent:FindFirstChild("CommF_")

                    if storeRemote then 
                        for attempt = 1, 3 do 
                            if storeSuccess then break end
                            
                            local ok, result = SafeInvoke(
                                storeRemote, 
                                "StoreFruit", 
                                fruitName, 
                                fruitTool
                            ) 

                            if ok and result == true then 
                                storeSuccess = true 
                            else
                                task.wait(0.5)
                            end 
                        end 
                    end
                    
                    -- Add to temporary blacklist if storage fails after retries
                    if not storeSuccess then 
                        table.insert(StoreBlacklist, fruitTool.Name) 
                    end
                end
            end) 

            isStoring = false
        end 
    end 
end)