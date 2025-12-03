$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Downloading Discord..." -ForegroundColor Cyan
    $url = "https://discord.com/api/download?platform=win"
    $dest = "$env:TEMP\discord_setup.exe"
    
    # แก้ไข: ลบไฟล์เก่าทิ้งก่อนกันเหนียว (Fix Access Denied)
    if (Test-Path $dest) { Remove-Item $dest -Force }
    
    Invoke-WebRequest -Uri $url -OutFile $dest
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath $dest -ArgumentList "-s" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "Download failed." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
