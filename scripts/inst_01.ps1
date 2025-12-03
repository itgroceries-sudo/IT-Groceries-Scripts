# ไฟล์: inst_01.ps1 (7-Zip Auto-Install)
$ErrorActionPreference = 'Stop'

try {
    Write-Host "[ CLOUD ] Checking latest 7-Zip version..." -ForegroundColor Cyan
    
    # 1. Scrape หาลิงก์
    $web = Invoke-WebRequest -Uri "https://www.7-zip.org/" -UseBasicParsing
    $link = $web.Links.href | Where-Object {$_ -match "-x64.exe"} | Select-Object -First 1
    
    if (-not $link) { throw "Download link not found." }
    
    $dlUrl = "https://www.7-zip.org/" + $link
    $dest = "$env:TEMP\7zip_setup.exe"
    
    # 2. ดาวน์โหลด
    Write-Host "[ CLOUD ] Downloading from $dlUrl" -ForegroundColor Yellow
    Invoke-WebRequest -Uri $dlUrl -OutFile $dest
    
    # 3. ติดตั้ง
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath $dest -ArgumentList "/S" -Wait
        
        # 4. ลบไฟล์ทิ้ง
        Remove-Item $dest -Force
        
        # ส่งรหัส 0 (สำเร็จ) กลับไปให้ Batch File
        exit 0
    } else {
        throw "File download failed."
    }

} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    # ส่งรหัส 1 (ล้มเหลว) กลับไปให้ Batch File
    exit 1
}
