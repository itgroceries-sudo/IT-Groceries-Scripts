# =========================================================
#  FILE: Master.ps1 (The Engine v2.0 - Cleanup Fix)
# =========================================================
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ตัวแปรรับค่าจาก inst_xx.ps1: $url, $fileName, $installArgs

$dest = "$env:TEMP\$fileName"
$aria2 = "$env:TEMP\aria2c.exe"

try {
    # ---------------------------------------------------------
    # 1. DOWNLOAD PHASE
    # ---------------------------------------------------------
    Write-Host "[ CLOUD ] Downloading $fileName..." -ForegroundColor Cyan
    
    if ($env:UseAria2 -eq "1" -and (Test-Path $aria2)) { 
        # Aria2 Download
        & $aria2 -x 8 -s 8 -j 1 --check-certificate=false -d "$env:TEMP" -o "$fileName" $url 
        if ($LASTEXITCODE -ne 0) { throw "Aria2 Failed" }
    } else { 
        # Standard Download
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    }
    
    if (-not (Test-Path $dest)) { throw "Download Failed (File not found)" }

    # ---------------------------------------------------------
    # 2. INSTALL PHASE
    # ---------------------------------------------------------
    Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
    
    # แยก MSI กับ EXE
    if ($dest -like "*.msi") {
        $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$dest`" $installArgs" -Wait -PassThru
    } else {
        $proc = Start-Process -FilePath $dest -ArgumentList $installArgs -Wait -PassThru
    }
    
    # ---------------------------------------------------------
    # 3. VERIFY RESULT
    # ---------------------------------------------------------
    # เช็ค Exit Code (0 หรือ 3010 คือผ่าน)
    if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) { 
        Write-Host "[ SUCCESS ] Installation Complete." -ForegroundColor Green
    } else { 
        # แจ้งเตือน แต่ไม่หยุดการทำงาน เพื่อให้ไปถึงขั้นตอนลบไฟล์
        Write-Host "[ WARN ] Installer Exit Code: $($proc.ExitCode)" -ForegroundColor Yellow
    }

} catch {
    # จับ Error ระหว่างทาง (โหลดไม่ผ่าน/เน็ตหลุด)
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1

} finally {
    # ---------------------------------------------------------
    # 4. CLEANUP PHASE (ทำงานเสมอ 100% ไม่ว่าจะเกิดอะไรขึ้น)
    # ---------------------------------------------------------
    if (Test-Path $dest) {
        Write-Host "[ CLEANUP ] Removing installer..." -ForegroundColor Gray
        
        # ลองลบ 3 ครั้ง (เผื่อไฟล์ติด Lock)
        for ($i=1; $i -le 3; $i++) {
            try {
                Remove-Item $dest -Force -ErrorAction Stop
                break # ถ้าลบได้ ให้จบ Loop
            } catch {
                # ถ้าลบไม่ได้ (ติด Lock) ให้รอ 2 วินาทีแล้วลองใหม่
                Start-Sleep 2
            }
        }
    }
}
