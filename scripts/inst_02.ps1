$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    # --- Config ---
    # ใช้ลิงก์ Standalone (ตัวเต็ม) เพื่อให้ Aria2 โหลดได้เต็มประสิทธิภาพ
    $url = "https://dl.google.com/chrome/install/standalonesetup64.exe"
    $fileName = "ChromeSetup_Full.exe"
    $dest = "$env:TEMP\$fileName"
    $aria2 = "$env:TEMP\aria2c.exe"

    # ลบไฟล์เก่าทิ้งก่อน (กัน Aria2 งง)
    if (Test-Path $dest) { Remove-Item $dest -Force }

    Write-Host "[ CLOUD ] Preparing Google Chrome..." -ForegroundColor Cyan

    # --- HYBRID DOWNLOAD ENGINE ---
    if ($env:UseAria2 -eq "1" -and (Test-Path $aria2)) {
        # [ Mode: ARIA2 Turbo ]
        Write-Host ">> Engaged Aria2 High-Speed Download (16 Connections)..." -ForegroundColor Yellow
        # -x16 = 16 connections, -s16 = split to 16 pieces, -j1 = 1 download at a time
        # -d = directory, -o = filename
        & $aria2 -x 16 -s 16 -j 1 -d "$env:TEMP" -o "$fileName" $url
    } else {
        # [ Mode: Standard ]
        Write-Host ">> Standard Download (Invoke-WebRequest)..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $url -OutFile $dest
    }

    # --- INSTALLATION ---
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        
        # Chrome Standalone Silent Install
        $proc = Start-Process -FilePath $dest -ArgumentList "/silent", "/install" -Wait -PassThru
        
        # Cleanup
        Remove-Item $dest -Force
        
        if ($proc.ExitCode -eq 0) { exit 0 } else { throw "Install failed with code $($proc.ExitCode)" }
    } else { 
        throw "Download failed (File not found)." 
    }

} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
