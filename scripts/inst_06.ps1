$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Downloading AnyDesk..." -ForegroundColor Cyan
    $url = "https://download.anydesk.com/AnyDesk.exe"
    $dest = "$env:TEMP\anydesk_setup.exe"
    
    Invoke-WebRequest -Uri $url -OutFile $dest
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        # AnyDesk Install Command
        Start-Process -FilePath $dest -ArgumentList "--install `"$env:ProgramFiles(x86)\AnyDesk`" --silent" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "Download failed." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
