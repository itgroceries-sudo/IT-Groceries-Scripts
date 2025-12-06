# =========================================================
#  FILE: inst_09.ps1 (LINE PC - Custom Logic)
#  Description: Unpacks the wrapper to find the real installer
# =========================================================
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$url = "https://desktop.line-scdn.net/win/new/LineInst.exe"
$wrapperFile = "$env:TEMP\LineInst_Wrapper.exe"

try {
    # 1. Download Wrapper (ตัวเปลือก)
    Write-Host "[ CLOUD ] Downloading LINE Wrapper..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $wrapperFile -UseBasicParsing

    if (Test-Path $wrapperFile) {
        # 2. Run Wrapper to Extract (รันเพื่อให้มันคายไฟล์ออกมา)
        Write-Host "[ LINE ] Extracting real installer..." -ForegroundColor Yellow
        $wrapperProc = Start-Process -FilePath $wrapperFile -PassThru

        # 3. Loop Check: รอจนกว่าจะเจอไฟล์ LineInst_*.exe ใน Temp
        $maxRetries = 30  # รอสูงสุด 30 วินาที
        $realInstaller = $null
        
        for ($i=0; $i -lt $maxRetries; $i++) {
            Start-Sleep 1
            # ค้นหาไฟล์ที่ชื่อขึ้นต้นด้วย LineInst_ และลงท้ายด้วย .exe (เอาตัวใหม่ล่าสุด)
            $realInstaller = Get-ChildItem "$env:TEMP\LineInst_*.exe" | Sort-Object CreationTime -Descending | Select-Object -First 1
            
            if ($realInstaller) {
                # เจอแล้ว! หยุด Loop
                break
            }
        }

        # 4. Kill Wrapper (ฆ่าตัวเปลือกทิ้ง เพราะเราได้ไส้ในแล้ว)
        if (-not $wrapperProc.HasExited) {
            Stop-Process -Id $wrapperProc.Id -Force -ErrorAction SilentlyContinue
        }

        # 5. Run Real Installer (ติดตั้งตัวจริงแบบ Silent)
        if ($realInstaller) {
            Write-Host "[ LINE ] Found: $($realInstaller.Name)" -ForegroundColor Cyan
            Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
            
            # สั่งรันตัวจริงด้วย /S
            $proc = Start-Process -FilePath $realInstaller.FullName -ArgumentList "/S" -Wait -PassThru
            
            if ($proc.ExitCode -eq 0) {
                Write-Host "[ SUCCESS ] LINE PC Installed." -ForegroundColor Green
                
                # Cleanup (ลบทั้งตัวเปลือกและตัวจริง)
                Remove-Item $wrapperFile -Force -ErrorAction SilentlyContinue
                Remove-Item $realInstaller.FullName -Force -ErrorAction SilentlyContinue
            } else {
                throw "Installation Failed (Exit Code: $($proc.ExitCode))"
            }
        } else {
            throw "Could not extract LineInst_*.exe (Time out)"
        }
    } else {
        throw "Download Failed"
    }

} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
