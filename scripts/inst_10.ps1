$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Downloading Acrobat Reader..." -ForegroundColor Cyan
    # Link ตรงเวอร์ชันเสถียรล่าสุด
    $url = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2400420272/AcroRdrDC2400420272_en_US.exe"
    $dest = "$env:TEMP\acrobat_setup.exe"
    
    Invoke-WebRequest -Uri $url -OutFile $dest
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath $dest -ArgumentList "/sAll /rs /msi EULA_ACCEPT=YES" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "Download failed." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
