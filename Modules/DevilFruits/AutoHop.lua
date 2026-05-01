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
-- Pecah kondisi biar keliatat jelas dependency apa aja yang ditunggu
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

-- Toggle: Auto Hop Server
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

                    -- Klik tombol open
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

            -- Tunggu list server loading
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

                -- Acak posisi scroll
                if dummyScroll and dummyScroll:IsA("ScrollingFrame") then
                    local randY = math.random(500, 2500)
                    dummyScroll.CanvasPosition = Vector2.new(0, randY)
                    task.wait(0.5)
                end

                if not scrollFrame then continue end

                local buttons = {}
                local sPos    = scrollFrame.AbsolutePosition
                local sSize   = scrollFrame.AbsoluteSize

                -- Kumpulin tombol join yang keliatan
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

                        -- Cek apakah di area visible
                        if vy > yMin and vy < yMax then
                            table.insert(buttons, v)
                        end
                    end
                end

                -- FIX 1 (ANTI BENGONG): Kalo list server kosong/nge-bug, TUTUP UI!
                -- Biar di putaran loop selanjutnya dia otomatis ngeklik "Servers" lagi buat refresh.
                if #buttons == 0 then
                    if browser then browser.Enabled = false end
                    task.wait(1)
                    continue 
                end

                -- FIX 2 (CEPAT & ANTI ERROR): Jangan di-spam pake 'for loop'!
                -- Pilih 1 tombol ACAK dari list, klik, lalu tunggu hasilnya.
                -- Kalo gagal masuk, loop bakal muter lagi nyari tombol lain. 0% Lag!
                local randomTarget = buttons[math.random(1, #buttons)]
                local bp = randomTarget.AbsolutePosition
                local bs = randomTarget.AbsoluteSize
                local tx = bp.X + (bs.X / 2)
                local ty = bp.Y + (bs.Y / 2) + 58

                -- Klik Join & Enter
                VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0)
                VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)

                VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0)
                VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)

                -- Kasih jeda pas buat 1x proses teleport (Kalo sukses lu pindah, kalo gagal dia ngulang pinter)
                task.wait(3)
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
    task.wait(10) -- Jeda awal biar game stabil

    while task.wait(2) do
        -- // Safety Check: Skip kalo game belum siap
        if not State.IsGameReady then
            _G.Cat.WaitUntilReady()
            task.wait(5) -- Jeda lama pas loading
            continue
        end

        -- // Main Logic
        if Settings.AutoHop and State.IsGameReady then
            local success, err = pcall(function()
                local fruitCount = 0

                -- Scan Data ESP (Cek buah di workspace)
                if _G.Cat.ESP and _G.Cat.ESP.Data then
                    for fruit, _ in pairs(_G.Cat.ESP.Data) do
                        if fruit and fruit.Parent == workspace then
                            fruitCount = fruitCount + 1
                        end
                    end
                end

                -- Logic Hop: Kalo ga ada buah, pindah server
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

        -- // Cleanup Logic
        -- Reset kalo fitur dimatiin pas proses hop jalan
        if isHopping and not Settings.AutoHop then
            isHopping = false

            if _G.Cat.ReleaseCharacter then
                _G.Cat.ReleaseCharacter()
            end
        end
    end
end)