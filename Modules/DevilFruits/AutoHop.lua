-- [[ ==========================================
--      MODULE: DEVIL FRUITS - AUTO HOP SERVER
--    ========================================== ]]

-- // Services
local HttpService = game:GetService("HttpService")
local VIM         = game:GetService("VirtualInputManager")
local Players     = game:GetService("Players")

-- // Variables
local Me = Players.LocalPlayer

-- // Wait for Global Framework
while not (
    _G.Cat and
    _G.Cat.UI and
    _G.Cat.Settings and
    _G.Cat.State and
    _G.Cat.ESP
) do
    task.wait(0.1)
end

-- // Global References
local UI       = _G.Cat.UI
local Settings = _G.Cat.Settings
local State    = _G.Cat.State
local ESP      = _G.Cat.ESP

-- ==========================================
-- 1. UI SETUP (Devil Fruits Tab)
-- ==========================================

local Page = UI.CreateTab("Devil Fruits", false)

UI.CreateToggle(
    Page,
    "Auto Hop Server",
    "Hop if no fruits or inventory full",
    Settings.AutoHop,
    function(s)
        Settings.AutoHop = s
    end
)

-- ==========================================
-- 2. LOGIC: SERVER HOPPING ENGINE
-- ==========================================
local isHopping = false

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true

    -- Save settings sebelum pindah server
    pcall(function()
        local encoded = HttpService:JSONEncode(Settings)
        writefile("CatHUB_Config.json", encoded)
    end)

    task.spawn(function()
        -- STEP 1: Sky TP (Safety)
        pcall(function()
            if Me.Character then
                local hrp = Me.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local x = hrp.Position.X
                    local z = hrp.Position.Z
                    hrp.CFrame = CFrame.new(x, 5000, z)
                    hrp.Anchored = true
                end
            end
        end)
        task.wait(0.3)

        -- MAIN HOP LOOP
        while Settings.AutoHop do
            local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)

            -- Buka Browser kalo ketutup
            if not browser or not browser.Enabled then
                local btnName = "ServerBrowserButton"
                local openBtn = Me.PlayerGui:FindFirstChild(btnName, true)

                if openBtn then
                    local pos  = openBtn.AbsolutePosition
                    local size = openBtn.AbsoluteSize
                    local tx   = pos.X + (size.X / 2)
                    local ty   = pos.Y + (size.Y / 2) + 58

                    VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                    task.wait(0.05)
                    VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                end
            end

            browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            if not browser then
                task.wait(0.5)
                continue
            end

            local listArea = browser:FindFirstChild("Inside", true)
            local count    = 0

            repeat
                task.wait(0.2)
                count    = count + 1
                listArea = browser:FindFirstChild("Inside", true)
            until (listArea and #listArea:GetChildren() > 5) or count > 15

            if listArea then
                local scrollFrame = browser:FindFirstChild("FakeScroll", true)
                local dummyScroll = browser:FindFirstChild("ScrollingFrame", true)

                if dummyScroll and dummyScroll:IsA("ScrollingFrame") then
                    local randY = math.random(500, 2500)
                    dummyScroll.CanvasPosition = Vector2.new(0, randY)
                    task.wait(0.5)
                end

                if not scrollFrame then continue end

                local buttons = {}
                local sPos    = scrollFrame.AbsolutePosition
                local sSize   = scrollFrame.AbsoluteSize

                for _, v in pairs(listArea:GetDescendants()) do
                    local isBtn = v:IsA("TextButton") 
                        and v.Name == "Join" 
                        and v.Visible

                    if isBtn then
                        local vy = v.AbsolutePosition.Y
                        local yMin = sPos.Y
                        local yMax = sPos.Y + sSize.Y - 30

                        if vy > yMin and vy < yMax then
                            table.insert(buttons, v)
                        end
                    end
                end

                for _, target in pairs(buttons) do
                    if not Settings.AutoHop then break end

                    local bp = target.AbsolutePosition
                    local bs = target.AbsoluteSize
                    local tx = bp.X + (bs.X / 2)
                    local ty = bp.Y + (bs.Y / 2) + 58

                    VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait(0.05)

                    VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

                    task.wait(0.05)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    task.wait(0.3)
                end
            end
            task.wait(0.5)
        end

        -- Cleanup
        local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
        if browser then
            browser.Enabled = false
        end

        if _G.Cat.ReleaseCharacter then
            _G.Cat.ReleaseCharacter()
        end

        isHopping = false
    end)
end

-- [[ LOKASI: PALING BAWAH SENDIRI ]]

task.spawn(function()
    task.wait(10)

    while task.wait(2) do
        if not State.IsGameReady then
            _G.Cat.WaitUntilReady()
            task.wait(5)
            continue
        end

        if Settings.AutoHop and State.IsGameReady then
            local success, err = pcall(function()
                local fruitCount = 0

                if _G.Cat.ESP and _G.Cat.ESP.Data then
                    for fruit, _ in pairs(_G.Cat.ESP.Data) do
                        if fruit and fruit.Parent then
                            -- FILTER CERDAS: Abaikan kalau buah dipegang player lain
                            -- Di Blox Fruits, buah yang diambil jadi Tool di Character.
                            local isHeldByOther = false
                            
                            if fruit:IsA("Tool") then
                                isHeldByOther = true
                            else
                                -- Cek kalau instance buah berada di dalam Character player lain
                                local char = fruit:FindFirstAncestorOfClass("Model")
                                if char and Players:GetPlayerFromCharacter(char) then
                                    isHeldByOther = true
                                end
                            end

                            -- Kalau buah nggak dipegang orang, baru itung sebagai buah valid
                            if not isHeldByOther then
                                fruitCount = fruitCount + 1
                            end
                        end
                    end
                end

                -- Logic Hop: Kalau ga ada buah valid, pindah server
                if fruitCount == 0 then
                    if not isHopping then
                        _G.Cat.HopServer()
                    end
                end
            end)

            if not success then
                warn("[CatHUB] Error scan: ", err)
            end
        end

        -- Cleanup Logic
        if isHopping and not Settings.AutoHop then
            isHopping = false

            if _G.Cat.ReleaseCharacter then
                _G.Cat.ReleaseCharacter()
            end
        end
    end
end)