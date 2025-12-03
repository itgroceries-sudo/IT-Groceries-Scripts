$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Downloading Google Chrome (Online Installer)..." -ForegroundColor Cyan
    
    # ใช้ลิงก์ตรงสำหรับตัว Stub Installer (Online) ขนาดเล็ก
    $url = "https://dl.google.com/chrome/install/ChromeSetup.exe"
    $dest = "$env:TEMP\ChromeSetup.exe"
    
    # ถ้ามีไฟล์เก่าค้าง ให้ลบทิ้งก่อน
    if (Test-Path $dest) { Remove-Item $dest -Force }
    
    Invoke-WebRequest -Uri $url -OutFile $dest
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        # สั่งรันแบบเงียบ (มันจะโหลดไฟล์ต่อเองเบื้องหลัง)
        Start-Process -FilePath $dest -ArgumentList "/silent", "/install" -Wait
        
        Remove-Item $dest -Force
        exit 0
    } else { throw "Download failed." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
