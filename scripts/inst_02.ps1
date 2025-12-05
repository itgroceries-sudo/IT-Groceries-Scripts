# ==============================================================================================
#  FILE: inst_02.ps1 (Google Chrome - Enterprise Standalone)
# ==============================================================================================
$url = "https://dl.google.com/chrome/install/standalonesetup64.exe"
$fileName = "ChromeSetup.exe"
$installArgs = "/silent /install"
# -------------------- MASTER LOGIC START --------------------
$ErrorActionPreference = 'Stop'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
try {
    $dest = "$env:TEMP\$fileName"; $aria2 = "$env:TEMP\aria2c.exe"
    Write-Host "[ CLOUD ] Downloading $fileName..." -Fg Cyan
    if ($env:UseAria2 -eq "1" -and (Test-Path $aria2)) { 
        & $aria2 -x 8 -s 8 -j 1 --check-certificate=false -d "$env:TEMP" -o "$fileName" $url 
    } else { Invoke-WebRequest -Uri $url -OutFile $dest }
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -Fg Green
        if ($dest -like "*.msi") {
            $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$dest`" $installArgs" -Wait -PassThru
        } else {
            $proc = Start-Process -FilePath $dest -ArgumentList $installArgs -Wait -PassThru
        }
        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) { Remove-Item $dest -Force; exit 0 } else { throw "Exit Code: $($proc.ExitCode)" }
    } else { throw "Download Failed" }
} catch { Write-Host "[ ERROR ] $_" -Fg Red; exit 1 }
# -------------------- MASTER LOGIC END --------------------
