--================================================--
--    FOG MUSIC HUB & CLOUD CHANGER (FINAL FIX)   --
--================================================--

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Set Tema Gelap Elegan
WindUI:SetTheme("Dark")

-- Create Main Window
local Window = WindUI:CreateWindow({
    Title = "FOG Hub",
    Icon = "crown",
    Author = "Swa Team",
    Size = UDim2.new(0, 480, 0, 520),
})

Window:EditOpenButton({ Title = "Open FOG Hub", Icon = "star", Enabled = true })
Window:Tag({ Title = "v0.0.012 - ( Complete Edition )", Color = Color3.fromRGB(168, 85, 247) })

-- Ambil Avatar Thumbnail Roblox
local success, thumbnail = pcall(function()
    return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)

if not success then
    thumbnail = "rbxassetid://0"
end

--------------------------------------------------
-- DAFTAR ID LAGU
--------------------------------------------------
local songList = {
    { name = "Song 3", id = "90521568613709" },
    { name = "Song 6", id = "71393805905055" },
    { name = "Song 8", id = "134763052215450" },
    { name = "Song 9", id = "85598267402579" },
    { name = "Song 18", id = "137287856848151" },
    { name = "Song 19", id = "89468064746667" },
    { name = "Song 20", id = "83707813531588" },
    { name = "Song 21", id = "104759646592993" },
    {name = "song 1", id = "104759646592993" },
    {name = "song 2", id = "93192520113222" },
}

--------------------------------------------------
-- GLOBAL SOUND PLAYER & AUTO-NEXT SYSTEM
--------------------------------------------------
local currentSound = Instance.new("Sound")
currentSound.Name = "FOG_MusicPlayer"
currentSound.Volume = 2
currentSound.Looped = false
currentSound.Parent = SoundService

local isPlaylistActive = false
local currentPlaylistIndex = 1

local function playMusic(songId, songName)
    currentSound:Stop()
    currentSound.SoundId = "rbxassetid://" .. tostring(songId)
    
    task.spawn(function()
        pcall(function()
            if not currentSound.IsLoaded then
                currentSound.Loaded:Wait()
            end
            currentSound:Play()
        end)
    end)
    
    WindUI:Notify({ Title = "Memutar Musik", Content = songName .. " (" .. songId .. ")", Duration = 2.5 })
end

local function stopMusic()
    isPlaylistActive = false
    currentSound:Stop()
    WindUI:Notify({ Title = "Pemutar Musik", Content = "Musik dihentikan.", Duration = 2 })
end

currentSound.Ended:Connect(function()
    if isPlaylistActive then
        currentPlaylistIndex = currentPlaylistIndex + 1
        if currentPlaylistIndex > #songList then
            currentPlaylistIndex = 1
        end
        local nextSong = songList[currentPlaylistIndex]
        playMusic(nextSong.id, nextSong.name)
    end
end)

--------------------------------------------------
-- FUNGSI GANTI SKY / CLOUDS
--------------------------------------------------
local function setCustomSky(assetId, name)
    pcall(function()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then
                v:Destroy()
            end
        end
        
        local newSky = Instance.new("Sky")
        newSky.Name = "FOG_CustomSky"
        newSky.SkyboxBk = "rbxassetid://" .. tostring(assetId)
        newSky.SkyboxDn = "rbxassetid://" .. tostring(assetId)
        newSky.SkyboxFt = "rbxassetid://" .. tostring(assetId)
        newSky.SkyboxLf = "rbxassetid://" .. tostring(assetId)
        newSky.SkyboxRt = "rbxassetid://" .. tostring(assetId)
        newSky.SkyboxUp = "rbxassetid://" .. tostring(assetId)
        newSky.Parent = Lighting
        
        WindUI:Notify({ Title = "Change Sky", Content = "Berhasil mengubah langit ke " .. name, Duration = 2.5 })
    end)
end

--------------------------------------------------
-- TAB 1: DASHBOARD (PROFIL & JAM DUNIA)
--------------------------------------------------
local DashboardTab = Window:Tab({
    Title = "Dashboard",
    Icon = "layout-dashboard",
})

local InfoSection = DashboardTab:Section({
    Title = "Informasi Akun",
    Opened = true,
})

InfoSection:Paragraph({
    Title = LocalPlayer.Name .. " (" .. LocalPlayer.DisplayName .. ")",
    Content = "User ID: " .. LocalPlayer.UserId .. "\nStatus: Terhubung",
    Image = thumbnail,
    ImageSize = 48,
})

local ClockSection = DashboardTab:Section({
    Title = "Jam Dunia",
    Opened = true,
})

local ClockParagraph = ClockSection:Paragraph({
    Title = "Waktu Real-Time",
    Content = "Memuat waktu...",
})

task.spawn(function()
    while true do
        local dateWIB = os.date("!*t")
        local hourWIB = (dateWIB.hour + 7) % 24
        local timeStringWIB = string.format("%02d:%02d:%02d", hourWIB, dateWIB.min, dateWIB.sec)
        local dateString = os.date("%A, %d %B %Y")

        ClockParagraph:SetDesc(
            "Tanggal: " .. dateString .. "\n" ..
            "WIB: " .. timeStringWIB .. " | UTC: " .. os.date("%H:%M:%S")
        )
        task.wait(1)
    end
end)

--------------------------------------------------
-- TAB 2: MAINKAN (PLAYER CONTROLS)
--------------------------------------------------
local MainkanTab = Window:Tab({
    Title = "Mainkan",
    Icon = "play",
})

local PlayerSection = MainkanTab:Section({
    Title = "Kontrol Pemutar",
    Opened = true,
})

PlayerSection:Button({
    Title = "Putar Lagu Pertama",
    Description = "Mulai putar dari daftar lagu",
    Callback = function()
        isPlaylistActive = false
        playMusic(songList[1].id, songList[1].name)
    end,
})

PlayerSection:Button({
    Title = "Hentikan Musik (Stop)",
    Description = "Matikan audio yang sedang berjalan",
    Callback = stopMusic,
})

--------------------------------------------------
-- TAB 3: JELAJAHI (BROWSE ALL SONGS)
--------------------------------------------------
local JelajahiTab = Window:Tab({
    Title = "Jelajahi",
    Icon = "list",
})

local BrowseSection = JelajahiTab:Section({
    Title = "Daftar Seluruh Lagu",
    Opened = true,
})

for _, song in ipairs(songList) do
    BrowseSection:Button({
        Title = song.name,
        Description = "ID: " .. song.id, -- Diperbaiki dari error tanda '+' sebelumnya
        Callback = function()
            isPlaylistActive = false
            playMusic(song.id, song.name)
        end,
    })
end

--------------------------------------------------
-- TAB 4: FAVORIT (AUTO-NEXT PLAYLIST)
--------------------------------------------------
local FavoritTab = Window:Tab({
    Title = "Favorit",
    Icon = "heart",
})

local FavSection = FavoritTab:Section({
    Title = "Daftar Putar Favorit (Auto-Next)",
    Opened = true,
})

FavSection:Button({
    Title = "Putar Semua (Auto-Next Beruntun)",
    Description = "Memutar lagu dari awal dan otomatis lanjut ke lagu berikutnya saat selesai",
    Callback = function()
        isPlaylistActive = true
        currentPlaylistIndex = 1
        playMusic(songList[1].id, songList[1].name)
        WindUI:Notify({ Title = "Playlist Aktif", Content = "Auto-Next Beruntun Dinyalakan", Duration = 3 })
    end,
})

FavSection:Button({
    Title = "Matikan Playlist",
    Description = "Hentikan mode putar otomatis",
    Callback = stopMusic,
})

for _, song in ipairs(songList) do
    FavSection:Button({
        Title = song.name,
        Description = "ID: " .. song.id,
        Callback = function()
            isPlaylistActive = false
            playMusic(song.id, song.name)
        end,
    })
end

--------------------------------------------------
-- TAB 5: CHANGE CLOUDS / SKY
--------------------------------------------------
local CloudTab = Window:Tab({
    Title = "Change Clouds",
    Icon = "cloud",
})

local CloudSection = CloudTab:Section({
    Title = "Pengaturan Langit & Awan (Custom Sky)",
    Opened = true,
})

CloudSection:Button({
    Title = "Ganti Langit - Pilihan 1",
    Description = "ID: 17077940527",
    Callback = function()
        setCustomSky("17077940527", "Sky 1")
    end,
})

CloudSection:Button({
    Title = "Ganti Langit - Pilihan 2",
    Description = "ID: 14703430232",
    Callback = function()
        setCustomSky("14703430232", "Sky 2")
    end,
})

Window:SelectTab(1)
