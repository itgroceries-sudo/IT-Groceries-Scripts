$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Downloading GIMP..." -ForegroundColor Cyan
    # GIMP ลิงก์มักเปลี่ยนบ่อย อันนี้เป็นตัว Stable ปัจจุบัน
    $url = "https://download.gimp.org/gimp/v2.10/windows/gimp-2.10.38-setup.exe"
    $dest = "$env:TEMP\gimp_setup.exe"
    
    Invoke-WebRequest -Uri $url -OutFile $dest
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath $dest -ArgumentList "/VERYSILENT /NORESTART" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "Download failed." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
