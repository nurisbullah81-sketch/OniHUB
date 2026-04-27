-- Logika HopServer Anti-Cloudflare (Multi-Proxy, Validation, User-Agent, Randomized)

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Me = _G.Cat.Player
local PlaceID = game.PlaceId

-- Proxy List (Urutan prioritas)
local Proxies = {
    "https://games.roproxy.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100",
    "https://games.api.hyra.io/v1/games/%s/servers/Public?sortOrder=Asc&limit=100",
    "https://roproxy.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"
}

-- Cek executor request (Xeno, Syn, Fluxus support ini untuk User-Agent)
local requestFunc = http_request or (syn and syn.request) or request

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    
    warn("[CatHUB] [HOP] Mulai cari server...")

    for _, proxyUrl in ipairs(Proxies) do
        local url = string.format(proxyUrl, PlaceID)
        local rawBody = ""
        local successFetch = false

        -- 1. FETCH DENGAN USER-AGENT (BYPASS CLOUDFLARE)
        if requestFunc then
            local ok, res = pcall(function()
                return requestFunc({
                    Url = url,
                    Method = "GET",
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
                    }
                })
            end)
            if ok and res and res.Body then
                rawBody = res.Body
                successFetch = true
            end
        end

        -- Fallback kalau executor ga support request
        if not successFetch then
            local ok, res = pcall(function() return game:HttpGet(url) end)
            if ok then rawBody = res end
        end

        -- 2. BODY VALIDATION (CEK HTML SAMPAH)
        if rawBody:find("<!DOCTYPE html>") or rawBody:find("<html") then
            warn("[CatHUB] [HOP] Proxy " .. proxyUrl .. " kena block Cloudflare! Skipping...")
            continue -- Langsung coba proxy berikutnya
        end

        -- 3. PARSE JSON (DENGAN PCALL KETAT)
        local ok, data = pcall(function()
            return HttpService:JSONDecode(rawBody)
        end)

        if ok and data and data.data then
            local validServers = {}
            for _, srv in ipairs(data.data) do
                if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    table.insert(validServers, srv)
                end
            end

            -- 4. RANDOMIZED START (Acak pilihan server)
            if #validServers > 0 then
                local chosen = validServers[math.random(1, #validServers)]
                warn("[CatHUB] [HOP] Gas Teleport! Ke server " .. chosen.id .. " (" .. chosen.playing .. "/" .. chosen.maxPlayers .. ")")
                
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(PlaceID, chosen.id, Me)
                end)
                
                break -- Berhasil dapet server, berhenti nyari
            else
                warn("[CatHUB] [HOP] Proxy " .. proxyUrl .. " ga ada slot kosong.")
            end
        else
            warn("[CatHUB] [HOP] Proxy " .. proxyUrl .. " gagal parse JSON.")
        end
    end
    
    task.wait(15)
    isHopping = false
end