
# WeaR-Scripts

WeaR-Scripts adalah kumpulan skrip lokal (local scripts) untuk executor Roblox. Paket ini menyatukan fitur-fitur universal (movement, fly, ESP) dan modul khusus untuk game "Fish It!" — dirancang agar modular, mudah dikonfigurasi, dan cepat diadaptasi.

Repository resmi: https://github.com/RidTheWann/WeaR-Scripts

Catatan penting: beberapa fitur bersifat "blatant" (langsung memodifikasi perilaku game). Fitur tersebut sangat berisiko dan dapat menyebabkan akun dibanned. Aktifkan hanya jika Anda memahami risikonya.

---

## Ringkasan Fitur
- Universal: WalkSpeed, JumpPower, Fly (WASD), Noclip, ESP, Infinite Jump
- Fish It!: Auto Fish, Auto Shake, Auto Catch, Auto Sell, Auto Equip Best Rod, TP to Fish Zone
- Blatant (OPT-IN): Insta-Catch, Auto Farm (blatant), Force Legendary, TP to Rare Spots
- Misc: Anti-AFK, Notifikasi, Keybinds, dan penyimpanan konfigurasi (jika executor mendukung)

---

## Cara Instalasi
1. Buka executor Anda (mis. Synapse, Krnl, Fluxus — tergantung dukungan fitur).
2. Anda dapat memuat GUI langsung dari repository resmi dengan salah satu perintah berikut:

```lua
-- GUI Universal (dari repository resmi)
loadstring(game:HttpGet("https://raw.githubusercontent.com/RidTheWann/WeaR-Scripts/main/gui.lua"))()

-- GUI Khusus Fish It! (jalankan saat berada di game Fish It!)
loadstring(game:HttpGet("https://raw.githubusercontent.com/RidTheWann/WeaR-Scripts/main/gui-fishit.lua"))()
```

3. Alternatif: jalankan `loader.lua` langsung jika Anda menggunakan repository lokal atau ingin sebuah entrypoint yang menjelaskan opsi.

Catatan: jika Anda memindahkan file ke repository lain, ganti hostname/path pada URL di atas sesuai lokasi baru.

---

## Penggunaan & Konfigurasi
- UI dirancang modular: setiap tombol mengaktifkan/menonaktifkan fitur.
- Fitur blatant berlabel jelas di UI dengan peringatan warna merah — selalu pilih "Enable Blatant Module" secara eksplisit.
- Beberapa fitur (contoh: AutoSell, AutoEquip) memiliki pengecekan aman dan debounce internal untuk mencegah spam remote.

Keybinds umum (bawaan):
- `Fly toggle` — di-aktifkan lewat UI (gunakan W/A/S/D untuk kontrol saat terbang)
- `Toggle GUI` — disediakan oleh executor (opsional)

Jika executor Anda mendukung fungsi file I/O (`writefile`, `readfile`), skrip dapat menyimpan konfigurasi lokal secara otomatis. Contoh (opsional, executor-specific):

```lua
-- Pseudocode penyimpanan konfigurasi (gunakan only jika executor mendukung)
local HttpService = game:GetService("HttpService")
local configFile = "WeaR-config.json"
local config = { AutoFish = false, AutoSell = true }
if writefile and readfile then
    writefile(configFile, HttpService:JSONEncode(config))
end
```

---

## Tentang Modul Blatant (Penting)
Fitur-fitur berikut dianggap blatant:

- Insta-Catch: Memanggil remote events untuk melewati minigame.
- Auto Farm Blatant: Mengulangi siklus cast/shake/reel tanpa jeda.
- Force Legendary: Mengubah nilai internal (luck/cooldown) pada tool.

Peringatan: Mengaktifkan modul ini meningkatkan risiko deteksi. Skrip menyediakan opsi "Enable Blatant Module" dan memperlihatkan peringatan saat diaktifkan. Gunakan dengan akun cadangan jika memungkinkan.

---

## Troubleshooting
- Jika GUI tidak muncul: pastikan `PlayerGui` tersedia dan Anda menjalankan script dari executor dengan akses lokal.
- Jika fitur remote error: periksa apakah game menggunakan nama remote yang berbeda. Anda bisa menyesuaikan fungsi di `fishit.lua` dengan nama remote yang tepat.
- Jika script crash: buka console executor untuk melihat error; kebanyakan perbaikan hanya membutuhkan pengecekan `pcall` atau nama objek yang berbeda.

---

## Kontribusi
Ingin menambah fitur atau memperbaiki bug? Silakan fork repository, buat branch, dan kirim pull request. Sertakan deskripsi singkat perubahan dan alasan.

---

## Lisensi & Etika
Skrip ini disediakan "as-is" untuk tujuan pembelajaran dan eksperimen. Penggunaan untuk cheating di server publik memiliki konsekuensi — gunakan secara bertanggung jawab.

---

Terima kasih telah menggunakan WeaR-Scripts. Jika Anda ingin, saya bisa lanjutkan dengan: hardening `fishit.lua`, menambahkan modul blatant opt-in, dan memperbarui `gui-fishit.lua` agar menyerupai Chloe-X (theme, persistence, profil). Beri tahu saya jika mau saya teruskan.
