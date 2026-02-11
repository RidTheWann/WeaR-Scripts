# WeaR-Scripts

Script untuk game Roblox dengan berbagai fitur universal dan khusus Fish It!

## 🚀 Cara Menggunakan (Seperti Chloe X)

### Universal Script (Semua Game)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/RidTheWann/WeaR-Scripts/main/gui.lua"))()
```

### Fish It! Script (Khusus Fish It!)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/RidTheWann/WeaR-Scripts/main/gui-fishit.lua"))()
```

## 📋 Setup untuk Developer

### 1. Upload ke GitHub
1. Buat repository baru di GitHub (nama: `WeaR-Scripts`)
2. Upload semua file dari folder ini
3. Pastikan repository bersifat **Public**

### 2. Ganti URL
Setelah upload, ganti `YOUR-USERNAME` dengan username GitHub Anda di:
- `loader.lua`
- `README.md` (file ini)

### 3. Share ke Pengguna
Berikan loader script ini ke pengguna:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/RidTheWann/WeaR-Scripts/main/gui-fishit.lua"))()
```

## ⚡ Fitur Universal

- **WalkSpeed**: Mengubah kecepatan berjalan
- **JumpPower**: Mengubah kekuatan lompat
- **Fly**: Mode terbang (WASD)
- **Noclip**: Menembus dinding
- **ESP**: Melihat pemain lain melalui dinding
- **Infinite Jump**: Lompat tanpa batas

## 🎣 Fitur Fish It!

### Normal Features
- **Auto Fish**: Otomatis memancing dan reel
- **Auto Shake**: Otomatis shake saat mancing
- **Auto Catch**: Otomatis catch ikan
- **Auto Sell**: Otomatis jual ikan
- **Auto Equip Best Rod**: Otomatis equip rod terbaik
- **TP to Fish Zone**: Teleport ke zona mancing

### Blatant Features (HIGH RISK!)
- **Insta-Catch**: Langsung dapat ikan tanpa minigame (blatant)
- **Auto Farm Blatant**: Farming super cepat tanpa jeda (blatant)
- **Force Legendary**: Manipulasi peluang dapat ikan langka (blatant)
- **TP to Rare Spots**: Teleport ke lokasi ikan langka (blatant)

### Misc
- **Anti-AFK**: Mencegah kick karena AFK

## 📁 File-file

- `gui.lua` - GUI universal untuk semua game
- `gui-fishit.lua` - GUI khusus Fish It! dengan fitur blatant
- `main.lua` - Script core universal
- `fishit.lua` - Script core Fish It!
- `loader.lua` - Loader script dengan URL

## 🔧 Update Script

Jika Anda update script, pengguna tidak perlu download ulang! Mereka cukup execute loader yang sama, dan akan otomatis dapat versi terbaru.

## ⚠️ Catatan

- Script ini hanya berfungsi di game yang mengizinkan local scripts
- Fitur blatant berisiko tinggi kena ban
- Gunakan dengan bijak dan ikuti aturan game
- Untuk support, hubungi developer

## 📝 Version

**v1.0** - Initial Release
- Universal features
- Fish It! features
- Blatant features
- Modern UI with animations
