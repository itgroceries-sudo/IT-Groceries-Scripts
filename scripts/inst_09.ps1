# =========================================================
#  FILE: inst_09.ps1 (LINE PC - GDrive Zip Method)
# =========================================================
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# [CONFIG] เอา ID จากลิงก์ Google Drive มาใส่ตรงนี้
$GDriveID = "1XG5PH3WWBaNRKLvDYkigPo3b6hyktUwW" 

# สร้างลิงก์ดาวน์โหลดตรง (Direct Link)
$url = "https://drive.google.com/uc?export=download&id=$GDriveID"
$zipFile = "$env:TEMP\LineSetup.zip"
$extractDir = "$env:TEMP\Line_Extract"

try {
    # 1. Download ZIP
    Write-Host "[ CLOUD ] Downloading LINE form GDrive..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $zipFile -UseBasicParsing

    if (Test-Path $zipFile) {
        # 2. Extract
        Write-Host "[ LINE ] Extracting..." -ForegroundColor Yellow
        if (Test-Path $extractDir) { Remove-Item $extractDir -Recurse -Force }
        Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force

        # 3. Find Installer (หาไฟล์ .exe ที่แกะออกมา)
        $realInstaller = Get-ChildItem "$extractDir\*.exe" -Recurse | Select-Object -First 1
        
        if ($realInstaller) {
            Write-Host "[ LINE ] Installing: $($realInstaller.Name)" -ForegroundColor Cyan
            
            # 4. Install & Watchdog (สูตรแก้ค้าง)
            $proc = Start-Process -FilePath $realInstaller.FullName -ArgumentList "/S" -PassThru
            
            $timeout = 0
            while (-not $proc.HasExited) {
                Start-Sleep -Seconds 2
                $timeout++
                
                # ถ้า LINE เด้งขึ้นมา แสดงว่าเสร็จแล้ว -> ฆ่าทิ้ง
                $lineApp = Get-Process "LINE" -ErrorAction SilentlyContinue
                if ($lineApp) {
                    Write-Host "[ FIX ] Killing Auto-Start LINE..." -ForegroundColor Magenta
                    $lineApp | Stop-Process -Force -ErrorAction SilentlyContinue
                    # ฆ่าตัวติดตั้งด้วยเพื่อให้จบงาน
                    $proc | Stop-Process -Force -ErrorAction SilentlyContinue
                    break
                }
                
                # Timeout 3 นาที
                if ($timeout -ge 90) { $proc | Stop-Process -Force; break }
            }

            # 5. Cleanup
            Write-Host "[ SUCCESS ] LINE PC Installed." -ForegroundColor Green
            Remove-Item $zipFile -Force -ErrorAction SilentlyContinue
            Remove-Item $extractDir -Recurse -Force -ErrorAction SilentlyContinue
            
        } else {
            throw "Installer not found in ZIP."
        }
    } else {
        throw "Download Failed (Check GDrive Link)."
    }

} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
