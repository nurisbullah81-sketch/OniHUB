-- Modules/DevilFruits/AutoHop.lua
local HttpService = game:GetService("HttpService")
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local Me = Players.LocalPlayer
while not _G.Cat or not _G.Cat.UI or not _G.Cat.Settings or not _G.Cat.State or not _G.Cat.ESP do task.wait(0.1) end
local UI = _G.Cat.UI
local Settings = _G.Cat.Settings
local State = _G.Cat.State
local ESP = _G.Cat.ESP

-- FIX: Masuk ke kamar yang sama
local Page = UI.CreateTab("Devil Fruits", false)

-- 1. PASANG UI
UI.CreateToggle(Page, "Auto Hop Server", "Hop if no fruits or inventory full", Settings.AutoHop, function(s) Settings.AutoHop = s UI.SaveSettings() end)

-- 2. LOGIC HOP SERVER (MURNI DARI CODE LU)
local isHopping = false

function _G.Cat.HopServer()
    if isHopping then return end
    isHopping = true
    pcall(function() writefile("CatHUB_Config.json", HttpService:JSONEncode(Settings)) end)
    task.spawn(function()
        pcall(function()
            if Me.Character then local hrp = Me.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, 5000, hrp.Position.Z) hrp.Anchored = true end end
        end)
        task.wait(0.3) 
        while Settings.AutoHop do 
            local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true)
            if not browser or not browser.Enabled then
                local openBtn = Me.PlayerGui:FindFirstChild("ServerBrowserButton", true)
                if openBtn then local p, s = openBtn.AbsolutePosition, openBtn.AbsoluteSize VIM:SendMouseButtonEvent(p.X + (s.X/2), p.Y + (s.Y/2) + 58, 0, true, game, 0) task.wait(0.05) VIM:SendMouseButtonEvent(p.X + (s.X/2), p.Y + (s.Y/2) + 58, 0, false, game, 0) end
            end
            browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true) if not browser then task.wait(0.5) continue end
            local listArea = browser:FindFirstChild("Inside", true) local count = 0
            repeat task.wait(0.2) count = count + 1 listArea = browser:FindFirstChild("Inside", true) until (listArea and #listArea:GetChildren() > 5) or count > 15
            if listArea then
                local scrollFrame = browser:FindFirstChild("FakeScroll", true) local dummyScroll = browser:FindFirstChild("ScrollingFrame", true)
                if dummyScroll and dummyScroll:IsA("ScrollingFrame") then dummyScroll.CanvasPosition = Vector2.new(0, math.random(500, 2500)) task.wait(0.5) end
                if not scrollFrame then continue end
                local buttons = {} local sPos, sSize = scrollFrame.AbsolutePosition, scrollFrame.AbsoluteSize
                for _, v in pairs(listArea:GetDescendants()) do if v:IsA("TextButton") and v.Name == "Join" and v.Visible then if v.AbsolutePosition.Y > sPos.Y and v.AbsolutePosition.Y < (sPos.Y + sSize.Y - 30) then table.insert(buttons, v) end end end
                for _, target in pairs(buttons) do
                    if not Settings.AutoHop then break end 
                    local bp, bs = target.AbsolutePosition, target.AbsoluteSize local tx, ty = bp.X + (bs.X/2), bp.Y + (bs.Y/2) + 58
                    VIM:SendMouseButtonEvent(tx, ty, 0, true, game, 0) VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game) task.wait(0.05) 
                    VIM:SendMouseButtonEvent(tx, ty, 0, false, game, 0) VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game) task.wait(0.05)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0) task.wait(0.3)
                end
            end
            task.wait(0.5)
        end
        local browser = Me.PlayerGui:FindFirstChild("ServerBrowser", true) if browser then browser.Enabled = false end
        _G.Cat.ReleaseCharacter() isHopping = false
    end)
end

task.spawn(function()
    task.wait(5)
    while task.wait(2) do
        if Settings.AutoHop and State.IsGameReady then
            pcall(function()
                local fruitCount = 0 for f, _ in pairs(ESP.Data) do if f and f.Parent and f.Parent == workspace then fruitCount = fruitCount + 1 end end
                if fruitCount == 0 then _G.Cat.HopServer() end
            end)
        else if isHopping then isHopping = false _G.Cat.ReleaseCharacter() end end
    end
end)