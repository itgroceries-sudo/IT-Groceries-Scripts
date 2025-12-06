# =========================================================
#  FILE: Master.ps1 (The Engine v3.0 - Smart Download)
# =========================================================
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# รับตัวแปร: $url, $fileName, $installArgs
$dest = "$env:TEMP\$fileName"
$aria2 = "$env:TEMP\aria2c.exe"

try {
    # ---------------------------------------------------------
    # 1. DOWNLOAD PHASE (Smart Logic: 16 -> 8 -> IWR)
    # ---------------------------------------------------------
    Write-Host "[ CLOUD ] Downloading $fileName..." -ForegroundColor Cyan
    
    # ถ้ามี Aria2 ให้เริ่มกระบวนการ Turbo
    if ($env:UseAria2 -eq "1" -and (Test-Path $aria2)) { 
        
        # [Step 1] ลองโหลดแบบเต็มสูบ (16 Connections)
        Write-Host "   >> Attempt 1: High Speed (16 Connections)..." -NoNewline -ForegroundColor Gray
        & $aria2 -x 16 -s 16 -j 1 --check-certificate=false -d "$env:TEMP" -o "$fileName" $url *>$null
        
        # ตรวจสอบผลลัพธ์
        if ($LASTEXITCODE -eq 0 -and (Test-Path $dest)) {
            Write-Host " [ OK ]" -ForegroundColor Green
        } else {
            # [Step 2] ถ้าพลาด ให้ลองลดสปีดลง (8 Connections)
            Write-Host " [ FAIL ]" -ForegroundColor Red
            Write-Host "   >> Attempt 2: Standard Speed (8 Connections)..." -NoNewline -ForegroundColor Yellow
            
            # ลบไฟล์ขยะที่โหลดไม่เสร็จทิ้งก่อน
            if (Test-Path $dest) { Remove-Item $dest -Force }
            if (Test-Path "$dest.aria2") { Remove-Item "$dest.aria2" -Force }

            & $aria2 -x 8 -s 8 -j 1 --check-certificate=false -d "$env:TEMP" -o "$fileName" $url *>$null
            
            if ($LASTEXITCODE -eq 0 -and (Test-Path $dest)) {
                Write-Host " [ OK ]" -ForegroundColor Green
            } else {
                # [Step 3] ถ้ายังไม่ได้อีก ให้ยอมแพ้แล้วใช้ตัวโหลดของ Windows
                Write-Host " [ FAIL ]" -ForegroundColor Red
                throw "Aria2 Failed. Switching to Basic Download."
            }
        }

    } else {
        # ถ้าไม่มี Aria2 ตั้งแต่ต้น ให้ข้ามไปใช้ Basic เลย
        throw "Aria2 not found. Using Basic Download."
    }

} catch {
    # [Step 4] (Last Resort) ใช้ Invoke-WebRequest (ช้าแต่ชัวร์)
    Write-Host "   >> Attempt 3: Basic Download (Invoke-WebRequest)..." -ForegroundColor Magenta
    try {
        if (Test-Path $dest) { Remove-Item $dest -Force }
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    } catch {
        Write-Host "[ FATAL ERROR ] Download Failed Completely." -ForegroundColor Red
        exit 1
    }
}

try {
    # ---------------------------------------------------------
    # 2. INSTALL PHASE
    # ---------------------------------------------------------
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        
        if ($dest -like "*.msi") {
            $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$dest`" $installArgs" -Wait -PassThru
        } else {
            $proc = Start-Process -FilePath $dest -ArgumentList $installArgs -Wait -PassThru
        }
        
        # ---------------------------------------------------------
        # 3. VERIFY RESULT
        # ---------------------------------------------------------
        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) { 
            Write-Host "[ SUCCESS ] Installation Complete." -ForegroundColor Green
        } else { 
            Write-Host "[ WARN ] Installer Exit Code: $($proc.ExitCode)" -ForegroundColor Yellow
        }
    } else {
        throw "File not found after download process."
    }

} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1

} finally {
    # ---------------------------------------------------------
    # 4. CLEANUP PHASE (ลบไฟล์ 100%)
    # ---------------------------------------------------------
    if (Test-Path $dest) {
        Write-Host "[ CLEANUP ] Removing installer..." -ForegroundColor Gray
        for ($i=1; $i -le 3; $i++) {
            try { Remove-Item $dest -Force -ErrorAction Stop; break } 
            catch { Start-Sleep 2 }
        }
    }
}
