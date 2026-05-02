local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- ==========================================
--  [WAJIB] OBAT FLUENT BUG LAYAR TEMBOK BLOX FRUITS
-- ==========================================
task.spawn(function()
    task.wait(2) -- Wajib nunggu 2 detik biar Fluent selesai bikin semua UI-nya
    local gui = game:GetService("CoreGui"):FindFirstChildWhichIsA("ScreenGui")
    if gui then
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("ViewportFrame") then
                -- Temukan kotak 3D Fluent, lalu HANCURKAN.
                -- Ini satu-satunya cara mutlak biar kamera lu kaga dicuri lagi.
                obj:Destroy()
            end
        end
    end
end)