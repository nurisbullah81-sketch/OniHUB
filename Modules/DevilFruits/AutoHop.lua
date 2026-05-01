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
-- 2. LOGIC: SERVER HOPPING ENGINE (API VERSION)
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
        -- STEP 1: Sky TP (Safety dari damage pas mau pindah)
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
        task.wait(1)

        -- STEP 2: API HOP ENGINE (Zero UI, 0% Lag, 100% Anti-Stuck)
        local TeleportService = game:GetService("TeleportService")
        local api_url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100"

        while Settings.AutoHop do
            pcall(function()
                -- Ambil data server langsung dari server utama Roblox
                local request = game:HttpGet(api_url)
                local decoded = HttpService:JSONDecode(request)

                if decoded and decoded.data then
                    local availableServers = {}

                    -- Saring server: Cari yang belum penuh & bukan server saat ini
                    for _, server in ipairs(decoded.data) do
                        if type(server) == "table" and server.playing < (server.maxPlayers - 1) and server.id ~= game.JobId then
                            table.insert(availableServers, server.id)
                        end
                    end

                    -- Kalo ada server cocok, langsung sikat pindah
                    if #availableServers > 0 then
                        local targetServer = availableServers[math.random(1, #availableServers)]
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer, Me)
                    end
                end
            end)
            
            -- Kasih jeda 3 detik biar API kaga kena limit (Error 429)
            task.wait(3)
        end

        -- Cleanup (Kalo fitur dimatiin tengah jalan)
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