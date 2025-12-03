$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Downloading Acrobat Reader..." -ForegroundColor Cyan
    # แก้ไข: ใช้ลิงก์ FTP ของ Adobe (เวอร์ชันล่าสุดเสมอ)
    $url = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2400420272/AcroRdrDC2400420272_en_US.exe"
    # หมายเหตุ: Adobe ชอบเปลี่ยนเลข Build ใน URL ถ้าลิงก์นี้ตายอีก แนะนำให้ใช้ Chocolatey Script แทนครับ
    
    $dest = "$env:TEMP\acrobat_setup.exe"
    if (Test-Path $dest) { Remove-Item $dest -Force }
    
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
