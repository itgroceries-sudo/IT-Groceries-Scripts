$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Downloading Discord..." -ForegroundColor Cyan
    $url = "https://discord.com/api/download?platform=win"
    $dest = "$env:TEMP\discord_setup.exe"
    
    Invoke-WebRequest -Uri $url -OutFile $dest
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        # Discord installs silently by default but -s helps
        Start-Process -FilePath $dest -ArgumentList "-s" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "Download failed." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
