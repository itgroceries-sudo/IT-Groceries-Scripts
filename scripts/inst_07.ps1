$ErrorActionPreference = 'Stop'

try {
    # 1. กำหนดค่า (Zoom ลิงก์ตรงถาวร)
    $url = "https://zoom.us/client/latest/ZoomInstaller.exe"
    $dest = "$env:TEMP\zoom_setup.exe"  # ใช้ $env:TEMP แทน %TEMP%

    # 2. ดาวน์โหลด
    Write-Host "[ CLOUD ] Downloading Zoom..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $dest

    # 3. ติดตั้ง
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        
        # Zoom ต้องใช้ ArgumentList สำหรับพารามิเตอร์ /silent
        Start-Process -FilePath $dest -ArgumentList "/silent", "/install" -Wait
        
        # 4. ลบไฟล์ทิ้ง
        Remove-Item $dest -Force
        
        # ส่งรหัส 0 (สำเร็จ)
        exit 0
    } else {
        throw "Download failed."
    }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    # ส่งรหัส 1 (ล้มเหลว)
    exit 1
}
