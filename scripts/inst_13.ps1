$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Checking Audacity Github..." -ForegroundColor Cyan
    $api = "https://api.github.com/repos/audacity/audacity/releases/latest"
    $json = Invoke-RestMethod -Uri $api
    $asset = $json.assets | Where-Object {$_.name -like "*64bit.exe"} | Select-Object -First 1
    
    if ($asset) {
        $dest = "$env:TEMP\audacity_setup.exe"
        Write-Host "Downloading $($asset.name)..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $dest
        
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath $dest -ArgumentList "/VERYSILENT" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "Asset not found." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
