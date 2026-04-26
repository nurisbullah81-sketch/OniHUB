local function Load(file)
    local url = "https://raw.githubusercontent.com/nurisbullah81-sketch/OniHUB/refs/heads/main/" .. file .. "?v=" .. math.random()
    local ok, r = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not ok then warn("[CatHUB] Fail: " .. file .. " | " .. tostring(r)) end
    return r
end

local VirtualUser = game:GetService("VirtualUser")
_G.Cat.Player.Idled:Connect(function()
    if _G.Cat.Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

Load("StyleUI.lua")
Load("Status.lua")
Load("Devil_Fruits.lua")

