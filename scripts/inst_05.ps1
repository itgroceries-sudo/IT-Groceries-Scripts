# ==============================================================================================
#  FILE: inst_05.ps1 (Notepad++)
# ==============================================================================================
$url = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.7.1/npp.8.7.1.Installer.x64.exe"
$fileName = "npp_setup.exe"
$installArgs = "/S"
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
