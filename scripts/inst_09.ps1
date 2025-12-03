$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    # 1. สร้างโฟลเดอร์ชั่วคราว
    $workDir = "$env:TEMP\LINE_Install_$((Get-Random))"
    New-Item -ItemType Directory -Path $workDir -Force | Out-Null
    
    Write-Host "[ CLOUD ] Downloading LINE PC..." -ForegroundColor Cyan
    $lineUrl = "https://desktop.line-scdn.net/win/new/LineInst.exe"
    $lineExe = "$workDir\LineInst.exe"
    Invoke-WebRequest -Uri $lineUrl -OutFile $lineExe
    
    # 2. โหลด 7zr.exe (ตัวแตกไฟล์ขนาดเล็ก) เพื่อมาผ่า LINE
    Write-Host "[ CLOUD ] Fetching Extractor..." -ForegroundColor Yellow
    $7zUrl = "https://www.7-zip.org/a/7zr.exe"
    $7zExe = "$workDir\7zr.exe"
    Invoke-WebRequest -Uri $7zUrl -OutFile $7zExe
    
    # 3. สั่งแตกไฟล์ LINE หาไส้ใน (.msi)
    Write-Host "[ CLOUD ] Extracting MSI..." -ForegroundColor Yellow
    # ใช้ 7zr แตกไฟล์ LineInst.exe ไปที่โฟลเดอร์ MSI
    $proc = Start-Process -FilePath $7zExe -ArgumentList "x `"$lineExe`" -o`"$workDir\MSI`" -y" -Wait -PassThru
    
    # 4. หาไฟล์ .msi ที่แตกออกมา (ชื่ออาจเปลี่ยนไปตามเวอร์ชัน เลยต้องสั่งหา)
    $msiFile = Get-ChildItem -Path "$workDir\MSI" -Filter "*.msi" -Recurse | Select-Object -First 1
    
    if ($msiFile) {
        Write-Host "[ CLOUD ] Installing $($msiFile.Name)..." -ForegroundColor Green
        
        # 5. สั่งติดตั้ง MSI แบบเงียบกริบ (/qn)
        $procInstall = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$($msiFile.FullName)`" /qn /norestart" -Wait -PassThru
        
        if ($procInstall.ExitCode -eq 0) {
            # สั่งปิด LINE ที่อาจจะเด้งขึ้นมาเอง
            Start-Sleep -Seconds 5
            Stop-Process -Name "Line" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "LineInst" -Force -ErrorAction SilentlyContinue
            
            # ล้างบาง
            Remove-Item $workDir -Recurse -Force
            exit 0
        } else { throw "MSI Installation failed code: $($procInstall.ExitCode)" }
        
    } else { throw "MSI file not found inside installer." }

} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    # พยายามลบไฟล์ขยะแม้จะ Error
    if (Test-Path $workDir) { Remove-Item $workDir -Recurse -Force }
    exit 1
}
