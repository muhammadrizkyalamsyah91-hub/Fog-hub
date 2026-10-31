--================================================--
--    CUSTOM UI UPDATE BOX - SAFE PERSISTENT TIMER  --
--================================================--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Hapus UI lama jika ada agar tidak menumpuk
if PlayerGui:FindFirstChild("FOG_UpdateUI") then
    PlayerGui.FOG_UpdateUI:Destroy()
end

-- ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FOG_UpdateUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Kotak Utama (Frame)
local MainBox = Instance.new("Frame")
MainBox.Name = "UpdateBox"
MainBox.Size = UDim2.new(0, 320, 0, 150)
MainBox.Position = UDim2.new(0.5, -160, 0.5, -75)
MainBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainBox.BorderSizePixel = 0
MainBox.Parent = ScreenGui

-- Efek Sudut Melengkung (UICorner)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainBox

-- Garis Pinggir Kotak (UIStroke)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(168, 85, 247)
UIStroke.Thickness = 2
UIStroke.Parent = MainBox

-- Judul / Header Teks
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "UPDATE FOG HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Parent = MainBox

-- Garis Pembatas Header
local Line = Instance.new("Frame")
Line.Size = UDim2.new(0.9, 0, 0, 1)
Line.Position = UDim2.new(0.05, 0, 0, 40)
Line.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Line.BorderSizePixel = 0
Line.Parent = MainBox

-- Detail Informasi (Pembuat & Waktu Mundur)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0.9, 0, 0, 55)
InfoLabel.Position = UDim2.new(0.05, 0, 0, 50)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "Memuat waktu..."
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextSize = 13
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.Parent = MainBox

-- Tombol Tutup (Close Button)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.8, 0, 0, 30)
CloseButton.Position = UDim2.new(0.1, 0, 0, 110)
CloseButton.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "TUTUP"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 13
CloseButton.Parent = MainBox

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = CloseButton

-- Menggunakan Registry agar waktu terkunci dan tidak kereset saat re-execute
if not _G.FOG_GlobalTargetTime then
    -- Set target awal: 1 hari (86400 detik) + 2 menit (120 detik) dari sekarang
    _G.FOG_GlobalTargetTime = os.time() + 86400 + 120
end

-- Fungsi Timer Mundur (Countdown)
task.spawn(function()
    while MainBox and MainBox.Parent do
        local remaining = _G.FOG_GlobalTargetTime - os.time()
        
        if remaining < 0 then
            remaining = 0
        end
        
        local days = math.floor(remaining / 86400)
        local hours = math.floor((remaining % 86400) / 3600)
        local minutes = math.floor((remaining % 3600) / 60)
        local seconds = remaining % 60
        
        InfoLabel.Text = string.format("Pembuat: swa_robloxc\nWaktu tersisa: %d day %d min %d sec", days, minutes, seconds)
        
        task.wait(1)
    end
end)

-- Fungsi Klik Tombol Tutup
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
