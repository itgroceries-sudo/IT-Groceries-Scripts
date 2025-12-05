# =========================================================
#  FILE: Master.ps1 (The Engine)
#  Description: Handles downloading and installing based on variables
# =========================================================
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    # 1. Setup Paths
    $dest = "$env:TEMP\$fileName"
    $aria2 = "$env:TEMP\aria2c.exe"
    
    # 2. Download Logic
    Write-Host "[ CLOUD ] Downloading $fileName..." -ForegroundColor Cyan
    if ($env:UseAria2 -eq "1" -and (Test-Path $aria2)) { 
        # Aria2 Download
        & $aria2 -x 8 -s 8 -j 1 --check-certificate=false -d "$env:TEMP" -o "$fileName" $url 
        if ($LASTEXITCODE -ne 0) { throw "Aria2 Failed" }
    } else { 
        # Standard Download
        Invoke-WebRequest -Uri $url -OutFile $dest 
    }
    
    # 3. Verify & Install Logic
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        
        # Auto-detect MSI vs EXE
        if ($dest -like "*.msi") {
            $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$dest`" $installArgs" -Wait -PassThru
        } else {
            $proc = Start-Process -FilePath $dest -ArgumentList $installArgs -Wait -PassThru
        }
        
        # 4. Check Exit Code & Cleanup
        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) { 
            Remove-Item $dest -Force
            Write-Host "[ SUCCESS ] Installation Complete." -ForegroundColor Green
            exit 0 
        } else { 
            throw "Installer Exit Code: $($proc.ExitCode)" 
        }
    } else { 
        throw "Download Failed (File not found)" 
    }

} catch { 
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1 
}
