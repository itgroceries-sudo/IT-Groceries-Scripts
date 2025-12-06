# =========================================================
#  FILE: inst_09.ps1 (LINE PC - 7-Zip Unpack Strategy)
#  Description: Uses 7-Zip to extract the inner installer directly
# =========================================================
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$url = "https://desktop.line-scdn.net/win/new/LineInst.exe"
$fileName = "LineInst.exe"
$dest = "$env:TEMP\$fileName"
$extractDir = "$env:TEMP\Line_Extract"

# เช็คว่ามี 7-Zip ไหม (ใช้ตัว 64bit หรือ 32bit ก็ได้)
$7z = "$env:ProgramFiles\7-Zip\7z.exe"
if (-not (Test-Path $7z)) { $7z = "${env:ProgramFiles(x86)}\7-Zip\7z.exe" }

if (-not (Test-Path $7z)) {
    Write-Host "[ ERROR ] 7-Zip is required for LINE installation." -ForegroundColor Red
    Write-Host "Please install 7-Zip (Menu 01) first!" -ForegroundColor Yellow
    exit 1
}

try {
    # 1. Download
    Write-Host "[ CLOUD ] Downloading LINE PC..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

    if (Test-Path $dest) {
        # 2. Extract using 7-Zip (แกะไส้ในออกมา)
        Write-Host "[ LINE ] Extracting installer..." -ForegroundColor Yellow
        if (Test-Path $extractDir) { Remove-Item $extractDir -Recurse -Force }
        
        # สั่ง 7z แตกไฟล์ไปที่โฟลเดอร์ชั่วคราว
        & $7z x "$dest" "-o$extractDir" -y | Out-Null

        # 3. Find Inner Installer (หาไฟล์ .exe ตัวจริงข้างใน)
        # ปกติ LINE จะซ่อนตัวจริงไว้ชื่อประมาณ LineInst_xxxx.exe หรืออยู่ในโฟลเดอร์ย่อย
        $realInstaller = Get-ChildItem "$extractDir\LineInst_*.exe" -Recurse | Select-Object -First 1
        
        if (-not $realInstaller) {
            # ถ้าไม่เจอชื่อ LineInst_*.exe ให้ลองหา .exe ที่ใหญ่ที่สุดในนั้น
            $realInstaller = Get-ChildItem "$extractDir\*.exe" -Recurse | Sort-Object Length -Descending | Select-Object -First 1
        }

        # 4. Install
        if ($realInstaller) {
            Write-Host "[ LINE ] Installing real setup: $($realInstaller.Name)" -ForegroundColor Cyan
            
            # สั่งรันตัวจริงด้วย /S (Silent)
            $proc = Start-Process -FilePath $realInstaller.FullName -ArgumentList "/S" -Wait -PassThru
            
            if ($proc.ExitCode -eq 0) {
                Write-Host "[ SUCCESS ] LINE PC Installed." -ForegroundColor Green
            } else {
                throw "Installation Failed (Code: $($proc.ExitCode))"
            }
        } else {
            throw "Could not find installer inside the package."
        }

        # 5. Cleanup
        Remove-Item $dest -Force -ErrorAction SilentlyContinue
        Remove-Item $extractDir -Recurse -Force -ErrorAction SilentlyContinue

    } else {
        throw "Download Failed"
    }

} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
