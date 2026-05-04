-- [[ CAT HUB: FULL UI LAYOUT (REDZ STYLE) ]]
-- STRICTLY USING REDZ LIB V5 API SIGNATURES

local Window = redzlib:MakeWindow({
    "CatHUB",
    "by : CatHUB Team",
    false -- Nonaktifkan auto-save file biar nggak numpuk
})

-- ==========================================
-- TAB 1: MAIN
-- ==========================================
local TabMain = Window:MakeTab({"Main", "home"})

TabMain:AddSection("Player Statistics")
TabMain:AddParagraph({
    "Status",
    "Level: - | Beli: - | Fragments: -\nMelee: - | Sword: - | Gun: - | Defense: - | Fruit: -"
})

TabMain:AddSection("Server Info")
TabMain:AddParagraph({
    "Server",
    "Time Left: -\nPlayers: - / -"
})

TabMain:AddSection("Actions")
TabMain:AddButton({
    "Rejoin Server",
    function() 
        -- [HUBUNGKAN KE LOGIC REJOIN LO]
    end,
    Desc = "Kembali ke server yang sama"
})

TabMain:AddButton({
    "Server Hop",
    function() 
        -- [HUBUNGKAN KE LOGIC HOP LO]
    end,
    Desc = "Cari server baru yang sepi"
})

TabMain:AddToggle({
    "Auto Server Hop",
    false, -- Default
    function(Value)
        -- [COMING SOON] _G.Cat.Settings.AutoHop = Value
    end,
    "AutoHop",
    Desc = "Otomatis pindah server saat selesai / kosong"
})

TabMain:AddSection("Utility")
TabMain:AddButton({
    "Remove Lava",
    function() end, -- [COMING SOON]
    Desc = "Hilangkan lava di Prehistoric Island"
})

TabMain:AddButton({
    "Remove Boat Collision",
    function() end, -- [COMING SOON]
    Desc = "Hilangi collision boat biar nggak nyangkut"
})

TabMain:AddSection("Community")
TabMain:AddDiscordInvite({
    "CatHUB Discord",
    "Join discord untuk update script, lapor bug, dan request fitur.",
    "rbxassetid://0", -- Ganti dengan ID Logo Server Discord lo
    "discord.gg/catHub" -- Ganti dengan link invite lo
})

-- ==========================================
-- TAB 2: FARM (Bagian 1: Core Settings)
-- ==========================================
local TabFarm = Window:MakeTab({"Farm", "sword"})

TabFarm:AddSection("Auto Farm")
TabFarm:AddToggle({
    "Auto Farm",
    false,
    function(Value)
        -- _G.Cat.Settings.AutoFarm = Value
    end,
    "AutoFarm",
    Desc = "Farm mob otomatis sesuai level"
})

TabFarm:AddToggle({
    "Auto Quest",
    true,
    function(Value)
        -- _G.Cat.Settings.AutoQuest = Value
    end,
    "AutoQuest",
    Desc = "Ambil dan selesaikan quest otomatis"
})

TabFarm:AddDropdown({
    "Farm Mode",
    {"Normal", "Chest", "Bounty", "Factory"},
    "Normal",
    function(Value)
        -- Logic pindah mode farm
    end,
    "FarmMode"
})

TabFarm:AddDropdown({
    "Select Sea",
    {"Sea 1", "Sea 2", "Sea 3"},
    "Sea 1",
    function(Value)
        -- Logic filter sea
    end,
    "FarmSea"
})

TabFarm:AddSection("Combat Settings")
TabFarm:AddToggle({
    "Fast Attack",
    false,
    function(Value)
        -- _G.Cat.Settings.FastAttack = Value
    end,
    "FastAttack",
    Desc = "Meningkatkan kecepatan serangan M1"
})

TabFarm:AddToggle({
    "Auto Click / M1",
    false,
    function(Value)
        -- _G.Cat.Settings.AutoAttack = Value
    end,
    "AutoClick",
    Desc = "Klik otomatis tanpa perlu pencet mouse"
})

TabFarm:AddToggle({
    "Bring Mobs",
    false,
    function(Value)
        -- _G.Cat.Settings.BringMobs = Value
    end,
    "BringMobs",
    Desc = "Mengumpulkan semua mob ke satu tempat"
})

TabFarm:AddSlider({
    "Bring Distance",
    10, 500, 10, 150,
    function(Value)
        -- Logic ubah jarak bring
    end,
    "BringDistance",
    Desc = "Jarak maksimal mob yang akan di-bring"
})

TabFarm:AddSection("Haki & Buff")
TabFarm:AddToggle({
    "Auto Buso",
    true,
    function(Value)
        -- _G.Cat.Settings.AutoBuso = Value
    end,
    "AutoBuso",
    Desc = "Aktifkan Haki Pelindung otomatis"
})

TabFarm:AddToggle({
    "Auto Ken",
    false,
    function(Value) end, -- [COMING SOON]
    "AutoKen",
    Desc = "Aktifkan Haki Penglihatan otomatis"
})

TabFarm:AddSlider({
    "Attack Distance",
    10, 300, 10, 75,
    function(Value)
        -- Logic ubah jarak serangan
    end,
    "AttackDistance",
    Desc = "Jarak mob sebelum mulai menyerang"
})

-- (LANJUTAN TAB FARM)
-- ==========================================
-- FARM: WEAPON CONFIG
-- ==========================================
TabFarm:AddSection("Weapon Selection")

TabFarm:AddDropdown({
    "Select Melee",
    {"Combat", "Dark Step", "Electro", 
    "Fishman Karate", "Dragon Breath", 
    "Superhuman", "Death Step", "Sharkman Karate", 
    "Electric Claw", "Dragon Talon", "Godhuman"},
    "Combat",

    function(Value) end, -- [COMING SOON]
    "MeleeWeapon"
})

TabFarm:AddDropdown({
    "Select Sword",
    {"None", "Saber", "Katana", 
    "Dual Katana", "Iron Mace", 
    "Triple Katana", "Pipe", 
    "Dual-Headed Blade", "Soul Cane", 
    "Bisento", "Wando", "Shisui", "Saddi", 
    "Yoru", "Tushita", "Spikey Trident", 
    "Hallow Scythe", "Dark Dagger", 
    "Midnight Blade", "Buddy Sword", "Canvander"},
    "None",

    function(Value) end, -- [COMING SOON]
    "SwordWeapon"
})

TabFarm:AddDropdown({
    "Select Gun",
    {"None", "Musket", "Slingshot", "Flintlock", "Refined Slingshot", "Dual Flintlock", "Cannon", "Kabucha"},
    "None",
    function(Value) end, -- [COMING SOON]
    "GunWeapon"
})

-- ==========================================
-- FARM: DEVIL FRUIT CONFIG
-- ==========================================
TabFarm:AddSection("Devil Fruit Config")

TabFarm:AddToggle({
    "Use Devil Fruit",
    false,
    function(Value) end, -- [COMING SOON]
    "UseFruit",
    Desc = "Gunakan skill buah iblis saat farm"
})

TabFarm:AddDropdown({
    "Select Devil Fruit",
    {"None", "Rocket", "Spin", "Blade", "Spring", "Bomb", "Smoke", "Spike", "Flame", "Sand", "Dark", "Diamond", "Light", "Rubber", "Ghost", "Magma", "Quake", "Buddha", "Love", "Spider", "Sound", "Phoenix", "Portal", "Rumble", "Pain", "Blizzard", "Gravity", "Mammoth", "T-Rex", "Dough", "Shadow", "Venom", "Control", "Spirit", "Leopard", "Kitsune"},
    "None",
    function(Value) end, -- [COMING SOON]
    "FruitWeapon"
})

TabFarm:AddDropdown({
    "Fruit Attack Type",
    {"Melee", "Fruit M1"},
    "Melee",
    function(Value) end, -- [COMING SOON]
    "FruitAttackType",
    Desc = "Pilih mode serangan saat buah aktif"
})

-- ==========================================
-- FARM: SKILL SETTINGS (Z, X, C, V, F)
-- ==========================================
TabFarm:AddSection("Skill Config")

TabFarm:AddToggle({
    "Skill Z",
    true,
    function(Value) end, -- [COMING SOON]
    "SkillZ"
})
TabFarm:AddToggle({
    "Skill X",
    true,
    function(Value) end, -- [COMING SOON]
    "SkillX"
})
TabFarm:AddToggle({
    "Skill C",
    true,
    function(Value) end, -- [COMING SOON]
    "SkillC"
})
TabFarm:AddToggle({
    "Skill V",
    false,
    function(Value) end, -- [COMING SOON]
    "SkillV"
})
TabFarm:AddToggle({
    "Skill F",
    false,
    function(Value) end, -- [COMING SOON]
    "SkillF"
})

-- ==========================================
-- TAB 3: STATS
-- ==========================================
local TabStats = Window:MakeTab({"Stats", "bar-chart-2"})

TabStats:AddSection("Auto Stats")
TabStats:AddToggle({
    "Auto Allocate Stats",
    false,
    function(Value)
        -- Logic auto stat on/off
    end,
    "AutoStats",
    Desc = "Otomatis beli stat saat dapat point"
})

TabStats:AddSection("Stat Distribution")
TabStats:AddToggle({
    "Melee",
    false,
    function(Value) end, -- [COMING SOON]
    "StatMelee"
})
TabStats:AddToggle({
    "Defense",
    false,
    function(Value) end, -- [COMING SOON]
    "StatDefense"
})
TabStats:AddToggle({
    "Sword",
    false,
    function(Value) end, -- [COMING SOON]
    "StatSword"
})
TabStats:AddToggle({
    "Gun",
    false,
    function(Value) end, -- [COMING SOON]
    "StatGun"
})
TabStats:AddToggle({
    "Devil Fruit",
    false,
    function(Value) end, -- [COMING SOON]
    "StatFruit"
})

TabStats:AddSection("Advanced Settings")
TabStats:AddSlider({
    "Points to Keep",
    1, 2550, 1, 5,
    function(Value)
        -- Logic simpan stat minimum
    end,
    "PointsToKeep",
    Desc = "Jumlah point yang nggak akan di pakai otomatis"
})

TabStats:AddToggle({
    "Lock Stats at Max",
    false,
    function(Value) end, -- [COMING SOON]
    "LockMaxStats",
    Desc = "Berhenti auto stat saat satu stat mencapai max"
})

-- ==========================================
-- TAB 4: SHOP
-- ==========================================
local TabShop = Window:MakeTab({"Shop", "shopping-bag"})

TabShop:AddSection("Fighting Styles")
TabShop:AddDropdown({
    "Select Style",
    {"Black Leg", "Electro", "Fishman Karate", "Dragon Breath", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman"},
    "Black Leg",
    function() end, -- [COMING SOON]
    "ShopStyleDropdown"
})
TabShop:AddButton({
    "Buy Fighting Style",
    function() 
        -- Logic beli style: Module.FireRemote("BuyHaki", DropdownValue)
    end,
    Desc = "Beli style yang dipilih di dropdown"
})

TabShop:AddSection("Swords")
TabShop:AddDropdown({
    "Select Sword",
    {"Katana", "Cutlass", "Dual Katana", "Iron Mace", "Triple Katana", "Pipe", "Dual-Headed Blade", "Soul Cane", "Bisento"},
    "Katana",
    function() end, -- [COMING SOON]
    "ShopSwordDropdown"
})
TabShop:AddButton({
    "Buy Sword",
    function() 
        -- Logic beli sword: Module.FireRemote("BuyItem", DropdownValue)
    end,
    Desc = "Beli pedang yang dipilih di dropdown"
})

TabShop:AddSection("Guns")
TabShop:AddDropdown({
    "Select Gun",
    {"Musket", "Slingshot", "Flintlock", "Refined Slingshot", "Dual Flintlock", "Cannon", "Kabucha"},
    "Musket",
    function() end, -- [COMING SOON]
    "ShopGunDropdown"
})
TabShop:AddButton({
    "Buy Gun",
    function() 
        -- Logic beli gun
    end,
    Desc = "Beli senjata api yang dipilih di dropdown"
})

TabShop:AddSection("Accessories & Misc")
TabShop:AddButton({
    "Buy Race Reroll",
    function() 
        -- Module.FireRemote("BlackbeardReward", "Reroll", "2")
    end,
    Desc = "Mengulang race (Butuh 1500 Fragments)"
})
TabShop:AddButton({
    "Buy Stat Refund",
    function() 
        -- Module.FireRemote("BlackbeardReward", "Refund", "2")
    end,
    Desc = "Reset semua stat (Butuh 2500 Fragments)"
})
TabShop:AddButton({
    "Buy Ghoul Mask",
    function() 
        -- Module.FireRemote("Ectoplasm", "Buy", 2)
    end,
    Desc = "Beli Ghoul Mask (Butuh 50 Ectoplasm)"
})

-- ==========================================
-- TAB 5: DEVIL FRUIT
-- ==========================================
local TabDF = Window:MakeTab({"Devil Fruit", "apple"})

TabDF:AddSection("ESP & Tracking")
TabDF:AddToggle({
    "Fruit ESP",
    false,
    function(Value) 
        -- _G.Cat.Settings.FruitESP = Value
    end,
    "FruitESP",
    Desc = "Tunjukkan lokasi buah di seluruh map"
})
TabDF:AddToggle({
    "Near Fruit ESP",
    false,
    function(Value) end, -- [COMING SOON]
    "NearFruitESP",
    Desc = "Tunjukkan buah yang cuma dekat dengan player"
})
TabDF:AddToggle({
    "Fruit Sniper",
    false,
    function(Value) end, -- [COMING SOON]
    "FruitSniper",
    Desc = "Lock kamera otomatis ke buah yang muncul"
})

TabDF:AddSection("Auto Grab & Store")
TabDF:AddToggle({
    "Auto Grab Fruit",
    false,
    function(Value) end, -- [COMING SOON]
    "AutoGrab",
    Desc = "Otomatis ambil buah yang ada di map/dekat"
})
TabDF:AddToggle({
    "Auto Store Fruit",
    false,
    function(Value)
        -- _G.Cat.Settings.AutoStoreFruit = Value
    end,
    "AutoStore",
    Desc = "Simpan buah yang baru diambil langsung ke inventory"
})
TabDF:AddDropdown({
    "Store To",
    {"Inventory", "Coffin", "Treasure"},
    "Inventory",
    function() end, -- [COMING SOON]
    "StoreLocation",
    Desc = "Pilih tempat menyimpan buah"
})

-- ==========================================
-- TAB 6: RAID
-- ==========================================
local TabRaid = Window:MakeTab({"Raid", "zap"})

TabRaid:AddSection("Raid Configuration")
TabRaid:AddDropdown({
    "Raid Type",
    {"Normal", "Advanced"},
    "Normal",
    function() end, -- [COMING SOON]
    "RaidType"
})
TabRaid:AddDropdown({
    "Select Raid Fruit",
    {"Flame", "Ice", "Quake", "Light", "Dark", "Rumble", "Magma", "Buddha", "Sand", "Spider", "Phoenix", "Dough", "Venom", "Control", "Shadow", "Dragon", "Leopard", "Kitsune", "T-Rex", "Mammoth", "Blizzard", "Gravity", "Pain"},
    "Flame",
    function() end, -- [COMING SOON]
    "SelectRaid"
})

TabRaid:AddSection("Automation")
TabRaid:AddToggle({
    "Auto Start Raid",
    false,
    function(Value) end, -- [COMING SOON]
    "AutoStartRaid",
    Desc = "Mulai raid otomatis saat sudah di pulau"
})
TabRaid:AddToggle({
    "Auto Next Island",
    false,
    function(Value) end, -- [COMING SOON]
    "AutoNextIsland",
    Desc = "Otomatis pindah ke pulau berikutnya saat mob kosong"
})

TabRaid:AddSection("Raid Boosts")
TabRaid:AddToggle({
    "Kill Aura Raid",
    false,
    function(Value) end, -- [COMING SOON]
    "KillAuraRaid",
    Desc = "Bunuh semua mob sekitar secara instan"
})
TabRaid:AddToggle({
    "Super Bring Raid",
    false,
    function(Value) end, -- [COMING SOON]
    "SuperBringRaid",
    Desc = "Kumpulkan semua mob di raid ke satu titik"
})

-- ==========================================
-- TAB 7: TELEPORT
-- ==========================================
local TabTeleport = Window:MakeTab({"Teleport", "map-pin"})

TabTeleport:AddSection("Sea Selection")
TabTeleport:AddDropdown({
    "Select Sea",
    {"Sea 1", "Sea 2", "Sea 3"},
    "Sea 1",
    function() end, -- [COMING SOON]
    "TeleportSea"
})

TabTeleport:AddSection("Island Teleport")
-- List panjang biar mirip asli
TabTeleport:AddDropdown({
    "Select Island",
    {"Pirate Village", "Marine Fortress", "Jungle", "Pirate Ship", "Desert", "Green Zone", "Magma Village", "Underwater City", "Prison", "Colosseum", "Fishman Cave", "Skylands", "Skypiea", "Impel Down", "Upper Yard", "Cake Island", "Cursed Ship", "Frozen Village", "Mansion", "Floating Turtle", "Hydra Island", "Great Tree", "Castle on the Sea", "Tiki Outpost", "Sea of Treats", "Diary Island", "Peanut Island", "Ice Cream Island", "Chocolate Island", "Candy Island"},
    "Pirate Village",
    function() end, -- [COMING SOON]
    "TeleportIsland"
})
TabTeleport:AddButton({
    "Teleport to Island",
    function() 
        -- Logic teleport: CFrame ke posisi island
    end,
    Desc = "Teleport langsung ke pulau yang dipilih"
})

TabTeleport:AddSection("Dungeons")
TabTeleport:AddButton({
    "Teleport to Factory",
    function() end, -- [COMING SOON]
    Desc = "Masuk ke dalam Factory"
})
TabTeleport:AddButton({
    "Teleport to Raid Lobby",
    function() end, -- [COMING SOON]
    Desc = "Teleport ke tempat awal masuk raid"
})

TabTeleport:AddSection("Sea Events")
TabTeleport:AddButton({
    "Teleport to Sea Beast",
    function() end, -- [COMING SOON]
    Desc = "Teleport ke lokasi Sea Beast terdekat"
})
TabTeleport:AddButton({
    "Teleport to Ship Raid",
    function() end, -- [COMING SOON]
    Desc = "Teleport ke kapal Ship Raid"
})

-- ==========================================
-- TAB 8: MISC
-- ==========================================
local TabMisc = Window:MakeTab({"Misc", "settings2"})

TabMisc:AddSection("Player Utilities")
TabMisc:AddToggle({
    "Anti AFK",
    true,
    function(Value)
        -- _G.Cat.Settings.AntiAFK = Value
    end,
    "AntiAFK",
    Desc = "Mencegah kick karena idle terlalu lama"
})
TabMisc:AddToggle({
    "FPS Boost",
    false,
    function(Value)
        -- _G.Cat.Settings.FPSBoost = Value
    end,
    "FPSBoost",
    Desc = "Menaikkan FPS dengan menurunkan kualitas grafis"
})
TabMisc:AddToggle({
    "Click Teleport",
    false,
    function(Value) end, -- [COMING SOON]
    "ClickTP",
    Desc = "Teleport ke tempat yang diklik mouse"
})
TabMisc:AddToggle({
    "Infinite Range",
    false,
    function(Value) end, -- [COMING SOON]
    "InfiniteRange",
    Desc = "Biar bisa pickpocket/interaksi dari jarak jauh"
})

TabMisc:AddSection("Webhook Notifications")
TabMisc:AddToggle({
    "Fruit Webhook",
    false,
    function(Value)
        -- _G.Cat.Settings.FruitWebhook = Value
    end,
    "FruitWebhook",
    Desc = "Kirim notif ke Discord saat buah spawn"
})
TabMisc:AddTextBox({
    "Webhook URL",
    "",
    "Input Discord Webhook URL...",
    false,
    function(Value)
        -- _G.Cat.Settings.FruitWebhookURL = Value
    end
})
TabMisc:AddDropdown({
    "Webhook Rarity",
    {"Mythical Only", "Legendary & Above", "All Fruits"},
    "Mythical Only",
    function() end, -- [COMING SOON]
    "WebhookRarity",
    Desc = "Filter tipe buah yang trigger webhook"
})

TabMisc:AddSection("Combat Utilities")
TabMisc:AddToggle({
    "Kill Aura",
    false,
    function(Value) end, -- [COMING SOON]
    "KillAura",
    Desc = "Bunuh semua mob dalam radius instan"
})
TabMisc:AddSlider({
    "Kill Aura Distance",
    50, 1000, 50, 500,
    function() end, -- [COMING SOON]
    "KillAuraDistance",
    Desc = "Jarak maksimal Kill Aura"
})

-- ==========================================
-- TAB 9: SETTINGS (PENGATURAN UI)
-- ==========================================
local TabSettings = Window:MakeTab({"Settings", "sliders-horizontal"})

TabSettings:AddSection("UI Appearance")
TabSettings:AddDropdown({
    "Select Theme",
    {"Darker", "Dark", "Purple"},
    "Darker",
    function(Value)
        -- Ini fungsi NATIF dari Redz Lib V5
        redzlib:SetTheme(Value)
    end,
    "UITheme",
    Desc = "Ganti skema warna keseluruhan UI"
})

TabSettings:AddSlider({
    "UI Scale",
    300, 2000, 50, 450,
    function(Value)
        -- Ini fungsi NATIF dari Redz Lib V5 (Default 450)
        redzlib:SetScale(Value)
    end,
    "UIScale",
    Desc = "Perbesar/Perkecil ukuran UI (Default: 450)"
})

TabSettings:AddSection("Window Controls")
TabSettings:AddButton({
    "Toggle Minimize UI",
    function()
        -- Ini fungsi NATIF dari Redz Lib V5
        Window:Minimize()
    end,
    Desc = "Sembunyikan atau tampilkan UI secara langsung"
})

TabSettings:AddButton({
    "Reset UI to Default",
    function()
        -- Reset scale ke default (450) dan tema ke Darker
        redzlib:SetScale(450)
        redzlib:SetTheme("Darker")
    end,
    Desc = "Kembalikan ukuran dan warna UI ke awal"
})

TabSettings:AddSection("Mobile Support")
TabSettings:AddButton({
    "Create Minimize Button",
    function()
        -- Ini fungsi NATIF Redz Lib V5 untuk bikin tombol floating di HP
        Window:AddMinimizeButton({
            Corner = UDim.new(0, 12),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Stroke = {
                Color = Color3.fromRGB(60, 60, 60),
                Thickness = 1
            }
        })
    end,
    Desc = "Bikin tombol kecil di layar untuk buka/tutup UI (Khusus Mobile)"
})

TabSettings:AddParagraph({
    "UI Information",
    "UI Engine: Redz Lib V5\nCreated for: CatHUB\nStatus: Shell Ready"
})