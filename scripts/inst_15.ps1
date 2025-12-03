$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Checking LibreOffice..." -ForegroundColor Cyan
    $base = "https://download.documentfoundation.org/libreoffice/stable/"
    $web = Invoke-WebRequest -Uri $base -UseBasicParsing
    $latestVer = $web.Links.href | Where-Object {$_ -match '^\d+(\.\d+)+/$'} | Sort-Object {[version]($_ -replace '/','')} -Descending | Select-Object -First 1
    
    if (-not $latestVer) { throw "No version found." }
    
    $dlPage = $base + $latestVer + "win/x86_64/"
    $web2 = Invoke-WebRequest -Uri $dlPage -UseBasicParsing
    $msi = $web2.Links.href | Where-Object {$_ -match '\.msi$' -and $_ -notmatch 'help' -and $_ -notmatch 'sdk'} | Select-Object -First 1
    
    if (-not $msi) { throw "MSI not found." }
    
    $dlUrl = $dlPage + $msi
    $dest = "$env:TEMP\libre_setup.msi"
    
    Write-Host "Downloading $msi..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $dlUrl -OutFile $dest
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$dest`" /qn /norestart" -Wait
        Remove-Item $dest -Force
        exit 0
    }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
