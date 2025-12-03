$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Downloading LINE PC..." -ForegroundColor Cyan
    $url = "https://desktop.line-scdn.net/win/new/LineInst.exe"
    $dest = "$env:TEMP\LineInst.exe"
    
    # ลบไฟล์เก่าถ้ามี
    if (Test-Path $dest) { Remove-Item $dest -Force }
    
    Invoke-WebRequest -Uri $url -OutFile $dest
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        # /S ตัวใหญ่สำหรับ NSIS
        $proc = Start-Process -FilePath $dest -ArgumentList "/S" -PassThru
        $proc.WaitForExit()
        
        # รอสักพักแล้วสั่ง Kill Process เพราะ LINE ชอบเด้งออโต้
        Start-Sleep -Seconds 5
        Stop-Process -Name "Line" -Force -ErrorAction SilentlyContinue
        Stop-Process -Name "LineInst" -Force -ErrorAction SilentlyContinue
        
        Remove-Item $dest -Force
        exit 0
    } else { throw "Download failed." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
