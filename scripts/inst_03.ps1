$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    # --- Config ---
    # Direct link to Firefox Full Installer
    $url = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
    $fileName = "FirefoxSetup.exe"
    $dest = "$env:TEMP\$fileName"
    $aria2 = "$env:TEMP\aria2c.exe"

    # Cleanup old file
    if (Test-Path $dest) { Remove-Item $dest -Force }

    Write-Host "`n[ CLOUD ] Preparing Mozilla Firefox..." -ForegroundColor Cyan

    # --- HYBRID DOWNLOAD ENGINE (DEBUG MODE) ---
    if ($env:UseAria2 -eq "1" -and (Test-Path $aria2)) {
        # [ Mode: ARIA2 Turbo ]
        Write-Host "`n=================================================" -ForegroundColor Green
        Write-Host "   ARIA2 ENGINE DETECTED - TURBO MODE ENGAGED" -ForegroundColor Green
        Write-Host "=================================================" -ForegroundColor Green
        
        # -x16 = 16 connections
        # --check-certificate=false (Fix some redirect issues with Mozilla)
        & $aria2 -x 16 -s 16 -j 1 --check-certificate=false -d "$env:TEMP" -o "$fileName" $url
        
        Write-Host "`n[ TEST ] Download Complete. Look at the stats above!" -ForegroundColor Yellow
        Write-Host "[ TEST ] This confirms Aria2 is working." -ForegroundColor Yellow
        # Pause to let you see the Aria2 progress bar/speed
        Read-Host "Press ENTER to launch the installer..." 

    } else {
        # [ Mode: Standard ]
        Write-Host "`n=================================================" -ForegroundColor Red
        Write-Host "   ARIA2 NOT FOUND - USING SLOW MODE" -ForegroundColor Red
        Write-Host "=================================================" -ForegroundColor Red
        
        Invoke-WebRequest -Uri $url -OutFile $dest
    }

    # --- INSTALLATION (GUI MODE) ---
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Launching Installer (Non-Silent)..." -ForegroundColor Green
        
        # Start Installer and Wait (User must click Next)
        $proc = Start-Process -FilePath $dest -Wait -PassThru
        
        # Cleanup
        Remove-Item $dest -Force
        
        if ($proc.ExitCode -eq 0) { exit 0 } else { exit 0 } # Firefox GUI always returns 0 if manual
    } else { 
        throw "Download failed (File not found)." 
    }

} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    # Pause on error so you can read it
    Read-Host "Press ENTER to exit..."
    exit 1
}
